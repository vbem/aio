# https://alpinelinux.org/
# https://hub.docker.com/_/alpine
FROM alpine:3.15

# https://docs.docker.com/engine/reference/builder/#arg
ARG IMG_VER IMG_REV IMG_CREATED

# https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL \
org.opencontainers.image.title="aio" \
org.opencontainers.image.description="All-In-One for DevOps and debugging." \
org.opencontainers.image.authors="i@lilei.tech" \
org.opencontainers.image.vendor="lilei.tech" \
org.opencontainers.image.source="https://github.com/vbem/aio" \
org.opencontainers.image.url="https://hub.docker.com/r/vbem/aio" \
org.opencontainers.image.base.name="library/alpine" \
org.opencontainers.image.version="$IMG_VER" \
org.opencontainers.image.revision="$IMG_REV" \
org.opencontainers.image.created="$IMG_CREATED"

RUN function log { echo -e "\e[7;36m$(date +%F_%T)\e[0m\e[1;96m $*\e[0m" > /dev/stderr ; } \
\
# https://wiki.alpinelinux.org/wiki/Alpine_setup_scripts#setup-apkrepos
# https://mirrors.alpinelinux.org/
# https://developer.aliyun.com/mirror/alpine
# https://mirrors.tuna.tsinghua.edu.cn/help/alpine/
&& log "updating apk repositories mirror" \
&& echo "@edgetesting https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&& sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
# && sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
&& cat /etc/apk/repositories \
\
# https://docs.alpinelinux.org/user-handbook/0.1a/Working/apk.html
# https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management
# https://wiki.alpinelinux.org/wiki/Comparison_with_other_distros#Comparison_chart.2FRosetta_Stone
# https://pkgs.alpinelinux.org
&& apps="tzdata alpine-conf bash curl iputils docker-cli git openjdk17 maven jq yq rclone npm py3-pip libc6-compat kubectl@edgetesting helm@edgetesting" \
&& log "installing $apps" \
&& apk add --no-cache $apps \
\
# https://wiki.alpinelinux.org/wiki/Alpine_setup_scripts#setup-timezone
&& log "setting timezone as 'Asia/Shanghai'" \
&& setup-timezone -z Asia/Shanghai \
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
# https://github.com/aliyun/aliyun-cli/releases
&& log "installing aliyun-cli" \
&& wget https://aliyuncli.alicdn.com/aliyun-cli-linux-latest-amd64.tgz -O- | tar xz && chown root:root aliyun && chmod 755 aliyun && mv aliyun /usr/local/bin/ \
\
&& log "cleaning all cache files" \
&& rm -rf ~/.ash_history ~/.cache/ ~/.config/ ~/.npm* ~/* /var/cache/apk/* /tmp/*

# HEALTHCHECK --timeout=1s --retries=1 CMD true || false

WORKDIR /root

ENV \
LANG=C.UTF-8 \
# PS1='\[\e[1;7;94m\] ?=$? $(. /etc/os-release && echo $ID-$VERSION_ID) \u@$(hostname -i)@\H:\w \[\e[0m\]\n\$ ' \
PS1='\[\e]0;\u@\h: \w\a\]\[\e[0m\]\[\e[1;97;41m\]$(r=$?; [ $r -ne 0 ] && echo " \\$?=$r ")\[\e[0m\]\[\e[1;97;43m\]$([ 1 -ne $SHLVL ] && echo " \\$SHLVL=$SHLVL ")\[\e[0m\]\[\e[3;37;100m\] $(source /etc/os-release && echo $ID-$VERSION_ID) \[\e[0m\]\[\e[95;40m\] \u\[\e[0m\]\[\e[1;35;40m\]$([ "$(id -ng)" != "$(id -nu)" ] && echo ":$(id -ng)")\[\e[0m\]\[\e[2;90;40m\]@\[\e[0m\]\[\e[3;32;40m\]$(hostname -i)\[\e[0m\]\[\e[2;90;40m\]@\[\e[0m\]\[\e[4;34;40m\]\H\[\e[0m\]\[\e[2;90;40m\]:\[\e[0m\]\[\e[1;33;40m\]$PWD \[\e[0m\]\n\[\e[0m\]\[\e[1;31m\]\$\[\e[0m\] '
CMD ["/bin/bash"]
