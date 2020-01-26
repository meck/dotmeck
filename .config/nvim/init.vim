" Misc {{{
"""""""""""

" Encoding of this script
scriptencoding utf-8

let s:vimDir = '$XDG_CONFIG_HOME/nvim'

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
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-scriptease'

" Git Stuff
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'airblade/vim-gitgutter'

" Gist
Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim'

" Preview targets for f/F/t/T
Plug 'unblevable/quick-scope'

" Surround editing and objects
Plug 'machakann/vim-sandwich'

" Aligning stuff
Plug 'godlygeek/tabular'

" Better quickfix window
Plug 'romainl/vim-qf'

" Interactive selection, build rust extension if cargo is installed
Plug 'liuchengxu/vim-clap', { 'do': function('clap#helper#build_all') }

" Statusline and theme
Plug 'vim-airline/vim-airline'

" Themes
Plug 'meck/nord-vim', { 'branch': 'develop' }
" Waiting for PR
" Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }
Plug 'gruvbox-community/gruvbox'

" Languge Files
Plug 'sheerun/vim-polyglot'

" Language server client
" Special instaltion for NixOS (Requires yarn)
if filereadable('/etc/os-release')  && ( strpart(filter(readfile('/etc/os-release'), 'v:val =~ "^NAME"')[0], 5) ==# 'NixOS' )
  Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
else
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

" Adds seamless navigation between tmux and vim
Plug 'christoomey/vim-tmux-navigator'

" Default Snippets for coc.nvim
Plug 'honza/vim-snippets'

" Tagbar
Plug 'majutsushi/tagbar'

" UndoTree
Plug 'mbbill/undotree'

" Wiki
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }

" Distraction free writing
Plug 'junegunn/goyo.vim'

" Preview of register contents
Plug 'junegunn/vim-peekaboo'

"}}}
"  Language Specific Plugins {{{
""""""""""""""""""""""""""""""""

" Haskell
Plug 'parsonsmatt/intero-neovim', { 'for': 'haskell' }
Plug 'ndmitchell/ghcid', { 'for': 'haskell', 'rtp': 'plugins/nvim' }
Plug 'meck/vim-brittany', { 'for': 'haskell' }
Plug 'alx741/vim-hindent', { 'for': 'haskell' }
Plug 'alx741/vim-stylishask', { 'for': 'haskell' }
Plug 'meck/vim-counterpoint', { 'for': 'haskell' }
Plug 'meck/vim-clap-hoogle'

" Purescript
Plug 'purescript-contrib/purescript-vim'

" Markdown
Plug 'plasticboy/vim-markdown'
Plug 'rhysd/vim-gfm-syntax'
Plug 'JamshedVesuna/vim-markdown-preview'

" Python
Plug 'jmcantrell/vim-virtualenv' , { 'for': 'python' }

" Go
Plug 'fatih/vim-go' , { 'for': 'go' }

" Rust
Plug 'rust-lang/rust.vim' , { 'for': 'rust' }

call plug#end()

"}}}
"  Built in settings {{{
""""""""""""""""""""""""
set termguicolors                       " Lots of colors
set clipboard^=unnamed,unnamedplus      " Use MacOs / Linux clipboard
language en_US.UTF-8                    " Not MacOS Lang
filetype plugin indent on               " Enabling filetype support provides filetype-specific indenting, syntax
set omnifunc=syntaxcomplete#Complete    " Basic Compleation
syntax on                               " highlighting, omni-completion and other useful settings.
set showcmd                             " Show command
set noshowmode                          " mode is shown in airline
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
set exrc                                " Source .nvimrc or .vimrc in current directory
set secure                              " Limit autocmds and shell cmds from above
set foldlevelstart=99                   " Open new files with no folds closed
set updatetime=300                      " For quicker diagnostics with coc.nvim
set shortmess+=c                        " Dont show the number of matches

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
set textwidth=0                         " Textwidth set in ftplugin
set linebreak                           " Linebreak


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

"Automatically switch line numbers
function! Relativize(v)
  if &number
    let &relativenumber = a:v
  endif
endfunction
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

" Live substitution
set inccommand=split

" Terminal
augroup nvim_term
  autocmd!

  " Always enter terminal in insert mode
  autocmd BufWinEnter,WinEnter,TermOpen term://* startinsert
  autocmd BufLeave term://* stopinsert

  " no linenumbers in terminals
  autocmd TermOpen * setlocal nonumber norelativenumber
augroup END


"}}}
"  Plugin Settings {{{
""""""""""""""""""""""
" Coc.nvim

" Coc extensions to always install
let g:coc_global_extensions =
  \ [ 'coc-json'
  \ , 'coc-snippets'
  \ , 'coc-vimlsp'
  \ , 'coc-yaml'
  \ , 'coc-emoji'
  \ , 'coc-rls'
  \ , 'coc-diagnostic' ]

augroup CocAugrp
  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Hide the bar at bottom of coclist windows and remove numbers
  autocmd! FileType list
  autocmd FileType list setlocal nonumber norelativenumber
  autocmd FileType list set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

augroup END

" Vim Obsession
augroup obsssions_autoload
  autocmd!
  autocmd VimEnter * nested
            \ if !argc() && empty(v:this_session) && filereadable('Session.vim') |
            \   source Session.vim |
            \ endif
augroup END

" Quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#obsession#indicator_text = 'Ⓢ'
function! AirlineInit()
  let g:airline_section_z = airline#section#create(['obsession', '%3p%% %4l:%-2c'])
endfunction
augroup airline_init
  autocmd!
  autocmd User AirlineAfterInit call AirlineInit()
augroup END

