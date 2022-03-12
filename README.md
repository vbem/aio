# AIO
[![Continuous Integration](https://github.com/vbem/aio/actions/workflows/ci.yml/badge.svg)](https://github.com/vbem/aio/actions/workflows/ci.yml)
[![GitHub Super-Linter](https://github.com/vbem/aio/workflows/Lint%20Code%20Base/badge.svg)](https://github.com/vbem/aio/actions/workflows/linter.yml)
[![GitHub release (latest SemVer including pre-releases)](https://img.shields.io/github/v/release/vbem/aio?include_prereleases)](https://github.com/vbem/aio/releases)
[![GitHub (Pre-)Release Date](https://img.shields.io/github/release-date-pre/vbem/aio)](https://github.com/vbem/aio/releases)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/vbem/aio)](https://github.com/vbem/aio/graphs/commit-activity)
[![GitHub last commit](https://img.shields.io/github/last-commit/vbem/aio)](https://github.com/vbem/aio/graphs/commit-activity)
[![Docker Pulls](https://img.shields.io/docker/pulls/vbem/aio)](https://hub.docker.com/r/vbem/aio)
[![GitHub top language](https://img.shields.io/github/languages/top/vbem/aio)](https://github.com/vbem/aio)
[![GitHub issues](https://img.shields.io/github/issues/vbem/aio)](https://github.com/vbem/aio/issues)

<p align="center">
  <img src="https://repository-images.githubusercontent.com/372759229/b03c199c-cead-465b-a2b9-a3f28ad4de0a">
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
