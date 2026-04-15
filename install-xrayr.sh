#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

AMD64_URL="https://github.com/hk9999-png/siran-xrayr/releases/download/%E7%89%88%E6%9C%AC0.0.1/XrayR-wyx2685-amd64.tar.gz"
ARM64_URL="https://github.com/hk9999-png/siran-xrayr/releases/download/%E7%89%88%E6%9C%AC0.0.1/XrayR-wyx2685-arm64.tar.gz"

echo -e "${green}========================================${plain}"
echo -e "${green}  XrayR wyx2685 修改版 一键安装脚本${plain}"
echo -e "${green}  支持 VLESS + Reality${plain}"
echo -e "${green}========================================${plain}"
echo ""

if [[ $EUID -ne 0 ]]; then
    echo -e "${red}请使用 root 用户运行此脚本${plain}"
    exit 1
fi

arch=$(uname -m)
download_url=""

if [[ "$arch" == "x86_64" ]]; then
    echo -e "${green}检测到架构: x86_64 (amd64)${plain}"
    download_url="$AMD64_URL"
elif [[ "$arch" == "aarch64" ]]; then
    echo -e "${green}检测到架构: aarch64 (arm64)${plain}"
    download_url="$ARM64_URL"
else
    echo -e "${yellow}无法自动识别架构: ${arch}${plain}"
    echo -e "${yellow}请手动选择:${plain}"
    echo "  1) x86_64 / amd64"
    echo "  2) aarch64 / arm64"
    read -p "请输入 1 或 2: " choice
    case "$choice" in
        1) download_url="$AMD64_URL" ;;
        2) download_url="$ARM64_URL" ;;
        *)
            echo -e "${red}无效选择，退出${plain}"
            exit 1
            ;;
    esac
fi

echo ""
echo -e "${green}[1/4] 安装官方 XrayR 框架...${plain}"
bash <(curl -Ls https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh)
if [[ $? -ne 0 ]]; then
    echo -e "${red}XrayR 框架安装失败，退出${plain}"
    exit 1
fi

echo ""
echo -e "${green}[2/4] 停止 XrayR 服务...${plain}"
systemctl stop XrayR

echo ""
echo -e "${green}[3/4] 下载并替换 wyx2685 修改版二进制...${plain}"
curl -Lo /tmp/XrayR-wyx2685.tar.gz "$download_url"
if [[ $? -ne 0 ]]; then
    echo -e "${red}下载失败，请检查网络或 GitHub 链接${plain}"
    exit 1
fi

cd /usr/local/XrayR
tar -xzf /tmp/XrayR-wyx2685.tar.gz
extracted=$(tar -tzf /tmp/XrayR-wyx2685.tar.gz | head -1)
if [[ "$extracted" != "XrayR" ]]; then
    mv "$extracted" XrayR
fi
chmod +x XrayR
rm -f /tmp/XrayR-wyx2685.tar.gz

echo ""
echo -e "${green}[4/5] 启动 XrayR...${plain}"
systemctl start XrayR

echo ""
echo -e "${green}[5/5] 清理编译和安装缓存...${plain}"
rm -rf /tmp/wyx2685-XrayR /root/go /usr/local/go /root/.cache/go-build /root/go1.*.linux-*.tar.gz /tmp/XrayR-wyx2685.tar.gz 2>/dev/null
echo -e "${green}清理完成${plain}"

echo ""
echo -e "${green}========================================${plain}"
echo -e "${green}  安装完成！${plain}"
echo -e "${green}========================================${plain}"
echo ""
echo -e "配置文件路径: ${yellow}/etc/XrayR/config.yml${plain}"
echo -e "查看日志:     ${yellow}XrayR log${plain}"
echo -e "重启服务:     ${yellow}XrayR restart${plain}"
echo -e "查看版本:     ${yellow}XrayR version${plain}"
echo ""
echo -e "${yellow}请记得上传你的 config.yml 到 /etc/XrayR/config.yml 后执行 XrayR restart${plain}"
