#!/bin/bash

# パスワードファイルのパス
PASSWORD_FILE="passwords.txt"

# パスワードを追加する関数
add_password() {

    echo "サービス名を入力してください:"
    read service
    echo "ユーザー名を入力してください:"
    read username
    echo "パスワードを入力してください:"
    read password

    # ファイルに情報を追加
    echo "$service,$username,$password" >> $PASSWORD_FILE

    echo "パスワードの追加は成功しました。"
}

# パスワードを取得する関数
get_password() {

    echo "サービス名を入力してください:"
    read service

    # ファイルからパスワードを検索し表示
    found=0
    while IFS=, read -r serv user pass; do
        if [ "$serv" == "$service" ]; then
            echo "サービス名: $serv"
            echo "ユーザー名: $user"
            echo "パスワード: $pass"
            found=1
        fi
    done < $PASSWORD_FILE

    ## サービス名が保存されていなかった場合
    if [ $found -eq 0 ]; then
        echo "そのサービスは登録されていません。"
    fi

}

# メインループ
echo "パスワードマネージャーへようこそ！"
while true; do
    echo "次の選択肢から入力してください(Add Password/Get Password/Exit)："
    read option
    case $option in
        "Add Password") # Add Password が入力された場合
            add_password
            ;;
        "Get Password") # Get Password が入力された場合
            get_password
            ;;
        "Exit") # Exit が入力された場合
            echo "Thank you!"
            exit 0 ## プログラムが終了
            ;;
        *) # Add Password/Get Password/Exit 以外が入力された場合
            echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
            ;;
    esac
done