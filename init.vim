"---------------------------------------------
"                key scheme
"---------------------------------------------
" Ctrl+R %    - copy current file name into command line
" * (<s-8>)   - serch/highlight word
" q:          - command history
" gv          - re-select last visual selection

"---------------------------------------------
"                misc settings
"---------------------------------------------
let mapleader=" "

if has('nvim')
    let $VIMHOME = "~/.config/nvim"
    " normal mode in terminal by Esc
    tnoremap <Esc> <C-\><C-n>
else
    let $VIMHOME = "~/.vim"
endif

set pastetoggle=<m-P>
set history=100
"completion in command line
set wildmenu

" no mouse support
set mouse = ""

" F1 - Esc
imap <F1> <Esc>
nmap <F1> <Esc>
vmap <F1> <Esc>

"ctrl+space - omni complition
imap <NUL> <c-x><c-o>
set complete=.,w,b,u,t,k

" Display what command is waiting for an operator
set showcmd

" redraw only when we need to.
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

" do not store vimrc options in session
set ssop-=options

nmap <leader>S :mksession! <c-r>r/.vimsession<cr>
nmap <leader>R :source <c-r>r/.vimsession<cr>

" tell it to use an undo file
set undofile
" set a directory to store the undo history
exec 'set undodir='.$VIMHOME.'/undo'

" store swp files in die
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
"#let g:ag_working_path_mode="r"
nmap <leader>ff :Ack ""<Left>
nmap <leader>fw :Ack "<C-R><C-W>"
nmap <leader>fW :Ack "\b<C-R><C-W>\b"

"---------------------------------------------
"             windows/tabs
"---------------------------------------------
set splitright
set splitbelow

nmap <leader>1 1<c-w><c-w>
nmap <leader>2 2<c-w><c-w>
nmap <leader>3 3<c-w><c-w>
nmap <leader>4 4<c-w><c-w>

" windows
nmap <c-j> <C-w><Down>
nmap <c-h> <C-w><Left>
nmap <c-l> <C-w><Right>
nmap <c-k> <C-w><Up>

" tabs
nmap <leader>J :tabprev<CR>
nmap <leader>K :tabnext<CR>

"---------------------------------------------
"               intend/tab/spaces
"---------------------------------------------
" move curson over empty space
set virtualedit=all

" indent when moving to the next line while writing code<Paste>
set autoindent

"set smartindent
"set smarttab

set tabstop=4
" when using the >> or << commands, shift lines by 4 spaces
set shiftwidth=4
set softtabstop=4
" expand tabs into spaces
set expandtab

" show vertical line
"set colorcolumn=80

" indent text in visual mode
vmap < <gv
vmap > >gv

"---------------------------------------------
"            lines/numbers/wrap
"---------------------------------------------
" go between wrapped lines
map j gj
map k gk
map <Down> gj
map <Up> gk

set number
"releative line numbers
set rnu
" show a visual line under the cursor's current line
set cursorline
set nowrap
set scrolloff=3             " Keep 3 lines below and above cursor
" show the matching part of the pair for [] {} and ()
set showmatch

" line number/scroll/highlight
nmap <leader>ll :set nornu<cr>:set number<CR>
nmap <leader>lr :set number<cr>:set rnu<cr>
nmap <leader>lw :set wrap!<cr>
nmap <leader>ln :set nonumber<cr>:set nornu<cr>

" new/move lines
let @e=''

nmap zs :call ToogleScrollMode()<CR>

"folding
set foldmethod=manual

au BufWinEnter *.java,*.py silent! loadview
au BufWinLeave *.java,*.py mkview

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
nmap <leader>ct :%s/\s\+$//e<cr>

nmap <leader>co :lopen<cr>
nmap <leader>cn :lnext<cr>
nmap <leader>cp :lprevious<cr>

"---------------------------------------------
"                files/types
"---------------------------------------------
set wildignore+=*/bin/*
set wildignore+=*.class
set wildignore+=*.pyc
set wildignore+=*/build/^[^g]*

"---------------------------------------------
"                plugins
"---------------------------------------------
call plug#begin('$VIMHOME/plugged')
Plug 'morhetz/gruvbox'
Plug 'bling/vim-airline'
Plug 'SirVer/ultisnips'
Plug 'scrooloose/nerdtree'
Plug 'mileszs/ack.vim'
Plug 'majutsushi/tagbar'
Plug 'simnalamburt/vim-mundo'
Plug 'nvie/vim-flake8'
Plug 'davidhalter/jedi-vim'
Plug 'ctrlpvim/ctrlp.vim'
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

