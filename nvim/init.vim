let mapleader="\<Space>"
let maplocalleader="\\"
"
" Automatic, language-dependant indentation, syntax coloring and other
" functionality
filetype indent plugin on
syntax on

call plug#begin('~/.config/nvim/bundle')

Plug 'airblade/vim-gitgutter'
Plug 'godlygeek/tabular'
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
Plug 'chriskempson/base16-vim'
Plug 'vim-ruby/vim-ruby'
Plug 'wincent/ferret'
Plug 'w0rp/ale'

call plug#end()

let g:deoplete#enable_at_startup = 1

let g:ale_linters = { 'zsh': ['shellcheck'] }

"-------------------------------------------------------------
"               Colorscheme
"------------------------------------------------------------
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

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
  autocmd BufNewFile, BufReadPost *.md set filetype=markdown
  autocmd FileType markdown setlocal ai sw=2 sts=2 et
  autocmd FileType markdown setlocal colorcolumn=80
  autocmd FileType markdown setlocal textwidth=80
  autocmd Filetype markdown setlocal spell
  autocmd Filetype markdown setlocal spelllang=en_ca

  " Git commit messages
  autocmd FileType gitcommit setlocal spell textwidth=72
augroup end

" ----------------------------------------------------
"  Allow syntax highlighting in Markdown fenced code blocks
" ----------------------------------------------------

let g:markdown_fenced_languages = ['html', 'ruby', 'javascript']
" ----------------------------------------------------
" Mouse related goodies
" ----------------------------------------------------
set mouse+=a

" if &term =~ '^screen'
"   " tmux knows the extended mouse mode
"   set ttymouse=xterm2
" endif

" ----------------------------------------------------
"                Mappings
" ----------------------------------------------------
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nmap <LocalLeader>vi :tabe ~/.config/nvim/init.vim<CR>
nmap <Leader>gw :!git add . && git commit -m 'WIP:' && git push --no-verify <cr>
nmap <LocalLeader>i gg=G<C-o><C-o>zz
nmap <LocalLeader>bpr obinding.remote_pry<esc>:w<cr>
nmap <LocalLeader>bp obinding.pry<esc>:w<cr>
" converts local variable to let in RSpec
nmap <LocalLeader>vtl ^ysiw)Iletf(a:f=2xv$hS{

nmap <Leader>p :Files<CR>
nmap <Leader>h :Helptags<CR>
nmap <Leader>c :History:<CR>
nmap <Leader>t :Tags<CR>:w

nmap <C-e> :UltiSnipsEdit<CR>

let g:vimrubocop_keymap = 0
nmap <LocalLeader>ru :RuboCop<CR>

"---------------------------------------------------------------------------
"                 Vim-rspec settings
"---------------------------------------------------------------------------

" Outputs rspec test in other tmux pane
let g:rspec_command = 'call Send_to_Tmux("bin/rspec {spec}\n")'

map <LocalLeader>t :call RunCurrentSpecFile()<CR>
map <LocalLeader>s :call RunNearestSpec()<CR>
map <LocalLeader>l :call RunLastSpec()<CR>
map <LocalLeader>a :call RunAllSpecs()<CR>
map <LocalLeader>f :call RunFailingSpecs()<CR>
map <LocalLeader>ff :call RunFastFailingSpecs()<CR>
map <LocalLeader>u :call RunUnitTests()<CR>

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
let g:UltiSnipsEditSplit               = 'horizontal'

let g:UltiSnipsSnippetDirectories      = ['private-snippets']
let g:UltiSnipsSnippetsDir             = '~/dotfiles/config/nvim/private-snippets'
"--------------------------------------------------
" The Silver Searcher
"--------------------------------------------------
if executable('rg')
  " Use rg over grep
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

