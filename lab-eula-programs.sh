#!/bin/bash

export DEBIAN_FRONTEND=noninteractive


# VirtualBox
sudo apt-get install mokutil
SBDISABLED=$(mokutil --sb)
if [ "$SBDISABLED" = "SecureBoot disabled" ]; then
    sudo apt-get install virtualbox
    if [ -f /home/luis/Downloads/Linux.ova -a ! -d /opt/Linux ]; then
        vboxmanage import /home/luis/Downloads/Linux.ova --vsys 0 --basefolder "/opt"
	chown -R aluno:aluno /opt/Linux
    fi
fi

#wireshark
if ! [ -f /usr/local/sbin/wire.sh ]; then
sudo apt remove wireshark -y
sudo apt autoremove -y
echo PURGE | sudo debconf-communicate wireshark-common

sudo touch /usr/local/sbin/wire.sh
echo wireshark-common wireshark-common/install-setuid select "true" | sudo debconf-set-selections
sudo apt install wireshark -y
sudo usermod -aG wireshark aluno
sudo chmod +x /usr/bin/dumpcap
fi

#CiscoPacketTracer

if ! [ -d /opt/pt ]; then
wget "https://www.dropbox.com/scl/fi/fpexy62c8mybh10k1u5h1/Packet_Tracer822_amd64_signed.deb?rlkey=1hvmun574d7p6ud4ey32xwl2j&st=6dnoy373&dl=1" -O /opt/cisco.deb

cd /opt

echo PacketTracer PacketTracer_822_amd64/accept-eula select "true" | sudo debconf-set-selections
echo PacketTracer PacketTracer_822_amd64/show-eula select "false" | sudo debconf-set-selections

DEBIAN_FRONTEND=noninteractive dpkg -i cisco.deb
sudo apt install -f -y
DEBIAN_FRONTEND=noninteractive dpkg -i cisco.deb
sudo rm cisco.deb
sudo wget "https://drive.google.com/uc?export=download&id=1L01Mg96hWRpeI9LNOqzugmsSod7vza0O" -O /etc/skel/pt.zip
cd /etc/skel
sudo unzip pt.zip
sudo rm /etc/skel/pt.zip

fi


exit 0