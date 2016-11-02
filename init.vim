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
    tnoremap <Esc> <C-\><C-n>
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
call plug#begin('$VIMHOME/plugged')

"appearance
Plug 'morhetz/gruvbox'
Plug 'bling/vim-airline'
Plug 'luochen1990/rainbow'      "hi brackets diff colors

"utils
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
" Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'kshenoy/vim-signature'    "show marks
Plug 'terryma/vim-expand-region'
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/ReplaceWithRegister' "replace <motion> with register
Plug '~/Projects/far.vim'

"files
Plug 'mbbill/undotree'

"git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

"dev
" Plug 'SirVer/ultisnips'
Plug 'neomake/neomake', {'for': 'python'}

"python
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
" Plug 'zchee/deoplete-jedi', {'for': 'python'}
Plug 'hdima/python-syntax', {'for': 'python'}

"unite
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/unite-outline'
Plug 'Shougo/vimfiler.vim'
Plug 'tsukkee/unite-tag'

"completion
Plug 'Shougo/deoplete.nvim'

call plug#end()
"}}}

"misc {{{
filetype plugin indent on

let mapleader=" "

"leader key timeout
set timeoutlen=5000
set pastetoggle=<F12>
set history=300
"view complete items in command line
set wildmenu
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

"help {{{
nnoremap <F1>u :h usr_41.txt<cr>
nnoremap <F1>f :h function-list<cr>
"}}}

