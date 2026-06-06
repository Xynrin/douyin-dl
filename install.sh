#!/bin/bash
# -----------------------------------------------------------------------------
# TikTok & Douyin Downloader - Linux One-Click Installer
# -----------------------------------------------------------------------------

set -e

# GitHub Repository Configuration
GITHUB_USER="Xynrin"
GITHUB_REPO="tiktok-douyin-dl"

INSTALL_DIR="$HOME/.local/share/tiktok-douyin-dl"
BIN_DIR="$HOME/.local/bin"

# Terminal Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}   🚀 TikTok & Douyin Downloader Installer        ${NC}"
echo -e "${BLUE}==================================================${NC}"

# Create directories
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

# 1. Choose Language
echo -e "\n${YELLOW}🌐 选择语言 / Choose Language：${NC}"
echo "1. 简体中文 (Chinese)"
echo "2. English"
read -p "请输入选项序号 / Enter option number [1-2] (Default: 1): " LANG_OPT < /dev/tty
if [ "$LANG_OPT" = "2" ]; then
    USER_LANG="en"
    echo -e "✓ Language set to English."
else
    USER_LANG="zh"
    echo -e "✓ 语言设置为：简体中文。"
fi

# Write language configuration
echo "{\"lang\": \"$USER_LANG\"}" > "$INSTALL_DIR/config.json"

# 2. Install binaries (local or remote)
install_binary() {
    local name=$1
    local local_file="dist/$name"
    
    if [ -f "$local_file" ]; then
        if [ "$USER_LANG" = "zh" ]; then
            echo -e "📦 检测到本地已编译好的二进制文件，正在安装 $name ..."
        else
            echo -e "📦 Local pre-compiled binary found, installing $name ..."
        fi
        cp "$local_file" "$INSTALL_DIR/"
    else
        if [ "$GITHUB_USER" = "YOUR_GITHUB_USERNAME" ] || [ "$GITHUB_REPO" = "YOUR_GITHUB_REPO" ]; then
            echo -e "${RED}❌ Error: GITHUB_USER / GITHUB_REPO not configured in install.sh.${NC}"
            exit 1
        fi

        if [ "$USER_LANG" = "zh" ]; then
            echo -e "🌐 正在从 GitHub 获取最新版本 $name 的下载链接..."
        else
            echo -e "🌐 Fetching download link for $name from GitHub..."
        fi
        
        # Resolve redirect from latest releases
        REDIRECT_URL=$(curl -sI "https://github.com/$GITHUB_USER/$GITHUB_REPO/releases/latest" | grep -i '^location:' | cut -d' ' -f2 | tr -d '\r\n' || true)
        
        if [ -n "$REDIRECT_URL" ] && [[ "$REDIRECT_URL" == *"/releases/tag/"* ]]; then
            TAG=$(basename "$REDIRECT_URL")
            DOWNLOAD_URL="https://github.com/$GITHUB_USER/$GITHUB_REPO/releases/download/$TAG/$name"
        else
            # Fallback REST API
            API_URL="https://api.github.com/repos/$GITHUB_USER/$GITHUB_REPO/releases/latest"
            DOWNLOAD_URL=$(curl -s "$API_URL" | grep -o '"browser_download_url": *"[^"]*"' | grep -o 'http[^"]*' | grep -E "/$name$" | head -n 1 || true)
        fi
        
        if [ -z "$DOWNLOAD_URL" ] || [[ "$DOWNLOAD_URL" == *"rate limit exceeded"* ]]; then
            if [ "$USER_LANG" = "zh" ]; then
                echo -e "${RED}❌ 错误: 无法获取 $name 的下载链接，可能 Releases 中尚未发布此文件。${NC}"
            else
                echo -e "${RED}❌ Error: Failed to retrieve download link for $name. Check if the asset exists in Releases.${NC}"
            fi
            exit 1
        fi

        if [ "$USER_LANG" = "zh" ]; then
            echo -e "⚡ 正在下载最新版 $name ..."
        else
            echo -e "⚡ Downloading latest release of $name ..."
        fi
        curl -L -# "$DOWNLOAD_URL" -o "$INSTALL_DIR/$name"
    fi
    
    chmod +x "$INSTALL_DIR/$name"
}

# Install both tools
install_binary "douyin-dl"
install_binary "tiktok-dl"

# 3. Configure Terminals/Aliases
echo -e "\n${YELLOW}💬 配置启动命令 / Configure Startup Commands:${NC}"

