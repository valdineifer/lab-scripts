#!/bin/bash

if ! command -v python3 &>/dev/null; then
  echo "Python 3 is not installed. Exiting..."
  return 1
fi

if ! command -v pip &>/dev/null; then
  echo "pip is not installed. Exiting..."
  return 1
fi

inventory_path="/etc/gdm3/PostLogin/inventory_script-master"

wget -O inventory.zip https://github.com/valdineifer/inventory_script/archive/refs/heads/master.zip
unzip -o inventory.zip -d /etc/gdm3/PostLogin

if [ -f /etc/gdm3/PostLogin/Default ]; then
  mv /etc/gdm3/PostLogin/Default /etc/gdm3/PostLogin/Default.bkp
fi

inventory_url='http://192.168.100.95:4000/inventory'

pip install -r "$inventory_path/src/requirements.txt"