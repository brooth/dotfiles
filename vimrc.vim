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

"g:initial_dir = path where vim started
function! InitVimEnterSettings()
    let g:initial_dir = getcwd()
    exec 'set path='.g:initial_dir.','.g:initial_dir.'/**'
endfunction
autocmd VimEnter * call InitVimEnterSettings()
"}}}

"plugins {{{
call plug#begin()

" appearance
Plug 'morhetz/gruvbox'
Plug 'bling/vim-airline'
Plug 'mhartington/oceanic-next'
" paste and indent
Plug 'sickill/vim-pasta'
" show register content on " # <c-r>
Plug 'junegunn/vim-peekaboo'

" tools
Plug 'tpope/vim-surround'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'tpope/vim-commentary'
"exchange arguments with g< g> gs
Plug 'machakann/vim-swap'

" configs
Plug 'editorconfig/editorconfig-vim'

" my boys
Plug '~/Projects/far.vim'
" Plug '~/Projects/meta-x.vim'

" files
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" complition
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"performace and fixes
Plug 'antoinemadec/FixCursorHold.nvim'

call plug#end()
"}}}

"misc {{{
set encoding=utf-8
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

filetype plugin indent on

let mapleader=";"
set timeoutlen=1500
" set pastetoggle=<F12>
set history=300
set mouse=a "all mouse support
set hidden
set showcmd "display what command is waiting for an operator
" set lazyredraw "redraw only when we need to. do not use, cause lagging
set nolz "disable lazydraw
set updatetime=750 "some plugins relay on that, finetune for best performance
set signcolumn=yes:2 "show separate column for signs (gitgutter)
set formatoptions-=cro "do not propogate comments on new lines
set confirm "propmt for saving the file when quit instead of showing error
"set exrc "load .vimrc in the current directory

"allow gf to open non-existent files
map gf :edit <cfile><cr>

"cancel hightlight on Esc
nnoremap <esc> :noh<cr><esc>
inoremap <esc> <esc>:noh<cr><esc>

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
nnoremap <expr> vp '`[' . strpart(getregtype(), 0, 1) . '`]'

