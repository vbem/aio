#!/usr/bin/env bash

[ -v _KIT_BASH ] && return # avoid duplicated source
export _KIT_BASH # sourced sential

# Group stdin to stdout with title
# $1: group tile
# https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions#grouping-log-lines
function kit::wf::group {
    echo "::group::🎁 $1"; cat; echo "::endgroup::"
}

# Set stdin as value to environment with given name
# $1: environment variable name
# https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions#setting-an-environment-variable
function kit::wf::env {
    echo "$1<<__HEREDOC__" >> $GITHUB_ENV
    cat >> $GITHUB_ENV
    echo "__HEREDOC__" >> $GITHUB_ENV
}

# Set stdin as value to output of current step with given name
# $1: output name
# https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions#setting-an-output-parameter
# https://renehernandez.io/snippets/multiline-strings-as-a-job-output-in-github-actions/
function kit::wf::output {
    local val
    val=$(< /dev/stdin)
    echo "::set-output name=$1::$val"
    echo "$val" | kit::wf::group "📜 set-output '$1'"
}

# Flatten JSON to key-value lines
#   $1: separator (default as ' 👉 ')
function kit::json::flatten {
    jq -Mcr --arg sep "${1:- 👉 }" 'paths(type!="object" and type!="array") as $p | {"key":$p|join("."),"value":getpath($p)} | "\(.key)\($sep)\(.value|@json)"'
}
