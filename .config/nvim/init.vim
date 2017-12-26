" Misc {{{
"""""""""""

" Encoding of this script
scriptencoding utf-8

" A variable to use in diffrent places in this file
if has('nvim')
  let s:vimDir = '$HOME/.config/nvim'
else
  let s:vimDir = '$HOME/.vim'
endif


" }}}
"  Plugins {{{
"
""""""""""""""

" Automatically install the plugin manager if not installed
augroup plug_auto_install
  autocmd!
  if empty(glob(expand(s:vimDir . '/autoload/plug.vim')))
    execute('silent !curl -fLo ' . s:vimDir . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    autocmd plug_auto_install VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
augroup END

" Start the plugin manager
call plug#begin(expand(s:vimDir . '/plugged'))

" Smart stuff
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-obsession'

" Git Stuff
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'airblade/vim-gitgutter'

" Surround editing and objects
Plug 'machakann/vim-sandwich'

" Aligning stuff
Plug 'godlygeek/tabular'

" fuzzy all the things
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'

" Statusline and theme
Plug 'vim-airline/vim-airline'
Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }

" ALE Linter
if has('timers') && exists('*job_start') && exists('*ch_close_in') || has('nvim')
  Plug 'w0rp/ale'
endif

" Completion engine
Plug 'roxma/nvim-completion-manager'
" Needed for Completion in vim
if !has('nvim')
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Language server client
Plug 'autozimu/LanguageClient-neovim', {'tag': 'binary-*-x86_64-apple-darwin' }

" Adds seamless navigation between tmux and vim
Plug 'christoomey/vim-tmux-navigator'

" Snippets Manager and default Snippets
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Tagbar
Plug 'majutsushi/tagbar'

" UndoTree
Plug 'mbbill/undotree'

" Dash for macOS
Plug 'rizzatti/dash.vim'

"}}}
"  Language Specific Plugins {{{
""""""""""""""""""""""""""""""""

" Haskell
if has('nvim')
  Plug 'parsonsmatt/intero-neovim', { 'for': 'haskell' }
endif
Plug 'neovimhaskell/haskell-vim'
" Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }
Plug 'meck/vim-brittany', { 'for': 'haskell' }
Plug 'alx741/vim-hindent', { 'for': 'haskell' }
Plug 'alx741/vim-stylishask', { 'for': 'haskell' }

" Markdown
Plug 'plasticboy/vim-markdown'

" Python
Plug 'zchee/deoplete-jedi' , { 'for': 'python' }
Plug 'jmcantrell/vim-virtualenv' , { 'for': 'python' }

" Go
Plug 'fatih/vim-go' , { 'for': 'go' }
Plug 'zchee/deoplete-go', { 'for': 'go', 'do': 'make'}

" Rust
Plug 'rust-lang/rust.vim' , { 'for': 'rust' }
Plug 'sebastianmarkow/deoplete-rust', { 'for': 'rust' }

call plug#end()

"}}}
"  Built in settings {{{
""""""""""""""""""""""""
set t_Co=256                                     " Yhea colors for everyone
set clipboard^=unnamed,unnamedplus               " Use MacOs / Linux clipboard
language en_US.UTF-8                             " Not MacOS Lang
filetype plugin indent on                        " Enabling filetype support provides filetype-specific indenting, syntax
set omnifunc=syntaxcomplete#Complete             " Basic Compleation
syntax on                                        " highlighting, omni-completion and other useful settings.
set showcmd                                      " Show command
set noshowmode                                   " mode is shown in airline
set mouse=a                                      " Dont select line numbers with mouse
set history=1000                                 " Command history
set visualbell                                   " Dont beep
set noerrorbells
set notimeout ttimeout ttimeoutlen=0             " Quickly time out on keycodes, but never time out on mappings
set backspace=indent,eol,start                   " Proper backspace behavior
set listchars=space:\·,eol:\¬,tab:\→\·           " Invisibles
set laststatus=2                                 " Always show statusline
set nolist                                       " Start without list symbols
set expandtab
set hidden                                       " Allow hidden buffers

" Indenting
set autoindent                                   " Auto indent
set smartindent                                  " Smart indent
set wrap                                         " Wrap lines
set textwidth=500                                " Textwidth
set linebreak                                    " Linebreak

" Scrolling
set scrolloff=4                                  " Start scrolling before we hit the buffer
set sidescrolloff=5
set softtabstop=2
set shiftwidth=2

set shortmess+=c                                 " Dont show the number of matches

" Persistent Undo
if has('persistent_undo')
  " Create the undo directory if it dosent exsist
  let s:myUndoDir = expand(s:vimDir . '/undodir')
  call system('mkdir -p ' . s:myUndoDir)
  " Set the directory
  let &undodir = s:myUndoDir
  set undofile
endif

" Completion
set completeopt=menuone,longest,preview,noselect

" Command line completion
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
set wildmode=longest,list,full
set wildmenu

" Searching
set incsearch
set smartcase
set ignorecase
set smarttab

" Line numbers
set numberwidth=5
set relativenumber
set number

"Automatically switch line numbers
augroup relativize
  autocmd!
  autocmd BufWinEnter,FocusGained,InsertLeave,WinEnter * call Relativize(1)
  autocmd BufWinLeave,FocusLost,InsertEnter,WinLeave * call Relativize(0)
augroup END

" netrw
let g:netrw_banner = 0

" Neovim Stuff
if has('nvim')

  "Navigate terminal window
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l
  tnoremap <Esc> <C-\><C-n>

  augroup nvim_term
    autocmd!

    " Always enter terminal in insert mode
    autocmd BufWinEnter,WinEnter,TermOpen term://* startinsert
    autocmd BufLeave term://* stopinsert

    " no linenumbers in terminals
    autocmd TermOpen * setlocal nonumber norelativenumber
  augroup END

  " Live substitution
  set inccommand=split
endif

" Traverse the popup menu with Tab
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Space as leader works with showcmd
map <Space> <Leader>

"}}}
"  Plugin Settings {{{
""""""""""""""""""""""


