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

mkdir -p $build
cd $build

extra=
[[ "$ndk_vvdec" == "armeabi-v7a"* ]] && extra="-DANDROID_ARM_NEON=TRUE"

cmake \
       -DCMAKE_BUILD_TYPE=Release -DANDROID_ABI=$ndk_vvdec \
	    -DCMAKE_TOOLCHAIN_FILE=${HOME}/mpv-android-vvc/buildscripts/sdk/android-ndk-$v_ndk/build/cmake/android.toolchain.cmake \
		-DBUILD_SHARED_LIBS=ON -DANDROID_PLATFORM=android-21 -DLIBXML2_WITH_PYTHON=OFF -DIconv_LIBRARY=$prefix_dir/$prefix_name/lib \
	    -DCMAKE_INSTALL_PREFIX=$prefix_dir $extra ..

cmake --build . --config release -j$cores
cmake --build . --target install
