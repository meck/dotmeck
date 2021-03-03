" vim: set foldmarker={{{,}}} foldmethod=marker foldlevel=1 :
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc                                                                {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Encoding of this script
scriptencoding utf-8

" Load plugins
lua require'plugins'



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Settings                                                            {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set termguicolors                       " 24-bit colors in term
set clipboard^=unnamed,unnamedplus      " Use MacOs / Linux clipboard
filetype plugin indent on               " Enabling filetype support provides filetype-specific indenting, syntax
set omnifunc=syntaxcomplete#Complete    " Basic completion
syntax on                               " Highlighting, omni-completion and other useful settings.
set showcmd                             " Show command
set noshowmode                          " Mode is shown in airline
set mouse=a                             " Enable mouse
set history=1000                        " Command history
set visualbell                          " Don't beep
set noerrorbells
set notimeout ttimeout ttimeoutlen=0    " Quickly time out on keycodes, but never time out on mappings
set backspace=indent,eol,start          " Proper backspace behavior
set listchars=trail:\·,eol:\¬,tab:\▸\   " Invisibles
set laststatus=2                        " Always show statusline
set nolist                              " Start without list symbols
set autoread                            " Read when a file is changed from the outside
set hidden                              " Allow hidden buffers
set exrc                                " Source .nvimrc or .vimrc in current directory
set secure                              " Limit autocmds and shell cmds from above
set foldlevelstart=99                   " Open new files with no folds closed
set updatetime=300                      " For quicker diagnostics
set shortmess+=c                        " Don't show the number of matches

" Scrolling
set scrolloff=4                         " Start scrolling before we hit the edges
set sidescrolloff=5

" Indenting
set smartindent                         " Smart indent
set autoindent                          " Auto indent
set expandtab
set softtabstop=2                       " Use spaces for tabs
set shiftwidth=2
set smarttab

" Line breaks
set wrap                                " Wrap lines
set textwidth=0                         " Set per file type
set linebreak                           " Line break smartly

" Completion
set completeopt=menuone,noselect

" Command line completion
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git
set wildmode=longest,list,full
set wildmenu

" Searching
set incsearch
set smartcase
set ignorecase

" Line numbers
set numberwidth=5
set relativenumber
set number

" Live substitution
set inccommand=split



" Persistent Undo
if has('persistent_undo')
  " Create the undo directory if it dosent exsist
  let s:myUndoDir = expand(stdpath('data') . '/undodir')
  call system('mkdir -p ' . s:myUndoDir)
  " Set the directory
  let &undodir = s:myUndoDir
  set undofile
endif



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Auto groups                                                         {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Automatically switch line numbers
augroup relativize
  autocmd!
  autocmd BufWinEnter,FocusGained,InsertLeave,WinEnter * call Relativize(1)
  autocmd BufWinLeave,FocusLost,InsertEnter,WinLeave * call Relativize(0)
augroup END



" Quick fix window
augroup quickfix
    autocmd!
    autocmd FileType qf setlocal wrap
            \| setlocal norelativenumber
            \| setlocal numberwidth=2
augroup END



" Terminal
augroup nvim_term
  autocmd!

  " Always enter terminal in insert mode
  autocmd BufWinEnter,WinEnter,TermOpen term://* startinsert
  autocmd BufLeave term://* stopinsert

  " No line numbers in terminals
  autocmd TermOpen * setlocal nonumber norelativenumber
augroup END



" Reload config after write
augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
augroup END



" Highlight selection after yanking
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent!
          \ lua vim.highlight.on_yank {higroup="IncSearch", timeout=350}
augroup END



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Functions                                                           {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Delete buffer if it is only open in a single window,
" otherwise close the window
function! CloseWindowOrKillBuffer()
  let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))
  if number_of_windows_to_this_buffer > 1
    wincmd c
  else
    bdelete
  endif
endfunction


" Change Line Numbers
function! Relativize(v)
  if &number
    let &relativenumber = a:v
  endif
endfunction


" Toggle to swedish keymap
" and spelling
function! SweMap()
  if (&keymap !=# '')
    set keymap=""
    set spelllang=en_us
  else
    set keymap=swe-us
    set spelllang=sv
  endif
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Commands                                                            {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Delete all but the current buffer
command! Bonly silent! execute "%bd|e#|bd#"



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Plug-in Settings                                                    {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Vim Obsession
augroup obsssions_autoload
  autocmd!
  autocmd VimEnter * nested
            \ if !argc() && empty(v:this_session) && filereadable('Session.vim') |
            \   source Session.vim |
            \ endif
augroup END

" Better Whitespace
let g:show_spaces_that_precede_tabs=1
hi! link ExtraWhitespace Error

" Quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']


" Signify
let g:signify_sign_add               = '∙'
let g:signify_sign_delete            = '∙'
let g:signify_sign_delete_first_line = '∙'
let g:signify_sign_change            = '∙'
let g:signify_priority               = 5


" Pandoc
let g:pandoc#formatting#mode = 'hA'
let g:pandoc#spell#enabled = 0
let g:pandoc#spell#default_langs = ['en','sv']
let g:pandoc#hypertext#create_if_no_alternates_exists = 1
let g:pandoc#hypertext#autosave_on_edit_open_link = 1
let g:pandoc#after#modules#enabled = ['tablemode', 'ultisnips']


" Pandoc syntax, no haskell
"https://github.com/vim-pandoc/vim-pandoc-syntax/issues/344#issuecomment-761563470
let g:pandoc#syntax#codeblocks#embeds#langs = ['bash=sh', 'vhdl']


" Tablemode
" Pandoc complatible layout
let g:table_mode_corner ='+'
let g:table_mode_corner_corner='+'
let g:table_mode_header_fillchar='-'


" Theme
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_uniform_diff_background = 1
let g:nord_underline = 1
" https://github.com/arcticicestudio/nord-vim/issues/211
au Colorscheme * hi! link Conceal Number
colorscheme nord



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Built in mappings                                                   {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Space as leader works with showcmd
let g:mapleader = "\<Space>"
let g:maplocalleader = "\\"

" Move across wrapped lines like regular lines
noremap 0 ^
noremap ^ 0

" Clear search highlight with esc
nnoremap <silent><esc> :noh<return><esc>

" Window close window
nnoremap <silent> Q :call CloseWindowOrKillBuffer()<cr>

" Reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" Echo new fold levels
nnoremap zr zr:echo 'Foldlevel = ' . &foldlevel<cr>
nnoremap zm zm:echo 'Foldlevel = ' . &foldlevel<cr>
nnoremap zR zR:echo 'Foldlevel = ' . &foldlevel<cr>
nnoremap zM zM:echo 'Foldlevel = ' . &foldlevel<cr>

" make Y consistent with C and D. See :help Y.
nnoremap Y y$

" w!! expands to a sudo save
cmap w!! w !sudo tee >/dev/null %

" Edit vimrc with F1 and source it automatically when saved
nmap <silent><f1> :e $MYVIMRC<CR>

" Clean trailing whitespaces
noremap <silent> <Leader>wc :StripWhitespace<CR>

" Use custom swedish keymap
nnoremap <silent> <Leader>s :call SweMap()<CR>

nnoremap <silent> Q :call CloseWindowOrKillBuffer()<CR>

" Terminal spawning
nnoremap <silent> <Leader>te :belowright split +resize\ 13 \| setlocal winfixheight \| terminal <CR>
nnoremap <silent> <Leader>vte :belowright vsplit \| terminal <CR>

" Navigate windows
nnoremap <C-h> <C-\><C-n><C-w>h
nnoremap <C-j> <C-\><C-n><C-w>j
nnoremap <C-k> <C-\><C-n><C-w>k
nnoremap <C-l> <C-\><C-n><C-w>l
inoremap <C-h> <C-\><C-n><C-w>h
inoremap <C-j> <C-\><C-n><C-w>j
inoremap <C-k> <C-\><C-n><C-w>k
inoremap <C-l> <C-\><C-n><C-w>l

" Navigate terminal window
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
tnoremap <Esc> <C-\><C-n>

" Tab Navigation hjkl
nnoremap <Leader>tk  :tabfirst<CR>
nnoremap <Leader>tl  :tabnext<CR>
nnoremap <Leader>th  :tabprev<CR>
nnoremap <Leader>tj  :tablast<CR>
nnoremap <Leader>tt  :tabedit<Space>
nnoremap <Leader>tm  :tabm<Space>
nnoremap <Leader>td  :tabclose<CR>



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Plugin mapping, functions and autocmds                              {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Gitgutter
nmap <silent> ]g :GitGutterNextHunk <CR>
nmap <silent> [g :GitGutterPrevHunk <CR>


" UndoTree
nnoremap <silent><Leader>u :UndotreeToggle<CR>


" TODO Tempory fix, see:
" http://github.com/vim/vim/issues/4738
" `0` argument sets file to local
nnoremap <silent>gx :call netrw#BrowseX(netrw#GX(),0)<cr>



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Lua                                                                 {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Lua General Settings
lua require'settings'

" LSP
lua require'lsp'
