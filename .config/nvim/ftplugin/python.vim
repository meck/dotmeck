" Figure out the system Python for Neovim.
if exists("$VIRTUAL_ENV")
    let g:python3_host_prog="/Users/meck/.virtualenvs/neovim3/bin/python"
    let g:python_host_prog="/Users/meck/.virtualenvs/neovim2/bin/python"
endif

" This stops autoindent from moving all # Comments to first row
inoremap # X#
