"---------------------------------------------
"                key scheme
"---------------------------------------------
" Ctrl+R %    - copy current file name into command line
" * (<s-8>)   - serch/highlight word
" q:          - command history

"---------------------------------------------
"                misc settings
"---------------------------------------------
filetype plugin indent on

let mapleader=","

set pastetoggle=<m-p>
set history=100
"$ sing in the change mode
"set cpoptions+=$
"completion in command line
set wildmenu

set showcmd                     " Display what command is waiting for an operator
set noequalalways               " Don't resize when closing a window

" auto reload .vimrc
"autocmd! bufwritepost .vimrc source %

"---------------------------------------------
"                misc maps
"---------------------------------------------
nmap <leader><leader> :

"disable ex mode
:map Q <Nop>
"redraws screen
nmap <F5> <C-L>

"insert mode
imap <c-h> <left>
imap <c-k> <up>
imap <c-j> <down>
imap <c-l> <right>

"---------------------------------------------
"          save/restore/quit
"---------------------------------------------
"save current file with F2
nnoremap <F2> :w<CR>
inoremap <F2> <Esc>:w<CR>
nnoremap <F10> :q<CR>

set ssop-=options " do not store vimrc options

nmap <m-s>w :mksession! <c-r>r/.vimsession<cr>
nmap <m-s>r :source <c-r>r/.vimsession<cr>

"---------------------------------------------
"                  buffers
"---------------------------------------------
"nmap <leader>b :ls<cr>:b
"nmap <leader>bd :ls<cr>:bd
nmap <leader>b% :%bd<cr>:e #<cr>

"---------------------------------------------
"          search/replace/subtitude
"---------------------------------------------
"case sensetive search in CtrlP if enter capitals
set smartcase
"highlight search
set hlsearch
"highlight search while typing
set incsearch

"no hightlight
nmap <F3> :noh<CR>
imap <F3> <esc>:noh<CR>

"replace (subsitute)
nmap <leader>ss :%s//gc<Left><Left><Left>
nmap <leader>sw ,ss<C-R><C-W>/
nmap <leader>sW ,ss\<<C-R><C-W>\>/

nmap <leader>rr :call ReplaceInFiles("")<Left><Left>
nmap <leader>rw :call ReplaceInFiles("<C-R><C-w>", "")<Left><Left>
nmap <leader>rW :call ReplaceInFilesExact("<C-R><C-w>", "")<Left><Left>
nmap <leader>re :call ReplaceInFilesExact("")<Left><Left>

"Ag
let g:ag_working_path_mode="r"
nmap <leader>ff :Ag ""<Left>
nmap <leader>fw :Ag "<C-R><C-W>"
nmap <leader>fW :Ag "\b<C-R><C-W>\b"

"---------------------------------------------
"             windows/tabs
"---------------------------------------------
set splitright

" windows
"nmap <c-j> <C-w><Down>
"nmap <c-h> <C-w><Left>
"nmap <c-l> <C-w><Right>

" tabs
nmap <m-j> :tabprev<CR>
nmap <m-k> :tabnext<CR>

"---------------------------------------------
"               tabs/spaces
"---------------------------------------------
"set virtualedit=all
set autoindent
"set smartindent

"set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4
" spaces instead of tab
set expandtab

" doc width
set colorcolumn=80

" indent text in visual mode
vmap < <gv
vmap > >gv

"---------------------------------------------
"            lines/numbers/wrap
"---------------------------------------------
set number
"releative line numbers
set rnu
set cursorline
set nowrap
set scrolloff=3             " Keep 3 lines below and above cursor

" line number/scroll/highlight
nmap <leader>ll :set nornu<cr>:set number<CR>
nmap <leader>lr :set number<cr>:set rnu<cr>
nmap <leader>lw :set wrap!<cr>
nmap <leader>ln :set nonumber<cr>:set nornu<cr>

" new/move lines
let @e=''
nmap <m-n> :pu e<cr>k
nmap <m-N> :pu! e<cr>j
nmap <m-m> :m +1<CR>
nmap <m-M> :m -2<CR>
nmap <m-d> yyp
nmap <m-D> yyP

nmap zs :call ToogleScrollMode()<CR>

"folding
"au BufWinEnter *.java silent! loadview
au BufWinLeave *.java mkview

