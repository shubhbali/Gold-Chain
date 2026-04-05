import { ethers } from 'ethers'
import Head from 'next/head'
import { type CSSProperties, useEffect, useMemo, useState } from 'react'

import { NextPageWithLayout } from 'utils/page.types'

declare global {
  interface Window {
    ethereum?: any
  }
}

type TokenOption = {
  key: 'gilt' | 'gold' | 'dex'
  symbol: 'GILT' | 'GOLD' | 'DEX'
  name: string
  decimals: number
  address?: string
  native?: boolean
}

const CHAIN_ID = 714
const CHAIN_ID_HEX = '0x2ca'
const RPC_URL = process.env.NEXT_PUBLIC_GOLD_CHAIN_RPC || 'http://127.0.0.1:8545'
const EXPLORER_URL = process.env.NEXT_PUBLIC_GOLD_CHAIN_EXPLORER || 'http://localhost'
const ROUTER_ADDRESS = process.env.NEXT_PUBLIC_GOLD_CHAIN_ROUTER_ADDRESS || ''
const WGILT_ADDRESS = process.env.NEXT_PUBLIC_GOLD_CHAIN_WGILT_ADDRESS || ''
const GOLD_ADDRESS = process.env.NEXT_PUBLIC_GOLD_CHAIN_GOLD_ADDRESS || ''
const DEX_ADDRESS = process.env.NEXT_PUBLIC_GOLD_CHAIN_DEX_ADDRESS || ''

const TOKENS: TokenOption[] = [
  { key: 'gilt', symbol: 'GILT', name: 'Gold Chain GILT', decimals: 18, native: true },
  { key: 'gold', symbol: 'GOLD', name: 'Gold Chain GOLD', decimals: 18, address: GOLD_ADDRESS },
  { key: 'dex', symbol: 'DEX', name: 'Gold Chain DEX', decimals: 18, address: DEX_ADDRESS },
]

const routerAbi = [
  'function getAmountsOut(uint256 amountIn, address[] calldata path) view returns (uint256[] memory amounts)',
  'function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) payable returns (uint256[] memory amounts)',
  'function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) returns (uint256[] memory amounts)',
  'function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) returns (uint256[] memory amounts)',
]

const erc20Abi = [
  'function balanceOf(address account) view returns (uint256)',
  'function allowance(address owner, address spender) view returns (uint256)',
  'function approve(address spender, uint256 amount) returns (bool)',
]

const pageWrapStyle: CSSProperties = {
  minHeight: '100vh',
  background: '#f5f1e8',
  color: '#18110a',
  padding: '32px 20px',
  fontFamily: 'ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif',
}

const shellStyle: CSSProperties = {
  maxWidth: 960,
  margin: '0 auto',
  display: 'grid',
  gap: 24,
}

const cardStyle: CSSProperties = {
  background: '#fffaf0',
  border: '1px solid #d9c9ac',
  borderRadius: 20,
  padding: 24,
  boxShadow: '0 12px 32px rgba(56, 34, 8, 0.08)',
}

const labelStyle: CSSProperties = {
  display: 'block',
  fontSize: 14,
  fontWeight: 600,
  marginBottom: 8,
}

const inputStyle: CSSProperties = {
  width: '100%',
  padding: '14px 16px',
  borderRadius: 14,
  border: '1px solid #c9b693',
  fontSize: 16,
  background: '#ffffff',
  color: '#18110a',
}

const primaryButtonStyle: CSSProperties = {
  width: '100%',
  padding: '16px 18px',
  borderRadius: 16,
  border: 'none',
  background: '#b8860b',
  color: '#fff8e8',
  fontSize: 16,
  fontWeight: 700,
  cursor: 'pointer',
}

const secondaryButtonStyle: CSSProperties = {
  ...primaryButtonStyle,
  width: 'auto',
  background: '#fffaf0',
  color: '#6f4f0a',
  border: '1px solid #c9b693',
}

function shortAddress(value?: string) {
  if (!value) return ''
  return `${value.slice(0, 6)}...${value.slice(-4)}`
}

