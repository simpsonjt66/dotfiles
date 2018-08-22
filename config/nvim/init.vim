call plug#begin('~/.nvim/bundle')

Plug 'airblade/vim-gitgutter'
Plug 'chriskempson/base16-vim'
Plug 'jgdavey/tslime.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf.vim'
Plug 'ngmy/vim-rubocop'
Plug 'roxma/nvim-yarp'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'thoughtbot/vim-rspec'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-rails'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-ruby/vim-ruby'
Plug '~/.fzf'

call plug#end()

let g:deoplete#enable_at_startup = 1
"
"--------------------------------------------------
"     Airline
"--------------------------------------------------
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" let g:rehash256 = 1
let g:airline#extensions#tabline#enabled = 1 "enable airline tabline
let g:airline#extensions#tabline#tab_min_count = 2 "only show tabline if tabs are being used
let g:airline#extensions#tabline#show_buffers = 0 "do not show open buffers
let g:airline#extensions#tabline#show_splits = 0

" Settings
" ----------------------------------------------------
set backupdir=~/.tmp
set directory=~/.tmp    "Keeps all the temp files out of the directory
set encoding=utf-8
set expandtab
set fillchars+=vert:│
set history=500 " keep 50 lines of command line history
set hlsearch
set incsearch " do incremental searching
set laststatus=2        "Always show status bar
set list
set listchars=tab:‣\ ,eol:¬
set noshowmode
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
set viminfo+=!
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

highlight VertSplit none

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
  autocmd BufWritePre  * %s/\s\+$//e
augroup end

" ----------------------------------------------------
" Mouse related goodies
" ----------------------------------------------------
set mouse+=a

if &term =~ '^screen'
  " tmux knows the extended mouse mode
  set ttymouse=xterm2
endif

"-------------------------------------------------------------
"               Colorscheme
"------------------------------------------------------------
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Mappings
" ----------------------------------------------------
map <C-p> :Files<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Vim-rspec settings
"---------------------------------------------------------------------------

" Outputs rspec test in other tmux pane
let g:rspec_command = 'call Send_to_Tmux("bin/rspec {spec}\n")'

map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
map <Leader>f :call RunFailingSpecs()<CR>
map <Leader>ff :call RunFastFailingSpecs()<CR>
map <Leader>u :call RunUnitTests()<CR>

function! RunFailingSpecs() abort
  let s:rspec_command = substitute(g:rspec_command, "{spec}", "--only-failures", "g")
  execute s:rspec_command
endfunction

function! RunFastFailingSpecs() abort
  let s:rspec_command = substitute(g:rspec_command, "{spec}", "--only-failures --fail-fast", "g")
  execute s:rspec_command
endfunction

function! RunUnitTests() abort
  let s:rspec_command = substitute(g:rspec_command, "{spec}", "--tag ~@js", "g")
  execute s:rspec_command
endfunction
