#!/bin/bash

# Installs Krew, the kubectl plugin manager
# https://krew.sigs.k8s.io/docs/user-guide/setup/install/

echo "Installing krew…"

# test if it exists
kubectl krew &> /dev/null

if (exit $?)
then
    echo 'Krew is already installed.';
    exit 0;
fi


set -x; cd "$(mktemp -d)" &&
    OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
    KREW="krew-${OS}_${ARCH}" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
    tar zxvf "${KREW}.tar.gz" &&
    ./"${KREW}" install krew
