# instalar o fish shell
sudo apt update && sudo apt upgrade -y

sudo add-apt-repository ppa:ondrej/php -y

sudo apt install fish git php8.2 php8.2-{cli,common,xml,fpm,curl,mbstring,gd,zip,intl,bcmath,mysql} mariadb-server gnome-tweaks gpg pass -y
chsh -s $(which fish)

# instalar apps

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

# Instalando o starship
curl -fsSL https://starship.rs/install.sh | sh

