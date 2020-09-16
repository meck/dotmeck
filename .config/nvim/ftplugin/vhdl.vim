setlocal formatoptions+=cro
setlocal comments=:--
setlocal textwidth=135
setlocal softtabstop=4

" For vim-table
setlocal commentstring=--%s


" Dirty fix while wating for
" https://github.com/jeremiah-c-leary/vhdl-style-guide/issues/353

noremap <silent> <buffer> <F9> :call RunVSG()<CR>

if exists('*RunVSG')
    finish
endif

function RunVSG()

  " Save current as a temporary file
  let s:tmpfile = tempname() . '.vhd'
  execute 'silent write ' . s:tmpfile


  " Traverse up the direcory tree for a cfg file
  let s:cfgcmd = findfile(".vsgrc", ".;")
  if s:cfgcmd !=# ""
    let s:cfgcmd = "--configuration " . s:cfgcmd
  endif

  " clear qf
  call setqflist([])

  " process the tempfile
  cgetex system("vsg -f " . s:tmpfile . " " . s:cfgcmd . " -of syntastic --fix")

  " replace the buffer contents
  call nvim_buf_set_lines(bufnr('%') , 0, -1, 0, readfile(s:tmpfile))

  " open if not empty
  if len(getqflist()) == 0
    echo "No Issues"
  else
    let s:winnr = winnr()
    copen
    if winnr() != s:winnr
      wincmd p
    endif
  endif

endfunction



