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

"focus window of last created buffer
function! JumpLastBufferWindow()
    call win_gotoid(win_getid(bufwinnr(last_buffer_nr())))
endfunction

"g:initial_dir = path where vim started
function! InitVimEnterSettings()
    let g:initial_dir = getcwd()
    exec 'set path='.g:initial_dir.','.g:initial_dir.'/**'
endfunction
autocmd VimEnter * call InitVimEnterSettings()
"}}}

"plugins {{{
let g:plugins = exists('g:plugins') ? g:plugins : {}

" appearance
call extend(g:plugins, {
            \   'morhetz/gruvbox': {},
            \   'bling/vim-airline': {},
            \   'mhartington/oceanic-next': {},
            \   'luochen1990/rainbow': {},
            \   'Yggdroot/indentLine': {},
            \   })
" tools
call extend(g:plugins, {
            \   'tpope/vim-repeat': {},
            \   'tpope/vim-surround': {},
            \   'tpope/vim-commentary': {},
            \   'kshenoy/vim-signature': {},
            \   'terryma/vim-expand-region': {},
            \   'easymotion/vim-easymotion': {},
            \   'vim-scripts/ReplaceWithRegister': {},
            \   'terryma/vim-multiple-cursors': {},
            \   })
" my boys
call extend(g:plugins, {
            \   '~/Projects/far.vim': {},
            \   '~/Projects/meta-x.vim': {},
            \   })
" files
call extend(g:plugins, {
            \   'mbbill/undotree': {},
            \   'junegunn/fzf': {'dir': '~/.fzf', 'do': './install --all'},
            \   'junegunn/fzf.vim': {},
            \   })
" git
call extend(g:plugins, {
            \   'tpope/vim-fugitive': {},
            \   'airblade/vim-gitgutter': {},
            \   })
" dev
call extend(g:plugins, {
            \   'Shougo/deoplete.nvim': {},
            \   'metakirby5/codi.vim': {},
            \   'davinche/godown-vim': {},
            \   })

call plug#begin('$VIMHOME/plugged')
    for plug in keys(g:plugins)
        call plug#(plug, g:plugins[plug])
    endfor
call plug#end()
"}}}

"misc {{{
set encoding=utf-8
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

filetype plugin indent on

let mapleader=" "
set timeoutlen=1500
set pastetoggle=<F12>
set history=300
"no mouse support
set mouse = ""
"allow switching away from a changed buffer without saving.
set hidden
"Display what command is waiting for an operator
set showcmd
"redraw only when we need to.
"set lazyredraw
"en spell checker
"set spell spelllang=en

"disable ex mode
nnoremap Q <Nop>
nnoremap q: <Nop>

"yeah
nnoremap Y y$

"select pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

