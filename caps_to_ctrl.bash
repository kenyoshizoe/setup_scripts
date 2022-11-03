gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"
sed -i -e "s/XKBOPTIONS=\"/XKBOPTIONS=\"ctrl:nocaps/" /etc/default/keyboard
