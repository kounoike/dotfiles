" vim: set ts=4 sw=4 sts=0:
"-----------------------------------------------------------------------------

" 文字コード関連
"
if &encoding !=# 'utf-8'
        set encoding=japan
        set fileencoding=japan
endif
if has('iconv')
        let s:enc_euc = 'euc-jp'
        let s:enc_jis = 'iso-2022-jp'
        " iconvがeucJP-msに対応しているかをチェック
        if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
                let s:enc_euc = 'eucjp-ms'
                let s:enc_jis = 'iso-2022-jp-3'
        " iconvがJISX0213に対応しているかをチェック
        elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
                let s:enc_euc = 'euc-jisx0213'
                let s:enc_jis = 'iso-2022-jp-3'
        endif
        " fileencodingsを構築
        if &encoding ==# 'utf-8'
                let s:fileencodings_default = &fileencodings
                let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
                let &fileencodings = &fileencodings .','. s:fileencodings_default
                unlet s:fileencodings_default
        else
                let &fileencodings = &fileencodings .','. s:enc_jis
                set fileencodings+=utf-8,ucs-2le,ucs-2
                if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
                        set fileencodings+=cp932
                        set fileencodings-=euc-jp
                        set fileencodings-=euc-jisx0213
                        set fileencodings-=eucjp-ms
                        let &encoding = s:enc_euc
                        let &fileencoding = s:enc_euc
                else
                        let &fileencodings = &fileencodings .','. s:enc_euc
                endif
        endif
        " 定数を処分
        unlet s:enc_euc
        unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
        function! AU_ReCheck_FENC()
                if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
                        let &fileencoding=&encoding
                endif
        endfunction
"       autocmd BufReadPost * call AU_ReCheck_FENC()
        autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
        set ambiwidth=double
endif

"-----------------------------------------------------------------------------
set nocompatible

"-----------------------------------------------------------------------------
" プラグイン
" vim起動時のみruntimepathにneobundle.vimを追加
if has('vim_starting')
  set nocompatible
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

" neobundle.vimの初期化
call neobundle#begin(expand('~/.vim/bundle'))

" NeoBundleを更新するための設定
NeoBundleFetch 'Shougo/neobundle.vim'

" 読み込むプラグインを記載
"unite
NeoBundle 'Shougo/unite.vim'
NeoBundle 'ujihisa/unite-colorscheme'

" EditorConfig
NeoBundle 'editorconfig/editorconfig-vim'

"ステータスラインの拡張
NeoBundle 'itchyny/lightline.vim'
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ }

"Flake8を使う
NeoBundle 'Flake8-vim'
NeoBundle 'fisadev/vim-isort'

NeoBundle 'scrooloose/syntastic'
let g:syntastic_mode_map = {
            \ 'mode': 'active',
            \ 'active_filetypes': ['php', 'coffee', 'javascript', 'sh', 'vim'],
            \ 'passive_filetypes': ['html', 'haskell', 'python']
            \}
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_javascript_checkers = ['jshint']
let g:syntastic_coffee_checkers = ['coffeelint']
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

NeoBundleLazy 'hynek/vim-python-pep8-indent', {
    \ "autoload": {"insert": 1, "filetypes": ["python", "python3", "djangohtml"]}}

"" インデントを線で表示
" NeoBundle 'Yggdroot/indentLine'

" インデントを色で表示
NeoBundle 'nathanaelkane/vim-indent-guides'

" GVimのインスタンスを共有で使う
NeoBundle 'thinca/vim-singleton'

" if_luaが有効ならneocompleteを使う
NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache'

if neobundle#is_installed('neocomplete')
    " neocomplete用設定
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_ignore_case = 1
    let g:neocomplete#enable_smart_case = 1
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns._ = '\h\w*'
    " docstringは表示しない
    autocmd FileType python setlocal completeopt-=preview
elseif neobundle#is_installed('neocomplcache')
    " neocomplcache用設定
    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_enable_ignore_case = 1
    let g:neocomplcache_enable_smart_case = 1
    if !exists('g:neocomplcache_keyword_patterns')
        let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns._ = '\h\w*'
    let g:neocomplcache_enable_camel_case_completion = 1
    let g:neocomplcache_enable_underbar_completion = 1
endif
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

"-----------------------------------------------------------------------------
" カラースキーム
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'vim-scripts/pyte'
NeoBundle 'tomasr/molokai'

call neobundle#end()

" インストールのチェック
NeoBundleCheck

" 読み込んだプラグインも含め、ファイルタイプの検出、ファイルタイプ別プラグイン/インデントを有効化する
filetype plugin indent on

"Flake8-vimの設定
"保存時に自動でチェック
let g:PyFlakeOnWrite = 1
let g:PyFlakeCheckers = 'pep8,mccabe,pyflakes'
let g:PyFlakeDefaultComplexity=12


""""""""""""""""""""""""""""""
" 最後のカーソル位置を復元する
""""""""""""""""""""""""""""""
if has("autocmd")
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
endif

"最初の文字を入れたときから検索する
set incsearch

" 非表示文字の表示
set list
set listchars=tab:>-,trail:-

" CUIのカラースキームはデフォルト
colorscheme default             "gvim使用時はgvimrcを編集すること

"自動リロード
set autoread

"自動バックアップをしない
set nobackup
set noundofile
set encoding=utf-8