"stay same position on insert mode exit
inoremap <silent> <Esc> <Esc>`^

"insert mode moving
inoremap <c-h> <left>
inoremap <c-k> <up>
inoremap <c-j> <down>
inoremap <c-l> <right>

"expand-region
nnoremap ]e <Plug>(expand_region_expand)
nnoremap [e <Plug>(expand_region_shrink)

"no jump to exsiting pair, but insert
let g:AutoPairsMultilineClose=0
"}}}

"abbreviations {{{
iabbrev bgc brooth@gmail.com
iabbrev KO Khalidov Oleg
" }}}

"help {{{
nnoremap <F1>u :h usr_41.txt<cr>
nnoremap <F1>f :h function-list<cr>
"}}}

"cmdline "{{{
"view complete items in command line
set wildmenu

" templates
" exec 'nnoremap ;f :find '
" exec 'nnoremap ;b :b '
" exec 'nnoremap ;d :bd '
" exec 'nnoremap ;q :qa'
" exec 'nnoremap ;s :%s//gc<left><left><left>'

" movement
cnoremap <c-h> <left>
cnoremap <c-l> <right>

"insane.vim
call mx#tools#setdefault('g:mx#favorits', [
            \   {'word': 'find'},
            \   {'word': 'so %'},
            \   {'word': 'qall', 'short': 'qa'},
            \   {'word': 'edit!'},
            \   {'word': '%s//gc', 'caption': 'sub', 'cursor': 3},
            \   ])
"}}}

"session/source {{{
"do not store vimrc options in session
set ssop-=options
"store marks
set viminfo='1000,f1
"store undo history
set undofile
"set a directory to store the undo history
exec 'set undodir='.$VIMHOME.'/undo'
"store swp files in vim dir
exec 'set dir='.$VIMHOME.'/swp'

function! SaveSession()
    let l:path = g:initial_dir.'/.vimsession'
    if confirm('save current session? '.l:path, "&yes\n&no", 1)==1
        execute 'mksession! '.l:path
    endif
endfunction

" Ctrl-S - Session/Source
nnoremap <silent><c-s>s :call SaveSession()<cr>
nnoremap <silent><c-s>l :exec 'source '.g:initial_dir.'/.vimsession'<cr>

nnoremap <silent><c-s>e :e ~/.config/nvim/init.vim<cr>
nnoremap <silent><c-s>r :source ~/.config/nvim/init.vim<cr>
nnoremap <c-s>t :source %<cr>
"}}}

"buffers/windows/tabs {{{
"kill current buffer and goto previous
function! WipeBufferGoPrev()
    let buf_num = bufnr('%')
    exe 'bprevious'
    exe 'bd! '.buf_num
endfunction

"kill background buffers
function! DeleteBackBuffers()
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
        if n != cb && buflisted(n) && !getbufvar(n, '&mod')
            exe 'bd ' . n
        endif
        let n -= 1
    endwhile
    silent exec 'norm! o'
endfun

function! DeleteUnmodifiedBuffers()
    let n = bufnr('$')
    while n > 0
        if buflisted(n) && !getbufvar(n, '&mod')
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

function! DeleteLeftBuffers()
    let n = bufnr('%') - 1
    while n > 0
        if buflisted(n) && !getbufvar(n, '&mod')
            exe 'bd ' . n
        endif
        let n -= 1
    endwhile
endfun

"Ctrl-B - Buffers
nnoremap <silent><c-b>n :bnext<cr>
nnoremap <silent><c-b>p :bprevious<cr>
nnoremap <silent><c-b>d :bd %<cr>
nnoremap <silent><c-b>w :call WipeBufferGoPrev()<cr>
nnoremap <silent><c-b>b :call DeleteBackBuffers()<cr>
nnoremap <silent><c-b>o :call DeleteOtherBuffers()<cr>
nnoremap <silent><c-b>u :call DeleteUnmodifiedBuffers()<cr>
nnoremap <silent><c-b>r :call DeleteRightBuffers()<cr>
nnoremap <silent><c-b>l :call DeleteLeftBuffers()<cr>
nnoremap <silent><c-b>e :e!<cr>

"cmd & focus
nnoremap <c-w><c-v> <c-w><c-v><c-w>l
nnoremap <c-w><c-s> <c-w><c-s><c-w>j
nnoremap <c-w><c-r> <c-w><c-r><c-w><c-w>

"save current buffer with F2
nnoremap <F2> :w<cr>
inoremap <F2> <Esc>:w<cr>
vnoremap <F2> <Esc>:w<cr>
"close current window
nnoremap <F10> :q<cr>
"}}}

"search/replace/subtitude "{{{
set smartcase
set ignorecase
set incsearch

"no hightlight
nnoremap <esc> :noh<cr><esc>
inoremap <esc> <esc>:noh<cr><esc>

if executable('ag')
    set grepprg=ag\ --nogroup\ --column\ --nocolor
    set grepformat=%f:%l:%c:%m
endif

"far.vim
let g:far#debug = 0
let g:far#check_window_resize_period = 3000
let g:far#file_mask_favorits = ['%', '**/*.*', '**/*.vim', '**/*.txt']
"}}}

"indent/tab/spaces "{{{
"move curson over empty space
set virtualedit=all
"keep cursor position while C-u/C-d/gg/etc
set nostartofline

"indent when moving to the next line while writing code
set autoindent
set smartindent
set smarttab
set tabstop=4
"when using the >> or << commands, shift lines by 4 spaces
set shiftwidth=4
set softtabstop=4
"expand tabs into spaces
set expandtab

"show vertical line
set colorcolumn=100

"indent text in visual mode with tab
vnoremap <s-tab> <gv
vnoremap <tab> >gv

" copy lines up/down
nnoremap <c-k> yyP
nnoremap <c-j> yyp
vnoremap <c-k> yP
vnoremap <c-j> mCy`Cp`CmC

let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#343D46'
"}}}

"lines/numbers/wrap {{{
set number
"releative line numbers
set rnu
"no wrapping by default
set nowrap

"keep 5 lines below and above cursor
set scrolloff=5
"horizontal scroll by 1 col
set sidescroll=1
"faster scrolling
set lazyredraw

"return to last edit position
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

"go between wrapped lines
map j gj
map k gk
map <Down> gj
map <Up> gk

"Ctrl-L - Lines
nnoremap <c-l>r :set number<cr>:set rnu<cr>
nnoremap <c-l>n :set nornu<cr>:set number<cr>
nnoremap <c-l>h :set nonumber<cr>:set nornu<cr>
nnoremap <c-l>w :set wrap!<cr>

"folds
set foldmethod=syntax
set foldlevelstart=20
set foldnestmax=2

"fold file header (e.g. license javadoc)
nnoremap zh mmggzf%`m
"fold current statement
nnoremap ze zf%

