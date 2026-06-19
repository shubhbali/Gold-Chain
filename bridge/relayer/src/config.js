import { canonicalRouteSpec, normalizeRouteId } from './constants.js';

function isObject(value) {
  return value !== null && typeof value === 'object' && !Array.isArray(value);
}

function isAddressLike(value) {
  return typeof value === 'string' && /^0x[a-fA-F0-9]{40}$/.test(value);
}

function assertFinalityPolicy(name, policy, environment) {
  if (!isObject(policy)) throw new Error(`${name}.finality is required`);
  const minConfirmations = Number(policy.minConfirmations);
  if (!Number.isSafeInteger(minConfirmations) || minConfirmations <= 0) {
    throw new Error(`${name}.finality.minConfirmations must be a positive integer`);
  }
  if (policy.requireSafeTag !== undefined && typeof policy.requireSafeTag !== 'boolean') {
    throw new Error(`${name}.finality.requireSafeTag must be boolean when set`);
  }
  if (policy.requireFinalizedTag !== undefined && typeof policy.requireFinalizedTag !== 'boolean') {
    throw new Error(`${name}.finality.requireFinalizedTag must be boolean when set`);
  }
  if (environment === 'production' && minConfirmations < 12) {
    throw new Error(`production ${name} finality.minConfirmations must be >= 12`);
  }
  if (environment === 'production' && policy.requireSafeTag !== true && policy.requireFinalizedTag !== true) {
    throw new Error(`production ${name} finality must require safe or finalized tag`);
  }
}

function assertChainConfig(name, chain, addressField, environment) {
  if (!isObject(chain)) throw new Error(`${name} config is required`);
  if (typeof chain.rpcUrl !== 'string' || chain.rpcUrl.length === 0) throw new Error(`${name}.rpcUrl is required`);
  if (!isAddressLike(chain[addressField])) throw new Error(`${name}.${addressField} must be an EVM address`);
  const chainId = Number(chain.chainId);
  if (!Number.isSafeInteger(chainId) || chainId <= 0) throw new Error(`${name}.chainId must be a positive integer`);
  if (chain.startBlock !== undefined) {
    const startBlock = Number(chain.startBlock);
    if (!Number.isSafeInteger(startBlock) || startBlock < 0) throw new Error(`${name}.startBlock must be >= 0`);
  }
  assertFinalityPolicy(name, chain.finality, environment);
}

function assertRoutes(config) {
  if (!isObject(config.routes)) throw new Error('routes are required');
  for (const required of ['1', '2']) {
    if (!isObject(config.routes[required])) throw new Error(`route ${required} is required`);
  }
  for (const [routeId, route] of Object.entries(config.routes)) {
    const id = normalizeRouteId(routeId);
    const canonical = canonicalRouteSpec(id);
    if (route.symbol !== canonical.symbol) throw new Error(`route ${routeId} symbol must be ${canonical.symbol}`);
    if (!isAddressLike(route.rootToken)) throw new Error(`route ${routeId}.rootToken must be an EVM address`);
    if (route.enabled !== true) throw new Error(`route ${routeId} must be explicitly enabled`);
    if (route.mockOnly === true && config.environment === 'production') {
      throw new Error(`route ${routeId} is mockOnly and cannot be used in production`);
    }
    if (!isObject(route.scaling)) throw new Error(`route ${routeId}.scaling is required`);
    if (Number(route.scaling.rootDecimals) !== canonical.rootDecimals) {
      throw new Error(`route ${routeId}.scaling.rootDecimals must be ${canonical.rootDecimals}`);
    }
    if (Number(route.scaling.goldDecimals) !== canonical.goldDecimals) {
      throw new Error(`route ${routeId}.scaling.goldDecimals must be ${canonical.goldDecimals}`);
    }
    if (Number(route.scaling.scalingExponent) !== canonical.scalingExponent) {
      throw new Error(`route ${routeId}.scaling.scalingExponent must be ${canonical.scalingExponent}`);
    }
  }
}

