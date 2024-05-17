#!/bin/bash
clear
# Determine System Architecture and System Type
OS_TYPE=""
OS_ARCH=$(uname -m)

if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" = "debian" ] || [ "$ID" = "ubuntu" ]; then
        OS_TYPE="debian"
    elif [ "$ID" = "centos" ]; then
        OS_TYPE="centos"
    elif [ "$ID" = "alpine" ]; then
        OS_TYPE="alpine"
    else
        OS_TYPE="unknown"
    fi
fi

# banner
_show_banner() {
    echo "------------------------ 36H VPS Script All In One ------------------------"
    echo -e "Github：\e[32mhttps://github.com/36-H/36-h.github.io\e[0m"
    echo -e "Blog：\e[32mhttps://blog.36h.top\e[0m"
    echo -e ""
}

# menu
_show_menu(){
    echo "0.更新最新脚本"
    echo "1.安装Docker"
    echo "2.融合怪VPS评测"
    echo "3.安装1Panel面板"
    echo "4.IPV6脚本"
    echo "5.流媒体检测"
    echo -e ""
    echo -ne "\e[36m请选择功能：\e[0m"
}

_run_script(){
    echo "选择为 $1 !"
}

# main
_main(){
    _show_banner
    _show_menu
    read number
    _run_script $number
}


_main