augroup remember_folds
  autocmd!
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent! loadview
augroup END

"multiple cursor
let g:multi_cursor_start_key='<c-m>'
let g:multi_cursor_start_word_key='<c-M>'
let g:multi_cursor_next_key='<C-m>'
"}}}

"lint/correcting {{{
"trailing
nnoremap <c-c>t :%s/\s\+$//e<cr>:nohl<cr>
"mixed indent
nnoremap <c-c>i :retab<cr>
"goto next, prev. open error
nnoremap <c-c>q :lopen<cr>
nnoremap <c-c>n :lnext<cr>
nnoremap <c-c>p :lprevious<cr>

"format all file
nnoremap <c-c>= mCgg=G`CmC

"comment line
map  gcl

"}}}

"files/types {{{
set wildignore+=*/bin/*
set wildignore+=*/.git/*
set wildignore+=*/.idea/*
set wildignore+=*/build/*

autocmd BufRead,BufNewFile *.gradle set ft=groovy

"Netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 1

nnoremap <silent> <c-n>e :Explore<cr>
"}}}

"git "{{{
"no mappings by gitgutter
let g:gitgutter_map_keys = 0

if(&termguicolors)
    hi GitGutterAdd guibg=#1E303B
    hi GitGutterChange guibg=#1E303B
    hi GitGutterDelete guibg=#1E303B
    hi GitGutterChangeDelete guibg=#1E303B
endif

nnoremap <c-g>b :Gblame<cr>
nnoremap <c-g>B :Gbrowse<cr>
nnoremap <c-g>s :Gstatus<cr>
nnoremap <c-g>c :Gcommit<cr>
nnoremap <c-g>d :Gvdiff<cr>
nnoremap <c-g>P :Gpush<cr>
nnoremap <c-g>L :Gpull<cr>
nnoremap <c-g>R :!git checkout <c-r>%<cr><cr>
nnoremap <c-g>p :GitGutterPreviewHunk<cr>:call JumpLastBufferWindow()<cr>
nnoremap <c-g>r :GitGutterUndoHunk<cr>
nnoremap <c-g>S :GitGutterStageHunk<cr>
nnoremap <c-g>l :GitGutterLineHighlightsToggle<cr>
nnoremap [h :GitGutterPrevHunk<cr>
nnoremap ]h :GitGutterNextHunk<cr>

let g:gitgutter_sign_added = '↪'
let g:gitgutter_sign_removed = '↩'
let g:gitgutter_sign_modified = '↬'
let g:gitgutter_sign_modified_removed = '↫'

" function! s:ConfigGitGutter()
"     highlight GitGutterAdd ctermfg=244 ctermbg=237
"     highlight GitGutterChange ctermfg=244 ctermbg=237
"     highlight GitGutterDelete ctermfg=244 ctermbg=237
"     highlight GitGutterChangeDelete ctermfg=244 ctermbg=237
" endfunction
" autocmd VimEnter * call s:ConfigGitGutter()
"}}}

"completion/deoplete {{{
"ctrl+space - omni complition
inoremap <NUL> <C-Space>
inoremap <C-@> <C-Space>
inoremap <C-Space> <c-x><c-o>

"disable preview popup buffer
set completeopt-=preview

"up/down with tab
inoremap <expr> <Tab>  pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <s-Tab>  pumvisible() ? "\<C-p>" : "\<s-Tab>"

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_camal_case = 1
let g:deoplete#auto_completion_start_length = 1
let g:deoplete#auto_complete_start_length = 1
let g:deoplete#auto_complete_delay = 50
let g:deoplete#max_list = 30
let g:deoplete#max_menu_width = 30
let g:deoplete#sources = {}
"}}}

"ultisnips {{{
" let g:UltiSnipsExpandTrigger="<Nop>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" let g:UltiSnipsListSnippets="<F6>"

" let g:ulti_expand_or_jump_res = 0

" "work nicely with deoplete. expand on cr
" function! <SID>ExpandSnippetOrReturn()
"     let snippet = UltiSnips#ExpandSnippetOrJump()
"     if g:ulti_expand_or_jump_res > 0
"         return snippet
"     else
"         return "\<C-Y>"
"     endif
" endfunction
" inoremap <expr> <cr> pumvisible() ? "<C-R>=<SID>ExpandSnippetOrReturn()<cr>" : "\<cr>"
"}}}

"theme {{{
" set background=dark
colorscheme OceanicNext

if (has("termguicolors"))
    set termguicolors

    hi LineNr guifg=#65737E guibg=#1E303B
    hi CursorLineNr guifg=#EC5f67 guibg=#1E303B gui=none
    hi SignatureMarkText guifg=#FAC863 guibg=#1E303B
endif

" highlight line in insert mode
hi cursorline cterm=none ctermbg=238 ctermfg=none
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul
set nocul

"hl TODO, FIXME in blue bold
highlight Todo ctermfg=blue guibg=none guifg=#6699CC gui=bold cterm=bold

"rainbow brackets
let g:rainbow_active = 1
let g:rainbow_conf = {
            \ 'guifgs': ['#AB7967', '#C594C5', '#6699CC', '#5FB3B3', '#99C794'],
            \ 'ctermfgs': ['166', '3', 'magenta', 'lightblue', '9', '118'],
            \ 'separately': {
            \       'html': {}
            \   }
            \ }

"easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_keys = 'asdfghjljknmvcrtuiyopwqb'
let g:EasyMotion_smartcase = 0

nmap s <Plug>(easymotion-overwin-f)

function! SyntaxUnderCursor()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
"}}}

"airline {{{
set laststatus=2
let g:airline_theme='oceanicnext'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s '

"window number instead of mode
let g:airline_section_a="%{winnr().':'.bufnr('%')}"

function! s:ConfigAirlineSymbols()
    let g:airline_symbols.maxlinenr = ''
    let g:airline_symbols.linenr = ''
endfunction
autocmd VimEnter * call s:ConfigAirlineSymbols()
"}}}

"undo tree {{{
nnoremap <F4> :UndotreeToggle<cr> :UndotreeFocus<cr>
inoremap <F4> <esc><f4>
"}}}

" fzf {{{
let g:fzf_layout = { 'up': '~20%' }

map <c-p> :Files<cr>
nmap \ :Buffers<cr>
nmap <c-n>L :Lines<cr>
nmap <c-n>l :BLines<cr>
nmap <c-n>m :Marks<cr>
nmap <c-n>T :Tags<cr>
nmap <c-n>t :BTags<cr>

" }}}

"neomake "{{{
let g:neomake_error_sign = {'text': '⚑'}
let g:neomake_warning_sign = {'text': '⚑'}

if (&termguicolors)
    hi NeomakeErrorSign guibg=#1E303B
    hi NeomakeWarningSign guibg=#1E303B
endif

"}}}

"markdown "{{{
autocmd BufRead *.md set wrap lbr
autocmd BufEnter *.md set syntax=markdown
"}}}

" vim: set et fdm=marker sts=4 sw=4:
