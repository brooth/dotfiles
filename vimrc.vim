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

"plugins {{{
call plug#begin()

" syntax
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" theme
Plug 'bling/vim-airline'
Plug 'mhartington/oceanic-next'
Plug 'ryanoasis/vim-devicons'
" Plug 'TaDaa/vimade' "dim inactive windows
Plug 'tmux-plugins/vim-tmux-focus-events' "dim when jumping to tmux

" tools
Plug 'tpope/vim-surround'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'tpope/vim-commentary'
Plug 'folke/which-key.nvim'
Plug 'machakann/vim-swap' "exchange arguments with g< g> gs
Plug 'mg979/vim-visual-multi'
Plug 'mbbill/undotree'
Plug 'karb94/neoscroll.nvim'

" configs
" Plug 'editorconfig/editorconfig-vim'

" text editing
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

" my boys
Plug '~/Projects/far.vim'
" Plug '~/Projects/meta-x.vim'

" navigation
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'phaazon/hop.nvim'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'kyazdani42/nvim-web-devicons'

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" dev
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mfussenegger/nvim-dap'

"performace and fixes
Plug 'antoinemadec/FixCursorHold.nvim'

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

    " open NVimTree and two empty splits by defauls (no args)
    if argc() == 0
        exec 'vsplit'
        exec 'NvimTreeOpen'
    endif
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
nnoremap <expr> gvp '`[' . strpart(getregtype(), 0, 1) . '`]'
"paste and select pasted text
nnoremap vp pgvp
nnoremap vP Pgvp

"vi mode moving in insert mode
inoremap <c-h> <left>
inoremap <c-k> <up>
inoremap <c-j> <down>
inoremap <c-l> <right>
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

" tools {{{
lua require('neoscroll').setup()

" highlight yank
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup END

lua << EOF
--require('neoscroll').setup()

require("which-key").setup {
    plugins = {
        marks = true,
        registers = true,
        spelling = {
            enabled = false,
        },
    },
    key_labels = {
        -- not working
        ["<C-W><C-B>"] = "Delete Back Buffers",
    },
    window = {
        border = "none", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
        winblend = 0
    },
}
EOF

"multi-cursor
let g:VM_mouse_mappings = 1
let g:VM_maps = {}
let g:VM_maps["Add Cursor Down"] = '\\j'
let g:VM_maps["Add Cursor Up"] = '\\k'
let g:VM_maps["Add Cursor Up"] = '\\k'

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

autocmd FocusLost * wa|echom 'All buffers saved!'
 
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

"save current buffer with F2
nnoremap <F2> :w<cr>
inoremap <F2> <Esc>:w<cr>
vnoremap <F2> <Esc>:w<cr>
nnoremap <F3> :wa<cr>
inoremap <F3> <Esc>:wa<cr>
vnoremap <F3> <Esc>:wa<cr>
"close current window
nnoremap <F10> :q<cr>
"}}}

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
" map <silent> j gj
" map <silent> k gk
" map <Down> gj
" map <Up> gk

"leader-l - Lines
nnoremap <leader>lr :set number<cr>:set rnu<cr>
nnoremap <leader>ln :set nornu<cr>:set number<cr>
nnoremap <leader>lh :set nonumber<cr>:set nornu<cr>
nnoremap <leader>lw :set wrap!<cr>
" }}}

"folds {{{
set foldlevelstart=0 "do not fold new buffers
set foldnestmax=2

augroup remember_folds
    autocmd!
    autocmd BufWinLeave *.* mkview
    autocmd BufWinEnter *.* silent! loadview
augroup END

" TODO: check filetype is supported by treesitter
autocmd BufEnter * if !&readonly && &foldmethod == 'manual' |
  \ set foldmethod=expr |
  \ set foldexpr=nvim_treesitter#foldexpr() |
  \ endif

function! CloseFolds(level)
    let n = 0
    let lines = line('$')
    while (n <= lines)
        if a:level == foldlevel(n)
            exec ''. n . 'foldc'
            let end = foldclosedend(n)
            if end != -1
                let n = end
            endif
        endif
        let n = n + 1
    endwhile
