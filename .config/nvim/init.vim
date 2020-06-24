" {{{
" vim: set foldmarker={{{,}}} foldmethod=marker foldlevel=1 :
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Misc                                                                {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Encoding of this script
scriptencoding utf-8

let s:vimDir = '$HOME/.config/nvim'



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Plugins                                                             {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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


Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim' " Gist
Plug 'unblevable/quick-scope'                   " Preview targets for f/F/t/T
Plug 'machakann/vim-sandwich'                   " Surround editing and objects
Plug 'godlygeek/tabular'                        " Aligning stuff
Plug 'romainl/vim-qf'                           " Better quickfix window
Plug 'liuchengxu/vim-clap'                      " Interactive selection
Plug 'vim-airline/vim-airline'                  " Statusline and theme
Plug 'meck/nord-vim', { 'branch': 'develop' }   " Theme - TODO Waiting for PR
Plug 'sheerun/vim-polyglot'                     " Languge Files
Plug 'neovim/nvim-lsp'                          " Builtin LSP
Plug 'haorenW1025/diagnostic-nvim'              " Builtin LSP diagnostic
Plug 'wbthomason/lsp-status.nvim'               " Get LSP status for statusline
Plug 'haorenW1025/completion-nvim'              " Completion with LSP support
Plug 'steelsojka/completion-buffers'            " Buffers for completion-nvim
Plug 'SirVer/ultisnips'                         " Snippets
Plug 'honza/vim-snippets'                       " Default Snippets
Plug 'majutsushi/tagbar'                        " Tagbar
Plug 'mbbill/undotree'                          " UndoTree
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }     " Wiki
Plug 'junegunn/vim-peekaboo'                    " Preview of register contents
Plug 'jamessan/vim-gnupg'                       " GnuPG
Plug 'liuchengxu/graphviz.vim'                  " Graphviz



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Language specific Plugins                                           {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Haskell
Plug 'ndmitchell/ghcid', { 'for': 'haskell', 'rtp': 'plugins/nvim' }
Plug 'meck/vim-brittany', { 'for': 'haskell' }
Plug 'alx741/vim-hindent', { 'for': 'haskell' }
Plug 'alx741/vim-stylishask', { 'for': 'haskell' }
Plug 'meck/vim-counterpoint', { 'for': 'haskell' }
Plug 'meck/vim-clap-hoogle'

" Markdown
Plug 'plasticboy/vim-markdown'
Plug 'rhysd/vim-gfm-syntax'
Plug 'JamshedVesuna/vim-markdown-preview'

Plug 'fatih/vim-go' , { 'for': 'go' }
Plug 'rust-lang/rust.vim' , { 'for': 'rust' }

call plug#end()



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
set updatetime=300                      " For quicker diagnostics with coc.nvim
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
set completeopt=menuone,noinsert

" Command line completion
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git
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

" Live substitution
set inccommand=split



" Persistent Undo
if has('persistent_undo')
  " Create the undo directory if it dosent exsist
  let s:myUndoDir = expand(stdpath("data") . '/undodir')
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
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 1000)
augroup END



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Functions                                                           {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Whitespace clean
function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
    echo 'Stripped trailing whitespaccs'
endfunction


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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Commands                                                            {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Delete all but the current buffer
command! Bonly silent! execute "%bd|e#|bd#"



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Lua Config                                                          {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

lua << EOF
  require'lsp'
EOF



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


" Quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']


" Airline
let g:airline_left_sep = "\ue0b8" " Slanted Dividers
let g:airline_left_alt_sep = "\ue0b9"
let g:airline_right_sep = "\ue0be"
let g:airline_right_alt_sep = "\ue0bf"

let g:airline_powerline_fonts = 1
let g:airline#extensions#obsession#indicator_text = 'Ⓢ'
let g:airline#extensions#obsession#enabled = 1

function! AirlineInit()
  " call airline#parts#define_function('lsp', 'v:lua.lsp_get_airline_error')
  " let g:airline_section_c = airline#section#create(['file', 'readonly', 'lsp'])
endfunction
augroup airline_init
  autocmd!
  autocmd User AirlineAfterInit call AirlineInit()
augroup END



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

autocmd FileType clap_input inoremap <silent> <buffer> <Esc> <Esc>:call clap#handler#exit()<CR>


" VimWiki
let g:vimwiki_list = [{'path': '~/vimwiki/',
                     \ 'path_html': '~/wiki/',
                     \ 'syntax': 'markdown',
                     \ 'ext': '.md',
                     \ 'template_path': '~/.config/wiki/',
                     \ 'template_default':'GitHub',
                     \ 'custom_wiki2html': '~/.config/wiki/wiki2html.sh',
                     \ 'template_ext':'.html5',
                     \ 'auto_export':1
                     \ }]



" Theme
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_uniform_diff_background = 1
let g:nord_underline = 1
colorscheme nord



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Built in mappings                                                   {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Space as leader works with showcmd
let g:mapleader = "\<Space>"

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
noremap <silent> <Leader>wc :call TrimWhitespace()<CR>

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

" Snippets
let g:UltiSnipsExpandTrigger="<Plug>(ultisnips_expand)" " Completion to expand
let g:UltiSnipsJumpForwardTrigger="<tab>"



" Completion
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_docked_hover = 1
let g:completion_docked_minimum_size = 5
let g:completion_docked_maximum_size = 20
let g:completion_auto_change_source = 1
let g:completion_chain_complete_list =  {
    \ 'default': [
    \    {'complete_items': ['lsp', 'snippet', 'path']},
    \    {'complete_items': ['buffers']},
    \]}

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ completion#trigger_completion()

" Load completion plugin for all buffers
augroup load_comp_grp
    autocmd!
    autocmd BufEnter * lua require'completion'.on_attach()
augroup END



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
