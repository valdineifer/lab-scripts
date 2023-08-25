#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

#########
# Desativa IPv6

sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
sysctl -w net.ipv6.conf.lo.disable_ipv6=1

# Configura rotação de logs

cat <<EOF > /etc/logrotate.d/custom_logs
/var/log/syslog /var/log/kern.log {
    weekly
    missingok
    rotate 4
    compress
    delaycompress
    notifempty
    create 0644 root root
    size 200M
    sharedscripts
    postrotate
    endscript
}
EOF
logrotate -f /etc/logrotate.d/custom_logs

echo "Logrotate configuration has been set up successfully."

############### Criação do usuário aluno ###############

# Pula configuração do Ubuntu pelo usuário novo
rm -f /usr/share/applications/gnome-online-accounts-panel.desktop
mkdir -p /etc/skel/.config
echo 'yes' > /etc/skel/.config/gnome-initial-setup-done


# Cria usuário aluno e define senha
if id aluno &> /dev/null; then
  echo ok
else
  useradd --create-home --password "vivaoic2021!" -s /bin/bash aluno
fi
echo "aluno:vivaoic2021!" | chpasswd

#####################################################################################
############### Script executado pelo usuário aluno logo após o login ###############
#####################################################################################
# Recria home do aluno logo após login
echo '#!/bin/bash
if [[ "$USER" == "aluno" ]]; then
        rm -rf /home/$USER
        cp -r /etc/skel /home/$USER
        chown -R $USER:$USER /home/$USER
        echo "aluno:vivaoic2021!" | chpasswd

 	echo export PATH="/opt/flutter/bin:\$PATH" >> /home/aluno/.bashrc
  	echo export PATH="/opt/android-studio/bin:/opt/Android/Sdk/platform-tools:\$PATH" >> /home/aluno/.bashrc
  	rm -f /opt/flutter/bin/cache/lockfile

   	ln -s /opt/gradle .gradle
        
        echo "DROP USER IF EXISTS '\''aluno'\''@'\''localhost'\''; CREATE USER '\''aluno'\''@'\''%'\'' IDENTIFIED BY '\''aluno'\''; GRANT ALL PRIVILEGES ON *.* TO '\''aluno'\''@'\''%'\'';" | mysql
        sudo -u postgres dropdb --if-exists aluno; sudo -u postgres createdb aluno
        sudo -u postgres dropuser --if-exists aluno; sudo -u postgres createuser aluno
        echo "ALTER USER aluno WITH PASSWORD '\''aluno'\''; GRANT ALL PRIVILEGES ON DATABASE aluno to aluno;" | sudo -u postgres psql
fi
exit 0
' > /etc/gdm3/PostLogin/Default
chmod a+x /etc/gdm3/PostLogin/Default
echo '' > /etc/gdm3/PostSession/Default

# Usa GDM como gerenciador de login (já é o padrão)
#echo "/usr/sbin/gdm3" > /etc/X11/default-display-manager
#DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true dpkg-reconfigure gdm3
#echo set shared/default-x-display-manager gdm3 | debconf-communicate

###################### Programas #####################
# Sublime Text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
# Visual Studio Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
# OBS Studio
sudo add-apt-repository -y ppa:obsproject/obs-studio

### Apt-get
DEBIAN_FRONTEND=noninteractive dpkg --configure -a
apt-get update -y
apt-get install -y  \
  python3-pip default-jre default-jdk maven swi-prolog racket elixir clisp nasm gcc-multilib \
  python3.11-full \
  git \
  flex bison \
  sublime-text code vim sasm \
  obs-studio v4l2loopback-dkms \
  mysql-server postgresql postgresql-contrib \
  wireshark arp-scan net-tools mtr dnsutils traceroute curl

# Python
update-alternatives --install /usr/bin/python3 python3  /usr/bin/python3.11 1
update-alternatives --install /usr/bin/python3 python3  /usr/bin/python3.10 2

### Snaps
sudo snap install eclipse --classic
sudo snap install intellij-idea-community --classic
sudo snap install mongo33
sudo snap install bluej

# Flutter
# sudo snap install flutter --classic
snap remove flutter
if [ ! -d "/opt/flutter" ]; then
  cd /opt
  wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.10.5-stable.tar.xz -O /tmp/flutter.tar.xz
  tar xf /tmp/flutter.tar.xz
  chown -R aluno:aluno flutter
  cd -
fi

# Google Chrome
if ! command -v google-chrome &> /dev/null; then
	cd /tmp
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	dpkg -i google-chrome-stable_current_amd64.deb
	cd -
fi

##################################

# Instala o Android SDK e Android Studio
if [[ ! -d /opt/Android ]]; then
  wget https://nuvem.ufba.br/s/FjNaDukULOwHhs4/download -O /tmp/Android.tar.bz2
  cd /opt
  tar xjf /tmp/Android.tar.bz2
  rm /tmp/Android.tar.bz2
  cd /etc/skel
  unlink Android
  ln -s /opt/Android .
fi
if [[ ! -d /opt/android-studio ]]; then
  wget https://nuvem.ufba.br/s/6BUVDGWKKMxR6Fj/download -O /tmp/android-studio.tar.bz2
  cd /opt
  tar xjf /tmp/android-studio.tar.bz2
  rm /tmp/android-studio.tar.bz2
fi
if [[ ! -d /opt/gradle ]]; then
  wget https://nuvem.ufba.br/s/U5anBL3tRpN2xhT/download -O /tmp/gradle.tar.bz2
  cd /opt
  tar xjf /tmp/gradle.tar.bz2
  mv .gradle gradle
  chown -R aluno:aluno gradle
  rm /tmp/gradle.tar.bz2
fi

exit 0
