#!/bin/sh

apt-get update -y
apt-get install -y vim python3-pip

# Cria usuário aluno e define senha
if id aluno &> /dev/null; then
  echo ok
else
  useradd --create-home --password "vivaoic2021!" --gecos "" -s /bin/bash aluno
fi
echo "aluno:vivaoic2021!" | chpasswd

# Apaga home do aluno após logout
echo '#!/bin/bash
if [[ "$USER" == "aluno" ]]; then
        rm -rf /home/$USER
        cp -r /etc/skel /home/$USER
        chown -R $USER:$USER /home/$USER
        echo "aluno:vivaoic2021!" | chpasswd
fi
exit 0
' > /etc/gdm3/PostSession/Default

# Usa GDM como gerenciador de login
echo "/usr/sbin/gdm3" > /etc/X11/default-display-manager
DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true dpkg-reconfigure gdm3
echo set shared/default-x-display-manager gdm3 | debconf-communicate

exit 0
