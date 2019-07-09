function lsg()
{
    if [ $# = 1 ]; then
        ls -a | grep $1
    elif [ $# = 2 ]; then
        ls -a $1 | grep $2
    fi
}

function psg()
{
    if [ $# = 0 ]; then
        ps -aux
    elif [ $# = 1 ]; then
        ps -aux | grep $1
    fi
}
function ipinfo()
{
    if [ $# = 1 ]; then
        curl ipinfo.io/$1
    else
        curl ipinfo.io
    fi
}

function mem()
{
    ps aux | head -n1
    ps aux | grep $1 | grep -v grep | grep $1
    echo -n "$1 totally use memory "
    ps aux | grep $1 | grep -v grep | awk '{ total += $6; } END { print total/1024"MB" }'
}

function open()
{
    if [ $# != 2 ]; then
        echo "usage: open <host> <port>"
    else
        nc -zv $1 $2
    fi
}

trash_can="/tmp/recycle_bin"
function rm()
{
    [ -d $trash_can ] || mkdir $trash_can
    mv $@ $trash_can
    echo "moving $@ to $trash_can"
}

function rrm()
{
    /bin/rm -I $@    
}

function man2()
{
    URL="https://wangchujiang.com/linux-command/"
    [ -z $1 ] && (echo "please give a command as \$1"; exit)
    #ping -c1 -w 3 8.8.8.8 > /dev/null || (echo "Internet is not accessable"; return)
    res=`curl -s -o /dev/null/ $URL -w %{http_code}`
    [ 200 -ne $res ] && (echo "https://wangchujiang.com/linux-command is not accessable"; return)
    w3m ${URL}c/${1} | less
}

function rfc() {
    declare -A RFC=(            \
        ["arp"]="826"           \
        ["ipv4"]="791"          \
        ["ipv6"]="2460"         \
        ["icmp"]="792"          \
        ["udp"]="768"           \
        ["tcp"]="793"           \
    )
    URL='https://tools.ietf.org/html/'
    
    if [ -z $1 ]; then
        echo "please give a protocol or rfc number as \$1"
        return 1
    fi

    res=`curl -s -o /dev/null/ $URL -w %{http_code}`
    if [ 200 -ne $res ]; then
        echo "https://tools.ietf.otf/html/ is not accessable"
        return 2
    fi

    _match=0
    for key in "${!RFC[@]}"
    do
        if [ "$1" == "$key" ]; then
            _match=1
        fi
    done

    if [ "$_match" == 1 ]; then
        w3m ${URL}rfc${RFC[$1]} | less
    else
        w3m ${URL}rfc${1} | less
    fi
}


alias port='sudo netstat -antlp'
alias py='python'
alias py3='python3'
alias ptt='ssh bbsu@ptt.cc'
#alias tmp='cd ~/vm_share/tmp'

# 引號裡要打引號前要先用\跳脫，但是也不能直接打\，否則會被awk解析，要打'\'
alias cpu_load='ps -aux|awk '\''BEGIN{ sum=0} {sum=sum+$3} END{print sum}'\'''
alias mem_load='ps -aux|awk '\''BEGIN{ sum=0} {sum=sum+$4} END{print sum}'\'''

alias manc='man -M /usr/share/man/zh_TW'
alias ..='cd ..'
alias info='info --vi-keys'
