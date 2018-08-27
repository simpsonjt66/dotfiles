" Automatic, language-dependant indentation, syntax coloring and other
" functionality
filetype indent plugin on
syntax on

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
Plug 'scrooloose/nerdtree'
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

"--------------------------------------------------
" File type specific settings
"--------------------------------------------------

augroup myfiletypes
  " clear old autocmds in group
  autocmd!
  " Ruby
  " Autoindent with two spaces, always expand tabs
  autocmd FileType ruby,eruby,yaml setlocal ai sw=2 sts=2 et
  autocmd FileType ruby,eruby,yaml setlocal path+=lib
  autocmd Filetype ruby,eruby,yaml setlocal colorcolumn=80
  " Make ?s part of the word
  autocmd FileType ruby,eruby,yaml setlocal iskeyword+=?

  " Remove trailing whitespace on save for ruby files.
  autocmd BufWritePre  * %s/\s\+$//e

  " Markdown
  autocmd FileType markdown setlocal ai sw=2 sts=2 et
  autocmd FileType markdown setlocal colorcolumn=80
  autocmd FileType markdown setlocal textwidth=80
  autocmd Filetype markdown setlocal spell
  autocmd Filetype markdown setlocal spelllang=en_ca

  " Git commit messages
  autocmd FileType gitcommit setlocal spell
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
noremap! <Leader>i gg=G<C-o><C-o>zz
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

source $HOME/.nvim/plugin/settings.vim

"--------------------------------------------------
"     fzf
"--------------------------------------------------
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case  --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

