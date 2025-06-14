#!/usr/bin/env bash
set -euo pipefail

# Set up Java on your computer: install 'jenv' and Azul Zulu Java (works in architectures x86_64 and arm64).

version=17 # 8, 11, 17, 21, "latest"

new_section() {
    local -r text=$1
    local -r blue='\x1b[34m'
    local -r no_color='\x1b[0m'

    echo -e "\n${blue}${text}${no_color}"
}

new_section "Install 'jenv' and Azul Zulu version $version"
brew install jenv zulu@"$version"

new_section "Edit '$HOME/.zshrc' to set up 'jenv'"
# shellcheck disable=SC2016
if grep -q '^eval "$(jenv init -)"' "$HOME/.zshrc"; then
  echo "'jenv' is already set up in '$HOME/.zshrc'. No changes needed."
else
  cat <<'EOL' >>"$HOME/.zshrc"

# >>> jenv >>>
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
# <<< jenv <<<
EOL
fi

new_section "Enable 'jenv' 'export' plugin"
export PATH="$HOME/.jenv/bin:$PATH"
export PROMPT_COMMAND="" # Fix for unbound PROMPT_COMMAND in non-interactive shells
eval "$(jenv init -)"
jenv enable-plugin export

# new_section "Restart shell"
# source "$HOME/.zshrc"

new_section "Remove current Java versions from 'jenv'"
rm -f ~/.jenv/shims/.jenv-shim
for v in $(jenv versions --bare); do
  jenv remove "$v"
done
rm -f ~/.jenv/version

new_section "Check current state of 'jenv'"
jenv versions --verbose
# jenv doctor
# echo "Run 'jenv remove ...' if you get the error 'jenv: version ... is not installed'"

new_section "Show all 'java' command paths"
java_paths=$(find /Library/Java/JavaVirtualMachines \
  -type f \
  -path '*/Contents/Home/bin/*' \
  -name 'java' |
  sed 's:bin/java$::')
echo "$java_paths"

new_section "Add all 'java' commands to 'jenv'"
while IFS= read -r java_path; do
  jenv add "$java_path"
done <<<"$java_paths"

new_section "Set global Java version"
if [[ $version == 'latest' ]]; then
  global_version=$(
    jenv versions --bare |
      grep '^ *[0-9]' |
      sort -V |
      tail -n 1 |
      grep -oE '^[0-9]+'
  )
elif [[ $version == '8' ]]; then
  global_version='1.8'
else
  global_version="$version"
fi
echo "Setting global Java version to '$global_version'..."
jenv global "$global_version"

new_section "Check current state of 'jenv'"
echo "'jenv versions':"
jenv versions --verbose
echo
echo "'jenv doctor':"
jenv doctor
