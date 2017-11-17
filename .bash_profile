# Initialize
# ==========

export CUSTOM_PATH="${HOME}/.custom"

source_if_exists() {
  # Run `source` if file exists
  # 
  # Usage:
  #   source_if_exists i_exist
  #   source_if_exists i_dont_exist

  if [ -f "$1" ]; then
    source "$1"
    return 0
  fi
  return 1
}


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
alias desktop="cd ${HOME}/Desktop/"
alias downloads="cd ${HOME}/Downloads/"
alias ll="gls -lAhF --color=always --time-style='+%Y-%m-%d %H:%M:%S %z' \
  | sed 1d"
# install `gls` with:
# $ brew install coreutils
alias lsfiles="ls -l | grep -v '^d' | sed 1d"  # "sed 1d" or "tail -n +2" to remove the first line
alias lsdir="ls -l | grep '^d'"
alias nb="jupyter notebook"
alias myip="ipconfig getifaddr en0"
export CLICOLOR=1  # ls -G


# Utilities
# =========

UTILS_FILE="${CUSTOM_PATH}/utils"
source_if_exists "${UTILS_FILE}"
export PATH="${CUSTOM_PATH}:${PATH}"


# TOKENS
# ======

TOKEN_FILE="${CUSTOM_PATH}/tokens"
source_if_exists "${TOKEN_FILE}"


# To handle non-ASCII characters
# ==============================
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8


# Spark
# =====
# export PYSPARK_SUBMIT_ARGS="--master local[2]"
# alias pyspark-ipython="PYSPARK_DRIVER_PYTHON=ipython pyspark"  # needs $SPARK_HOME
# alias pyspark-jupyter="PYSPARK_DRIVER_PYTHON=jupyter PYSPARK_DRIVER_PYTHON_OPTS=\"notebook\" pyspark"  # needs $SPARK_HOME
# After running `$ pyspark`, import os; os.environ['SPARK_HOME'] results in "/usr/local/Cellar/apache-spark/2.0.1/libexec"
# because Spark was installed with `brew` so it's not necessary to:
# export SPARK_HOME="/usr/local/Cellar/apache-spark/2.2.0/libexec/"
# export PATH="$SPARK_HOME/bin:$PATH"


# Git
# ===

# git-prompt.sh: display current branch in bash (variable `__git_ps1`)
# -------------
# Following http://git-prompt.sh/, run in the terminal:
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o "${HOME}"/.git-prompt.sh
GIT_PROMPT_FILE="${HOME}/.git-prompt.sh"
source_if_exists "${GIT_PROMPT_FILE}"

# git-completion.sh: autocomplete git subcommands and other useful stuff
# -----------------
# Documentation: https://github.com/git/git/blob/master/contrib/completion/git-completion.bash

# Analogous to get-prompt.sh:
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o "${HOME}"/.git-completion.bash
source_if_exists "${HOME}/.git-completion.bash"

# Add git completion to aliases
__git_complete ga _git_add
__git_complete gb _git_branch
__git_complete gco _git_checkout


# Custom prompt
# =============

export PS1="\n[\D{%T}] \[\033[0;34m\]\u \[\033[1;32m\]\w\[\033[0m\]"

# Git
export GIT_PS1_SHOWDIRTYSTATE=true # unstaged ('*') and staged ('+') changes next to the branch name
export GIT_PS1_SHOWSTASHSTATE=true # '$' next to the branch name if something is stashed
export GIT_PS1_SHOWUNTRACKEDFILES=true # '%' next to the branch name if there're untracked files
export GIT_PS1_SHOWUPSTREAM="auto verbose" # difference between HEAD and its upstream: '<' (you are behind), '>' (you are ahead), '<>' (you have diverged), '=' (no difference)
export GIT_PS1_DESCRIBE_STYLE="branch" # more information (relative to newer tag or branch) about the identity of commits checked out as a detached HEAD
export GIT_PS1_SHOWCOLORHINTS=true # colored hint about the current dirty state; allow when using PROMPT_COMMAND
if [ -f "${GIT_PROMPT_FILE}" ]; then
  export PS1="${PS1}\[\033[0;31m\]\$(__git_ps1 \" (%s)\")\[\033[0m\]"
fi

export PS1="${PS1}\[\033[00m\] \$ "
