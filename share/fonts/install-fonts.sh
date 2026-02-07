#!/bin/bash
# MengXiOS Desktop Environment - 字体安装脚本

set -e

echo "=========================================="
echo "MDE - 字体安装"
echo "=========================================="

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

# 检测发行版
if [ -f /etc/arch-release ]; then
    DISTRO="arch"
elif [ -f /etc/debian_version ]; then
    DISTRO="debian"
else
    DISTRO="unknown"
fi

echo "检测到的发行版: $DISTRO"
echo ""

# Arch Linux
if [ "$DISTRO" = "arch" ]; then
    echo "使用 pacman 安装字体..."
    
    sudo pacman -S --noconfirm --needed \
        ttf-nerd-fonts-symbols-mono \
        noto-fonts \
        noto-fonts-cjk \
        noto-fonts-emoji \
        ttf-dejavu \
        ttf-liberation
    
    # 安装 Maple Font
    if ! fc-list | grep -q "Maple"; then
        echo "安装 Maple Font..."
        yay -S --noconfirm --needed ttf-maple || true
    fi
    
    echo "✓ Arch 字体安装完成"

# Debian/Ubuntu
elif [ "$DISTRO" = "debian" ]; then
    echo "下载并安装字体..."
    
    # 安装系统字体
    sudo apt install -y \
        fonts-noto \
        fonts-noto-cjk \
        fonts-noto-color-emoji \
        fonts-dejavu \
        fonts-liberation
    
    # 下载 Nerd Fonts
    echo "下载 Nerd Fonts..."
    NERD_FONTS_VERSION="v3.0.2"
    NERD_FONTS_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/$NERD_FONTS_VERSION"
    
    download_font() {
        local font_name="$1"
        local zip_file="$FONT_DIR/${font_name}.zip"
        
        if [ ! -f "$zip_file" ]; then
            echo "  下载 $font_name..."
            wget -q -O "$zip_file" "$NERD_FONTS_URL/${font_name}.zip" || true
        fi
        
        if [ -f "$zip_file" ]; then
            echo "  解压 $font_name..."
            unzip -o -q "$zip_file" -d "$FONT_DIR/$font_name"
            rm -f "$zip_file"
        fi
    }
    
    download_font "JetBrainsMono"
    download_font "FiraCode"
    download_font "Hack"
    
    # 下载 Maple Font
    echo "下载 Maple Font..."
    MAPLE_URL="https://github.com/subframe7536/Maple-font/releases/download/v6.4"
    wget -q -O "$FONT_DIR/MapleMono.zip" "$MAPLE_URL/MapleMono-NF.zip" || true
    
    if [ -f "$FONT_DIR/MapleMono.zip" ]; then
        unzip -o -q "$FONT_DIR/MapleMono.zip" -d "$FONT_DIR/MapleMono"
        rm -f "$FONT_DIR/MapleMono.zip"
    fi
    
    echo "✓ Debian 字体安装完成"
fi

# 刷新字体缓存
echo ""
echo "刷新字体缓存..."
fc-cache -fv "$FONT_DIR" > /dev/null 2>&1

echo ""
echo "=========================================="
echo "✓ 字体安装完成！"
echo "=========================================="
echo ""
echo "已安装的字体:"
fc-list | grep -E "(Nerd|Maple|Noto)" | cut -d: -f2 | sort -u | head -10
echo ""
