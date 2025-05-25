#!/bin/bash

# Parte 1 do script
echo "Atualizando repositórios e sistema..."
sudo apt update && sudo apt upgrade -y

echo "Adicionando repositório PPA para PHP..."
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y

echo "Iniciando script de pós-instalação..."

echo "Instalando curl, wget, unzip e git..."
sudo apt install git curl wget unzip -y

# Instalação de pacotes adicionais
echo "Instalando PHP e pacotes relacionados..."
sudo apt install php8.2 php8.2-{cli,common,xml,fpm,curl,mbstring,gd,zip,intl,bcmath,mysql} mariadb-server gnome-tweaks gpg pass wget curl unzip flatpak -y

echo "Instalando aplicativos Flatpak..."
# Instalar flatpak primeiro
sudo apt install flatpak -y
# Adicionar repositório flathub se não existir
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# Instalar apps flatpak
flatpak install flathub com.discordapp.Discord it.mijorus.gearlever net.hovancik.Stretchly io.github.shiftey.Desktop io.dbeaver.DBeaverCommunity com.mattjakeman.ExtensionManager com.github.marktext.marktext org.kde.krita com.rtosta.zapzap com.heroicgameslauncher.hgl app.zen_browser.zen md.obsidian.Obsidian io.ente.auth com.bitwarden.desktop org.gimp.GIMP org.inkscape.Inkscape -y || echo "Erro ao instalar flatpaks - continuando"

echo "Baixando fontes..."
# Instalar wget se não estiver instalado
which wget >/dev/null || sudo apt install wget -y
which unzip >/dev/null || sudo apt install unzip -y

mkdir -p ~/Downloads
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P ~/Downloads || echo "Erro ao baixar fonte - continuando"
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P ~/Downloads || echo "Erro ao baixar fonte - continuando"
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P ~/Downloads || echo "Erro ao baixar fonte - continuando"
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P ~/Downloads || echo "Erro ao baixar fonte - continuando"
wget https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip -P ~/Downloads || echo "Erro ao baixar fonte - continuando"
wget https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip -P ~/Downloads || echo "Erro ao baixar fonte - continuando"

unzip -o ~/Downloads/Fira_Code_v6.2.zip -d ~/Downloads || echo "Erro ao extrair fonte - continuando"
unzip -o ~/Downloads/JetBrainsMono-2.304.zip -d ~/Downloads || echo "Erro ao extrair fonte - continuando"

echo "Criando diretórios..."
mkdir -p ~/Projects
mkdir -p ~/.icons

echo "Instalando o bun..."
which curl >/dev/null || sudo apt install curl -y
curl -fsSL https://bun.sh/install | bash || echo "Erro ao instalar bun - continuando"

echo "Configurando git..."
git config --global user.name ""
git config --global user.email ""
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global credential.credentialStore gpg

echo "Instalando o fnm..."
curl -fsSL https://fnm.vercel.app/install | bash || echo "Erro ao instalar fnm - continuando"

# Carregar fnm para poder usar
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env)"

echo "Instalando Node.js..."
fnm install 23 || echo "Erro ao instalar node - continuando"
fnm use 23 || echo "Erro ao usar node - continuando"

echo "Instalando o starship..."
curl -sS https://starship.rs/install.sh | sh || echo "Erro ao instalar starship - continuando"

# Adicionar starship ao fish
echo "starship init fish | source" >> ~/.config/fish/config.fish

starship preset bracketed-segments -o ~/.config/starship.toml

echo "Instalando o composer..."
which php >/dev/null || sudo apt install php -y
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" || echo "Erro ao baixar composer - continuando"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" || echo "Erro ao verificar composer - continuando"
php composer-setup.php || echo "Erro ao instalar composer - continuando"
php -r "unlink('composer-setup.php');" || echo "Erro ao remover setup - continuando"
sudo mv composer.phar /usr/local/bin/composer || echo "Erro ao mover composer - continuando"

echo "Configurando mariadb..."
# Verificar se estamos em um sistema com systemd
if [ -d "/run/systemd/system" ]; then
    sudo systemctl enable mariadb || echo "Erro ao habilitar mariadb - continuando"
    sudo systemctl start mariadb || echo "Erro ao iniciar mariadb - continuando"
else
    echo "Systemd não detectado - pulando configuração do MariaDB"
fi

echo "Baixando aplicativos adicionais..."
wget https://github.com/th-ch/youtube-music/releases/download/v3.9.0/YouTube-Music-3.9.0.AppImage -P ~/Downloads || echo "Erro ao baixar YouTube Music - continuando"

echo "Baixando o vscode..."
wget https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64 -O vscode.deb || echo "Erro ao baixar vscode - continuando"
sudo apt install ./vscode.deb -y || echo "Erro ao instalar vscode - continuando"

echo "Baixando gnome-dash-fixer..."
mkdir -p ~/Documents
wget https://github.com/BenJetson/gnome-dash-fix/archive/refs/heads/master.zip -P ~/Documents || echo "Erro ao baixar gnome-dash-fix - continuando"
unzip -o ~/Documents/master.zip -d ~/Documents || echo "Erro ao extrair gnome-dash-fix - continuando"
if [ -d ~/Documents/gnome-dash-fix-master ]; then
    cd ~/Documents/gnome-dash-fix-master
    chmod +x interactive.py
    ./interactive.py || echo "Erro ao executar gnome-dash-fix - continuando"
else
    echo "Diretório gnome-dash-fix-master não encontrado - pulando"
fi

# Limpeza
echo "Instalação completa!"
exit 0
