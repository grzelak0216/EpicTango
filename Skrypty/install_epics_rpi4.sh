#!/bin/bash
set -e

echo "==== Instalacja zależności systemowych ===="
sudo apt update
sudo apt install -y \
    git build-essential libreadline-dev libncurses-dev perl libexpat1-dev \
    libtool automake pkg-config libssl-dev flex bison re2c libpcre3-dev \
    python3-dev python3-numpy python3-pip python3-venv ca-certificates wget curl

# Utworzenie katalogu głównego
EPICS_ROOT=~/epics
mkdir -p "$EPICS_ROOT/modules"
cd "$EPICS_ROOT"

echo "==== Tworzenie środowiska Pythona ===="
if [ ! -d ~/epics-venv ]; then
    python3 -m venv ~/epics-venv
fi
source ~/epics-venv/bin/activate
pip install --upgrade pip
pip install pyepics caproto

echo "==== Pobieranie i budowanie EPICS Base ===="
if [ ! -d epics-base ]; then
    git clone --branch R7.0.8 https://github.com/epics-base/epics-base.git
fi
cd epics-base
EPICS_HOST_ARCH=$(./startup/EpicsHostArch)
make -j$(nproc)

echo "==== Ustawianie zmiennych środowiskowych ===="
if ! grep -q "EPICS Environment" ~/.bashrc; then
cat <<EOF >> ~/.bashrc

# EPICS Environment
export EPICS_ROOT=$EPICS_ROOT
export EPICS_BASE=\$EPICS_ROOT/epics-base
export EPICS_MODULES=\$EPICS_ROOT/modules
export PATH=\$EPICS_BASE/bin/$EPICS_HOST_ARCH:\$PATH
export LD_LIBRARY_PATH=\$EPICS_BASE/lib/$EPICS_HOST_ARCH:\$LD_LIBRARY_PATH
source ~/epics-venv/bin/activate
EOF
fi

source ~/.bashrc

# Funkcja naprawiająca configure/RELEASE
fix_release() {
    local release_file="$1/configure/RELEASE"
    if [ -f "$release_file" ]; then
        echo "Naprawiam $release_file ..."
        sed -i '/SUPPORT *=/d' "$release_file"
        sed -i "s|^EPICS_BASE *=.*|EPICS_BASE = $EPICS_ROOT/epics-base|" "$release_file"
        if [[ "$1" != *"asyn"* ]] && [ -d "$EPICS_ROOT/modules/asyn" ]; then
            if grep -q "^ASYN" "$release_file"; then
                sed -i "s|^ASYN *=.*|ASYN = $EPICS_ROOT/modules/asyn|" "$release_file"
            else
                echo "ASYN = $EPICS_ROOT/modules/asyn" >> "$release_file"
            fi
        fi
    fi
}

echo "==== Pobieranie i budowanie modułów: asyn, sequencer ===="
cd "$EPICS_ROOT/modules"

# ASYN
if [ ! -d asyn ]; then
    git clone https://github.com/epics-modules/asyn.git
fi
fix_release asyn
cd asyn
make clean
make -j$(nproc)

# SEQUENCER
cd "$EPICS_ROOT/modules"
if [ ! -d sequencer ]; then
    git clone https://github.com/epics-modules/sequencer.git
fi
fix_release sequencer
cd sequencer
make clean
make -j$(nproc)

echo
echo "==== Instalacja zakończona pomyślnie ===="
echo "Aby aktywować środowisko, użyj:"
echo "    source ~/epics-venv/bin/activate"
echo "    source ~/.bashrc"
echo
echo "Host architektury: $EPICS_HOST_ARCH"
echo "EPICS zainstalowany w: $EPICS_ROOT"
