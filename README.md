# 🚀 TikTok & Douyin Media Downloader (Linux Standalone)

[![Release](https://img.shields.io/github/v/release/Xynrin/tiktok-douyin-dl?color=brightgreen&logo=github&style=flat-square)](https://github.com/Xynrin/tiktok-douyin-dl/releases)
[![License](https://img.shields.io/github/license/Xynrin/tiktok-douyin-dl?color=blue&style=flat-square)](file:///home/xxy/project/douyin-dl/LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux-blue?logo=linux&style=flat-square)](#)

A high-speed, zero-dependency command-line utility suite for downloading TikTok and Douyin videos and images without watermarks on Linux. Packaged with a built-in Python environment, Pillow image analysis library, and Playwright Chromium runtime, both tools run fully standalone out of the box.

---

🌐 **[English]** | **[简体中文](README_zh.md)**

---

## ✨ Features

* **📦 Zero Dependencies**: No need to install Python, Playwright, or configure browser drivers. Everything is packaged in standalone binaries.
* **🌐 Multilingual Setup**: Choose between **English** and **简体中文** during installation.
* **⚡ Standalone Binaries**: Separate binaries for both platforms:
  * `douyin-dl`: For Douyin videos and photo carousels.
  * `tiktok-dl`: For TikTok videos and photo slideshows.
* **🌐 One-Click Installation**: Installs and configures terminal shortcuts for both tools automatically.
* **🎬 Auto-Detection**: Extracts links from sharing texts, supports single items and batch downloads.
* **⚖️ Built-in Disclaimer**: Protects developer rights and defines educational usage limits.

---

## 🛠️ Installation (Linux)

Run the following command in your terminal to select your language and install both tools to your path (`~/.local/bin`):

```bash
curl -fsSL "https://raw.githubusercontent.com/Xynrin/tiktok-douyin-dl/main/install.sh?v=$(date +%s)" | bash
```

> 💡 **Tip**: During installation, you will select your display language (English or Chinese) and can customize the command aliases. Please ensure `~/.local/bin` is in your environment `$PATH`. If not, add `export PATH="$HOME/.local/bin:$PATH"` to your `~/.bashrc` or `~/.zshrc` and run `source`.

---

## 🚀 Usage

### 1. Douyin Downloader
Launch the Douyin downloader (default: `douyin-dl`):
```bash
douyin-dl
```
Or quiet command line mode:
```bash
douyin-dl "Sharing Text or URL" [Output Directory]
```

### 2. TikTok Downloader
Launch the TikTok downloader (default: `tiktok-dl`):
```bash
tiktok-dl
```
Or quiet command line mode:
```bash
tiktok-dl "Sharing Text or URL" [Output Directory]
```

---

## ⚖️ Legal Disclaimer

> [!IMPORTANT]
> By downloading or using this software, you agree to the following terms:
> 
> 1. **Educational & Personal Use Only**: This software is intended strictly for personal research, educational study of web scraping, and private technical backups. Any commercial usage, malicious scraping, or network attacks are strictly prohibited.
> 2. **Intellectual Property Rights**: All media downloaded belongs to the original creators and respective platforms. You must delete downloaded files within 24 hours and must not redistribute, modify, or upload them without permission.
> 3. **Compliance & Liability**: You must comply with local laws and platform Terms of Service. The author assumes no responsibility for account limitations, network bans, copyright issues, or legal disputes arising from your use of this software.
> 4. **No Warranties**: This software is provided "AS IS", without warranties of any kind. Use at your own risk.
