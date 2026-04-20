## Docker Image

Included in this repo is a Dockerfile that you can launch a Gilt Chain node with. Docker images are available on `ghcr.io/chatzoneai-spec/gold-chain`.

You can build the docker image with the following commands:
```bash
make docker
```

If your build machine has an ARM-based chip, like Apple silicon (M1), the image is built for `linux/arm64` by default. To build for `x86_64`, apply the --platform arg:

```bash
docker build --platform linux/amd64 -t chatzoneai-spec/gold-chain -f Dockerfile .
```

Before starting Docker, get a copy of `config.toml` and `genesis.json` from releases: https://github.com/chatzoneai-spec/Gold-Chain/releases, and make necessary modifications. `config.toml` and `genesis.json` should be mounted into `/gilt/config` inside the container. Assume they are under `./config` in your current working directory, then start the container with:
```bash
docker run -v $(pwd)/config:/gilt/config --rm --name gilt -it chatzoneai-spec/gold-chain
```

You can also use `ETHEREUM OPTIONS` to overwrite settings in the configuration file
```bash
docker run -v $(pwd)/config:/gilt/config --rm --name gilt -it chatzoneai-spec/gold-chain --http.addr 0.0.0.0 --http.port 8545 --http.vhosts '*' --verbosity 3
```

If you need to open another shell, just do:
```bash
docker exec -it gilt /bin/bash
```

We also provide a `docker-compose` file for local testing

To use the container in kubernetes, you can use a configmap or secret to mount the `config.toml` & `genesis.json` into the container
```bash
containers:
  - name: gilt
    image: chatzoneai-spec/gold-chain

    ports:
      - name: p2p
        containerPort: 30311  
      - name: rpc
        containerPort: 8545
      - name: ws
        containerPort: 8546     

    volumeMounts:
      - name: gilt-config
        mountPath: /gilt/config

  volumes:
    - name: gilt-config
      configMap:
        name: cm-gilt-config
```

Your configmap `gilt-config` should look like this:
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: cm-gilt-config
data:
  config.toml: |
    ...

  genesis.json: |
    ...  

```
