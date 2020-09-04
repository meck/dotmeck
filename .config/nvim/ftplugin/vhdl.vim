setlocal formatoptions+=cro
setlocal comments=:--
setlocal textwidth=135
setlocal softtabstop=4

" For vim-table
setlocal commentstring=--%s


" Dirty fix while wating for
" https://github.com/jeremiah-c-leary/vhdl-style-guide/issues/353

noremap <F9> :call RunVSG()<CR>

endfor
if exists('*RunVSG')
    finish
endif

function RunVSG()
  let s:cfgfile = findfile(".vsgrc", ".;")
  if s:cfgfile ==# ""
    let s:cfgfile = "nocmd"
  else
    let s:cfgcmd = '--configuration ' . s:cfgfile
  endif
  let s:current_file = expand("%:p")
  setl autoread
  write!
  cgetex system("vsg -f " . s:current_file . " " . s:cfgcmd . " --fix")
  copen
  wincmd p
  edit
  set autoread
endfunction



