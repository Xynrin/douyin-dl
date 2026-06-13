# 🚀 TikTok & 抖音无水印下载器 (Windows GUI & Linux CLI)

[![Release](https://img.shields.io/github/v/release/Xynrin/tiktok-douyin-dl?color=brightgreen&logo=github&style=flat-square)](https://github.com/Xynrin/tiktok-douyin-dl/releases)
[![License](https://img.shields.io/github/license/Xynrin/tiktok-douyin-dl?color=blue&style=flat-square)](LICENSE)

一款跨平台的高效工具套件，用于批量下载 TikTok 和抖音无水印的视频和图文作品。
现已提供 **现代化的 Windows 桌面客户端** 以及 **Linux 独立命令行工具**。完美打包了内置运行沙箱与浏览器，**完全独立，零环境依赖**。

---

🌐 **[English](README.md)** | **[简体中文]**

---

## ✨ v1.2+ 全新特性 (Windows 客户端)
* 🎨 **现代化 UI 设计**：全新引入 Windows 11 Fluent 风格的暗黑模式 (Dark Mode) 极简界面。
* 🔄 **静默智能热更新**：启动时自动比对 GitHub 版本，支持一键无感下载并覆盖更新，永远保持最新反爬规则。
* 📦 **规范化安装包**：提供标准的 `Setup.exe` 安装向导，自动生成桌面快捷方式及卸载程序。
* 🛡️ **浏览器沙箱隔离**：首次运行自动下载专用的隔离浏览器内核，绝不污染或调用用户宿主机日常使用的 Chrome 浏览器。

## 📥 下载与安装

### 💻 Windows 用户 (图形界面推荐)
1. 前往 [Releases 页面](https://github.com/Xynrin/tiktok-douyin-dl/releases/latest)。
2. 下载 `MediaDownloader_Setup.exe`，双击安装即可（内置中文向导与免责声明）。
3. *可选：* 如果你偏好命令行，也可以在同页面直接下载 `douyin-dl.exe` 或 `tiktok-dl.exe`。

### 🐧 Linux 用户 (CLI 命令行)
在终端运行以下命令，即可自动拉取最新二进制包并软链接至 `~/.local/bin`：

```bash
curl -fsSL "https://raw.githubusercontent.com/Xynrin/tiktok-douyin-dl/main/install.sh?v=$(date +%s)" | bash
```
> **注意**：由于版本更新，目前的云端流水线仅打包了 Windows 版本。若要使 Linux 在线安装生效，您需要将编译好的 Linux 二进制文件（无后缀的 `douyin-dl`）上传至最新 Release 中。

---

## 🚀 使用方法

### Windows 图形界面
双击桌面生成的 **MediaDownloader** 图标，在文本框内直接粘贴你在抖音/TikTok复制的“分享文本”或纯链接，选择对应平台，点击“开始下载”即可。

### 命令行静默调用 (适用于 Linux 或 Windows CMD)
```bash
douyin-dl "分享文本或链接" [保存目录]
tiktok-dl "分享文本或链接" [保存目录]
```

## ⚖️ 免责声明
本软件仅限用于个人学习研究、学术交流及网页技术备份测试，严禁用于任何商业用途、非法抓取或网络攻击。因使用本软件导致的一切版权纠纷或账号风控后果，均由使用者自行承担全部责任。
