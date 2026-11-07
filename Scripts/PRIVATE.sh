#!/bin/bash
# ============================================================
# Scripts/PRIVATE.sh - 私有 feed 扩展（亚瑟 RE-SS-01 v2）
# 作用：把 feeds.conf.default 之外需要的第三方 feed 追加进去。
# 调用位置：WRT-CORE.yml 的 "Update Feeds" 步骤，在
#   ./scripts/feeds update -a 之前执行：
#     $GITHUB_WORKSPACE/Scripts/PRIVATE.sh
# 说明：
# - Lucky、Bandix 不在 ImmortalWrt 官方 feed 里，必须在 update 之前
#   写入 feeds.conf.default，否则 Config/PRIVATE.txt 里的
#   CONFIG_PACKAGE_lucky / bandix 等符号无法解析（会被静默忽略）。
# - 只改 feeds.conf.default，不自行 clone：update -a 会统一拉取。
# ============================================================

CONF="feeds.conf.default"
[ -f feeds.conf ] && CONF="feeds.conf"

echo "[PRIVATE] target conf: $CONF"

add_feed() {
    local name="$1" url="$2"
    if grep -q "^[[:space:]]*src-git[^[:space:]]*[[:space:]]*${name}[[:space:]]" "$CONF" 2>/dev/null; then
        echo "[PRIVATE] feed ${name} already present"
        return 0
    fi
    echo "src-git ${name} ${url}" >> "$CONF"
    echo "[PRIVATE] + ${name} -> ${url}"
}

add_feed lucky "https://github.com/gdy666/luci-app-lucky.git#main"
add_feed bandix "https://github.com/timsaya/openwrt-bandix.git#main"
add_feed luci-bandix "https://github.com/timsaya/luci-app-bandix.git#main"

echo "[PRIVATE] ===== $CONF ====="
cat "$CONF"
exit 0
