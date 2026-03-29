import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { ethers } from 'ethers';
import Web3 from 'web3';
import { bufferToHex, rlp } from 'ethereumjs-util';
import { getBlockHeader } from '../test/helpers/blocks.js';
import { getReceiptBytes, getReceiptProof } from '../test/helpers/proofs.js';
import MerkleTree from '../test/helpers/merkle-tree.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const REPO_ROOT = path.resolve(__dirname, '../../..');
export const ADDRESS_BOOK_PATH = path.join(REPO_ROOT, '.live-roughnet', 'live-bridge-addresses.json');
export const DEFAULT_SEPOLIA_RPC = 'https://sepolia.drpc.org';

export const ROOT_ETHER_ADDRESS = '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE';
export const STATE_RECEIVER_ADDRESS = '0x0000000000000000000000000000000000003001';
export const NATIVE_GILT_BRIDGE_ADDRESS = '0x0000000000000000000000000000000000003002';
export const STAKE_HUB_ADDRESS = '0x0000000000000000000000000000000000002002';
export const GOV_HUB_ADDRESS = '0x0000000000000000000000000000000000001007';
export const GOVERNOR_ADDRESS = '0x0000000000000000000000000000000000002004';
export const GOV_TOKEN_ADDRESS = '0x0000000000000000000000000000000000002005';
export const GOLD_CHAIN_ID = 714;
export const ZERO_ADDRESS = ethers.ZeroAddress;
export const CHECKPOINT_ACCOUNT_HASH = ethers.keccak256(ethers.toUtf8Bytes('gold-chain-roughnet'));

export function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

export function writeJson(filePath, value) {
  fs.mkdirSync(path.dirname(filePath), { recursive: true });
  fs.writeFileSync(filePath, `${JSON.stringify(value, null, 2)}\n`);
}

export function readArtifact(relativePath) {
  return readJson(path.join(REPO_ROOT, relativePath));
}

export function bytecodeOf(artifact) {
  const bytecode = artifact?.bytecode?.object ?? artifact?.bytecode;
  if (!bytecode) {
    throw new Error('artifact is missing bytecode');
  }
  return bytecode.startsWith('0x') ? bytecode : `0x${bytecode}`;
}

function isReceiptIndexingError(error) {
  const messages = [
    error?.message,
    error?.shortMessage,
    error?.error?.message,
    error?.error?.data,
  ].filter(Boolean);
  return messages.some((message) => String(message).includes('transaction indexing is in progress'));
}

function rpcUrlForProvider(provider) {
  return provider?._getConnection?.().url || provider?.connection?.url || null;
}

async function receiptProvidersFor(txResponse) {
  const providers = [txResponse.provider].filter(Boolean);
  const network = await txResponse.provider.getNetwork();
  if (network.chainId !== 11155111n) {
    return providers;
  }

  const fallbackUrls = [
    ...(process.env.SEPOLIA_RECEIPT_RPC_URLS || '').split(',').map((value) => value.trim()).filter(Boolean),
    'https://sepolia.drpc.org',
    'https://ethereum-sepolia.publicnode.com',
    'https://ethereum-sepolia-rpc.publicnode.com',
  ];

  const seen = new Set(providers.map((provider) => rpcUrlForProvider(provider)).filter(Boolean));
  for (const url of fallbackUrls) {
    if (seen.has(url)) {
      continue;
    }
    providers.push(new ethers.JsonRpcProvider(url));
    seen.add(url);
  }

  return providers;
}

export async function waitForMined(txResponse, confirmations = 1, timeoutMs = 300000, pollMs = 3000) {
  if (!txResponse?.hash || !txResponse?.provider) {
    throw new Error('missing transaction response/provider');
  }

  const startedAt = Date.now();
  const providers = await receiptProvidersFor(txResponse);
  let loggedWaiting = false;
  while (Date.now() - startedAt < timeoutMs) {
    if (!loggedWaiting && Date.now() - startedAt >= 30000) {
      console.log(`Still waiting for tx ${txResponse.hash}`);
      loggedWaiting = true;
    }
    let sawReceipt = false;
    for (const provider of providers) {
      try {
        const receipt = await provider.getTransactionReceipt(txResponse.hash);
        if (!receipt) {
          continue;
        }

        sawReceipt = true;
        if (confirmations > 1) {
          const latestBlock = await provider.getBlockNumber();
          if (latestBlock < receipt.blockNumber + confirmations - 1) {
            continue;
          }
        }

        if (receipt.status === 0 || receipt.status === 0n) {
          throw new Error(`transaction ${txResponse.hash} reverted`);
        }

        return receipt;
      } catch (_) {
        continue;
      }
    }
    if (!sawReceipt) {
      await sleep(pollMs);
      continue;
    }
    await sleep(pollMs);
  }

  throw new Error(`Timed out waiting for transaction ${txResponse.hash}`);
}

