#!/bin/bash

apt-get update -y
apt-get install -y vim python3-pip git

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
