#!/bin/bash
# ============================================================
# Scripts/PRIVATE.sh - 私有 feed 扩展（亚瑟 RE-SS-01 v2）
# 调用位置：WRT-CORE.yml 的 "Update Feeds" 步骤，在 ./scripts/feeds update -a 之前：
#   $GITHUB_WORKSPACE/Scripts/PRIVATE.sh
#
# 为什么需要它：Lucky、Bandix 不在 ImmortalWrt 官方 feed 里，必须在 feeds update
# 之前写进 feeds.conf.default，否则 CONFIG_PACKAGE_lucky / bandix 是无效符号，
# 会被 defconfig 静默丢掉（固件里就没有这两个插件）。
#
# scripts/feeds 的两个坑（踩过，务必遵守）：
# 1) feed 名必须是 \w+ —— 不能带连字符（用 luci-bandix 会报
#    "Syntax error in feeds.conf.default"，整个 run 退出码 25）。
# 2) 行内 # 之后全部按注释剥掉，所以分支写法是 url;branch 而不是 url#branch；
#    下面三个仓库默认分支就是 main，直接省略。
# ============================================================

CONF="feeds.conf.default"
[ -f feeds.conf ] && CONF="feeds.conf"

echo "[PRIVATE] target conf: $CONF"

add_feed() {
    local name="$1" url="$2"
    if grep -Eq "^[[:space:]]*src-git[[:space:]]+${name}[[:space:]]" "$CONF" 2>/dev/null; then
        echo "[PRIVATE] feed ${name} already present"
        return 0
    fi
    echo "src-git ${name} ${url}" >> "$CONF"
    echo "[PRIVATE] + ${name} -> ${url}"
}

# Lucky（lucky 核心 + luci-app-lucky 同一个仓库）
add_feed lucky "https://github.com/gdy666/luci-app-lucky.git"
# Bandix 核心（Rust + eBPF 流量统计）
add_feed bandix "https://github.com/timsaya/openwrt-bandix.git"
# Bandix 的 LuCI 前端（名字不能带 -）
add_feed lucibandix "https://github.com/timsaya/luci-app-bandix.git"

echo "[PRIVATE] ===== $CONF ====="
cat "$CONF"
exit 0
