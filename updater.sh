#!/bin/bash

brew bundle dump --force
echo -e "cask_args appdir: '/Applications'\n$(cat Brewfile)" > Brewfile

code --list-extensions > vs_extensions.txt