" ----- Indenting -----
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=80
" setlocal colorcolumn=+1

" ----- haskell-vim -----
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

let g:haskell_indent_if = 4
let g:haskell_indent_case = 4
let g:haskell_indent_let = 4
let g:haskell_indent_where = 6
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do = 3
let g:haskell_indent_in = 4
let g:haskell_indent_guard = 4

" ----- Coc.nvim -----
setlocal signcolumn=yes

" ----- ndmitchell/ghcid -----
nnoremap <silent> <leader>hg :Ghcid<CR>


" ----- parsonsmatt/intero-neovim -----
" Wait with starting Intero
let g:intero_start_immediately = 0

" Use ALE (works even when not using Intero)
let g:intero_use_neomake = 0

let g:intero_backend = { 'command': 'stack repl' }

augroup interoMappings
  autocmd!

  " Open and go to the New window
  nnoremap <silent> <leader>io :execute 'InteroOpen' <Bar> :call <SID>win_by_bufname('Intero')<CR>
  nnoremap <silent> <leader>ih :InteroHide<CR>
  nnoremap <silent> <leader>is :InteroStart<CR>
  nnoremap <silent> <leader>ik :InteroKill<CR>

  " Reload the file in Intero after saving but only when intero is running
  function! ReloadInteroIfRunning()
    if exists('g:intero_started') && g:intero_started
      :InteroReload
    endif
  endfunction
  autocmd BufWritePost *.hs call ReloadInteroIfRunning()

  " nnoremap <silent> <leader>wr :w \| :InteroReload<CR>

  nnoremap <silent> <leader>il :execute 'InteroLoadCurrentModule' <Bar> :call <SID>win_by_bufname('Intero')<CR>
  nnoremap <silent> <leader>if :execute 'InteroLoadCurrentFile' <Bar> :call <SID>win_by_bufname('Intero')<CR>

  nnoremap <silent> <leader>it :InteroTypeInsert<CR>
  nnoremap <silent> <leader>iT :InteroToggleTypeOnHover<CR>

  nnoremap <silent> <leader>id :InteroGoToDef<CR>
  nnoremap <silent> <leader>iu :InteroUses<CR>
  nnoremap <leader>ist :InteroSetTargets<SPACE>

  " Enter insertmode when going to the REPL
  autocmd BufWinEnter,WinEnter Intero startinsert | setlocal winfixheight

augroup END

" ----- Code formating -----

" Formating on save
let g:brittany_on_save = 0
let g:hindent_on_save = 0
let g:stylishask_on_save = 0

" Mappings
noremap <leader>hfb :Brittany<CR>
noremap <leader>hfi :Hindent<CR>
noremap <leader>hfs :Stylishask<CR>

" ----- vim-clap-hoogle -----
" Search the word under the cursor
nnoremap <silent><Leader>hh :Clap hoogle ++query=<cword><CR>
" Open search
nnoremap <silent><Leader>hH :Clap hoogle<CR>

" ----- alfred-hoogle -----
nnoremap <silent><Leader>ho :silent execute ':!/usr/bin/osascript -e '
  \ . shellescape('tell application "Alfred 3" to run trigger "ext_trig"
  \ in workflow "se.meck.alfred-hoogle"
  \ with argument "' . expand('<cword>') . '"') <CR>

" ----- Tagbar -----

" Hasktags for tagbar
let g:tagbar_type_haskell = {
    \ 'ctagsbin'    : 'hasktags',
    \ 'ctagsargs'   : '-x -c -o-',
    \ 'kinds'       : [
        \  'm:modules:0:1',
        \  'd:data:0:1',
        \  'd_gadt:data gadt:0:1',
        \  'nt:newtype:0:1',
        \  'c:classes:0:1',
        \  'i:instances:0:1',
        \  'cons:constructors:0:1',
        \  'c_gadt:constructor gadt:0:1',
        \  'c_a:constructor accessors:1:1',
        \  't:type names:0:1',
        \  'pt:pattern types:0:1',
        \  'pi:pattern implementations:0:1',
        \  'ft:function types:0:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'          : '.',
    \ 'kind2scope'   : {
        \ 'm'        : 'module',
        \ 'd'        : 'data',
        \ 'd_gadt'   : 'd_gadt',
        \ 'c_gadt'   : 'c_gadt',
        \ 'nt'       : 'newtype',
        \ 'cons'     : 'cons',
        \ 'c_a'      : 'accessor',
        \ 'c'        : 'class',
        \ 'i'        : 'instance'
    \ },
    \ 'scope2kind'   : {
        \ 'module'   : 'm',
        \ 'data'     : 'd',
        \ 'newtype'  : 'nt',
        \ 'cons'     : 'c_a',
        \ 'd_gadt'   : 'c_gadt',
        \ 'class'    : 'ft',
        \ 'instance' : 'ft'
    \ }
\ }

" Switch to buffer by name
function! s:win_by_bufname(bufname)
    let l:bufmap = map(range(1, winnr('$')), '[bufname(winbufnr(v:val)), v:val]')
    let l:thewindow = filter(l:bufmap, 'v:val[0] =~ a:bufname')[0][1]
    execute l:thewindow 'wincmd w'
endfunction
