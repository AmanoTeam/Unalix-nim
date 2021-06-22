declare -r temporary_directory="$(mktemp --directory)"

declare -r pcre_url='https://ftp.pcre.org/pub/pcre/pcre-8.45.tar.bz2'
declare -r pcre_output='pcre.tar.bz2'
declare -r pcre_directory='pcre-8.45'

declare -r ndk_url='https://dl.google.com/android/repository/android-ndk-r23-beta5-linux.zip'
declare -r ndk_output='ndk.zip'
declare -r ndk_directory='android-ndk-r23-beta5'

declare -r ndk_sysroot="${temporary_directory}/${ndk_directory}/toolchains/llvm/prebuilt/linux-x86_64/sysroot"

declare -r llvm_strip="${ndk_directory}/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-strip"

declare -r armv7a_clang="${temporary_directory}/${ndk_directory}/toolchains/llvm/prebuilt/linux-x86_64/bin/armv7a-linux-androideabi31-clang"
declare -r armv7a_clangpp="${temporary_directory}/${ndk_directory}/toolchains/llvm/prebuilt/linux-x86_64/bin/armv7a-linux-androideabi31-clang++"
declare -r armv7a_host='armv7a-linux-androideabi'

declare -r aarch64_clang="${temporary_directory}/${ndk_directory}/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android31-clang"
declare -r aarch64_clangpp="${temporary_directory}/${ndk_directory}/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android31-clang++"
declare -r aarch64_host='aarch64-linux-androideabi'

declare -r i686_clang="${temporary_directory}/${ndk_directory}/toolchains/llvm/prebuilt/linux-x86_64/bin/i686-linux-android31-clang"
declare -r i686_clangpp="${temporary_directory}/${ndk_directory}/toolchains/llvm/prebuilt/linux-x86_64/bin/i686-linux-android31-clang++"
declare -r i686_host='i686-linux-androideabi'

declare -r x86_64_clang="${temporary_directory}/${ndk_directory}/toolchains/llvm/prebuilt/linux-x86_64/bin/x86_64-linux-android31-clang"
declare -r x86_64_clangpp="${temporary_directory}/${ndk_directory}/toolchains/llvm/prebuilt/linux-x86_64/bin/x86_64-linux-android31-clang++"
declare -r x86_64_host='x86_64-linux-androideabi'

declare -r choosenim_url='https://nim-lang.org/choosenim/init.sh'
declare -r choosenim_output='choosenim.sh'

declare -r nim_exec="${HOME}/.nimble/bin/nim"
declare -r choosenim_exec="${HOME}/.nimble/bin/choosenim"

declare -r musl_exec="${temporary_directory}/gcc/bin/musl-gcc"

cd "${temporary_directory}"

# Clone Unalix
git clone --depth '1' \
	'https://github.com/AmanoTeam/Unalix-nim.git'

# Extract NDK
wget "${ndk_url}" -O "${ndk_output}"
unzip "${ndk_output}"

# Setup Nim devel
wget "${choosenim_url}" -O "${choosenim_output}"
bash "${choosenim_output}"
"${choosenim_exec}" 'devel'

# Download PCRE
wget "${pcre_url}" -O "${pcre_output}"

tar xf "${pcre_output}"
cd "${pcre_directory}"

# Compile PCRE for armv7a-linux-androideabi
env CFLAGS='-flto=full -fwhole-program-vtables -ffunction-sections -fdata-sections' CCFLAGS='-flto=full -fwhole-program-vtables -ffunction-sections -fdata-sections' ./configure --with-sysroot="${ndk_sysroot}" \
	CC="${armv7a_clang}" \
	CXX="${armv7a_clangpp}" \
	--host "${armv7a_host}"

make --jobs

cp 'pcre.h' '../Unalix-nim/src/unalixpkg/'

cd ..

