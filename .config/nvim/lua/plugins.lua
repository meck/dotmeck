------------------------------------------------------------------------
--                             Bootstrap                              --
------------------------------------------------------------------------

local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])
if not packer_exists then
  local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

  print("Installing Packer")
  vim.cmd("!git clone https://github.com/wbthomason/packer.nvim "..install_path)
end


------------------------------------------------------------------------
--                              Plugins                               --
------------------------------------------------------------------------


vim.cmd [[packadd packer.nvim
          autocmd BufWritePost plugins.lua PackerCompile]]

local packer = require('packer')

packer.init()
packer.startup(function()

  use {'wbthomason/packer.nvim', opt = true}                        -- Packer manages itself

  -- Visual
  use {'meck/nord-vim',  branch = 'custom' }                        -- Theme TODO Waiting for PR
  use 'vim-airline/vim-airline'                                     -- Statusline and theme

  -- LSP
  use 'neovim/nvim-lsp'                                            -- Builtin LSP
  use 'nvim-lua/lsp-status.nvim'                                   -- Get LSP status for statusline

  -- UI
  use 'tpope/vim-vinegar'                                           -- Better netrw behavior
  use 'tpope/vim-repeat'                                            -- Repeat plugin mappings with `.`
  use {
    'nvim-telescope/telescope.nvim',                                -- Fuzzy finder
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }
  use 'mbbill/undotree'                                             -- UndoTree
  use 'tpope/vim-obsession'                                         -- Save vim state
  use 'romainl/vim-qf'                                              -- Better quickfix window

  -- Movment, selection
  use 'tpope/vim-unimpaired'                                        -- Handy shortcuts
  use 'tpope/vim-commentary'                                        -- Handle Comments
  use 'machakann/vim-sandwich'                                      -- Surround editing and objects
  use 'junegunn/vim-peekaboo'                                       -- Preview of register contents
  use 'unblevable/quick-scope'                                      -- Preview targets for f/F/t/T

  -- Completion and snippets
  use 'nvim-lua/completion-nvim'                                    -- Completion with LSP support
  use 'steelsojka/completion-buffers'                               -- Buffers for completion-nvim
  use {
    'SirVer/ultisnips',                                             -- Snippets
    requires = {'honza/vim-snippets'}                               -- Default snippets
  }

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run =  ':TSUpdate'
  }

  -- Git Stuff
  use 'tpope/vim-fugitive'
  use 'tpope/vim-git'
  use 'mhinz/vim-signify'
  use {
    'mattn/gist-vim',                                              --  Gists
    requires = {'mattn/webapi-vim'}
  }

  -- Formating
  use 'godlygeek/tabular'                                          -- Aligning stuff
  use 'dhruvasagar/vim-table-mode'                                 -- Textbased tables

  -- Utillites
  use {
    'tpope/vim-dispatch',                                          -- Async Make
    opt = true,
    cmd = {'Dispatch', 'Make', 'Focus', 'Start'},
    requires = {'radenling/vim-dispatch-neovim'},
  }


------------------------------------------------------------------------
--                     Language specific plugins                      --
------------------------------------------------------------------------

  -- Multiple Languages
  use 'sheerun/vim-polyglot'

  -- Haskell
  use { 'ndmitchell/ghcid',
    'meck/vim-counterpoint',
    ft = {'haskell', 'lhaskell', 'cabal'}
  }

  -- Markdown/Pandoc/Tex
  use 'lervag/vimtex'
  use {
    'vim-pandoc/vim-pandoc',
    requires = {
      'vim-pandoc/vim-pandoc-syntax',
      'vim-pandoc/vim-pandoc-after'
    }
  }

  -- Misc
  use {'fatih/vim-go', ft = 'go'}
  use {'rust-lang/rust.vim' , ft = 'rust'}
  use 'liuchengxu/graphviz.vim'

end)

-- TODO make this synchronous
if not packer_exists then
  packer.compile()
  packer.install()
end