nmap zh mmggzf%`m
nmap ze zf%

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

"---------------------------------------------
"               correct
"---------------------------------------------
nmap ,ct :%s/\s\+$//e<cr>

nmap ,co :lopen<cr>
nmap ,cn :lnext<cr>
nmap ,cp :lprevious<cr>

"---------------------------------------------
"                files/types
"---------------------------------------------
set wildignore+=*/bin/*
set wildignore+=*.class
set wildignore+=*/build/^[^g]*

"ft = filetype
autocmd BufRead,BufNewFile *.gradle set ft=java

"---------------------------------------------
"                plugins
"---------------------------------------------
call plug#begin('~/.config/nvim/plugged')
Plug 'https://github.com/altercation/vim-colors-solarized.git'
Plug 'https://github.com/bling/vim-airline.git'
Plug 'https://github.com/SirVer/ultisnips.git'
Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'https://github.com/rking/ag.vim.git'
Plug 'https://github.com/majutsushi/tagbar.git'
Plug 'https://github.com/simnalamburt/vim-mundo.git'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-surround'
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'
Plug '~/projects/vim-plugins/scroll_mode.vim'
Plug '~/projects/vim-plugins/replace_all_files.vim'
Plug '~/projects/vim-plugins/java_class_name.vim'
call plug#end()

"---------------------------------------------
"                vimux
"---------------------------------------------
let g:VimuxHeight = "40"
let @r=getcwd()

nmap <Leader>ml :VimuxRunLastCommand<CR>
nmap <Leader>mq :VimuxCloseRunner<CR>
nmap <Leader>mi :VimuxInspectRunner<CR>
nmap <Leader>mq :VimuxCloseRunner<CR>
nmap <Leader>mz :call VimuxZoomRunner()<CR>

"---------------------------------------------
"                eclim & java
"---------------------------------------------
au BufEnter *.java silent let @c=GetCanonicalClassName()
au BufEnter *.java silent let @s=GetSimpleClassName()

imap <NUL> <c-x><c-u>
nmap <leader>jP :ProjectProblems<cr>
nmap <leader>jc :JavaCorrect<cr>
nmap <leader>jf :%JavaFormat<cr>
nmap <leader>ji :JavaImport<cr>
nmap <leader>jI :JavaImportOrganize<cr>
nmap <leader>jl :JavaImpl<cr>
nmap <leader>jd :JavaDocPreview<cr><c-k>
nmap <leader>jD :JavaDocSearch<cr><c-k>
nmap <leader>js :JavaSearchContext -a<cr><c-k>
nnoremap <silent> <buffer> <cr> :JavaSearchContext<cr>

map <F8> :TagbarToggle<CR><c-l>

"---------------------------------------------
"                ctrlp
"---------------------------------------------
"let g:ctrlp_map = '\'
let g:ctrlp_by_filename = 1
let g:ctrlp_working_path_mode = '0'
let g:ctrlp_use_caching = 1

nmap <m-p> :CtrlP <cr><c-\>w
nmap <c-m-p> :CtrlPMRUFiles<cr>
nmap \ :CtrlPBuffer<CR>
nmap <m-c> :CtrlPChange<CR>
nmap <m-t> :CtrlPBufTag<CR>
nmap <m-T> :CtrlPBufTag<CR><c-\>w

"---------------------------------------------
"                ultisnips
"---------------------------------------------
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsListSnippets="<F6>"

"---------------------------------------------
"                airline
"---------------------------------------------
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#fnamemod = ':t'

"---------------------------------------------
"                nerd tree
"---------------------------------------------
let NERDTreeWinSize=46

nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>nn :NERDTreeToggle<CR>
nmap <leader>nf :NERDTreeFind<CR>
nmap <leader>nq :NERDTreeClose<CR>
nmap <leader>n0 :let NERDTreeQuitOnOpen=0<CR>
nmap <leader>n1 :let NERDTreeQuitOnOpen=1<CR>

"---------------------------------------------
"                Gundo
"---------------------------------------------
nmap <F4> :GundoToggle<cr>
imap <F4> <esc><f4>

"---------------------------------------------
"                solarized
"---------------------------------------------
colorscheme solarized
set background=dark

"---------------------------------------------
"                  Ag
"---------------------------------------------
if executable('ag')
    " Note we extract the column as well as the file and line number
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    set grepformat=%f:%l:%c%m
endif

"---------------------------------------------
"             QuickFixOpenAll
"---------------------------------------------
function! QuickFixOpenAll()
    if empty(getqflist())
        return
    endif
    let s:prev_val = ""
    for d in getqflist()
        let s:curr_val = bufname(d.bufnr)
		if s:curr_val != s:prev_val
            exec "tabnew " . s:curr_val
        endif
        let s:prev_val = s:curr_val
    endfor
endfunction
command! QuickFixOpenAll call QuickFixOpenAll()
