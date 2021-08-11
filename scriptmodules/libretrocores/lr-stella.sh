#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="lr-stella"
rp_module_desc="Atari 2600 Libretro Core"
rp_module_help="ROM Extensions: .a26 .bin .rom .zip .gz\n\nCopy Your Atari 2600 ROMs to $romdir/atari2600"
rp_module_licence="GPL2 https://raw.githubusercontent.com/stella-emu/stella/master/License.txt"
rp_module_repo="git https://github.com/stella-emu/stella master"
rp_module_section="libretrocores"

function sources_lr-stella() {
    gitPullOrClone
}

function build_lr-stella() {
    cd src/libretro
    make clean
    make
    md_ret_require="$md_build/stella_libretro.so"
}

function install_lr-stella() {
    md_ret_files=(
        'README.md'
        'src/libretro/stella_libretro.so'
        'stella/license.txt'
    )
}

function configure_lr-stella() {
    mkRomDir "atari2600"

    ensureSystemretroconfig "atari2600"

    addEmulator 1 "$md_id" "atari2600" "$md_inst/stella_libretro.so"
    addSystem "atari2600"
}
