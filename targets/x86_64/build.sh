#!/bin/sh
# ============================================================
# 本地构建入口脚本
# 用途：在本地手动构建 rootfs 时使用（GitHub Actions 里用不到）
# 使用方式：cd <ImageBuilder 目录> && sh <此脚本路径>
# ============================================================

# 检查当前目录是否是 ImageBuilder 根目录
if [ ! -f Makefile ]; then
    echo "错误：当前目录不是 ImageBuilder 根目录"
    echo "请先 cd 到 ImageBuilder 目录再执行此脚本"
    exit 1
fi

# 检查 packages.list 是否存在
PKG_LIST_FILE="$(dirname "$0")/packages.list"
if [ ! -f "$PKG_LIST_FILE" ]; then
    echo "错误：未找到 packages.list 文件"
    exit 1
fi

# 读取包清单，过滤注释和空行
PACKAGES=$(grep -v '^\s*#' "$PKG_LIST_FILE" | grep -v '^\s*$' | tr '\n' ' ' | sed 's/ $//')

# 同步 files 目录到当前 ImageBuilder 根目录
FILES_DIR="$(dirname "$0")/files"
if [ -d "$FILES_DIR" ]; then
    rsync -a --delete "$FILES_DIR/" ./files/
else
    echo "警告：未找到 files 目录"
fi

# 执行构建
make image \
  PROFILE=generic \
  PACKAGES="$PACKAGES" \
  FILES=files