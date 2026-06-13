# TikTok/抖音 媒体批量下载器 (GUI 版本) - 产品需求文档

## Overview
- **Summary**: 基于现有的两个命令行工具 `douyin_image_downloader.py`（抖音图文/视频下载器）和 `tiktok_downloader.py`（TikTok 媒体下载器），构建一个适用于 Windows 平台的图形用户界面 (GUI) 版本。该 GUI 使用 Python 内置的 `tkinter` 库，提供用户友好的操作界面来输入链接、选择保存路径、查看下载进度和日志，并最终打包为独立的 Windows 可执行文件 (`.exe`)。
- **Purpose**: 解决命令行工具对非技术用户门槛高的问题，提供直观的可视化界面；统一抖音与 TikTok 两个下载器在 GUI 中的使用体验；提供可执行文件形式以便分发给无 Python 环境的用户。
- **Target Users**: Windows 用户，需要便捷下载抖音 / TikTok 视频和图文，且不熟悉命令行操作的普通用户或技术用户。

## Goals
1. 提供一个基于 `tkinter` 的 GUI，支持输入一个或多个抖音/TikTok 链接（支持分享文本粘贴与纯数字 ID）。
2. 支持选择下载保存目录，默认路径为 Windows 桌面 (`%USERPROFILE%\Desktop`) 下的 `douyin_downloads` 或 `tiktok_downloads` 子目录。
3. 提供平台选择（抖音 / TikTok），由 GUI 调用对应的下载逻辑（复用现有两个文件的核心函数）。
4. 提供实时的下载进度、日志输出窗口，并包含开始/取消下载、打开输出目录等辅助按钮。
5. 提供 `免责声明` 弹窗，每次启动都需要用户确认同意（提供"不再提示"勾选选项，勾选后写入 `config.json`，下次启动自动跳过）。
6. 打包为 Windows `.exe` 可执行文件（PyInstaller + Playwright 浏览器自动安装提示）。
7. 适配中文/英文双语界面（保留现有 `LANG` 逻辑）。
8. 支持下载中途取消（"取消下载"按钮可中断正在进行的下载任务）。

## Non-Goals (Out of Scope)
- 不修改 `douyin_image_downloader.py` 与 `tiktok_downloader.py` 中已有核心下载逻辑（GUI 作为新的入口复用它们的函数）。
- 不提供 macOS / Linux 打包，仅聚焦 Windows 可执行文件。
- 不实现账号登录、收藏、历史记录管理等高级功能。
- 不实现 Web 界面或远程控制。
- 不提供下载后视频剪辑/格式转换功能。

## Background & Context
- 项目现有的两个 CLI 工具使用 `Playwright` 驱动 Chromium 浏览器解析页面 JSON 注水数据，配合直接 API 下载视频/图文。
- `douyin_image_downloader.py` 的入口下载函数为 `download_urls(raw_input, output_dir)`，其内部使用 `extract_urls_from_text`、`process_single`、`download_video`、`ensure_browser_installed` 等。
- `tiktok_downloader.py` 具有类似结构的 `download_urls(raw_input, output_dir)` 与 `process_single`、`ensure_browser_installed` 等。
- 两个文件都包含 `DISCLAIMER`、`LANG`、`config.json` 语言配置等。
- GUI 不依赖原 CLI 的 `check_for_updates` 功能（已移除更新检查逻辑）。
- 打包工具将使用 `PyInstaller`（`--onefile --noconsole --name`），并通过 `PLAYWRIGHT_BROWSERS_PATH` 环境变量定位 Playwright Chromium（保留两文件中已有处理逻辑）。

## Functional Requirements
- **FR-1**: 启动时，读取 `config.json` 的 `lang` 字段；若不存在或文件缺失，则默认 `zh`。GUI 界面文案按语言切换（中文/英文）。
- **FR-2**: 启动时弹出 `免责声明` 对话框（可滚动查看），包含：
  - 免责声明全文（不可编辑，不可复制，只读）。
  - "我已阅读并同意以上免责声明" 复选框（必须勾选）。
  - "不再提示" 复选框（可选，勾选后下次启动自动跳过免责声明并直接进入主界面）。
  - "继续" 按钮：勾选同意后可用，点击进入主界面。
  - "退出" 按钮：拒绝免责声明，退出程序。
  - 若 `config.json` 中存在 `"disclaimer_agreed": true`，则跳过此弹窗直接进入主界面。
- **FR-3**: 主界面包含以下元素：
  - 平台选择：下拉框（`抖音`/`TikTok`），默认 `抖音`。
  - 链接输入框：多行文本框，可粘贴多条链接或分享文本（支持每行一个或用空格/换行分隔）。
  - 保存路径显示框 + `浏览` 按钮：打开系统文件夹选择对话框。
  - `开始下载` / `取消下载` 按钮：触发下载或中断下载；下载中显示"取消下载"，空闲时显示"开始下载"。
  - `打开输出目录` 按钮：下载完成或路径选中后可用，使用系统默认方式打开所选目录（`os.startfile` on Windows）。
  - 实时日志输出：只读文本控件，显示下载过程中的每一行日志（复用原 CLI 的 `t(...)` 格式化输出）。
  - 进度条：显示当前下载进度（已处理链接数 / 总链接数）。
  - 状态栏：显示当前状态（就绪、下载中、已取消、完成、错误等）。
