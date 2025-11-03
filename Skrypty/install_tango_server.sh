#!/bin/bash
set -e

TANGO_HOST_IP="192.168.1.10"  # <-- Ustaw IP tego serwera
TANGO_PORT="10000"

echo "===> Instalacja zależności Tango i bazy danych"
sudo apt update
sudo apt install -y \
  mariadb-server \
  omniidl libomniorb4-dev libcos4-dev libomnithread4-dev \
  build-essential cmake libtool ant \
  libzmq3-dev libssl-dev python3-dev python3-pip

echo "===> Konfiguracja TANGO_HOST"
echo "export TANGO_HOST=$TANGO_HOST_IP:$TANGO_PORT" >> ~/.bashrc
export TANGO_HOST=$TANGO_HOST_IP:$TANGO_PORT

echo "===> Instalacja cpptango i pytango"
pip3 install --user cpptango==9.5.0 pytango==9.5.0

echo "===> Konfiguracja bazy danych MariaDB"
sudo systemctl start mariadb
sudo mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS tango;
CREATE USER IF NOT EXISTS 'tango'@'%' IDENTIFIED BY 'tango';
GRANT ALL PRIVILEGES ON tango.* TO 'tango'@'%';
FLUSH PRIVILEGES;
EOF

echo "===> Instalacja DatabaseDS (serwer bazy danych TANGO)"
mkdir -p ~/tango-ds
cd ~/tango-ds
git clone --depth 1 --branch 9.5.0 https://gitlab.com/tango-controls/TangoDatabase.git
cd TangoDatabase
make -j$(nproc)

echo "===> Tworzenie systemd unit dla DatabaseDS"
cat <<EOF | sudo tee /etc/systemd/system/tango-database.service
[Unit]
Description=TANGO Database Device Server
After=network.target mariadb.service

[Service]
Environment="TANGO_HOST=$TANGO_HOST_IP:$TANGO_PORT"
ExecStart=$(pwd)/Database
Restart=on-failure
User=$USER

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable tango-database
sudo systemctl start tango-database

echo "===> Instalacja zakończona (Serwer). Pamiętaj, by otworzyć port $TANGO_PORT i zrestartować terminal."
