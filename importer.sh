#!/bin/bash
ln -s "$(pwd)/dotfiles/.gitconfig" ~/.gitconfig

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
echo "Done!"