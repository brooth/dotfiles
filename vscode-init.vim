"info {{{
" Ctrl+R %    - copy current file name into command line
"
" search & replace
" :args **/*.java OR :args `ag -l <search> **/*.java`
" :argdo %s/<search>/<replace>/ge | update
"
" to clean buffer cache remove sub! dirs ~/.local/share/nvim
"
" replace with register
" [count]["x]gr{motion} - Replace {motion} text with the contents of register x.
" [count]["x]grr          Replace [count] lines with the contents of register x.
" {Visual}["x]gr          Replace the selection with the contents of register x.
"}}}

"base {{{
if has('nvim')
    let $VIMHOME = "~/.config/nvim"
    "normal mode in terminal by Esc
    tnoremap <c-q> <C-\><C-n>
    tnoremap <c-w> <C-\><C-n><c-w>
else
    let $VIMHOME = "~/.vim"
endif
"}}}

" vscode bindings {{{

" folds
nnoremap <silent> za <Cmd>call VSCodeNotify('editor.toggleFold')<CR>
nnoremap <silent> zR <Cmd>call VSCodeNotify('editor.unfoldAll')<CR>
nnoremap <silent> zM <Cmd>call VSCodeNotify('editor.foldAll')<CR>
nnoremap <silent> zo <Cmd>call VSCodeNotify('editor.unfold')<CR>
nnoremap <silent> zO <Cmd>call VSCodeNotify('editor.unfoldRecursively')<CR>
nnoremap <silent> zc <Cmd>call VSCodeNotify('editor.fold')<CR>
nnoremap <silent> zC <Cmd>call VSCodeNotify('editor.foldRecursively')<CR>
nnoremap <silent> z1 <Cmd>call VSCodeNotify('editor.foldLevel1')<CR>
nnoremap <silent> z2 <Cmd>call VSCodeNotify('editor.foldLevel2')<CR>
nnoremap <silent> z3 <Cmd>call VSCodeNotify('editor.foldLevel3')<CR>
nnoremap <silent> z4 <Cmd>call VSCodeNotify('editor.foldLevel4')<CR>
nnoremap <silent> z5 <Cmd>call VSCodeNotify('editor.foldLevel5')<CR>
nnoremap <silent> z6 <Cmd>call VSCodeNotify('editor.foldLevel6')<CR>
nnoremap <silent> z7 <Cmd>call VSCodeNotify('editor.foldLevel7')<CR>
nnoremap <silent> zj <Cmd>call VSCodeNotify('editor.gotoNextFold')<CR>
nnoremap <silent> zk <Cmd>call VSCodeNotify('editor.gotoPreviousFold')<CR>
xnoremap <silent> zV <Cmd>call VSCodeNotify('editor.foldAllExcept')<CR>