function tokenAddress(token: TokenOption) {
  return token.native ? WGILT_ADDRESS : token.address || ''
}

function formatAmount(value: ethers.BigNumber, decimals = 18, precision = 6) {
  const parsed = Number(ethers.utils.formatUnits(value, decimals))
  if (!Number.isFinite(parsed)) return '0'
  return parsed.toLocaleString(undefined, {
    minimumFractionDigits: 0,
    maximumFractionDigits: precision,
  })
}

function toHexChainId(chainId: number) {
  return `0x${chainId.toString(16)}`
}

async function resolveBestPath(
  router: ethers.Contract,
  inputToken: TokenOption,
  outputToken: TokenOption,
  amountIn: ethers.BigNumber,
) {
  const inputAddress = tokenAddress(inputToken)
  const outputAddress = tokenAddress(outputToken)

  const intermediates = Array.from(new Set([WGILT_ADDRESS, GOLD_ADDRESS, DEX_ADDRESS])).filter(
    (address) => address && address !== inputAddress && address !== outputAddress,
  )

  const candidatePaths = [[inputAddress, outputAddress], ...intermediates.map((mid) => [inputAddress, mid, outputAddress])]

  let best: { path: string[]; amounts: ethers.BigNumber[] } | null = null

  for (const path of candidatePaths) {
    try {
      const amounts = await router.getAmountsOut(amountIn, path)
      if (!best || amounts[amounts.length - 1].gt(best.amounts[best.amounts.length - 1])) {
        best = { path, amounts }
      }
    } catch {
      // no route for this path
    }
  }

  return best
}

