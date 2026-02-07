#!/bin/bash
# MengXiOS Desktop Environment - Arch Linux 依赖安装脚本
# Developer: ZhongHongSoftware, Zeta

set -e

echo "=========================================="
echo "MDE - Arch Linux 依赖安装"
echo "=========================================="

# 检查是否为 root
if [ "$EUID" -eq 0 ]; then
    echo "错误: 请不要使用 root 运行此脚本"
    echo "脚本会在需要时自动请求 sudo 权限"
    exit 1
fi

# 配置 archlinuxcn 源
configure_archlinuxcn() {
    echo ""
    echo "配置 archlinuxcn 源..."
    
    if grep -q "archlinuxcn" /etc/pacman.conf; then
        echo "  archlinuxcn 源已配置"
    else
        echo "  添加 archlinuxcn 源..."
        sudo tee -a /etc/pacman.conf > /dev/null << 'EOF'

[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
EOF
        echo "  ✓ archlinuxcn 源已添加"
    fi
    
    # 导入 GPG key
    echo "  导入 GPG key..."
    sudo pacman -Sy --noconfirm archlinuxcn-keyring || true
    
    echo "  ✓ archlinuxcn 源配置完成"
}

# 安装 yay
install_yay() {
    echo ""
    echo "安装 yay AUR helper..."
    
    if command -v yay &> /dev/null; then
        echo "  yay 已安装"
    else
        sudo pacman -S --noconfirm --needed yay
        echo "  ✓ yay 已安装"
    fi
}

# 安装核心依赖
install_core_deps() {
    echo ""
    echo "安装核心依赖..."
    
    local core_pkgs=(
        # 窗口管理器和核心工具
        bspwm
        sxhkd
        
        # X11 核心组件
        xorg-server
        xorg-xinit
        xorg-xrandr
        xorg-xsetroot
        xorg-xprop
        xorg-xwininfo
        xorg-xdpyinfo
        xorg-xev
        xorg-xkill
        
        # 终端
        wezterm
        kitty
        
        # Shell
        fish
        
        # 编辑器
        neovim
        
        # 启动器
        rofi
        
        # 合成器 (picom-ftlabs)
        picom-ftlabs-git
        
        # 通知
        dunst
        
        # 壁纸
        feh
        
        # 状态栏
        eww
        
        # 多媒体
        mpd
        mpv
        ncmpcpp
        
        # 音频
        pulseaudio
        pavucontrol
        
        # 网络
        networkmanager
        network-manager-applet
        
        # 输入法
        fcitx5
        fcitx5-chinese-addons
        fcitx5-gtk
        fcitx5-qt
        
        # 文件管理
        thunar
        udiskie
        
        # 系统工具
        polkit-gnome
        
        # Python 依赖
        python-urwid
        python-pip
    )
    
    echo "  安装软件包..."
    yay -S --noconfirm --needed "${core_pkgs[@]}"
    
    echo "  ✓ 核心依赖安装完成"
}

# 安装可选依赖
install_optional_deps() {
    echo ""
    echo "安装可选依赖..."
    
    local optional_pkgs=(
        # 图片查看器
        imv
        
        # 截图工具
        flameshot
        
        # 系统监控
        htop
        btop
        
        # 文件搜索
        fd
        ripgrep
        
        # 其他工具
        keymapper
    )
    
    echo "  安装可选软件包..."
    yay -S --noconfirm --needed "${optional_pkgs[@]}" || true
    
    echo "  ✓ 可选依赖安装完成"
}

# 启用服务
enable_services() {
    echo ""
    echo "启用系统服务..."
    
    sudo systemctl enable NetworkManager
    sudo systemctl start NetworkManager
    
    echo "  ✓ 服务已启用"
}

# 主函数
main() {
    configure_archlinuxcn
    install_yay
    install_core_deps
    install_optional_deps
    enable_services
    
    echo ""
    echo "=========================================="
    echo "✓ 所有依赖安装完成！"
    echo "=========================================="
    echo ""
    echo "下一步:"
    echo "  1. make install-fonts  # 安装字体"
    echo "  2. sudo make install   # 安装 MDE"
    echo ""
}

main "$@"
