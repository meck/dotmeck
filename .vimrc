"Misc {{{
"""""""""""

" Encoding of this script
scriptencoding utf-8

" }}}
"  Built in settings {{{
""""""""""""""""""""""""
set clipboard^=unnamed,unnamedplus      " Use MacOs / Linux clipboard
language en_US.UTF-8                    " Not MacOS Lang
filetype plugin indent on               " Enabling filetype support provides filetype-specific indenting, syntax
set omnifunc=syntaxcomplete#Complete    " Basic Compleation
syntax on                               " highlighting, omni-completion and other useful settings.
set showcmd                             " Show command
set mouse=a                             " Dont select line numbers with mouse
set history=1000                        " Command history
set visualbell                          " Dont beep
set noerrorbells
set notimeout ttimeout ttimeoutlen=0    " Quickly time out on keycodes, but never time out on mappings
set backspace=indent,eol,start          " Proper backspace behavior
set listchars=trail:\·,eol:\¬,tab:\▸\   " Invisibles
set laststatus=2                        " Always show statusline
set nolist                              " Start without list symbols
set autoread                            " Read when a file is changed from the outside
set hidden                              " Allow hidden buffers
set secure                              " Limit autocmds and shell cmds from above
set foldlevelstart=99                   " Open new files with no folds closed

" Scrolling
set scrolloff=4                         " Start scrolling before we hit the buffer
set sidescrolloff=5

" Indenting
set smartindent                         " Smart indent
set autoindent                          " Auto indent
set expandtab
set softtabstop=2
set shiftwidth=2
set smarttab

" Linebreaks
set wrap                                " Wrap lines
set textwidth=500                       " Textwidth
set linebreak                           " Linebreak

set shortmess+=c                        " Dont show the number of matches

" Completion
set completeopt=menuone,longest,preview

" Command line completion
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
set wildmode=longest,list,full
set wildmenu

" Searching
set incsearch
set smartcase
set ignorecase
set nohlsearch

" Line numbers
set numberwidth=5
set relativenumber
set number

" Colorscheme
colorscheme desert

"Automatically switch line numbers
augroup relativize
  autocmd!
  autocmd BufWinEnter,FocusGained,InsertLeave,WinEnter * call Relativize(1)
  autocmd BufWinLeave,FocusLost,InsertEnter,WinLeave * call Relativize(0)
augroup END

" quickfix
augroup quickfix
    autocmd!
    autocmd FileType qf setlocal wrap
            \| setlocal norelativenumber
            \| setlocal numberwidth=2
augroup END

" netrw
let g:netrw_banner = 0

"}}}
"  Functions {{{
""""""""""""""""

" Switch line numbers
function! Relativize(v)
  if &number
    let &relativenumber = a:v
  endif
endfunction

" Whitespace removal
fun! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
    echo 'Stripped any trailing whitespaccs'
endfun

"}}}
"  Mappings {{{
""""""""""""""

" Navigate windows
noremap <silent> <C-h> :wincmd h<CR>
noremap <silent> <C-j> :wincmd j<CR>
noremap <silent> <C-k> :wincmd k<CR>
noremap <silent> <C-l> :wincmd l<CR>
inoremap <silent> <C-h> <ESC>:wincmd h<CR>
inoremap <silent> <C-j> <ESC>:wincmd j<CR>
inoremap <silent> <C-k> <ESC>:wincmd k<CR>
inoremap <silent> <C-l> <ESC>:wincmd l<CR>

" Space as leader works with showcmd
let g:mapleader = "\<Space>"

" Move across wrapped lines like regular lines
noremap 0 ^
noremap ^ 0

" w!! expands to a sudo save
cmap w!! w !sudo tee >/dev/null %

" Netrw explorer enter/return
nnoremap <Leader>e :Lexplore<CR>

" Navigate popup menu with tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Edit vimrc with f5 and source it automatically when saved
nmap <silent> <leader><f5> :e $MYVIMRC<CR>
augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
augroup END

" Tab Navigation hjkl
nnoremap <Leader>tk  :tabfirst<CR>
nnoremap <Leader>tl  :tabnext<CR>
nnoremap <Leader>th  :tabprev<CR>
nnoremap <Leader>tj  :tablast<CR>
nnoremap <Leader>tt  :tabedit<Space>
nnoremap <Leader>tm  :tabm<Space>
nnoremap <Leader>td  :tabclose<CR>

" Whitespace Clean
noremap <silent> <Leader>wc :call TrimWhitespace()<CR>

"}}}