- **FR-4**: 默认保存路径：
  - 当平台 = 抖音：`%USERPROFILE%\Desktop\douyin_downloads`
  - 当平台 = TikTok：`%USERPROFILE%\Desktop\tiktok_downloads`
  - 用户可通过 `浏览` 按钮修改，修改后需记忆到一个简单的配置（例如写入 `config.json` 的 `last_output_dir` 字段）。
- **FR-5**: 下载过程在后台线程（`threading.Thread`）中执行，避免阻塞 GUI；主线程通过 `queue.Queue` 与 `tkinter.after()` 轮询刷新日志和进度条。支持通过 `threading.Event` 标志位在下载中途响应"取消下载"操作。
- **FR-6**: `开始下载` 按钮在下载期间变为 `取消下载`；用户点击后设置取消标志，后台线程感知后停止继续下载下一个链接（已完成的不回滚）；按钮在取消后恢复为 `开始下载`。
- **FR-7**: 下载过程中：
  - 对用户输入进行链接提取（复用 `extract_urls_from_text`），若用户只输入纯数字 ID（抖音），兼容为 `https://www.douyin.com/video/{id}`。
  - 复用现有 `process_single` / `download_urls` 的解析与下载逻辑（以抖音或 TikTok 的函数为准）。
  - 将原本 `print()` 的每一行日志，通过回调追加到 GUI 日志窗口。
- **FR-8**: 运行时复用 `ensure_browser_installed`，若首次运行没有 Chromium，自动提示并调用 `playwright install chromium`；在 GUI 日志中清晰反映进度。
- **FR-9**: 提供 `PyInstaller` 构建脚本或指令（例如 `build_exe.bat`），生成单文件 `exe`。构建时必须处理好 `--collect-all playwright --collect-all PIL` 等依赖。
- **FR-10**: 支持中文路径（UTF-8 处理），避免因保存路径含中文字符导致崩溃。

## Non-Functional Requirements
- **NFR-1**: GUI 启动时间 < 5 秒（普通 Windows 10/11 机器上），界面清晰可读，字号适中。
- **NFR-2**: 下载逻辑与 GUI 严格解耦：所有 I/O/网络/浏览器操作在后台线程中完成，主线程只负责渲染与状态更新。
- **NFR-3**: 代码需具备良好的可维护性：新建一个文件 `gui_downloader.py` 作为 GUI 入口，尽量少修改原有两个下载文件（最多允许为支持日志回调做一个小的函数重构，若无必要则不改）。
- **NFR-4**: 异常处理：下载中任何异常不会使 GUI 崩溃，会在日志中以红色/显著文字体现。
- **NFR-5**: 可执行文件在 Windows 10/11（64 位）上双击即可运行，无需安装 Python；首次运行若 Playwright 浏览器缺失，会自动安装（或提示安装）。

## Constraints
- **Technical**: Python 3.9+；GUI 使用标准库 `tkinter`（不引入 PyQt 等第三方 UI 库，便于 PyInstaller 打包）；依赖：`playwright`、`Pillow`、`pyinstaller`（构建时）。
- **Business**: 仅分发自用；必须保留现有的免责声明文字并在 GUI 中显式展示。
- **Dependencies**: Playwright 依赖系统级的 Chromium 安装（由 `playwright install chromium` 或自动安装处理）；不修改现有 `PLAYWRIGHT_BROWSERS_PATH` 环境变量逻辑。

## Assumptions
- 用户运行环境为 64 位 Windows 10 或 Windows 11，具备网络访问权限。
- Playwright 安装脚本在首次运行需要能够访问下载源（Microsoft CDN）。
- 用户账号有权在桌面写文件。

## Acceptance Criteria

### AC-1: GUI 启动与免责声明
- **Given**: 用户在 Windows 上运行 GUI 可执行文件或 `python gui_downloader.py`
- **When**: 程序启动
- **Then**: 显示免责声明弹窗，包含：只读免责声明全文、"我已阅读并同意"复选框（必须勾选）、"不再提示"复选框（可选）、"继续"按钮（勾选后可用）、"退出"按钮。若 `config.json` 中有 `"disclaimer_agreed": true`，则直接跳过此弹窗进入主界面。拒绝（不勾选同意直接点继续或点退出）则程序退出。
- **Verification**: `human-judgment`（由测试者启动 GUI，手动交互验证）
- **Notes**: 文本需与原 CLI 的 `DISCLAIMER` 完全一致（按 `LANG` 切换）；"不再提示"写入 `config.json` 后下次自动跳过。

