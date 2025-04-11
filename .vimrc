vmap J :m +1 <Esc>V
vmap K :m -2 <Esc>V

vmap <Tab> >gv
vmap <S-Tab> <gv
tnoremap <Esc> <C-\><C-n>

set nocompatible

filetype indent plugin on

syntax on

" Allows switching between files easier
set hidden

set wildmenu

set showcmd

set hlsearch

set ignorecase
set smartcase

set backspace=indent,eol,start

set autoindent
set nostartofline

set ruler

set laststatus=2
set confirm

set visualbell

set t_vb=
set mouse=a

set cmdheight=2

set clipboard=unnamed

set number
set relativenumber
set scrolloff=10

set notimeout ttimeout ttimeoutlen=200

map Y y$

nnoremap <C-L> :nohl<CR><C-L>

vmap <C-x> :!pbcopy<CR>
vmap <C-c> :!pbcopy<CR><CR>
