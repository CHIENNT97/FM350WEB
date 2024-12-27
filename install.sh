#!/bin/sh

TAR_FILE="/tmp/webui.tar.gz"  # 替换为您的 tar 文件路径
TARGET_DIR="/root"  # 替换为您的目标目录

# 更新软件包列表并安装 tar（如果未安装）
opkg update
opkg install tar comgt chat

# 检查 TAR 文件是否存在
if [ ! -f "$TAR_FILE" ]; then
    echo "TAR 文件 $TAR_FILE 不存在，请检查文件路径。"
    exit 1
fi

# 创建目标目录（如果不存在）
mkdir -p "$TARGET_DIR"

# 解压 TAR 文件
echo "正在解压 $TAR_FILE 到 $TARGET_DIR..."
tar -xzvf "$TAR_FILE" -C "$TARGET_DIR"  # -z：解压 .gz，-x：解压，-v：显示过程，-f：文件名，-C：指定目标目录

# 设置权限
chmod -R 777 "$TARGET_DIR"  # 设置文件为可读写
find "$TARGET_DIR" -type d -exec chmod 775 {} +  # 设置目录为可读写可执行

echo "解压完成，权限设置完成！"

ln -s /root/350 /www
ln -s /root/cgi-bin/lock_cell.lua /www/cgi-bin
ln -s /root/cgi-bin/save_config.lua /www/cgi-bin
ln -s /root/cgi-bin/lock_5g.lua /www/cgi-bin
ln -s /root/cgi-bin/getdevices.lua /www/cgi-bin
ln -s /tmp/data.txt /www/350
ln -s /root/cgi-bin/utils.lua /www/cgi-bin

echo "软链接设置完成！"

#!/bin/sh

# 脚本名称
SCRIPT_NAME="my_startup_script"
SCRIPT_PATH="/etc/init.d/$SCRIPT_NAME"

# 创建启动脚本
echo "创建启动脚本 $SCRIPT_PATH"
cat <<'EOF' > "$SCRIPT_PATH"
#!/bin/sh /etc/rc.common

START=99  # 启动顺序
STOP=10   # 停止顺序

start() {
    echo "Starting my custom script..."
    # 在这里添加您要执行的命令
    # 例如启动一个服务或运行一个程序
    # /path/to/your_command &
	/root/loop_script.sh &
}

stop() {
    echo "Stopping my custom script..."
    # 在这里添加停止命令
}

EOF

# 设置脚本权限
echo "设置脚本权限..."
chmod +x "$SCRIPT_PATH"

# 启用自启动
echo "启用自启动..."
"$SCRIPT_PATH" enable

# 测试启动脚本
echo "手动测试启动脚本..."
"$SCRIPT_PATH" start

echo "设置完成，您可以重启路由器进行验证。"
