" Author: meck <johan@meck.se>
" Description: Change Vim Current directory

let s:save_cpo = &cpoptions
set cpoptions&vim

let s:cd = {}

let s:default_opts = {
      \ 'fd': '--follow --type d',
      \ 'find': '. -type d',
      \ }

let s:default_finder = v:null

for exe in ['fd', 'find']
  if executable(exe)
    let s:default_finder = exe
    break
  endif
endfor

if s:default_finder is v:null
  let s:default_source = ['No usable tools found for the cd provider']
else
  let s:default_source = join([s:default_finder, s:default_opts[s:default_finder]], ' ')
endif

function! s:cd.source() abort
  let dir = getcwd()
  if !empty(g:clap.provider.args)
    let dir = g:clap.provider.args[-1]
    if isdirectory(expand(dir))
      let g:__clap_provider_cwd = dir
      let g:clap.provider.args = g:clap.provider.args[:-2]
    endif
  endif
  " TODO show current starting path
  " echomsg pathshorten(fnamemodify(expand(dir), ':~'))

  if has_key(g:clap.context, 'finder')
    let finder = g:clap.context.finder
    return finder.' '.join(g:clap.provider.args, ' ')
  elseif g:clap.provider.args == ['--hidden']
    if s:default_finder ==# 'fd'
      return join([s:default_finder, s:default_opts[s:default_finder], '--hidden'], ' ')
    else
      return s:default_source
    endif
  else
    return s:default_source
  endif
endfunction

let s:cd.sink = 'cd'

let s:cd.enable_rooter = v:true

let g:clap#provider#cd# = s:cd

let &cpoptions = s:save_cpo
unlet s:save_cpo
