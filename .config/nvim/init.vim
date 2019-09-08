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

" fuzzy all the things
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'

" Statusline and theme
Plug 'vim-airline/vim-airline'

" Wating for PR
Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }
Plug 'gruvbox-community/gruvbox'

" Languge Files
Plug 'sheerun/vim-polyglot'

" Language server client
Plug 'neoclide/coc.nvim', {'branch': 'release'}

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

Plug 'junegunn/vim-peekaboo'

"}}}
"  Language Specific Plugins {{{
""""""""""""""""""""""""""""""""

" Haskell
Plug 'parsonsmatt/intero-neovim', { 'for': 'haskell' }
Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }
Plug 'ndmitchell/ghcid', { 'for': 'haskell', 'rtp': 'plugins/nvim' }
Plug 'meck/vim-brittany', { 'for': 'haskell' }
Plug 'alx741/vim-hindent', { 'for': 'haskell' }
Plug 'alx741/vim-stylishask', { 'for': 'haskell' }

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
" set colorcolumn=+1
set linebreak                           " Linebreak

set shortmess+=c                        " Dont show the number of matches

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
  \ , 'coc-rls']

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

" GitGutter
let g:gitgutter_sign_added = '∙'
let g:gitgutter_sign_modified = '∙'
let g:gitgutter_sign_removed = '∙'
let g:gitgutter_sign_modified_removed = '∙'

" Airline
let g:airline_powerline_fonts = 1

let g:airline_section_z = '%3p%% %4l:%-2c'

let g:airline#extensions#hunks#enabled = 1

let g:airline#extensions#obsession#enabled = 1
let g:airline#extensions#obsession#indicator_text = '$'

" Fzf-vim
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

aug fzf_setup
  autocmd!
  " Changes the remapping of escape for fzf windows to be able to close
  autocmd TermOpen term://*FZF tnoremap <silent> <buffer><nowait> <esc> <c-c>

  " Hide the bar at bottom of fzf windows
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
aug END

" :Rg  - Start fzf with hidden preview window that can be enabled with "?" key
" :Rg! - Start fzf in fullscreen and display the preview window above
" Ignores the filename and the l:c when filtering the results
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \  <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%' )
  \          : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \  <bang>0)

" :Files  - Start fzf with hidden preview window that can be enabled with "?" key
" :Files! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" VimWiki
let g:vimwiki_list = [{'path': '~/vimwiki/',
                     \ 'path_html': '~/wiki/',
                     \ 'auto_export': 1}]

" Theme
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
""""""""""""""""

" Use fzf to cd starting from home directory
function! Fzf_Cd(...)
  let l:o = {'source': 'fd --follow -t d . $HOME', 'sink': 'cd', 'down': '30%'}
  if len(a:000) > 0
    let l:o.options = shellescape('-q' . join(a:000, ' '))
  endif
  call fzf#run(l:o)
endfunction

command! -nargs=* Cd :call Fzf_Cd(<f-args>)

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

" Close all but the current buffer
function! Buflist()
    redir => l:bufnames
    silent ls
    redir END
    let l:list = []
    for l:i in split(l:bufnames, "\n")
        let l:buf = split(l:i, '"' )
        call add(l:list, l:buf[-2])
    endfor
    return l:list
endfunction

function! Bdeleteonly()
    let l:list = filter(Buflist(), "v:val != bufname('%')")
    for l:buffer in l:list
        exec 'bdelete '.l:buffer
    endfor
endfunction

command! Bonly :silent call Bdeleteonly()

" Shrink the current widow to fit smaller content
fun! s:ShrinkWinToFit()
    let l:initcursor = getpos('.')
    call cursor(1,1)
    let l:i = 0
    let l:previouspos = [-1,-1,-1,-1]
    " keep moving cursor down one visual line until it stops moving position
    while l:previouspos != getpos('.')
      let l:i += 1
      " store current cursor position BEFORE moving cursor
      let l:previouspos = getpos('.')
      normal! gj
    endwhile
    " Resize
    if l:i < winheight(0)
      execute 'resize ' . l:i
    endif
    " restore cursor position
    call setpos('.', l:initcursor)
endfunction

"}}}
"  Mappings {{{
""""""""""""""
" Built in mappings {{{

" Space as leader works with showcmd
let g:mapleader = "\<Space>"

" Move across wrapped lines like regular lines
noremap 0 ^
noremap ^ 0

" Clear search hightligt
nnoremap <silent><esc> :noh<return><esc>

" w!! expands to a sudo save
cmap w!! w !sudo tee >/dev/null %

" Edit vimrc with f5 and source it automatically when saved
nmap <silent> <leader><f5> :e $MYVIMRC<CR>
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

" Tagbar
nnoremap <Leader>tb :TagbarToggle <CR>

" UndoTree
nnoremap <silent><Leader>u :UndotreeToggle<CR>

" FZF
" Search for files
nnoremap <silent><Leader>f :Files<CR>
" Search buffers
nnoremap <silent><Leader>b :Buffer<CR>
" cwd from ~
nnoremap <silent><Leader>d :Cd<CR>

" }}}
" }}}

