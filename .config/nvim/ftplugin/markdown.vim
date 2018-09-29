silent! call airline#extensions#whitespace#disable()

" JamshedVesuna/vim-markdown-preview"
" Run with <C-p>

let vim_markdown_preview_toggle=2

if executable('grip')
  let vim_markdown_preview_github=1
endif 

