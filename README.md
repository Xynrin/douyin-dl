# 🚀 TikTok & Douyin Downloader (Windows GUI & Linux CLI)

[![Release](https://img.shields.io/github/v/release/Xynrin/tiktok-douyin-dl?color=brightgreen&logo=github&style=flat-square)](https://github.com/Xynrin/tiktok-douyin-dl/releases)
[![License](https://img.shields.io/github/license/Xynrin/tiktok-douyin-dl?color=blue&style=flat-square)](LICENSE)

A powerful cross-platform tool suite for downloading TikTok and Douyin videos/photos without watermarks. 
Available as a **Modern Windows GUI app** with one-click installation, and an **Independent Linux CLI tool**. **Zero environment dependencies** (built-in Python, Playwright, and drivers).

---

🌐 **[English]** | **[简体中文](README_zh.md)**

---

## ✨ New Features in v1.2+ (Windows GUI)
* 🎨 **Modern Fluent UI**: Brand new Dark Mode interface based on Windows 11 aesthetics.
* 🔄 **Smart Auto-Update**: Checks GitHub releases on startup and silently updates the app with a single click.
* 📦 **One-Click Installer**: Standard Windows `Setup.exe` installer with desktop shortcuts and uninstaller.
* 🛡️ **Built-in Browser Engine**: Automatically downloads its own isolated headless browser sandbox on first run, without interfering with your system Chrome.

## 📥 Download & Installation

### 💻 For Windows Users (GUI & CLI)
1. Go to the [Releases Page](https://github.com/Xynrin/tiktok-douyin-dl/releases/latest).
2. Download `MediaDownloader_Setup.exe` and double-click to install.
3. *Optional:* If you prefer the command line, download `douyin-dl.exe` or `tiktok-dl.exe` directly.

### 🐧 For Linux Users (CLI)
Run the following command in your terminal to automatically install the latest Linux binaries to `~/.local/bin`:

```bash
curl -fsSL "https://raw.githubusercontent.com/Xynrin/tiktok-douyin-dl/main/install.sh?v=$(date +%s)" | bash
```

> **Note:** The install script looks for Linux binaries in the latest release. Make sure the Linux binaries (`douyin-dl` / `tiktok-dl`) are uploaded to the latest release.

---

## 🚀 Usage

### Windows GUI
Simply open **MediaDownloader** from your desktop, paste the share text/links, choose the platform (Douyin/TikTok), and click "Start Download".

### CLI Usage (Linux & Windows CMD)
```bash
douyin-dl "Share text or link" [output_directory]
tiktok-dl "Share text or link" [output_directory]
```

## ⚖️ Disclaimer
By downloading or using this software, you agree that it is strictly for educational, academic, and web-testing purposes. Commercial use or illegal scraping is strictly prohibited. You are solely responsible for any copyright or legal disputes arising from its use.
