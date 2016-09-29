set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'scrooloose/nerdtree'
Plugin 'JamshedVesuna/vim-markdown-preview'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'ervandew/supertab'
Plugin 'vim-ruby/vim-ruby'
Plugin 'ngmy/vim-rubocop'
Plugin 'thoughtbot/vim-rspec'
Plugin 'jgdavey/tslime.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-commentary'
Plugin 'kchmck/vim-coffee-script'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'

" All plugins must be loaded before this line
call vundle#end()            " required
filetype plugin indent on    " required

"Trigger configuration for ultisnip
let g:UltiSnipExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBacwardTrigger="<c-k>"
" Split the window for ultisnips edit
let g:UltiSnipsEditSplit="horizontal"
" Settings for vim-markdown-preview
let vim_markdown_preview_browser='Safari'
let vim_markdown_preview_github=1
let vim_markdown_preview_hotkey='<C-m>'
" Outputs rspec test in other tmux pane
let g:rspec_command = 'call Send_to_Tmux("zeus rspec {spec}\n")'

" airline-vim options
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
" let g:molokai_original = 1
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
syntax on

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

augroup end
	
colorscheme molokai	
set t_Co=256
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set backspace=indent,eol,start
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set backupdir=~/.tmp
set directory=~/.tmp    "Keeps all the temp files out of the directory
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set number
set laststatus=2        "Always show status bar
set shiftwidth=2        "Set indent to 2 spaces
set tabstop=2           "Set indent to 2 spaces
set relativenumber
set cursorline
set cursorcolumn
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

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
"if &t_Co > 2 || has("gui_running")
"  syntax on
"  set hlsearch
"endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

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


" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
"packadd matchit.
