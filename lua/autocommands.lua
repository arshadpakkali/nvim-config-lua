vim.cmd([[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo,dap-float nnoremap <silent> <buffer> q :close<CR> | nnoremap <silent> <buffer> <esc> :close<CR>
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
	autocmd FileType help set rnu
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup _auto_resize
      autocmd!
      autocmd VimResized * tabdo wincmd =
  augroup end

  autocmd CursorMoved * set nohlsearch
  nnoremap n n:set hlsearch<cr>
]])
