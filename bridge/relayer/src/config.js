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
    const id = Number(routeId);
    if (!Number.isSafeInteger(id) || id <= 0) throw new Error(`invalid route id ${routeId}`);
    if (!['PAXG', 'XAUT'].includes(route.symbol)) throw new Error(`unsupported route ${routeId} symbol ${route.symbol}`);
    if (!isAddressLike(route.rootToken)) throw new Error(`route ${routeId}.rootToken must be an EVM address`);
    if (route.enabled !== true) throw new Error(`route ${routeId} must be explicitly enabled`);
    if (route.mockOnly === true && config.environment === 'production') {
      throw new Error(`route ${routeId} is mockOnly and cannot be used in production`);
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
  return Object.freeze({
    ...config,
    ethereum: Object.freeze({ ...config.ethereum, chainId: Number(config.ethereum.chainId), startBlock: Number(config.ethereum.startBlock ?? 0) }),
    goldChain: Object.freeze({ ...config.goldChain, chainId: Number(config.goldChain.chainId), startBlock: Number(config.goldChain.startBlock ?? 0) }),
    relayer: Object.freeze({ ...config.relayer, signerSetVersion: Number(config.relayer.signerSetVersion ?? 1), rescanOverlapBlocks: Number(config.relayer.rescanOverlapBlocks ?? 0) }),
  });
}
