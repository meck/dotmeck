" ----- w0rp/ale -----

let g:ale_linters.haskell = ['stack-ghc-mod', 'hlint']

" ----- parsonsmatt/intero-neovim -----

" Prefer starting Intero manually (faster startup times)
let g:intero_start_immediately = 0

" Use ALE (works even when not using Intero)
let g:intero_use_neomake = 0

" ---- eagletmt/neco-ghc -----

"  Show type in autocomplete
let g:necoghc_enable_detailed_browse = 1

" ----- Code formating -----

" Formating on save is too aggressive for me
let g:hindent_on_save = 0
let g:stylishask_on_save = 0
let g:brittany_on_save = 0

function! HaskellFormat()
  :Hindent
  :Stylishask
endfunction

" Just hindent
nnoremap <leader>fi :Hindent<CR>
" Just stylish-haskell
nnoremap <leader>fs :Stylishask<CR>
" Brittany
nnoremap <leader>fb :Brittany<CR>
" First hindent, then stylish-haskell
nnoremap <leader>ff :call HaskellFormat()<CR>


" ----- Intero -----

nnoremap <silent> <leader>io :InteroOpen<CR>
nnoremap <silent> <leader>iov :InteroOpen<CR><C-W>H
nnoremap <silent> <leader>ih :InteroHide<CR>
nnoremap <silent> <leader>is :InteroStart<CR>
nnoremap <silent> <leader>ik :InteroKill<CR>

nnoremap <silent> <leader>wr :w \| :InteroReload<CR>
nnoremap <silent> <leader>il :InteroLoadCurrentModule<CR>
nnoremap <silent> <leader>if :InteroLoadCurrentFile<CR>

map <leader>t <Plug>InteroGenericType
map <leader>T <Plug>InteroType
nnoremap <silent> <leader>it :InteroTypeInsert<CR>

nnoremap <silent> <leader>jd :InteroGoToDef<CR>
nnoremap <silent> <leader>iu :InteroUses<CR>
nnoremap <leader>ist :InteroSetTargets<SPACE>

" Enter insertmode when going to the REPL
autocmd BufWinEnter,WinEnter Intero startinsert

" " Reload the file in Intero after saving
" autocmd! BufWritePost *.hs InteroReload


" ----- Hoogle -----

" Hoogle the word under the cursor
nnoremap <silent> <leader>hh :Hoogle<CR>

" Hoogle and prompt for input
nnoremap <leader>hH :Hoogle

" Hoogle for detailed documentation (e.g. "Functor")
nnoremap <silent> <leader>hi :HoogleInfo<CR>

" Hoogle for detailed documentation and prompt for input
nnoremap <leader>hI :HoogleInfo

" Hoogle, close the Hoogle window
nnoremap <silent> <leader>hz :HoogleClose<CR>


" ----- Pointfree convertion -----

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
    \ 'ctagsbin'  : 'hasktags',
    \ 'ctagsargs' : '-x -c -o-',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:1:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type'
    \ },
    \ 'scope2kind' : {
        \ 'module' : 'm',
        \ 'class'  : 'c',
        \ 'data'   : 'd',
        \ 'type'   : 't'
    \ }
\ }
