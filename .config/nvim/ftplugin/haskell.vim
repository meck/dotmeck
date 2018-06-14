" ----- haskell-vim -----

let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

" ----- w0rp/ale -----

" Testing Language Server For Linting instead of ale
let b:ale_enabled = 0
setlocal signcolumn=yes
" let g:ale_linters.haskell = ['stack-ghc-mod', 'hlint']

" ----- ndmitchell/ghcid -----
nnoremap <silent> <leader>hg :Ghcid<CR>

" ----- parsonsmatt/intero-neovim -----

" Wait with starting Intero
let g:intero_start_immediately = 0

" Use ALE (works even when not using Intero)
let g:intero_use_neomake = 0

" Show type on hover
" let g:intero_type_on_hover = 0
" set updatetime=1000

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

" ---- eagletmt/neco-ghc -----

"  Show type in autocomplete
" let g:necoghc_enable_detailed_browse = 1

" ----- Code formating -----

" Formating on save
let g:brittany_on_save = 1
let g:hindent_on_save = 0
let g:stylishask_on_save = 1

" Mappings
nnoremap <leader>hfb :Brittany<CR>
nnoremap <leader>hfi :Hindent<CR>
nnoremap <leader>hfs :Stylishask<CR>

" ----- Hoogle -----

" Hoogle the word under the cursor
nnoremap <silent> <leader>hh :Hoogle<CR>

" Hoogle and prompt for input
nnoremap <leader>hH :Hoogle<space>

" Hoogle for detailed documentation (e.g. "Functor")
nnoremap <silent> <leader>hi :HoogleInfo<CR>

" Hoogle for detailed documentation and prompt for input
nnoremap <leader>hI :HoogleInfo<space>

" Hoogle, close the Hoogle window
nnoremap <silent> <leader>hz :HoogleClose<CR>


" ----- Pointfree convertion -----

function! s:pointfree()
  call system('pointfree '.shellescape(join(getline(a:firstline, a:lastline), "\n")))
endfunction

function! s:pointful()
  call system('pointful '.shellescape(join(getline(a:firstline, a:lastline), "\n")))
endfunction

vnoremap <silent> <leader>hm :echo s:pointfree()<CR>
vnoremap <silent> <leader>hM :echo s:pointful()<CR>

function! Pointfree()
  call setline('.', split(system('pointfree '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
endfunction
vnoremap <silent> <leader>h. :call Pointfree()<CR>

function! Pointful()
  call setline('.', split(system('pointful '.shellescape(join(getline(a:firstline, a:lastline), "\n"))), "\n"))
endfunction
vnoremap <silent> <leader>h> :call Pointful()<CR>

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
