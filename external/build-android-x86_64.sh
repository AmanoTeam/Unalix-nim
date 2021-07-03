#!/bin/bash

set -e

OUT_JSON="${HOME}/.cache/nim/main_r/main.json"

export PATH="${PATH}:${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin"

export CFLAGS="-Wno-unused-command-line-argument -fPIC -DNO_SYSLOG -flto=full -fwhole-program-vtables -ffunction-sections -fdata-sections -L${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/x86_64-linux-android/31 -L${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/lib64 -I${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include -I${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/local/include"
export CCFLAGS="-Wno-unused-command-line-argument -fPIC -DNO_SYSLOG -flto=full -fwhole-program-vtables -ffunction-sections -fdata-sections -L${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/x86_64-linux-android/31 -L${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/lib64 -I${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include -I${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/local/include"
export CXXFLAGS="-Wno-unused-command-line-argument -fPIC -DNO_SYSLOG -flto=full -fwhole-program-vtables -ffunction-sections -fdata-sections -L${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/x86_64-linux-android/31 -L${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/lib64 -I${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include -I${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/local/include"
export LDFLAGS="-Wno-unused-command-line-argument -fPIC -DNO_SYSLOG -flto=full -fwhole-program-vtables -ffunction-sections -fdata-sections -L${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/x86_64-linux-android/31 -L${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/lib64 -I${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include -I${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/local/include"
export CPPFLAGS="-Wno-unused-command-line-argument -fPIC -DNO_SYSLOG -flto=full -fwhole-program-vtables -ffunction-sections -fdata-sections -L${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/x86_64-linux-android/31 -L${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/lib64 -I${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include -I${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/local/include"

export CC="${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/x86_64-linux-android31-clang"
export CXX="${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/x86_64-linux-android31-clang++"
export AR="${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-ar"
export AS="${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-as"
export LD="${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/ld"
export LIPO="${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-lipo"
export RANLIB="${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-ranlib"
export OBJCOPY="${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-objcopy"
export OBJDUMP="${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-objdump"
export STRIP="${ANDROID_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-strip"

# Build Pcre
if [ -d './pcre-8.45' ]; then
	cd './pcre-8.45'
	./configure --host 'x86_64-linux-android'
	make --jobs
	pcrePath="$(realpath './.libs/libpcre.a')"
	cd ..
else
	curl 'https://ftp.pcre.org/pub/pcre/pcre-8.45.tar.gz' | tar zxf -
	cd './pcre-8.45'
	./configure --host 'x86_64-linux-android'
	make --jobs
	pcrePath="$(realpath './.libs/libpcre.a')"
	cd ..
fi

if [ -d './openssl-1.1.1k' ]; then
	cd './openssl-1.1.1k'
	
	./Configure android-x86_64 \
		shared \
		zlib-dynamic \
		no-ssl \
		no-hw \
		no-srp \
		no-tests
	make --jobs all
	
	libcryptoPath="$(realpath 'libcrypto.a')"
	libsslPath="$(realpath 'libssl.a')"
	
	cd ..
else
	curl 'https://www.openssl.org/source/openssl-1.1.1k.tar.gz' | tar zxf -
	cd './openssl-1.1.1k'
	
	curl -L 'https://github.com/termux/termux-packages/raw/master/packages/openssl/Configurations-15-android.conf.patch' | patch -p 01
	curl -L 'https://github.com/termux/termux-packages/raw/master/packages/openssl/apps-ocsp.c.patch' | patch -p 01
	curl -L 'https://github.com/termux/termux-packages/raw/master/packages/openssl/crypto-armcap.c.patch' | patch -p 01
	curl -L 'https://github.com/termux/termux-packages/raw/master/packages/openssl/e_os.h.patch' | patch -p 01
	
	./Configure android-x86_64 \
		shared \
		zlib-dynamic \
		no-ssl \
		no-hw \
		no-srp \
		no-tests
	make --jobs all
	
	libcryptoPath="$(realpath 'libcrypto.a')"
	libsslPath="$(realpath 'libssl.a')"
	
	cd ..
fi

nim compile \
	--compileOnly:on \
	--os:android \
	--cpu:amd64 \
	--define:release \
	--define:ssl \
	--define:nimDisableCertificateValidation \
	--dynlibOverride:libssl \
	--dynlibOverride:libcrypto \
	--dynlibOverride:libpcre \
	--opt:size \
	--passC:-flto=full \
	--passC:-fPIC \
	--passC:-fwhole-program-vtables \
	--passC:-ffunction-sections \
	--passC:-data-sections \
	--passL:-flto=full \
	--passL:-fPIC \
	--passL:-fwhole-program-vtables \
	--passL:-ffunction-sections \
	--passL:-data-sections \
	--passL:-static \
	--passL:"${pcrePath}" \
	--passL:"${libcryptoPath}" \
	--passL:"${libsslPath}" \
	--gcc.exe:"${CC}" \
	--gcc.linkerexe:"${CC}" \
	'./src/unalixpkg/main.nim'

jq -r '.compile[][1]' "${OUT_JSON}" | awk "{sub(\"clang\",\"${CC}\")} 1" > build.sh
jq -r '.linkcmd' "${OUT_JSON}" | awk "{sub(\"clang\",\"${CC}\")} 1" >> build.sh

bash './build.sh'

"${STRIP}"  --discard-all --strip-all './src/unalixpkg/main'

if ! [ -d './builds/android-x86_64' ]; then
	mkdir --parent './builds/android-x86_64'
fi

mv './src/unalixpkg/main' './builds/android-x86_64/unalix-android-x86_64'

for directory in 'pcre-8.45' 'openssl-1.1.1k'; do
	cd "${directory}"
	make clean
	cd ..
done

rm --recursive "$(dirname ${OUT_JSON})"

echo "Build successful: $(realpath './builds/android-x86_64/unalix-android-x86_64')"
