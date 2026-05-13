import { parseEther } from "ethers/lib/utils";
import { artifacts, contract, web3 } from "hardhat";
import { assert, expect } from "chai";
import { BN, constants, expectRevert } from "@openzeppelin/test-helpers";

const WBNB = artifacts.require("./WBNB.sol");

contract("WGILT", ([alice, bob]) => {
  let wgilt;

  beforeEach(async () => {
    wgilt = await WBNB.new({ from: alice });
  });

  it("tracks supply and balances from deposits and withdrawals", async () => {
    const one = parseEther("1");
    const two = parseEther("2");

    await wgilt.deposit({ from: alice, value: one.toString() });
    await web3.eth.sendTransaction({ from: bob, to: wgilt.address, value: two.toString() });

    assert.equal((await wgilt.symbol()).toString(), "WGILT");
    assert.equal((await wgilt.totalSupply()).toString(), parseEther("3").toString());
    assert.equal((await wgilt.balanceOf(alice)).toString(), one.toString());
    assert.equal((await wgilt.balanceOf(bob)).toString(), two.toString());

    await wgilt.withdraw(parseEther("0.5").toString(), { from: bob });
    assert.equal((await wgilt.totalSupply()).toString(), parseEther("2.5").toString());
    assert.equal((await wgilt.balanceOf(bob)).toString(), parseEther("1.5").toString());
  });

  it("rejects zero-address transfers and preserves burn accounting semantics", async () => {
    await wgilt.deposit({ from: alice, value: parseEther("1").toString() });

    await expectRevert(wgilt.transfer(constants.ZERO_ADDRESS, parseEther("0.1").toString(), { from: alice }), "WGILT: zero destination");

    assert.equal((await wgilt.totalSupply()).toString(), parseEther("1").toString());
    assert.equal((await wgilt.balanceOf(constants.ZERO_ADDRESS)).toString(), "0");
  });

  it("supports unlimited allowance semantics for router-style flows", async () => {
    await wgilt.deposit({ from: alice, value: parseEther("1").toString() });
    await wgilt.approve(bob, constants.MAX_UINT256, { from: alice });

    const before = new BN((await wgilt.allowance(alice, bob)).toString());
    await wgilt.transferFrom(alice, bob, parseEther("0.25").toString(), { from: bob });
    const after = new BN((await wgilt.allowance(alice, bob)).toString());

    expect(after.eq(before)).to.eq(true);
    assert.equal((await wgilt.balanceOf(bob)).toString(), parseEther("0.25").toString());
  });
});
