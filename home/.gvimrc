" ウィンドウ位置の保存
let g:save_window_file = expand('~/.vimwinpos')
augroup SaveWindow
  autocmd!
  autocmd VimLeavePre * call s:save_window()
  function! s:save_window()
    let options = [
      \ 'set columns=' . &columns,
      \ 'set lines=' . &lines,
      \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
      \ ]
    call writefile(options, g:save_window_file)
  endfunction
augroup END

if filereadable(g:save_window_file)
  execute 'source' g:save_window_file
endif

"---------------------------------------------------------------------------
" 日本語入力に関する設定:
" 実質，Windowsでしか機能しません
if has('multi_byte_ime') || has('xim')
  " IME ON時のカーソルの色を設定(設定例:紫)
  highlight CursorIM guibg=Purple guifg=NONE
  " 挿入モード・検索モードでのデフォルトのIME状態設定
  set iminsert=0 imsearch=0
  " 挿入モードでのIME状態を記憶させない場合、次行のコメントを解除
  inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif

"---------------------------------------------------------------------------
" マウスに関する設定:
"
" 解説:
" mousefocusは幾つか問題(一例:ウィンドウを分割しているラインにカーソルがあっ
" ている時の挙動)があるのでデフォルトでは設定しない。Windowsではmousehide
" が、マウスカーソルをVimのタイトルバーに置き日本語を入力するとチラチラする
" という問題を引き起す。
"
" どのモードでもマウスを使えるようにする
set mouse=a
" マウスの移動でフォーカスを自動的に切替えない (mousefocus:切替る)
set nomousefocus
" 入力時にマウスポインタを隠す (nomousehide:隠さない)
set mousehide
" ビジュアル選択(D&D他)を自動的にクリップボードへ (:help guioptions_a)
"set guioptions+=a

"---------------------------------------------------------------------------
" 印刷に関する設定:
"
" 注釈:
" 印刷はGUIでなくてもできるのでvimrcで設定したほうが良いかもしれない。この辺
" りはWindowsではかなり曖昧。一般的に印刷には明朝、と言われることがあるらし
" いのでデフォルトフォントは明朝にしておく。ゴシックを使いたい場合はコメント
" アウトしてあるprintfontを参考に。
"
" 参考:
"   :hardcopy
"   :help 'printfont'
"   :help printing
"
"---------------------------------------------------------------------------
" 印刷用フォント
if has('printer')
  if has('win32')
    "set printfont=MS_Mincho:h12:cSHIFTJIS
    set printfont=MS_Gothic:h12:cSHIFTJIS
  endif
endif

"---------------------------------------------------------------------------
" フォント設定
if has('win32')
  " Windows用
  "set guifont=MS_Gothic:h12:cSHIFTJIS
  "set guifont=MS_Gothic:h12
  "set guifont=Consolas:h12,Lucida_Console:h12:w6 guifontwide=MS_Gothic:h12
  "set guifont=MS_Mincho:h12:cSHIFTJIS
  set guifont=Consolas:h14 guifontwide=MS_Gothic:h14
  " 行間隔の設定
  set linespace=1
  " 一部のUCS文字の幅を自動計測して決める
  if has('kaoriya')
    set ambiwidth=auto
  endif
endif


"---------------------------------------------------------------------------
let g:indent_guides_enable_on_vim_startup=1
"---------------------------------------------------------------------------
let g:solarized_termcolors=256
let g:solarized_termtrans=0
let g:solarized_degrade=0
let g:solarized_bold=1
let g:solarized_underline=1
let g:solarized_italic=0
let g:solarized_contrast='normal'
let g:solarized_visibility='normal'

" 行番号を表示
set number

" Lightテーマを使いたい
set background=light
colorscheme solarized

" gVimのインスタンスを一つに制限する
call singleton#enable()

source $VIMRUNTIME/delmenu.vim
set langmenu=ja_jp.utf-8
source $VIMRUNTIME/menu.vim

" キー割り当て
:map <C-TAB> :tabn<CR>

