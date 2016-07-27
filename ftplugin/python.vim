set wildignore+=*.pyc
set wildignore+=*/env/^[^g]*

let g:jedi#goto_command = "<leader>G"
let g:jedi#goto_assignments_command = "<leader>A"
let g:jedi#goto_definitions_command = "<leader>P"
let g:jedi#documentation_command = "<leader>D"
let g:jedi#usages_command = "<leader>U"
let g:jedi#completions_command = "<c-Space>"
let g:jedi#rename_command = "<leader>R"

"jedi
let g:jedi#show_call_signatures = "1"
let g:jedi#popup_select_first = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#completions_enabled = 0

"syntastic
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_flake8_args='--ignore=E501,E126,E128'

"enable all Python syntax highlighting features
if has('python3')
    let g:jedi#force_py_version = 3
endif
let python_highlight_all = 1

set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
set nocindent

set completeopt-=preview
if has('python3')
    set omnifunc=python3complete#Complete
endif

