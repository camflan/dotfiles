#!/bin/bash

# Installs pkl
# https://pkl-lang.org/main/current/pkl-cli/index.html#download

VERSION=0.25.1
PLATFORM=aarch64
INSTALL_PATH=/usr/local/bin

echo "Installing pkl…"

# test if it exists
pkl --version &> /dev/null

if (exit $?)
then
    echo "Pkl $VERSION is already installed.";
    exit 0;
fi

BINARY_URL="https://github.com/apple/pkl/releases/download/$VERSION/pkl-macos-$PLATFORM"

set -x; cd "$(mktemp -d)" &&
    curl -L -o pkl $BINARY_URL &&
    chmod +x pkl &&
    sudo mv pkl $INSTALL_PATH/pkl
