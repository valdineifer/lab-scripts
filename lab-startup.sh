#!/bin/bash

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
## Mongodb
#wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
#echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

### Apt-get
apt-get update -y
apt-get install -y  \
  python3-pip default-jre default-jdk \
  git \
  sublime-text code vim \
  obs-studio v4l2loopback-dkms \
  mysql-server postgresql postgresql-contrib 
  #mongodb-org
### Snaps
sudo snap install eclipse --classic
sudo snap install intellij-idea-community --classic

##################################

# Pula configuração do Ubuntu pelo usuário novo
mkdir -p /etc/skel/.config
echo 'yes' > /etc/skel/.config/gnome-initial-setup-done

# Cria usuário aluno e define senha
if id aluno &> /dev/null; then
  echo ok
else
  useradd --create-home --password "vivaoic2021!" -s /bin/bash aluno
fi
echo "aluno:vivaoic2021!" | chpasswd

# Recria home do aluno logo após login
echo '#!/bin/bash
if [[ "$USER" == "aluno" ]]; then
        rm -rf /home/$USER
        cp -r /etc/skel /home/$USER
        chown -R $USER:$USER /home/$USER
        echo "aluno:vivaoic2021!" | chpasswd
        
        echo "DROP USER IF EXISTS '\''aluno'\''@'\''localhost'\''; CREATE USER '\''aluno'\''@'\''%'\'' IDENTIFIED BY '\''aluno'\''; GRANT ALL PRIVILEGES ON *.* TO '\''aluno'\''@'\''%'\'';" | mysql
fi
exit 0
' > /etc/gdm3/PostLogin/Default
chmod a+x /etc/gdm3/PostLogin/Default
echo '' > /etc/gdm3/PostSession/Default

# Usa GDM como gerenciador de login
echo "/usr/sbin/gdm3" > /etc/X11/default-display-manager
DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true dpkg-reconfigure gdm3
echo set shared/default-x-display-manager gdm3 | debconf-communicate

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

exit 0
