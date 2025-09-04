# Tárgyaló naptár alkalmazás.

## Környezet beállítása
A környezet beállításához ami egy docker konténer virtualizációs környezet, a következő lépéseket kell megtenni.

### Docker környezet telepítése Window 11-re
#### Hardver környezet:
BIOS:
Intel Hyper-Threading Technology engedélyezve
#### Szoftver környezet
Windows Features:
Hyper-v telepítve/bekapcsolva

WSL windows Subsystem Linux
wsl --install -d Ubuntu-24.04
https://learn.microsoft.com/en-us/windows/wsl/install

Install git for windows
 https://git-scm.com/downloads/win

Docker destop telepítése:
https://docs.docker.com/desktop/setup/install/windows-install/

### Alkalmazás indítása
A gyökér könyvtárból a következő parancs futtatásával:
docker-compose up -d

### Alkalmazás elérése localhost-on
https://localhost:8443/index.php
