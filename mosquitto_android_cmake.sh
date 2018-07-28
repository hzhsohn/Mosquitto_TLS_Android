#!/bin/bash
# Script used to cmake and then make mosquitto for android on MacOSX with android-ndk-r8e and a patched mosquitto source.
# Update paths below and run it from inside the root mosquitto dir (right in the one you clone from hg)

# Used patched mosquitto from: https://bitbucket.org/andreasjk/mosquitto
# Used NDK: http://dl.google.com/android/ndk/android-ndk-r8e-darwin-x86_64.tar.bz2
# Used cmake toolchain file from https://github.com/Itseez/opencv/blob/master/android/android.toolchain.cmake

# Threading has to be disabled since android doesn't support it fully
# Also disabled TLS since I couldn't get cmake to find the openssl lib properly

#参数设在这里,支持的NDK版本有r5-r10d
CURRENT_DIR=$(dirname $(readlink -f $0))
ANDROID_NDK=${ANDROID_NDK_R9D}
ANDROID_ABI="armeabi-v7a"
ANDROID_TOOLCHAIN="arm-linux-androideabi-4.8"

#显示参数
echo "
--------------------------------
--
--
mosquitto cmake CURRENT_DIR="${CURRENT_DIR}"
                ANDROID_NDK="${ANDROID_NDK}"
                ANDROID_TOOLCHAIN="${ANDROID_TOOLCHAIN}"
--
--
"


rm -rf mosquitto/build
mkdir -p mosquitto/build
cd mosquitto/build
cmake \
   -DANDROID_NDK=${ANDROID_NDK} \
   -DANDROID_ABI=${ANDROID_ABI} \
   -DANDROID_NDK_HOST_X64="YES" \
   -DANDROID_NATIVE_API_LEVEL=19 \
   -DANDROID_TOOLCHAIN_NAME=${ANDROID_TOOLCHAIN} \
   -DCMAKE_TOOLCHAIN_FILE="${CURRENT_DIR}/android-cmake/android.toolchain.cmake" \
   -DOPENSSL_LIBRARIES="${CURRENT_DIR}/openssl/arch-${ANDROID_ABI}/lib" \
   -DOPENSSL_INCLUDE_DIR="${CURRENT_DIR}/openssl/sources/include" \
   -DWITH_TLS=ON \
   -DWITH_THREADING=OFF ..
echo "Start building android ..."
make
echo "Output file `pwd`"
cd ..