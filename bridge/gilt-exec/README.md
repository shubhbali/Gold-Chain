# Gilt Overview
Gilt is the official Golang implementation of the Gilt PoS blockchain. It is a fork of [geth](https://github.com/ethereum/go-ethereum) and is EVM compatible (upto London fork).

[Repository](https://github.com/chatzoneai-spec/Gold-Chain/tree/master/bridge/gilt-exec)
![MIT License](https://img.shields.io/badge/license-MIT-green.svg)

### Installing gilt using packaging

The easiest way to get started with gilt is to install packages from the [releases](https://github.com/chatzoneai-spec/Gold-Chain/releases) page.

If you prefer a source install in one command:

    git clone --depth 1 -b master https://github.com/chatzoneai-spec/Gold-Chain.git && cd Gold-Chain/bridge/gilt-exec && make gilt && sudo cp build/bin/gilt /usr/bin/gilt

The releases supports both the networks i.e. Gilt Mainnet, and GiltTestnet (Testnet) unless explicitly specified. Before the stable release for mainnet, pre-releases will be available marked with `beta` tag for deploying on GiltTestnet (testnet). On sufficient testing, stable release for mainnet will be announced with a forum post.

### Building from source

- Install Go (version 1.19 or later) and a C compiler.
- Clone the repository and build the binary using the following commands:
    ```shell
    make gilt
    ```
- Start gilt using the ideal config files for the validator and sentry provided in the `packaging` folder.
    ```shell
    ./build/bin/gilt server --config ./packaging/templates/mainnet-v1/sentry/sentry/gilt/config.toml
    ```
- To build full set of utilities, run:
    ```shell
    make all
    ```
- Run unit and integration tests
    ```shell
    make test && make test-integration
    ```

#### Using the new cli

Post `v0.3.0` release, gilt uses a new command line interface (cli). The new-cli (located at `internal/cli`) has been built while keeping the flag usage similar to old-cli (located at `cmd/geth`) with a few notable changes. Please refer to [docs](./docs) section for the flag usage guide and example.

### Latest Config Reference

For the latest canonical TOML config options, refer to:

- [`docs/cli/default_config.toml`](docs/cli/default_config.toml)

### Documentation

- The official documentation for the Gilt PoS chain can be found [here](./docs). It contains all the conceptual and architectural details of the chain along with an operational guide for users running the nodes.
- New release announcements and discussions can be found in [GitHub Discussions](https://github.com/chatzoneai-spec/Gold-Chain/discussions).
- Gilt improvement proposals are tracked in [GitHub Discussions](https://github.com/chatzoneai-spec/Gold-Chain/discussions) and issues.

### Contribution guidelines

Thank you for considering helping out with the source code! We welcome contributions from anyone on the internet, and are grateful for even the smallest of fixes! If you'd like to contribute to gilt, please fork, fix, commit, and send a pull request for the maintainers to review and merge into the main code base. 

From the outset, we defined some guidelines to ensure new contributions only ever enhance the project:

* Quality: Code in the Gilt project should meet the style guidelines, with sufficient test-cases, descriptive commit messages, evidence that the contribution does not break any compatibility commitments or cause adverse feature interactions, and evidence of high-quality peer-review. Code must adhere to the official Go [formatting](https://golang.org/doc/effective_go.html#formatting) guidelines (i.e. uses [gofmt](https://golang.org/cmd/gofmt/)).
* Testing: Please ensure that the updated code passes all the tests locally before submitting a pull request. In order to run unit tests, run `make test` and to run integration tests, run `make test-integration`.
* Size: The Gilt project’s culture is one of small pull-requests, regularly submitted. The larger a pull-request, the more likely it is that you will be asked to resubmit as a series of self-contained and individually reviewable smaller PRs.
* Maintainability: If the feature will require ongoing maintenance (e.g. support for a particular brand of database), we may ask you to accept responsibility for maintaining this feature
* Pull requests need to be based on and opened against the `develop` branch.
* PR title should be prefixed with package(s) they modify.
  * E.g. "eth, rpc: make trace configs optional"


### Hardware Requirements

Minimum:

* CPU with 4+ cores
* 8GB RAM
* 1TB free storage space to sync the Mainnet
* 8 MBit/sec download Internet service

Recommended:

* Fast CPU with 8+ cores
* 16GB+ RAM
* High-performance SSD with at least 1TB of free space
* 25+ MBit/sec download Internet service

## License

The Gilt library (i.e. all code outside of the `cmd` directory) is licensed under the
[GNU Lesser General Public License v3.0](https://www.gnu.org/licenses/lgpl-3.0.en.html),
also included in our repository in the `COPYING.LESSER` file.

The Gilt binaries (i.e. all code inside of the `cmd` directory) are licensed under the
[GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html), also
included in our repository in the `COPYING` file.

## Join our Discord server

Join Gilt community – share your ideas or just say hi over on [Gilt Community Discord](https://discord.gg/z2VpC455eU) or on [Gilt R&D Discord](https://discord.gg/z2VpC455eU).
