#!/bin/bash -e

. ../../include/path.sh

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf _build$ndk_suffix
	exit 0
else
	exit 255
fi

mkdir -p _build$ndk_suffix
cd _build$ndk_suffix

extra=
[[ "$ndk_vvdec" == "armeabi-v7a"* ]] && extra="-DANDROID_ARM_NEON=TRUE"

cmake \
       -DCMAKE_BUILD_TYPE=Release -DANDROID_ABI=$ndk_vvdec \
	    -DCMAKE_TOOLCHAIN_FILE=${HOME}/mpv-android-vvc/buildscripts/sdk/android-ndk-r26c/build/cmake/android.toolchain.cmake \
		-DANDROID_STL=c++_shared -DVVDEC_ENABLE_LINK_TIME_OPT=OFF -DANDROID_PLATFORM=android-21 \
	    -DCMAKE_INSTALL_PREFIX=$prefix_dir $extra ..

cmake --build . --config release -j$cores
cmake --build . --target install
