#!/bin/bash

# パスワードファイルのパス
PASSWORD_FILE="passwords.txt"

echo "パスワードマネージャーへようこそ！"

echo "サービス名を入力してください:"
read service
echo "ユーザー名を入力してください:"
read username
echo "パスワードを入力してください:"
read password

# ファイルに情報を追加
echo "$service,$username,$password" >> $PASSWORD_FILE

echo "Thank you!"