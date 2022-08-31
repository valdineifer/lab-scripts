# lab-scripts

Para instalar o script de atualização na máquina, execute o seguinte comando:

```
wget -O - https://github.com/graco-ufba/lab-scripts/blob/main/install.sh | /bin/bash
```

O script `lab-startup.sh` será executado a cada inicialização da máquina.

Para visualizar o log, execute:

```
journalctl -fu labstartup.service
```