endfun
function! OpenFolds(level)
    for n in range(0, line('$'))
        if a:level == foldlevel(n) && foldclosed(n) == n
            exec ''. n . 'foldo'
        endif
    endfor
endfunc

nnoremap <silent> zlc :call CloseFolds(v:count)<cr>
nnoremap <silent> zlo :call OpenFolds(v:count)<cr>
"}}}

"lint/correcting {{{
"trailing
nnoremap <c-c>t :%s/\s\+$//e<cr>:nohl<cr>
"mixed indent
nnoremap <c-c>i :retab<cr>
"goto next, prev. open error
nnoremap ]] :lnext<cr>
nnoremap [[ :lprevious<cr>
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

"syntax hightlight "{{{

"hl TODO:, FIXME: in blue bold
augroup vimrc_todo
    au!
    au Syntax * syn match MyTodo /\v<(FIXME|NOTE|TODO):/
          \ containedin=.*Comment
augroup END
hi def link MyTodo Todo

function! SyntaxUnderCursor()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

lua <<EOF
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  },
  playground = {
    enable = true,
  },
}
EOF
"}}}

"navigation "{{{
"hop
lua << EOF
    require('hop').setup()
EOF

nnoremap s <cmd> HopChar1<cr>

" Telescope {{{
lua << EOF
local actions = require("telescope.actions")
local borderchars = {"═", "║", "═", "║", "╔", "╗", "╝", "╚"}

-- displays stats (1/4) on the propmt
function status_stats(self)
  local xx = (self.stats.processed or 0) - (self.stats.filtered or 0)
  local yy = self.stats.processed or 0
  if xx == 0 and yy == 0 then
    return ""
  end
  return string.format(" %s/%s ", xx, yy)
end

require('telescope').setup {
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
      vertical = {
        width = 0.5,
        height = 0.5,
        anchor = 'N',
      },
    },
    border = true,
    borderchars = borderchars,
    get_status_text = status_stats,
    prompt_prefix = ' ',
    selection_caret = ' ',
    entry_prefix = ' ',
    color_devicons = true,
    disable_devicons = false,
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = {
      "node_modules",
      ".git",
      ".cache",
      ".history",
    },
    set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
      n = {
        ["<esc>"] = actions.delete_buffer,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      prompt_title = "",
      results_title = "",
      preview_title = "",
      previewer = false,
      dir_icon = '',
      selection_caret = ' ',
      entry_prefix = ' ',
      cwd = vim.fn.getcwd(),
    },
    file_browser = {
      hidden = true,
      prompt_title = "",
      results_title = "",
      preview_title = "",
      previewer = false,
      dir_icon = '',
    }, 
    buffers = {
      layout_strategy = 'vertical',
      theme = 'dropdown',
      previewer = false,
      prompt_title = "",
      results_title = "",
      preview_title = "",
      borderchars = borderchars,
      ignore_current_buffer = true,
      sort_mru = true,
      selection_caret = ' ',
      entry_prefix = ' ',
    },
    oldfiles = {
      layout_strategy = 'vertical',
      theme = 'dropdown',
      previewer = false,
      prompt_title = "",
      results_title = "",
      preview_title = "",
      borderchars = borderchars
    },
  },
}
EOF

nnoremap <c-p>p <cmd>Telescope buffers<cr>
nnoremap <c-p><c-p> <cmd>Telescope find_files<cr>
nnoremap <silent> <c-p>b :exec 'Telescope file_browser cwd=' . expand('%:h')<cr>
nnoremap <silent> <c-p>s :exec 'Telescope file_browser cwd=' . getcwd() . '/src'<cr>
nnoremap <silent> <c-p>r :exec 'Telescope file_browser cwd=' . getcwd()<cr>
nnoremap <c-p>g <cmd>Telescope live_grep<cr>
nnoremap <c-p>? <cmd>Telescope help_tags<cr>
nnoremap <c-p>h <cmd>Telescope oldfiles<cr>
nnoremap <c-p>c <cmd>Telescope command_history<cr>

"Open the current file in the default program
nmap <c-p>x :!open %<cr><cr>
"}}}

"NvimTree {{{

"TODO: autocmd on bufclose, check if only one window is visible then open the tree?
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "",
    \   '-unstaged': "",
    \   '-staged': "",
    \   'unmerged': "",
    \   '-renamed': "➜",
    \   'untracked': "ﮦ",
    \   '-deleted': "",
    \   '-ignored': ""
    \   },
    \ 'folder': {
    \   'arrow_open': "-",
    \   'arrow_closed': "+",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   }
    \ }

lua << EOF
local tree_cb = require('nvim-tree.config').nvim_tree_callback

require('nvim-tree').setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  ignore_ft_on_setup  = {},
  auto_close          = false,
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  update_to_buf_dir   = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = false,
    icons = {
      hint = "h",
      info = "i",
      warning = "w",
      error = "r",
    }
  },
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 40,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    auto_resize = true,
    mappings = {
      custom_only = false,
      list = {
        { key = {"zo"}, cb = tree_cb("open") },
        { key = {"zc"}, cb = tree_cb("close_node") },
      }
    },
    number = false,
    relativenumber = false,
    signcolumn = "yes"
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  }
}
--{ key = {"<CR>", "o", "<2-LeftMouse>"}, cb = tree_cb("edit") },
--{ key = {"<2-RightMouse>", "<C-]>"},    cb = tree_cb("cd") },
--{ key = "<C-v>",                        cb = tree_cb("vsplit") },
--{ key = "<C-x>",                        cb = tree_cb("split") },
--{ key = "<C-t>",                        cb = tree_cb("tabnew") },
--{ key = "<",                            cb = tree_cb("prev_sibling") },
--{ key = ">",                            cb = tree_cb("next_sibling") },
--{ key = "P",                            cb = tree_cb("parent_node") },
--{ key = "<BS>",                         cb = tree_cb("close_node") },
--{ key = "<S-CR>",                       cb = tree_cb("close_node") },
--{ key = "<Tab>",                        cb = tree_cb("preview") },
--{ key = "K",                            cb = tree_cb("first_sibling") },
--{ key = "J",                            cb = tree_cb("last_sibling") },
--{ key = "I",                            cb = tree_cb("toggle_ignored") },
--{ key = "H",                            cb = tree_cb("toggle_dotfiles") },
--{ key = "R",                            cb = tree_cb("refresh") },
--{ key = "a",                            cb = tree_cb("create") },
--{ key = "d",                            cb = tree_cb("remove") },
--{ key = "D",                            cb = tree_cb("trash") },
--{ key = "r",                            cb = tree_cb("rename") },
--{ key = "<C-r>",                        cb = tree_cb("full_rename") },
--{ key = "x",                            cb = tree_cb("cut") },
--{ key = "c",                            cb = tree_cb("copy") },
--{ key = "p",                            cb = tree_cb("paste") },
--{ key = "y",                            cb = tree_cb("copy_name") },
--{ key = "Y",                            cb = tree_cb("copy_path") },
--{ key = "gy",                           cb = tree_cb("copy_absolute_path") },
--{ key = "[c",                           cb = tree_cb("prev_git_item") },
--{ key = "]c",                           cb = tree_cb("next_git_item") },
--{ key = "-",                            cb = tree_cb("dir_up") },
--{ key = "s",                            cb = tree_cb("system_open") },
--{ key = "q",                            cb = tree_cb("close") },
--{ key = "g?",                           cb = tree_cb("toggle_help") },
EOF

