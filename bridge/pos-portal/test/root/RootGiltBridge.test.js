import { bufferToHex, rlp } from 'ethereumjs-util'
import { deployInitializedContracts } from '../helpers/deployerNew.js'
import { expect } from 'chai'
import { syncState } from '../helpers/utils.js'
import { submitCheckpoint } from '../helpers/checkpoint.js'

contract('RootChainManager native GILT route', (accounts) => {
  const buildExitPayload = (headerNumber, checkpointData, receipt, logIndex = 0) =>
    bufferToHex(
      rlp.encode([
        headerNumber,
        bufferToHex(Buffer.concat(checkpointData.proof)),
        checkpointData.number,
        checkpointData.timestamp,
        bufferToHex(checkpointData.transactionsRoot),
        bufferToHex(checkpointData.receiptsRoot),
        bufferToHex(checkpointData.receipt),
        bufferToHex(rlp.encode(checkpointData.receiptParentNodes)),
        bufferToHex(checkpointData.path),
        logIndex
      ])
    )

  it('Should burn wrapped GILT on deposit and credit child native GILT', async () => {
    const contracts = await deployInitializedContracts(accounts)
    const amount = 5n
    await contracts.root.wrappedGilt.mint(accounts[0], amount)
    const rootBalanceBefore = await contracts.root.wrappedGilt.balanceOf(accounts[0])

    await contracts.root.wrappedGilt.approve(contracts.root.wrappedGiltPredicate.target, amount)
    const depositTx = await contracts.root.rootChainManager.depositFor(
      accounts[0],
      contracts.root.wrappedGilt.target,
      ethers.AbiCoder.defaultAbiCoder().encode(['uint256'], [amount.toString()])
    )
    const depositReceipt = await depositTx.wait()
    const syncTxs = await syncState(depositReceipt)
    await Promise.all(syncTxs.map((tx) => tx.wait()))

    expect(await contracts.root.wrappedGilt.balanceOf(accounts[0])).to.equal(rootBalanceBefore - amount)
    expect(await contracts.child.childNativeGilt.credited(accounts[0])).to.equal(amount)
  })

  it('Should mint wrapped GILT on exit from child native GILT', async () => {
    const contracts = await deployInitializedContracts(accounts)
    const amount = 3n
    await contracts.root.wrappedGilt.mint(accounts[0], amount)
    const rootBalanceBefore = await contracts.root.wrappedGilt.balanceOf(accounts[0])

    await contracts.root.wrappedGilt.approve(contracts.root.wrappedGiltPredicate.target, amount)
    const depositTx = await contracts.root.rootChainManager.depositFor(
      accounts[0],
      contracts.root.wrappedGilt.target,
      ethers.AbiCoder.defaultAbiCoder().encode(['uint256'], [amount.toString()])
    )
    const depositReceipt = await depositTx.wait()
    const syncTxs = await syncState(depositReceipt)
    await Promise.all(syncTxs.map((tx) => tx.wait()))

    const withdrawTx = await contracts.child.childNativeGilt.withdraw(amount)
    await withdrawTx.wait()
    const withdrawReceipt = await web3.eth.getTransactionReceipt(withdrawTx.hash)

    const checkpointData = await submitCheckpoint(contracts.root.checkpointManager, withdrawReceipt)
    const headerNumber = await contracts.root.checkpointManager.currentCheckpointNumber()
    const exitData = buildExitPayload(headerNumber, checkpointData, withdrawReceipt, 0)

    await contracts.root.rootChainManager.exit(exitData)

    expect(await contracts.root.wrappedGilt.balanceOf(accounts[0])).to.equal(rootBalanceBefore)
  })
})