json_file=$("${nim_exec}" compile \
	--verbosity:3 \
	--compileOnly:on \
	--os:android \
	--cpu:arm \
	--define:release \
	--define:usePcreHeader \
	--opt:size \
	--passC:-flto=full \
	--passC:-fwhole-program-vtables \
	--passC:-ffunction-sections \
	--passC:-data-sections \
	--passL:-flto=full \
	--passL:-fwhole-program-vtables \
	--passL:-ffunction-sections \
	--passL:-data-sections \
	--passL:-static \
	--passL:"${temporary_directory}/${pcre_directory}/.libs/libpcre.a" \
	--gcc.exe:"${armv7a_clang}" \
	--gcc.linkerexe:"${armv7a_clang}" \
	'./Unalix-nim/src/unalixpkg/main.nim' 2>&1 \
	| grep  --only-matching --extended-regexp "${HOME}.+/main.json\s" | sed -r 's/\s//g')

jq -r '.compile[][1]' "${json_file}" | awk "{sub(\"clang\",\"${armv7a_clang}\")} 1" > build.sh
jq -r '.linkcmd' "${json_file}" | awk "{sub(\"clang\",\"${armv7a_clang}\")} 1" >> build.sh

bash './build.sh'

cp $(jq -r '.outputFile' "${json_file}") "unalix-cli-${armv7a_host}"
chmod 777 "unalix-cli-${armv7a_host}"

"${llvm_strip}" --discard-all --strip-all "unalix-cli-${armv7a_host}"

cd "${pcre_directory}"

make clean

# Compile PCRE for aarch64-linux-androideabi
env CFLAGS='-flto=full -fwhole-program-vtables -ffunction-sections -fdata-sections' CCFLAGS='-flto=full -fwhole-program-vtables -ffunction-sections -fdata-sections' ./configure --with-sysroot="${ndk_sysroot}" \
	CC="${aarch64_clang}" \
	CXX="${aarch64_clangpp}" \
	--host "${aarch64_host}"

make --jobs

cd ..

json_file=$("${nim_exec}" compile \
	--verbosity:3 \
	--compileOnly:on \
	--os:android \
	--cpu:arm64 \
	--define:release \
	--define:usePcreHeader \
	--opt:size \
	--passC:-flto=full \
	--passC:-fwhole-program-vtables \
	--passC:-ffunction-sections \
	--passC:-data-sections \
	--passL:-flto=full \
	--passL:-fwhole-program-vtables \
	--passL:-ffunction-sections \
	--passL:-data-sections \
	--passL:-static \
	--passL:"${temporary_directory}/${pcre_directory}/.libs/libpcre.a" \
	--gcc.exe:"${aarch64_clang}" \
	--gcc.linkerexe:"${aarch64_clang}" \
	'./Unalix-nim/src/unalixpkg/main.nim' 2>&1 \
	| grep  --only-matching --extended-regexp "${HOME}.+/main.json\s" | sed -r 's/\s//g')

jq -r '.compile[][1]' "${json_file}" | awk "{sub(\"clang\",\"${aarch64_clang}\")} 1" > build.sh
jq -r '.linkcmd' "${json_file}" | awk "{sub(\"clang\",\"${aarch64_clang}\")} 1" >> build.sh

bash './build.sh'

cp $(jq -r '.outputFile' "${json_file}") "unalix-cli-${aarch64_host}"
chmod 777 "unalix-cli-${aarch64_host}"

"${llvm_strip}" --discard-all --strip-all "unalix-cli-${aarch64_host}"

cd "${pcre_directory}"

make clean

# Compile PCRE for i686-linux-androideabi
env CFLAGS='-flto=full -fwhole-program-vtables -ffunction-sections -fdata-sections' CCFLAGS='-flto=full -fwhole-program-vtables -ffunction-sections -fdata-sections' ./configure --with-sysroot="${ndk_sysroot}" \
	CC="${i686_clang}" \
	CXX="${i686_clangpp}" \
	--host "${i686_host}"

make --jobs

cd ..

json_file=$("${nim_exec}" compile \
	--verbosity:3 \
	--compileOnly:on \
	--os:android \
	--cpu:i386 \
	--define:release \
	--define:usePcreHeader \
	--opt:size \
	--passC:-flto=full \
	--passC:-fwhole-program-vtables \
	--passC:-ffunction-sections \
	--passC:-data-sections \
	--passL:-flto=full \
	--passL:-fwhole-program-vtables \
	--passL:-ffunction-sections \
	--passL:-data-sections \
	--passL:-static \
	--passL:"${temporary_directory}/${pcre_directory}/.libs/libpcre.a" \
	--gcc.exe:"${i686_clang}" \
	--gcc.linkerexe:"${i686_clang}" \
	'./Unalix-nim/src/unalixpkg/main.nim' 2>&1 \
	| grep  --only-matching --extended-regexp "${HOME}.+/main.json\s" | sed -r 's/\s//g')

