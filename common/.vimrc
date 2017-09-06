"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle Stuff
" """""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'jgdavey/tslime.vim'
Plugin 'JamshedVesuna/vim-markdown-preview'
Plugin 'SirVer/ultisnips'
Plugin 'airblade/vim-gitgutter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'ervandew/supertab'
Plugin 'honza/vim-snippets'
Plugin 'kchmck/vim-coffee-script'
Plugin 'ngmy/vim-rubocop'
Plugin 'pangloss/vim-javascript'
Plugin 'thoughtbot/vim-rspec'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'nanotech/jellybeans.vim'
Plugin 'valloric/youcompleteme'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-syntastic/syntastic'
Plugin 'viniciusban/vim-github-colorscheme'
" All plugins must be loaded before this line
call vundle#end()           

filetype plugin indent on    
syntax on
colorscheme jellybeans

"Default Trigger configuration for ultisnip before adding YCM
" let g:UltiSnipExpandTrigger="<tab>"
" let g:UltiSnipsListSnippets="<c-tab>"
" let g:UltiSnipsJumpForwardTrigger="<c-j>"
" let g:UltiSnipsJumpBacwardTrigger="<c-k>"

" NEW Ultisnips configuration after adding YCM
" (via http://stackoverflow.com/a/22253548/1626737)
let g:SuperTabDefaultCompletionType    = '<C-n>'
let g:SuperTabCrMapping                = 0
let g:UltiSnipsExpandTrigger           = '<tab>'
let g:UltiSnipsJumpForwardTrigger      = '<tab>'
let g:UltiSnipsJumpBackwardTrigger     = '<s-tab>'
let g:ycm_key_list_select_completion   = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<C-p>', '<Up>']

" Split the window for ultisnips edit
let g:UltiSnipsEditSplit="horizontal"
"
" Added as a workaround for UltiSnips Edit in wrong directory
let g:UltiSnipsSnippetDirectories= ['my-snippets']
let g:UltiSnipsSnippetsDir='~/.vim/my-snippets'

" Settings for vim-markdown-preview
let vim_markdown_preview_browser='Safari'
let vim_markdown_preview_github=1
let vim_markdown_preview_hotkey='<Leader>m'
"
" Outputs rspec test in other tmux pane
let g:rspec_command = 'call Send_to_Tmux("bin/rspec {spec}\n")'

" Settings for syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = [ 'eslint' ]
let g:syntastic_scss_checkers = [ 'sass-lint' ]
let g:syntastic_sass_sass_args     = '-I ' . getcwd()

" airline-vim options
" let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

let g:airline_symbols.space = "\ua0"

let g:rehash256 = 1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#tabline#enabled = 1 "enable airline tabline
let g:airline#extensions#tabline#tab_min_count = 2 "only show tabline if tabs are being used
let g:airline#extensions#tabline#show_buffers = 0 "do not show open buffers
let g:airline#extensions#tabline#show_splits = 0

"=====================================================================
" Ruby Stuff
" ====================================================================
augroup myfiletypes
	"clear old autocmds in group
	autocmd!
	"autoindent with two spaces, always indent tabs
	autocmd FileType ruby,eruby,yaml setlocal ai sw=2 sts=2 et
	autocmd FileType ruby,eruby,yaml setlocal path+=lib
	autocmd Filetype ruby,eruby,yaml setlocal colorcolumn=80
	" make ?s part of the word
	autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?

	"markdown
	autocmd FileType markdown setlocal ai sw=2 sts=2 et
	autocmd FileType markdown setlocal colorcolumn=80
	autocmd FileType markdown setlocal textwidth=80
	autocmd Filetype markdown setlocal spell
	autocmd Filetype markdown setlocal spelllang=en_ca

	" Javascript
	autocmd FileType javascript setlocal ai sw=2 sts=2 et

augroup end

set backspace=indent,eol,start
set backupdir=~/.tmp
set cursorcolumn
set cursorline
set directory=~/.tmp    "Keeps all the temp files out of the directory
set history=50		" keep 50 lines of command line history
set incsearch		" do incremental searching
set laststatus=2        "Always show status bar
set list
set listchars=tab:‣\ ,eol:¬
set number
set relativenumber
set ruler		" show the cursor position all the time
set shiftwidth=2        "Set indent to 2 spaces
set showcmd		" display incomplete commands
set splitright
set t_Co=256
set tabstop=2           "Set indent to 2 spaces
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
hi cursorline cterm=underline gui=underline ctermbg=none
"hi StatusLine ctermfg=17  ctermbg=yellow
" Don't use Ex mode, use Q for formatting
map Q gq
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" Remove trailing whitespace on save for ruby files.
au BufWritePre *.rb :%s/\s\+$//e

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set mouse+=a

if &term =~ '^screen'
	" tmux knows the extended mouse mode
	set ttymouse=xterm2
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
		au!

		" For all text files set 'textwidth' to 78 characters.
		autocmd FileType text setlocal textwidth=78

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid or when inside an event handler
		" (happens when dropping a file on gvim).
		autocmd BufReadPost *
					\ if line("'\"") >= 1 && line("'\"") <= line("$") |
					\   exe "normal! g`\"" |
					\ endif

	augroup END

else
	set smartindent
	set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
				\ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
	" Prevent that the langmap option applies to characters that result from a
	" mapping.  If unset (default), this may break plugins (but it's backward
	" compatible).
	set langnoremap
endif

" The Silver Searcher
if executable('ag')
	" Use ag over grep
	set grepprg=ag\ --nogroup\ --nocolor

	" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

	" ag is fast enough that CtrlP doesn't need to cache
	let g:ctrlp_use_caching = 0
endif

" bind K to grep word under the cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
"packadd matchit.
