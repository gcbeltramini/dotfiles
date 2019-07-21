# Functions
# =========

cdl() {
  # Change directory and list directory contents.
  #
  # Usage:
  #   cdl /path/to/folder
  #   cdl -
  cd "$1" && ls
}

declare -a cdh__dirs_history
declare -i cdh__idx=0

cdh() {
  # Change directory and store history. Useful to use "cdh -".
  #
  # Usage:
  #   cd folder0; cdh folder1; cdh folder2; cdh folder3
  #   cdh -  # move to folder2; "cd -" will do the same
  #   cdh -  # move to folder1; "cd -" will move to folder3
  #   cdh -  # stay in folder1
  if [[ "$1" != "-" ]]; then
    [[ "${cdh__idx}" -eq 0 ]] && cdh__dirs_history[cdh__idx]=$(pwd)  # necessary for the first use of "cdh"
    cd "$1"
    cdh__idx=$((++cdh__idx))  # or: cdh__idx+=1
    cdh__dirs_history[cdh__idx]=$(pwd)
  elif [[ "${cdh__idx}" -gt 0 ]]; then
    cdh__dirs_history[cdh__idx]=""
    cdh__idx=$((--cdh__idx))
    cd "${cdh__dirs_history[$cdh__idx]}"
  fi
}

source_if_exists() {
  # Run `source` if file exists.
  # 
  # Usage:
  #   source_if_exists i_exist
  #   source_if_exists i_dont_exist
  [[ -f "$1" ]] && source "$1" || :
}

is_valid_command() {
  # Check if command is exists.
  #
  # Usage:
  #   is_valid_command foo && echo "'foo' exists"
  #   is_valid_command ls && echo "'ls' exists"
  command -v "${1}" > /dev/null
}

brew-update-all() {
  brew update
  brew upgrade
  brew cask upgrade
  brew cleanup -s

  echo -e "\n\033[34mInstalled Casks that have newer versions available in the tap,"
  echo -e "including the Casks that have \`auto_updates true\` or \`version :latest\`:\033[0m"
  brew cask outdated --greedy
  echo -e "\n\033[34mTo install them, run \`brew cask upgrade <program-name>\`.\033[0m"

}

conda-update-all() {
  conda update -n base conda --yes -c defaults
  conda update --all --yes -c defaults
  conda clean --all --yes
}


# To handle non-ASCII characters
# ==============================
export LC_ALL=en_US.UTF-8
# export LANG=en_US.UTF-8  http://pubs.opengroup.org/onlinepubs/7908799/xbd/envvar.html#tag_002_002


# Aliases
# =======

# Git
# ---
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gco="git checkout"
alias gd="git diff"
alias gf="git fetch --all --prune"
alias gm="git merge"
alias gp="git pull"
alias gs="git status"
#alias gl="git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias master="gf && gm origin/master"
# git config --global alias.please 'push --force-with-lease'
# =>
# git please = git push --force-with-lease


# General
# -------
alias desktop="cd ${HOME}/Desktop/"
alias downloads="cd ${HOME}/Downloads/"
alias ll="ls -lAhF --color=always --time-style='+%Y-%m-%d %H:%M:%S %z' \
  | sed 1d"
# `ls` must be GNU-ls. In MacOS, `ls` will be `gls`: $ brew install coreutils
alias lsfiles="ls -l | grep -v '^d' | sed 1d"  # "sed 1d" or "tail -n +2" to remove the first line
alias lsdir="ls -l | grep '^d' --color=never"
alias nb="jupyter notebook"
alias myip-internal="ipconfig getifaddr en0"  # only in macOS
alias myip-external="curl ipecho.net/plain ; echo"  # or: "curl ifconfig.me"
alias mybash="subl ${HOME}/.bash_profile"
alias treeclean="tree -a -I '.idea|target|.git'"

# Python
# ------
alias pip="python3 -m pip"


# Utilities
# =========

# ranger (https://github.com/ranger/ranger) - brew install ranger
# ------
# navigate and display file content. When exit, enter the last folder
alias rg='ranger --choosedir=${HOME}/.rangerdir; LASTDIR=`cat ${HOME}/.rangerdir`; cd "${LASTDIR}"'
# Source: https://superuser.com/a/1043815


# Git
# ===

# git-prompt.sh: display current branch in bash (variable `__git_ps1`)
# -------------
# Following http://git-prompt.sh/, run in the terminal:
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o "${HOME}"/.git-prompt.sh
GIT_PROMPT_FILE="${HOME}/.git-prompt.sh"

# git-completion.sh: autocomplete git subcommands and other useful stuff
# -----------------
# Documentation: https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
# Analogous to git-prompt.sh:
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o "${HOME}"/.git-completion.bash
GIT_COMPLETION_FILE="${HOME}/.git-completion.bash"

if is_valid_command brew; then
  # brew install bash-completion@2 git
  GIT_PROMPT_FILE="$(brew --prefix)/etc/bash_completion.d/git-prompt.sh"
  GIT_COMPLETION_FILE="$(brew --prefix)/etc/bash_completion.d/git-completion.bash"
fi
source_if_exists "${GIT_PROMPT_FILE}"
source_if_exists "${GIT_COMPLETION_FILE}"

