-- ~/.config/nvim/init.lua
--
-- 最小構成のNeovim設定。プラグインマネージャーは導入しない。
-- 基本オプション設定とキーマップのみを扱う。
--
-- WSLのクリップボード連携（win32yank）は別ステップで対応予定のため、
-- ここでは一般的なvim標準オプションの範囲に留める。

local opt = vim.opt

-- 見た目
opt.number = true -- 行番号を表示
opt.relativenumber = true -- 相対行番号を表示
opt.termguicolors = true -- 24bitカラーを有効化
opt.cursorline = true -- カーソル行をハイライト
opt.signcolumn = "yes" -- サインカラムを常に表示（表示のガタつき防止）

-- インデント
opt.expandtab = true -- タブをスペースに変換
opt.tabstop = 2 -- タブ幅
opt.shiftwidth = 2 -- インデント幅
opt.smartindent = true -- 新しい行のインデントを自動調整

-- 検索
opt.ignorecase = true -- 検索時に大文字小文字を無視
opt.smartcase = true -- 大文字を含む場合は区別する

-- 編集
opt.clipboard = "unnamedplus" -- OSのクリップボードとレジスタを共有
opt.mouse = "a" -- マウス操作を有効化
opt.splitright = true -- 垂直分割時に右側へ新しいウィンドウを開く
opt.splitbelow = true -- 水平分割時に下側へ新しいウィンドウを開く
opt.undofile = true -- 永続的なundo履歴を保持
opt.scrolloff = 8 -- カーソル上下の余白行数

-- キーマップ
vim.g.mapleader = " "

local map = vim.keymap.set

-- 保存・終了
map("n", "<leader>w", "<cmd>write<cr>", { desc = "保存" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "終了" })

-- ウィンドウ移動
map("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ移動" })
map("n", "<C-j>", "<C-w>j", { desc = "下のウィンドウへ移動" })
map("n", "<C-k>", "<C-w>k", { desc = "上のウィンドウへ移動" })
map("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ移動" })

-- 検索ハイライトの解除
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "検索ハイライト解除" })