function! ToogleNvimTreeSmart()
    if &filetype == 'NvimTree'
        exec ':NvimTreeClose'
    elseif &filetype == ''
        exec ':NvimTreeFocus'
    else
        exec ':NvimTreeFindFile'
    endif
endfunction

nnoremap <silent> <c-p>n :call ToogleNvimTreeSmart()<CR>
nnoremap <silent> <c-p><c-n> :NvimTreeToggle<CR>
"}}}
"}}}

"git <c-g> {{{
let g:gitgutter_map_keys = 0 "no mappings by gitgutter

" fugitive
nnoremap <c-g><c-g> :Git<cr>
nnoremap <c-g><c-c> :Git commit<cr>
nnoremap <c-g><c-p> :Git push<cr>

" git gutter
nnoremap <c-g>R :!git checkout <c-r>%<cr><cr>
nnoremap <c-g>p :GitGutterPreviewHunk<cr>:call JumpLastBufferWindow()<cr>
nnoremap <c-g>r :GitGutterUndoHunk<cr>
nnoremap <c-g>S :GitGutterStageHunk<cr>
nnoremap <c-g>d :GitGutterLineHighlightsToggle<cr>
nnoremap <c-g>[ :GitGutterPrevHunk<cr>
nnoremap <c-g>] :GitGutterNextHunk<cr>

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_modified_removed = '~'

