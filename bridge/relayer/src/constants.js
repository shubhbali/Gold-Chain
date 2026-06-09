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

export function eventKey(direction, eventId) {
  if (!direction || !eventId) throw new Error('direction and eventId are required');
  return `${direction}:${String(eventId).toLowerCase()}`;
}
