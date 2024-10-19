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

[ -f configure ] || ./autogen.sh

mkdir -p $build
cd $build

extra=
[[ "$ndk_triple" == "i686"* ]] && extra="--disable-asm"

../configure \
	--host=$ndk_triple $extra \
	--enable-shared --disable-static \
	--disable-require-system-font-provider

make -j$cores
make DESTDIR="$prefix_dir" install
