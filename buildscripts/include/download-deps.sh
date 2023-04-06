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

# fdkaac
if [ ! -d fdkaac ]; then
	git clone https://github.com/mstorsjo/fdk-aac fdkaac
fi

# libopus
if [ ! -d opus ]; then
	git clone https://github.com/xiph/opus opus
fi

# mbedtls
if [ ! -d mbedtls ]; then
	mkdir mbedtls
	$WGET https://github.com/ARMmbed/mbedtls/archive/mbedtls-$v_mbedtls.tar.gz -O - | \
		tar -xz -C mbedtls --strip-components=1
fi

# dav1d
[ ! -d dav1d ] && git clone https://github.com/videolan/dav1d

# ffmpeg
if [ ! -d ffmpeg ]; then
	git clone https://github.com/MartinEesmaa/FFmpeg-FixVVC ffmpeg
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

# youtube-dl
$WGET https://kitsunemimi.pw/ytdl/dist.zip
unzip dist.zip -d ../app/src/main/assets/ytdl
rm -f ../app/src/main/assets/ytdl/youtube-dl # don't need it
rm dist.zip
