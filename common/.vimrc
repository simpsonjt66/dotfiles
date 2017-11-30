"-----------------------------------------------------
"  Plugins
"-----------------------------------------------------

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'jiangmiao/auto-pairs'
Plugin 'jgdavey/tslime.vim'
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'
Plugin 'SirVer/ultisnips'
Plugin 'ervandew/supertab'
Plugin 'honza/vim-snippets'
Plugin 'godlygeek/tabular'
Plugin 'ngmy/vim-rubocop'
Plugin 'pangloss/vim-javascript'
Plugin 'thoughtbot/vim-rspec'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-endwise'
Plugin 'nanotech/jellybeans.vim'
Plugin 'valloric/youcompleteme'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-syntastic/syntastic'

" All plugins must be loaded before this line
call vundle#end()           

filetype plugin indent on    

"-------------------------------------------------------------               
"               Colorscheme
"------------------------------------------------------------
set t_Co=256
syntax enable
set background=dark
colorscheme jellybeans

"--------------------------------------------------
"     Ultisnips, YouCompleteMe & SuperTab
"--------------------------------------------------
let g:ycm_key_list_select_completion   = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<C-p>', '<Up>']

let g:SuperTabDefaultCompletionType    = '<C-n>'

let g:UltiSnipsExpandTrigger           = '<tab>'
let g:UltiSnipsJumpForwardTrigger      = '<tab>'
let g:UltiSnipsJumpBackwardTrigger     = '<s-tab>'

let g:UltiSnipsEditSplit               = "horizontal"
"
let g:UltiSnipsSnippetDirectories      = ['my-snippets']
let g:UltiSnipsSnippetsDir             = '~/.vim/my-snippets'

"--------------------------------------------------
"     Syntastic
"--------------------------------------------------
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 1
let g:syntastic_check_on_open            = 0
let g:syntastic_check_on_wq              = 0
let g:syntastic_javascript_checkers      = [ 'eslint' ]
let g:syntastic_scss_checkers            = [ 'sass-lint' ]
let g:syntastic_sass_sass_args           = '-I ' . getcwd()

"--------------------------------------------------
"     Airline
"--------------------------------------------------
" let g:airline_powerline_fonts = 1

" if !exists('g:airline_symbols')
"   let g:airline_symbols = {}
" endif

" let g:airline_symbols.space = "\ua0"

" let g:rehash256 = 1
" let g:airline_left_sep=''
" let g:airline_right_sep=''
" let g:airline#extensions#tabline#enabled = 1 "enable airline tabline
" let g:airline#extensions#tabline#tab_min_count = 2 "only show tabline if tabs are being used
" let g:airline#extensions#tabline#show_buffers = 0 "do not show open buffers
" let g:airline#extensions#tabline#show_splits = 0

"--------------------------------------------------
" Ruby Stuff
"--------------------------------------------------
augroup myfiletypes
  autocmd!  
  " clear old autocmds in group
  "autoindent with two spaces, always indent tabs
  autocmd FileType ruby,eruby,yaml setlocal autoindent shiftwidth=2 softtabstop=2 expandtab
  autocmd FileType ruby,eruby,yaml setlocal path+=lib
  autocmd Filetype ruby,eruby,yaml setlocal colorcolumn=80
  " make ?s part of the word
  autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?
  " Remove trailing whitespace on save for ruby files.
  autocmd BufWritePre *.rb :%s/\s\+$//e

  " Text
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

  " Markdown
  autocmd FileType markdown setlocal ai sw=2 sts=2 et
  autocmd FileType markdown setlocal colorcolumn=80
  autocmd FileType markdown setlocal textwidth=80
  autocmd Filetype markdown setlocal spell
  autocmd Filetype markdown setlocal spelllang=en_ca

  " Javascript
  autocmd FileType javascript setlocal ai sw=2 sts=2 et

  " Git commit messages
  autocmd FileType gitcommit setlocal spell

augroup end

set autoread
set autoindent
set backspace=indent,eol,start
set backupdir=~/.tmp
set directory=~/.tmp    "Keeps all the temp files out of the directory
set expandtab
set hlsearch
set history=500 " keep 50 lines of command line history
set incsearch " do incremental searching
set laststatus=2        "Always show status bar
set list
set listchars=tab:‣\ ,eol:¬
set nowrap
set number
set relativenumber
set ruler    " show the cursor position all the time
set shiftwidth=2        "Set indent to 2 spaces
set showcmd    " display incomplete commands
set showmatch  " jumps to matching bracket
set smarttab
set softtabstop=2
set splitright
set wildmenu
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set viminfo+=!

hi cursorline cterm=underline gui=underline ctermbg=none

" Don't use Ex mode, use Q for formatting
map Q gq

"     vim-rspec settings
"---------------------------------------------------------------------------

" Outputs rspec test in other tmux pane
let g:rspec_command = 'call Send_to_Tmux("bin/rspec {spec}\n")'

map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
map <Leader>f :call RunFailingSpecs()<CR>
map <Leader>ff :call RunFastFailingSpecs()<CR>

function! RunFailingSpecs() abort
  let s:rspec_command = substitute(g:rspec_command, "{spec}", "--only-failures", "g")
  execute s:rspec_command
endfunction

function! RunFastFailingSpecs() abort
  let s:rspec_command = substitute(g:rspec_command, "{spec}", "--only-failures --fail-fast", "g")
  execute s:rspec_command
endfunction

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
if executable('rg')
  " Use rg over grep
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" bind K to grep word under the cursor
nnoremap K :silent! grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
"packadd matchit.

"    Mappings
"---------------------------------------------------------
map <Leader>vi :tabe ~/.vimrc<CR>
map <Leader>gw :!git add . && git commit -m 'WIP' && git push <cr>
map <Leader>i mmgg=G'm
map <Leader>bp obinding.pry<esc>:w<cr>
map <C-p> :Files<CR>
