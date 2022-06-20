#!/bin/bash
ln -s "$(pwd)/.gitconfig" ~/.gitconfig

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap Homebrew/bundle
brew bundle --file Brewfile
echo "Done!"