#!/bin/bash -e

. ./include/depinfo.sh

[ -z "$TRAVIS" ] && TRAVIS=0
[ -z "$WGET" ] && WGET=wget

mkdir -p deps && cd deps

# libxml2
if [ ! -d libxml2 ]; then
	mkdir libxml2
	$WGET ftp://xmlsoft.org/libxml2/libxml2-2.9.12.tar.gz -O - | \
		tar -xz -C libxml2 --strip-components=1
fi

# vvdec
if [ ! -d vvdec ]; then
	git clone https://github.com/fraunhoferhhi/vvdec vvdec
fi

# fdk-aac
if [ ! -d fdk-aac ]; then
	git clone https://github.com/mstorsjo/fdk-aac fdk-aac
fi

# mbedtls
if [ ! -d mbedtls ]; then
	mkdir mbedtls
	$WGET https://github.com/ARMmbed/mbedtls/archive/mbedtls-$v_mbedtls.tar.gz -O - | \
		tar -xz -C mbedtls --strip-components=1
fi

# dav1d
[ ! -d dav1d ] && git clone https://code.videolan.org/videolan/dav1d.git --branch 0.8.2

# ffmpeg
if [ ! -d ffmpeg ]; then
	# git clone https://github.com/FFmpeg/FFmpeg ffmpeg
	git clone https://github.com/tbiat/FFmpeg ffmpeg
	[ $TRAVIS -eq 1 ] && ( cd ffmpeg; git checkout $v_travis_ffmpeg )
fi

# freetype2
[ ! -d freetype2 ] && git clone git://git.sv.nongnu.org/freetype/freetype2.git -b VER-$v_freetype

# fribidi
if [ ! -d fribidi ]; then
	mkdir fribidi
	$WGET https://github.com/fribidi/fribidi/releases/download/v$v_fribidi/fribidi-$v_fribidi.tar.xz -O - | \
		tar -xJ -C fribidi --strip-components=1
fi

# harfbuzz
if [ ! -d harfbuzz ]; then
	mkdir harfbuzz
	$WGET https://github.com/harfbuzz/harfbuzz/releases/download/$v_harfbuzz/harfbuzz-$v_harfbuzz.tar.xz -O - | \
		tar -xJ -C harfbuzz --strip-components=1
fi

# libass
[ ! -d libass ] && git clone https://github.com/libass/libass

# lua
if [ ! -d lua ]; then
	mkdir lua
	$WGET http://www.lua.org/ftp/lua-$v_lua.tar.gz -O - | \
		tar -xz -C lua --strip-components=1
fi

# mpv
[ ! -d mpv ] && git clone https://github.com/mpv-player/mpv

cd ..
