#!/bin/bash
# Create Symbolic Link
ln -s "$(pwd)/dotfiles/.gitconfig" ~/.gitconfig
ln -s "$(pwd)/dotfiles/.bash_profile" ~/.bash_profile
ln -s "$(pwd)/dotfiles/.zshrc" ~/.zshrc
ln -s "$(pwd)/dotfiles/.zsh_plugins" ~/.zsh_plugins

# Installing ZSH Plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git dotfiles/.zsh_plugins/zsh-syntax-highlighting/
echo "source $HOME/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

#Installing Packages
# Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux Detected"
    xargs sudo apt install < packages.txt
# MacOS
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "MacOS Detected"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap Homebrew/bundle
    brew bundle --file Brewfile
fi

#Installing VS Code extensions
cat vs_extensions.txt | xargs -L 1 code --install-extension 

echo "Done!"