export async function deployContract(signer, artifact, args = []) {
  const factory = new ethers.ContractFactory(artifact.abi, bytecodeOf(artifact), signer);
  const contract = await factory.deploy(...args);
  await waitForMined(contract.deploymentTransaction());
  return contract;
}

export function contractAt(address, artifact, runner) {
  return new ethers.Contract(address, artifact.abi, runner);
}

export function saveAddressBook(data) {
  writeJson(ADDRESS_BOOK_PATH, data);
}

export function loadAddressBook() {
  return readJson(ADDRESS_BOOK_PATH);
}

export async function waitForCondition(fn, label, timeoutMs = 900000, intervalMs = 5000) {
  const startedAt = Date.now();
  while (Date.now() - startedAt < timeoutMs) {
    const value = await fn();
    if (value) {
      return value;
    }
    await sleep(intervalMs);
  }
  throw new Error(`Timed out waiting for ${label}`);
}

export function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

export function publicKeyBytes(privateKey) {
  const uncompressed = ethers.SigningKey.computePublicKey(privateKey, false);
  return `0x${uncompressed.slice(4)}`;
}

export function role(name) {
  return ethers.keccak256(ethers.toUtf8Bytes(name));
}

export function hexAddressBytes(address) {
  return ethers.getBytes(address);
}

export function hexStringBytes(value) {
  return ethers.toUtf8Bytes(value);
}

export function checkpointSignature(privateKey, data) {
  const digest = ethers.keccak256(ethers.concat(['0x01', data]));
  const signature = new ethers.SigningKey(privateKey).sign(digest);
  return [[BigInt(signature.r), BigInt(signature.s), BigInt(signature.v)]];
}

export function buildExitPayload(headerNumber, checkpointData, receiptLogIndex = 0) {
  return bufferToHex(
    rlp.encode([
      headerNumber,
      bufferToHex(Buffer.concat(checkpointData.blockProof)),
      checkpointData.blockNumber,
      checkpointData.blockTime,
      bufferToHex(checkpointData.txRoot),
      bufferToHex(checkpointData.receiptRoot),
      bufferToHex(checkpointData.receipt),
      bufferToHex(rlp.encode(checkpointData.receiptParentNodes)),
      bufferToHex(checkpointData.path),
      receiptLogIndex,
    ]),
  );
}

export async function buildCheckpointData(web3Child, txHash, offsetBlock, startActualBlock) {
  const tx = await web3Child.eth.getTransaction(txHash);
  const receipt = await web3Child.eth.getTransactionReceipt(txHash);
  const block = await web3Child.eth.getBlock(receipt.blockHash, true);
  const endActualBlock = Number(block.number);

  if (startActualBlock > endActualBlock) {
    throw new Error(`invalid checkpoint window ${startActualBlock} > ${endActualBlock}`);
  }

  const headers = [];
  for (let actualBlock = startActualBlock; actualBlock <= endActualBlock; actualBlock += 1) {
    const rawBlock = await web3Child.eth.getBlock(actualBlock);
    headers.push(
      await getBlockHeader({
        ...rawBlock,
        number: actualBlock - offsetBlock,
      }),
    );
  }

  const normalizedBlock = {
    ...block,
    number: endActualBlock - offsetBlock,
  };

  const tree = new MerkleTree(headers);
  const blockHeader = await getBlockHeader(normalizedBlock);
  const receiptProof = await getReceiptProof(receipt, block, web3Child);

  return {
    actualStartBlock: startActualBlock,
    actualEndBlock: endActualBlock,
    startBlock: startActualBlock - offsetBlock,
    endBlock: endActualBlock - offsetBlock,
    blockNumber: endActualBlock - offsetBlock,
    blockTime: Number(block.timestamp),
    headerRoot: bufferToHex(tree.getRoot()),
    blockProof: tree.getProof(blockHeader),
    txRoot: Buffer.from(block.transactionsRoot.slice(2), 'hex'),
    receiptRoot: Buffer.from(block.receiptsRoot.slice(2), 'hex'),
    receipt: getReceiptBytes(receipt),
    receiptParentNodes: receiptProof.parentNodes,
    path: Buffer.concat([Buffer.from('00', 'hex'), receiptProof.path]),
  };
}

