#!/bin/bash

set -e

# https://github.com/kaushalmodi/hello_musl
wget 'https://raw.githubusercontent.com/kaushalmodi/hello_musl/master/config.nims' -O 'config.nims'

nim musl \
	--define:pcre \
	--define:openssl \
	--define:nimDisableCertificateValidation \
	'./src/unalixpkg/main.nim'

if ! [ -d './builds/linux-x86_64' ]; then
	mkdir --parent './builds/linux-x86_64'
fi

mv './src/unalixpkg/main' './builds/linux-x86_64/unalix-linux-x86_64'

echo "Build successful: $(realpath './builds/linux-x86_64/unalix-linux-x86_64')"