if has('nvim')
    Plug 'Shougo/deoplete.nvim'
else
    Plug 'Shougo/neocomplete.vim'
endif

call plug#end()
filetype plugin indent on

let g:indentLine_faster = 1

"---------------------------------------------
"                vimux
"---------------------------------------------
let g:VimuxHeight = "40"
let @r=getcwd()

nmap <Leader>ml :VimuxRunLastCommand<CR>
nmap <Leader>mq :VimuxCloseRunner<CR>
nmap <Leader>mi :VimuxInspectRunner<CR>
nmap <Leader>mz :call VimuxZoomRunner()<CR>

"---------------------------------------------
"                 markdown
"---------------------------------------------
autocmd BufRead *.md set wrap lbr

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
"                ultisnips
"---------------------------------------------
let g:UltiSnipsExpandTrigger="<Nop>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsListSnippets="<F6>"

" respect neosnippet
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
"                python
"---------------------------------------------
" enable all Python syntax highlighting features
let python_highlight_all = 1

autocmd FileType python setlocal completeopt-=preview
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd BufRead *.py set nocindent

" flake8
"let g:flake8_show_in_gutter=1
let g:flake8_show_in_file=1

autocmd BufWritePost *.py call Flake8()

" jedi
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

"---------------------------------------------
"                ctrlp
"---------------------------------------------
let g:ctrlp_by_filename = 1
let g:ctrlp_working_path_mode = '0'
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 1

nmap <leader>p :CtrlP<cr>
nmap <leader>P :CtrlPMRUFiles<cr>
nmap <leader><c-p> :CtrlP<cr><c-\>w<cr>
nmap <leader>C :CtrlPChange<CR>
nmap <leader>T :CtrlPTag<CR>
nmap \ :CtrlPLine<cr>

if executable('ag')
    let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
                \ --ignore .git
                \ --ignore .svn
                \ --ignore .DS_Store
                \ --ignore "**/*.pyc"
                \ -g ""'
endif

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
"                nerd tree
"---------------------------------------------
let NERDTreeWinSize=46
let NERDTreeHighlightCursorline = 1

let NERDTreeIgnore=['\.pyc$', '\.pyo$', '\.py\$class$', '^\.git$' ]

nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>N :NERDTreeFind<CR>

"---------------------------------------------
"                Gundo
"---------------------------------------------
nmap <F4> :MundoToggle<cr>
imap <F4> <esc><f4>

"---------------------------------------------
"                  Ack
"---------------------------------------------

"---------------------------------------------
"             functions
"---------------------------------------------
" ReplaceInFiles
function! ReplaceInFiles(o, n)
    exec "Ack '" . a:o . "'"
    if empty(getqflist())
        return
    endif

    let l:c = "%s/" . escape(a:o, '\') . "/" . escape(a:n, '\') . "/g"
    let l:p = input('additinal params? (q=quit) :' . l:c)
    if l:p == "q"
        exec "bd %"
        return
    endif

    exec "call QuickFixDoAll(\"" . l:c . l:p . "\")"
endfunction

function! ReplaceInFilesExact(o, n)
    exec "Ack '\\b" . a:o . "\\b'"
    if empty(getqflist())
        return
    endif

    let l:c = "%s/\\\\<" . escape(a:o, '\') . "\\\\>/" . escape(a:n, '\') . "/g"
    let l:p = input('additinal params? (q=quit) :' . l:c)
    if l:p == "q"
        exec "bd %"
        return
    endif

    exec "call QuickFixDoAll(\"" . l:c . l:p . "\")"
endfunction

" QuickFixDoAll
function! QuickFixDoAll(command)
    if empty(getqflist())
        return
    endif
    exec "only"
    let s:prev_val = ""
    for d in getqflist()
        let s:curr_val = bufname(d.bufnr)
        if (s:curr_val != s:prev_val)
            exec "edit " . s:curr_val
            exec a:command
            exec "write"
        endif
        let s:prev_val = s:curr_val
    endfor
    "exec "quit"
endfunction
command! -nargs=+ QuickFixDoAll call QuickFixDoAll(<f-args>)

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

function! GetCanonicalClassName()
    return system("ctags -f - -u --java-kinds=pc " . expand('%:p') . " | grep -m 2 -o '^[^	]*' | tr '\\n' '.' | sed 's/.$/\\n/'")
endfunction

function! GetSimpleClassName()
    return system("ctags -f - -u --java-kinds=c " . expand('%:p') . " | grep -m 1 -o '^[^	]*'")
endfunction
