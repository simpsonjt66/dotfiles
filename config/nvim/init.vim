call plug#begin('~/.nvim/bundle')

Plug 'airblade/vim-gitgutter'
Plug 'chriskempson/base16-vim'
Plug 'honza/vim-snippets'
Plug 'jgdavey/tslime.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'ngmy/vim-rubocop'
Plug 'roxma/nvim-yarp'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'SirVer/ultisnips'
Plug 'thoughtbot/vim-rspec'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-ruby/vim-ruby'
Plug 'wincent/ferret'

call plug#end()

let g:deoplete#enable_at_startup = 1

"--------------------------------------------------
"     Airline
"--------------------------------------------------
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline#extensions#tabline#enabled = 1 "enable airline tabline
let g:airline#extensions#tabline#tab_min_count = 2 "only show tabline if tabs are being used
let g:airline#extensions#tabline#show_buffers = 0 "do not show open buffers
let g:airline#extensions#tabline#show_splits = 0

" ----------------------------------------------------
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
set termguicolors  " use guifg/guibg instead of ctermfg/ctermbg in terminal
set viminfo+=!
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

highlight VertSplit none

"--------------------------------------------------
" Ruby Stuff
"--------------------------------------------------
syntax on  " Enable syntax highlighting

augroup myfiletypes
  " clear old autocmds in group
  autocmd!
  " Autoindent with two spaces, always expand tabs
  autocmd FileType ruby,eruby,yaml setlocal ai sw=2 sts=2 et
  autocmd FileType ruby,eruby,yaml setlocal path+=lib
  autocmd Filetype ruby,eruby,yaml setlocal colorcolumn=80
  " Make ?s part of the word
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

" ----------------------------------------------------
"                Mappings
" ----------------------------------------------------
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

map <Leader>vi :tabe ~/.config/nvim/init.vim<CR>
map <Leader>gw :!git add . && git commit -m 'WIP:' && git push --no-verify <cr>
map <Leader>i mmgg=G'm
map <Leader>bpr obinding.remote_pry<esc>:w<cr>
map <Leader>bp obinding.pry<esc>:w<cr>
map <C-p> :Files<CR>

nmap <C-e> :UltiSnipsEdit<CR>

"---------------------------------------------------------------------------
"                 Vim-rspec settings
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

"--------------------------------------------------
"     Ultisnips
"--------------------------------------------------
let g:UltiSnipsExpandTrigger           = '<tab>'
let g:UltiSnipsJumpForwardTrigger      = '<tab>'
let g:UltiSnipsJumpBackwardTrigger     = '<s-tab>'

"--------------------------------------------------
" The Silver Searcher
"--------------------------------------------------
if executable('rg')
  " Use rg over grep
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

nnoremap K :silent! grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

"--------------------------------------------------
"     fzf
"--------------------------------------------------
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case  --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
