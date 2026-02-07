#!/bin/bash
# MengXiOS Desktop Environment - MPD Initialization Script

MPD_DIR="$HOME/.local/share/mpd"
MUSIC_DIR="$HOME/Music"

# 创建必要的目录
mkdir -p "$MPD_DIR"/{playlists,}
mkdir -p "$MUSIC_DIR"

# 创建空的数据库文件
touch "$MPD_DIR/db"
touch "$MPD_DIR/log"
touch "$MPD_DIR/state"

echo "MPD 目录初始化完成"
echo "  数据目录: $MPD_DIR"
echo "  音乐目录: $MUSIC_DIR"