"stay same position on insert mode exit
inoremap <silent> <Esc> <Esc>`^
"escape to normal mode
imap jj <esc>
imap kk <esc>
imap ll <esc>
imap hh <esc>
"insert the char in the end and quit from insert mode
imap ;; <Esc>A;<Esc>
imap ,, <Esc>A,<Esc>

"vi mode moving in insert mode
inoremap <c-h> <left>
inoremap <c-k> <up>
inoremap <c-j> <down>
inoremap <c-l> <right>

"Open the current file in the default program
nmap <leader>x :!open %<cr><cr>
"}}}

"abbreviations {{{
iabbrev bgc brooth@gmail.com
iabbrev KO Khalidov Oleg
"}}}

"help {{{
nnoremap <F1>u :h usr_41.txt<cr>
nnoremap <F1>f :h function-list<cr>
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

"registers/clipboard {{{
let g:peekaboo_window="call CreateCenteredFloatingWindow()"

function! CreateCenteredFloatingWindow()
    let width = float2nr(&columns * 0.6)
    let height = float2nr(&lines * 0.5)
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}
    let top = "╔" . repeat("═", width - 2) . "╗"
    let mid = "║" . repeat(" ", width - 2) . "║"
    let bot = "╚" . repeat("═", width - 2) . "╝"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction

"select mode with mouse
set selectmode=mouse
"copy selected text (with mouse) to system clipboard
snoremap y <c-g>"+y
"}}}

"session/source {{{
set ssop-=options "do not store vimrc options in session
set viminfo='1000,f1 "store marks
set undofile "store undo history

"set a directory to store the undo history
exec 'set undodir='.$VIMHOME.'/undo'
"store swp files in vim dir
exec 'set dir='.$VIMHOME.'/swp'

"return to last edit position
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

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
nnoremap <silent><c-s>r :source ~/Projects/dotfiles/vimrc.vim<cr>
nnoremap <silent><c-s>t :source %<cr>
"}}}

"buffers/windows/tabs {{{
"functions {{{
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
"}}}

"Buffers
nnoremap <silent><c-w>n :bnext<cr>
nnoremap <silent><c-w>p :bprevious<cr>
nnoremap <silent><c-w>b :buffers<CR>:buffer 
nnoremap <silent><c-w>e :e!<cr>
nnoremap <silent><c-w><c-d> :bd %<cr>
nnoremap <silent><c-w><c-w> :call WipeBufferGoPrev()<cr>
nnoremap <silent><c-w><c-b> :call DeleteBackBuffers()<cr>
nnoremap <silent><c-w><c-o> :call DeleteOtherBuffers()<cr>
nnoremap <silent><c-w><c-u> :call DeleteUnmodifiedBuffers()<cr>
nnoremap <silent><c-w><c-r> :call DeleteRightBuffers()<cr>
nnoremap <silent><c-w><c-l> :call DeleteLeftBuffers()<cr>

"Windows, split/swap and move the cursor to new/swapped pane
nnoremap <c-w>V <c-w><c-v><c-w>l
nnoremap <c-w>S <c-w><c-s><c-w>j
nnoremap <c-w>r <c-w><c-r><c-w><c-w>

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

"far.vim
let g:far#debug = 1
let g:far#check_window_resize_period = 3000
let g:far#file_mask_favorits = ['%', '**/*.*', '**/*.dart', '**/*.ts', '**/*.js']
"}}}

"indent/tab/spaces "{{{
set virtualedit=all "move curson over empty space
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

let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#343D46'
"}}}

"lines/numbers/wrap {{{
set number "show line number
set rnu "releative line numbers
set nowrap "no wrapping by default

set scrolloff=5 "keep 5 lines below and above from the cursor
set sidescroll=1 "horizontal scroll by 1 col
set sidescrolloff=5  "keep 5 lines left and right from the cursor

"go between wrapped lines
map j gj
map k gk
map <Down> gj
map <Up> gk

"leader-l - Lines
nnoremap <leade>lr :set number<cr>:set rnu<cr>
nnoremap <leade>ln :set nornu<cr>:set number<cr>
nnoremap <leade>lh :set nonumber<cr>:set nornu<cr>
nnoremap <leade>lw :set wrap!<cr>
" }}}

"folds {{{
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
" }}}

"lint/correcting {{{
"trailing
nnoremap <c-c>t :%s/\s\+$//e<cr>:nohl<cr>
"mixed indent
nnoremap <c-c>i :retab<cr>
"goto next, prev. open error
nnoremap <c-c>l :lopen<cr>
nnoremap <c-c>j :lnext<cr>
nnoremap <c-c>k :lprevious<cr>

"format all file
nnoremap <c-c>= mCgg=G`CmC
"}}}

