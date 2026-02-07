#!/bin/bash
# MengXiOS Desktop Environment - Debian/Ubuntu 依赖安装脚本
# Developer: ZhongHongSoftware, Zeta

set -e

echo "=========================================="
echo "MDE - Debian/Ubuntu 依赖安装"
echo "=========================================="

# 检查是否为 root
if [ "$EUID" -eq 0 ]; then
    echo "错误: 请不要使用 root 运行此脚本"
    echo "脚本会在需要时自动请求 sudo 权限"
    exit 1
fi

# 更新软件源
update_sources() {
    echo ""
    echo "更新软件源..."
    sudo apt update
    echo "  ✓ 软件源已更新"
}

# 安装核心依赖
install_core_deps() {
    echo ""
    echo "安装核心依赖..."
    
    local core_pkgs=(
        # 窗口管理器和核心工具
        bspwm
        sxhkd
        xorg
        x11-xserver-utils
        
        # 终端
        kitty
        
        # Shell
        fish
        
        # 编辑器
        neovim
        
        # 启动器
        rofi
        
        # 合成器
        picom
        
        # 通知
        dunst
        
        # 壁纸
        feh
        
        # 多媒体
        mpd
        mpv
        ncmpcpp
        
        # 音频
        pulseaudio
        pavucontrol
        
        # 网络
        network-manager
        network-manager-gnome
        
        # 输入法
        fcitx5
        fcitx5-chinese-addons
        
        # 文件管理
        thunar
        udiskie
        
        # 系统工具
        policykit-1-gnome
        
        # Python 依赖
        python3-urwid
        python3-pip
        
        # 构建工具
        build-essential
        git
        curl
        wget
    )
    
    echo "  安装软件包..."
    sudo apt install -y "${core_pkgs[@]}"
    
    echo "  ✓ 核心依赖安装完成"
}

# 安装 eww (需要从源码编译)
install_eww() {
    echo ""
    echo "安装 eww..."
    
    if command -v eww &> /dev/null; then
        echo "  eww 已安装"
        return 0
    fi
    
    echo "  eww 需要从源码编译，这可能需要 10-20 分钟..."
    
    # 安装 Rust
    if ! command -v cargo &> /dev/null; then
        echo "  安装 Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi
    
    # 安装 eww 依赖
    sudo apt install -y \
        libgtk-3-dev \
        libgtk-layer-shell-dev \
        libpango1.0-dev \
        libgdk-pixbuf2.0-dev \
        libcairo2-dev \
        libglib2.0-dev
    
    # 克隆并编译 eww
    local eww_dir="/tmp/eww-build"
    rm -rf "$eww_dir"
    git clone https://github.com/elkowar/eww "$eww_dir"
    cd "$eww_dir"
    cargo build --release
    sudo install -Dm755 target/release/eww /usr/local/bin/eww
    cd -
    rm -rf "$eww_dir"
    
    echo "  ✓ eww 已安装"
}

# 安装 wezterm
install_wezterm() {
    echo ""
    echo "安装 wezterm..."
    
    if command -v wezterm &> /dev/null; then
        echo "  wezterm 已安装"
        return 0
    fi
    
    echo "  下载 wezterm..."
    local wezterm_url="https://github.com/wez/wezterm/releases/download/20230712-072601-f4abf8fd/wezterm-20230712-072601-f4abf8fd.Ubuntu22.04.deb"
    local wezterm_deb="/tmp/wezterm.deb"
    
    wget -O "$wezterm_deb" "$wezterm_url"
    sudo dpkg -i "$wezterm_deb" || sudo apt install -f -y
    rm -f "$wezterm_deb"
    
    echo "  ✓ wezterm 已安装"
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
        fd-find
        ripgrep
    )
    
    echo "  安装可选软件包..."
    sudo apt install -y "${optional_pkgs[@]}" || true
    
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
    update_sources
    install_core_deps
    install_eww
    install_wezterm
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
