#!/bin/bash

# データファイルのパス
DATA_FILE="./data.txt"

# ポート番号
PORT=8000

# レスポンスを返す関数
function respond {
    # HTTPレスポンスヘッダー
    echo -e "HTTP/1.1 200 OK\r\nContent-Length: ${#response}\r\nContent-Type: text/plain\r\n\r\n"
    # HTTPレスポンスボディー
    echo -e "${response}\r\n"
}

# データを作成する関数
function create_data {
    # リクエストボディーからデータを取得する
    data=$(awk '/^\r?$/{body=1;next} body' <&3)

    # データをファイルに追記する
    echo "$data" >> $DATA_FILE

    # レスポンスを生成する
    response="Data created"
}

# データを読み取る関数
function read_data {
    # データをファイルから読み込む
    data=$(cat $DATA_FILE)

    # レスポンスを生成する
    response="$data"
}

# データを更新する関数
function update_data {
    # リクエストボディーからデータを取得する
    data=$(awk '/^\r?$/{body=1;next} body' <&3)

    # ファイルの内容をデータで置き換える
    echo "$data" > $DATA_FILE

    # レスポンスを生成する
    response="Data updated"
}

# データを削除する関数
function delete_data {
    # ファイルを削除する
    rm $DATA_FILE

    # レスポンスを生成する
    response="Data deleted"
}

trap exit INT

while true; do
# netcatでHTTPリクエストを待ち受ける
res=$(nc -l $PORT | (
    # HTTPリクエストの最初の行を読み込む
    read request

    # HTTPリクエストがGETメソッドかどうかをチェックする
    if echo "$request" | grep -q "GET"; then
        # データを読み取る
        read_data
        respond
    fi

    # HTTPリクエストがPOSTメソッドか
	    if echo "$request" | grep -q "POST"; then
        # データを作成する
        create_data
        respond
    fi

    # HTTPリクエストがPUTメソッドかどうかをチェックする
    if echo "$request" | grep -q "PUT"; then
        # データを更新する
        update_data
        respond
    fi

    # HTTPリクエストがDELETEメソッドかどうかをチェックする
    if echo "$request" | grep -q "DELETE"; then
        # データを削除する
        delete_data
        respond
    fi
)
)
echo $res
done

