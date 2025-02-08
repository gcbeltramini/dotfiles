# Setup steps

## macOS setup

Run `macos.sh`

## In file `~/.zshrc`

1. Set `ZSH_THEME="powerlevel10k/powerlevel10k"`
2. Add the plugins to the list of plugins for Oh My Zsh to load:

     ```shell
     plugins=(
       autoupdate
       aws
       colored-man-pages
       conda-zsh-completion
       F-Sy-H # fast-syntax-highlighting
       fzf
       git
       kubectl
       terraform
       web-search
       zsh-autosuggestions
       zsh-syntax-highlighting
     )
     ```

3. Add the following line before `source "$ZSH/oh-my-zsh.sh"`:

     ```shell
     fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
     ```

4. Add this to the section `User configuration`: `export LESS="FRX"`
5. Modify the default text editor:

     ```shell
     # Preferred editor for local and remote sessions
     if [[ -n $SSH_CONNECTION ]]; then
       export EDITOR='vim'
     else
       export EDITOR='subl --new-window --wait'
     fi
     ```

6. Add these lines to the top of the file, where file `update_all.sh` is [this](../.custom/update_all.sh):

     ```shell
     if [ -f "$HOME"/Documents/update_all.sh ]; then
       bash "$HOME"/Documents/update_all.sh # this script runs 1x/week
     fi
     ```

7. Add this section to the end of `~/.zshrc`:

     ```shell
     # >>> CUSTOM >>>
     alias zrc='subl "$HOME/.zshrc"'

     REPOS_HOME="$HOME/Documents/repos/"

     repo() {
       # \`cd\` into repository folder.
       #
       # Usage:
       #   repo [<repo_name>]
       #
       # Examples:
       #   repo
       #   repo my-project
       local -r repo=${1:-}
       cd "${REPOS_HOME}/$repo"
     }

     _repo_complete() {
       _path_files -W "$REPOS_HOME" -/  # `-/` ensures only directories are listed
     }

     # Register the completion
     compdef _repo_complete repo

     # Customize zstyle:
     # (from https://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/#formatting-completion)
     # (this affects the autocompletion of all commands in the terminal)
     # format all messages not formatted in bold prefixed with ----
     zstyle ':completion:*' format '%B---- %d%b'
     # format descriptions (notice the vt100 escapes)
     zstyle ':completion:*:*:*:*:descriptions' format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'
     # bold and underline normal messages
     zstyle ':completion:*:*:*:*:messages' format '%B%U---- %d%u%b'
     # format in bold red error messages
     zstyle ':completion:*:*:*:*:warnings' format "%B$fg[red]%}---- no match for: $fg[white]%d%b"
     # use the tag name as group name
     zstyle ':completion:*' group-name ''
     # activate menu selection
     zstyle ':completion:*' menu select
     # avoid hiding descriptions, enable verbose descriptions
     zstyle ':completion:*' verbose yes

     # <<< CUSTOM >>>
     ```

## Powerlevel10k configuration

Open a new terminal (or run `p10k configure`). In iTerm2 or Termux, `p10k configure` can install the recommended font
for you. Simply answer "Yes" when asked whether to install `Meslo Nerd Font`.

Suggested answers:

- `Prompt Style`: Lean
- `Character Set`: Unicode
- `Prompt Colors`: 256 colors
- `Show current time?`: 12-hour format
- `Prompt Height`: Two lines
- `Prompt Connection`: Dotted
- `Prompt Frame`: Left
- `Connection & Frame Color`: Light
- `Prompt Spacing`: Compact
- `Icons`: Few icons
- `Prompt Flow`: Concise
- `Enable Transient Prompt?`: No
- `Instant Prompt Mode`: Verbose (recommended)

## Git config

```shell
git config --global user.email "yourusernam@yourdomain.com"
git config --global user.name "Your Name"
git config --global fetch.prune true
git config --global pull.rebase false
git config --global push.autoSetupRemote true
git config --global url."ssh://git@github.com/".insteadOf "https://github.com/"
# (for 'terraform init')
git config --global --add includeIf.gitdir:~/repos/open-source/.path ~/.gitconfig-open-source
# (different settings to separate the open-source and private/professional projects)

cat > ~/.gitconfig-open-source <<EOF
[user]
	email = yourusernam@yourdomain.com
	name = Your Name
	signingkey = ~/.ssh/id_ed25519.pub
EOF
```

## GitHub config

References:

- <https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent>
- <https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account#adding-a-new-ssh-key-to-your-account>

```shell
ssh-keygen -t ed25519 -C "yourusernam@yourdomain.com"
# When asked to enter a passphrase, only type enter, i.e., leave it empty.
eval "$(ssh-agent -s)"

echo "Host github.com
  IgnoreUnknown UseKeychain
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
" >> ~/.ssh/config

ssh-add --apple-use-keychain ~/.ssh/id_ed25519

pbcopy < ~/.ssh/id_ed25519.pub
```

1. Go to <https://github.com/settings/ssh/new> and choose:
    - `Title`: choose something to identify your computer
    - `Key type`: `Authentication Key`
    - `Key`: paste your public key (the command `pbcopy` above copies the content of `id_ed25519.pub` to your clipboard)
2. Repeat the process, but now with `Key type` = `Signing Key`

```shell
git config --global gpg.format ssh
git config --global commit.gpgsign true
git config --global user.signingkey ~/.ssh/id_ed25519.pub
echo "$(git config --global user.email) $(cat ~/.ssh/id_ed25519.pub)" > ~/.ssh/allowed_signers
git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowedsigners
```

## Sublime Text

### Install additional dictionaries

Instructions from <https://github.com/titoBouzout/Dictionaries?tab=readme-ov-file#installation>:

1. In the terminal: `mkdir -p "$HOME/Library/Application Support/Sublime Text/Packages/Dictionaries"`
2. Choose the dictionaries from <https://github.com/titoBouzout/Dictionaries> and download the 3 files related to the
   desired language (extensions AFF, DIC, TXT).
3. Move these 3 files into the folder above (there can't be any subfolder)
4. Enable spell checking: in Sublime --> menu `View` --> `Spell Check` (shortcut: F6)
5. Choose a dictionary: in Sublime --> menu `View` --> `Dictionary` --> `Dictionaries`

## Python setup

Run `python_setup.sh`

### Customize Jupyter notebooks

References:

- <https://github.com/jupyter/notebook/blob/main/packages/application/style/base.css>
- <https://jupyter-notebook.readthedocs.io/en/latest/custom_css.html>
- <https://stackoverflow.com/a/76778615>
- <https://github.com/jupyter/notebook/discussions/7152>

If you want to edit one specific Jupyter notebook, run this:

```python
from IPython.display import display, HTML
display(HTML("<style>.jp-Notebook { --jp-notebook-max-width: 95% !important; }</style>"))
# or: display(HTML("<style>:root { --jp-notebook-max-width: 95% !important; }</style>"))
```

The usual solution in CSS file `$(jupyter --config-dir)/custom/custom.css` (typically `~/.jupyter/custom/custom.css`)
doesn't work anymore:

```css
.container {
  width: 95% !important;
}
```

Possible solutions that work (it's only necessary to refresh the browser page where the Jupyter notebook is; the
`!important` rule may not be necessary):

```css
.jp-Notebook {
  --jp-notebook-max-width: 95% !important;
}

:root {
  --jp-notebook-max-width: 95% !important;
}

:root body[data-notebook='notebooks'] {
  --jp-notebook-max-width: 95% !important;
}
```
