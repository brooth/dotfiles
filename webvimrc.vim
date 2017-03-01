"
" vimrc for web/react-native dev
"
let g:plugins = {
            \   'neomake/neomake': {},
            \   'pangloss/vim-javascript': {},
            \   'mxw/vim-jsx': {},
            \   'othree/yajs': {},
            \   'steelsojka/deoplete-flow': {}
            \ }

source ~/Projects/dotfiles/vimrc.vim

"search/replace/subtitude "{{{
call add(g:far#file_mask_favorits, ['**/*.html', '**/*.js'])
"}}}

"theme {{{
if (&termguicolors)
    hi xmlTagName guifg=#EC5f67
    hi xmlTagN guifg=#EC5f67
    hi xmlAttrib guifg=#C594C5
    hi jsBrackets guifg=#5FB3B3
    hi jsBraces guifg=#5FB3B3
    hi jsParens guifg=#5FB3B3
    hi jsFuncParens guifg=#5FB3B3
    hi jsFuncCall guifg=#6699CC
    hi jsObjectProp guifg=#EC5f67
    hi jsGlobalObjects guifg=#fac863
    hi jsStorageClass guifg=#C594C5
endif
"}}}

"js/react/nodejs "{{{
let g:jsx_ext_required = 0
let g:javascript_plugin_flow = 1

set wildignore+=*/node_modules
set wildignore+=*/node_modules/**

syntax keyword jsConditional delete

"deoplete
" call deoplete#custom#set('flow', 'rank', 700)
let flow_path = getcwd() . '/node_modules/.bin/flow'
let g:deoplete#sources#flow#flow_bin = flow_path

"neomake
function! ProcessEslint(entry)
    if a:entry.text =~ 'Warning'
        let a:entry.type = 'W'
    endif
endfunction

let g:neomake_javascript_enabled_makers = ['eslint']
let eslint_exec = getcwd() . '/node_modules/.bin/eslint'
let g:neomake_javascript_eslint_maker = {
            \ 'exe': eslint_exec,
            \ 'args': ['-f', 'compact'],
            \ 'errorformat': '%f: line %l\, col %c\, %m',
            \ 'postprocess': function('ProcessEslint')
            \ }
let g:neomake_jsx_enabled_makers = g:neomake_javascript_enabled_makers
let g:neomake_jsz_eslint_maker = g:neomake_javascript_eslint_maker

autocmd! BufRead *.js Neomake
autocmd! BufWritePost *.js Neomake

map <m-9> :!adb shell input keyevent 3 &<cr><cr>
map <m-0> :!adb shell input keyevent 82 &<cr><cr>
" let g:neomake_logfile='/tmp/neomake.log'
"}}}

"html/templates "{{{
let g:html_inited = 0
function! SetupHtmlSettings()
    set syntax=html
    syntax keyword javaScriptConditional var,of

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

" vim: set et fdm=marker sts=4 sw=4:
