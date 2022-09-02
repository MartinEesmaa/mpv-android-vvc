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
       -DCMAKE_BUILD_TYPE=Release -DCMAKE_SYSTEM_NAME=Android -DCMAKE_ANDROID_ARCH_ABI=$ndk_vvdec \
	    -DCMAKE_TOOLCHAIN_FILE=${HOME}/mpv-android-vvc/buildscripts/sdk/android-ndk-r25/build/cmake/android-legacy.toolchain.cmake \
		-DANDROID_STL=c++_shared -DANDROID_PLATFORM=android-$MINSDKVERSION \
	    -DCMAKE_INSTALL_PREFIX=$prefix_dir $extra ..

cmake --build . --config release -j$cores
cmake --build . --target install