# Configure Douyin Command
if [ "$USER_LANG" = "zh" ]; then
    read -p "请输入 抖音下载器 终端激活命令 (回车默认使用 'douyin-dl'): " CUSTOM_DOUYIN < /dev/tty
else
    read -p "Enter terminal command for Douyin downloader (Press Enter for 'douyin-dl'): " CUSTOM_DOUYIN < /dev/tty
fi
if [ -z "$CUSTOM_DOUYIN" ]; then
    CUSTOM_DOUYIN="douyin-dl"
fi
ln -sf "$INSTALL_DIR/douyin-dl" "$BIN_DIR/$CUSTOM_DOUYIN"

# Configure TikTok Command
if [ "$USER_LANG" = "zh" ]; then
    read -p "请输入 TikTok下载器 终端激活命令 (回车默认使用 'tiktok-dl'): " CUSTOM_TIKTOK < /dev/tty
else
    read -p "Enter terminal command for TikTok downloader (Press Enter for 'tiktok-dl'): " CUSTOM_TIKTOK < /dev/tty
fi
if [ -z "$CUSTOM_TIKTOK" ]; then
    CUSTOM_TIKTOK="tiktok-dl"
fi
ln -sf "$INSTALL_DIR/tiktok-dl" "$BIN_DIR/$CUSTOM_TIKTOK"

# 4. Check Environment $PATH
NEED_SOURCE=false
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    if [ "$USER_LANG" = "zh" ]; then
        echo -e "\n⚙️  正在检测并配置环境变量..."
    else
        echo -e "\n⚙️  Detecting and configuring environment PATH..."
    fi
    
    # Write ~/.bashrc
    if [ -f "$HOME/.bashrc" ]; then
        if ! grep -q "export PATH=\"\$HOME/.local/bin:\$PATH\"" "$HOME/.bashrc"; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
            NEED_SOURCE=true
        fi
    fi
    
    # Write ~/.zshrc
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "export PATH=\"\$HOME/.local/bin:\$PATH\"" "$HOME/.zshrc"; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
            NEED_SOURCE=true
        fi
    fi
fi

# Print Success message
echo -e "${GREEN}==================================================${NC}"
if [ "$USER_LANG" = "zh" ]; then
    echo -e "${GREEN}🎉 安装与配置成功！${NC}"
    echo -e "${GREEN}==================================================${NC}"
    echo -e "📁 程序保存路径: ${BLUE}$INSTALL_DIR${NC}"
    echo -e "🚀 抖音下载命令: ${BLUE}$CUSTOM_DOUYIN${NC}"
    echo -e "🚀 TikTok下载命令: ${BLUE}$CUSTOM_TIKTOK${NC}"
    echo -e ""
    echo -e "${YELLOW}🔔 使用提示:${NC}"
    if [ "$NEED_SOURCE" = true ]; then
        echo -e "1. 💡 ${YELLOW}请先运行 'source ~/.bashrc' (或 'source ~/.zshrc') 使配置生效！${NC}"
        echo -e "2. 之后在终端任意目录下运行 ${GREEN}$CUSTOM_DOUYIN${NC} 或 ${GREEN}$CUSTOM_TIKTOK${NC} 即可下载！"
    else
        echo -e "1. 终端任意目录下直接运行 ${GREEN}$CUSTOM_DOUYIN${NC} 或 ${GREEN}$CUSTOM_TIKTOK${NC} 即可下载！"
    fi
else
    echo -e "${GREEN}🎉 Installation & Configuration Successful!${NC}"
    echo -e "${GREEN}==================================================${NC}"
    echo -e "📁 Installation Directory: ${BLUE}$INSTALL_DIR${NC}"
    echo -e "🚀 Douyin Command: ${BLUE}$CUSTOM_DOUYIN${NC}"
    echo -e "🚀 TikTok Command: ${BLUE}$CUSTOM_TIKTOK${NC}"
    echo -e ""
    echo -e "${YELLOW}🔔 Note:${NC}"
    if [ "$NEED_SOURCE" = true ]; then
        echo -e "1. 💡 ${YELLOW}Please run 'source ~/.bashrc' (or 'source ~/.zshrc') to apply PATH changes!${NC}"
        echo -e "2. Then type ${GREEN}$CUSTOM_DOUYIN${NC} or ${GREEN}$CUSTOM_TIKTOK${NC} anywhere in terminal to start."
    else
        echo -e "1. Type ${GREEN}$CUSTOM_DOUYIN${NC} or ${GREEN}$CUSTOM_TIKTOK${NC} anywhere in your terminal to start."
    fi
fi
echo -e "=================================================="
