# Debug

The ```gilt debug``` command takes a debug dump of the running client.

- [```gilt debug pprof```](./debug_pprof.md): Dumps gilt pprof traces.

- [```gilt debug block <number>```](./debug_block.md): Dumps gilt block traces.

## Examples

By default it creates a tar.gz file with the output:

```
$ gilt debug
Starting debugger...

Created debug archive: gilt-debug-2021-10-26-073819Z.tar.gz
```

Send the output to a specific directory:

```
$ gilt debug --output data
Starting debugger...

Created debug directory: data/gilt-debug-2021-10-26-075437Z
```