# ============================================================
# 预置配置版 Dockerfile
# 使用方式：把 build.yml 产出的 rootfs.tar.gz 和此文件放同一目录
#           docker build -t yourname/istoreos-custom:amd64 .
# ============================================================

# 从空镜像开始
FROM scratch

# 把预置好配置的 rootfs 完整铺到容器根目录
# rootfs 里已经包含 /etc/config/network 和 /etc/uci-defaults/00-network
# 所以容器启动后网络会自动配置，无需额外脚本
ADD rootfs.tar.gz /

# 容器启动命令：启动 OpenWrt 的 procd 初始化系统
# procd 会自动执行 /etc/uci-defaults/ 下的脚本
CMD ["/sbin/init"]