const bluebird = require('bluebird')

const GiltValidatorSet = artifacts.require('GiltValidatorSet')
const TestGiltValidatorSet = artifacts.require('TestGiltValidatorSet')
const BytesLib = artifacts.require('BytesLib')
const ECVerify = artifacts.require('ECVerify')
const IterableMapping = artifacts.require('IterableMapping')
const RLPReader = artifacts.require('RLPReader')
const SafeMath = artifacts.require('SafeMath')
const StateReciever = artifacts.require('StateReceiver')
const TestStateReceiver = artifacts.require('TestStateReceiver')
const TestCommitState = artifacts.require('TestCommitState')
const System = artifacts.require('System')
const ValidatorVerifier = artifacts.require('ValidatorVerifier')

const libDeps = [
    {
        lib: BytesLib,
        contracts: [GiltValidatorSet, TestGiltValidatorSet]
    },
    {
        lib: ECVerify,
        contracts: [GiltValidatorSet, TestGiltValidatorSet]
    },
    {
        lib: IterableMapping,
        contracts: [StateReciever, TestStateReceiver]
    },
    {
        lib: RLPReader,
        contracts: [GiltValidatorSet, TestGiltValidatorSet, StateReciever, TestStateReceiver]
    },
    {
        lib: SafeMath,
        contracts: [GiltValidatorSet, TestGiltValidatorSet, StateReciever, TestStateReceiver]
    }
]

module.exports = async function (deployer, network) {
    deployer.then(async () => {
        console.log('linking libs...')
        for (let e of libDeps) {
            await deployer.deploy(e.lib)
            deployer.link(e.lib, e.contracts)
        }

        console.log("Deploying contracts...")
        await deployer.deploy(GiltValidatorSet)
        await deployer.deploy(TestGiltValidatorSet)
        await deployer.deploy(StateReciever)
        await deployer.deploy(TestStateReceiver)
        await deployer.deploy(System)
        await deployer.deploy(ValidatorVerifier)
        await deployer.deploy(TestCommitState)
    })
}
