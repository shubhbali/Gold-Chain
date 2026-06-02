const GILT_VALIDATOR_SET_SLOTS = {
  alreadyInit: 0,
  currentValidatorSet: 1,
  currentValidatorSetMap: 4,
  maxNumOfMaintaining: 8,
  maintainSlashScale: 10,
  validatorExtraSet: 11,
  maxNumOfCandidates: 13,
  previousVoteAddrFullSet: 18,
  currentVoteAddrFullSet: 19,
  turnLength: 23,
  validatorBootstrapHash: 28,
};

const GILT_VALIDATOR_SET_STORAGE_LAYOUT_MANIFEST = {
  alreadyInit: GILT_VALIDATOR_SET_SLOTS.alreadyInit,
  currentValidatorSet: GILT_VALIDATOR_SET_SLOTS.currentValidatorSet,
  currentValidatorSetMap: GILT_VALIDATOR_SET_SLOTS.currentValidatorSetMap,
  maxNumOfMaintaining: GILT_VALIDATOR_SET_SLOTS.maxNumOfMaintaining,
  maintainSlashScale: GILT_VALIDATOR_SET_SLOTS.maintainSlashScale,
  validatorExtraSet: GILT_VALIDATOR_SET_SLOTS.validatorExtraSet,
  maxNumOfCandidates: GILT_VALIDATOR_SET_SLOTS.maxNumOfCandidates,
  previousVoteAddrFullSet: GILT_VALIDATOR_SET_SLOTS.previousVoteAddrFullSet,
  currentVoteAddrFullSet: GILT_VALIDATOR_SET_SLOTS.currentVoteAddrFullSet,
  turnLength: GILT_VALIDATOR_SET_SLOTS.turnLength,
  validatorBootstrapHash: GILT_VALIDATOR_SET_SLOTS.validatorBootstrapHash,
};

function verifyGiltValidatorSetStorageLayout(storageLayout) {
  const entries = storageLayout?.storage;
  if (!Array.isArray(entries)) {
    throw new Error(
      "GiltValidatorSet artifact is missing storageLayout.storage. Run forge build with extra_output = [\"storageLayout\"] before launch generation.",
    );
  }

  const byLabel = new Map(entries.map((entry) => [entry.label, entry]));
  const checked = [];
  for (const [label, expectedSlot] of Object.entries(GILT_VALIDATOR_SET_STORAGE_LAYOUT_MANIFEST)) {
    const entry = byLabel.get(label);
    if (!entry) {
      throw new Error(`GiltValidatorSet storage layout missing required launch field: ${label}`);
    }
    if (String(entry.slot) !== String(expectedSlot)) {
      throw new Error(
        `GiltValidatorSet storage slot mismatch for ${label}: expected slot ${expectedSlot}, artifact has slot ${entry.slot}. Update launch storage deliberately before generating genesis.`,
      );
    }
    checked.push(label);
  }
  return checked;
}

module.exports = {
  GILT_VALIDATOR_SET_SLOTS,
  GILT_VALIDATOR_SET_STORAGE_LAYOUT_MANIFEST,
  verifyGiltValidatorSetStorageLayout,
};
