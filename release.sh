#!/bin/bash
# 遇到错误立即退出
set -e

# 1. 从 Python 脚本中自动读取当前版本号 (使用 douyin_image_downloader 的版本作为整体发布版本号)
VERSION=$(./.venv/bin/python -c "import douyin_image_downloader; print(douyin_image_downloader.VERSION)")
echo "📦 开始本地打包并发布版本: v$VERSION ..."

# 2. 运行 PyInstaller 编译两套独立软件
echo "🔨 正在编译 抖音下载器 (douyin-dl) ..."
rm -rf build dist/douyin-dl
# 2.1 生成 spec 文件并用 Python 修改，排除 playwright-local-browsers 以极大地减小打包体积
./.venv/bin/python ./.venv/bin/pyi-makespec --onefile --name=douyin-dl \
  --add-data ".venv/lib/python3.14/site-packages/playwright/driver:playwright/driver" \
  douyin_image_downloader.py

./.venv/bin/python -c 'import sys; f_path=sys.argv[1]; c=open(f_path).read(); open(f_path,"w").write(c.replace("pyz = PYZ(a.pure)", "a.datas = [x for x in a.datas if \"local-browsers\" not in x[0] and \"local-browsers\" not in x[1]]\na.binaries = [x for x in a.binaries if \"local-browsers\" not in x[0] and \"local-browsers\" not in x[1]]\npyz = PYZ(a.pure)"))' douyin-dl.spec

# 2.2 使用修改后的 spec 文件进行编译
./.venv/bin/python -m PyInstaller --clean douyin-dl.spec

echo "🔨 正在编译 TikTok 下载器 (tiktok-dl) ..."
rm -rf build dist/tiktok-dl
# 2.3 生成 spec 文件并用 Python 修改，排除 playwright-local-browsers 以极大地减小打包体积
./.venv/bin/python ./.venv/bin/pyi-makespec --onefile --name=tiktok-dl \
  --add-data ".venv/lib/python3.14/site-packages/playwright/driver:playwright/driver" \
  tiktok_downloader.py

./.venv/bin/python -c 'import sys; f_path=sys.argv[1]; c=open(f_path).read(); open(f_path,"w").write(c.replace("pyz = PYZ(a.pure)", "a.datas = [x for x in a.datas if \"local-browsers\" not in x[0] and \"local-browsers\" not in x[1]]\na.binaries = [x for x in a.binaries if \"local-browsers\" not in x[0] and \"local-browsers\" not in x[1]]\npyz = PYZ(a.pure)"))' tiktok-dl.spec

# 2.4 使用修改后的 spec 文件进行编译
./.venv/bin/python -m PyInstaller --clean tiktok-dl.spec

# 清理临时文件
rm -f douyin-dl.spec tiktok-dl.spec
rm -rf build


# 3. 提交 .gitignore 等其他非源码文件的修改，并推送 Tag
git add .

# 检查是否有修改需要 commit（防止无修改时 commit 报错）
if ! git diff-index --quiet HEAD --; then
    git commit -m "release: v$VERSION"
fi

# 检查本地和远程是否已存在该 Tag，若存在则先删除（方便覆盖更新）
if git rev-parse "v$VERSION" >/dev/null 2>&1; then
    echo "⚠️ 检测到本地已存在 Tag v$VERSION，正在重置..."
    git tag -d "v$VERSION"
    git push origin --delete "v$VERSION" || true
fi

# 同时也尝试在 GitHub 上删除同名的 Release（如果存在，防止覆盖发布失败）
if command -v gh &> /dev/null && gh auth status &> /dev/null; then
    echo "🧹 正在清理 GitHub 上已有的 Release v$VERSION ..."
    gh release delete "v$VERSION" -y || true
fi

git tag "v$VERSION"
git push origin main
git push origin "v$VERSION"

# 4. 使用 gh CLI 一键创建 Release 并上传二进制文件
echo "🚀 正在创建 GitHub Release 并上传二进制文件..."

# 检查 gh 工具是否存在
if ! command -v gh &> /dev/null; then
    echo "❌ 错误: 未检测到 github-cli (gh)。请先运行 'sudo dnf install gh' 安装它。"
    exit 1
fi

# 检查 gh 是否已登录
if ! gh auth status &> /dev/null; then
    echo "🔑 请先在终端中运行 'gh auth login' 登录您的 GitHub 账号，然后重新运行本脚本。"
    exit 1
fi

# 创建或覆盖发布 Release (同时上传两套打包文件)
gh release create "v$VERSION" ./dist/douyin-dl ./dist/tiktok-dl --title "v$VERSION" --notes "Linux standalone builds for v$VERSION"

echo "🎉 发布成功！v$VERSION 二进制文件已上传至 GitHub Releases。"
