#!/bin/bash

# パスワードファイルのパス
DECRYPTED_FILE="passwords.txt"
ENCRYPTED_FILE="passwords.txt.gpg"

# パスワードを追加する関数
add_password() {
    # 共通鍵暗号をユーザーに入力させる
    echo "暗号化のためのパスフレーズを入力してください:"
    read -s passphrase #画面に表示しない

    echo "サービス名を入力してください:"
    read service
    echo "ユーザー名を入力してください:"
    read username
    echo "パスワードを入力してください:"
    read password

    # すでに暗号化されたファイルが存在すれば復号化
    if [ -f $ENCRYPTED_FILE ]; then
        gpg --yes --batch --passphrase $passphrase --output $DECRYPTED_FILE -d $ENCRYPTED_FILE 2>/dev/null
        ## 復号化に失敗した場合
        if ! gpg --yes --batch --passphrase $passphrase --output $DECRYPTED_FILE -d $ENCRYPTED_FILE 2>/dev/null; then
            echo "エラー: ファイルの復号化に失敗しました。パスフレーズを確認してください。"
            return
        fi
    fi

    # ファイルに情報を追加
    echo "$service,$username,$password" >> $DECRYPTED_FILE

    # ファイルを暗号化
    gpg --yes --batch --passphrase $passphrase -c $DECRYPTED_FILE 2>/dev/null
    rm $DECRYPTED_FILE

    echo "パスワードの追加は成功しました。"
}

# パスワードを取得する関数
get_password() {
    # 共通鍵暗号をユーザーに入力させる
    echo "暗号化されたファイルを復号するためのパスフレーズを入力してください:"
    read -s passphrase #画面に表示しない

    echo "サービス名を入力してください:"
    read service

    # ファイルの復号化
    gpg --yes --batch --passphrase $passphrase --output $DECRYPTED_FILE -d $ENCRYPTED_FILE 2>/dev/null
        ## 復号化に失敗した場合
        if ! gpg --yes --batch --passphrase $passphrase --output $DECRYPTED_FILE -d $ENCRYPTED_FILE 2>/dev/null; then
            echo "エラー: ファイルの復号化に失敗しました。パスフレーズを確認してください。"
            return
        fi

    # ファイルからパスワードを検索し表示
    found=0
    while IFS=, read -r serv user pass; do
        if [ "$serv" == "$service" ]; then
            echo "サービス名: $serv"
            echo "ユーザー名: $user"
            echo "パスワード: $pass"
            echo "" # 空行を追加
            found=1
        fi
    done < $DECRYPTED_FILE

    ## サービス名が保存されていなかった場合
    if [ $found -eq 0 ]; then
        echo "そのサービスは登録されていません。"
    fi

    # 一時ファイルを削除
    rm $DECRYPTED_FILE

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
