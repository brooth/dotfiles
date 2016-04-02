"---------------------------------------------
"                key scheme
"---------------------------------------------
" Ctrl+R %    - copy current file name into command line
" * (<s-8>)   - serch/highlight word
" q:          - command history
" gv          - re-select last visual selection
"
" search & replace
" :args `ag -l <search> **/*.java`
" :argdo %s/<search>/<replace>/gc

"---------------------------------------------
"                plugins
"---------------------------------------------
if has('nvim')
    let $VIMHOME = "~/.config/nvim"
    "normal mode in terminal by Esc
    tnoremap <Esc> <C-\><C-n>
else
    let $VIMHOME = "~/.vim"
endif

call plug#begin('$VIMHOME/plugged')
Plug 'morhetz/gruvbox'
Plug 'bling/vim-airline'
Plug 'SirVer/ultisnips'
Plug 'majutsushi/tagbar'
Plug 'simnalamburt/vim-mundo'
Plug 'nvie/vim-flake8'
Plug 'davidhalter/jedi-vim'
Plug 'tpope/vim-surround'
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'
Plug 'artur-shaik/vim-javacomplete2'
Plug 'scrooloose/syntastic'
Plug 'hsanson/vim-android'
Plug 'tpope/vim-repeat'
Plug 'haya14busa/incsearch.vim'
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/unite-outline'
Plug 'Shougo/vimfiler.vim'

if has('nvim')
    Plug 'Shougo/deoplete.nvim'
else
    Plug 'Shougo/neocomplete.vim'
endif

call plug#end()

let g:indentLine_faster = 1

"---------------------------------------------
"                misc settings
"---------------------------------------------
filetype plugin indent on

let mapleader=" "

set pastetoggle=<F12>
set history=100
"completion in command line
set wildmenu

"no mouse support
set mouse = ""

"F1 - Esc
imap <F1> <Esc>
nmap <F1> <Esc>
vmap <F1> <Esc>

"ctrl+space - omni complition
imap <NUL> <c-x><c-o>
set complete=.,w,b,u,t,k

"Display what command is waiting for an operator
set showcmd

"redraw only when we need to.
set lazyredraw

"---------------------------------------------
"                misc maps
"---------------------------------------------
"disable ex mode
:map Q <Nop>

"yeah
map Y y$

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
nmap <leader>E :e!<cr>

"do not store vimrc options in session
set ssop-=options

nmap <leader>S :mksession! <c-r>r/.vimsession<cr>
nmap <leader>R :source <c-r>r/.vimsession<cr>

"tell it to use an undo file
set undofile
"set a directory to store the undo history
exec 'set undodir='.$VIMHOME.'/undo'

"store swp files in die
exec 'set dir='.$VIMHOME.'/tmp'

"---------------------------------------------
"                  buffers
"---------------------------------------------
nmap <leader>bD :%bd<cr>:e #<cr>

"---------------------------------------------
"          search/replace/subtitude
"---------------------------------------------
"case sensetive search in CtrlP if enter capitals
set smartcase
"with smartcase ignores case when all in lowercase
set ignorecase
"highlight search
set hlsearch
"highlight search while typing
set incsearch

"no hightlight
nmap <F3> :noh<CR>
imap <F3> <esc>:noh<CR>

"incsearch plugin
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

nmap [q :cprev<cr>
nmap ]q :cnext<cr>

if executable('ag')
    set grepprg=ag\ --nogroup\ --column\ --nocolor
    set grepformat=%f:%l:%C:%m
endif

"---------------------------------------------
"             windows/tabs
"---------------------------------------------
set splitright
set splitbelow

nmap <leader>1 1<c-w><c-w>
nmap <leader>2 2<c-w><c-w>
nmap <leader>3 3<c-w><c-w>
nmap <leader>4 4<c-w><c-w>

"windows
nmap <c-j> <C-w><Down>
nmap <c-h> <C-w><Left>
nmap <c-l> <C-w><Right>
nmap <c-k> <C-w><Up>

"tabs
nmap <leader>j :tabprev<CR>
nmap <leader>k :tabnext<CR>
nmap <leader>te :tabe %<cr>

"---------------------------------------------
"               intend/tab/spaces
"---------------------------------------------
"move curson over empty space
set virtualedit=all

"indent when moving to the next line while writing code<Paste>
set autoindent

"set smartindent
"set smarttab

set tabstop=4
"when using the >> or << commands, shift lines by 4 spaces
set shiftwidth=4
set softtabstop=4
"expand tabs into spaces
set expandtab

"show vertical line
"set colorcolumn=80

"indent text in visual mode
vmap < <gv
vmap > >gv

"---------------------------------------------
"            lines/numbers/wrap
"---------------------------------------------
"go between wrapped lines
map j gj
map k gk
map <Down> gj
map <Up> gk

set number
"releative line numbers
set rnu
"show a visual line under the cursor's current line
set cursorline
set nowrap
"keep 3 lines below and above cursor
set scrolloff=3
"show bracket pair
"set showmatch

"line number/scroll/highlight
nmap <leader>ll :set nornu<cr>:set number<CR>
nmap <leader>lr :set number<cr>:set rnu<cr>
nmap <leader>lw :set wrap!<cr>
nmap <leader>ln :set nonumber<cr>:set nornu<cr>

"folding
set foldmethod=manual

au BufWinEnter *.java,*.py silent! loadview
au BufWinLeave *.java,*.py mkview

