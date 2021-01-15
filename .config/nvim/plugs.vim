" {{{
" vim: set foldmarker={{{,}}} foldmethod=marker foldlevel=1 :
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Plugins                                                             {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:vimDir = expand(stdpath('config'))

" Automatically install the plugin manager if not installed
augroup plug_auto_install
  autocmd!
  if empty(glob(s:vimDir . '/autoload/plug.vim'))
    execute('silent !curl -fLo ' . s:vimDir . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    autocmd plug_auto_install VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
augroup END

" Start the plugin manager
call plug#begin(s:vimDir . '/plugged')

" Smart stuff
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-vinegar'

Plug 'kyazdani42/nvim-web-devicons'

" Git Stuff
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'airblade/vim-gitgutter'


Plug 'mattn/webapi-vim' | Plug 'mattn/gist-vim'              "  Gist
Plug 'unblevable/quick-scope'                                "  Preview targets for f/F/t/T
Plug 'machakann/vim-sandwich'                                "  Surround editing and objects
Plug 'godlygeek/tabular'                                     "  Aligning stuff
Plug 'romainl/vim-qf'                                        "  Better quickfix window
Plug 'vim-airline/vim-airline'                               "  Statusline and theme
Plug 'meck/nord-vim', { 'branch': 'custom' }                 "  Theme - TODO Waiting for PR
Plug 'sheerun/vim-polyglot'                                  "  Language Files
Plug 'SirVer/ultisnips'                                      "  Snippets
Plug 'honza/vim-snippets'                                    "  Default Snippets
Plug 'mbbill/undotree'                                       "  UndoTree
Plug 'junegunn/vim-peekaboo'                                 "  Preview of register contents
Plug 'jamessan/vim-gnupg'                                    "  GnuPG
Plug 'tpope/vim-dispatch'                                    "  Async make
Plug 'radenling/vim-dispatch-neovim'                         "  Vim-dispatch in neovim terminal


if has("nvim-0.5.0")
Plug 'neovim/nvim-lsp'                                       "  Builtin LSP
Plug 'nvim-lua/lsp-status.nvim'                              "  Get LSP status for statusline
Plug 'nvim-lua/completion-nvim'                              "  Completion with LSP support
Plug 'steelsojka/completion-buffers'                         "  Buffers for completion-nvim
Plug 'nvim-lua/popup.nvim'                                   "  Vim compatibility api
Plug 'nvim-lua/plenary.nvim'                                 "  Functions
Plug 'nvim-lua/telescope.nvim'                               "  Fuzzy
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
" Language specific Plugins                                           {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Haskell
Plug 'ndmitchell/ghcid', { 'for': 'haskell', 'rtp': 'plugins/nvim' }
Plug 'meck/vim-counterpoint', { 'for': 'haskell' }

" Markdown/Pandoc/Tex
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-pandoc/vim-pandoc-after'
Plug 'dhruvasagar/vim-table-mode'
Plug 'lervag/vimtex'

" Misc
Plug 'fatih/vim-go' , { 'for': 'go' }
Plug 'rust-lang/rust.vim' , { 'for': 'rust' }
Plug 'liuchengxu/graphviz.vim'

call plug#end()

" }}}
