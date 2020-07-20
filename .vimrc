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
" tidy up long lines of code by moving single lines to multi lines
Plug 'AndrewRadev/splitjoin.vim'
" nicer command bar
Plug 'itchyny/lightline.vim'
" fuzzy finding - not necessary, will set this up without plugin soon
Plug 'ctrlpvim/ctrlp.vim'
" allows access to entire undo history in a tree format (not linear)
Plug 'mbbill/undotree'
" git plugins
Plug 'tpope/vim-fugitive'
Plug 'rbong/vim-flog'
Plug 'airblade/vim-gitgutter'

" search
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'mattn/emmet-vim'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'morhetz/gruvbox'
Plug 'nanotech/jellybeans.vim'
Plug 'chriskempson/base16.vim'
Plug 'dense-analysis/ale'

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

let g:ale_linters = {
			\	'typeScript': ['tsserver'],
			\	'javascript': ['tsserver'],
			\ 'php': ['langserver'],
			\ 'coffeescript': ['coffee'],
			\ 'scss': ['prettier'],
			\ 'yaml': ['prettier'],
			\}
let g:ale_fixers = {
			\ '*': ['remove_trailing_lines', 'trim_whitespace'],
			\ 'css': ['prettier'],
			\ 'less': ['prettier'],
			\	'scss': ['prettier'],
			\ 'yaml': ['prettier'],
			\ 'php': ['php_cs_fixer'],
			\ 'coffeescript': ['coffee'],
			\ 'json': ['eslint'],
			\ 'javascript': ['prettier'],
			\ 'typescript': ['prettier'],
			\ 'typescript.tsx': ['prettier'],
			\}
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
set omnifunc=ale#completion#OmniFunc
let g:ale_completion_tsserver_autoimport = 1
" shortcut gp for Ale Fix
nnoremap gp :ALEFix <CR>
" use tab for autocompletion rather than ctrl+p
function! InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<tab>"
	else
		return "\<c-p>"
	endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

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

" ****** Grep ******
" cycle through results quicker
nmap <silent> <C-N> :cn<CR>zv
nmap <silent> <C-P> :cp<CR>zv
" adjust quick fix window size
au FileType qf call AdjustWindowHeight(3, 30)
function! AdjustWindowHeight(minheight, maxheight)
	 let l = 1
	 let n_lines = 0
	 let w_width = winwidth(0)
	 while l <= line('$')
			 " number to float for division
			 let l_len = strlen(getline(l)) + 0.0
			 let line_width = l_len/w_width
			 let n_lines += float2nr(ceil(line_width))
			 let l += 1
	 endw
	 exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
endfunction
" open quick fix window by default
augroup autoquickfix
		autocmd!
		autocmd QuickFixCmdPost [^l]* cwindow
		autocmd QuickFixCmdPost    l* lwindow
augroup END

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
