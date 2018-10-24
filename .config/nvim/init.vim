" Misc {{{
"""""""""""

" Encoding of this script
scriptencoding utf-8

" The current vim directory
if has('nvim')
  let s:vimDir = '$HOME/.config/nvim'
else
  let s:vimDir = '$HOME/.vim'
endif

" Architecture of the current system
let s:uname = substitute(system('uname -ms'), '\n', '', '')
if match(s:uname, 'Darwin.*64$') !=# '-1'
  let s:arch = 'MacOs'
elseif match(s:uname, 'Linux.*86$') !=# '-1'
  let s:arch = 'LinuxI32'
elseif match(s:uname, 'Linux.*64$') !=# '-1'
  let s:arch = 'LinuxI64'
elseif match(s:uname, 'armv6.*') !=# '-1'
  let s:arch = 'Arm32'
elseif match(s:uname, 'armv7.*') !=# '-1'
  let s:arch = 'Arm64'
else
  let s:arch = 'Unknown'
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

" Testing
Plug 'junegunn/vader.vim'

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

" Better quickfix window
Plug 'romainl/vim-qf'

" fuzzy all the things
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'

" Statusline and theme
Plug 'vim-airline/vim-airline'
" Wating for PR
" Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }
Plug 'meck/nord-vim', { 'branch': 'testing' }
Plug 'morhetz/gruvbox'

" ALE Linter
if has('timers') && exists('*job_start') && exists('*ch_close_in') || has('nvim')
  Plug 'w0rp/ale'
endif

" Completion engine
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Languge Files
Plug 'sheerun/vim-polyglot'

" Show completion signature in echo area
Plug 'Shougo/echodoc.vim'

" Language server client
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh', }

" Adds seamless navigation between tmux and vim
Plug 'christoomey/vim-tmux-navigator'

" Snippets Manager and default Snippets
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Tagbar
Plug 'majutsushi/tagbar'

" UndoTree
Plug 'mbbill/undotree'

"}}}
"  Language Specific Plugins {{{
""""""""""""""""""""""""""""""""

" Haskell
if has('nvim')
  Plug 'parsonsmatt/intero-neovim', { 'for': 'haskell' }
endif
Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }
Plug 'ndmitchell/ghcid', { 'for': 'haskell', 'rtp': 'plugins/nvim' }

Plug 'meck/vim-brittany', { 'for': 'haskell' }
Plug 'alx741/vim-hindent', { 'for': 'haskell' }
Plug 'alx741/vim-stylishask', { 'for': 'haskell' }

" Markdown
Plug 'plasticboy/vim-markdown'
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

" netrw
let g:netrw_banner = 0

" Neovim Stuff
if has('nvim')

  " Live substitution
  set inccommand=split

  augroup nvim_term
    autocmd!

    " Always enter terminal in insert mode
    autocmd BufWinEnter,WinEnter,TermOpen term://* startinsert
    autocmd BufLeave term://* stopinsert

    " no linenumbers in terminals
    autocmd TermOpen * setlocal nonumber norelativenumber
  augroup END

endif

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

  let g:ale_open_list = 0
endif

"Completion
let g:deoplete#enable_at_startup = 1
call deoplete#custom#source('_',  'max_menu_width', 0)
call deoplete#custom#source('_',  'max_abbr_width', 0)
call deoplete#custom#source('_',  'max_kind_width', 0)

" GitGutter
let g:gitgutter_sign_added = '∙'
let g:gitgutter_sign_modified = '∙'
let g:gitgutter_sign_removed = '∙'
let g:gitgutter_sign_modified_removed = '∙'

" Snippets
let g:UltiSnipsExpandTrigger='<NUL>'
let g:UltiSnipsListSnippets='<NUL>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'

" Expand snippets with enter in completion menu
let g:ulti_expand_or_jump_res = 0
function! <SID>ExpandSnippetOrReturn()
  let l:snippet = UltiSnips#ExpandSnippetOrJump()
  if g:ulti_expand_or_jump_res > 0
    return l:snippet
  else
    return "\<CR>"
  endif
endfunction
inoremap <silent> <expr> <CR> pumvisible() ? "<C-R>=<SID>ExpandSnippetOrReturn()<CR>" : "\<CR>"

" Language server client
let g:LanguageClient_serverCommands = {
    \ 'haskell': ['hie-wrapper'],
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ }

let g:LanguageClient_hasSnippetSupport = 0
let g:LanguageClient_hoverPreview = 'Always'

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

augroup auLanguageClientStartedVar
  autocmd!
  autocmd User LanguageClientStarted let b:LanguageClientRunning=1
  autocmd User LanguageClientStopped let b:LanguageClientRunning=0
augroup END


" Airline

let g:airline_skip_empty_sections = 1
let g:airline_powerline_fonts = 1

" Shows if there is a Language server running
call airline#parts#define_text('lspstatus','LS')
call airline#parts#define_condition('lspstatus', 'exists("b:LanguageClientRunning") && b:LanguageClientRunning')
" call airline#parts#define_condition('lspstatus', 'LanguageClient_runSync("LanguageClient#isAlive") ==# "true"')
let g:airline_section_x = airline#section#create_right(['tagbar', 'gutentags', 'grepper', 'lspstatus', 'filetype'])
let g:airline_section_z = '%3p%% %4l:%-2c'

let g:airline#extensions#hunks#enabled=1

let g:airline#extensions#obsession#enabled = 1
let g:airline#extensions#obsession#indicator_text = '$'

let g:airline#extensions#languageclient#enabled = 1
let airline#extensions#languageclient#error_symbol = 'E:'
let airline#extensions#languageclient#warning_symbol = 'W:'
let airline#extensions#languageclient#show_line_numbers = 0
let airline#extensions#languageclient#open_lnum_symbol = '(L'
let airline#extensions#languageclient#close_lnum_symbol = ')'

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

" Theme
let g:nord_comment_brightness = 12
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
 " hi Normal guibg=NONE
endif

"}}}
"  Functions {{{
""""""""""""""""

" Use fzf to cd starting from home directory
function! Fzf_Cd()
  call fzf#run({'source': 'fd --follow -t d . $HOME', 'sink': 'cd', 'down': '30%'})
endfunction

command! -nargs=0 Cd :call Fzf_Cd()

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

" Manage the Quickfix and Loclist Automatically
let g:LanguageClient_open_List=0
augroup LanguageClientAutoList
  autocmd!
  autocmd User LanguageClientDiagnosticsChanged if g:LanguageClient_open_List
        \ | call s:UpdateLists()
        \ | endif
augroup END

fun! ToggleAutoLists()
  " If the autofunctions are on turn off and close
  if g:ale_open_list || g:LanguageClient_open_List
    let g:ale_open_list = 0
    let g:LanguageClient_open_List = 0
    cclose
    lclose
    echo 'Automatic Lists Off'
  " Otherwise turn on and open if any content
  else
    let g:ale_open_list = 1
    let g:LanguageClient_open_List = 1
    call s:UpdateLists()
    echo 'Automatic Lists On'
  endif
endfun

function! s:UpdateLists()
  let l:winnr = winnr()
  execute ':cwindow'
  execute ':lwindow'
  if l:winnr !=# winnr()
    wincmd p
  endif
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

command! Ball :silent call Bdeleteonly()

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

" Built in

" Space as leader works with showcmd
let g:mapleader = "\<Space>"

" Clear search hightligt
nnoremap <silent><esc> :noh<return><esc>

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

" Navigate Neovim terminal window
if has('nvim')
  tnoremap <C-h> <C-\><C-n><C-w>h
  tnoremap <C-j> <C-\><C-n><C-w>j
  tnoremap <C-k> <C-\><C-n><C-w>k
  tnoremap <C-l> <C-\><C-n><C-w>l
  tnoremap <Esc> <C-\><C-n>
endif

" Language Client
" These mappings replace built in functions
augroup LanguageClient_mappings
  autocmd!
  " Show type info (and short doc) of identifier under cursor.
  autocmd User LanguageClientStarted noremap <buffer> <silent>K :call LanguageClient#textDocument_hover()<CR>
  autocmd User LanguageClientStopped unmap <buffer>K
  " Goto definition of identifier under cursor capital for a split.
  autocmd User LanguageClientStarted nnoremap <buffer> <silent>gd :call LanguageClient#textDocument_definition()<CR>
  autocmd User LanguageClientStopped unmap <buffer>gd
  autocmd User LanguageClientStarted nnoremap <buffer> <silent>gD :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>
  autocmd User LanguageClientStopped unmap <buffer>gD
  " gq format
  autocmd User LanguageClientStarted set formatexpr=LanguageClient#textDocument_rangeFormatting()
  autocmd User LanguageClientStopped set formatexpr=
augroup END

nnoremap <silent> <Leader>ll :call LanguageClient_contextMenu()<CR>
" Show code action
nnoremap <silent> <Leader>a :call LanguageClient#textDocument_codeAction()<CR>
" Rename identifier under cursor.
nnoremap <silent> <Leader>r :call LanguageClient#textDocument_rename()<CR>
" Format current document.
nnoremap <silent> <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
" Format selected lines.
vnoremap <silent> <Leader>lf :call LanguageClient#textDocument_rangeFormatting()<CR>
" List of current buffer's symbols.
nnoremap <silent> <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>
" List of project's symbols.
nnoremap <silent> <Leader>lS :call LanguageClient#workspace_symbol()<CR>
" List all references of identifier under cursor.
nnoremap <silent> <Leader>lr :call LanguageClient#textDocument_references()<CR>

" Toggles Underlining of all ocurrences of the item under the cursor
nnoremap <silent> <Leader>lh :call <SID>ToggleLspHlUnderCursor()<CR>

function s:ToggleLspHlUnderCursor()
  if exists('b:lspHlUnderCursor') && b:lspHlUnderCursor
    call LanguageClient#clearDocumentHighlight()
    let b:lspHlUnderCursor = 0
  else
    call LanguageClient#textDocument_documentHighlight()
    let b:lspHlUnderCursor = 1
  endif
endfunction

if has('nvim')
  " This makes scrolling slow even if run async...
  function! s:LspHlUnderCursorHelper()
    if LanguageClient_runSync('LanguageClient#isAlive') ==# 'true'
      call LanguageClient#textDocument_documentHighlight()
    endif
  endfunction

  augroup LspHlAUGroup
    autocmd!
    autocmd CursorMoved * if exists('b:lspHlUnderCursor') && b:lspHlUnderCursor | call jobstart([s:LspHlUnderCursorHelper()]) | endif
  augroup END
endif


" Toggle the autoopening of lists
nnoremap <silent><Leader>q :call ToggleAutoLists()<CR>

" Tagbar
nnoremap <Leader>tb :TagbarToggle <CR>

" UndoTree
nnoremap <silent><Leader>u :UndotreeToggle<CR>

" FZF
" Search for files
nnoremap <silent><Leader>f :Files<CR>
" Search buffers
nnoremap <silent><Leader>b :Buffer<CR>

" Terminals
nnoremap <silent> <Leader>te :belowright split +resize\ 13 \| setlocal winfixheight \| terminal <CR>
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

" }}}