"cmd templates "{{{
exec 'nnoremap ;f :find '
exec 'nnoremap ;b :b '
exec 'nnoremap ;d :bd '
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
nnoremap <silent><c-s>r :exec 'source '.g:initial_dir.'/.vimsession'<cr>

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
function! CloseBackBuffers()
  let n = bufnr('$')
  while n > 0
    if bufloaded(n) && bufwinnr(n) < 0
      exe 'bd! ' . n
    endif
    let n -= 1
  endwhile
endfun

function! CloseOtherBuffers()
  let n = bufnr('$')
  let cb = bufnr('%')
  while n > 0
    if n != cb && bufloaded(n)
      exe 'bd! ' . n
    endif
    let n -= 1
  endwhile
  silent exec 'norm! o'
endfun

"Ctrl-B - Buffers
nnoremap <silent><c-b>n :bnext<cr>
nnoremap <silent><c-b>p :bprevious<cr>
nnoremap <silent><c-b>d :bd %<cr>
nnoremap <silent><c-b>w :call WipeBufferGoPrev()<cr>
nnoremap <silent><c-b>b :call CloseBackBuffers()<cr>
nnoremap <silent><c-b>o :call CloseOtherBuffers()<cr>

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
nnoremap <F3> :noh<cr>
inoremap <F3> <esc>:noh<cr>

if executable('ag')
    set grepprg=ag\ --nogroup\ --column\ --nocolor
    set grepformat=%f:%l:%c:%m
endif

"far.vim
let g:far#debug = 1
let g:far#auto_write_replaced_buffers = 0
let g:far#confirm_fardo = 0
let g:far#check_window_resize_period = 3000
let g:far#file_mask_favorits = ['%', '**/*.*', '**/*.py', '**/*.html',
    \   '**/*.vim', '**/*.txt', '**/*.java', '**/*.gradle']
"}}}

"indent/tab/spaces "{{{
"move curson over empty space
set virtualedit=all
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
"set colorcolumn=80

"indent text in visual mode with tab
vnoremap <s-tab> <gv
vnoremap <tab> >gv
"}}}

"lines/numbers/wrap {{{
set number
"releative line numbers
set rnu
"show a visual line under the cursor's current line
set cursorline
"no wrapping by default
set nowrap
"keep 5 lines below and above cursor
set scrolloff=5
"horizontal scroll by 1 col
set sidescroll=1
"manual folding
set foldmethod=manual

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

"fold file header (e.g. license javadoc)
nnoremap zh mmggzf%`m
"fold current statement
nnoremap ze zf%
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
"}}}

"files/types {{{
set wildignore+=*/bin/*
set wildignore+=*/.git/*
set wildignore+=*/.idea/*
set wildignore+=*/build/^[^g]*

autocmd BufRead,BufNewFile *.gradle set ft=groovy
"}}}

"git "{{{
"no mappings by gitgutter
let g:gitgutter_map_keys = 0

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

" FIXME ???
set complete=.,w,b,u,k

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
let g:deoplete#max_list = 50
let g:deoplete#auto_complete_delay = 50

let g:deoplete#sources = {}
let g:deoplete#sources._ = ['above', 'buffer', 'omni']
"}}}

"unite {{{
let g:unite_winheight = 13
let g:unite_source_history_yank_enable = 1
let g:unite_source_rec_max_cache_files = 1000
let g:unite_prompt = '➥ '

if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nocolor --nogroup --smart-case'
    let g:unite_source_grep_recursive_opt = ''

    let g:unite_source_rec_async_command = ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']
    let g:ackprg = 'ag --nogroup --column'
endif

call unite#filters#matcher_default#use(['converter_tail', 'matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
" call unite#filters#matcher_default#use(['matcher_fuzzy', 'converter_tail'])
" call unite#filters#sorter_default#use(['sorter_selecta'])

"TODO: from wildignore
" call unite#custom#source('file_rec/neovim', 'ignore_pattern', join([
"             \ '\..*/',
"             \ 'node_modules/',
"             \ 'build/[^gen]',
"             \ ], '\|'))

let s:filters = {"name" : "custom_buffer_converter"}

function! s:filters.filter(candidates, context)
    for candidate in a:candidates
        "echo candidate
        let word = get(candidate, 'word')
        let path = get(candidate, 'action__path', '')
        let word = word.repeat(' ', (30 - len(word)))
        if len(path) > 50
            let path = path[0:10].'..'.path[len(path)-38:]
        endif
        let candidate.abbr = printf("%s%s", word, path)
    endfor
    return a:candidates
endfunction

call unite#define_filter(s:filters)
unlet s:filters
call unite#custom#source('buffer,file_rec/neovim', 'converters', 'custom_buffer_converter')

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
    nnoremap <buffer> <Esc> <plug>(unite_exit)
    inoremap <buffer> <Esc> <plug>(unite_exit)

    nnoremap <silent><buffer><expr> <C-s>     unite#do_action('split')
    nnoremap <silent><buffer><expr> <C-v>     unite#do_action('vsplit')
endfunction
autocmd FileType unite call <SID>UniteSetup()

nnoremap <leader>u :Unite -buffer-name=files
            \ -buffer-name=files
            \ -start-insert
            \ -no-split
            \ buffer file_rec/neovim<cr>
nnoremap <leader>U :UniteWithBufferDir -buffer-name=files
            \ -buffer-name=files
            \ -start-insert
            \ -no-split
            \ buffer file_rec/neovim file/new directory/new<cr>
nnoremap <leader>g :Unite -buffer-name=grep
            \ -no-quit
            \ grep:<cr>
nnoremap <leader>G :UniteWithCursorWord -buffer-name=grep
            \ -no-quit
            \ grep:.<cr>
nnoremap <leader>o :Unite -buffer-name=tags
            \ -start-insert
            \ -no-split
            \ tag<cr>
nnoremap <leader>O :Unite -buffer-name=outline
            \ -start-insert
            \ -no-split
            \ outline<cr>
nnoremap <leader><leader> :Unite -buffer-name=buffers
            \ -start-insert
            \ -no-split
            \ buffer<cr>
nnoremap <leader>t :Unite -buffer-name=todos
            \ -no-quit
            \ vimgrep:**:\\\TODO\:\\\|FIXME\:<cr>
"}}}

"vimfiler "{{{
"<C-l> <Plug>(vimfiler_redraw_screen)
"*     <Plug>(vimfiler_toggle_mark_all_lines)
"U     <Plug>(vimfiler_clear_mark_all_lines)
"cc    <Plug>(vimfiler_copy_file)
"mm    <Plug>(vimfiler_move_file)
"dd    <Plug>(vimfiler_delete_file)
"Cc    <Plug>(vimfiler_clipboard_copy_file)
"Cm    <Plug>(vimfiler_clipboard_move_file)
"Cp    <Plug>(vimfiler_clipboard_paste)
"r     <Plug>(vimfiler_rename_file)
"K     <Plug>(vimfiler_make_directory)
"N     <Plug>(vimfiler_new_file)
"x     <Plug>(vimfiler_execute_system_associated)
"X     <Plug>(vimfiler_execute_vimfiler_associated)
"~     <Plug>(vimfiler_switch_to_home_directory)
"\     <Plug>(vimfiler_switch_to_root_directory)
"&     <Plug>(vimfiler_switch_to_project_directory)
".     <Plug>(vimfiler_toggle_visible_ignore_files)
"g?    <Plug>(vimfiler_help)
"v     <Plug>(vimfiler_preview_file)
"yy    <Plug>(vimfiler_yank_full_path)
"M     <Plug>(vimfiler_set_current_mask)
"S     <Plug>(vimfiler_select_sort_type)
"gs    <Plug>(vimfiler_toggle_safe_mode)
"a     <Plug>(vimfiler_choose_action)
"Y     <Plug>(vimfiler_pushd)
"P     <Plug>(vimfiler_popd)
"T     <Plug>(vimfiler_expand_tree_recursive)
"I     <Plug>(vimfiler_cd_input_directory)

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
    nnoremap <silent><buffer> i <Plug>(vimfiler_toggle_mark_current_line)
    nnoremap <silent><buffer> gh <Plug>(vimfiler_switch_to_history_directory)
    nnoremap <buffer> <Esc><Esc> <Plug>(vimfiler_exit)
endfunction

nnoremap <leader>f :VimFilerCurrentDir -status<cr>
nnoremap <leader>F :VimFilerBufferDir -status <cr>
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
set background=dark
colorscheme gruvbox

"dim inactive  windows
" hi def Dim cterm=none ctermbg=none ctermfg=242

" function! s:DimInactiveWindow()
"     let b:cur_syntax = &syntax
"     syntax clear
"     syntax region Dim start='' end='$$$end$$$'
" endfunction

" function! s:UndimActiveWindow()
"     if exists("b:cur_syntax")
"         execute 'set syntax='.b:cur_syntax
"     endif
" endfunction

" autocmd BufEnter * call s:UndimActiveWindow()
" autocmd WinEnter * call s:UndimActiveWindow()
" autocmd WinLeave * call s:DimInactiveWindow()

"hl line in insert mode
function! s:SetNormalCursorLine()
    hi cursorline cterm=none ctermbg=237 ctermfg=none
endfunction

function! s:SetInsertCursorLine()
    hi cursorline cterm=none ctermbg=235 ctermfg=none
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
            \ 'ctermfgs': ['166', '3', 'magenta', 'lightblue', '9', '118'],
            \ 'separately': {
            \       'html': {}
            \ }
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

"neomake "{{{
highlight neomakeErrorSign ctermfg=196 ctermbg=237
highlight neomakeWarnSign ctermfg=166 ctermbg=237

let g:neomake_error_sign = {'text': '⚑', 'texthl': 'neomakeErrorSign'}
let g:neomake_warning_sign = {'text': '⚑', 'texthl': 'neomakeWarnSign'}
"}}}

"markdown "{{{
autocmd BufRead *.md set wrap lbr
autocmd BufEnter *.md set syntax=markdown
"}}}

"html/templates "{{{
let g:html_inited = 0
function! SetupHtmlSettings()
    set syntax=html
    syntax keyword javaScriptConditional var

    if g:html_inited != 0
        return
    endif
    let g:html_inited = 1

    " highlights
    highlight htmlTagName ctermfg=208
    highlight htmlTag ctermfg=109
    highlight htmlArg ctermfg=109
    highlight javaScript ctermfg=250
endfunction
autocmd BufEnter *.html call SetupHtmlSettings()
"}}}

"python "{{{
set wildignore+=*.pyc
set wildignore+=*/__pycache__/**
set wildignore+=*/__pycache__
set wildignore+=*/.env/^[^g]*

let g:jedi#goto_command = "<leader>pg"
let g:jedi#goto_assignments_command = "<leader>pa"
let g:jedi#goto_definitions_command = "<leader>pd"
let g:jedi#documentation_command = "<leader>pk"
let g:jedi#usages_command = "<leader>pu"
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
    let g:neomake_python_enabled_makers = ['flake8']
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

autocmd BufWinEnter *.py setlocal omnifunc=jedi#completions
"}}}

" vim: set et fdm=marker sts=4 sw=4:
