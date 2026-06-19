export const ROUTES = Object.freeze({
  PAXG: 1,
  XAUT: 2,
});

export const GOLD_DECIMALS = 18;

export const CANONICAL_ROUTES = Object.freeze({
  [ROUTES.PAXG]: Object.freeze({
    routeId: ROUTES.PAXG,
    symbol: 'PAXG',
    canonicalMainnetToken: '0x45804880De22913dAFE09f4980848ECE6EcbAf78',
    rootDecimals: 18,
    goldDecimals: GOLD_DECIMALS,
    scalingExponent: 0,
  }),
  [ROUTES.XAUT]: Object.freeze({
    routeId: ROUTES.XAUT,
    symbol: 'XAUT',
    canonicalMainnetToken: '0x68749665FF8D2d112Fa859AA293F07A622782F38',
    rootDecimals: 6,
    goldDecimals: GOLD_DECIMALS,
    scalingExponent: 12,
  }),
});

export const FLOW = Object.freeze({
  ROOT_LOCK_TO_CHILD_MINT: 'root-lock-to-child-mint',
  CHILD_BURN_TO_ROOT_RELEASE: 'child-burn-to-root-release',
});

export function normalizeRouteId(routeId) {
  const normalized = Number(routeId);
  if (!Number.isSafeInteger(normalized) || normalized <= 0) {
    throw new Error(`invalid routeId: ${routeId}`);
  }
  return normalized;
}

export function canonicalRouteSpec(routeId) {
  const normalized = normalizeRouteId(routeId);
  const spec = CANONICAL_ROUTES[normalized];
  if (!spec) throw new Error(`unsupported canonical routeId: ${routeId}`);
  return spec;
}

function scaleFactor(spec) {
  const exponent = spec.goldDecimals - spec.rootDecimals;
  if (!Number.isSafeInteger(exponent) || exponent < 0) {
    throw new Error(`invalid scaling for route ${spec.routeId}: rootDecimals ${spec.rootDecimals}, goldDecimals ${spec.goldDecimals}`);
  }
  return 10n ** BigInt(exponent);
}

export function rootAmountToGoldAmount(routeId, rootAmount) {
  if (typeof rootAmount !== 'bigint' || rootAmount < 0n) throw new Error('rootAmount must be a non-negative bigint');
  return rootAmount * scaleFactor(canonicalRouteSpec(routeId));
}

export function goldAmountToRootAmount(routeId, goldAmount) {
  if (typeof goldAmount !== 'bigint' || goldAmount < 0n) throw new Error('goldAmount must be a non-negative bigint');
  const factor = scaleFactor(canonicalRouteSpec(routeId));
  if (goldAmount % factor !== 0n) throw new Error(`GOLD amount ${goldAmount} is not redeemable exactly on route ${routeId}`);
  return goldAmount / factor;
}

export const EVENT_TOPICS = Object.freeze({
  DEPOSITED: '0x614cd53614cbca0a11d120abc455cd6a3ce52b864035eb075598aa8eaedf2926',
  WITHDRAWAL_INITIATED: '0xdf75afe746a835b4c48a0c4d91c13b28a6eb75a2672745834e751fe3e171c9b4',
});

export function eventKey(direction, eventId) {
  if (!direction || !eventId) throw new Error('direction and eventId are required');
  return `${direction}:${String(eventId).toLowerCase()}`;
}
