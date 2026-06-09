export function assertFinalizedEvent({ chainName, headBlock, event, finality }) {
  if (!event || !Number.isSafeInteger(event.blockNumber) || event.blockNumber < 0) {
    throw new Error(`${chainName}: event ${event?.id ?? '<unknown>'} has invalid blockNumber`);
  }
  if (!Number.isSafeInteger(headBlock) || headBlock < event.blockNumber) {
    throw new Error(`${chainName}: invalid headBlock ${headBlock} for event ${event.id}`);
  }
  if (!finality || !Number.isSafeInteger(finality.minConfirmations) || finality.minConfirmations <= 0) {
    throw new Error(`${chainName}: explicit positive minConfirmations finality policy is required`);
  }

  const confirmations = headBlock - event.blockNumber + 1;
  if (confirmations < finality.minConfirmations) {
    return { finalized: false, confirmations, reason: 'insufficient-confirmations' };
  }
  if (finality.requireSafeTag === true && event.safe !== true) {
    return { finalized: false, confirmations, reason: 'missing-safe-tag' };
  }
  if (finality.requireFinalizedTag === true && event.finalized !== true) {
    return { finalized: false, confirmations, reason: 'missing-finalized-tag' };
  }
  return { finalized: true, confirmations };
}

export function filterFinalizedEvents({ chainName, headBlock, events, finality }) {
  return events
    .map((event) => ({ event, status: assertFinalizedEvent({ chainName, headBlock, event, finality }) }))
    .filter(({ status }) => status.finalized)
    .map(({ event }) => event);
}
