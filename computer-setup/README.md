# Setup steps

- [Setup steps](#setup-steps)
  - [macOS setup](#macos-setup)
  - [In file `~/.zshrc`](#in-file-zshrc)
  - [Powerlevel10k configuration](#powerlevel10k-configuration)
  - [Git config](#git-config)
  - [GitHub config](#github-config)
  - [Sublime Text](#sublime-text)
    - [Install additional dictionaries](#install-additional-dictionaries)
  - [Visual Studio Code](#visual-studio-code)
  - [Python setup](#python-setup)
    - [Customize Jupyter notebooks](#customize-jupyter-notebooks)

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

## Visual Studio Code

1. Run the following script to install the VS Code extensions:

    ```shell
    while read -r extension; do
      [[ -z "$extension" || "$extension" =~ ^# ]] && continue # Skip empty lines and comments
      code --install-extension "$extension"
    done <<'EOF'
    aaron-bond.better-comments
    amazonwebservices.aws-toolkit-vscode
    charliermarsh.ruff
    davidanson.vscode-markdownlint
    eamodio.gitlens
    exiasr.hadolint
    foxundermoon.shell-format
    github.copilot
    github.copilot-chat
    gruntfuggly.todo-tree
    hashicorp.terraform
    johnpapa.vscode-peacock
    mkhl.shfmt
    ms-azuretools.vscode-docker
    ms-python.debugpy
    ms-python.python
    ms-python.vscode-pylance
    ms-python.vscode-python-envs
    ms-toolsai.jupyter
    ms-toolsai.jupyter-keymap
    ms-toolsai.jupyter-renderers
    ms-toolsai.vscode-jupyter-cell-tags
    ms-toolsai.vscode-jupyter-slideshow
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    ms-vscode.makefile-tools
    ms-vscode.remote-explorer
    njpwerner.autodocstring
    oderwat.indent-rainbow
    redhat.vscode-yaml
    streetsidesoftware.code-spell-checker
    tamasfe.even-better-toml
    timonwong.shellcheck
    yzhang.markdown-all-in-one
    EOF
    ```

2. Run Cmd+Shift+P and type `Preferences: Open User Settings (JSON)`:

```json
{
    // Files
    // ---------------------------------------------------------------------------------------------
    "files.insertFinalNewline": true,
    "files.trimFinalNewlines": true,
    "files.trimTrailingWhitespace": true,
    // Editor
    // ---------------------------------------------------------------------------------------------
    "editor.rulers": [
        100,
        120
    ],
    "editor.renderWhitespace": "all",
    // Terminal
    // ---------------------------------------------------------------------------------------------
    "terminal.integrated.env.osx": {
        "PATH": "${env:PATH}"
    },
    "terminal.integrated.copyOnSelection": true,
    "terminal.integrated.suggest.enabled": false,
    // VS Code settings
    // ---------------------------------------------------------------------------------------------
    "files.autoSave": "onFocusChange",
    "window.openFoldersInNewWindow": "on",
    "workbench.colorTheme": "Default Dark Modern",
    "workbench.sideBar.location": "right",
    "workbench.startupEditor": "none",
    // Languages
    // ---------------------------------------------------------------------------------------------
    "[github-actions-workflow]": {
        "editor.defaultFormatter": "redhat.vscode-yaml"
    },
    "[markdown]": {
        "editor.defaultFormatter": "DavidAnson.vscode-markdownlint"
    },
    "[python]": {
        // https://github.com/astral-sh/ruff-vscode/tree/main
        "editor.defaultFormatter": "charliermarsh.ruff",
    },
    "autoDocstring.docstringFormat": "numpy",
    // Required extensions to format shell files: 'shell-format', 'shfmt'
    "shfmt.executableArgs": [
        "-i",
        "2"
    ], // indent with 2 spaces, otherwise 'shfmt' will use tabs
    "[shellscript]": {
        "editor.insertSpaces": true,
        "editor.tabSize": 2,
        "editor.detectIndentation": false, // to make sure that "editor.insertSpaces" and "editor.tabSize" are used
    },
    "[terraform]": {
        "editor.defaultFormatter": "hashicorp.terraform",
    },
    "[terraform-vars]": {
        "editor.defaultFormatter": "hashicorp.terraform",
    },
    // Python linter
    // ---------------------------------------------------------------------------------------------
    "ruff.configuration": {
        "format": {
            "quote-style": "preserve"
        },
        "lint": {
            "per-file-ignores": {
                "__init__.py": [
                    "F401",
                    "F403"
                ]
            }
        }
    },
    "ruff.lineLength": 120,
    "ruff.lint.ignore": [
        "AIR001",
        "AIR31",
        "B905",
        "E731",
        "FIX0",
        "PLC0415",
        "S311",
        "TD002",
        "TD003",
        "TID252",
    ],
    "ruff.lint.select": [
        "A003",
        "AIR",
        "B03",
        "B9",
        "D3",
        "DJ",
        "E",
        "EXE",
        "F",
        "FIX",
        "FLY",
        "FURB",
        "I",
        "ICN",
        "INT",
        "ISC",
        "LOG",
        "N81",
        "N9",
        "PIE7",
        "PLC",
        "PLE",
        "PT02",
        "PYI",
        "RSE",
        "RUF1",
        "RUF2",
        "S2",
        "S3",
        "S5",
        "S7",
        "SIM2",
        "SIM3",
        "SIM4",
        "SIM9",
        "SLOT",
        "T10",
        "TCH",
        "TD",
        "TID",
        "UP01",
        "UP02",
        "UP034",
        "UP04",
        "W",
        "YTT",
    ],
    // Remote - SSH
    // ---------------------------------------------------------------------------------------------
    "aws.telemetry": false,
    "remote.SSH.connectTimeout": 120,
    "remote.SSH.defaultExtensions": [
        "amazonwebservices.aws-toolkit-vscode"
    ],
   // Spelling
   // ---------------------------------------------------------------------------------------------
   "cSpell.userWords": [
       "dataframe",
       "venv",
   ],
}
```

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
