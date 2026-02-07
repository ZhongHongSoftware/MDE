# MengXiOS Desktop Environment - Makefile
# Developer: ZhongHongSoftware, Zeta
# Email: 3380089537@qq.com
#
# 支持 Arch Linux 和 Debian/Ubuntu
# 功能：依赖安装、配置部署、打包构建

# ============================================================================
# 变量定义
# ============================================================================

PREFIX ?= /usr
BINDIR = $(PREFIX)/bin
DATADIR = $(PREFIX)/share
SYSCONFDIR = /etc
DESTDIR ?=

PROJECT_NAME = mengxios-de
VERSION = 3.0.0

# 检测发行版
DISTRO := $(shell \
	if [ -f /etc/arch-release ]; then \
		echo "arch"; \
	elif [ -f /etc/debian_version ]; then \
		echo "debian"; \
	else \
		echo "unknown"; \
	fi)

# ============================================================================
# 颜色输出
# ============================================================================

COLOR_RESET = \033[0m
COLOR_BOLD = \033[1m
COLOR_GREEN = \033[32m
COLOR_YELLOW = \033[33m
COLOR_BLUE = \033[34m

define print_info
	@echo "$(COLOR_BLUE)$(COLOR_BOLD)ℹ $(1)$(COLOR_RESET)"
endef

define print_success
	@echo "$(COLOR_GREEN)$(COLOR_BOLD)✓ $(1)$(COLOR_RESET)"
endef

define print_warn
	@echo "$(COLOR_YELLOW)$(COLOR_BOLD)⚠ $(1)$(COLOR_RESET)"
endef

# ============================================================================
# 默认目标
# ============================================================================

.PHONY: all
all: help

.PHONY: help
help:
	@echo "$(COLOR_BOLD)MengXiOS Desktop Environment - 构建系统$(COLOR_RESET)"
	@echo ""
	@echo "检测到的发行版: $(COLOR_GREEN)$(DISTRO)$(COLOR_RESET)"
	@echo ""
	@echo "$(COLOR_BOLD)目标:$(COLOR_RESET)"
	@echo "  $(COLOR_GREEN)install-deps$(COLOR_RESET)     - 安装所有系统依赖"
	@echo "  $(COLOR_GREEN)install-fonts$(COLOR_RESET)    - 安装所需字体"
	@echo "  $(COLOR_GREEN)install$(COLOR_RESET)          - 安装 MDE 到系统"
	@echo "  $(COLOR_GREEN)uninstall$(COLOR_RESET)        - 从系统卸载 MDE"
	@echo "  $(COLOR_GREEN)package-arch$(COLOR_RESET)     - 构建 Arch 软件包 (.pkg.tar.zst)"
	@echo "  $(COLOR_GREEN)package-debian$(COLOR_RESET)   - 构建 Debian 软件包 (.deb)"
	@echo "  $(COLOR_GREEN)clean$(COLOR_RESET)            - 清理构建产物"
	@echo "  $(COLOR_GREEN)test$(COLOR_RESET)             - 运行测试"
	@echo ""
	@echo "$(COLOR_BOLD)完整安装流程:$(COLOR_RESET)"
	@echo "  1. make install-deps   # 安装所有软件"
	@echo "  2. make install-fonts  # 安装字体"
	@echo "  3. sudo make install   # 安装配置文件"
	@echo ""
	@echo "$(COLOR_BOLD)快速打包:$(COLOR_RESET)"
	@echo "  make package-$(DISTRO)"
	@echo ""

# ============================================================================
# 依赖安装
# ============================================================================

.PHONY: install-deps
install-deps:
	$(call print_info,安装依赖 ($(DISTRO))...)
ifeq ($(DISTRO),arch)
	@bash scripts/install-deps-arch.sh
else ifeq ($(DISTRO),debian)
	@bash scripts/install-deps-debian.sh
else
	$(call print_warn,不支持的发行版: $(DISTRO))
	@exit 1
endif
	$(call print_success,依赖安装完成)

.PHONY: install-fonts
install-fonts:
	$(call print_info,安装字体...)
	@bash share/fonts/install-fonts.sh
	$(call print_success,字体安装完成)

# ============================================================================
# 安装和卸载
# ============================================================================

.PHONY: install
install:
	$(call print_info,安装 MDE 到系统...)
	
	# 安装二进制文件
	$(call print_info,安装二进制文件...)
	install -Dm755 bin/mde-session $(DESTDIR)$(BINDIR)/mde-session
	install -Dm755 bin/mde-settings $(DESTDIR)$(BINDIR)/mde-settings
	
	# 安装配置文件
	$(call print_info,安装配置文件...)
	mkdir -p $(DESTDIR)$(DATADIR)/mde/config
	cp -r config/* $(DESTDIR)$(DATADIR)/mde/config/
	
	# 设置权限
	find $(DESTDIR)$(DATADIR)/mde/config -type f -name "*.sh" -exec chmod +x {} \;
	chmod +x $(DESTDIR)$(DATADIR)/mde/config/bspwm/bspwmrc || true
	chmod +x $(DESTDIR)$(DATADIR)/mde/config/bspwm/rules || true
	chmod +x $(DESTDIR)$(DATADIR)/mde/config/eww/toggle_bar || true
	find $(DESTDIR)$(DATADIR)/mde/config/eww/scripts -type f -exec chmod +x {} \; 2>/dev/null || true
	
	# 安装壁纸
	$(call print_info,安装壁纸...)
	install -Dm644 share/wallpapers/default.jpg $(DESTDIR)$(DATADIR)/mde/wallpapers/default.jpg
	
	# 安装 session 文件
	$(call print_info,安装 session 文件...)
	install -Dm644 session/mengxios.desktop $(DESTDIR)$(DATADIR)/xsessions/mengxios.desktop
	
	# 安装脚本
	$(call print_info,安装辅助脚本...)
	mkdir -p $(DESTDIR)$(DATADIR)/mde/scripts
	install -Dm755 scripts/*.sh $(DESTDIR)$(DATADIR)/mde/scripts/
	
	$(call print_success,MDE 安装完成!)
	@echo ""
	@echo "$(COLOR_BOLD)下一步:$(COLOR_RESET)"
	@echo "  1. 退出当前会话"
	@echo "  2. 在登录管理器选择 'MengXiOS Desktop Environment'"
	@echo "  3. 登录"
	@echo ""

.PHONY: uninstall
uninstall:
	$(call print_info,卸载 MDE...)
	rm -f $(DESTDIR)$(BINDIR)/mde-session
	rm -f $(DESTDIR)$(BINDIR)/mde-settings
	rm -rf $(DESTDIR)$(DATADIR)/mde
	rm -f $(DESTDIR)$(DATADIR)/xsessions/mengxios.desktop
	$(call print_success,MDE 已卸载)

# ============================================================================
# 打包
# ============================================================================

.PHONY: package-arch
package-arch:
	$(call print_info,构建 Arch 软件包...)
	cd packaging/arch && makepkg -sf
	$(call print_success,Arch 软件包构建完成)
	@ls -lh packaging/arch/*.pkg.tar.zst

.PHONY: package-debian
package-debian:
	$(call print_info,构建 Debian 软件包...)
	dpkg-buildpackage -us -uc -b
	$(call print_success,Debian 软件包构建完成)
	@ls -lh ../*.deb

# ============================================================================
# 清理
# ============================================================================

.PHONY: clean
clean:
	$(call print_info,清理构建产物...)
	rm -f packaging/arch/*.pkg.tar.zst
	rm -f packaging/arch/*.tar.gz
	rm -rf packaging/arch/pkg
	rm -rf packaging/arch/src
	rm -f ../*.deb
	rm -f ../*.changes
	rm -f ../*.buildinfo
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	$(call print_success,清理完成)

# ============================================================================
# 测试
# ============================================================================

.PHONY: test
test:
	$(call print_info,运行测试...)
	@bash -n bin/mde-session && echo "  ✓ mde-session 语法正确"
	@bash -n config/bspwm/bspwmrc && echo "  ✓ bspwmrc 语法正确"
	@bash -n config/eww/toggle_bar && echo "  ✓ toggle_bar 语法正确"
	@python3 -m py_compile bin/mde-settings && echo "  ✓ mde-settings 语法正确"
	$(call print_success,所有测试通过)

# ============================================================================
# 开发辅助
# ============================================================================

.PHONY: dev-install
dev-install:
	$(call print_info,开发模式安装...)
	mkdir -p ~/.config
	ln -sf $(PWD)/config/* ~/.config/
	$(call print_success,开发环境配置完成)

.PHONY: dev-uninstall
dev-uninstall:
	$(call print_info,清理开发环境...)
	# 这里需要小心，只删除符号链接
	find ~/.config -type l -exec sh -c 'test "$$(readlink "{}")" = "$(PWD)/config/*" && rm "{}"' \;
	$(call print_success,开发环境已清理)
