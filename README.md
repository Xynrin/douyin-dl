# 🚀 Douyin Media Downloader (Linux Standalone)

[![Release](https://img.shields.io/github/v/release/Xynrin/douyin-dl?color=brightgreen&logo=github&style=flat-square)](https://github.com/Xynrin/douyin-dl/releases)
[![License](https://img.shields.io/github/license/Xynrin/douyin-dl?color=blue&style=flat-square)](file:///home/xxy/project/douyin-dl/LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux-blue?logo=linux&style=flat-square)](#)

A high-speed, zero-dependency command-line utility for downloading Douyin videos and images without watermarks on Linux. Packaged with a built-in Python environment, Pillow image analysis library, and Playwright Chromium runtime, it runs fully standalone out of the box.

---

🌐 **[English]** | **[简体中文](README_zh.md)**

---

## ✨ Features

* **📦 Zero Dependencies**: No need to install Python, Playwright, or configure browser drivers. Everything is packaged in a single standalone binary.
* **🌐 One-Click Installation**: Install and configure the terminal shortcut with a single command.
* **⚡ Smart Auto-Updates**: Prompts to check and update itself to the latest version dynamically when run in interactive mode.
* **🎬 Auto-Detection**: Extracts sharing text automatically, supports downloading single items or in batch (images & videos).
* **📊 Detailed Logs**: Outputs resolutions, formats, and download statuses cleanly.
* **⚖️ Built-in Disclaimer**: Includes a rigorous legal disclaimer to protect rights and define appropriate educational boundaries.

---

## 🛠️ Installation (Linux)

Run the following command in your terminal to fetch the latest pre-compiled binary and add it to your path (`~/.local/bin`):

```bash
curl -fsSL "https://raw.githubusercontent.com/Xynrin/douyin-dl/main/install.sh?v=$(date +%s)" | bash
```

> 💡 **Tip**: During installation, you can configure your custom command alias (defaults to `douyin-dl`). Please ensure `~/.local/bin` is in your environment `$PATH`. If not, add `export PATH="$HOME/.local/bin:$PATH"` to your `~/.bashrc` or `~/.zshrc` and run `source`.

---

## 🚀 Usage

### 1. Interactive Mode (Recommended)
Launch the tool by typing your configured command alias (default: `douyin-dl`):
```bash
douyin-dl
```
* Read the disclaimer, type `y` to accept, and paste your Douyin links or sharing texts.
* Files will be downloaded to `douyin_downloads` (or your custom directory).

### 2. Silent CLI Mode (Ideal for scripts)
```bash
douyin-dl "Sharing Text or URL" [Output Directory]
```
Example:
```bash
douyin-dl "https://v.douyin.com/xxxxxx/" ./my_downloads
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
