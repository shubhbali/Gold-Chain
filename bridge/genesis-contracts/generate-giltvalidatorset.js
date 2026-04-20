const program = require("commander")
const fs = require("fs")
const nunjucks = require("nunjucks")
const web3 = require("web3")
const validators = require("./validators")

program.version("0.0.1")
program.option("--gilt-chain-id <gilt-chain-id>", "Gilt chain id", "15001")
program.option(
  "--giltconsensus-chain-id <giltconsensus-chain-id>",
  "GiltConsensus chain id",
  "giltconsensus-P5rXwg"
)
program.option("--sprint-size <sprint-size>", "Sprint size", "64")
program.option(
  "--first-end-block <first-end-block>",
  "End block for first span",
  "255"
)
program.option(
  "-o, --output <output-file>",
  "GiltValidatorSet.sol",
  "./contracts/GiltValidatorSet.sol"
)
program.option(
  "-t, --template <template>",
  "GiltValidatorSet template file",
  "./contracts/GiltValidatorSet.template"
)
program.parse(process.argv)

// process validators
validators.forEach(v => {
  v.address = web3.utils.toChecksumAddress(v.address)
})

const data = {
  giltChainId: program.giltChainId,
  giltconsensusChainId: program.giltconsensusChainId,
  firstEndBlock: program.firstEndBlock,
  validators: validators,
  sprintSize: program.sprintSize
}
const templateString = fs.readFileSync(program.template).toString()
const resultString = nunjucks.renderString(templateString, data)
fs.writeFileSync(program.output, resultString)
console.log("Gilt validator set file updated.")
