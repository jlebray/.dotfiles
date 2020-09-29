# VERSIONS
RUBY_VERSION="2.7.1"
PYTHON2_VERSION="2.7.18"
PYTHON3_VERSION="3.8.5"
NODE_VERSION="14"

# Download Brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Install packages
brew install rbenv pyenv postgresql diff-so-fancy rg zsh nvm pyenv-virtualenv
brew tap heroku/brew && brew install heroku

# Add ZSH to shells
if ! grep -q "/usr/local/bin/zsh" /etc/shells; then
  echo "/usr/local/bin/zsh" >> /etc/shells
fi
chsh -s /usr/local/bin/zsh

# SDKMAN!
curl -s "https://get.sdkman.io" | bash

# Ruby
eval "$(rbenv init -)"
rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION

# Python
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv install $PYTHON2_VERSION
pyenv install $PYTHON3_VERSION
pyenv virtualenv $PYTHON2_VERSION neovim2
pyenv virtualenv $PYTHON3_VERSION neovim3

# Node
nvm install $NODE_VERSION
nvm use $NODE_VERSION

# Nvim hosts
gem install neovim
pyenv activate neovim2
pip install pynvim
source deactivate
pyenv activate neovim3
pip install pynvim
source deactivate
npm install -g neovim

# Postgresql
brew services start postgresql
