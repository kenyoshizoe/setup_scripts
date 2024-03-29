#!/usr/bin/bash

echo "--- install fundamental packages ---"
sudo apt install git ca-certificates curl gnupg lsb-release apt-transport-https gdebi -y

echo "--- change apt source ---"
sudo sed -i.bak -r 's@http://(jp\.)?archive\.ubuntu\.com/ubuntu/?@https://ftp.udx.icscoe.jp/Linux/ubuntu/@g' /etc/apt/sources.list

sudo apt update -y
sudo apt upgrade -y

echo "--- change home directory name ---"
if [ -d ~/デスクトップ ] ; then
    LANG=C xdg-user-dirs-gtk-update
else
    echo "skip."
fi

echo "--- change background ---"
gsettings set org.gnome.desktop.background picture-uri 'none'
gsettings set org.gnome.desktop.background primary-color '#282828'

echo "--- install docker ---"
docker --version &> /dev/null
if [ $? -ne 0 ] ; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io -y
else
    echo "skip."
fi

echo "--- generate ssh-key ---"
if [ -f ~/.ssh/id_rsa ] ; then
    echo "skip."
else
    ssh-keygen -t rsa
fi

echo "--- install terminator ---"
terminator -v &> /dev/null
if [ $? -ne 0 ] ; then
    sudo apt install terminator -y
    mkdir -p ~/.config/terminator
    cp terminator_config ~/.config/terminator/config
else
    echo "skip."
fi

echo "--- install vscode ---"
code -v &> /dev/null
if [ $? -ne 0 ] ; then
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    rm microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install code -y
else
    echo "skip."
fi

echo "--- install JetBrains Mono ---"
if [ -d ~/.fonts/JetBrainsMono ] ; then
    echo "skip."
else
    wget https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip
    unzip JetBrainsMono-2.242.zip -d temp
    mkdir -p ~/.fonts/JetBrainsMono
    cp temp/fonts/ttf/* ~/.fonts/JetBrainsMono
    rm -r temp JetBrainsMono-2.242.zip
fi

echo "--- install google-chrome-stable ---"
google-chrome-stable --version &> /dev/null
if [ $? -ne 0 ] ; then
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo apt update
    sudo apt-get install google-chrome-stable
    sudo rm /etc/apt/sources.list.d/google.list
else
    echo "skip."
fi

echo "--- install slack ---"
slack -v &> /dev/null
if [ $? -ne 0 ] ; then
    wget https://downloads.slack-edge.com/releases/linux/4.24.0/prod/x64/slack-desktop-4.24.0-amd64.deb
    sudo gdebi slack-desktop-4.24.0-amd64.deb -n
    rm slack-desktop-4.24.0-amd64.deb
else
    echo "skip."
fi

echo "--- install gruvbox theme ---"
git clone https://github.com/TheGreatMcPain/gruvbox-material-gtk.git
mkdir -p ~/.local/share/themes && cp -r gruvbox-material-gtk/themes/* ~/.local/share/themes
mkdir -p ~/.local/share/icons && cp -r gruvbox-material-gtk/icons/* ~/.local/share/icons
rm -rf gruvbox-material-gtk

echo "--- install system monitor applet ---"
# sudo apt install gnome-shell-extension-system-monitor
sudo apt install gnome-shell-extension-prefs
sudi apt install gnome-tweaks
