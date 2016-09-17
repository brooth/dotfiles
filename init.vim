"----------------------------------------------------------------
"                           info
"----------------------------------------------------------------
" Ctrl+R %    - copy current file name into command line
" * (<s-8>)   - serch/highlight word
" q:          - command history
" gv          - re-select last visual selection
"
" search & replace
" :args **/*.java OR :args `ag -l <search> **/*.java`
" :argdo %s/<search>/<replace>/ge | update
"
" to clean buffer cache remove sub! dirs ~/.local/share/nvim

"----------------------------------------------------------------
"                           base
"----------------------------------------------------------------
if has('nvim')
    let $VIMHOME = "~/.config/nvim"
    "normal mode in terminal by Esc
    tnoremap <Esc> <C-\><C-n>
else
    let $VIMHOME = "~/.vim"
endif

"----------------------------------------------------------------
"                           plugins
"----------------------------------------------------------------
call plug#begin('$VIMHOME/plugged')

"appearance
Plug 'morhetz/gruvbox'
Plug 'bling/vim-airline'
Plug 'luochen1990/rainbow'      "hi brackets diff colors

"utils
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'haya14busa/incsearch.vim' "highlight search while entering
Plug 'kshenoy/vim-signature'    "show marks
Plug 'terryma/vim-expand-region'
Plug 'easymotion/vim-easymotion'

"files
Plug 'mbbill/undotree'

"git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

"dev
Plug 'SirVer/ultisnips'
Plug 'neomake/neomake', {'for': 'python'}

"python
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'zchee/deoplete-jedi', {'for': 'python'}
Plug 'hdima/python-syntax', {'for': 'python'}

"typescript
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
Plug 'Quramy/tsuquyomi', {'for': 'typescript'}

"unite
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/unite-outline'
Plug 'Shougo/vimfiler.vim'
Plug 'tsukkee/unite-tag'

"completion
Plug 'Shougo/deoplete.nvim'

call plug#end()

"----------------------------------------------------------------
"                           misc
"----------------------------------------------------------------
filetype plugin indent on

let mapleader=" "
"leader key timeout
set timeoutlen=3000

set pastetoggle=<F12>
set history=100
"completion in command line
set wildmenu

autocmd VimEnter * let g:initial_dir = getcwd()

"no mouse support
set mouse = ""

"allow switching away from a changed buffer without saving.
set hidden

"F1 - Esc
imap <F1> <Esc>
nmap <F1> <Esc>
vmap <F1> <Esc>

"disable ex mode
map Q <Nop>

"yeah
map Y y$

"stay same position on insert mode exit
inoremap <silent> <Esc> <Esc>`^

"insert mode moving
imap <c-h> <left>
imap <c-k> <up>
imap <c-j> <down>
imap <c-l> <right>

"Display what command is waiting for an operator
set showcmd

"redraw only when we need to.
"set lazyredraw

"search for TODOs
nmap <Leader>t :noautocmd vimgrep /TODO/j **/*.*<CR>:botright cw<CR>

"expand-region
map = <Plug>(expand_region_expand)
map - <Plug>(expand_region_shrink)

"----------------------------------------------------------------
"                           help
"----------------------------------------------------------------
nmap <leader>hs :h usr_41.txt<cr>
nmap <leader>hf :h function-list<cr>

"----------------------------------------------------------------
"                       session/buffers
"----------------------------------------------------------------
"save current buffer with F2
nmap <F2> :w<CR>
imap <F2> <Esc>:w<CR>
vmap <F2> <Esc>:w<CR>

"kill current buffer with F10
nmap <F10> :q<cr>
nmap <F11> :bd %<cr>

"kill current buffer and open previous
function! KillBufferGoPrev()
    let buf_num = bufnr('%')
    exe 'bprevious'
    exe 'bd! '.buf_num
endfunction

nmap <leader>bd :call KillBufferGoPrev()<cr>
"kill other buffers (only buffer)
nmap <leader>bo :%bd<cr>:e #<cr>

"do not store vimrc options in session
set ssop-=options

"store marks
set viminfo='1000,f1

function! SaveSession()
    let l:path = g:initial_dir.'/.vimsession'
    if confirm('save current session? '.l:path, "&yes\n&no", 1)==1
        execute 'mksession! '.l:path
    endif
endfunction

" SPC - s(ession)
nmap <silent><leader>ss :call SaveSession()<cr>
nmap <silent><leader>sr :exec 'source '.g:initial_dir.'/.vimsession'<cr>

"store undo history
set undofile
"set a directory to store the undo history
exec 'set undodir='.$VIMHOME.'/undo'
"store swp files in vim dir
exec 'set dir='.$VIMHOME.'/swp'

"----------------------------------------------------------------
"                   search/replace/subtitude
"----------------------------------------------------------------
set smartcase
set ignorecase
set incsearch

"no hightlight
nmap <F3> :noh<CR>
imap <F3> <esc>:noh<CR>

"go to next/prev of vimgrep result
nmap [q :cprev<cr>
nmap ]q :cnext<cr>

if executable('ag')
    set grepprg=ag\ --nogroup\ --column\ --nocolor
    set grepformat=%f:%l:%C:%m
endif

"----------------------------------------------------------------
"                       windows/tabs
"----------------------------------------------------------------
"set splitright
"set splitbelow

"jump windows by numbers
nmap <leader><tab> <c-w>p
nmap <leader>1 1<c-w><c-w>
nmap <leader>2 2<c-w><c-w>
nmap <leader>3 3<c-w><c-w>
nmap <leader>4 4<c-w><c-w>
nmap <leader>5 5<c-w><c-w>

"kill windows by shift+numbers
nmap <leader>! 1<c-w>c
nmap <leader>@ 2<c-w>c
nmap <leader># 3<c-w>c
nmap <leader>$ 4<c-w>c
nmap <leader>% 5<c-w>c

"jump windows by ctrl+direction
nmap <c-j> <C-w><Down>
nmap <c-h> <C-w><Left>
nmap <c-l> <C-w><Right>
nmap <c-k> <C-w><Up>

"jump tabs by alt+direction
nmap <m-j> :tabprev<CR>
nmap <m-k> :tabnext<CR>

"----------------------------------------------------------------
"                       indent/tab/spaces
"----------------------------------------------------------------
"move curson over empty space
set virtualedit=all

"indent everything
noremap <Space>= miggvG=`i

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

