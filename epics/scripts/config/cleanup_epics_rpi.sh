#!/usr/bin/env bash
set -e

echo "======================================"
echo " EPICS / E3 CLEANUP SCRIPT (RPi)"
echo "======================================"

# --- SAFETY CHECK ---
echo "This will remove EPICS-related files and conda env 'e3'."
read -p "Continue? (y/N): " confirm
if [[ "$confirm" != "y" ]]; then
    echo "Aborted."
    exit 0
fi

# --- 1. REMOVE CONDA ENV ---
echo "=== Removing conda env: e3 ==="
if command -v conda >/dev/null 2>&1; then
    source "$HOME/miniforge3/etc/profile.d/conda.sh" || true
    conda env remove -y -n e3 || true
fi

# --- 2. REMOVE EPICS RELATED DIRS ---
echo "=== Removing EPICS directories ==="

CANDIDATES=(
    "$HOME/epics"
    "$HOME/EPICS"
    "$HOME/e3"
    "$HOME/epics-base"
    "$HOME/epics-support"
    "$HOME/ioc"
)

for d in "${CANDIDATES[@]}"; do
    if [ -d "$d" ]; then
        echo "Removing $d"
        rm -rf "$d"
    fi
done

# --- 3. OPTIONAL: REMOVE MINIFORGE ---
echo "=== Miniforge removal ==="
read -p "Remove Miniforge (~miniforge3)? (y/N): " rmconda
if [[ "$rmconda" == "y" ]]; then
    rm -rf "$HOME/miniforge3"
    echo "Miniforge removed."
else
    echo "Skipped Miniforge."
fi

# --- 4. CLEAN .bashrc ---
echo "=== Cleaning .bashrc ==="

BASHRC="$HOME/.bashrc"
TMP=$(mktemp)

# remove EPICS / conda / alias blocks
sed -E \
    -e '/EPICS e3 ARM COMPAT LAYER/,+20d' \
    -e '/conda\.sh/d' \
    -e '/conda activate e3/d' \
    -e '/alias iocsh=/d' \
    -e '/alias ioc=/d' \
    -e '/EPICS_BASE/d' \
    -e '/softIocPVA/d' \
    -e '/miniforge3/d' \
    "$BASHRC" > "$TMP"

mv "$TMP" "$BASHRC"

echo "bashrc cleaned."

# --- 5. REMOVE LEFTOVER ENV VARS FROM SESSION ---
unset EPICS_BASE || true
unset CONDA_PREFIX || true

echo "======================================"
echo " CLEANUP COMPLETE"
echo "======================================"
echo ""
echo "Next steps:"
echo "1. restart shell: exec bash"
echo "2. verify: conda, epics, iocsh removed"
echo "======================================"
