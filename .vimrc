set number "行番号を表示する set title "編集中のファイル名を表示
set showmatch "括弧入力時の対応する括弧を表示
set tabstop=4 "インデントをスペース4つ分に設定
set cursorline
set hlsearch
set wildmenu
set wildmode=full
set laststatus=2
set ignorecase "大文字/小文字の区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る
set clipboard=unnamed,autoselect "クリップボードの有効化
set ambiwidth=double " □や○文字が崩れる問題を解決

"余計なファイルを作成しない
set noswapfile
set nobackup
set noundofile

set fileencodings=utf-8
set laststatus=2
set fileformats=unix,dos,mac

set expandtab "タブ入力を複数の空白入力に置き換える
set tabstop=2 "画面上でタブ文字が占める幅
set shiftwidth=2 "自動インデントでずれる幅
set softtabstop=2 "連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent "改行時に前の行のインデントを継続する
set smartindent "改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set incsearch

nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

" setting of copy & paster
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
      set paste
      return a:ret
    endfunction

  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif
" changed leader key to space
let mapleader = " "
" F3でハイライトの設定
nnoremap <C-c> :set hlsearch!<CR>

" スペース + wでファイル保存
nnoremap <Leader>w :w<CR>

nnoremap <Leader>q :q<CR>
" スペース + . でvimrcを開く
nnoremap <Leader>. :new ~/.vimrc<CR>

set list
set listchars=tab:>-

if has('persistent_undo')
  let undo_path = expand('~/.vim/undo')
    exe 'set undodir=' .. undo_path
    set undofile
endif
"dein Scripts-----------------------------:u
if &compatible
  set nocompatible               " Be iMproved
endif

" dein.vimインストール時に指定したディレクトリをセット
let s:dein_dir = expand('~/.cache/dein')

" dein.vimの実体があるディレクトリをセット
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
" dein.vimが存在していない場合はgithubからclone
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif
" dein.vimインストール時に指定したディレクトリをセット
let s:dein_dir = expand('~/.cache/dein')

" dein.vimの実体があるディレクトリをセット
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  " dein.toml, dein_layz.tomlファイルのディレクトリをセット
  let s:toml_dir = expand('~/dotfiles/vim')

  " 起動時に読み込むプラグイン群
  call dein#load_toml(s:toml_dir . '/dein.toml', {'lazy': 0})

  " 遅延読み込みしたいプラグイン群
  call dein#load_toml(s:toml_dir . '/dein_lazy.toml', {'lazy': 1})
  " Add or remove your plugins here like this:
  "call dein#add('Shougo/neosnippet.vim')
  "call dein#add('Shougo/neosnippet-snippets')
  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
"End dein Scripts-------------------------
let g:wakatime_PythonBinary = '/usr/bin/python'  " (Default: 'python')

"setting about lsp{{{
if empty(globpath(&rtp, 'autoload/lsp.vim'))
  finish
endif

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nnoremap <buffer> gd :<C-u>LspDefinition<CR>
  nnoremap <buffer> gD :<C-u>LspReferences<CR>
  nnoremap <buffer> gs :<C-u>LspDocumentSymbol<CR>
  nnoremap <buffer> gS :<C-u>LspWorkspaceSymbol<CR>
  nnoremap <buffer> gQ :<C-u>LspDocumentFormat<CR>
  vnoremap <buffer> gQ :LspDocumentRangeFormat<CR>
  nnoremap <buffer> K :<C-u>LspHover<CR>
  inoremap <expr> <cr> pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    augroup END
command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1
let g:asyncomplete_popup_delay = 200

" color scheme
colorscheme onedark
let g:onedark_termcolors=256

" settings of airline{{{
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#wordcount#enabled = 0
let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'y', 'z']]
let g:airline_section_c = '%t'
let g:airline_section_x = '%{&filetype}'
let g:airline_theme='onedark'
"let g:airline#extensions#ale#enabled = 1
"let g:airline_section_z = '%3l:%2v %{airline#extensions#ale#get_warning()} %{airline#extensions#ale#get_error()}'
"let g:airline#extensions#ale#open_lnum_symbol = '('
"let g:airline#extensions#ale#close_lnum_symbol = ')'

let g:airline#extensions#tabline#buffer_idx_format = {
  \ '0': '0 ',
  \ '1': '1 ',
  \ '2': '2 ',
  \ '3': '3 ',
  \ '4': '4 ',
  \ '5': '5 ',
  \ '6': '6 ',
  \ '7': '7 ',
  \ '8': '8 ',
  \ '9': '9 '
  \}
" }}}

" setting of nerdtree {{{
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
"}}}

" setting of buffer
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>

" setting for help
set helplang=ja

" setting of deoplete {{{
let g:deoplete#enable_at_startup = 1
" }}}

""" markdown {{{
  autocmd BufRead,BufNewFile *.mkd  set filetype=markdown
  autocmd BufRead,BufNewFile *.md  set filetype=markdown
  nnoremap <silent> <C-p> :PrevimOpen<CR>
  " 自動で折りたたまないようにする
  let g:vim_markdown_folding_disabled=1
  let g:previm_enable_realtime = 1
" }}}

""" sonictemplate{{{
  let g:sonictemplate_vim_template_dir = [
    \ '~/dotfiles/template'
  \]
"""}}}

"""setting of indenline{{{
  let g:indentLine_char_list = ['|', '¦', '┆', '┊']
"}}}

"setting of ale{{{
" ファイル保存時にLinterを実行する
"let g:ale_lint_on_save = 1
"" テキスト変更時にはLinterを実行しない
"let g:ale_lint_on_text_changed = 'never'
"" Linter(コードチェックツール)の設定
"let g:ale_linters = {
"\   'python': ['flake8', 'mypy'],
"\}
"" ファイル保存時にはFixerを時刻しない
"let g:ale_fix_on_save = 0
"" テキスト変更時にはFixerを実行しない
"let g:ale_fix_on_text_changed = 'never'
"" Fixer(コード整形ツール)の設定
"let b:ale_fixers = {
"\   'python': ['autopep8', 'isort'],
"\}
"" 余分な空白があるときは警告表示
"let b:ale_warn_about_trailing_whitespace = 0
"" ALE実行時にでる目印行を常に表示
"let g:ale_sign_column_always = 1
"
"let g:ale_echo_msg_format = '[%linter%]%code: %%s'
"
"}}}
"
"setting of gitgutter{{{
"" 目印行を常に表示する
if exists('&signcolumn')  " Vim 7.4.2201
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif
"}}}
