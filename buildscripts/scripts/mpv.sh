#!/bin/bash -e

. ../../include/path.sh

build=_build$ndk_suffix

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf $build
	exit 0
else
	exit 255
fi

unset CC CXX # meson wants these unset

if [ ! -f mpv-vvceasy1.patch ]; then
    wget https://raw.githubusercontent.com/MartinEesmaa/mpv-winbuild-cmake/master/packages/mpv-vvceasy1.patch
    git apply mpv-vvceasy1.patch
else
    if git apply --check mpv-vvceasy1.patch 2>/dev/null; then
        :
    else
        git apply mpv-vvceasy1.patch
    fi
fi

meson setup $build --cross-file "$prefix_dir"/crossfile.txt \
	--default-library shared \
	-Diconv=disabled -Dlua=enabled \
	-Dlibmpv=true -Dcplayer=false \
	-Dmanpage-build=disabled

ninja -C $build -j$cores
if [ -f $build/libmpv.a ]; then
	echo >&2 "Meson fucked up, forcing rebuild."
	$0 clean
	exec $0 build
fi
DESTDIR="$prefix_dir" ninja -C $build install
