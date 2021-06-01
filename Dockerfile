# https://hub.docker.com/_/alpine
FROM alpine:3.13

WORKDIR /root

HEALTHCHECK --timeout=1s --retries=1 CMD true || false

ENV \
LANG=C.UTF-8 \
PS1='\[\e[1;7m\] $\?=$? $(. /etc/os-release && echo $ID-$VERSION_ID) \u@$(hostname -i)@\H:\w \[\e[0m\]\n\$ '

RUN function log { echo -e "\e[7;36m$(date +%F_%T)\e[0m\e[1;96m $*\e[0m" > /dev/stderr ; } \
# https://pkgs.alpinelinux.org/
# https://developer.aliyun.com/mirror/alpine
# https://mirrors.tuna.tsinghua.edu.cn/help/alpine/
&& log "updating apk repositories mirror" \
&& sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
# && sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
&& cat /etc/apk/repositories \
\
# https://pkgs.alpinelinux.org/packages?name=curl&branch=v3.13&arch=x86_64
# https://pkgs.alpinelinux.org/package/v3.12/main/x86_64/curl
&& log "installing 'curl'" \
&& apk add --no-cache curl \
\
# https://pkgs.alpinelinux.org/packages?name=tzdata&branch=v3.13&arch=x86_64
# https://wiki.alpinelinux.org/wiki/Setting_the_timezone
&& log "installing tzdata and set timezone as 'Asia/Shanghai'" \
&& apk add --no-cache tzdata \
&& cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone \
&& apk del tzdata \
\
# https://pkgs.alpinelinux.org/packages?name=docker-cli&branch=v3.13&arch=x86_64
&& log "installing docker-cli" \
&& apk add --no-cache docker-cli \
\
# https://pkgs.alpinelinux.org/packages?name=git&branch=v3.13&arch=x86_64
&& log "installing git" \
&& apk add --no-cache git \
\
# https://pkgs.alpinelinux.org/packages?name=openjdk8&branch=v3.13&arch=x86_64
# https://pkgs.alpinelinux.org/packages?name=maven&branch=v3.13&arch=x86_64
&& log "installing maven" \
&& apk add --no-cache openjdk8 maven \
\
# https://pkgs.alpinelinux.org/packages?name=npm&branch=v3.13&arch=x86_64
# https://pkgs.alpinelinux.org/packages?name=nodejs&branch=v3.13&arch=x86_64
# https://developer.aliyun.com/mirror/NPM
# https://npm.taobao.org/mirrors
&& log "installing nodejs and set npm mirror" \
&& apk add --no-cache npm \
&& npm config set registry https://registry.npm.taobao.org -g \
&& npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/ -g \
&& npm config set phantomjs_cdnurl https://npm.taobao.org/mirrors/phantomjs/ -g \
&& npm config set electron_mirror https://npm.taobao.org/mirrors/electron/ -g \
\
# https://pkgs.alpinelinux.org/packages?name=py3-pip&branch=v3.13&arch=x86_64
# https://pkgs.alpinelinux.org/packages?name=python3&branch=v3.13&arch=x86_64
# https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.12.0#python3_no_longer_provides_pip3.2C_use_py3-pip_from_community
# https://developer.aliyun.com/mirror/pypi
&& log "installing python3 and set pip3 mirror" \
&& apk add --no-cache py3-pip \
&& echo -e '[global]\nindex-url=https://mirrors.aliyun.com/pypi/simple/\ntrusted-host=mirrors.aliyun.com' > /etc/pip.conf \
\
# https://pkgs.alpinelinux.org/packages?name=ansible&branch=v3.13&arch=x86_64
&& log "installing ansible" \
&& apk add --no-cache ansible \
\
# https://docs.amazonaws.cn/cli/latest/userguide/install-linux-al2017.html
# https://pkgs.alpinelinux.org/packages?name=jq&branch=v3.13&arch=x86_64
# https://stedolan.github.io/jq/
&& log "installing jq" \
&& apk add --no-cache jq \
\
# https://help.aliyun.com/document_detail/121541.html , not all versions support BushBox, so we LOCK VERSION!!!
# https://github.com/aliyun/aliyun-cli/releases
&& log "installing aliyun-cli" \
&& wget https://github.com/aliyun/aliyun-cli/releases/download/v3.0.62/aliyun-cli-linux-3.0.62-amd64.tgz -O- | tar xz \
&& chown root:root aliyun && chmod 755 aliyun && mv aliyun /bin/aliyun \
\
# https://mikefarah.gitbook.io/yq/
# https://github.com/mikefarah/yq/releases
&& log "installing yq version 4.x (latest) as yq" \
&& wget "https://github.com/mikefarah/yq/releases/download/v4.9.3/yq_linux_amd64.tar.gz" -O- | tar xz \
&& mv yq_linux_amd64 yq && chown root:root yq && chmod 755 yq && mv yq /bin/ \
\
# https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux
&& log "installing kubectl" \
# && KUBECTL_VERSION=$(wget -O- https://dl.k8s.io/release/stable.txt) \
&& wget https://dl.k8s.io/release/v1.21.1/bin/linux/amd64/kubectl -O /bin/kubectl \
&& chmod a+x /bin/kubectl \
\
# https://helm.sh/
&& log "installing helm" \
# && wget "https://get.helm.sh/helm-v3.6.0-linux-amd64.tar.gz" -O- | tar xz \
# Too slow from original, use oss to accelerate
&& wget "https://cloud-devops.oss-cn-shanghai.aliyuncs.com/tools/helm/helm-v3.6.0-linux-amd64.tar.gz" -O- | tar xz \
&& mv linux-amd64/helm helm && rm -rf linux-amd64 && chown root:root helm && chmod 755 helm && mv helm /bin/ \
\
&& log "cleaning all cache files" \
&& rm -rf ~/.ash_history ~/.cache/ ~/.config/ ~/.npm* ~/* /var/cache/apk/* /tmp/*