function assertSignerPolicy(config) {
  const policy = config.relayer.signerSet;
  if (policy === undefined) {
    if (config.environment === 'production') throw new Error('production relayer.signerSet is required');
    return;
  }
  if (!isObject(policy)) throw new Error('relayer.signerSet must be an object');
  const threshold = Number(policy.threshold);
  if (!Number.isSafeInteger(threshold) || threshold <= 0) throw new Error('relayer.signerSet.threshold must be a positive integer');
  if (!Array.isArray(policy.signers) || policy.signers.length === 0) throw new Error('relayer.signerSet.signers are required');
  for (const signer of policy.signers) {
    if (!isAddressLike(signer)) throw new Error(`relayer.signerSet signer ${signer} must be an EVM address`);
  }
  const uniqueSigners = new Set(policy.signers.map((signer) => signer.toLowerCase()));
  if (uniqueSigners.size !== policy.signers.length) throw new Error('relayer.signerSet.signers must be unique');
  if (threshold > uniqueSigners.size) throw new Error('relayer.signerSet.threshold cannot exceed signer count');
  if (threshold === 1 && uniqueSigners.size === 1) throw new Error('relayer.signerSet cannot be 1-of-1');
  if (config.environment === 'production' && threshold < 2) throw new Error('production relayer.signerSet.threshold must be at least 2');
  if (config.relayer.submitterAddress !== undefined) {
    if (!isAddressLike(config.relayer.submitterAddress)) throw new Error('relayer.submitterAddress must be an EVM address');
    if (uniqueSigners.has(config.relayer.submitterAddress.toLowerCase())) {
      throw new Error('relayer submitter address must not also be a bridge signer');
    }
  }
}

export function validateRelayerConfig(config) {
  if (!isObject(config)) throw new Error('config object is required');
  if (!['local', 'testnet', 'production'].includes(config.environment)) {
    throw new Error('environment must be local, testnet, or production');
  }
  assertChainConfig('ethereum', config.ethereum, 'rootCustodyAddress', config.environment);
  assertChainConfig('goldChain', config.goldChain, 'childBridgeAddress', config.environment);
  assertRoutes(config);
  if (!isObject(config.relayer)) throw new Error('relayer config is required');
  if (typeof config.relayer.keyPath !== 'string' || config.relayer.keyPath.length === 0) {
    throw new Error('relayer.keyPath is required');
  }
  if (config.relayer.signerSetVersion !== undefined) {
    const signerSetVersion = Number(config.relayer.signerSetVersion);
    if (!Number.isSafeInteger(signerSetVersion) || signerSetVersion <= 0) throw new Error('relayer.signerSetVersion must be a positive integer');
  }
  if (config.relayer.rescanOverlapBlocks !== undefined) {
    const rescanOverlapBlocks = Number(config.relayer.rescanOverlapBlocks);
    if (!Number.isSafeInteger(rescanOverlapBlocks) || rescanOverlapBlocks < 0) throw new Error('relayer.rescanOverlapBlocks must be >= 0');
  }
  assertSignerPolicy(config);
  return Object.freeze({
    ...config,
    ethereum: Object.freeze({ ...config.ethereum, chainId: Number(config.ethereum.chainId), startBlock: Number(config.ethereum.startBlock ?? 0) }),
    goldChain: Object.freeze({ ...config.goldChain, chainId: Number(config.goldChain.chainId), startBlock: Number(config.goldChain.startBlock ?? 0) }),
    relayer: Object.freeze({ ...config.relayer, signerSetVersion: Number(config.relayer.signerSetVersion ?? 1), rescanOverlapBlocks: Number(config.relayer.rescanOverlapBlocks ?? 0) }),
  });
}

async function defaultRpc(rpcUrl, method, params = []) {
  const response = await fetch(rpcUrl, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ jsonrpc: '2.0', id: 1, method, params }),
  });
  if (!response.ok) throw new Error(`${method} HTTP ${response.status}`);
  const body = await response.json();
  if (body.error) throw new Error(`${method} RPC error ${body.error.message ?? JSON.stringify(body.error)}`);
  return body.result;
}

async function assertCodeAt(rpcFn, chainName, rpcUrl, address, fieldName) {
  const code = await rpcFn(rpcUrl, 'eth_getCode', [address, 'latest']);
  if (typeof code !== 'string' || code === '0x' || code === '0x0') {
    throw new Error(`${chainName}.${fieldName} has zero code at ${address}`);
  }
}

export async function assertBridgeContractsHaveCode(config, { rpc = defaultRpc } = {}) {
  const normalized = validateRelayerConfig(config);
  await assertCodeAt(rpc, 'ethereum', normalized.ethereum.rpcUrl, normalized.ethereum.rootCustodyAddress, 'rootCustodyAddress');
  await assertCodeAt(rpc, 'goldChain', normalized.goldChain.rpcUrl, normalized.goldChain.childBridgeAddress, 'childBridgeAddress');
  return true;
}
