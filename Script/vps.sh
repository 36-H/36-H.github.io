#!/bin/bash
clear
# Determine System Architecture and System Type
OS_TYPE=""
OS_ARCH=$(uname -m)
# gai.conf文件路径
GAI_CONF="/etc/gai.conf"

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
_show_menu() {
    echo "0.更新最新脚本"
    echo "1.安装Docker"
    echo "2.融合怪VPS评测"
    echo "3.安装1Panel面板"
    echo "4.切换IPV6/IPV4优先级"
    echo "5.流媒体检测"
    echo "6.3X-UI"
    echo "7.TG MTP"
    echo "8.测速脚本"
    echo "9.Nexttrace"
    echo "10.BBR脚本"
    echo -e ""
    echo -ne "\e[36m请选择功能：\e[0m"
}

_run_script() {
    if [ "$1" == "0" ]; then
        bash <(curl -sL 36h.top/Script/vps.sh)
    elif [ "$1" == "1" ]; then
        curl -fsSL https://get.docker.com | bash -s docker
        systemctl start docker
        systemctl enable docker
    elif [ "$1" == "2" ]; then
        curl -L https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh && chmod +x ecs.sh && bash ecs.sh
    elif [ "$1" == "3" ]; then
        if [ "$OS_TYPE" = "debian" ]; then
            curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && bash quick_start.sh
        elif [ "$OS_TYPE" = "centos" ]; then
            curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sh quick_start.sh
        elif [ "$OS_TYPE" = "ubuntu" ]; then
            curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sudo bash quick_start.sh
        else
            echo "Unknown system: $OS_TYPE"
        fi
    elif [ "$1" == "4" ]; then
        # 获取用户输入
        read -p "你想优先使用IPv4还是IPv6? (输入4或6): " priority
        # 验证用户输入
        if [[ "$priority" != "4" && "$priority" != "6" ]]; then
            echo "无效的输入，请输入4或6。"
            exit 1
        fi
        # 确保gai.conf文件存在
        if [ ! -f "$GAI_CONF" ]; then
            echo "没有找到$GAI_CONF文件，创建一个新的。"
            touch "$GAI_CONF"
        fi
        # 设置优先级
        if [ "$priority" == "4" ]; then
            if grep -q "precedence ::ffff:0:0/96  100" "$GAI_CONF"; then
                echo "IPv4优先级已经设置。"
            else
                echo "设置IPv4优先级。"
                echo "precedence ::ffff:0:0/96  100" >>"$GAI_CONF"
            fi
            # 移除可能的IPv6优先设置
            sed -i '/^precedence ::0\/0/d' "$GAI_CONF"
            echo "IPv4已设置为优先。"
        else
            if grep -q "precedence ::0/0  40" "$GAI_CONF"; then
                echo "IPv6优先级已经设置。"
            else
                echo "设置IPv6优先级。"
                echo "precedence ::0/0  40" >>"$GAI_CONF"
            fi
            # 移除可能的IPv4优先设置
            sed -i '/^precedence ::ffff:0:0\/96/d' "$GAI_CONF"
            echo "IPv6已设置为优先。"
        fi
    elif [ "$1" == "5" ]; then
        bash <(curl -Ls unlock.icmp.ing/test.sh)
    elif [ "$1" == "6" ]; then
        bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
    elif [ "$1" == "7" ]; then
        read -e -p "请输入MTP安装目录，会在该目录下创建mtproxy文件夹（回车为当前目录）:" directory
        if [ -z "${directory}" ]; then
            directory=$PWD
        fi
        mkdir $directory/mtproxy && cd $directory/mtproxy
        curl -s -o mtproxy.sh https://raw.githubusercontent.com/sunpma/mtp/master/mtproxy.sh && chmod +x mtproxy.sh && bash mtproxy.sh
    elif [ "$1" == "8" ]; then
        bash <(curl -sL bash.icu/speedtest)
    elif [ "$1" == "9" ]; then  
        curl nxtrace.org/nt |bash
    elif [ "$1" == "10" ]; then 
        wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
    else
        echo "无效的输入！"
    fi
}

# main
_main() {
    # 检查root权限
    if [ "$EUID" -ne 0 ]; then
        echo "请使用root权限运行此脚本。"
        exit 1
    fi
    _show_banner
    _show_menu
    read number
    _run_script $number
}

_main