function! s:ConfigGitGutter()
    if(&termguicolors)
        hi GitGutterAdd guifg=#b8bb26
        hi GitGutterChange guifg=#d9a243
        hi GitGutterDelete guifg=#fb4934
        hi GitGutterChangeDelete guifg=#fb4934
    endif
endfunction
autocmd VimEnter * call s:ConfigGitGutter()
"}}}

"theme {{{
syntax enable
colorscheme OceanicNext
" set background=dark

if (has("termguicolors"))
    set termguicolors
    "hi LineNr guifg=#65737E guibg=#1E303B
    "hi CursorLineNr guifg=#EC5f67 guibg=#1E303B gui=none
    "hi SignatureMarkText guifg=#FAC863 guibg=#1E303B
    "hi SignColumn ctermfg=243 guifg=#65737E guibg=#1E303B "signcolumn same color as numbers

    " fix jsx/tags coloring
    if g:colors_name == 'OceanicNext'
        hi Comment gui=italic
        hi TSTagAttribute guifg=#c594c5 gui=italic
        hi TSTag guifg=#fac863 "gui=bold
        hi TSConstructor guifg=#
        hi TSVariableBuiltin guifg=# gui=bold
        hi TSKeyword gui=bold
        hi TSConditional gui=bold
        hi TSInclude gui=bold
    endif

    "nvim tree
    hi NvimTreeGitDirty guifg=#d9a243
endif

" highlight line in insert mode
hi cursorline cterm=none ctermbg=238 ctermfg=none guibg=#1f3039
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul
set nocul

"dim vim when jump to tmux
" augroup tmuxdim
"   autocmd!
"   autocmd FocusGained * VimadeUnfadeActive
"   autocmd FocusLost * VimadeFadeActive
" augroup END
"}}}

"airline {{{
set laststatus=2
let g:airline_theme='oceanicnext'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 0
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s '

"window number instead of mode
" let g:airline_section_a="%{bufnr('%')}"
let g:airline_section_z="%l/%L #%v"

function! s:ConfigAirlineSymbols()
    let g:airline_symbols.maxlinenr = ''
    let g:airline_symbols.linenr = ''
endfunction
autocmd VimEnter * call s:ConfigAirlineSymbols()
"}}}

"dev (coc) {{{
set completeopt-=preview "disable preview popup buffer

"set nobackup
"set nowritebackup
"set cmdheight=2
set shortmess+=c "???

let g:coc_global_extensions = [
    \ 'coc-css',
    \ 'coc-diagnostic',
    \ 'coc-emmet',
    \ 'coc-eslint',
    \ 'coc-html',
    \ 'coc-json',
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

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! InitDevMappings()
  "navigate/fix diagnostics
  nmap <silent> [[ <Plug>(coc-diagnostic-prev)
  nmap <silent> ]] <Plug>(coc-diagnostic-next)
  nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
  nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
  nmap <silent> <c-k>d :CocDiagnostics<cr>
  nmap <silent> <c-k><c-k> <Plug>(coc-fix-current)
  nmap <silent> <c-k>k :CocFix<cr>
  nmap <silent> <c-k>l :CocList outline<cr>

  "goto code navigation.
  nmap <silent> <c-]> <Plug>(coc-definition)
  nmap <silent> <c-k>D <Plug>(coc-type-definition)
  nmap <silent> <c-k>I <Plug>(coc-implementation)
  nmap <silent> <c-k>R <Plug>(coc-references)

  "formatting
  nnoremap <silent> <c-k>f :call CocActionAsync('runCommand', 'editor.action.format')<cr>
  nnoremap <c-k>o :call CocAction('runCommand', 'editor.action.organizeImport')<cr>
        \ :call CocAction('runCommand', 'editor.action.format')<cr>
  xmap = <Plug>(coc-format-selected)
  nmap == vv=

  "refactor/renaming.
  nmap <c-k>r <Plug>(coc-rename)

  " show parameters hint
  inoremap <c-p> <c-\><c-o>:call CocActionAsync('showSignatureHelp')<cr>

  " snippets
  nmap <c-k>s :CocCommand snippets.editSnippets<cr>
  nmap <c-k>S :CocCommand snippets.openSnippetFiles<cr>