const SwapPage: NextPageWithLayout = () => {
  const readProvider = useMemo(() => new ethers.providers.JsonRpcProvider(RPC_URL), [])
  const readRouter = useMemo(() => new ethers.Contract(ROUTER_ADDRESS, routerAbi, readProvider), [readProvider])

  const [browserProvider, setBrowserProvider] = useState<ethers.providers.Web3Provider | null>(null)
  const [account, setAccount] = useState('')
  const [chainId, setChainId] = useState<number | null>(null)
  const [inputKey, setInputKey] = useState<TokenOption['key']>('gilt')
  const [outputKey, setOutputKey] = useState<TokenOption['key']>('gold')
  const [amountIn, setAmountIn] = useState('1')
  const [quote, setQuote] = useState('')
  const [quotePath, setQuotePath] = useState<string[]>([])
  const [balances, setBalances] = useState<Record<string, string>>({})
  const [allowanceEnough, setAllowanceEnough] = useState(false)
  const [loadingQuote, setLoadingQuote] = useState(false)
  const [busy, setBusy] = useState(false)
  const [status, setStatus] = useState('Connect a wallet on Gold Chain roughnet to swap.')
  const [txHash, setTxHash] = useState('')

  const inputToken = TOKENS.find((token) => token.key === inputKey) || TOKENS[0]
  const outputToken = TOKENS.find((token) => token.key === outputKey) || TOKENS[1]

  const wrongNetwork = chainId !== null && chainId !== CHAIN_ID
  const amountInWei = useMemo(() => {
    try {
      if (!amountIn) return null
      return ethers.utils.parseUnits(amountIn, inputToken.decimals)
    } catch {
      return null
    }
  }, [amountIn, inputToken.decimals])

  useEffect(() => {
    if (!window.ethereum) return undefined

    const provider = new ethers.providers.Web3Provider(window.ethereum, 'any')
    setBrowserProvider(provider)

    const syncWallet = async () => {
      try {
        const accounts = await provider.listAccounts()
        const network = await provider.getNetwork()
        setChainId(network.chainId)
        setAccount(accounts[0] || '')
      } catch {
        setAccount('')
      }
    }

    syncWallet()

    const handleAccountsChanged = (accounts: string[]) => {
      setAccount(accounts[0] || '')
    }

    const handleChainChanged = (value: string) => {
      setChainId(Number(value))
    }

    window.ethereum.on?.('accountsChanged', handleAccountsChanged)
    window.ethereum.on?.('chainChanged', handleChainChanged)

    return () => {
      window.ethereum?.removeListener?.('accountsChanged', handleAccountsChanged)
      window.ethereum?.removeListener?.('chainChanged', handleChainChanged)
    }
  }, [])

  useEffect(() => {
    if (!account) {
      setBalances({})
      return
    }

    let cancelled = false

    const loadBalances = async () => {
      const nextBalances: Record<string, string> = {}

      for (const token of TOKENS) {
        if (token.native) {
          const balance = await readProvider.getBalance(account)
          nextBalances[token.key] = formatAmount(balance, token.decimals)
          continue
        }

        const contract = new ethers.Contract(token.address || '', erc20Abi, readProvider)
        const balance = await contract.balanceOf(account)
        nextBalances[token.key] = formatAmount(balance, token.decimals)
      }

      if (!cancelled) {
        setBalances(nextBalances)
      }
    }

    loadBalances().catch(() => {
      if (!cancelled) {
        setBalances({})
      }
    })

    return () => {
      cancelled = true
    }
  }, [account, readProvider, txHash])

  useEffect(() => {
    if (!account || inputToken.native || !amountInWei) {
      setAllowanceEnough(inputToken.native)
      return
    }

    const contract = new ethers.Contract(inputToken.address || '', erc20Abi, readProvider)

    contract
      .allowance(account, ROUTER_ADDRESS)
      .then((allowance: ethers.BigNumber) => setAllowanceEnough(allowance.gte(amountInWei)))
      .catch(() => setAllowanceEnough(false))
  }, [account, amountInWei, inputToken, readProvider, txHash])

  useEffect(() => {
    let cancelled = false

    const loadQuote = async () => {
      setQuote('')
      setQuotePath([])

      if (!ROUTER_ADDRESS || !WGILT_ADDRESS || !amountInWei || inputToken.key === outputToken.key) {
        return
      }

      setLoadingQuote(true)

      try {
        const best = await resolveBestPath(readRouter, inputToken, outputToken, amountInWei)

        if (!cancelled && best) {
          setQuote(formatAmount(best.amounts[best.amounts.length - 1], outputToken.decimals))
          setQuotePath(best.path)
          setStatus('Quote ready.')
        }

        if (!cancelled && !best) {
          setStatus(`No live route found for ${inputToken.symbol} -> ${outputToken.symbol}.`)
        }
      } catch (error: any) {
        if (!cancelled) {
          setStatus(error?.message || 'Failed to fetch quote.')
        }
      } finally {
        if (!cancelled) {
          setLoadingQuote(false)
        }
      }
    }

    loadQuote()

    return () => {
      cancelled = true
    }
  }, [amountInWei, inputToken, outputToken, readRouter])

  const connectWallet = async () => {
    if (!window.ethereum) {
      setStatus('No injected wallet found in this browser.')
      return
    }

    try {
      setBusy(true)
      const provider = browserProvider || new ethers.providers.Web3Provider(window.ethereum, 'any')
      await provider.send('eth_requestAccounts', [])
      const signer = provider.getSigner()
      const address = await signer.getAddress()
      const network = await provider.getNetwork()
      setBrowserProvider(provider)
      setAccount(address)
      setChainId(network.chainId)
      setStatus('Wallet connected.')
    } catch (error: any) {
      setStatus(error?.message || 'Wallet connection failed.')
    } finally {
      setBusy(false)
    }
  }

  const switchToGoldChain = async () => {
    if (!window.ethereum) {
      setStatus('No injected wallet found in this browser.')
      return
    }

    try {
      setBusy(true)
      await window.ethereum.request({
        method: 'wallet_switchEthereumChain',
        params: [{ chainId: CHAIN_ID_HEX }],
      })
      setChainId(CHAIN_ID)
      setStatus('Switched to Gold Chain roughnet.')
    } catch (error: any) {
      if (error?.code === 4902) {
        await window.ethereum.request({
          method: 'wallet_addEthereumChain',
          params: [
            {
              chainId: CHAIN_ID_HEX,
              chainName: 'Gold Chain Roughnet',
              nativeCurrency: { name: 'GILT', symbol: 'GILT', decimals: 18 },
              rpcUrls: [RPC_URL],
              blockExplorerUrls: [EXPLORER_URL],
            },
          ],
        })
        setChainId(CHAIN_ID)
        setStatus('Gold Chain roughnet added to wallet.')
      } else {
        setStatus(error?.message || 'Network switch failed.')
      }
    } finally {
      setBusy(false)
    }
  }

  const approveInput = async () => {
    if (!browserProvider || !account || inputToken.native || !inputToken.address) {
      return
    }

    try {
      setBusy(true)
      const signer = browserProvider.getSigner()
      const contract = new ethers.Contract(inputToken.address, erc20Abi, signer)
      const tx = await contract.approve(ROUTER_ADDRESS, ethers.constants.MaxUint256)
      setStatus(`Approval submitted: ${tx.hash}`)
      setTxHash(tx.hash)
      await tx.wait()
      setAllowanceEnough(true)
      setStatus(`Approval confirmed: ${tx.hash}`)
    } catch (error: any) {
      setStatus(error?.message || 'Approval failed.')
    } finally {
      setBusy(false)
    }
  }

  const submitSwap = async () => {
    if (!browserProvider || !account || !amountInWei || quotePath.length < 2) {
      return
    }

    try {
      setBusy(true)
      const signer = browserProvider.getSigner()
      const router = new ethers.Contract(ROUTER_ADDRESS, routerAbi, signer)
      const quoteResult = await resolveBestPath(router, inputToken, outputToken, amountInWei)

      if (!quoteResult) {
        throw new Error(`No live route found for ${inputToken.symbol} -> ${outputToken.symbol}.`)
      }

      const amountOut = quoteResult.amounts[quoteResult.amounts.length - 1]
      const amountOutMin = amountOut.mul(99).div(100)
      const deadline = Math.floor(Date.now() / 1000) + 60 * 20

      let tx
      if (inputToken.native) {
        tx = await router.swapExactETHForTokens(amountOutMin, quoteResult.path, account, deadline, {
          value: amountInWei,
        })
      } else if (outputToken.native) {
        tx = await router.swapExactTokensForETH(amountInWei, amountOutMin, quoteResult.path, account, deadline)
      } else {
        tx = await router.swapExactTokensForTokens(amountInWei, amountOutMin, quoteResult.path, account, deadline)
      }

      setTxHash(tx.hash)
      setStatus(`Swap submitted: ${tx.hash}`)
      await tx.wait()
      setStatus(`Swap confirmed: ${tx.hash}`)
      setAmountIn('')
    } catch (error: any) {
      setStatus(error?.message || 'Swap failed.')
    } finally {
      setBusy(false)
    }
  }

  const primaryAction = (() => {
    if (!account) {
      return { label: busy ? 'Connecting...' : 'Connect Wallet', onClick: connectWallet, disabled: busy }
    }
    if (wrongNetwork) {
      return { label: busy ? 'Switching...' : 'Switch To Gold Chain', onClick: switchToGoldChain, disabled: busy }
    }
    if (!amountInWei || !quotePath.length) {
      return { label: loadingQuote ? 'Quoting...' : 'No Route Ready', onClick: () => {}, disabled: true }
    }
    if (!allowanceEnough) {
      return { label: busy ? 'Approving...' : `Approve ${inputToken.symbol}`, onClick: approveInput, disabled: busy }
    }
    return { label: busy ? 'Swapping...' : 'Swap', onClick: submitSwap, disabled: busy }
  })()

  return (
    <>
      <Head>
        <title>Gold Chain Swap</title>
      </Head>
      <main style={pageWrapStyle}>
        <div style={shellStyle}>
          <section style={{ ...cardStyle, display: 'grid', gap: 12 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap' }}>
              <div>
                <div style={{ fontSize: 13, letterSpacing: 1.2, textTransform: 'uppercase', color: '#8a6d3b' }}>
                  Gold Chain DEX
                </div>
                <h1 style={{ fontSize: 36, lineHeight: 1.05, margin: '8px 0 0' }}>Swap</h1>
              </div>
              <div style={{ display: 'grid', gap: 8, justifyItems: 'end' }}>
                <button
                  type="button"
                  onClick={account ? switchToGoldChain : connectWallet}
                  disabled={busy}
                  style={secondaryButtonStyle}
                >
                  {account ? shortAddress(account) : 'Connect Wallet'}
                </button>
                <div style={{ fontSize: 14, color: wrongNetwork ? '#b42318' : '#5e4a21' }}>
                  {chainId === CHAIN_ID ? 'Gold Chain roughnet' : chainId ? `Wrong chain: ${chainId}` : 'Wallet not connected'}
                </div>
              </div>
            </div>
            <div style={{ fontSize: 15, color: '#5e4a21' }}>
              Live markets right now: <strong>GILT</strong>, <strong>GOLD</strong>, and <strong>DEX</strong>.
            </div>
          </section>

          <section style={{ ...cardStyle, display: 'grid', gap: 18 }}>
            <div style={{ display: 'grid', gap: 18, gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))' }}>
              <div>
                <label style={labelStyle}>From</label>
                <select
                  value={inputKey}
                  onChange={(event) => setInputKey(event.target.value as TokenOption['key'])}
                  style={inputStyle}
                >
                  {TOKENS.filter((token) => token.key !== outputKey).map((token) => (
                    <option key={token.key} value={token.key}>
                      {token.symbol}
                    </option>
                  ))}
                </select>
                <div style={{ fontSize: 13, marginTop: 8, color: '#6f5b34' }}>
                  Balance: {balances[inputKey] || '0'} {inputToken.symbol}
                </div>
              </div>

              <div>
                <label style={labelStyle}>To</label>
                <select
                  value={outputKey}
                  onChange={(event) => setOutputKey(event.target.value as TokenOption['key'])}
                  style={inputStyle}
                >
                  {TOKENS.filter((token) => token.key !== inputKey).map((token) => (
                    <option key={token.key} value={token.key}>
                      {token.symbol}
                    </option>
                  ))}
                </select>
                <div style={{ fontSize: 13, marginTop: 8, color: '#6f5b34' }}>
                  Balance: {balances[outputKey] || '0'} {outputToken.symbol}
                </div>
              </div>
            </div>

            <div>
              <label style={labelStyle}>Amount</label>
              <input
                value={amountIn}
                onChange={(event) => setAmountIn(event.target.value)}
                inputMode="decimal"
                placeholder="0.0"
                style={inputStyle}
              />
            </div>

            <div style={{ display: 'grid', gap: 10, padding: 16, borderRadius: 16, background: '#f5ebd8' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap' }}>
                <span style={{ color: '#6f5b34' }}>Estimated output</span>
                <strong>
                  {quote || '0'} {outputToken.symbol}
                </strong>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap' }}>
                <span style={{ color: '#6f5b34' }}>Route</span>
                <span>
                  {quotePath.length
                    ? quotePath
                        .map((address) => TOKENS.find((token) => tokenAddress(token).toLowerCase() === address.toLowerCase())?.symbol || 'GILT')
                        .join(' -> ')
                    : 'No route yet'}
                </span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', gap: 12, flexWrap: 'wrap' }}>
                <span style={{ color: '#6f5b34' }}>Slippage</span>
                <span>1%</span>
              </div>
            </div>

            <button type="button" onClick={primaryAction.onClick} disabled={primaryAction.disabled} style={primaryButtonStyle}>
              {primaryAction.label}
            </button>
          </section>

          <section style={{ ...cardStyle, display: 'grid', gap: 10 }}>
            <strong>Status</strong>
            <div style={{ color: '#5e4a21', lineHeight: 1.5 }}>{status}</div>
            {txHash && (
              <a
                href={`${EXPLORER_URL.replace(/\/$/, '')}/tx/${txHash}`}
                target="_blank"
                rel="noreferrer"
                style={{ color: '#8a5b00', fontWeight: 700 }}
              >
                View transaction: {shortAddress(txHash)}
              </a>
            )}
          </section>
        </div>
      </main>
    </>
  )
}

SwapPage.pure = true

export default SwapPage
