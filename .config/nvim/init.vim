scriptencoding utf-8                             " Encoding of this script

" A variable to use in diffrent places in this file
if has('nvim')
  let s:vimDir = '$HOME/.config/nvim'
else
  let s:vimDir = '$HOME/.vim'
endif

""""""""""""""""""""""
"  Built in settings  "
"""""""""""""""""""""""
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

" Persistent Undo
if has('persistent_undo')
  " Create the undo directory if it dosent exsist
  let s:myUndoDir = expand(s:vimDir . '/undodir')
  call system('mkdir -p ' . s:myUndoDir)
  " Set the directory
  let &undodir = s:myUndoDir
  set undofile
endif


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

  " Enable Truecolor
  set termguicolors

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

" Space as leader works with showcmd
map <Space> <Leader>


"""""""""""""
"  Plugins  "
"""""""""""""

" Automatically install the plugin manager
augroup plug_auto_install
  autocmd!
augroup END

if empty(glob(expand(s:vimDir . '/autoload/plug.vim')))
  execute('silent !curl -fLo ' . s:vimDir . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  autocmd plug_auto_install VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Start the plugin manager
call plug#begin(expand(s:vimDir . '/plugged'))

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
augroup obsssions_autoload
  autocmd!
  autocmd VimEnter * nested
            \ if !argc() && empty(v:this_session) && filereadable('Session.vim') |
            \   source Session.vim |
            \ endif
augroup END

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
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Displays function signatures from completions in the command line.
Plug 'Shougo/echodoc.vim'

" Tagbar
Plug 'majutsushi/tagbar'

" UndoTree
Plug 'mbbill/undotree'

" Snippets Manager and default Snippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
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
Plug 'alx741/vim-stylishask', { 'for': 'haskell' }
Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }
Plug 'meck/vim-brittany', { 'for': 'haskell' }

" Arduino
Plug 'sudar/vim-arduino-syntax'
Plug 'meck/ale-platformio'

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

" Expand snippets
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" Load other snippets
let g:neosnippet#enable_snipmate_compatibility = 1

" For conceal markers in snippets
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Traverse the popup menu with Tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" GitGutter
let g:gitgutter_sign_added = '∙'
let g:gitgutter_sign_modified = '∙'
let g:gitgutter_sign_removed = '∙'
let g:gitgutter_sign_modified_removed = '∙'

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

" Close quickfix when done
augroup comp_qlist_autoclose
  autocmd!
  autocmd CompleteDone * silent! pclose!
augroup END

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

" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
if executable('rg')
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
endif

" Theme
let g:nord_comment_brightness = 10
" let g:nord_uniform_status_lines = 1
let g:nord_italic_comments = 1
let g:nord_uniform_diff_background = 1
colorscheme nord

"""""""""""""""
"  Functions  "
"""""""""""""""

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


""""""""""""""
"  Mappings  "
""""""""""""""

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
