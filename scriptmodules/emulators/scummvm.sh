#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="scummvm"
rp_module_desc="ScummVM - Virtual Machine for Graphical Point-and-Click Adventure Games"
rp_module_help="Copy your ScummVM games to $romdir/scummvm"
rp_module_licence="GPL2 https://raw.githubusercontent.com/scummvm/scummvm/master/COPYING"
rp_module_repo="git https://github.com/scummvm/scummvm.git v2.2.0"
rp_module_section="opt"
rp_module_flags="sdl2"

function depends_scummvm() {
    local depends=(
        'a52dec'
        'faad2'
        'flac'
        'fluidsynth'
        'freetype2'
        'libjpeg-turbo'
        'libmad'
        'libmpeg2'
        'libpng'
        'libspeechd'
        'libtheora'
        'libvorbis'
    )
    if [[ "$md_id" == "scummvm-sdl1" ]]; then
        depends+=('sdl' 'sdl_net')
    else
        depends+=('sdl2' 'sdl2_net')
    fi
    getDepends "${depends[@]}"
}

function sources_scummvm() {
    gitPullOrClone
    local patches=(
        'https://github.com/scummvm/scummvm/pull/2729.patch'
        'https://github.com/scummvm/scummvm/commit/a3bc5d64b8c4041326c8a214c47f9a206fb8b693.patch'
        'https://github.com/scummvm/scummvm/commit/6ef406ac20a68f53e66bb98a0c9842dc9553da07.patch'
        'https://github.com/scummvm/scummvm/pull/2915.patch'
    )
    for patch in "${patches[@]}"; do
        download "$patch" "$md_build" | applyPatch "$md_build/${patch##*/}"
    done
}

function build_scummvm() {
    local params=(
        --enable-release
        --enable-vkeybd
        --disable-debug
        --disable-eventrecorder
        --prefix="$md_inst"
        --enable-all-engines
    )
    isPlatform "rpi" && isPlatform "32bit" && params+=(--host=raspberrypi)
    isPlatform "gles" && params+=(--opengl-mode=gles2)
    # stop scummvm using arm-linux-gnueabihf-g++ which is v4.6 on
    # wheezy and doesn't like rpi2 cpu flags
    if isPlatform "rpi"; then
        CC="gcc" CXX="g++" ./configure "${params[@]}"
    else
        ./configure "${params[@]}"
    fi
    make clean
    make
    strip "$md_build/scummvm"
    md_ret_require="$md_build/scummvm"
}

function install_scummvm() {
    make install
    mkdir -p "$md_inst/extra"
    cp -v backends/vkeybd/packs/vkeybd_*.zip "$md_inst/extra"
}

function configure_scummvm() {
    mkRomDir "scummvm"

    local dir
    for dir in .config .local/share; do
        moveConfigDir "$home/$dir/scummvm" "$md_conf_root/scummvm"
    done

    # Create startup script
    rm -f "$romdir/scummvm/+Launch GUI.sh"
    local name="ScummVM"
    [[ "$md_id" == "scummvm-sdl1" ]] && name="ScummVM-SDL1"
    cat > "$romdir/scummvm/+Start $name.sh" << _EOF_
#!/bin/bash
game="\$1"
pushd "$romdir/scummvm" >/dev/null
$md_inst/bin/scummvm --fullscreen --joystick=0 --extrapath="$md_inst/extra" \$game
while read id desc; do
    echo "\$desc" > "$romdir/scummvm/\$id.svm"
done < <($md_inst/bin/scummvm --list-targets | tail -n +3)
popd >/dev/null
_EOF_
    chown $user:$user "$romdir/scummvm/+Start $name.sh"
    chmod u+x "$romdir/scummvm/+Start $name.sh"

    addEmulator 1 "$md_id" "scummvm" "bash $romdir/scummvm/+Start\ $name.sh %BASENAME%"
    addSystem "scummvm"
}