" Vim Obsession
augroup obsssions_autoload
  autocmd!
  autocmd VimEnter * nested
            \ if !argc() && empty(v:this_session) && filereadable('Session.vim') |
            \   source Session.vim |
            \ endif
augroup END


" Ale
if has_key(g:plugs, 'ale')
  let g:ale_echo_msg_error_str = 'E'
  let g:ale_echo_msg_warning_str = 'W'
  let g:ale_echo_msg_format = '[%linter%][%severity%] %s'
  let g:ale_lint_on_save = 1
  let g:ale_statusline_format = ['%d error(s)', '%d warning(s)', '']

  let g:ale_sign_warning = '▲'
  let g:ale_sign_error = 'X'
  let g:ale_sign_column_always = 1
endif


" GitGutter
let g:gitgutter_sign_added = '∙'
let g:gitgutter_sign_modified = '∙'
let g:gitgutter_sign_removed = '∙'
let g:gitgutter_sign_modified_removed = '∙'


"Snuppets

" Navigate popup menu with tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Expand snippets with enter in completion menu
imap <expr> <CR>  (pumvisible() ?  "\<c-y>\<Plug>(expand_or_nl)" : "\<CR>")
imap <expr> <Plug>(expand_or_nl) (cm#completed_is_snippet() ? "\<plug>(ultisnips_expand)":"\<CR>")
let g:UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'

" Navigate snippets
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:UltiSnipsRemoveSelectModeMappings = 0


" Language server client
let g:LanguageClient_serverCommands = {
    \ 'haskell': ['hie', '--lsp', ],
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ }

let g:LanguageClient_diagnosticsDisplay = {
    \    1: {
    \      'name': 'Error',
    \      'texthl': 'ALEError',
    \      'signText': 'X',
    \      'signTexthl': 'ALEErrorSign',
    \    },
    \    2: {
    \      'name': 'Warning',
    \      'texthl': 'ALEWarning',
    \      'signText': '▲',
    \      'signTexthl': 'ALEWarningSign',
    \    },
    \    3: {
    \      'name': 'Information',
    \      'texthl': 'ALEInfo',
    \      'signText': 'ⓘ',
    \      'signTexthl': 'ALEWarningSign',
    \    },
    \    4: {
    \      'name': 'Hint',
    \      'texthl': 'ALEInfo',
    \      'signText': '▶',
    \      'signTexthl': 'ALEInfoSign',
    \    },
    \ }


" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#hunks#enabled=0
let g:airline_section_z = '%3p%% %4l:%-2c'
let g:airline_skip_empty_sections = 1
let g:airline#extensions#obsession#enabled = 1
let g:airline#extensions#obsession#indicator_text = '$'

" Fzf-vim plugin
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

if has('nvim')
  aug fzf_setup
    autocmd!
    " Changes the remapping of escape for fzf windows to be able to close
    autocmd TermOpen term://*FZF tnoremap <silent> <buffer><nowait> <esc> <c-c>

    " Hide the bar at bottom of fzf windows
    autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0
      \| autocmd BufLeave <buffer> set laststatus=2
  aug END
end

" Use Ripgrep for Fzf
if executable('rg')
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
endif

" Theme
let g:nord_comment_brightness = 10
let g:nord_italic_comments = 1
let g:nord_uniform_diff_background = 1
colorscheme nord

" Dash dont foreground
let g:dash_activate=0

"}}}
"  Functions {{{
""""""""""""""""

"Switch line numbers
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
endfun

" Toggles shows or hides the nonempty lists
" and turns on Ales auto open
fun! ToggleAleAutoList()
  let l:winnr = winnr()
  if g:ale_open_list
    let g:ale_open_list = 0
    cclose
    lclose
  else
    if len(getqflist()) != 0
      copen
      stopinsert
    endif
    if len(getloclist(0)) != 0
      lopen
    endif
    let g:ale_open_list = 1
  endif
  if l:winnr !=# winnr()
      wincmd p
  endif
endfun

"}}}
"  Mappings {{{
""""""""""""""

" Language Client

" Show type info (and short doc) of identifier under cursor.
nnoremap <silent> <Leader>lh :call LanguageClient_textDocument_hover()<CR>
" Goto definition of identifier under cursor.
nnoremap <silent> <Leader>ld :call LanguageClient_textDocument_definition()<CR>
" Rename identifier under cursor.
nnoremap <silent> <Leader>lr :call LanguageClient_textDocument_rename()<CR>
" Format current document.
nnoremap <silent> <Leader>lf :call LanguageClient_textDocument_formatting()<CR>
" Format selected lines.
vnoremap <silent> <Leader>lf :call LanguageClient_textDocument_rangeFormatting()<CR>
" List of current buffer's symbols.
nnoremap <silent> <Leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
" List of project's symbols.
nnoremap <silent> <Leader>lS :call LanguageClient_workspace_symbol()<CR>
" List all references of identifier under cursor.
nnoremap <silent> <Leader>ll :call LanguageClient_textDocument_references()<CR>
" Show code action
nnoremap <silent> <Leader>la :call LanguageClient_textDocument_codeAction()<CR>

" Clear search hightligh
nnoremap <silent><esc> :noh<return><esc>

" Toggle the autoopening of lists
nnoremap <silent><Leader>q :call ToggleAleAutoList()<CR>

" Netrw explorer enter/return
nnoremap <Leader>e :Lexplore<CR>

" Tagbar
nnoremap <Leader>tb :TagbarToggle <CR>

" Change buffer
nnoremap <Leader>b :ls<CR>:b<Space>

" UndoTree
nnoremap <silent><Leader>u :UndotreeToggle<CR>

" FZF
" Search for files
nnoremap <Leader>zf :Files<CR>
" Search buffers
nnoremap <Leader>zb :Buffers<CR>

" w!! expands to a sudo save
cmap w!! w !sudo tee >/dev/null %

" Terminals
nnoremap <silent> <Leader>te :belowright split +resize\ 20 \| terminal <CR>
nnoremap <silent> <Leader>vte :belowright vsplit \| terminal <CR>

" Whitespace Clean
noremap <silent> <Leader>ws :call TrimWhitespace()<CR>

" Tab Navigation hjkl
nnoremap <Leader>tk  :tabfirst<CR>
nnoremap <Leader>tl  :tabnext<CR>
nnoremap <Leader>th  :tabprev<CR>
nnoremap <Leader>tj  :tablast<CR>
nnoremap <Leader>tt  :tabedit<Space>
nnoremap <Leader>tm  :tabm<Space>
nnoremap <Leader>td  :tabclose<CR>

"Dash search
nmap <silent> <leader>d <Plug>DashSearch
nmap <silent> <leader>D <Plug>DashGlobalSearch

" }}}