" Slanted Dividers
let g:airline_left_sep = "\ue0b8"
let g:airline_left_alt_sep = "\ue0b9"
let g:airline_right_sep = "\ue0be"
let g:airline_right_alt_sep = "\ue0bf"

" GitGutter
let s:gitgutter_sign_all = exists('g:airline_powerline_fonts') ? '▸' : '∙'
let g:gitgutter_sign_added = s:gitgutter_sign_all
let g:gitgutter_sign_modified = s:gitgutter_sign_all
let g:gitgutter_sign_removed = s:gitgutter_sign_all
let g:gitgutter_sign_modified_removed = s:gitgutter_sign_all

" Vim-Clap
let g:clap_search_box_border_symbols = { 'rounded': ["🭁", "🭌"], 'nil': ['', ''] }
let g:clap_search_box_border_style = exists('g:airline_powerline_fonts') ? 'rounded' : 'nil'
let g:clap_current_selection_sign = {
      \ 'text': exists('g:airline_powerline_fonts') ? '▶' : '>>',
      \ 'texthl': "Warning",
      \ "linehl": "ClapCurrentSelection"
      \ }
let g:clap_selected_sign = {
      \ 'text': exists('g:airline_powerline_fonts') ? '●' : ' >',
      \ 'texthl': "Warning",
      \ "linehl": "ClapSelected"
      \ }
let g:clap_enable_icon = 0
let g:clap_provider_grep_enable_icon = 0

" VimWiki
let g:vimwiki_list = [{'path': '~/vimwiki/',
                     \ 'path_html': '~/wiki/',
                     \ 'auto_export': 1}]

" Themes
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_uniform_diff_background = 1
let g:nord_underline = 1

let g:gruvbox_italic=1
let g:gruvbox_invert_selection=0

if exists('daytheme')
 set background=light
 colorscheme gruvbox
else
 set background=dark
 colorscheme nord
endif

"}}}
"  Functions {{{
""""""""""""""
" Delete buffer if it is only open in a single window, otherwise close the
" window
function! CloseWindowOrKillBuffer()
  let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

  if number_of_windows_to_this_buffer > 1
    wincmd c
  else
    bdelete
  endif
endfunction

"  }}}
"  Commands {{{
""""""""""""""
" Delete all but the current buffer
command! Bonly silent! execute "%bd|e#|bd#"

"  }}}
" Built in mappings {{{

" Space as leader works with showcmd
let g:mapleader = "\<Space>"

" Move across wrapped lines like regular lines
noremap 0 ^
noremap ^ 0

" Clear search hightligt
nnoremap <silent><esc> :noh<return><esc>

" Window killer
nnoremap <silent> Q :call CloseWindowOrKillBuffer()<cr>

" Reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" foldlevel
nnoremap zr zr:echo 'Foldlevel = ' . &foldlevel<cr>
nnoremap zm zm:echo 'Foldlevel = ' . &foldlevel<cr>
nnoremap zR zR:echo 'Foldlevel = ' . &foldlevel<cr>
nnoremap zM zM:echo 'Foldlevel = ' . &foldlevel<cr>

" make Y consistent with C and D. See :help Y.
nnoremap Y y$

" w!! expands to a sudo save
cmap w!! w !sudo tee >/dev/null %

" Edit vimrc with f5 and source it automatically when saved
nmap <silent><f5> :e $MYVIMRC<CR>
augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
augroup END

" Terminal
nnoremap <silent> <Leader>te :belowright split +resize\ 13 \| setlocal winfixheight \| terminal <CR>
nnoremap <silent> <Leader>vte :belowright vsplit \| terminal <CR>

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

" Whitespace Clean
function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
    echo 'Stripped trailing whitespaccs'
endfunction
noremap <silent> <Leader>wc :call TrimWhitespace()<CR>

"}}}
" Plugin mappings {{{

" Coc.nvim

" Map <tab> for trigger completion, completion confirm, snippet expand and jump.
inoremap <silent><expr> <TAB>
  \ pumvisible() ? coc#_select_confirm() :
  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Navigate snippets
let g:coc_snippet_next = '<tab>'
let g:coc_snippet_prev = '<s-tab>'

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" gq Format
set formatexpr=CocAction('formatSelected')

" Use `[s` and `]s` to navigate diagnostics
nmap <silent> [s <Plug>(coc-diagnostic-prev)
nmap <silent> ]s <Plug>(coc-diagnostic-next)

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap for rename current word
nmap <leader>r <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>lf  <Plug>(coc-format-selected)
nmap <leader>lf  <Plug>(coc-format-selected)

" Using CocList
" Show List
nnoremap <silent> <Leader>ll  :<C-u>CocList<cr>
" Show all diagnostics
nnoremap <silent> <Leader>ld  :<C-u>CocList diagnostics<cr>
" Find symbol of current document
nnoremap <silent> <Leader>ls  :<C-u>CocList outline<cr>
" Find symbol of current document
nnoremap <silent> <Leader>la  :<C-u>CocList actions<cr>

" Gitgutter
nmap <silent> ]g :GitGutterNextHunk <CR>
nmap <silent> [g :GitGutterPrevHunk <CR>

" Tagbar
nnoremap <Leader>tb :TagbarToggle <CR>

" UndoTree
nnoremap <silent><Leader>u :UndotreeToggle<CR>

" Clap
" Open Clap
nnoremap <silent><Leader>c :Clap<CR>
" Search for files
nnoremap <silent><Leader>f :Clap files<CR>
" Search buffers
nnoremap <silent><Leader>b :Clap buffers<CR>
" Grep
nnoremap <silent><Leader>g :Clap grep<CR>
" cwd from ~
nnoremap <silent><Leader>D :Clap cd ~<CR>
" cwd from .
nnoremap <silent><Leader>d :Clap cd<CR>

" }}}