"fold file header (e.g. license javadoc)
nmap zh mmggzf%`m
"fold current brackets
nmap ze zf%

"Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

"---------------------------------------------
"               correct
"---------------------------------------------
"trailing
nmap <leader>ct :%s/\s\+$//e<cr>

"goto next, prev. open error
nmap <leader>co :lopen<cr>
nmap ]c :lnext<cr>
nmap [c :lprevious<cr>

"---------------------------------------------
"                files/types
"---------------------------------------------
set wildignore+=*/bin/*
set wildignore+=*.class
set wildignore+=*.pyc
set wildignore+=*/build/^[^g]*

"---------------------------------------------
"                python
"---------------------------------------------
" <leader>g - goto assingment
" <leader>d - goto definitions
" K - pydoc
" <leader>r - renaming
" <leader2n - usages
"
"enable all Python syntax highlighting features
let python_highlight_all = 1

autocmd FileType python setlocal completeopt-=preview
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufRead *.py set nocindent

"flake8
"let g:flake8_show_in_gutter=1
let g:flake8_show_in_file=1

autocmd BufWritePost *.py call Flake8()

"jedi
let g:jedi#show_call_signatures = "1"
let g:jedi#popup_select_first = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#completions_enabled = 0

"---------------------------------------------
"               java
"---------------------------------------------
au BufEnter *.java silent let @c=GetCanonicalClassName()
au BufEnter *.java silent let @s=GetSimpleClassName()

autocmd BufRead,BufNewFile *.gradle set ft=java
autocmd FileType java setlocal omnifunc=javacomplete#Complete

"let g:android_sdk_path="~/Android/Sdk"
"let g:gradle_path="~/.gradle-2.6"
let g:gradle_daemon=1

let g:tagbar_autofocus = 1
map <F8> :TagbarToggle<CR>

function! GetCanonicalClassName()
    return system("ctags -f - -u --java-kinds=pc " . expand('%:p') . " | grep -m 2 -o '^[^	]*' | tr '\\n' '.' | sed 's/.$/\\n/'")
endfunction

function! GetSimpleClassName()
    return system("ctags -f - -u --java-kinds=c " . expand('%:p') . " | grep -m 1 -o '^[^	]*'")
endfunction

"---------------------------------------------
"                git
"---------------------------------------------
"hunks
nmap <leader>hv <Plug>GitGutterPreviewHunk
nmap <leader>h[ <Plug>GitGutterPrevHunk
nmap <leader>h] <Plug>GitGutterNextHunk
nmap <Leader>hu <Plug>GitGutterRevertHunk
nmap <Leader>ha <Plug>GitGutterStageHunk
"no mappings by gitgutter
let g:gitgutter_map_keys = 0

"---------------------------------------------
"         neocomplete/deoplete
"---------------------------------------------
if has('nvim')
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#enable_smart_case = 1
    let g:deoplete#auto_completion_start_length = 1

else
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#sources#syntax#min_keyword_length = 1
endif

inoremap <expr> <Tab>  pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <s-Tab>  pumvisible() ? "\<C-p>" : "\<s-Tab>"

"set completeopt=longest,menu,menuone
"todo: until the lag is
let g:deoplete#ignore_sources = {}
let g:deoplete#ignore_sources.java = ['javacomplete2']

"---------------------------------------------
"                  Unite
"---------------------------------------------
let g:unite_winheight = 13
let g:unite_source_history_yank_enable = 1
let g:unite_source_rec_max_cache_files = 1000
let g:unite_prompt = '» '
let g:unite_source_rec_async_command = ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']

let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--line-numbers --nocolor --nogroup --hidden --smart-case'
let g:unite_source_grep_recursive_opts = ''

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

function! <SID>UniteSetup()
    nmap <buffer> <Esc> <plug>(unite_exit)
    imap <buffer> <Esc> <plug>(unite_exit)
endfunction
autocmd FileType unite call <SID>UniteSetup()

nmap <leader>u :Unite -buffer-name=files
                \ -buffer-name=files
                \ -start-insert
                \ -no-split
                \ buffer neomru/file file_rec/neovim file/new directory/new<CR>
nmap <leader>U :UniteWithBufferDir
                \ -buffer-name=./files
                \ -start-insert
                \ -no-split
                \ buffer neomru/file file_rec/neovim file/new directory/new<CR>
nmap <leader>g :Unite -buffer-name=grep
                \ -no-split 
                \ grep:.<cr>
nmap <leader>o :Unite -buffer-name=outline
                \ -no-split
                \ -start-insert
                \ outline<cr>

"---------------------------------------------
"                 vimfiler
"---------------------------------------------
"let g:vimfiler_ignore_pattern = '^\%(.git\|.idea)$'

nmap <leader>f :VimFilerCurrentDir<cr>
nmap <leader>F :VimFilerBufferDir<cr>

"---------------------------------------------
"                 markdown
"---------------------------------------------
autocmd BufRead *.md set wrap lbr
autocmd BufEnter *.md set syntax=markdown

"---------------------------------------------
"                ultisnips
"---------------------------------------------
let g:UltiSnipsExpandTrigger="<Nop>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsListSnippets="<F6>"

"respect neosnippet
let g:ulti_expand_or_jump_res = 0
function! <SID>ExpandSnippetOrReturn()
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return snippet
    else
        return "\<C-Y>"
    endif
endfunction
imap <expr> <CR> pumvisible() ? "<C-R>=<SID>ExpandSnippetOrReturn()<CR>" : "\<CR>"

"---------------------------------------------
"                vimux
"---------------------------------------------
let g:VimuxHeight = "40"
let @r=getcwd()

nmap <Leader>vl :VimuxRunLastCommand<CR>
nmap <Leader>vq :VimuxCloseRunner<CR>
nmap <Leader>vi :VimuxInspectRunner<CR>
nmap <Leader>vz :call VimuxZoomRunner()<CR>

"---------------------------------------------
"                theme
"---------------------------------------------
set background=dark
colorscheme gruvbox

"---------------------------------------------
"                airline
"---------------------------------------------
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#fnamemod = ':t'

let g:airline_theme='oceanicnext'

"---------------------------------------------
"                Gundo
"---------------------------------------------
nmap <F4> :MundoToggle<cr>
imap <F4> <esc><f4>
