#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="scummvm-sdl1"
rp_module_desc="ScummVM Legacy SDL1 Version"
rp_module_help="Copy your ScummVM games to $romdir/scummvm"
rp_module_licence="GPL2 https://raw.githubusercontent.com/scummvm/scummvm/master/COPYING"
rp_module_repo="git https://github.com/scummvm/scummvm.git v2.2.0"
rp_module_section="opt"
rp_module_flags="sdl1 !mali !x11"

function depends_scummvm-sdl1() {
    depends_scummvm
}

function sources_scummvm-sdl1() {
    # sources_scummvm() expects $md_data to be ../scummvm
    # the following only modifies $md_data for the function call
    md_data="$(dirname $md_data)/scummvm" sources_scummvm
    if isPlatform "rpi"; then
        if isPlatform "kms"; then
            applyPatch "$md_data/01_rpi_kms_sdl1.diff"
        else
            applyPatch "$md_data/01_rpi_sdl1.diff"
        fi
    fi
}

function build_scummvm-sdl1() {
    build_scummvm
}

function install_scummvm-sdl1() {
    install_scummvm
}

function configure_scummvm-sdl1() {
    # use dispmanx by default on rpi with fkms
    isPlatform "dispmanx" && ! isPlatform "videocore" && setBackend "$md_id" "dispmmanx"
    configure_scummvm
}
