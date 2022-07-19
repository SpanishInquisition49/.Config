#!/bin/bash

InstallPackages() {
    echo "Installing Packages..."
    # Linux
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Linux Detected"
        packageManager='sudo apt install'
        if [ -x "$(command -v apk)" ];       then $packageManager=$(sudo apk add --no-cache)
        elif [ -x "$(command -v apt-get)" ]; then $packageManager=$(sudo apt install)
        elif [ -x "$(command -v dnf)" ];     then $packageManager=$(sudo dnf install)
        elif [ -x "$(command -v zypper)" ];  then $packageManager=$(sudo zypper install)
        elif [ -x "$(command -v pacman)"]; then $packageManager=$(sudo pacman -S)
        cat packages.txt | xargs $packageManager
    # MacOS
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "MacOS Detected"
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        brew tap Homebrew/bundle
        brew bundle --file Brewfile
    fi
}

InstallVsCodeExtensions() {
    echo "Installing VS Code extensions..."
    #Installing VS Code extensions  
    cat vs_extensions.txt | xargs -L 1 code --install-extension 
}

InstallFont() {
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
}

InstallOhMyZsh() {
    # Installing oh-my-zsh
    echo "Installing Oh My ZSH"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed 's:env zsh::g' | sed 's:chsh -s .*$::g')"
    rm ~/.zshrc
    rm ~/.zshrc.pre-oh-my-zsh
    mv ~/.oh-my-zsh "(pwd)/dotfiles/"
}

InstallDraculaPro() {
    # Installing Dracula Pro
    echo "Installing Dracula Pro"
    unzip "Dracula Pro - Zeno Rocha.zip" -d DraculaPro
    ln -s $(pwd)/DraculaPro/themes/zsh/dracula-pro.zsh-theme $(pwd)/dotfiles/.oh-my-zsh/themes/dracula-pro.zsh-theme
    code --install-extension DraculaPro/themes/visual-studio-code/dracula-pro.vsix
}

InstallZshPlugins() {
    echo "Installing ZSH plugins"
    # Installing ZSH Plugins
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$(pwd)dotfiles/.oh-my-zsh/plugins/zsh-syntax-highlighting/"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$(pwd)dotfiles/.oh-my-zsh/plugins/zsh-autosuggestions/"
    git clone https://github.com/wbingli/zsh-wakatime.git "$(pwd)/dotfiles/.oh-my-zsh/plugins/zsh-wakatime"
}

CreateSymbolicLink() {
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
}

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

InstallPackages
InstallVsCodeExtensions
InstallFont
InstallOhMyZsh
InstallDraculaPro
InstallZshPlugins
CreateSymbolicLink

echo "Done!"