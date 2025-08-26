# Requirements
After setting up on fresh Ubuntu server, here's what I needed

## General useful utilities
`sudo apt install build-essential libreadline-dev unzip`


## Set up ZSH
Kind of annoyed at the whole zsh setup process. Need to look into fish, my problem is that my zsh setup feels immobile
- Install zsh - [Link](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
    - Set zsh as default shell `chsh -s $(which zsh)`
- Install Zap, Zsh plugin manager - [Link](https://github.com/zap-zsh/zap?tab=readme-ov-file#install)

## General stuff
- `lazygit` - [Link](https://github.com/jesseduffield/lazygit?tab=readme-ov-file#installation)
- tree-sitter cli (necessary for LATEX) - [Link](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md)
- fd - [Link](https://github.com/sharkdp/fd?tab=readme-ov-file#installation)
- Latex2text - `sudo apt install python3-pylatexenc`

## Languages
- Rust - [Link](https://www.rust-lang.org/tools/install)
    - `rust-analyzer` - `rustup component add rust-analyzer`
- Go - [Link](https://go.dev/doc/install)
    - `gopls` - [Link](https://go.dev/gopls/#installation)
- JavaScript (via nvm) - [Link](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating)
    - `typescript-language-server` - `npm install -g typescript-language-server typescript`
- Lua - [Link](https://github.com/luarocks/luarocks/blob/main/docs/installation_instructions_for_unix.md#quick-start)
    - `lua-language-server` - [Link](https://github.com/LuaLS/lua-language-server/releases)
    - LuaRocks - [Link](https://github.com/luarocks/luarocks/blob/main/docs/download.md)
- Markdown
    - Marksman - [Link](https://github.com/artempyanykh/marksman/releases)
- Python
    - Pyright - [Link](https://github.com/microsoft/pyright/blob/main/docs/installation.md) (I used `npm` method)

