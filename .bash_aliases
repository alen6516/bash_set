function lsg()
{
    local cmd="ls -a"
    if [ $# -gt 0 ]; then
        for var in $@
        do
            cmd=$cmd" | grep $var"
        done
    fi

    echo "$cmd"
    echo "---------------"
    eval $cmd
}

function psg()
{
    local cmd="ps -aux"
    if [ $# -gt 0 ]; then
        for var in $@
        do
            cmd=$cmd" | grep $var"
        done
    fi

    echo "$cmd"
    echo "---------------"
    eval $cmd
}

function ipinfo()
{
    if [ $# = 1 ]; then
        curl ipinfo.io/$1
    else
        curl ipinfo.io
    fi
}

function ppid() 
{
    var=1234
    ps -o ppid= -p $var
}

function mem()       # show mem usage
{
    if [ $# != 1 ]; then
        echo "Please give process or pid as \$1"
        return 1
    fi
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
    command mv $@ $trash_can
    echo "moving $@ to $trash_can"
}

function rrm()
{
    command rm -I $@    
}

function cd()
{
    if [[ $# -eq 1 ]] && [[ -f $1 ]]; then
        command cd $@
        read -t 5 -p "Do you want to open it by vim? [yN] " ans
        if [[ $ans == 'y' ]] || [[ $ans == 'Y' ]]; then
            vim $@
        fi
    else
        command cd $@
    fi
}

function man2()
{
    local URL="https://wangchujiang.com/linux-command/"
    [ -z $1 ] && (echo "please give a command as \$1"; exit)
    #ping -c1 -w 3 8.8.8.8 > /dev/null || (echo "Internet is not accessable"; return)
    res=`curl -s -o /dev/null/ $URL -w %{http_code}`
    [ 200 -ne $res ] && (echo "https://wangchujiang.com/linux-command is not accessable"; return)
    w3m ${URL}c/${1} | less
}


# inner funtion for auto completion
function _completion() {

    local COM=""

    case $1 in
        "rfc")
            COM=${!RFC[*]}
            ;;
        "shortcut")
            COM=${!SHORTCUT[*]}
            ;;
        "doc")
            COM=""
            for _dir in ${!DOC[@]}
            do
                for _file in $(ls ~/doc/$_dir)
                do
                    if [[ $_dir == "cmd" ]]; then
                        COM="$COM ${_file%.cmd}"
                    elif [[ $_dir == "api" ]]; then
                        COM="$COM ${_file%.c}"
                    elif [[ $_dir == "prot" ]]; then
                        COM="$COM ${_file%.md}"
                    fi
                done
            done
            ;;
    esac

    #if [ "${#COMP_WORDS[@]}" != "2" ]; then
    #    return
    #fi
    COMPREPLY=($(compgen -W "$COM" "${COMP_WORDS[1]}"))
}


declare -A SHORTCUT=(       \
    ["bash"]="Bash/linux/Bash_Shortcuts"

)
function shortcut() {
    local URL='https://shortcutworld.com/'


    if [ -z $1 ]; then 
        echo "please give a parameter or option"
        return 1
    fi

    res=`curl -s -o /dev/null/ $URL -w %{http_code}`
    if [ 200 -ne $res ]; then
        echo "$URL is not accessable"
        return 2
    fi

    _match=0
    for key in "${!SHORTCUT[@]}"
    do
        if [ "$1" == "$key" ]; then
            _match=1
        fi
    done

    if [ "$_match" == 1 ]; then
        w3m ${URL}${SHORTCUT[$1]} | less
    else
        echo "Uknown shortcut, try again"
    fi
}
complete -F _completion shortcut



declare -A RFC=(            \
    ["arp"]="826"           \
    ["ip"]="791"            \
    ["ipv4"]="791"          \
    ["ipv6"]="2460"         \
    ["icmp"]="792"          \
    ["udp"]="768"           \
    ["tcp"]="793"           \
)
function rfc() {

    local URL='https://tools.ietf.org/html/'
    
    if [ -z $1 ]; then
        echo "please give a protocol or rfc number as \$1"
        return 1
    fi

    res=`curl -s -o /dev/null/ $URL -w %{http_code}`
    if [ 200 -ne $res ]; then
        echo "$URL is not accessable"
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
complete -F _completion rfc



declare -A DOC=(          \
    ["api"]=".c"          \
    ["cmd"]=".cmd"        \
    ["prot"]=".md"        \
)
function doc() {
    local HELP="usage: doc API|CMD|PROT"

    if [[ $# -eq 0 ]]; then
        cd ~/doc
        return 0
    fi

    if [[ ! $# -eq 1 ]]; then
        echo $HELP
    fi

    local file_cmd=""
    for item in $(ls ~/doc/cmd/)
    do
        item=${item%.*}
        file_cmd=$file_cmd" $item"
        #echo $item
    done
    if [[ $file_cmd =~ " $1 " ]]; then
        #echo "${1}.cmd"
        cat ~/doc/cmd/${1}.cmd | less
        return 0
    fi


    local file_api=""
    for item in $(ls ~/doc/api/)
    do
        item=${item%.*}
        file_api=$file_api" $item"
    done
    if [[ $file_api =~ " $1 " ]]; then
        #echo "${1}.c"
        cat ~/doc/api/${1}.c | less
        return 0
    fi


    local file_prot=""
    for item in $(ls ~/doc/prot/)
    do
        item=${item%.*}
        file_prot=$file_prot" $item"
    done
    if [[ $file_prot =~ " $1 " ]]; then
        #echo "${1}.md"
        cat ~/doc/prot/${1}.md | less
        return 0
    fi

    echo "can not find $1"
}
complete -F _completion doc



## for handy
alias tmp='cd ~/vm_share/tmp'
alias _ba='cd ~/.bash_set'
alias ..='cd ..'
alias py='python'
alias py3='python3'
alias od='objdump'
alias rlf='readlink -f'
alias tcpread='tcpdump -r'

## tool
alias port='sudo netstat -antlp'
alias ptt='ssh bbsu@ptt.cc'

#引號裡要打引號前要先用\跳脫，但是也不能直接打 \，否則會被 awk 解析，要打 '\'
alias cpu_load='ps -aux|awk '\''BEGIN{ sum=0} {sum=sum+$3} END{print sum}'\'''
alias mem_load='ps -aux|awk '\''BEGIN{ sum=0} {sum=sum+$4} END{print sum}'\'''

alias info='info --vi-keys'
alias man='man -M /usr/share/man'
alias manc='man -M /usr/share/man/zh_TW'
alias bpf='w3m http://biot.com/capstats/bpf.html | less'


## wrap command
alias cp='cp -i'
alias mv='mv -i'
alias tmux='history -w && tmux'     # write cmd history to .bash_history before using tmux
alias gdb='gdb -q'
