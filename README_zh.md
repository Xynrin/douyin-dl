# 🚀 TikTok & 抖音无水印视频/图文下载器 (Linux 独立版)

[![Release](https://img.shields.io/github/v/release/Xynrin/tiktok-douyin-dl?color=brightgreen&logo=github&style=flat-square)](https://github.com/Xynrin/tiktok-douyin-dl/releases)
[![License](https://img.shields.io/github/license/Xynrin/tiktok-douyin-dl?color=blue&style=flat-square)](file:///home/xxy/project/douyin-dl/LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux-blue?logo=linux&style=flat-square)](#)

面向 Linux 用户的高效命令行工具套件，用于批量下载 TikTok 和 抖音无水印的视频和图文作品。软件完美打包了内置 Python 运行沙箱、Pillow 图像库和 Playwright 浏览器，**完全独立，零环境依赖**。

---

🌐 **[English](README.md)** | **[简体中文]**

---

## ✨ 核心特性

* **📦 零环境依赖**：无需安装 Python、Playwright 或浏览器驱动，所有运行环境和浏览器均已内置。
* **🌐 双语显示选择**：在安装过程中，可自由选择终端显示语言为 **简体中文** 或 **English**。
* **⚡ 独立编译产物**：针对不同平台拆分为独立的可执行文件，保持轻量：
  * `douyin-dl`：下载抖音视频与图文相册。
  * `tiktok-dl`：下载 TikTok 视频与图文幻灯片。
* **🌐 极速一键安装**：支持通过单条终端指令自动拉取最新双平台二进制包并配置全局命令。
* **🎬 智能提取**：自动从粘贴的分享文本中提取出链接，支持单个/批量解析下载。
* **⚖️ 完备免责保障**：内置强交互式法律免责声明，规范使用界限，降低开发风险。

---

## 🛠️ 安装方法 (Linux)

在终端运行以下命令，选择显示语言，即可自动拉取最新双平台文件并软链接至您的个人命令目录 (`~/.local/bin`)：

```bash
curl -fsSL "https://raw.githubusercontent.com/Xynrin/tiktok-douyin-dl/main/install.sh?v=$(date +%s)" | bash
```

> 💡 **提示**：安装过程中可自定义各自的启动命令（默认为 `douyin-dl` 与 `tiktok-dl`）。请确保您的环境变量中包含 `~/.local/bin`。若没有，请在 `~/.bashrc` 或 `~/.zshrc` 末尾追加 `export PATH="$HOME/.local/bin:$PATH"` 并执行 `source` 使其生效。

---

## 🚀 使用方法

### 1. 抖音下载器
直接在终端输入启动指令（默认为 `douyin-dl`）：
```bash
douyin-dl
```
或命令行静默运行：
```bash
douyin-dl "分享文本或链接" [保存目录]
```

### 2. TikTok 下载器
直接在终端输入启动指令（默认为 `tiktok-dl`）：
```bash
tiktok-dl
```
Icon
或命令行静默运行：
```bash
tiktok-dl "分享文本或链接" [保存目录]
```

---

## ⚖️ 免责声明

> [!IMPORTANT]
> **在下载或运行本软件前，请务必仔细阅读并同意以下条款：**
> 
> 1. **学术及学习限制**：本软件仅限用于个人学习研究、学术交流及网页技术备份测试，严禁用于任何商业用途、非法抓取或网络攻击。
> 2. **知识产权归属**：本软件所下载的所有音视频、图文等媒体资源，其知识产权及著作权归原作者/版权所有者或相关平台所有。用户下载后应于 24 小时内删除，且不得在未经原作者授权的情况下进行二次传播、修改、上传或用于任何盈利性活动。
> 3. **合规与风控责任**：用户在使用本软件时，必须遵守当地法律法规、目的平台用户协议及相关服务条款。因使用本软件导致的一切直接或间接法律纠纷、版权诉讼、经济赔偿，或因频繁请求导致的平台账号限制、IP风控封禁等后果，均由使用者自行承担全部责任。
> 4. **无明示保证**：本软件按“原样”（AS IS）提供，不附带任何明示或暗示的保证，包括但不限于对特定用途的适用性。作者在任何情况下均不对因使用或无法使用本软件而产生的任何直接、间接、偶然、特殊或惩罚性损害承担任何赔偿责任。
