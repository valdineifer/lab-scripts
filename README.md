# lab-scripts

Para instalar o script de atualização na máquina, execute o seguinte comando **como usuário root**:

```
wget -O - https://raw.githubusercontent.com/graco-ufba/lab-scripts/main/install.sh | /bin/bash
```

O script `lab-startup.sh` será executado a cada inicialização da máquina.

Após a instalação, reinicie a máquina e execute o seguinte comando para visulizar o log:

```
journalctl -fu labstartup.service
```
