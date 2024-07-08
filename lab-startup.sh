#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/alpha/lab-profile-config.sh -O /tmp/lab-profile-config.sh
chmod a+x /tmp/lab-profile-config.sh

wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/alpha/lab-aluno-config.sh -O /tmp/lab-aluno-config.sh
chmod a+x /tmp/lab-aluno-config.sh

wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/alpha/lab-programs.sh -O /tmp/lab-programs.sh
chmod a+x /tmp/lab-programs.sh

wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/alpha/lab-eula-programs.sh -O /tmp/lab-eula-programs.sh
chmod a+x /tmp/lab-eula-programs.sh

/tmp/lab-profile-config.sh
/tmp/lab-aluno-config.sh
/tmp/lab-programs.sh
/tmp/lab-eula-programs.sh

exit 0