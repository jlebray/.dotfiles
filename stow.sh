#!/usr/bin/env bash

folders=(
    git
    nvim
    zsh
)

for app in ${folders[@]}; do
    echo "Stowing app: $app"
    stow -v -R -t ${HOME} $app
done
