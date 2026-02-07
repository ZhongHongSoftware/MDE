# MengXiOS Desktop Environment - 虚拟机优化指南

## 概述

本文档提供在虚拟机环境（VirtualBox、VMware 等）中运行 MDE 的优化建议。

## 虚拟机配置建议

### 最低配置

- **CPU**: 2 核心
- **内存**: 2GB RAM
- **显存**: 128MB
- **硬盘**: 20GB

### 推荐配置

- **CPU**: 4 核心
- **内存**: 4GB RAM
- **显存**: 256MB
- **硬盘**: 40GB
- **3D 加速**: 启用

## VirtualBox 优化

### 1. 启用 3D 加速

```bash
# 在虚拟机设置中
显示 -> 启用 3D 加速
显示 -> 视频内存 -> 设置为 256MB
```

### 2. 安装 Guest Additions

```bash
# 在虚拟机中执行
sudo apt install virtualbox-guest-utils virtualbox-guest-x11
# 或
sudo pacman -S virtualbox-guest-utils
```

### 3. 共享剪贴板

```bash
# 在虚拟机设置中
常规 -> 高级 -> 共享剪贴板 -> 双向
```

## VMware 优化

### 1. 安装 VMware Tools

```bash
# VMware 会自动提示安装
# 或手动安装
sudo apt install open-vm-tools open-vm-tools-desktop
# 或
sudo pacman -S open-vm-tools
sudo systemctl enable vmtoolsd
sudo systemctl start vmtoolsd
```

### 2. 启用 3D 加速

```bash
# 在虚拟机设置中
显示器 -> 启用 3D 图形加速
显示器 -> 图形内存 -> 设置为 2GB
```

## Picom 性能优化

### 虚拟机环境配置

编辑 `~/.config/picom/picom.conf`:

```conf
# 如果性能不佳，使用以下配置

# 禁用动画
animations = false;

# 降低模糊强度
blur-strength = 2;

# 或完全禁用模糊
# blur-method = "none";

# 禁用阴影
# shadow = false;

# 使用更快的后端
backend = "xrender";  # 代替 "glx"

# 禁用 vsync（可能导致撕裂，但提高性能）
# vsync = false;
```

### 性能模式脚本

创建 `~/.config/mde/performance-mode.sh`:

```bash
#!/bin/bash
# 切换到性能模式

# 重启 picom 使用性能配置
pkill picom
picom -b --config ~/.config/picom/picom-performance.conf &

echo "已切换到性能模式"
```

## EWW 优化

### 降低更新频率

编辑 eww 脚本，增加更新间隔：

```bash
# 例如，将 CPU 监控从每秒更新改为每 2 秒
# 在 eww/scripts/cpu.sh 中
sleep 2  # 原来是 sleep 1
```

### 禁用不必要的组件

编辑 `~/.config/eww/eww.yuck`，注释掉不需要的组件。

## BSPWM 优化

### 减少窗口间距

```bash
# 在 ~/.config/bspwm/bspwmrc 中
bspc config window_gap 2  # 原来是 4
bspc config border_width 2  # 原来是 3
```

## 显示器优化

### 自动调整分辨率

MDE 会自动检测并设置最佳分辨率。如果需要手动设置：

```bash
# 查看可用分辨率
xrandr

# 设置分辨率
xrandr --output Virtual-1 --mode 1920x1080
```

### 虚拟机常见分辨率

- 1920x1080 (推荐)
- 1680x1050
- 1440x900
- 1366x768
- 1280x720

## 内存优化

### 禁用不需要的服务

```bash
# 如果不需要输入法
sudo systemctl disable fcitx5

# 如果不需要打印服务
sudo systemctl disable cups

# 如果不需要蓝牙
sudo systemctl disable bluetooth
```

### 减少缓存

```bash
# 清理包缓存
# Arch
sudo pacman -Sc

# Debian
sudo apt clean
```

## 故障排除

### 问题 1: 黑屏

**解决方案**:

1. 检查日志:
   ```bash
   cat ~/.local/share/mde/logs/session-latest.log
   cat ~/.local/share/mde/logs/bspwm-latest.log
   ```

2. 确保 X server 正常:
   ```bash
   echo $DISPLAY  # 应该显示 :0 或 :1
   xrandr  # 应该列出显示器
   ```

3. 手动启动 bspwm:
   ```bash
   bspwm &
   ```

### 问题 2: eww 不显示

**解决方案**:

1. 检查 eww 是否运行:
   ```bash
   pgrep eww
   ```

2. 手动启动 eww:
   ```bash
   pkill eww
   eww daemon &
   sleep 1
   eww open bar
   ```

3. 检查 eww 日志:
   ```bash
   eww logs
   ```

### 问题 3: 快捷键不工作

**解决方案**:

1. 检查 sxhkd 是否运行:
   ```bash
   pgrep sxhkd
   ```

2. 重启 sxhkd:
   ```bash
   pkill sxhkd
   sxhkd &
   ```

3. 测试配置:
   ```bash
   sxhkd -p
   ```

### 问题 4: 性能卡顿

**解决方案**:

1. 使用性能模式:
   ```bash
   # 编辑 picom 配置，禁用动画和模糊
   nano ~/.config/picom/picom.conf
   ```

2. 降低 eww 更新频率

3. 增加虚拟机资源分配

### 问题 5: 圆角不显示

**解决方案**:

1. 确保使用 picom-ftlabs:
   ```bash
   picom --version
   ```

2. 检查 picom 配置:
   ```bash
   grep "corner-radius" ~/.config/picom/picom.conf
   ```

3. 重启 picom:
   ```bash
   pkill picom
   picom -b
   ```

## 性能监控

### 查看资源使用

```bash
# CPU 和内存
htop

# 显卡
glxinfo | grep "OpenGL"

# 进程
ps aux | grep -E "bspwm|eww|picom"
```

### 性能测试

```bash
# X server 性能
glxgears

# 合成器性能
picom --benchmark 10
```

## 推荐设置

### VirtualBox

```
显示:
  - 视频内存: 256MB
  - 3D 加速: 启用
  - 缩放因子: 100%

系统:
  - 处理器: 4 核心
  - 内存: 4096MB
  - 启用 PAE/NX
```

### VMware

```
显示器:
  - 图形内存: 2GB
  - 3D 图形加速: 启用
  - 监视器数量: 1

处理器:
  - 核心数: 4
  - 虚拟化引擎: 启用所有选项

内存:
  - 4096MB
```

## 总结

- **启用 3D 加速**: 提高图形性能
- **安装 Guest Tools**: 改善集成和性能
- **优化 Picom**: 根据性能调整特效
- **监控资源**: 使用 htop 等工具
- **查看日志**: 遇到问题先查看日志

---

**开发者**: ZhongHongSoftware, Zeta  
**邮箱**: 3380089537@qq.com
