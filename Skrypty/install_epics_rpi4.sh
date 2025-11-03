#!/bin/bash
set -e

echo "==== Instalacja zależności ===="
sudo apt update
sudo apt install -y \
    git build-essential libreadline-dev libncurses-dev perl libexpat1-dev \
    libtool automake pkg-config libssl-dev flex bison \
    python3-dev python3-numpy python3-pip python3-venv \
    ca-certificates wget curl

echo "==== Tworzenie środowiska Pythona ===="
python3 -m venv ~/epics-venv
source ~/epics-venv/bin/activate
pip install pyepics caproto

# Ścieżka główna
EPICS_ROOT=~/epics
mkdir -p "$EPICS_ROOT"/modules
cd "$EPICS_ROOT"

echo "==== Pobieranie i budowanie EPICS Base ===="
if [ ! -d epics-base ]; then
    git clone --branch R7.0.8 https://github.com/epics-base/epics-base.git
fi

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
source ~/epics-venv/bin/activate
EOF
source ~/.bashrc

# funkcja do poprawiania RELEASE
fix_release() {
    local dir="$1/configure/RELEASE"
    if [ -f "$dir" ]; then
        sed -i "s|^EPICS_BASE *=.*|EPICS_BASE = $EPICS_ROOT/epics-base|" "$dir"
    fi
}

echo "==== Pobieranie i budowanie modułów: asyn, seq, stream ===="
cd "$EPICS_ROOT/modules"

# asyn
if [ ! -d asyn ]; then
    git clone https://github.com/epics-modules/asyn.git
fi
fix_release asyn
cd asyn
make -j$(nproc)

# seq
cd "$EPICS_ROOT/modules"
if [ ! -d sequencer ]; then
    git clone https://github.com/epics-modules/sequencer.git
fi
fix_release sequencer
cd sequencer
make -j$(nproc)

# stream
cd "$EPICS_ROOT/modules"
if [ ! -d stream ]; then
    git clone https://github.com/paulscherrerinstitute/StreamDevice.git stream
fi
fix_release stream
cd stream
make -j$(nproc)

echo "==== Instalacja zakończona pomyślnie (Raspberry Pi / Ubuntu) ===="