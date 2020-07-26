call plug#begin('~/.vim/plugged')

"****** Syntax Highlighters ******
Plug 'mustache/vim-mustache-handlebars'
Plug 'lumiliet/vim-twig'
Plug 'kchmck/vim-coffee-script'
Plug 'jparise/vim-graphql'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'leafgarland/typescript-vim'
Plug 'jparise/vim-graphql'
Plug 'cakebaker/scss-syntax.vim'

"****** Other Plugins ******
" popes stuff
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
" nicer command bar
Plug 'itchyny/lightline.vim'
" allows access to entire undo history in a tree format (not linear)
Plug 'mbbill/undotree'
" git plugins
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
Plug 'airblade/vim-gitgutter'

" search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mattn/emmet-vim'
Plug 'nanotech/jellybeans.vim'

" distraction free writing
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/seoul256.vim'

function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
	let g:limelight_conceal_ctermfg = 240
	colorscheme seoul256
  Limelight
  " ...
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
	colorscheme jellybeans
  Limelight!
  " ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

call plug#end()

" undotree toggle
nnoremap <F5> :UndotreeToggle<CR>
" save undo info in specified location and allow it to persist
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile

" ****** Linting/Autocompletion ******
let g:coc_global_extensions = [
	\'coc-markdownlint',
	\'coc-highlight',
	\'coc-tsserver',
	\'coc-git',
	\'coc-json',
	\'coc-python',
	\'coc-phpls',
	\'coc-html',
	\'coc-css',
	\'coc-docker',
	\'coc-yaml',
	\'coc-xml',
	\'coc-emmet',
	\'coc-pairs',
	\'coc-snippets',
	\'coc-yank',
	\'coc-prettier',
	\'coc-sh'
	\]

" use tab for autocompletion rather than ctrl+p
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" ****** Themes ******
let g:lightline = {
		\	'colorscheme': 'jellybeans',
		\ 'active': {
		\ 'left': [ [ 'mode', 'paste' ],
		\					[ 'readonly', 'filename', 'modified', 'fugitive' ] ]
		\					},
		\ 'component': {
		\		'fugitive': '%{FugitiveStatusline()}'
		\ }
\}
set background=dark
colorscheme jellybeans
set t_Co=256

" ****** General ******
set autoindent
set relativenumber
set softtabstop=0 noexpandtab
set shiftwidth=2
set tabstop=2
set mouse=a
set noswapfile
set wildignore=*/.git/*,*/node_modules/*,*/dist/*,*/build/*
set ttimeoutlen=5
set smartcase
set ignorecase
set lazyredraw
" recognise tsx/ts files
au BufNewFile,BufRead *.ts setlocal filetype=typescript
au BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
"
" show cursorline on selected window only
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" ****** Netrw File Explorer ******
" open netrw file explorer with ctrl+n
map <C-n> :e .<CR>
" open netrw at the last opened location
let g:netrw_keepdir=0

" ****** Git ******
" Default to not read-only in vimdiff
set noro"
