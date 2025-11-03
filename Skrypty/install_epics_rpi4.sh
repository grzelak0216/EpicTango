#!/bin/bash
set -e

echo "==== Instalacja zależności ===="
sudo apt update
sudo apt install -y \
    git build-essential libreadline-dev libncurses-dev perl libexpat1-dev \
    libtool automake pkg-config libssl-dev flex bison \
    python3-dev python3-numpy python3-pip ca-certificates wget curl

echo "==== Instalacja pyepics i caproto ===="
pip3 install --user pyepics caproto

# Ścieżka główna
EPICS_ROOT=~/epics
mkdir -p "$EPICS_ROOT"/modules
cd "$EPICS_ROOT"

echo "==== Pobieranie i budowanie EPICS Base ===="
git clone --branch R7.0.8 https://github.com/epics-base/epics-base.git
cd epics-base
EPICS_HOST_ARCH=$(./startup/EpicsHostArch)
make -j$(nproc)

echo "==== Ustawianie zmiennych środowiskowych ===="
cat <<EOF >> ~/.bashrc

# EPICS Environment
export EPICS_ROOT=$EPICS_ROOT
export EPICS_BASE=\$EPICS_ROOT/epics-base
export EPICS_MODULES=\$EPICS_ROOT/modules
export PATH=\$EPICS_BASE/bin/$EPICS_HOST_ARCH:\$PATH
export LD_LIBRARY_PATH=\$EPICS_BASE/lib/$EPICS_HOST_ARCH:\$LD_LIBRARY_PATH
EOF
source ~/.bashrc

echo "==== Pobieranie i budowanie modułów: asyn, seq, stream ===="
cd "$EPICS_ROOT/modules"

# asyn
git clone https://github.com/epics-modules/asyn.git
cd asyn
make -j$(nproc)

# seq
cd "$EPICS_ROOT/modules"
git clone https://github.com/epics-modules/sequencer.git
cd sequencer
make -j$(nproc)

# stream
cd "$EPICS_ROOT/modules"
git clone https://github.com/paulscherrerinstitute/StreamDevice.git stream
cd stream
make -j$(nproc)

echo "==== Instalacja zakończona pomyślnie (Raspberry Pi) ===="
