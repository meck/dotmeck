set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1

" let g:go_auto_sameids = 1
let g:go_auto_type_info = 1

" ALE Settings
let g:ale_go_gometalinter_options = '
  \ --aggregate
  \ --fast
  \ --sort=line
  \ --vendor
  \ --vendored-linters
  \ --disable=gotype
  \ --disable=gas
  \ --disable=goconst
  \ --disable=gocyclo
  \ '
let g:ale_linters = {'go': ['gometalinter']}