endfunction

function! OnCocStatusChanged()
    if !exists('g:dev_mappings') &&
          \ stridx(g:coc_status[1:3], 'TSC') >= 0
        call InitDevMappings()
        echom 'Dev mappings enabled!'
        let g:dev_mappings = 1
    endif
endfunction

autocmd User CocStatusChange call OnCocStatusChanged()

"show documentation in preview window.
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>

"highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

"TODO: review {{{
"
"
"add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

"applying codeAction to the selected region.
"Example: `,aap` for current paragraph
xmap ,a <Plug>(coc-codeaction-selected)
nmap ,a <Plug>(coc-codeaction-selected)

"remap keys for applying codeAction to the current buffer.
nmap ,ac <Plug>(coc-codeaction)

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


"" Add (Neo)Vim's native statusline support.
"" NOTE: Please sez `:h coc-status` for integrations with external plugins that
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
"}}}
"}}}

" debugger/inspector <c-j> {{{
nnoremap <silent> <c-j><c-j> :lua require'dap'.continue()<CR>
nnoremap <silent> <c-j>h :lua require'dap'.run_to_cursor()<CR>
nnoremap <silent> <c-j>j :lua require'dap'.step_over()<CR>
nnoremap <silent> <c-j><c-]> :lua require'dap'.step_into()<CR>
nnoremap <silent> <c-j><c-o> :lua require'dap'.step_out()<CR>
nnoremap <silent> <c-j>B :lua require'dap'.list_breakpoints()<CR>
nnoremap <silent> <c-j>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <c-j>c :lua require'dap'.set_breakpoint(vim.fn.input('Condition: '))<CR>
nnoremap <silent> <c-j>l :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point: '))<CR>
nnoremap <silent> <c-j>r :lua require'dap'.repl.open({width=90}, 'vsplit')<CR><c-w>hi
nnoremap <silent> <c-j>y :lua require'dap'.run_last()<CR>
nnoremap <silent> <c-j>k :lua require('dap.ui.widgets').hover()<CR>
nnoremap <silent> <c-j>s :lua local widgets=require("dap.ui.widgets");widgets.sidebar(widgets.scopes, {width=90}).open()<CR>
nnoremap <silent> <c-j>f :lua local widgets=require("dap.ui.widgets");widgets.sidebar(widgets.frames, {width=90}).open()<CR>

lua << EOF
local dap = require('dap')
dap.set_log_level('TRACE');

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/.config/nvim/vimspector-config/gadgets/macos/download/vscode-node-debug2/out/src/nodeDebug.js'},
}
dap.configurations.typescript = {
  {
    name = 'Attach to inspector',
    type = 'node2',
    request = 'attach',
    protocol = 'inspector',
    stopOnEntry = true,
    sourceMaps = true,
    console = 'integratedTerminal',
    cwd= vim.fn.getcwd(),
  },
}
EOF

sign define DapBreakpoint text= texthl=WarningMsg
sign define DapBreakpointRejected text= texthl=LineNr
sign define DapBreakpointCondition text= texthl=WarningMsg
sign define DapLogPoint text= texthl=WarningMsg
sign define DapStopped text= texthl=WarningMsg
"}}}

" vim: set et fdm=marker sts=4 sw=4:
