#!/bin/bash
set -e

TANGO_SERVER_IP="192.168.1.10"  # <-- IP serwera Tango
TANGO_PORT="10000"

echo "===> Instalacja zależności"
sudo apt update
sudo apt install -y \
  omniidl libomniorb4-dev libcos4-dev libomnithread4-dev \
  build-essential cmake libtool ant \
  libzmq3-dev libssl-dev python3-dev python3-pip

echo "===> Konfiguracja TANGO_HOST"
echo "export TANGO_HOST=$TANGO_SERVER_IP:$TANGO_PORT" >> ~/.bashrc
export TANGO_HOST=$TANGO_SERVER_IP:$TANGO_PORT

echo "===> Instalacja cpptango i pytango"
pip3 install --user cpptango==9.5.0 pytango==9.5.0

echo "===> Tango gotowe na Raspberry Pi 4 (klient/serwer urządzeń)."
