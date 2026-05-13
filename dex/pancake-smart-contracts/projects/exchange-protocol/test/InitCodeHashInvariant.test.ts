import * as fs from "fs";
import * as path from "path";
import { ethers } from "ethers";
import { artifacts, contract } from "hardhat";
import { assert, expect } from "chai";

const PancakeFactory = artifacts.require("./PancakeFactory.sol");
const PancakePair = artifacts.require("./PancakePair.sol");

function readLibraryInitCodeHash(): string {
  const libraryPath = path.resolve(__dirname, "../contracts/libraries/PancakeLibrary.sol");
  const source = fs.readFileSync(libraryPath, "utf8");
  const match = source.match(/PAIR_INIT_CODE_HASH\s*=\s*hex"([0-9a-fA-F]{64})"/);
  if (!match) {
    throw new Error("PAIR_INIT_CODE_HASH constant not found in PancakeLibrary.sol");
  }
  return `0x${match[1].toLowerCase()}`;
}

contract("InitCodeHashInvariant", ([alice]) => {
  it("keeps library, factory and compiled pair bytecode hash aligned", async () => {
    const factory = await PancakeFactory.new(alice, { from: alice });

    const factoryHash = (await factory.INIT_CODE_PAIR_HASH()).toLowerCase();
    const libraryHash = readLibraryInitCodeHash();
    const computedPairHash = ethers.utils.keccak256(PancakePair.bytecode).toLowerCase();

    expect(libraryHash).to.eq(computedPairHash);
    expect(factoryHash).to.eq(computedPairHash);
    assert.equal(libraryHash, factoryHash);
  });
});
