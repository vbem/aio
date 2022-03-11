[![GitHub issues](https://img.shields.io/github/issues/vbem/aio)](https://github.com/vbem/aio/issues)
[![GitHub top language](https://img.shields.io/github/languages/top/vbem/aio)](https://github.com/vbem/aio)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/vbem/aio)](https://github.com/vbem/aio/graphs/commit-activity)
[![GitHub last commit](https://img.shields.io/github/last-commit/vbem/aio)](https://github.com/vbem/aio/graphs/commit-activity)
[![GitHub release (latest SemVer including pre-releases)](https://img.shields.io/github/v/release/vbem/aio?include_prereleases)](https://github.com/vbem/aio/releases)
[![GitHub (Pre-)Release Date](https://img.shields.io/github/release-date-pre/vbem/aio)](https://github.com/vbem/aio/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/vbem/aio)](https://hub.docker.com/r/vbem/aio)
[![Continuous Integration](https://github.com/vbem/aio/actions/workflows/ci.yml/badge.svg)](https://github.com/vbem/aio/actions/workflows/ci.yml)

<p align="center">
  <img src="https://raw.githubusercontent.com/vbem/aio/main/logo.png">
</p>

# aio
A generic DevOps all-in-one image pre-installed with many tools.

## What

An All-In-One docker image for command-line debugging or basic CI/CD tasks:
- Alpine latest stable version based
- `tzdata` added and `Asia/Shanghai` as default time-zone. You can change this by setting `TZ` env var at runtime
- Replaced `ash` to `bash` as default shell
- `$PS1` optimized
- Pre-installed many tools mentioned in `Dockerfile`

## Where

- Code repository: https://github.com/vbem/aio
- Docker repository: https://hub.docker.com/r/vbem/aio

## How

For docker run:
```shell
docker run --rm -it --name aio vbem/aio
```

For K8S run:
```shell
kubectl run aio -v5 -n ${YOUR_NAMESPACE} -it --rm --restart=Never --image=vbem/aio
```
