#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/alpha/lab-profile-config.sh -O /tmp/lab-profile-config.sh
wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/alpha/lab-aluno-config.sh -O /tmp/lab-aluno-config.sh
wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/alpha/lab-programs.sh -O /tmp/lab-programs.sh
wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/alpha/lab-eula-programs.sh -O /tmp/lab-eula-programs.sh

if ! [ -f /usr/local/sbin/done.txt ]; then
	sudo touch /usr/local/sbin/done.txt
	sudo echo "false" > /usr/local/sbin/done.txt
	chmod a+x /usr/local/sbin/done.txt
else
	sudo echo "true" > /usr/local/sbin/done.txt
	if ! cmp -s /usr/local/sbin/lab-profile-config.sh /tmp/lab-profile-config.sh; then
	sudo echo "false" > /usr/local/sbin/done.txt
	fi
	if ! cmp -s /usr/local/sbin/lab-aluno-config.sh /tmp/lab-aluno-config.sh; then
	sudo echo "false" > /usr/local/sbin/done.txt
	fi
	if ! cmp -s /usr/local/sbin/lab-programs.sh /tmp/lab-programs.sh; then
	sudo echo "false" > /usr/local/sbin/done.txt
	fi
	if ! cmp -s /usr/local/sbin/lab-eula-programs.sh /tmp/lab-eula-programs.sh; then
	sudo echo "false" > /usr/local/sbin/done.txt
	fi
fi

DONE=$(cat /usr/local/sbin/done.txt)

if [ "$DONE" = "false" ]; then
	sudo cp /tmp/lab-profile-config.sh /usr/local/sbin
	sudo cp /tmp/lab-aluno-config.sh /usr/local/sbin
	sudo cp /tmp/lab-programs.sh /usr/local/sbin
	sudo cp /tmp/lab-eula-programs.sh /usr/local/sbin

	chmod a+x /usr/local/sbin/lab-profile-config.sh
	chmod a+x /usr/local/sbin/lab-aluno-config.sh
	chmod a+x /usr/local/sbin/lab-programs.sh
	chmod a+x /usr/local/sbin/lab-eula-programs.sh

	/usr/local/sbin/lab-profile-config.sh
	/usr/local/sbin/lab-aluno-config.sh
	/usr/local/sbin/lab-programs.sh
	/usr/local/sbin/lab-eula-programs.sh

	echo "SCRIPTS ATUALIZADOS"
else
	echo "SEM NECESSIDADE DE ATUALIZAR SCRIPTS"
fi

exit 0
