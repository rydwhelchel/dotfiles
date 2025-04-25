# Open zellij
# eval "$(zellij setup --generate-auto-start zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"

# Powerlevel 10k
plug "romkatv/powerlevel10k"

# Load and initialise completion system
autoload -Uz compinit
compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Add NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Aliases
## [L]i[s]t [a]ll
alias lsa="ls -a"
## Leftover remnant from the dotfile repo stuff I was doing, probably worth returning to this style
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
## Lists out line with internalip
alias internalip='ifconfig | grep "inet 1"'
## [F]ind file
alias f='nvim "$(fzf)"'
## [B]ack-[U]p [D]ots -- -r for folders
alias bud='mkdir .bak/
cp ~/.zshrc ~/.bak/
cp ~/.vimrc ~/.bak/
cp -r ~/.config ~/.bak/
cp ~/.gitconfig ~/.bak/
cp ~/.p10k.zsh ~/.bak/
cp ~/.zprofile ~/.bak/
'

## [Y]azi
alias y='yazi'

## [C]argo [p]x
alias carp='cargo px'

# Set the path for NVIM and add nvim as the default editor
export PATH="$PATH:/opt/nvim-linux64/bin"
export EDITOR=nvim
export GIT_EDITOR=nvim
export PATH=~/bin:$PATH
export PATH=/home/rdub/.cache/rebar3/bin:$PATH
export PATH=~/go/bin:$PATH
export PATH=$PATH:~/zig/zig-0.14.0
# export PATH=$PATH:~/zig/zig-0.15.0-DEV
export PATH=$HOME//opt/homebrew/Cellar/erlang/27.3/lib/erlang/erts-15.2.3/bin:$PATH
export PATH=$HOME//opt/homebrew/bin:$PATH

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


# bun completions
[ -s "/Users/ryanwhelchel/.bun/_bun" ] && source "/Users/ryanwhelchel/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/Users/ryanwhelchel/.deno/bin:$PATH"
export PATH="/Users/ryanwhelchel/.config/emacs/bin:$PATH"
# Prepending path in case a system-installed rustc needs to be overridden
export PATH="/Users/ryanwhelchel/.local/bin/rust/bin:$PATH"
