# Security Policy

## Supported Versions

Please see [Releases](https://github.com/chatzoneai-spec/Gold-Chain/releases). We recommend using the [most recently released version](https://github.com/chatzoneai-spec/Gold-Chain/releases/latest).

## Audit reports

Audit reports are published in the `docs` folder: https://github.com/chatzoneai-spec/Gold-Chain/tree/master/gilt/docs/audits

| Scope  | Date     | Report Link                                                                                              |
| ------ | -------- | -------------------------------------------------------------------------------------------------------- |
| `geth` | 20170425 | [pdf](https://github.com/ethereum/go-ethereum/blob/master/docs/audits/2017-04-25_Geth-audit_Truesec.pdf) |
| `clef` | 20180914 | [pdf](https://github.com/ethereum/go-ethereum/blob/master/docs/audits/2018-09-14_Clef-audit_NCC.pdf)     |

## Reporting a Vulnerability

**Please do not file a public ticket** mentioning the vulnerability.

To disclose a vulnerability, open a private security advisory for this repository: [https://github.com/chatzoneai-spec/Gold-Chain/security/advisories](https://github.com/chatzoneai-spec/Gold-Chain/security/advisories).

Use the built-in `geth version-check` feature to check whether the software is affected by any known vulnerability. This command will fetch the latest [`vulnerabilities.json`](https://geth.ethereum.org/docs/vulnerabilities/vulnerabilities.json) file which contains known security vulnerabilities concerning `geth`, and cross-check the data against its own version number.
