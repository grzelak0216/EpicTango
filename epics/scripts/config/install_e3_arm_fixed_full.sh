#!/usr/bin/env bash
set -euo pipefail

echo "======================================"
echo " EPICS ARM INSTALLER"
echo "======================================"

echo "=== SYSTEM DEPENDENCIES ==="
sudo apt update
sudo apt install -y \
    git wget curl build-essential \
    libreadline-dev libncurses-dev \
    perl pkg-config re2c

echo "=== CHECK MINIFORGE ==="

if [ ! -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then

    ARCH=$(uname -m)

    case "$ARCH" in
        aarch64)
            INSTALLER="Miniforge3-Linux-aarch64.sh"
            ;;
        x86_64)
            INSTALLER="Miniforge3-Linux-x86_64.sh"
            ;;
        *)
            echo "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac

    echo "Installing Miniforge..."

    wget -O "$INSTALLER" \
      "https://github.com/conda-forge/miniforge/releases/latest/download/$INSTALLER"

    bash "$INSTALLER" -b -p "$HOME/miniforge3"
fi

source "$HOME/miniforge3/etc/profile.d/conda.sh"

echo "=== CONFIGURE CONDA ==="

conda config --add channels conda-forge || true
conda config --set channel_priority strict || true

echo "=== CREATE ENV ==="

if conda env list | awk '{print $1}' | grep -qx e3; then
    echo "Environment e3 already exists."
else
    conda create -y -n e3 \
        epics-base \
        p4p \
        perl \
        make \
        compilers
fi

conda activate e3

echo "=== VERIFY INSTALL ==="

echo "Conda:"
conda --version

echo
echo "EPICS:"
conda list | grep epics || true

echo
echo "Searching for softIoc..."

find "$CONDA_PREFIX" -type f \( -name "softIoc" -o -name "softIocPVA" \) 2>/dev/null || true

echo "=== INSTALL COMPAT ALIASES ==="

grep -q "EPICS_E3_ARM_COMPAT" ~/.bashrc 2>/dev/null || cat >> ~/.bashrc <<'EOF'

# EPICS_E3_ARM_COMPAT

if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
    source "$HOME/miniforge3/etc/profile.d/conda.sh"
fi

epicsenv() {
    conda activate e3
}

alias ioc="softIoc"

EOF

echo
echo "======================================"
echo " INSTALL FINISHED"
echo "======================================"
echo
echo "Open new shell and run:"
echo
echo "    conda activate e3"
echo
echo "Then verify:"
echo
echo "    which softIoc"
echo "    which softIocPVA"
echo
