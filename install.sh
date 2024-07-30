#!/bin/bash

# 実行している環境を判定する
IS_MACOS=""
IS_WSL=""
IS_LINUX=""
if [[ "$(uname)" == "Darwin" ]]; then
    IS_MACOS="true"
elif [[ "$(uname -a)" == *"Microsoft"* ]]; then
    IS_WSL="true"
else
    IS_LINUX="true"
fi

# dotfilesのディレクトリ
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# VSCodeの設定ファイルと拡張機能のリストの場所
VSCODE_SETTINGS="$DOTFILES_DIR/vscode/settings.json"
VSCODE_EXTENSIONS="$DOTFILES_DIR/vscode/extensions-list.txt"

# OSごとに追加する設定ファイルを分ける
if [[ $IS_MACOS ]]; then
    ln -sfv "$VSCODE_SETTINGS" ~/Library/Application\ Support/Code/User/settings.json
elif [[ $IS_WSL ]]; then
    ln -sfv "$VSCODE_SETTINGS" ~/.vscode-server/data/Machine/settings.json
    ln -sfv "$DOTFILES_DIR/.bashrc" ~
elif [[ $IS_LINUX ]]; then
    ln -sfv "$VSCODE_SETTINGS" ~/.config/Code/User/settings.json
    ln -sfv "$DOTFILES_DIR/.bashrc" ~
fi

# VSCodeがインストールされているか確認して、拡張機能をインストール
if command -v code &> /dev/null; then
    cat "$VSCODE_EXTENSIONS" | xargs -L 1 code --install-extension
else
    echo "VSCode is not installed. Skipping extension installation."
fi

# 他のセットアップやインストールコマンドをここに追加
git config --global user.name "SilkZwx"
git config --global user.email "SilkZwx@users.noreply.github.com"

# dotfiles リポジトリのディレクトリ
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 既存の .bashrc をバックアップする
if [ -f "$HOME/.bashrc" ]; then
    mv "$HOME/.bashrc" "$HOME/.bashrc.backup"
fi

# dotfiles リポジトリの .bashrc をホームディレクトリにコピーする
cp "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"

# シェルを再読み込みする
source "$HOME/.bashrc"

echo "Dotfiles installation complete!"

