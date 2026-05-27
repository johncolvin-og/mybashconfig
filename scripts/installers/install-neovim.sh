#!/usr/bin/env bash

# this_dir="${BASH_SOURCE[0]}"
# echo "nargs: $#"
# echo "nbash: ${#BASH_SOURCE[@]}"
# echo "$this_dir"
# echo "$0"
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz

tar -xf nvim-linux-x86_64.tar.gz
install_dir=/usr/local/
rsync -a nvim-linux-x86_64/ $install_dir
rm -rf nvim-linux-x86_64