# Add git completion to aliases
if [ -f "${GIT_COMPLETION_FILE}" ]; then
  __git_complete ga _git_add
  __git_complete gb _git_branch
  __git_complete gco _git_checkout
  __git_complete gd _git_diff
  __git_complete gf _git_fetch
  __git_complete gm _git_merge
  __git_complete gp _git_pull
fi


# Appearance
# ==========
export HISTTIMEFORMAT="%Y-%m-%d %T "
export CLICOLOR=1  # in macOS, equivalent to: ls -G
export LEIN_SUPPRESS_USER_LEVEL_REPO_WARNINGS=true
alias sbt="TERM=xterm-color sbt -Dscala.color"
# References:
# - https://github.com/sbt/sbt/issues/3240#issuecomment-306421046 (enables autocomplete and navigation with arrows)
# - https://stackoverflow.com/a/33832205/7649076 (color in the REPL)
alias spark-shell='spark-shell --conf spark.driver.extraJavaOptions="-Dscala.color"'

# Custom prompt
# -------------

export PS1="\n[\D{%T}] \[\033[1;34m\]\u \[\033[1;32m\]\w\[\033[0m\]"

# Git
export GIT_PS1_SHOWDIRTYSTATE=true # unstaged ('*') and staged ('+') changes next to the branch name
export GIT_PS1_SHOWSTASHSTATE=true # '$' next to the branch name if something is stashed
export GIT_PS1_SHOWUNTRACKEDFILES=true # '%' next to the branch name if there are untracked files
export GIT_PS1_SHOWUPSTREAM="auto verbose" # difference between HEAD and its upstream: '<' (you are behind), '>' (you are ahead), '<>' (you have diverged), '=' (no difference)
export GIT_PS1_DESCRIBE_STYLE="branch" # more information (relative to newer tag or branch) about the identity of commits checked out as a detached HEAD
export GIT_PS1_SHOWCOLORHINTS=true # colored hint about the current dirty state; allow when using PROMPT_COMMAND
if [ -f "${GIT_PROMPT_FILE}" ]; then
  export PS1="${PS1}\[\033[0;31m\]\$(__git_ps1 \" (%s)\")\[\033[0m\]"
fi

export PS1="${PS1}\[\033[0m\] \$ "


# Programs
# ========

# Default editor
# --------------
export EDITOR="subl -w -n"

# Homebrew
# --------
if is_valid_command brew; then export PATH="$(brew --prefix)/sbin:${PATH}"; fi

# jEnv
# ----
if is_valid_command jenv; then
  export PATH="${HOME}/.jenv/bin:${PATH}"
  eval "$(jenv init -)";
fi

# rbenv
# -----
if is_valid_command rbenv; then eval "$(rbenv init -)"; fi

# Miniconda/Anaconda Python
# -------------------------
# miniconda (conda >= 4.4)
# export PATH="${HOME}/miniconda3/bin:$PATH"
# Deprecated: https://github.com/conda/conda/blob/0734fdf12f112b5a2a1ced81526715a08ef29519/CHANGELOG.md#recommended-change-to-enable-conda-in-your-shell
. "${HOME}/miniconda3/etc/profile.d/conda.sh"
conda activate base


# Autocomplete
# ============

# https://docs.brew.sh/Shell-Completion
if is_valid_command brew; then
  
  case $- in
    *e* ) set_e=true && set +e ;;
    * )   set_e=false ;;
  esac
  
  for completion_file in $(brew --prefix)/etc/bash_completion.d/*; do
    source "${completion_file}"
  done
  
  # bash-completion@2
  source_if_exists "$(brew --prefix)/share/bash-completion/bash_completion"
  
  [[ "${set_e}" = true ]] && set -e
  
fi

source_if_exists "${NUCLI_HOME}/nu.bashcompletion"


# Utilities
# =========
export CODE_HOME="${HOME}/code"
export CUSTOM_PATH="${CODE_HOME}/gcbeltramini/dotfiles/.custom"
UTILS_FILE="${CUSTOM_PATH}/utils"
source_if_exists "${UTILS_FILE}"
export PATH="${CUSTOM_PATH}:${PATH}"


# Tokens
# ======
TOKEN_FILE="${HOME}/.credentials/tokens"
source_if_exists "${TOKEN_FILE}"


# Spark
# =====
# export PYSPARK_SUBMIT_ARGS="--master local[2]"
# alias pyspark-ipython="PYSPARK_DRIVER_PYTHON=ipython pyspark"  # needs $SPARK_HOME
# alias pyspark-jupyter="PYSPARK_DRIVER_PYTHON=jupyter PYSPARK_DRIVER_PYTHON_OPTS=\"notebook\" pyspark"  # needs $SPARK_HOME
# After running `$ pyspark`, import os; os.environ['SPARK_HOME'] results in "/usr/local/Cellar/apache-spark/2.0.1/libexec"
# because Spark was installed with `brew` so it's not necessary to:
# export SPARK_HOME="/usr/local/Cellar/apache-spark/2.2.0/libexec/"
# export PATH="$SPARK_HOME/bin:$PATH"
