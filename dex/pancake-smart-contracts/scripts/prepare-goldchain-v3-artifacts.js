const fs = require('fs')
const path = require('path')

const ROOT = path.resolve(__dirname, '..')
const DEFAULT_SOURCE_DIR = path.resolve(ROOT, 'projects/vecake-farm-booster/v3/test/artifactsFile')
const DEFAULT_OUTPUT_DIR = path.resolve(ROOT, 'deployments/v3-artifacts')

const REQUIRED_ARTIFACTS = [
  'PancakeV3PoolDeployer',
  'PancakeV3Factory',
  'SwapRouter',
  'NonfungiblePositionManager',
  'MasterChefV3',
  'PancakeV3LmPoolDeployer',
]

const OPTIONAL_ARTIFACTS = ['QuoterV2', 'V3Migrator', 'NonfungibleTokenPositionDescriptor']

function loadArtifact(sourceDir, name, required) {
  const file = path.resolve(sourceDir, `${name}.json`)
  if (!fs.existsSync(file)) {
    if (required) {
      throw new Error(`Missing required V3 artifact: ${file}`)
    }
    return null
  }
  const artifact = JSON.parse(fs.readFileSync(file, 'utf8'))
  if (!artifact.abi || !artifact.bytecode) {
    throw new Error(`Invalid artifact (abi/bytecode missing): ${file}`)
  }
  return artifact
}

function normalizeArtifact(artifact) {
  return {
    contractName: artifact.contractName,
    sourceName: artifact.sourceName,
    abi: artifact.abi,
    bytecode: artifact.bytecode,
    deployedBytecode: artifact.deployedBytecode || null,
  }
}

function writeArtifact(outputDir, name, artifact) {
  const out = path.resolve(outputDir, `${name}.json`)
  fs.writeFileSync(out, `${JSON.stringify(normalizeArtifact(artifact), null, 2)}\n`)
  return out
}

function main() {
  const sourceDir = path.resolve(ROOT, process.env.GOLD_CHAIN_V3_ARTIFACT_SOURCE_DIR || DEFAULT_SOURCE_DIR)
  const outputDir = path.resolve(ROOT, process.env.GOLD_CHAIN_V3_ARTIFACTS_DIR || DEFAULT_OUTPUT_DIR)

  if (!fs.existsSync(sourceDir)) {
    throw new Error(`V3 artifact source directory does not exist: ${sourceDir}`)
  }

  fs.mkdirSync(outputDir, { recursive: true })

  const written = []
  for (const name of REQUIRED_ARTIFACTS) {
    const artifact = loadArtifact(sourceDir, name, true)
    written.push(writeArtifact(outputDir, name, artifact))
  }

  const skippedOptional = []
  for (const name of OPTIONAL_ARTIFACTS) {
    const artifact = loadArtifact(sourceDir, name, false)
    if (!artifact) {
      skippedOptional.push(name)
      continue
    }
    written.push(writeArtifact(outputDir, name, artifact))
  }

  console.error(
    JSON.stringify(
      {
        manifestVersion: 'goldchain.dex.v3.artifacts.v1',
        sourceDir,
        outputDir,
        written,
        skippedOptional,
        generatedAt: new Date().toISOString(),
      },
      null,
      2,
    ),
  )
}

main()
