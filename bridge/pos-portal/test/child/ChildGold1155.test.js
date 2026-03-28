import { AbiCoder } from 'ethers'
import { deployFreshChildContracts } from '../helpers/deployerNew.js'
import { expect } from 'chai'

const abi = new AbiCoder()

contract('ChildGold1155', (accounts) => {
  describe('deposit and withdrawSingle', () => {
    const rootAmount = 2n
    const tokenId = 1n
    let childGold1155

    before(async () => {
      const contracts = await deployFreshChildContracts(accounts)
      childGold1155 = contracts.childGold1155

      const depositorRole = await childGold1155.DEPOSITOR_ROLE()
      await childGold1155.grantRole(depositorRole, accounts[0])
    })

    it('Should mint scaled ERC1155 GOLD on deposit', async () => {
      const depositData = abi.encode(['uint256', 'uint256'], [tokenId.toString(), rootAmount.toString()])
      await childGold1155.deposit(accounts[1], depositData)
      expect(await childGold1155.balanceOf(accounts[1], tokenId)).to.equal(2000n)
    })

    it('Should reject non exact withdraw amounts', async () => {
      await expect(
        childGold1155.connect(await ethers.getSigner(accounts[1])).withdrawSingle(tokenId, 1999)
      ).to.be.revertedWith('ChildGold1155: NON_EXACT_WITHDRAW')
    })

    it('Should allow exact withdraw amounts', async () => {
      await expect(
        childGold1155.connect(await ethers.getSigner(accounts[1])).withdrawSingle(tokenId, 1000)
      ).to.not.be.reverted
    })
  })
})
