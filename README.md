# AIO
[![Continuous Integration](https://github.com/vbem/aio/actions/workflows/ci.yml/badge.svg)](https://github.com/vbem/aio/actions/workflows/ci.yml)
[![GitHub Super-Linter](https://github.com/vbem/aio/workflows/Lint%20Code%20Base/badge.svg)](https://github.com/vbem/aio/actions/workflows/linter.yml)
[![GitHub issues](https://img.shields.io/github/issues/vbem/aio)](https://github.com/vbem/aio/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/vbem/aio)](https://github.com/vbem/aio/graphs/commit-activity)
[![GitHub last commit](https://img.shields.io/github/last-commit/vbem/aio)](https://github.com/vbem/aio/graphs/commit-activity)
[![docker-hub semver](https://img.shields.io/docker/v/vbem/aio?label=docker-hub%20semver)](https://hub.docker.com/r/vbem/aio)
[![docker-hub pulls](https://img.shields.io/docker/pulls/vbem/aio?label=docker-hub%20pulls)](https://hub.docker.com/r/vbem/aio)

<p align="center">
  <a href="https://github.com/vbem/aio"><img src="https://repository-images.githubusercontent.com/372759229/b03c199c-cead-465b-a2b9-a3f28ad4de0a"></a>
</p>

## What
A generic DevOps all-in-one image pre-installed with many tools.
- Alpine latest stable version based
- `tzdata` added and `Asia/Shanghai` as default time-zone. You can change this by setting `TZ` env var at runtime
- Replaced `ash` to `bash` as default shell
- `$PS1` optimized
- Pre-installed many tools mentioned in `Dockerfile`

## Where

- [Code repository](https://github.com/vbem/aio)
- [Docker image repository](https://hub.docker.com/r/vbem/aio)

## How

For docker run:
```shell
docker run --rm -it --name aio vbem/aio
```

For K8S run:
```shell
kubectl run aio -v5 -n ${YOUR_NAMESPACE} -it --rm --restart=Never --image=vbem/aio
```
