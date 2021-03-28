M = {}

M.sh = {
  {
    -- shellcheck
    lintCommand = "shellcheck -f gcc -x -",
    lintStdin = true,
    lintFormats = {
      "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m"
    }
  }, {
    -- shfmt
    formatCommand = 'shfmt -ln bash -i 2 -bn -ci -sr -kp',
    formatStdin = true
  }
}

M.lua = {
  {
    -- lua-format
    formatCommand = 'lua-format --indent-width=2 -i',
    formatStdin = true
  }
}

M.python = {
  {
    -- black
    formatCommand = 'black --quiet -',
    formatStdin = true
  }, {
    -- pylint
    lintCommand = 'pylint --output-format text --score no --msg-template {path}:{line}:{column}:{C}:pylint:{msg} ${INPUT}',
    lintFormats = {"%f:%l:%c:%t:%m"},
    lintStdin = false,
    lintOffsetColumns = 1,
    lintCategoryMap = {I = 'H', R = 'I', C = 'I', W = 'W', E = 'E', F = 'E'}
  }
}

M.vim = {
  {
    -- vint
    lintCommand = 'vint --enable-neovim --style-problem ${INPUT}',
    lintFormats = {"%f:%l:%c: %m"}
  }
}

M.vhdl = {
  {
    -- vhdl style guide
    lintCommand = "vsg -of syntastic -f ${INPUT}",
    lintFormats = {"%tRROR: %f(%l)%m", "%tARNING: %f(%l)%m"}
  }
}

M.make = {
  {
    -- checkmake
    lintCommand = 'checkmake --format "w{{.LineNumber}}:{{.Rule}}:{{.Violation}}" ${INPUT}',
    lintFormats = {"%t%l:%m"}
  }
}

return M