"show tabs and whitespaces FIXME
set list

"show vertical line
"set colorcolumn=80

"indent text in visual mode with tab
vmap <s-tab> <gv
vmap <tab> >gv

"----------------------------------------------------------------
"                       lines/numbers/wrap
"----------------------------------------------------------------
"go between wrapped lines
map j gj
map k gk
map <Down> gj
map <Up> gk

set number
"releative line numbers
set rnu

nmap <leader>ll :set nornu<cr>:set number<CR>
nmap <leader>lr :set number<cr>:set rnu<cr>
nmap <leader>ln :set nonumber<cr>:set nornu<cr>

"show a visual line under the cursor's current line
set cursorline

"no wrapping by default
set nowrap

nmap <leader>lw :set wrap!<cr>

"keep 5 lines below and above cursor
set scrolloff=5

"show bracket pair
"set showmatch

"manual folding
set foldmethod=manual

"fold file header (e.g. license javadoc)
nmap zh mmggzf%`m
"fold current statement
nmap ze zf%

"Return to last edit position when opening files
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

"----------------------------------------------------------------
"                       lint/correcting
"----------------------------------------------------------------
"trailing
nmap <leader>ct :%s/\s\+$//e<cr>
"mixed indent
nmap <leader>cm :retab<cr>

"goto next, prev. open error
nmap <leader>co :lopen<cr>
nmap ]l :lnext<cr>
nmap [l :lprevious<cr>

"----------------------------------------------------------------
"                       files/types
"----------------------------------------------------------------
set wildignore+=*/bin/*
set wildignore+=*/.git/*
set wildignore+=*/.idea/*
set wildignore+=*/build/^[^g]*

autocmd BufRead,BufNewFile *.gradle set ft=groovy

" SPC d(ot files)
nmap <leader>de :e ~/.config/nvim/init.vim<cr>
nmap <leader>dr :source ~/.config/nvim/init.vim<cr>

"----------------------------------------------------------------
"                           git
"----------------------------------------------------------------
"no mappings by gitgutter
let g:gitgutter_map_keys = 0

nmap <leader>gg :Gblame<cr>
nmap <leader>gb :Gbrowse<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>gd :Gvdiff<cr>
nmap <leader>gP :Gpush<cr>
nmap <leader>gL :Gpull<cr>

nmap <leader>gp :GitGutterPreviewHunk<cr>10<c-w>j
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk
nmap <leader>gr :GitGutterRevertHunk<cr>
nmap <leader>gS :GitGutterStageHunk<cr>
nmap <leader>gl :GitGutterLineHighlightsToggle<cr>

let g:gitgutter_sign_added = '↪'
let g:gitgutter_sign_removed = '↩'
let g:gitgutter_sign_modified = '↬'
let g:gitgutter_sign_modified_removed = '↫'

function! s:ConfigGitGutter()
    highlight GitGutterAdd ctermfg=244 ctermbg=237
    highlight GitGutterChange ctermfg=244 ctermbg=237
    highlight GitGutterDelete ctermfg=244 ctermbg=237
    highlight GitGutterChangeDelete ctermfg=244 ctermbg=237
endfunction
autocmd VimEnter * call s:ConfigGitGutter()

"----------------------------------------------------------------
"                       completion/deoplete
"----------------------------------------------------------------
"ctrl+space - omni complition
imap <NUL> <C-Space>
imap <C-@> <C-Space>
imap <C-Space> <c-x><c-o>

"set complete=.,w,b,u,k FIXME ???

"disable preview popup buffer
set completeopt-=preview

"up/down with tab
inoremap <expr> <Tab>  pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <s-Tab>  pumvisible() ? "\<C-p>" : "\<s-Tab>"

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_completion_start_length = 1
let g:deoplete#auto_complete_start_length=1
let g:deoplete#max_list=50

"----------------------------------------------------------------
"                             Unite
"----------------------------------------------------------------
let g:unite_winheight = 13
let g:unite_source_history_yank_enable = 1
let g:unite_source_rec_max_cache_files = 1000
let g:unite_prompt = '➥ '

if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nocolor --nogroup --smart-case'
    let g:unite_source_grep_recursive_opt = ''

    let g:unite_source_rec_async_command = ['ag --follow --nocolor --nogroup --hidden -g ""']
    let g:ackprg = 'ag --nogroup --column'
endif

call unite#filters#matcher_default#use(['converter_tail', 'matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])

"TODO: from wildignore
call unite#custom#source('file_rec/async', 'ignore_pattern', join([
            \ '\..*/',
            \ 'node_modules/',
            \ 'build/[^gen]',
            \ ], '\|'))

let s:filters = {"name" : "custom_buffer_converter"}

function! s:filters.filter(candidates, context)
    for candidate in a:candidates
        "echo candidate
        let word = get(candidate, 'word')
        let path = get(candidate, 'action__path', '')
        let candidate.abbr = printf("%s   %s", word, path)
        " let candidate.abbr = word
    endfor
    return a:candidates
endfunction

call unite#define_filter(s:filters)
unlet s:filters
call unite#custom#source('buffer,file_rec/async', 'converters', 'custom_buffer_converter')

let s:filters = {"name" : "custom_grep_converter"}

function! s:filters.filter(candidates, context)
    for candidate in a:candidates
        let filename = fnamemodify(get(candidate, 'action__path', candidate.word), ':t')
        let trimmed = substitute(get(candidate, 'source__info')[2], '^\s\+\|\s\+$', '', 'g')
        let candidate.abbr = printf("%s   %s", filename, trimmed)
    endfor
    return a:candidates
endfunction

call unite#define_filter(s:filters)
unlet s:filters
call unite#custom#source('grep', 'converters', 'custom_grep_converter')

function! <SID>UniteSetup()
    nmap <buffer> <Esc> <plug>(unite_exit)
    imap <buffer> <Esc> <plug>(unite_exit)

    nnoremap <silent><buffer><expr> <C-s>     unite#do_action('split')
    nnoremap <silent><buffer><expr> <C-v>     unite#do_action('vsplit')
endfunction
autocmd FileType unite call <SID>UniteSetup()

nmap <leader>u :Unite -buffer-name=files
            \ -buffer-name=files
            \ -start-insert
            \ -no-split
            \ buffer file_rec/async file/new directory/new<CR>
nmap <leader>U :UniteWithCursorWord -buffer-name=files
            \ -buffer-name=files
            \ -start-insert
            \ -no-split
            \ buffer file_rec/async file/new directory/new<CR>
nmap <leader>g :Unite -buffer-name=grep
            \ -no-quit
            \ grep:.<cr>
nmap <leader>G :UniteWithCursorWord -buffer-name=grep
            \ -no-quit
            \ grep:.<cr>
nmap <leader>o :Unite -buffer-name=tags
            \ -start-insert
            \ -no-split
            \ tag<cr>
nmap <leader>O :Unite -buffer-name=outline
            \ -start-insert
            \ -no-split
            \ outline<cr>
nmap <leader><leader> :Unite -buffer-name=buffers
            \ -start-insert
            \ -no-split
            \ buffer<cr>

"----------------------------------------------------------------
"                 vimfiler
"----------------------------------------------------------------
"<C-l> <Plug>(vimfiler_redraw_screen)
"*	   <Plug>(vimfiler_toggle_mark_all_lines)
"U	   <Plug>(vimfiler_clear_mark_all_lines)
"cc	   <Plug>(vimfiler_copy_file)
"mm	   <Plug>(vimfiler_move_file)
"dd	   <Plug>(vimfiler_delete_file)
"Cc	   <Plug>(vimfiler_clipboard_copy_file)
"Cm	   <Plug>(vimfiler_clipboard_move_file)
"Cp	   <Plug>(vimfiler_clipboard_paste)
"r	   <Plug>(vimfiler_rename_file)
"K	   <Plug>(vimfiler_make_directory)
"N	   <Plug>(vimfiler_new_file)
"x	   <Plug>(vimfiler_execute_system_associated)
"X	   <Plug>(vimfiler_execute_vimfiler_associated)
"~	   <Plug>(vimfiler_switch_to_home_directory)
"\	   <Plug>(vimfiler_switch_to_root_directory)
"&	   <Plug>(vimfiler_switch_to_project_directory)
".	   <Plug>(vimfiler_toggle_visible_ignore_files)
"g?	   <Plug>(vimfiler_help)
"v	   <Plug>(vimfiler_preview_file)
"yy	   <Plug>(vimfiler_yank_full_path)
"M	   <Plug>(vimfiler_set_current_mask)
"S	   <Plug>(vimfiler_select_sort_type)
"gs	   <Plug>(vimfiler_toggle_safe_mode)
"a	   <Plug>(vimfiler_choose_action)
"Y	   <Plug>(vimfiler_pushd)
"P	   <Plug>(vimfiler_popd)
"T	   <Plug>(vimfiler_expand_tree_recursive)
"I	   <Plug>(vimfiler_cd_input_directory)

let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_default_columns = ''
let g:vimfiler_explorer_columns = ''
let g:vimfiler_tree_leaf_icon = ''
let g:vimfiler_tree_indentation = 3
let g:vimfiler_file_icon = ''
let g:vimfiler_marked_file_icon = '*'
let g:vimfiler_readonly_file_icon = '~'

augroup vimfiler
    autocmd!
    autocmd FileType vimfiler call s:vimfiler_settings()
augroup END

function! s:vimfiler_settings()
    map <silent><buffer> <Space> <NOP>
    map <silent><buffer> <c-j> <NOP>
    nmap <silent><buffer> i <Plug>(vimfiler_toggle_mark_current_line)
    nmap <silent><buffer> gh <Plug>(vimfiler_switch_to_history_directory)
    nmap <buffer> <Esc><Esc> <Plug>(vimfiler_exit)
endfunction

nmap <leader>f :VimFilerCurrentDir -status<cr>
nmap <leader>F :VimFilerBufferDir -status <cr>

"----------------------------------------------------------------
"                           markdown
"----------------------------------------------------------------
autocmd BufRead *.md set wrap lbr
autocmd BufEnter *.md set syntax=markdown

"----------------------------------------------------------------
"                          ultisnips
"----------------------------------------------------------------
let g:UltiSnipsExpandTrigger="<Nop>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsListSnippets="<F6>"

"respect neosnippet???
" let g:ulti_expand_or_jump_res = 0
" function! <SID>ExpandSnippetOrReturn()
"     let snippet = UltiSnips#ExpandSnippetOrJump()
"     if g:ulti_expand_or_jump_res > 0
"         return snippet
"     else
"         return "\<C-Y>"
"     endif
" endfunction
" imap <expr> <CR> pumvisible() ? "<C-R>=<SID>ExpandSnippetOrReturn()<CR>" : "\<CR>"

"----------------------------------------------------------------
"                           theme
"----------------------------------------------------------------
set background=dark
colorscheme gruvbox

"dim inactive  windows
hi def Dim cterm=none ctermbg=none ctermfg=242

function! s:DimInactiveWindow()
    syntax region Dim start='' end='$$$end$$$'
endfunction

function! s:UndimActiveWindow()
    ownsyntax
endfunction

autocmd BufEnter * call s:UndimActiveWindow()
autocmd WinEnter * call s:UndimActiveWindow()
autocmd WinLeave * call s:DimInactiveWindow()

"hl line in insert mode
function! s:SetNormalCursorLine()
    hi cursorline cterm=none ctermbg=237 ctermfg=none
endfunction

function! s:SetInsertCursorLine()
    hi cursorline cterm=none ctermbg=52 ctermfg=none
endfunction

autocmd InsertEnter * call s:SetInsertCursorLine()
autocmd InsertLeave * call s:SetNormalCursorLine()

"hl line in active window only
autocmd WinEnter * set cul
autocmd WinLeave * set nocul

"hl TODO in blue
highlight Todo ctermfg=blue

"rainbow brackets
let g:rainbow_active = 1
let g:rainbow_conf = {
    \ 'ctermfgs': ['166', '3', 'magenta', 'lightblue', '9', '118']
    \ }

"easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_keys = 'asdfghjljknmvcrtuiyopwqb'
let g:EasyMotion_smartcase = 0

nmap s <Plug>(easymotion-overwin-f2)

"----------------------------------------------------------------
"                           airline
"----------------------------------------------------------------
set laststatus=2
let g:airline_theme='oceanicnext'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#fnamemod = ':t'
"window number instead of mode
let g:airline_section_a="%{winnr().':'.bufnr('%')}"

function! s:ConfigAirlineSymbols()
    let g:airline_symbols.maxlinenr = ''
    let g:airline_symbols.linenr = ''
endfunction
autocmd VimEnter * call s:ConfigAirlineSymbols()

"----------------------------------------------------------------
"                           undo tree
"----------------------------------------------------------------
nmap <F4> :UndotreeToggle<cr> :UndotreeFocus<cr>
imap <F4> <esc><f4>

"----------------------------------------------------------------
"                           neomake
"----------------------------------------------------------------
highlight neomakeErrorSign ctermfg=196 ctermbg=237
highlight neomakeWarnSign ctermfg=166 ctermbg=237

let g:neomake_error_sign = {'text': '⚑', 'texthl': 'neomakeErrorSign'}
let g:neomake_warning_sign = {'text': '⚑', 'texthl': 'neomakeWarnSign'}

"----------------------------------------------------------------
"                             python
"----------------------------------------------------------------
let g:jedi#goto_command = "<leader>pg"
let g:jedi#goto_assignments_command = "<leader>pa"
let g:jedi#goto_definitions_command = "<leader>pd"
let g:jedi#documentation_command = "<leader>pk"
let g:jedi#usages_command = "<leader>U"
let g:jedi#rename_command = "<leader>pr"
let g:jedi#completions_command = "<C-W>"

let g:jedi#auto_initialization = 1
let g:jedi#show_call_signatures = 1
let g:jedi#popup_select_first = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#completions_enabled = 0
let g:jedi#popup_on_dot = 0

let g:python_inited = 0
function! InitPythonSessing()
    " buffer settings
    setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
    setlocal nocindent

    " global settings
    if g:python_inited != 0
        return
    endif
    let g:python_inited = 1

    set wildignore+=*.pyc
    set wildignore+=*/node_modules/*
    set wildignore+=*/.env/^[^g]*

    let g:neomake_python_enabled_makers = ['pylint', 'flake8']
    let g:neomake_python_flake8_maker = { 'args': ['--ignore=E126,E128', '--max-line-length=100'], }
    autocmd! BufRead *.py Neomake

    "enable all Python syntax highlighting features
    let python_highlight_all = 1

    "custom hl
    highlight pythonSelf ctermfg=109
    highlight pylintSuppress ctermfg=8

    function! s:HighlightPython()
        Python3Syntax
        syn keyword pythonSelf self
        syn match pythonSelf "[\w_]="
        syn region pylintSuppress start='# pylint' end='$'
    endfunction

    autocmd! BufEnter *.py call s:HighlightPython()
    autocmd! WinEnter *.py call s:HighlightPython()

    if has('python3')
        let g:jedi#force_py_version = 3
    endif

    " ctags
    let l:mktags = "rm -f ".$VIMHOME."/tags".getcwd()."/tags && mkdir -p ".$VIMHOME."/tags".getcwd()"
    call system(l:mktags)
    exec 'set tags='.$VIMHOME.'/tags/'.getcwd().'/tags'

    function! UpdatePythonCtags()
        let l:cmd = "ctags -f ".$VIMHOME."/tags".getcwd()."/tags -R --exclude=.env".
                    \ " --exclude=.git --languages=python ".getcwd()
        call system(l:cmd)
    endfunction
    nnoremap <leader>T :call UpdatePythonCtags()<Cr>
    call UpdatePythonCtags()

    function! PyBufWritePost()
        Neomake
        call UpdatePythonCtags()
    endfunction
    autocmd! BufWritePost *.py :call PyBufWritePost()

endfunction
autocmd BufReadPost *.py call InitPythonSessing()
