# Functions
# =========

source_if_exists() {
  # Run `source` if file exists.
  #
  # Usage:
  #   source_if_exists <filename>
  #
  # Examples:
  #   source_if_exists i_exist      # file will be source'd
  #   source_if_exists i_dont_exist # nothing will be done
  [[ -f "$1" ]] && source "$1" || :
}

is_valid_command() {
  # Check if command is exists.
  #
  # Usage:
  #   is_valid_command <command>
  #
  # Examples:
  #   is_valid_command foo && echo "'foo' exists"
  #   is_valid_command ls && echo "'ls' exists"
  command -v "${1}" > /dev/null
}


# Initialize
# ==========
source_if_exists "${HOME}/.bashrc"
[[ "${BASH_VERSINFO[0]}" -ge 4 ]] && shopt -s autocd  # change directory without `cd`
if is_valid_command brew && [[ -z "${HOMEBREW_PREFIX:-}" ]]; then
  HOMEBREW_PREFIX="$(brew --prefix)"
fi


# To handle non-ASCII characters
# ==============================
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8


# Aliases
# =======

# Git
# ---
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gco="git checkout"
alias gd="git diff"
alias gf="git fetch --all"
alias gl="git log"
alias gm="git merge"
alias gp="git pull"
alias gs="git status"

# General
# -------
alias desktop="cd ${HOME}/Desktop/"
alias downloads="cd ${HOME}/Downloads/"
alias treeclean="tree -a -I '.idea|target|.git'"


# Git
# ===

if is_valid_command brew; then
  # brew install bash-completion@2 git
  GIT_PROMPT_FILE="${HOMEBREW_PREFIX}/etc/bash_completion.d/git-prompt.sh"
  GIT_COMPLETION_FILE="${HOMEBREW_PREFIX}/etc/bash_completion.d/git-completion.bash"
fi
source_if_exists "${GIT_PROMPT_FILE}"
source_if_exists "${GIT_COMPLETION_FILE}"

# Add git completion to aliases
if [[ -f "${GIT_COMPLETION_FILE}" ]]; then
  __git_complete ga _git_add
  __git_complete gb _git_branch
  __git_complete gc _git_commit
  __git_complete gco _git_checkout
  __git_complete gd _git_diff
  __git_complete gf _git_fetch
  __git_complete gm _git_merge
  __git_complete gp _git_pull
  __git_complete gs _git_status
fi


# Appearance
# ==========
export HISTTIMEFORMAT="%Y-%m-%d %T "
export CLICOLOR=1

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
if [[ -f "${GIT_PROMPT_FILE}" ]]; then
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
if is_valid_command brew; then
  export PATH="${HOMEBREW_PREFIX}/sbin:${PATH}"
fi

# jEnv
# ----
if is_valid_command jenv; then
  export PATH="${HOME}/.jenv/bin:${PATH}"
  eval "$(jenv init -)";
fi

# node
# ----
# https://nodejs.org/api/modules.html
if is_valid_command node && [[ -n "$HOMEBREW_PREFIX" ]]; then
  export NODE_PATH="${HOMEBREW_PREFIX}/lib/node_modules"
fi


# Autocomplete
# ============

 [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"

# Utilities
# =========
CUSTOM_PATH="$(dirname ${BASH_SOURCE[0]})/.custom"
source_if_exists "${CUSTOM_PATH}/utils"
export PATH="${CUSTOM_PATH}:${PATH}"


# Tokens
# ======
TOKEN_FILE="${HOME}/.credentials/tokens"
source_if_exists "${TOKEN_FILE}"
