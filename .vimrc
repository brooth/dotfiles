"----------------------------------------------------------------
"                           plugins
"----------------------------------------------------------------
call plug#begin('~/.vim/plugged')
Plug 'flazz/vim-colorschemes'
Plug 'brooth/far.vim'
call plug#end()

"----------------------------------------------------------------
"                           misc
"----------------------------------------------------------------
filetype plugin indent on

set wildmenu
set showcmd

exec 'set path='.getcwd().','.getcwd().'/**'

set undodir=$HOME/.vim/undo//
set noswapfile

"----------------------------------------------------------------
"                   search/replace/subtitude
"----------------------------------------------------------------
set smartcase
set ignorecase
set incsearch
set hlsearch

"no hightlight
nmap <F3> :noh<CR>
imap <F3> <esc>:noh<CR>

"far.vim
let g:far#debug = 1
let g:far#window_width = 60
let g:far#auto_preview = 1
let g:far#preview_window_height = 7
let g:far#auto_write_replaced_buffers = 0
let g:far#confirm_fardo = 1
let g:far#check_window_resize_period = 0
let g:far#file_mask_favorites = ['%', '**/*.*', '**/*.py', '**/*.vim', '**/*.txt']

"----------------------------------------------------------------
"                       indent/tab/spaces
"----------------------------------------------------------------
set tabstop=4
set shiftwidth=4
set softtabstop=4

set cursorline
set nowrap

"----------------------------------------------------------------
"                       files/types
"----------------------------------------------------------------
set wildignore+=*/.git/*

"----------------------------------------------------------------
"                           theme
"----------------------------------------------------------------
colorscheme gruvbox
set background=dark
set t_Co=256
