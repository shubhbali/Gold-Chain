import { AbiCoder } from 'ethers'
import { deployFreshRootContracts } from '../helpers/deployerNew.js'
import { expect } from 'chai'
import { getERC1155TransferSingleLog } from '../helpers/logs.js'
import { mockValues } from '../helpers/constants.js'

const abi = new AbiCoder()

contract('ScaledERC1155Predicate', (accounts) => {
  const scaleNumerator = 1000n

  describe('lockTokens', () => {
    const rootAmount = 2n
    const childTokenId = 1n
    const depositReceiver = mockValues.addresses[7]
    let depositor
    let dummyPaxgERC20
    let scaledERC1155Predicate

    before(async () => {
      depositor = await ethers.getSigner(accounts[1])
      const contracts = await deployFreshRootContracts(accounts)
      dummyPaxgERC20 = contracts.dummyPaxgERC20
      scaledERC1155Predicate = contracts.scaledERC1155Predicate

      await dummyPaxgERC20.transfer(depositor.address, rootAmount)
      await dummyPaxgERC20.connect(depositor).approve(scaledERC1155Predicate.target, rootAmount)
    })

    it('Should lock root amount and emit scaled child amount', async () => {
      const depositData = abi.encode(['uint256', 'uint256'], [childTokenId.toString(), rootAmount.toString()])
      await expect(
        scaledERC1155Predicate.lockTokens(depositor.address, depositReceiver, dummyPaxgERC20.target, depositData)
      )
        .to.emit(scaledERC1155Predicate, 'LockedScaledERC1155')
        .withArgs(
          depositor.address,
          depositReceiver,
          dummyPaxgERC20.target,
          childTokenId,
          rootAmount,
          rootAmount * scaleNumerator
        )
    })
  })

  describe('exitTokens', () => {
    const rootAmount = 3n
    const childTokenId = 2n
    const childAmount = rootAmount * scaleNumerator
    const withdrawer = mockValues.addresses[8]
    let dummyXautERC20
    let scaledERC1155Predicate

    before(async () => {
      const contracts = await deployFreshRootContracts(accounts)
      dummyXautERC20 = contracts.dummyXautERC20
      scaledERC1155Predicate = contracts.scaledERC1155Predicate

      await dummyXautERC20.approve(scaledERC1155Predicate.target, rootAmount)
      const depositData = abi.encode(['uint256', 'uint256'], [childTokenId.toString(), rootAmount.toString()])
      await scaledERC1155Predicate.lockTokens(accounts[0], accounts[0], dummyXautERC20.target, depositData)
    })

    it('Should release scaled amount back to root side', async () => {
      const burnLog = getERC1155TransferSingleLog({
        operator: accounts[0],
        from: withdrawer,
        to: mockValues.zeroAddress,
        tokenId: childTokenId,
        amount: childAmount
      })

      await expect(scaledERC1155Predicate.exitTokens(dummyXautERC20.target, dummyXautERC20.target, burnLog))
        .to.emit(scaledERC1155Predicate, 'ExitedScaledERC1155')
        .withArgs(withdrawer, dummyXautERC20.target, childTokenId, childAmount, rootAmount)
    })

    it('Should reject non exact child burn amounts', async () => {
      const badBurnLog = getERC1155TransferSingleLog({
        operator: accounts[0],
        from: withdrawer,
        to: mockValues.zeroAddress,
        tokenId: childTokenId,
        amount: childAmount - 1n
      })

      await expect(
        scaledERC1155Predicate.exitTokens(dummyXautERC20.target, dummyXautERC20.target, badBurnLog)
      ).to.be.revertedWith('ScaledERC1155Predicate: NON_EXACT_EXIT')
    })
  })
})
