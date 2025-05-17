#!/bin/bash

# Verificar se este script já foi executado antes
if [ -f "$HOME/.postinstall_completed" ]; then
    echo "A instalação inicial já foi realizada."
    # Parte 2 do script (executada após o login com fish shell)
    echo "Continuando com a instalação de pacotes adicionais..."
    
    # Instalação de pacotes adicionais
    sudo apt install php8.2 php8.2-{cli,common,xml,fpm,curl,mbstring,gd,zip,intl,bcmath,mysql} mariadb-server gnome-tweaks gpg pass -y
    
    # Configuração adicional aqui
    echo "Configurando aplicativos..."
    
    # Limpeza
    rm "$HOME/.postinstall_completed"
    echo "Instalação completa!"
    exit 0
fi

echo "Iniciando script de pós-instalação..."

# Parte 1 do script
echo "Atualizando repositórios e sistema..."
sudo apt update && sudo apt upgrade -y

echo "Adicionando repositório PPA para PHP..."
sudo add-apt-repository ppa:ondrej/php -y

echo "Instalando fish shell e git..."
sudo apt install fish git -y

# Configurar para continuar a execução após o login
echo "Configurando para continuar após o reinício do shell..."

# Criar arquivo de flag para indicar que parte 1 foi concluída
touch "$HOME/.postinstall_completed"

# Adicionar comando para executar este script novamente no login do fish
SCRIPT_PATH=$(realpath "$0")
FISH_CONFIG_DIR="$HOME/.config/fish"

mkdir -p "$FISH_CONFIG_DIR"

# Criar ou adicionar ao config.fish
echo "
# Executar automaticamente o script de pós-instalação na primeira vez
if test -f \"$HOME/.postinstall_completed\"
    bash \"$SCRIPT_PATH\"
end" >> "$FISH_CONFIG_DIR/config.fish"

echo "Alterando o shell padrão para fish..."
chsh -s $(which fish)

echo "O shell padrão foi alterado para fish."
echo "Por favor, faça logout e login novamente para continuar a instalação."
echo "A instalação continuará automaticamente após o login."

# instalar apps flatpak

sudo flatpak install flathub com.discordapp.Discord it.mijorus.gearlever net.hovancik.Stretchly io.github.shiftey.Desktop io.dbeaver.DBeaverCommunity com.mattjakeman.ExtensionManager com.github.marktext.marktext org.kde.krita com.rtosta.zapzap com.heroicgameslauncher.hgl app.zen_browser.zen md.obsidian.Obsidian io.ente.auth com.bitwarden.desktop -y

# baixar fontes

wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P ~/Downloads
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P ~/Downloads
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P ~/Downloads
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P ~/Downloads
wget https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip -P ~/Downloads
wget https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip -P ~/Downloads

unzip ~/Downloads/Fira_Code_v6.2.zip -d ~/Downloads
unzip ~/Downloads/JetBrainsMono-2.304.zip -d ~/Downloads

mkdir ~/Projects
mkdir ~/.icons

# Instalando o bun
curl -fsSL https://bun.sh/install | bash

git config --global user.name ""
git config --global user.email ""
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global credential.credentialStore gpg

# Instalando o fnm
curl -fsSL https://fnm.vercel.app/install | bash

# instalar o node 18
fnm install 23
fnm use 23

# Instalando o starship
curl -fsSL https://starship.rs/install.sh | sh

# Instalando o composer

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

# Ativando o mariadb

sudo systemctl enable mariadb
sudo systemctl start mariadb

# Download do yt music

wget https://github.com/th-ch/youtube-music/releases/download/v3.9.0/YouTube-Music-3.9.0.AppImage -P ~/Downloads

# Download do gnome-dash-fixer

wget https://github.com/BenJetson/gnome-dash-fix/archive/refs/heads/master.zip -P ~/Documents
unzip ~/Documents/master.zip -d ~/Documents
cd ~/Documents/gnome-dash-fix-master
chmod +x interactive.py
./interactive.py