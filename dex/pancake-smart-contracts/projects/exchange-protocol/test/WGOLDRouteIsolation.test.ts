import { parseEther } from "ethers/lib/utils";
import { artifacts, contract } from "hardhat";
import { assert } from "chai";
import { expectRevert } from "@openzeppelin/test-helpers";

const MockERC1155Mintable = artifacts.require("./utils/MockERC1155Mintable.sol");
const WGOLD = artifacts.require("./WGOLD.sol");
const WGOLDRouteToken = artifacts.require("./WGOLDRouteToken.sol");

contract("WGOLD route isolation", ([alice, bob]) => {
  let rawGold;
  let wrappedGold;
  let paxgRoute;
  let xautRoute;

  const one = parseEther("1").toString();
  const two = parseEther("2").toString();

  beforeEach(async () => {
    rawGold = await MockERC1155Mintable.new({ from: alice });
    wrappedGold = await WGOLD.new(rawGold.address, { from: alice });
    paxgRoute = await WGOLDRouteToken.new(
      wrappedGold.address,
      1,
      "Wrapped GOLD (PAXG)",
      "WGOLD-PAXG",
      { from: alice },
    );
    xautRoute = await WGOLDRouteToken.new(
      wrappedGold.address,
      2,
      "Wrapped GOLD (XAUT)",
      "WGOLD-XAUT",
      { from: alice },
    );
  });

  it("keeps PAXG and XAUT backing isolated end-to-end", async () => {
    await rawGold.mint(alice, 1, one, { from: alice });
    await rawGold.mint(bob, 2, one, { from: alice });

    await rawGold.setApprovalForAll(wrappedGold.address, true, { from: alice });
    await rawGold.setApprovalForAll(wrappedGold.address, true, { from: bob });
    await wrappedGold.wrap(1, one, { from: alice });
    await wrappedGold.wrap(2, one, { from: bob });

    await wrappedGold.setApprovalForAll(paxgRoute.address, true, { from: alice });
    await wrappedGold.setApprovalForAll(xautRoute.address, true, { from: bob });
    await paxgRoute.wrap(one, { from: alice });
    await xautRoute.wrap(one, { from: bob });

    assert.equal((await wrappedGold.balanceOf(paxgRoute.address, 1)).toString(), one);
    assert.equal((await wrappedGold.balanceOf(paxgRoute.address, 2)).toString(), "0");
    assert.equal((await wrappedGold.balanceOf(xautRoute.address, 2)).toString(), one);
    assert.equal((await wrappedGold.balanceOf(xautRoute.address, 1)).toString(), "0");

    await expectRevert(
      paxgRoute.unwrap(one, { from: bob }),
      "ERC20: burn amount exceeds balance",
    );

    await xautRoute.unwrap(one, { from: bob });
    await wrappedGold.unwrap(2, one, { from: bob });
    assert.equal((await rawGold.balanceOf(bob, 2)).toString(), one);
    assert.equal((await rawGold.balanceOf(bob, 1)).toString(), "0");
  });

  it("rejects route-mismatched wrapping attempts", async () => {
    await rawGold.mint(bob, 2, two, { from: alice });
    await rawGold.setApprovalForAll(wrappedGold.address, true, { from: bob });
    await wrappedGold.wrap(2, two, { from: bob });
    await wrappedGold.setApprovalForAll(paxgRoute.address, true, { from: bob });

    await expectRevert(
      paxgRoute.wrap(two, { from: bob }),
      "ERC1155: insufficient balance for transfer",
    );
  });
});
