#!/bin/bash

brew bundle dump --force
echo -e "cask_args appdir: '/Applications'\n$(cat Brewfile)" > Brewfile

code --list-extensions | sort > vs_extensions.txt

terminal-notifier -title "Config Backup" -subtitle "Daily Update" -message "Completed"
echo "Config Saved at $now"