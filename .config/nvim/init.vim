""""""""""""""""""""""
"  Built in settings  "
"""""""""""""""""""""""
scriptencoding utf-8                             " Encoding of this script
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
set notimeout ttimeout ttimeoutlen=200           " Quickly time out on keycodes, but never time out on mappings
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


set completeopt=menuone,longest,preview,noselect " Completion

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

  " Always enter terminal in insert mode
  autocmd BufWinEnter,WinEnter term://* startinsert

  " Live substitution
  set inccommand=split
endif

" Space as leader works with showcmd
map <Space> <Leader>


"""""""""""""
"  Plugins  "
"""""""""""""

" Start the plugin manager
call plug#begin('~/.vim/plugged')

" Adds seamless navigation between tmux and vim
"<ctrl-h> => Left
"<ctrl-j> => Down
"<ctrl-k> => Up
"<ctrl-l> => Right
"<ctrl-\> => Previous split
Plug 'christoomey/vim-tmux-navigator'

" fuzzy all the things
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Smart stuff
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'

" Automanagment of sessions
Plug 'tpope/vim-obsession'
" Autoload any session in the current directory if we start without arguments
autocmd VimEnter * nested
          \ if !argc() && empty(v:this_session) && filereadable('Session.vim') |
          \   source Session.vim |
          \ endif

" Statusline
Plug 'vim-airline/vim-airline'

" Best theme
Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }

" Asynchronous Lint Engine
if has('timers') && exists('*job_start') && exists('*ch_close_in') || has('nvim')
  Plug 'w0rp/ale'
endif

Plug 'Shougo/vimproc.vim', {'do' : 'make'}

Plug 'godlygeek/tabular'

" Completion engine
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif

" Displays function signatures from completions in the command line.
Plug 'Shougo/echodoc.vim'

" Tab-complete
Plug 'ervandew/supertab'

" Tagbar
Plug 'majutsushi/tagbar'

" Snippets Manager and default Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Vim Git runtime files
Plug 'tpope/vim-git'

" Git wrapper
Plug 'tpope/vim-fugitive'

" Shows git status in the gutter
Plug 'airblade/vim-gitgutter'


"""""""""""""""""""""""""""""""
"  Language Specific Plugins  "
"""""""""""""""""""""""""""""""

" Haskell
if has('nvim')
  Plug 'parsonsmatt/intero-neovim', { 'for': 'haskell' }
endif

"Syntax
Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
Plug 'alx741/vim-hindent', { 'for': 'haskell' }
Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }

" Arduino
Plug 'sudar/vim-arduino-syntax'
Plug 'meck/ale-platformio'

" Markdown
Plug 'plasticboy/vim-markdown'
Plug 'JamshedVesuna/vim-markdown-preview', { 'for' : 'markdown' }

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


"""""""""""""""""""""
"  Plugin Settings  "
"""""""""""""""""""""

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

" UltiSnips
let g:UltiSnipsExpandTrigger='<C-s>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'


" SuperTab
let g:SuperTabDefaultCompletionType = '<c-x><c-o>'
let g:SuperTabLongestEnhanced=1
let g:SuperTabLongestHighlight=1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" GitGutter
let g:gitgutter_sign_added = '∙'
let g:gitgutter_sign_modified = '∙'
let g:gitgutter_sign_removed = '∙'
let g:gitgutter_sign_modified_removed = '∙'

if has('nvim')
    " Deoplete
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#ignore_sources = {}
  let g:deoplete#ignore_sources._ = ['buffer', 'member', 'tag']
  let g:deoplete#max_list = 30

  " Disable comments as source
  call deoplete#custom#source('_',
  \ 'disabled_syntaxes', ['Comment', 'String'])

  " Use auto delimiter feature
  call deoplete#custom#source('_', 'converters',
  \ ['converter_auto_delimiter', 'remove_overlap'])

  " Move completions from around in the current buffer lower
  call deoplete#custom#source('around', 'rank', 100)
endif

" Close quickfix when done
autocmd CompleteDone * silent! pclose!

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#hunks#enabled=0
let g:airline_section_z = '%{airline#util#wrap(airline#extensions#obsession#get_status(),0)}%3p%% %4l:%-2c'
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

" Theme
colorscheme nord

if has('gui_vimr')
  let s:nord0_gui = '#2e3440'
  let s:nord1_gui = '#3b4252'
  let s:nord2_gui = '#434c5e'
  let s:nord3_gui = '#4c566a'
  let s:nord4_gui = '#d8dee9'
  let s:nord5_gui = '#e5e9f0'
  let s:nord6_gui = '#eceff4'
  let s:nord7_gui = '#8fbcbb'
  let s:nord8_gui = '#88c0d0'
  let s:nord9_gui = '#81a1c1'
  let s:nord10_gui = '#5e81ac'
  let s:nord11_gui = '#bf616a'
  let s:nord12_gui = '#d08770'
  let s:nord13_gui = '#ebcb8b'
  let s:nord14_gui = '#a3be8c'
  let s:nord15_gui = '#b48ead'

  let g:terminal_color_0 = s:nord1_gui
  let g:terminal_color_1 = s:nord11_gui
  let g:terminal_color_2 = s:nord14_gui
  let g:terminal_color_3 = s:nord13_gui
  let g:terminal_color_4 = s:nord9_gui
  let g:terminal_color_5 = s:nord15_gui
  let g:terminal_color_6 = s:nord8_gui
  let g:terminal_color_7 = s:nord5_gui
  let g:terminal_color_8 = s:nord3_gui
  let g:terminal_color_9 = s:nord11_gui
  let g:terminal_color_10 = s:nord14_gui
  let g:terminal_color_11 = s:nord13_gui
  let g:terminal_color_12 = s:nord9_gui
  let g:terminal_color_13 = s:nord15_gui
  let g:terminal_color_14 = s:nord7_gui
  let g:terminal_color_15 = s:nord6_gui
endif

""""""""""""""
"  Mappings  "
""""""""""""""

" Clear search hightligh
nnoremap <silent><esc> :noh<return><esc>

" Netrw explorer enter/return
nnoremap <Leader>e :Rexplore<CR>

" Tagbar
nnoremap <Leader>tb :TagbarToggle <CR>

" Change buffer
nnoremap <Leader>b :ls<CR>:b<Space>

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

" Whitespace removal
fun! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfun

command! TrimWhitespace call TrimWhitespace()
noremap <Leader>ws :call TrimWhitespace()<CR>

" Tab Navigation hjkl
nnoremap tk  :tabfirst<CR>
nnoremap tl  :tabnext<CR>
nnoremap th  :tabprev<CR>
nnoremap tj  :tablast<CR>
nnoremap tt  :tabedit<Space>
nnoremap tm  :tabm<Space>
nnoremap td  :tabclose<CR>

" Platformio
nnoremap <silent> <Leader>pir :belowright split +resize\ 20 \| terminal platformio run<CR>
nnoremap <silent> <Leader>piu :belowright split +resize\ 20 \| terminal platformio run --target upload<CR>
nnoremap <silent> <Leader>pic :belowright split +resize\ 20 \| terminal platformio run --target clean<CR>
nnoremap <silent> <Leader>pid :belowright split +resize\ 20 \| terminal platformio update<CR>
nnoremap <silent> <Leader>pim :belowright split +resize\ 20 \| terminal platformio device monitor<CR>