### AC-2: 默认保存路径为桌面
- **Given**: 用户首次启动 GUI，未手动修改过保存路径
- **When**: 在主界面查看 "保存路径" 输入框
- **Then**: 默认值为 `%USERPROFILE%\Desktop\douyin_downloads`（当平台=抖音）或 `%USERPROFILE%\Desktop\tiktok_downloads`（当平台=TikTok）。
- **Verification**: `programmatic`（代码中读取默认路径，并在 `tasks` 的单元验证中打印断言）

### AC-3: 链接输入与去重
- **Given**: 用户在链接输入框粘贴多条链接 / 分享文本 / 纯数字 ID
- **When**: 点击 "开始下载"
- **Then**: 从文本中正确提取 URL 或 ID（抖音），去重后进入下载队列；日志显示提取到的链接数量。
- **Verification**: `programmatic`（对 `extract_urls_from_text` 进行若干断言测试）

### AC-4: 抖音视频下载成功
- **Given**: 平台选择 `抖音`，保存路径为桌面，输入一条可公开访问的抖音视频链接
- **When**: 点击 "开始下载" 并等待完成
- **Then**: 在保存路径下生成 `{aweme_id}_{title}.mp4` 文件；日志输出成功信息；进度条走满。
- **Verification**: `human-judgment`（测试者操作并确认文件存在）

### AC-5: 抖音图文下载成功
- **Given**: 平台选择 `抖音`，输入一条图文作品链接
- **When**: 点击 "开始下载"
- **Then**: 在保存路径下生成 `{aweme_id}_{title}/image_{n}.jpg` 多张图片。
- **Verification**: `human-judgment`

### AC-6: TikTok 视频下载成功
- **Given**: 平台选择 `TikTok`，输入一条 TikTok 视频链接
- **When**: 点击 "开始下载"
- **Then**: 在保存路径下生成视频文件。
- **Verification**: `human-judgment`

### AC-7: 下载过程中 GUI 不冻结 + 取消功能
- **Given**: 用户已点击 "开始下载"
- **When**: 在下载期间拖动窗口、滚动日志，或点击 "取消下载"
- **Then**: 窗口响应正常；日志实时追加；进度条持续更新；按钮在下载期间显示"取消下载"，点击后下载停止（已完成的不回滚），按钮恢复为"开始下载"，状态栏显示"已取消"。
- **Verification**: `human-judgment`

### AC-8: 打开输出目录按钮行为正确
- **Given**: 已选定保存路径（或使用默认）
- **When**: 点击 "打开输出目录" 按钮
- **Then**: 在 Windows 文件资源管理器中打开该目录；若目录不存在则自动创建。
- **Verification**: `human-judgment`

### AC-9: 日志与错误显示
- **Given**: 下载过程中出现网络错误或解析失败
- **When**: 错误发生
- **Then**: 在日志窗口以醒目的颜色（例如红色）显示错误信息，GUI 不崩溃；进度条继续处理后续链接。
- **Verification**: `human-judgment`

### AC-10: PyInstaller 打包生成可用 exe
- **Given**: 已在 Windows 上安装好 Python、依赖与 PyInstaller
- **When**: 运行提供的 `build_exe.bat`（或 README 指令）
- **Then**: 在 `dist/` 目录生成单个可执行文件（如 `MediaDownloader_GUI.exe`），双击可启动，功能与 `python gui_downloader.py` 完全一致。
- **Verification**: `programmatic` + `human-judgment`（运行打包脚本并在 dist 中检查文件存在；手动启动 exe 验证基本流程）

### AC-11: 中英文界面切换
- **Given**: 在 `config.json` 中设置 `"lang": "en"` 或 `"lang": "zh"`
- **When**: 启动 GUI
- **Then**: 界面按钮、提示、日志均使用对应语言。
- **Verification**: `human-judgment`

### AC-12: 中文路径兼容性
- **Given**: 用户将保存路径修改为含中文/空格的目录，例如 `C:\Users\用户\桌面\我的下载`
- **When**: 执行一次下载
- **Then**: 文件能正确写入该路径，无 `UnicodeEncodeError` 或 `FileNotFoundError`。
- **Verification**: `human-judgment`

## Open Questions
- [x] 是否需要提供 "取消下载" 按钮以中断当前下载线程？ → **已确认：需要**，使用 `threading.Event` 标志位实现。
- [x] 是否需要保留 `check_for_updates` 的交互弹窗？ → **已确认：不需要**，更新功能已从 GUI 中移除，不依赖原 CLI 的更新逻辑。
- [x] 是否需要保留 "运行即同意免责声明" 逻辑？ → **已确认：每次启动都显示免责声明**，但提供"不再提示"勾选选项（勾选后写入 `config.json` 的 `disclaimer_agreed: true`，下次启动自动跳过）。
