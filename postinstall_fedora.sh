#!/bin/bash

# Parte 1 do script
echo "Atualizando repositórios e sistema..."
sudo dnf update -y

echo "Iniciando script de pós-instalação..."

# Instalação de pacotes básicos
echo "Instalando curl, wget, unzip e git..."
sudo dnf install git curl wget unzip -y

# Instalando PHP 8.2
echo "Instalando PHP e pacotes relacionados..."

sudo dnf install http://rpms.remirepo.net/fedora/remi-release-40.rpm -y
sudo dnf module enable php:remi-8.2 -y
sudo dnf install php-{cli,fpm,curl,mysqlnd,gd,opcache,zip,intl,common,bcmath,imagick,xmlrpc,json,readline,memcached,redis,mbstring,apcu,xml,dom,redis,memcached,memcache} -y

# Instalando o composer
echo "Instalando o composer..."
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" || echo "Erro ao baixar composer - continuando"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" || echo "Erro ao verificar composer - continuando"
php composer-setup.php || echo "Erro ao instalar composer - continuando"
php -r "unlink('composer-setup.php');" || echo "Erro ao remover setup - continuando"
sudo mv composer.phar /usr/local/bin/composer || echo "Erro ao mover composer - continuando"

# Instalando o mariadb
echo "Instalando o mariadb..."
sudo dnf install mariadb-server -y || echo "Erro ao instalar mariadb - continuando"
# Verificar se estamos em um sistema com systemd
if [ -d "/run/systemd/system" ]; then
    sudo systemctl enable mariadb || echo "Erro ao habilitar mariadb - continuando"
    sudo systemctl start mariadb || echo "Erro ao iniciar mariadb - continuando"
else
    sudo service mariadb enable || echo "Erro ao habilitar mariadb - continuando"
    sudo service mariadb start || echo "Erro ao iniciar mariadb - continuando"
fi

# Instalando as fontes
echo "Baixando fontes..."

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
curl -fsSL https://bun.sh/install | bash || echo "Erro ao instalar bun - continuando"
echo "Configurando git..."
git config --global user.name ""
git config --global user.email ""
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global credential.credentialStore gpg

echo "Instalando o fnm..."
curl -fsSL https://fnm.vercel.app/install | bash

echo "Instalando Node.js..."
fnm install 23 || echo "Erro ao instalar node - continuando"

echo "Instalando o starship..."
curl -sS https://starship.rs/install.sh | sh
starship preset bracketed-segments -o ~/.config/starship.toml

echo "Baixando aplicativos adicionais..."
wget https://github.com/th-ch/youtube-music/releases/download/v3.9.0/YouTube-Music-3.9.0.AppImage -P ~/Downloads || echo "Erro ao baixar YouTube Music - continuando"

echo "Instalando aplicativos Flatpak..."
# Instalar flatpak primeiro
sudo apt install flatpak -y
# Adicionar repositório flathub se não existir
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# Instalar apps flatpak
flatpak install flathub com.discordapp.Discord it.mijorus.gearlever net.hovancik.Stretchly io.github.shiftey.Desktop io.dbeaver.DBeaverCommunity com.mattjakeman.ExtensionManager com.github.marktext.marktext org.kde.krita com.rtosta.zapzap com.heroicgameslauncher.hgl app.zen_browser.zen md.obsidian.Obsidian io.ente.auth com.bitwarden.desktop org.gimp.GIMP org.inkscape.Inkscape -y || echo "Erro ao instalar flatpaks - continuando"

echo "Baixando gnome-dash-fixer..."
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