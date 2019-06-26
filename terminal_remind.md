# terminal short cut
short cut       | function
----------------|:--------
ctrl + u        | 從游標處向前刪除指令串
ctrl + k        | 從游標處向後刪除指令串
ctrl + a        | 移動游標到行首
ctrl + e        | 移動游標到行尾
ctrl + w        | 刪除一個word
ctrl + y        | paste the words deleted by ctrl + u/k/w
ctrl + p        | 顯示上一個指令
ctrl + r        | 在歷史裡搜尋指令
alt + .         | 上個命令後面的參數
ctrl + c        | 中斷執行
ctrl + d        | 中斷輸入
ctrl + z        | 暫停執行
!!              | 執行上一個指令
!-N             | 執行上 N 個指令
!N              | 執行 history 裡編號 N 的指令
!ps             | 執行上一個以 ps 開頭的指令
!$              | 上一個指令的最後一個參數
!^              | 上一個指令的第 1 個參數(指令後的)
!*              | 上一個指令的所有參數
!:N             | 上一個指令的第 N 個參數
!ls:2           | 上一個以 ls 開頭的指令的第 2 個參數
sudo !!         | 用 sudo 來執行上個指令