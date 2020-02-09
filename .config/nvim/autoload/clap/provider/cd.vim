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

function! s:cd.on_enter() abort
  call clap#spinner#set('foo')
endfunction

" if exists("g:ClapPrompt")
"   let s:prevClapPrompt = funcref("g:ClapPrompt")
" endif

" function! ClapFormat() abort
"   if g:clap.provider.id ==# 'cd'
"     if exists('g:__clap_provider_cwd')
"       let cwd = g:__clap_provider_cwd
"     else
"       let cwd = getcwd()
"     endif
"     return '%spinner% '. pathshorten(fnamemodify(expand(cwd), ':~:s?/$??')) . ' '
"   elseif exists("s:prevClapPromt")
"     call s:prevClapPrompt()
"   else
"     if exists("g:clap_prompt_format")
"       return g:clap.prompt_format
"     else
"       return ' %spinner%%forerunner_status%%provider_id%:'
"     endif
"   endif
" endfunction

" let g:ClapPrompt = function('ClapFormat')

function! s:cd.source() abort
  let dir = getcwd()
  if !empty(g:clap.provider.args)
    let dir = g:clap.provider.args[-1]
    if isdirectory(expand(dir))
      let g:__clap_provider_cwd = dir
      let g:clap.provider.args = g:clap.provider.args[:-2]
    endif
  endif

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
