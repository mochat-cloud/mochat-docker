#!/usr/bin/env bash

set -e

export ENGINE=${1}
export VERSION=${2}
export CHECK=${!#}
export TAGS="7.4-alpine-v3.9 7.4-alpine-v3.10 7.4-alpine-v3.11 7.4-alpine-v3.12"

function pull() {
    for TAG in ${TAGS}; do
        docker pull docker.pkg.github.com/hyperf/mochat-cloud/mochat-docker/hyperf:"${TAG}-${ENGINE}-${VERSION}"
        docker tag docker.pkg.github.com/hyperf/mochat-cloud/mochat-docker/hyperf:"${TAG}-${ENGINE}-${VERSION}" hyperf/hyperf:"${TAG}-${ENGINE}-${VERSION}"
    done
}

function push() {
    for TAG in ${TAGS}; do
        PV=${VERSION%\.*}
        PPV=${VERSION%%\.*}

        docker tag mochat/mochat:"${TAG}-${ENGINE}-${VERSION}" mochat/mochat:"${TAG}-${ENGINE}-${PV}"
        docker tag mochat/mochat:"${TAG}-${ENGINE}-${VERSION}" mochat/mochat:"${TAG}-${ENGINE}-${PPV}"
        docker tag mochat/mochat:"${TAG}-${ENGINE}-${VERSION}" mochat/mochat:"${TAG}-${ENGINE}"
        if [[ ${CHECK} != "--check" ]]; then
            echo "Publishing "${TAG}-${ENGINE}" ..."
            docker push mochat/mochat:"${TAG}-${ENGINE}"
            docker push mochat/mochat:"${TAG}-${ENGINE}-${PV}"
            docker push mochat/mochat:"${TAG}-${ENGINE}-${PPV}"
            docker push mochat/mochat:"${TAG}-${ENGINE}-${VERSION}"
            br
        fi
    done
}

function check() {
    if [[ ${CHECK} == "--check" ]]; then
        for TAG in ${TAGS}; do
            REALTAG=${TAG}-${ENGINE}-${VERSION}
            echo "Checking ${REALTAG}"
            version=`docker run mochat/mochat:$REALTAG php -v`
            echo $version | grep -Eo "PHP \d+\.\d+\.\d+"
            echo "Swoole: "
            swoole=`docker run mochat/mochat:$REALTAG php --ri swoole` && echo $swoole | grep -Eo "Version => \d+\.\d+\.\d+" || echo "No Swoole."
            echo "Swow: "
            swow=`docker run mochat/mochat:$REALTAG php --ri swow` && echo $swow | grep -Eo "Version => \d+\.\d+\.\d+" || echo "No Swow."
            br
        done
    fi
}

function br() {
    echo -e "\n"
}

if [[ ${ENGINE} != "" && ${VERSION} != "" ]]; then
    pull
    br
    check
    br
    push
fi

