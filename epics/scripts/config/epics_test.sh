#!/bin/bash
set -e

echo "==== Test instalacji EPICS ===="
echo

# Sprawdzenie zmiennych
echo "==== Sprawdzanie zmiennych środowiskowych ===="
echo "EPICS_BASE = $EPICS_BASE"
echo "EPICS_MODULES = $EPICS_MODULES"

if echo "$PATH" | grep -q "$EPICS_BASE/bin"; then
    echo "PATH zawiera EPICS_BASE/bin - OK"
else
    echo "PATH NIE zawiera EPICS_BASE/bin!"
fi
echo

# Sprawdzenie narzędzi
echo "==== Sprawdzanie narzędzi EPICS ===="
if ! command -v softIoc >/dev/null 2>&1; then
    echo "softIoc nie znaleziony! Sprawdź PATH i zmienne środowiskowe."
    exit 1
else
    echo "softIoc znaleziony: $(which softIoc)"
fi
echo

# Utwórz i uruchom testowy IOC
echo "==== Uruchamianie testowego IOC ===="
TEST_IOC_DIR=~/epics/testioc
mkdir -p "$TEST_IOC_DIR"
cd "$TEST_IOC_DIR"

cat > test.db <<EOF
record(ai, "TEST:VALUE") {
    field(VAL, "42")
}
EOF

cat > st.cmd <<EOF
#!$(which softIoc)
dbLoadRecords("test.db")
iocInit
EOF

softIoc -d test.db &
IOC_PID=$!
sleep 2

echo "==== Test komunikacji (caget) ===="
if command -v caget >/dev/null 2>&1; then
    caget TEST:VALUE
else
    echo "caget nie znaleziony, spróbuj: sudo apt install -y epics-utils"
fi

kill $IOC_PID || true
echo "==== Test zakończony ===="
