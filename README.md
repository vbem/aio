
[![Continuous Integration](https://github.com/vbem/aio/actions/workflows/ci.yml/badge.svg)](https://github.com/vbem/aio/actions/workflows/ci.yml)
# aio
A generic DevOps all-in-one image pre-installed with many tools.

## What

An All-In-One docker image for command-line debugging or basic CI/CD tasks:
- Alpine latest stable version based
- `mirrors.aliyun.com` repo enabled for `apk` acceleration
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
