# https://hub.docker.com/_/alpine
FROM alpine:3.14

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
# https://pkgs.alpinelinux.org/packages?name=tzdata&branch=v3.13&arch=x86_64
# https://wiki.alpinelinux.org/wiki/Setting_the_timezone
&& log "installing tzdata and set timezone as 'Asia/Shanghai'" \
&& apk add --no-cache tzdata \
&& cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone \
&& apk del tzdata \
\
# https://pkgs.alpinelinux.org
&& apps="bash curl iputils docker-cli git openjdk8 maven ansible jq yq rclone npm py3-pip" \
&& log "installing $apps" \
&& apk add --no-cache $apps \
\
# https://developer.aliyun.com/mirror/NPM
# https://npm.taobao.org/mirrors
&& log "setting npm mirror" \
&& npm config set registry https://registry.npm.taobao.org -g \
&& npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/ -g \
&& npm config set phantomjs_cdnurl https://npm.taobao.org/mirrors/phantomjs/ -g \
&& npm config set electron_mirror https://npm.taobao.org/mirrors/electron/ -g \
\
# https://developer.aliyun.com/mirror/pypi
&& log "setting python3 pip mirror" \
&& echo -e '[global]\nindex-url=https://mirrors.aliyun.com/pypi/simple/\ntrusted-host=mirrors.aliyun.com' > /etc/pip.conf \
\
# https://help.aliyun.com/document_detail/121541.html , not all versions support BushBox, so we LOCK VERSION!!!
# https://github.com/aliyun/aliyun-cli/releases
&& log "installing aliyun-cli" \
&& wget https://github.com/aliyun/aliyun-cli/releases/download/v3.0.62/aliyun-cli-linux-3.0.62-amd64.tgz -O- | tar xz \
&& chown root:root aliyun && chmod 755 aliyun && mv aliyun /usr/local/bin/ \
\
# https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux
&& log "installing kubectl" \
&& KUBECTL_VERSION=$(wget -O- https://dl.k8s.io/release/stable.txt) \
&& wget https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl -O kubectl \
&& chmod a+x kubectl && mv kubectl /usr/local/bin/ \
\
# https://helm.sh/
&& log "installing helm" \
&& wget "https://get.helm.sh/helm-v3.6.1-linux-amd64.tar.gz" -O- | tar xz \
&& mv linux-amd64/helm helm && rm -rf linux-amd64 && chown root:root helm && chmod 755 helm && mv helm /usr/local/bin/ \
\
&& log "cleaning all cache files" \
&& rm -rf ~/.ash_history ~/.cache/ ~/.config/ ~/.npm* ~/* /var/cache/apk/* /tmp/*
