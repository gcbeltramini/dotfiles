
# Aliases
# =======

# Git
# ---
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gs="git status"
alias gco="git checkout"
alias gl="git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
alias master="git pull origin master"
# git config --global alias.please 'push --force-with-lease'
# =>
# git please = git push --force-with-lease


# General
# -------
alias up="cd .."
alias desktop="cd ~/Desktop/"
alias downloads="cd ~/Downloads/"
alias ll="ls -la"
alias nb="jupyter notebook"
alias myip="ipconfig getifaddr en0"


# To handle non-ASCII characters
# ==============================
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8


# Spark
# =====
# export PYSPARK_SUBMIT_ARGS="--master local[2]"
alias pyspark-ipython="PYSPARK_DRIVER_PYTHON=ipython pyspark"
alias pyspark-jupyter="PYSPARK_DRIVER_PYTHON=jupyter PYSPARK_DRIVER_PYTHON_OPTS=\"notebook\" pyspark"
# $ pyspark
# >>> import os; os.environ['SPARK_HOME']  # "/usr/local/Cellar/apache-spark/2.0.1/libexec"
export SPARK_HOME="/usr/local/Cellar/apache-spark/2.1.0/libexec/"
export PATH="$SPARK_HOME/bin:$PATH"


# Git
# ===

# git-prompt.sh: display current branch in bash (variable `__git_ps1`)
# -------------
# Following http://git-prompt.sh/, run in the terminal:
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
source ~/.git-prompt.sh

# git-completion.sh: autocomplete git subcommands and other useful stuff
# -----------------
# Documentation: https://github.com/git/git/blob/master/contrib/completion/git-completion.bash

# Analogous to get-prompt.sh:
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
source ~/.git-completion.bash


export GIT_PS1_SHOWDIRTYSTATE="true" # add a * to the branch name if the branch has been changed
export PS1="\[\033[0;34m\]\\u \[\033[01;32m\]\\w\[\033[0;31m\]\$(__git_ps1 \" (%s)\")"

# Add git completion to aliases
__git_complete ga _git_add
__git_complete gb _git_branch
__git_complete gco _git_checkout


# Custom prompt
# =============

# export PS1="\[\033[0;34m\]\\u \[\033[01;32m\]\\w\[\033[0;31m\]" # if you don't have git-prompt.sh
export PS1="\n"$PS1"\[\033[00m\] \$ "
