let mapleader = " "
" Disables all default mappings, leaving commented until I run into an issue
" let g:vimwiki_ext2syntax = {}

call plug#begin()
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-markdown' " Shouldn't be needed in modern versions of VIM, apparently
  Plug 'tpope/vim-fugitive' " Git plugin
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'vimwiki/vimwiki'
  Plug 'preservim/nerdtree'
call plug#end()

" Override Vimwiki to use Notes path and markdown instead of .wiki
let g:vimwiki_list = [{'path': '~/Notes/',
                      \ 'syntax': 'markdown', 'ext': 'md'}]
" Tell Vimwiki to only use files in above path as wiki pages (instead of
" globally)
let g:vimwiki_global_ext = 0

vmap <Tab> >gv
vmap <S-Tab> <gv

tnoremap <Esc> <C-\><C-n>

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

" Enable syntax highlighting
syntax on

" Vim with default settings does not allow easy switching between multiple files
" in the same editor window. Users can use multiple split windows or multiple
" tab pages to edit multiple files, but it is still best to enable an option to
" allow easier switching between files.
" One such option is the 'hidden' option, which allows you to re-use the same
" window and switch from an unsaved buffer without saving it first. Also allows
" you to keep an undo history for multiple files when re-using the same window
" in this way. Note that using persistent undo also lets you undo in multiple
" files even in the same window, but is less efficient and is actually designed
" for keeping undo history after closing Vim entirely. Vim will complain if you
" try to quit without saving, and swap files will keep you safe if your computer
" crashes.
set hidden

" Set netrw style to tree style
let g:netrw_liststyle=3

" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window as mentioned above, and/or either of the following options:
" set autowriteall

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Enable use of the mouse for all modes
set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Set the clipboard to the system's
set clipboard=unnamed

" Display line numbers on the left
set number
set relativenumber
set scrolloff=10

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <Esc> :nohl<CR><C-L>
nnoremap j gj
nnoremap k gk

" Splits
nnoremap <leader>sx <C-w>q
nnoremap <leader>sd <C-w>s
nnoremap <leader>sv <C-w>v
" Navigation
nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
" Tabs
nnoremap <S-h> :bp<CR>
nnoremap <S-l> :bn<CR>
nnoremap <leader>x :bd<CR>

nnoremap <leader>n :NERDTreeToggle<CR>
" nnoremap <C-n> :NERDTree<CR>
" nnoremap <C-t> :NERDTreeToggle<CR>
" nnoremap <C-f> :NERDTreeFind<CR>

" CTRL-x (cut) and CTRL-c (copy)
vmap <C-x> :!pbcopy<CR>
vmap <C-c> :w !pbcopy<CR><CR>