async function checkpointWindowRoot(provider, actualStart, actualEnd, logicalStart) {
  const offset = actualStart - logicalStart;
  const headers = [];

  for (let actual = actualStart; actual <= actualEnd; actual += 1) {
    const rawBlock = await provider.send('eth_getBlockByNumber', [ethers.toQuantity(actual), false]);
    const normalized = normalizeBlockShape(rawBlock);
    headers.push(
      await getBlockHeader({
        ...normalized,
        number: actual - offset,
      }),
    );
  }

  const tree = new MerkleTree(headers);
  return ethers.hexlify(tree.getRoot()).toLowerCase();
}

export async function findCheckpointCursor(rootChain, provider, searchBack = 2000) {
  const currentHeaderBlock = await rootChain.currentHeaderBlock();
  const headerBlock = await rootChain.headerBlocks(currentHeaderBlock);
  const headerRoot = String(headerBlock[0]).toLowerCase();
  const logicalStart = Number(headerBlock[1]);
  const logicalEnd = Number(headerBlock[2]);

  if (headerRoot === ethers.ZeroHash.toLowerCase() && logicalStart === 0 && logicalEnd === 0) {
    return null;
  }

  const span = logicalEnd - logicalStart + 1;
  const actualLatest = await provider.getBlockNumber();
  const minActualEnd = Math.max(span - 1, actualLatest - searchBack);

  for (let actualEnd = actualLatest; actualEnd >= minActualEnd; actualEnd -= 1) {
    const actualStart = actualEnd - span + 1;
    const computedRoot = await checkpointWindowRoot(provider, actualStart, actualEnd, logicalStart);
    if (computedRoot === headerRoot) {
      return {
        currentHeaderBlock: currentHeaderBlock.toString(),
        offsetBlock: actualStart - logicalStart,
        lastActualEndBlock: actualEnd,
        logicalStart,
        logicalEnd,
      };
    }
  }

  throw new Error(
    `Unable to align root checkpoint ${currentHeaderBlock.toString()} (${logicalStart}-${logicalEnd}) with child chain`,
  );
}

export function web3For(url) {
  return new Web3(url);
}

export function rpcProviderFor(url) {
  return new ethers.JsonRpcProvider(url, undefined, { batchMaxCount: 1 });
}

function normalizeReceiptShape(receipt) {
  return {
    ...receipt,
    blockNumber: receipt?.blockNumber != null ? Number(BigInt(receipt.blockNumber)) : receipt?.blockNumber,
    transactionIndex:
      receipt?.transactionIndex != null ? Number(BigInt(receipt.transactionIndex)) : receipt?.transactionIndex,
  };
}

function normalizeBlockShape(block) {
  return {
    ...block,
    number: block?.number != null ? Number(BigInt(block.number)) : block?.number,
    timestamp: block?.timestamp != null ? Number(BigInt(block.timestamp)) : block?.timestamp,
    transactions: Array.isArray(block?.transactions)
      ? block.transactions.map((tx) =>
          typeof tx === 'string'
            ? tx
            : {
                ...tx,
                transactionIndex:
                  tx?.transactionIndex != null ? Number(BigInt(tx.transactionIndex)) : tx?.transactionIndex,
              },
        )
      : block?.transactions,
  };
}

export function childRpcFor(providerOrUrl) {
  const provider = typeof providerOrUrl === 'string' ? rpcProviderFor(providerOrUrl) : providerOrUrl;

  return {
    eth: {
      async getTransaction(hash) {
        const tx = await provider.send('eth_getTransactionByHash', [hash]);
        return tx?.transactionIndex != null
          ? { ...tx, transactionIndex: Number(BigInt(tx.transactionIndex)) }
          : tx;
      },
      async getTransactionReceipt(hash) {
        return normalizeReceiptShape(await provider.send('eth_getTransactionReceipt', [hash]));
      },
      async getBlock(ref, full = false) {
        const isHash = typeof ref === 'string' && ref.startsWith('0x') && ref.length === 66;
        const method = isHash ? 'eth_getBlockByHash' : 'eth_getBlockByNumber';
        const arg = isHash ? ref : ethers.toQuantity(ref);
        return normalizeBlockShape(await provider.send(method, [arg, full]));
      },
    },
  };
}