"files/types {{{
set wildignore+=*/bin/*
set wildignore+=*/.git/*
set wildignore+=*/.idea/*
set wildignore+=*/build/*
set wildignore+=*/node_modules/*
set wildignore+=*/.history/*
"}}}

"navigation "{{{
"Netrw
let g:netrw_banner = 0
let g:netrw_listsjyle = 1

nnoremap <silent> <c-n>e :Explore<cr>
"}}}

"Ctrl+g - Git "{{{
let g:gitgutter_map_keys = 0 "no mappings by gitgutter

"focus window of last created buffer
function! JumpLastBufferWindow()
    call win_gotoid(win_getid(bufwinnr(last_buffer_nr())))
endfunction

nnoremap <c-g>R :!git checkout <c-r>%<cr><cr>
nnoremap <c-g>p :GitGutterPreviewHunk<cr>:call JumpLastBufferWindow()<cr>
nnoremap <c-g>r :GitGutterUndoHunk<cr>
nnoremap <c-g>S :GitGutterStageHunk<cr>
nnoremap <c-g>l :GitGutterLineHighlightsToggle<cr>
nnoremap <c-g>k :GitGutterPrevHunk<cr>
nnoremap <c-g>j :GitGutterNextHunk<cr>

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_modified_removed = '?'

function! s:ConfigGitGutter()
    if(&termguicolors)
        hi GitGutterAdd guibg=#1E303B guifg=#b8bb26
        hi GitGutterChange guibg=#1E303B guifg=#d9a243
        hi GitGutterDelete guibg=#1E303B guifg=#fb4934
        hi GitGutterChangeDelete guibg=#1E303B guifg=#fb4934
    else
        hi GitGutterAdd ctermfg=244 ctermbg=237
        hi GitGutterChange ctermfg=244 ctermbg=237
        hi GitGutterDelete ctermfg=244 ctermbg=237
        hi GitGutterChangeDelete ctermfg=244 ctermbg=237
    endif
endfunction
autocmd VimEnter * call s:ConfigGitGutter()
"}}}

"theme {{{
set background=dark
colorscheme gruvbox

if (has("termguicolors"))
    set termguicolors
    hi LineNr guifg=#65737E guibg=#1E303B
    hi CursorLineNr guifg=#EC5f67 guibg=#1E303B gui=none
    hi SignatureMarkText guifg=#FAC863 guibg=#1E303B
    hi SignColumn ctermfg=243 guifg=#65737E guibg=#1E303B "signcolumn same color as numbers
endif

" highlight line in insert mode
hi cursorline cterm=none ctermbg=238 ctermfg=none
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul
set nocul

"hl TODO, FIXME in blue bold
highlight Todo ctermfg=blue guibg=none guifg=#6699CC gui=bold cterm=bold

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

"completion {{{
set completeopt-=preview "disable preview popup buffer

" set nobackup
" set nowritebackup
" set cmdheight=1
" set shortmess+=c

let g:coc_global_extensions = [
    \ 'coc-css',
    \ 'coc-diagnostic',
    \ 'coc-emmet',
    \ 'coc-eslint',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-pairs',
    \ 'coc-sh',
    \ 'coc-snippets',
\ ]

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"" Use <s-space> to trigger completion.
"if has('nvim')
"    inoremap <silent><expr> <s-space> coc#refresh()
"else
"    inoremap <silent><expr> <s-@> coc#refresh()
"endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

"navigate diagnostics
nmap <silent><c-k>p <Plug>(coc-diagnostic-prev)
nmap <silent><c-k>n <Plug>(coc-diagnostic-next)
"goto code navigation.
nmap <silent> <c-k><c-d> <Plug>(coc-definition)
nmap <silent> <c-k><c-y> <Plug>(coc-type-definition)
nmap <silent> <c-k><c-i> <Plug>(coc-implementation)
nmap <silent> <c-k><c-r> <Plug>(coc-references)
"renaming.
nmap <c-k>r <Plug>(coc-rename)

"show documentation in preview window.
nnoremap <silent> <c-k><c-d> :call <SID>show_documentation()<CR>
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction

"highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

"formatting
xmap <c-k>= <Plug>(coc-format-selected)
nmap <c-k>= <Plug>(coc-format-selected)

augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

"applying codeAction to the selected region.
"Example: `<c-k>aap` for current paragraph
xmap <c-k>a <Plug>(coc-codeaction-selected)
nmap <c-k>a <Plug>(coc-codeaction-selected)

"remap keys for applying codeAction to the current buffer.
nmap <c-k>ac <Plug>(coc-codeaction)
"apply AutoFix to problem on the current line.
nmap <c-k><c-f> <Plug>(coc-fix-current)

"" Map function and class text objects
"" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
"xmap if <Plug>(coc-funcobj-i)
"omap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap af <Plug>(coc-funcobj-a)
"xmap ic <Plug>(coc-classobj-i)
"omap ic <Plug>(coc-classobj-i)
"xmap ac <Plug>(coc-classobj-a)
"omap ac <Plug>(coc-classobj-a)

"" Remap <C-f> and <C-b> for scroll float windows/popups.
"if has('nvim-0.4.0') || has('patch-8.2.0750')
"    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"endif

"" Use CTRL-S for selections ranges.
"" Requires 'textDocument/selectionRange' support of language server.
"nmap <silent> <C-s> <Plug>(coc-range-select)
"xmap <silent> <C-s> <Plug>(coc-range-select)

"add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

"add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

"" Add (Neo)Vim's native statusline support.
"" NOTE: Please see `:h coc-status` for integrations with external plugins that
"" provide custom statusline: lightline.vim, vim-airline.
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

"" Mappings for CoCList
"" Show all diagnostics.
"nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
"" Manage extensions.
"nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
"" Show commands.
"nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
"" Find symbol of current document.
"nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
"" Search workspace symbols.
"nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
"" Do default action for next item.
"nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
"" Do default action for previous item.
"nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
"" Resume latest coc list.
"nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
""}}}

" vim: set et fdm=marker sts=4 sw=4:
