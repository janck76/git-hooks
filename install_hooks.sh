#!/bin/bash - 

shopt -s extglob

function link_hook {
    if [[ ! -e ../.git/hooks/$1 ]]; then
        ln -s ../../.helpers/$1 ../.git/hooks/
    fi
}

pushd $(dirname $0) >/dev/null

for FILE in +(pre|post)-*; do
    link_hook $FILE
done

popd >/dev/null

