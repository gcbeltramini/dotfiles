#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# Homebrew
# ------------------------------------------------------------

# Install Homebrew (https://brew.sh/):

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> "$HOME/.zprofile"

eval "$(/opt/homebrew/bin/brew shellenv)"

# ------------------------------------------------------------
# Apps
# ------------------------------------------------------------

# Install cask apps:
# - IntelliJ CE (https://www.jetbrains.com/idea/)
# - iTerm2 (https://iterm2.com/)
# - MeetingBar (https://meetingbar.app/)
# - PyCharm CE (https://www.jetbrains.com/pycharm/)
# - Rancher Desktop (https://rancherdesktop.io/)
# - Rectangle (https://rectangleapp.com/)
# - Sublime Text (https://www.sublimetext.com/)
# - VLC (https://www.videolan.org/vlc/)
# - Visual Studio Code (https://code.visualstudio.com/)
brew install --cask \
  intellij-idea-ce \
  iterm2 \
  meetingbar \
  pycharm-ce \
  rancher \
  rectangle \
  sublime-text \
  vlc \
  visual-studio-code

# ------------------------------------------------------------
# Utilities
# ------------------------------------------------------------

brew install \
  awscli \
  bash \
  bat \
  coreutils \
  fzf \
  gawk \
  grep \
  gsed \
  htop \
  jenv \
  jq \
  ruff \
  shellcheck \
  sponge \
  tree \
  uv \
  wget

# ------------------------------------------------------------
# oh-my-zsh (https://github.com/ohmyzsh/ohmyzsh)
# ------------------------------------------------------------

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ------------------------------------------------------------
# zsh plugins
# ------------------------------------------------------------

# autoupdate-oh-my-zsh-plugins (https://github.com/tamcore/autoupdate-oh-my-zsh-plugins)
# zsh-autosuggestions (https://github.com/zsh-users/zsh-autosuggestions)
# conda-zsh-completion (https://github.com/conda-incubator/conda-zsh-completion)
# zsh-syntax-highlighting (https://github.com/zsh-users/zsh-syntax-highlighting)
# zsh-completions (https://github.com/zsh-users/zsh-completions)
# fast-syntax-highlighting (https://github.com/zdharma/fast-syntax-highlighting):

git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoupdate
git clone https://github.com/conda-incubator/conda-zsh-completion.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/conda-zsh-completion
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/z-shell/F-Sy-H.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/F-Sy-H

# ------------------------------------------------------------
# Powerlevel10k (https://github.com/romkatv/powerlevel10k)
# ------------------------------------------------------------

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
