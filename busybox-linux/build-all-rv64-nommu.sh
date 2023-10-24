#!/bin/bash

set -e

mkdir -p output
cd output

function set_build_state() {
    touch "state_${1}"
}

function check_build_state() {
    if [ -e "state_${1}" ];then
        return 1
    else
        return 0
    fi
}

check_build_state "download-busybox" && ../download-busybox.sh
set_build_state "download-busybox"

check_build_state "build-busybox" && fakeroot ../build-busybox-nommu-rv64.sh
set_build_state "build-busybox"

check_build_state "download-linux" && ../download-linux.sh
set_build_state "download-linux"

check_build_state "build-linux" && ../build-linux-nommu-rv64.sh
set_build_state "build-linux"
