#!/bin/bash
# MengXiOS Desktop Environment - X11 工具快速安装
# 如果您遇到 "xrandr: command not found" 或 "xsetroot: command not found"
# 运行此脚本快速修复

set -e

echo "=========================================="
echo "MDE - X11 工具快速安装"
echo "=========================================="

# 检测发行版
if [ -f /etc/arch-release ]; then
    DISTRO="arch"
elif [ -f /etc/debian_version ]; then
    DISTRO="debian"
else
    echo "错误: 不支持的发行版"
    exit 1
fi

echo "检测到的发行版: $DISTRO"
echo ""

if [ "$DISTRO" = "arch" ]; then
    echo "安装 X11 工具 (Arch)..."
    sudo pacman -S --noconfirm --needed \
        xorg-server \
        xorg-xinit \
        xorg-xrandr \
        xorg-xsetroot \
        xorg-xprop \
        xorg-xwininfo \
        xorg-xdpyinfo \
        xorg-xev \
        xorg-xkill
    
    echo "✓ X11 工具安装完成"
    
elif [ "$DISTRO" = "debian" ]; then
    echo "安装 X11 工具 (Debian)..."
    sudo apt update
    sudo apt install -y \
        xorg \
        x11-xserver-utils \
        x11-utils \
        x11-apps
    
    echo "✓ X11 工具安装完成"
fi

echo ""
echo "=========================================="
echo "验证安装..."
echo "=========================================="

# 验证关键命令
for cmd in xrandr xsetroot xprop xwininfo; do
    if command -v "$cmd" &> /dev/null; then
        echo "  ✓ $cmd"
    else
        echo "  ✗ $cmd - 仍然缺失"
    fi
done

echo ""
echo "=========================================="
echo "✓ 完成！"
echo "=========================================="
echo ""
echo "现在可以重新登录 MDE 了"
echo ""
