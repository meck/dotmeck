" ----- Indenting -----
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal textwidth=80

" ----- haskell-vim -----
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

" ----- Indenting according to ormolu ----
let g:haskell_indent_if = 2
let g:haskell_indent_case = 2
let g:haskell_indent_let = 2
let g:haskell_indent_where = 2
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do = 4
let g:haskell_indent_in = 2
let g:haskell_indent_guard = 2


" ----- For diagnostics -----
setlocal signcolumn=yes


" ----- ndmitchell/ghcid -----
nnoremap <silent> <leader>hg :Ghcid<CR>
