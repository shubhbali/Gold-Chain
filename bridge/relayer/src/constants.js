export const ROUTES = Object.freeze({
  PAXG: 1,
  XAUT: 2,
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

export const EVENT_TOPICS = Object.freeze({
  DEPOSITED: '0x614cd53614cbca0a11d120abc455cd6a3ce52b864035eb075598aa8eaedf2926',
  WITHDRAWAL_INITIATED: '0xdf75afe746a835b4c48a0c4d91c13b28a6eb75a2672745834e751fe3e171c9b4',
});

export function eventKey(direction, eventId) {
  if (!direction || !eventId) throw new Error('direction and eventId are required');
  return `${direction}:${String(eventId).toLowerCase()}`;
}
