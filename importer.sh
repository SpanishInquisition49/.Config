#!/bin/bash
#Installing Packages
echo "
───────────▒▒▒▒▒▒▒▒
─────────▒▒▒──────▒▒▒
────────▒▒───▒▒▒▒──▒░▒
───────▒▒───▒▒──▒▒──▒░▒
──────▒▒░▒──────▒▒──▒░▒
───────▒▒░▒────▒▒──▒░▒
─────────▒▒▒▒▒▒▒───▒▒
─────────────────▒▒▒
─────▒▒▒▒────────▒▒
───▒▒▒░░▒▒▒─────▒▒──▓▓▓▓▓▓▓▓
──▒▒─────▒▒▒────▒▒▓▓▓▓▓░░░░░▓▓──▓▓▓▓
─▒───▒▒────▒▒─▓▓▒░░░░░░░░░█▓▒▓▓▓▓░░▓▓▓
▒▒──▒─▒▒───▓▒▒░░▒░░░░░████▓▓▒▒▓░░░░░░▓▓
░▒▒───▒──▓▓▓░▒░░░░░░█████▓▓▒▒▒▒▓▓▓▓▓░░▓▓
──▒▒▒▒──▓▓░░░░░░███████▓▓▓▒▒▒▒▒▓───▓▓░▓▓
──────▓▓░░░░░░███████▓▓▓▒▒▒▒▒▒▒▓───▓░░▓▓
─────▓▓░░░░░███████▓▓▓▒▒▒▒▒▒▒▒▒▓▓▓▓░░▓▓
────▓▓░░░░██████▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▓░░░░▓▓
────▓▓▓░████▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓
─────▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓
─────▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓
──────▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓
───────▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓
─────────▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓
───────────▓▓▓▓▓▓▒▒▒▒▒▓▓▓▓
───────────────▓▓▓▓▓▓▓▓
"
echo "Please grab a cup of coffe and wait... it's going to take a bit"
echo "Installing Packages..."
# Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux Detected"
    packageManager='sudo apt install'
    if [ -x "$(command -v apk)" ];       then $packageManager=$(sudo apk add --no-cache)
    elif [ -x "$(command -v apt-get)" ]; then $packageManager=$(sudo apt install)
    elif [ -x "$(command -v dnf)" ];     then $packageManager=$(sudo dnf install)
    elif [ -x "$(command -v zypper)" ];  then $packageManager=$(sudo zypper install)
    xargs $packageManager < packages.txt
# MacOS
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "MacOS Detected"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap Homebrew/bundle
    brew bundle --file Brewfile
fi
echo "Installing VS Code extensions"
#Installing VS Code extensions
cat vs_extensions.txt | xargs -L 1 code --install-extension 
echo "Installing JetBrains Font"
#Installing JetBrains Font
wget https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip -P ./font/
unzip ./font/JetBrainsMono-2.242.zip -d ./font/

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    mkdir ~/.local/share/fonts
    mv font/fonts/ttf/* ~/.local/share/fonts
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mv font/fonts/ttf/* /Library/Fonts
fi
fc-cache -f -v

# Installing oh-my-zsh
echo "Installing Oh My ZSH"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm ~/.zshrc
rm ~/.zshrc.pre-oh-my-zsh
mv ~/.oh-my-zsh "(pwd)/dotfiles/"

# Installing Dracula Theme for ZSH
git clone https://github.com/dracula/zsh.git "$(pwd)/dotfiles/.zsh_theme/dracula"
ln -s $(pwd)/dotfiles/.zsh_theme/dracula.zsh-theme $(pwd)/dotfiles/.oh-my-zsh/themes/dracula.zsh-theme
echo "Installing ZSH plugins"
# Installing ZSH Plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $(pwd)dotfiles/.oh-my-zsh/plugins/zsh-syntax-highlighting/
git clone https://github.com/zsh-users/zsh-autosuggestions $(pwd)dotfiles/.oh-my-zsh/plugins/zsh-autosuggestions/
echo "Creating Symbolik links for .files"
# Create Symbolic Link
ln -s "$(pwd)/dotfiles/.gitconfig" ~/.gitconfig
ln -s "$(pwd)/dotfiles/.bash_profile" ~/.bash_profile
ln -s "$(pwd)/dotfiles/.oh-my-zsh" ~/.oh-my-zsh
ln -s "$(pwd)/dotfiles/.zshrc" ~/.zshrc
# Importing VS Code settings.json
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ln -s "$(pwd)/dotfiles/settings.json" ~/.config/Code/User/settings.json
# MacOS
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ln -s "$(pwd)/dotfiles/settings.json" ~/Library/"Application Support"/Code/User/settings.json
fi
echo "Done!"