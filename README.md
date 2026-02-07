# MengXiOS Desktop Environment (MDE)

**版本**: 3.0.0  
**开发者**: ZhongHongSoftware, Zeta  
**邮箱**: 3380089537@qq.com  
**基于**: [XXiaoA/dotfiles](https://github.com/XXiaoA/dotfiles)

---

## 🎯 项目简介

MengXiOS Desktop Environment (MDE) 是一个现代化、美观且高效的 Linux 桌面环境，基于 bspwm 窗口管理器构建。

### ✨ 核心特性

- **🖥️ 多显示器支持**: 自动检测和配置多显示器
- **🎨 毛玻璃效果**: 使用 picom-ftlabs 实现现代化视觉效果
- **🎵 完整多媒体生态**: 集成 MPD、MPV、ncmpcpp
- **📝 强大的编辑器**: 预配置的 Neovim
- **🔧 现代 TUI 工具**: 完整的系统设置界面
- **🚀 健壮的启动系统**: 完善的错误处理，禁止黑屏
- **💻 虚拟机优化**: 完美支持 VirtualBox、VMware
- **📦 跨发行版支持**: 支持 Arch Linux 和 Debian/Ubuntu

### 🛠️ 核心组件

| 组件 | 软件 |
|------|------|
| **操作系统** | Arch Linux / Debian |
| **窗口管理器** | bspwm |
| **终端** | wezterm / kitty |
| **Shell** | fish |
| **编辑器** | neovim |
| **状态栏** | eww |
| **启动器** | rofi |
| **合成器** | picom-ftlabs |
| **通知** | dunst |
| **壁纸** | feh |
| **音乐** | mpd + ncmpcpp |
| **视频** | mpv |

---

## 📦 安装

### 系统要求

- **操作系统**: Arch Linux 或 Debian/Ubuntu
- **内存**: 最低 2GB，推荐 4GB
- **显卡**: 支持 OpenGL 2.0+
- **硬盘**: 20GB 可用空间

### 快速安装

```bash
# 1. 克隆仓库
git clone https://github.com/your-repo/mengxios-de.git
cd mengxios-de

# 2. 安装依赖
make install-deps

# 3. 安装字体
make install-fonts

# 4. 安装 MDE
sudo make install

# 5. 重启并选择 MengXiOS Desktop Environment
```

### 详细步骤

#### Arch Linux

```bash
# 安装依赖（包括 archlinuxcn 源配置）
make install-deps

# 安装字体
make install-fonts

# 安装 MDE
sudo make install
```

#### Debian/Ubuntu

```bash
# 安装依赖（包括编译 eww）
make install-deps

# 安装字体
make install-fonts

# 安装 MDE
sudo make install
```

---

## 🚀 使用

### 首次登录

1. 退出当前会话
2. 在登录管理器选择 **MengXiOS Desktop Environment**
3. 登录

### 常用快捷键

| 快捷键 | 功能 |
|--------|------|
| `Super + Return` | 打开终端 |
| `Super + Space` | 打开启动器 (rofi) |
| `Super + Q` | 关闭窗口 |
| `Super + 1-10` | 切换工作区 |
| `Super + Shift + 1-10` | 移动窗口到工作区 |
| `Super + H/J/K/L` | 切换焦点 |
| `Super + Shift + H/J/K/L` | 移动窗口 |
| `Super + F` | 全屏 |
| `Super + T` | 平铺模式 |
| `Super + Shift + T` | 伪平铺模式 |
| `Super + S` | 浮动模式 |
| `Super + Escape` | 重新加载 sxhkd |
| `Super + Alt + R` | 重启 bspwm |
| `Super + Alt + Q` | 退出 bspwm |
| `Super + I` | 打开设置工具 |

### 设置工具

```bash
# 打开 TUI 设置工具
mde-settings
```

功能包括：
- 显示器配置
- 网络设置
- 音频设置
- 壁纸设置
- 系统更新

### 日志查看

```bash
# Session 日志
cat ~/.local/share/mde/logs/session-latest.log

# bspwm 日志
cat ~/.local/share/mde/logs/bspwm-latest.log

# eww 日志
eww logs
```

---

## 🎨 自定义

### 更改主题

编辑 `~/.config/picom/picom.conf` 调整视觉效果：

```conf
# 圆角半径
corner-radius = 12;

# 模糊强度
blur-strength = 5;

# 透明度
inactive-opacity = 0.95;
```

### 更改壁纸

```bash
# 使用 feh
feh --bg-fill /path/to/your/wallpaper.jpg

# 或使用设置工具
mde-settings  # 选择 "壁纸设置"
```

### 更改快捷键

编辑 `~/.config/sxhkd/sxhkdrc`，然后重新加载：

```bash
pkill -USR1 sxhkd
```

---

## 🐛 故障排除

### 黑屏问题

1. 切换到 TTY: `Ctrl + Alt + F2`
2. 查看日志:
   ```bash
   cat ~/.local/share/mde/logs/session-latest.log
   cat ~/.local/share/mde/logs/bspwm-latest.log
   ```
3. 检查依赖:
   ```bash
   which bspwm sxhkd eww
   ```

### eww 不显示

```bash
# 重启 eww
pkill eww
eww daemon &
sleep 1
eww open bar
```

### 快捷键不工作

```bash
# 重启 sxhkd
pkill sxhkd
sxhkd &
```

### 虚拟机性能问题

参考 [虚拟机优化指南](docs/VM_OPTIMIZATION.md)

---

## 📚 文档

- [安装指南](docs/INSTALL.md)
- [虚拟机优化](docs/VM_OPTIMIZATION.md)
- [故障排除](docs/TROUBLESHOOTING.md)

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

### 开发

```bash
# 开发模式安装（符号链接）
make dev-install

# 运行测试
make test

# 清理
make clean
```

---

## 📄 许可证

本项目基于 MIT 许可证开源。

---

## 🙏 致谢

- [XXiaoA/dotfiles](https://github.com/XXiaoA/dotfiles) - 原始配置
- [bspwm](https://github.com/baskerville/bspwm) - 窗口管理器
- [eww](https://github.com/elkowar/eww) - 状态栏
- [picom-ftlabs](https://github.com/FT-Labs/picom) - 合成器

---

## 📧 联系方式

- **开发者**: ZhongHongSoftware, Zeta
- **邮箱**: 3380089537@qq.com

---

**MengXiOS Desktop Environment** - 让 Linux 桌面更美好！ 🚀