jq -r '.compile[][1]' "${json_file}" | awk "{sub(\"clang\",\"${i686_clang}\")} 1" > build.sh
jq -r '.linkcmd' "${json_file}" | awk "{sub(\"clang\",\"${i686_clang}\")} 1" >> build.sh

bash './build.sh'

cp $(jq -r '.outputFile' "${json_file}") "unalix-cli-${i686_host}"
chmod 777 "unalix-cli-${i686_host}"

"${llvm_strip}" --discard-all --strip-all "unalix-cli-${i686_host}"

cd "${pcre_directory}"

make clean

# Compile PCRE for x86_64-linux-androideabi
env CFLAGS='-flto=full -fwhole-program-vtables -ffunction-sections -fdata-sections' CCFLAGS='-flto=full -fwhole-program-vtables -ffunction-sections -fdata-sections' ./configure --with-sysroot="${ndk_sysroot}" \
	CC="${x86_64_clang}" \
	CXX="${x86_64_clangpp}" \
	--host "${x86_64_host}"

make --jobs

cd ..

json_file=$("${nim_exec}" compile \
	--verbosity:3 \
	--compileOnly:on \
	--os:android \
	--cpu:amd64 \
	--define:release \
	--define:usePcreHeader \
	--opt:size \
	--passC:-flto=full \
	--passC:-fwhole-program-vtables \
	--passC:-ffunction-sections \
	--passC:-data-sections \
	--passL:-flto=full \
	--passL:-fwhole-program-vtables \
	--passL:-ffunction-sections \
	--passL:-data-sections \
	--passL:-static \
	--passL:"${temporary_directory}/${pcre_directory}/.libs/libpcre.a" \
	--gcc.exe:"${x86_64_clang}" \
	--gcc.linkerexe:"${x86_64_clang}" \
	'./Unalix-nim/src/unalixpkg/main.nim' 2>&1 \
	| grep  --only-matching --extended-regexp "${HOME}.+/main.json\s" | sed -r 's/\s//g')

jq -r '.compile[][1]' "${json_file}" | awk "{sub(\"clang\",\"${x86_64_clang}\")} 1" > build.sh
jq -r '.linkcmd' "${json_file}" | awk "{sub(\"clang\",\"${x86_64_clang}\")} 1" >> build.sh

bash './build.sh'

cp $(jq -r '.outputFile' "${json_file}") "unalix-cli-${x86_64_host}"
chmod 777 "unalix-cli-${x86_64_host}"

"${llvm_strip}" --discard-all --strip-all "unalix-cli-${x86_64_host}"

git clone 'git://git.musl-libc.org/musl' \
	--depth '1'

cd './musl'

./configure --prefix="${temporary_directory}/gcc"
make --jobs
make install
cd ..

cd "${pcre_directory}"

make clean

# Compile PCRE for x86_64-unknown-linux-gnu
./configure CC="${musl_exec}" \
	--host 'x86_64-unknown-linux-gnu'

make --jobs

cd ..

"${nim_exec}" compile \
	--verbosity:3 \
	--os:linux \
	--cpu:amd64 \
	--define:release \
	--define:usePcreHeader \
	--passL:-static \
	--passL:"${temporary_directory}/${pcre_directory}/.libs/libpcre.a" \
	--gcc.exe:${musl_exec} \
	--gcc.linkerexe:${musl_exec} \
	'./Unalix-nim/src/unalixpkg/main.nim'

cp './Unalix-nim/src/unalixpkg/main' 'unalix-cli-x86_64-unknown-linux-gnu'
chmod 777 'unalix-cli-x86_64-unknown-linux-gnu'

strip --strip-all 'unalix-cli-x86_64-unknown-linux-gnu'