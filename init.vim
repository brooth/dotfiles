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
"completion in command line
set wildmenu

"ctrl+space - omni complition
imap <NUL> <c-x><c-o>
set complete=.,w,b,u,t,k

" Display what command is waiting for an operator
set showcmd

" redraw only when we need to.
"set lazyredraw

"---------------------------------------------
"                misc maps
"---------------------------------------------
"disable ex mode
:map Q <Nop>

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

" do not store vimrc options in session
set ssop-=options

nmap <m-s>w :mksession! <c-r>r/.vimsession<cr>
nmap <m-s>r :source <c-r>r/.vimsession<cr>

" tell it to use an undo file
set undofile
" set a directory to store the undo history
set undodir=~/.config/nvim/undo

"---------------------------------------------
"                  buffers
"---------------------------------------------
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
"#let g:ag_working_path_mode="r"
nmap <leader>ff :Ack ""<Left>
nmap <leader>fw :Ack "<C-R><C-W>"
nmap <leader>fW :Ack "\b<C-R><C-W>\b"

"---------------------------------------------
"             windows/tabs
"---------------------------------------------
set splitright
set splitbelow

" windows
nmap <c-j> <C-w><Down>
nmap <c-h> <C-w><Left>
nmap <c-l> <C-w><Right>
nmap <c-k> <C-w><Up>

" tabs
nmap <m-j> :tabprev<CR>
nmap <m-k> :tabnext<CR>

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
nmap <m-n> :pu e<cr>k
nmap <m-N> :pu! e<cr>j
nmap <m-m> :m +1<CR>
nmap <m-M> :m -2<CR>
nmap <m-d> yyp
nmap <m-D> yyP

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
nmap ,ct :%s/\s\+$//e<cr>

nmap ,co :lopen<cr>
nmap ,cn :lnext<cr>
nmap ,cp :lprevious<cr>

"---------------------------------------------
"                files/types
"---------------------------------------------
set wildignore+=*/bin/*
set wildignore+=*.class
set wildignore+=*.pyc
set wildignore+=*/build/^[^g]*

"ft = filetype
autocmd BufRead,BufNewFile *.gradle set ft=java

"---------------------------------------------
"                plugins
"---------------------------------------------
call plug#begin('~/.config/nvim/plugged')
Plug 'https://github.com/altercation/vim-colors-solarized.git'
Plug 'https://github.com/bling/vim-airline.git'
Plug 'vim-airline/vim-airline-themes'
Plug 'https://github.com/SirVer/ultisnips.git'
Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'https://github.com/mileszs/ack.vim.git'
Plug 'https://github.com/majutsushi/tagbar.git'
Plug 'https://github.com/simnalamburt/vim-mundo.git'
Plug 'https://github.com/Shougo/deoplete.nvim.git'
Plug 'https://github.com/nvie/vim-flake8.git'
Plug 'https://github.com/davidhalter/jedi-vim.git'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-surround'
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'
Plug 'https://github.com/Yggdroot/indentLine.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'airblade/vim-gitgutter'
call plug#end()

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
"                 deoplete
"---------------------------------------------
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_completion_start_length = 1

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

autocmd BufRead *.py inoremap <expr> <Tab>  pumvisible() ? "\<C-n>" : deoplete#mappings#manual_complete()

"---------------------------------------------
"                eclim & java
"---------------------------------------------
au BufEnter *.java silent let @c=GetCanonicalClassName()
au BufEnter *.java silent let @s=GetSimpleClassName()

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
let g:ctrlp_by_filename = 1
let g:ctrlp_working_path_mode = '0'
let g:ctrlp_use_caching = 1

nmap <m-\> :CtrlPBuffer<CR>
nmap <m-P> :CtrlP <cr><c-\>w
nmap \ :CtrlPMRUFiles<cr>
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

" wget
" https://raw.githubusercontent.com/mhartington/oceanic-next/master/autoload/airline/themes/oceanicnext.vim
" -P ~/.config/nvim/plugged/vim-airline-themes/autoload/airline/themes/
" let s:cterm0B = "166"
" let s:cterm09 = "37"
" let s:cterm09 = "37"
" let s:cterm0D = "67"
let g:airline_theme='oceanicnext'

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
nmap <F4> :MundoToggle<cr>
imap <F4> <esc><f4>

"---------------------------------------------
"                solarized
"---------------------------------------------
colorscheme solarized
set background=dark

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
