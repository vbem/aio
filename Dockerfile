# syntax=docker/dockerfile:1
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# https://alpinelinux.org/
# https://hub.docker.com/_/alpine
FROM alpine:3.15 AS fresh

RUN function log { echo -e "\e[7;36m$(date +%F_%T)\e[0m\e[1;96m $*\e[0m" > /dev/stderr ; } \
\
# https://wiki.alpinelinux.org/wiki/Alpine_setup_scripts#setup-apkrepos
# https://mirrors.alpinelinux.org/
# https://developer.aliyun.com/mirror/alpine
# https://mirrors.tuna.tsinghua.edu.cn/help/alpine/
&& log "updating apk repositories mirror" \
&& echo "@edgetesting https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
# && sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
&& sed -i 's/dl-cdn.alpinelinux.org/mirrors.cloud.tencent.com/g' /etc/apk/repositories \
# && sed -i 's/dl-cdn.alpinelinux.org/repo.huaweicloud.com/g' /etc/apk/repositories \
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
&& log "setting pip mirror" \
&& echo -e '[global]\nindex-url=https://mirrors.aliyun.com/pypi/simple/\ntrusted-host=mirrors.aliyun.com' > /etc/pip.conf \
\
# https://github.com/aliyun/aliyun-cli/releases
&& log "installing latest aliyun-cli" \
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
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
FROM fresh AS tester
RUN function log { echo -e "\e[7;36m$(date +%F_%T)\e[0m\e[1;96m $*\e[0m" > /dev/stderr ; } \
\
&& log "Test APK repositories" \
&& cat /etc/apk/repositories\
\
&& log "Test timezone" \
&& readlink -vf /etc/localtime \
\
&& log "Test bash" \
&& bash --version \
\
&& log "Test curl" \
&& curl --version \
\
&& log "Test ping" \
&& ping -V \
\
&& log "Test docker-cli" \
&& docker --version \
\
&& log "Test git" \
&& git --version \
\
&& log "Test openjdk17" \
&& javac --version \
\
&& log "Test maven" \
&& maven --version \
\
&& log "Test jq" \
&& jq --version \
\
&& log "Test yq" \
&& yq --version \
\
&& log "Test rclone" \
&& rclone --version \
\
&& log "Test nodejs" \
&& node --version \
\
&& log "Test npm" \
&& npm --version \
\
&& log "Test npm repositories" \
&& npm config list \
\
&& log "Test python3" \
&& python3 --version \
\
&& log "Test pip" \
&& pip --version \
\
&& log "Test pip mirrors" \
&& pip config list \
\
&& log "Test kubectl" \
&& kubectl version --client \
\
&& log "Test helm" \
&& helm --version \
\
&& log "Test aliyun-cli" \
&& aliyun --help \
\
&& log "Passed all test cases!"
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
FROM fresh AS output