nnoremap <silent> ]] <Cmd>call VSCodeNotify('editor.action.marker.next')<CR>
nnoremap <silent> [[ <Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>
" }}}

"plugins {{{
call plug#begin()

" tools
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'tpope/vim-commentary'
Plug 'machakann/vim-swap' "exchange arguments with g< g> gs
Plug 'mbbill/undotree'

" text editing
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

" my boys
" Plug '~/Projects/far.vim'
" Plug '~/Projects/meta-x.vim'

" navigation
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'phaazon/hop.nvim'
Plug 'unblevable/quick-scope' " better f,F,t,T jumping

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

"performace and fixes
"Plug 'antoinemadec/FixCursorHold.nvim'

call plug#end()
"}}}

"misc {{{
let mapleader=" "

filetype plugin indent on

set encoding=utf-8
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
set autowriteall "auto save buffers
set timeoutlen=1500
" set pastetoggle=<F12>
set history=300
set mouse=a "all mouse support
set hidden
set noautochdir "do not change cwd when open files (change with :cd)
set showcmd "display what command is waiting for an operator
"set lazyredraw "redraw only when we need to. do not use, cause lagging
set nolz "disable lazydraw
set colorcolumn=0 "do not display max_line_length column
set updatetime=750 "some plugins relay on that, finetune for best performance
set signcolumn=yes:2 "show separate column for signs (gitgutter)
set formatoptions-=cro "do not propogate comments on new lines
set confirm "propmt for saving the file when quit instead of showing error
"set exrc "load .vimrc in the current directory

function! OnVimEnter()
    "g:initial_dir = path where vim started
    let g:initial_dir = getcwd()
    exec 'set path='.g:initial_dir.','.g:initial_dir.'/**'
endfunction
autocmd VimEnter * call OnVimEnter()

"select mode with mouse
set selectmode=mouse
"copy selected text (with mouse) to system clipboard
snoremap y <c-g>"+y

"allow gf to open non-existent files
map gf :edit <cfile><cr>

"cancel hightlight on Esc
function! SmartEscape()
    "FIXME does not cancel hightlighting
    exec 'noh'
    "close help || git hunks || quickfix...
    if &filetype == '_help' || &filetype == 'diff'
                \ || &filetype == 'qf'
                \ || &filetype == 'fugitive'
                \ || &filetype == 'gitcommit'
        exec 'close'
    endif
    "close flaating windows
    for win in nvim_list_wins()
        let wconfig = nvim_win_get_config(win)
        if (wconfig.relative == 'win')
            call nvim_win_close(win, 0)
        endif
    endfor
endfunction

nnoremap <silent> <esc> :noh<cr>:call SmartEscape()<cr>
inoremap <silent> <esc> <esc>:noh<cr>

"disable ex mode
nnoremap Q <Nop>
nnoremap q: <Nop>

"yank line from cursor to end with shift-y
nnoremap Y y$
"highlight from cursor to end line with shift-v
nnoremap V v$
"highlight all line with vv
nnoremap vv V
"select pasted text
nnoremap <expr> gv '`[' . strpart(getregtype(), 0, 1) . '`]'

"vi mode moving in insert mode
inoremap <c-h> <left>
inoremap <c-k> <up>
inoremap <c-j> <down>
inoremap <c-l> <right>

" open help on right
augroup helpautogroup
    autocmd!
    autocmd FileType help wincmd L
augroup END
"}}}

"abbreviations {{{
iabbrev bgc brooth@gmail.com
iabbrev KO Khalidov Oleg
"}}}

"cmdline "{{{
set wildmenu "display comlition list
set wildmode=longest:full,full "do not pick first

"movement
cnoremap <c-h> <left>
cnoremap <c-l> <right>
cnoremap <m-b> <s-left>
cnoremap <m-f> <s-right>
"}}}

" tools {{{
" highlight yank
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="Visual", timeout=700}
augroup END

"session/source {{{
set ssop-=options "do not store vimrc options in session
set viminfo='1000,f1 "store marks
set undofile "store undo history

"set a directory to store the undo history
exec 'set undodir='.$VIMHOME.'/undo'
"store swp files in vim dir
exec 'set dir='.$VIMHOME.'/swp'

"buffers/windows {{{
"functions {{{
" background buffer has no window (invisible)
function! ClearBackBuffers()
    let n = bufnr('$')
    while n > 0
        if buflisted(n) && bufwinnr(n) < 0 && !getbufvar(n, '&mod')
            exe 'bd ' . n
        endif
        let n -= 1
    endwhile
endfun

function! DeleteOtherBuffers()
    let n = bufnr('$')
    let cb = bufnr('%')
    while n > 0
        if n != cb && buflisted(n) && getbufvar(n, '&filetype') != 'NVimTree'
            exe 'bd ' . n
        endif
        let n -= 1
    endwhile
    " silent exec 'norm! o'
endfun

function! DeleteUnmodifiedBuffers()
    let n = bufnr('$')
    while n > 0
        if buflisted(n) && !getbufvar(n, '&mod')
                    \ && getbufvar(n, '&filetype') != 'NVimTree'
            exe 'bd ' . n
        endif
        let n -= 1
    endwhile
endfun

function! DeleteRightBuffers()
    let n = bufnr('%') + 1
    let l = bufnr('$')
    while n <= l
        if buflisted(n) && !getbufvar(n, '&mod')
            exe 'bd ' . n
        endif
        let n += 1
    endwhile
endfun

function! JumpToBuffer(pos)
    let buffs = getbufinfo({'bufloaded': 1, 'buflisted': 1})
    if len(buffs) < a:pos
        echom 'no buffer at position '. a:pos
    else
        exec 'b '. buffs[a:pos - 1].bufnr
    endif
endfunction

function! SwapBuffers()
  let thiswin = winnr()
  let thisbuf = bufnr("%")
  let lastwin = winnr('$')
  while lastwin > 0
      if getbufvar(winbufnr(lastwin), '&filetype') != 'NVimTree'
                  \ && lastwin != thiswin
          break
      endif
      let lastwin -= 1
  endwhile
  let lastbuf = winbufnr(lastwin)
  exec  lastwin . " wincmd w" ."|".
      \ "buffer ". thisbuf ."|".
      \ thiswin ." wincmd w" ."|".
      \ "buffer ". lastbuf
endfunction
"}}}

"Buffers
nnoremap <silent><c-w>] :bnext<cr>
nnoremap <silent><c-w>[ :bprevious<cr>
nnoremap <silent><c-w><c-p> :bp\|bd #<cr>
nnoremap <silent><c-w><c-q> :bd %<cr>
nnoremap <silent><c-w><c-c> :call ClearBackBuffers()<cr>
nnoremap <silent><c-w><c-o> :call DeleteOtherBuffers()<cr>
nnoremap <silent><c-w><c-u> :call DeleteUnmodifiedBuffers()<cr>
nnoremap <silent><c-w><c-r> :call DeleteRightBuffers()<cr>
nnoremap <silent><c-w>1 :call JumpToBuffer(1)<cr>
nnoremap <silent><c-w>2 :call JumpToBuffer(2)<cr>
nnoremap <silent><c-w>3 :call JumpToBuffer(3)<cr>
nnoremap <silent><c-w>4 :call JumpToBuffer(4)<cr>
nnoremap <silent><c-w>5 :call JumpToBuffer(5)<cr>
nnoremap <silent><c-w>6 :call JumpToBuffer(6)<cr>
nnoremap <silent><c-w>7 :call JumpToBuffer(7)<cr>
nnoremap <silent><c-w>8 :call JumpToBuffer(8)<cr>
nnoremap <silent><c-w>9 :call JumpToBuffer(9)<cr>

"Panes, split/swap and move the cursor to new/swapped pane
nnoremap <c-w><c-v> <c-w><c-v><c-w>l
nnoremap <c-w><c-s> <c-w><c-s><c-w>j
nnoremap <silent><c-w>r :call SwapBuffers()<cr>

"search/replace/subtitude "{{{
set smartcase
set ignorecase
"set incsearch "search while typing, realy annoying

xnoremap <c-t> y/<c-r>"<cr>N
xnoremap <c-g> y0:g/<c-r>"/norm!
xnoremap <c-s> y:%s/<c-r>"//ge<left><left><left>
xnoremap <c-m> y/<c-r>"<cr>Nqq
xnoremap <s-t> y/\<<c-r>"\><cr>N
xnoremap <s-g> y0:g/\<<c-r>"\>/norm!
xnoremap <s-s> y:%s/\<<c-r>"\>//ge<left><left><left>
xnoremap <s-m> y/\<<c-r>"\><cr>Nqq

"far.vim
let g:far#debug = 1
let g:far#check_window_resize_period = 3000
let g:far#file_mask_favorits = ['%', '**/*.*', '**/*.dart', '**/*.ts', '**/*.js']
"}}}

"indent/tab/spaces "{{{
"set virtualedit=all "move curson over empty space
set nostartofline "keep cursor position while C-u/C-d/gg/etc

set autoindent "indent when moving to the next line while writing code
set smartindent
set smarttab
set tabstop=2
set shiftwidth=2 "when using the >> or << commands, shift lines by 2 spaces
set softtabstop=2
set expandtab "expand tabs into spaces

"display next/prev highlight at the center of the screen
nnoremap n nzzzv
nnoremap N Nzzzv

"indent text in visual mode with tab
vnoremap <s-tab> <gv
vnoremap <tab> >gv
"}}}

"lines/numbers/wrap {{{
set number "show line number
set rnu "releative line numbers
set nowrap "no wrapping by default

set scrolloff=5 "keep 5 lines below and above from the cursor
set sidescroll=1 "horizontal scroll by 1 col
set sidescrolloff=5  "keep 5 lines left and right from the cursor

"go between wrapped lines
map <silent> j gj
map <silent> k gk
map <Down> gj
map <Up> gk
"}}}


"lint/correcting {{{
"trailing
nnoremap <c-c>t :%s/\s\+$//e<cr>:nohl<cr>
"mixed indent
nnoremap <c-c>i :retab<cr>
"goto next, prev. open error
nnoremap <c-c>l :lopen<cr>

"format all file
nnoremap =- mCgg=G`CmC
"}}}

"files/types {{{
set wildignore+=*/bin/*
set wildignore+=*/.git/*
set wildignore+=*/.idea/*
set wildignore+=*/build/*
set wildignore+=*/node_modules/*
set wildignore+=*/.history/*
"}}}

"quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight def link QuickScopePrimary HopNextKey
  autocmd ColorScheme * highlight def link QuickScopeSecondary HopNextKey1
augroup END

nnoremap s <cmd> HopChar1<cr>

"hop {{{
lua << EOF
    require('hop').setup()
EOF
"}}}

" vim: set et fdm=marker sts=4 sw=4:
