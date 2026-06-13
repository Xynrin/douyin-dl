# GUI 版本实现计划（分解任务并排序）

## [ ] Task 1: 实现共享下载核心逻辑模块（与 GUI 解耦）
- **Priority**: P0
- **Depends On**: None
- **Description**: 
  - 在项目根目录新建 `gui_downloader.py`，其内部封装：
    - `get_default_output_dir(platform) -> str`：返回 Windows 桌面默认保存路径（根据平台选择 `douyin_downloads` 或 `tiktok_downloads`）。
    - `run_download(platform, raw_text, output_dir, log_callback, progress_callback, done_callback, cancel_event)`：在后台线程中运行，负责：
      1. 导入 `douyin_image_downloader` 或 `tiktok_downloader` 对应模块。
      2. 调用对应的 `extract_urls_from_text` 并去重。
      3. 调用 `ensure_browser_installed`。
      4. 在循环中调用 `process_single`，每次调用前检查 `cancel_event.is_set()`，若为 True 则停止继续处理并退出循环。
      5. 以 `print` 替换为 `log_callback(line)` 形式：通过临时将 `sys.stdout` 重定向到一个捕获类，以最小改动复用现有 CLI 的输出。
      6. 通过 `progress_callback(current, total, status)` 更新进度（status 含 "已取消" 等状态）。
      7. 完成后调用 `done_callback(success, fail, cancelled, path)`（含取消标志）。
- **Acceptance Criteria Addressed**: AC-2, AC-3, AC-4, AC-5, AC-6, AC-9
- **Test Requirements**:
  - `programmatic` TR-1.1: `get_default_output_dir("douyin")` 必须返回以 `Desktop\\douyin_downloads` 结尾的绝对路径；同样验证 "tiktok"。
  - `programmatic` TR-1.2: `extract_urls_from_text` 对以下输入正确返回非空列表：
    - 纯 URL：`"https://www.douyin.com/video/1234567890123456789"`
    - 包含分享文本：`"看这个视频 https://www.douyin.com/video/... 很有趣"`
    - 多条链接（换行或空格分隔）
    - 重复链接，返回结果需去重（由 `run_download` 内部处理）
  - `programmatic` TR-1.3: 平台字符串到模块的映射正确（douyin -> douyin_image_downloader, tiktok -> tiktok_downloader）。
- **Notes**: 推荐通过重定向 `sys.stdout` 捕获 print 输出到日志，避免修改两个既有下载文件；保持对现有文件的 "零改动" 原则。

## [ ] Task 2: 实现 GUI 主界面（tkinter）
- **Priority**: P0
- **Depends On**: Task 1
- **Description**: 
  - 在 `gui_downloader.py` 中构建 `App(tk.Tk)` 主类，包含：
    - 顶部标题栏与图标（可选）。
    - 免责声明对话框 `DisclaimerDialog(tk.Toplevel)`：含只读 `ScrolledText`（免责声明全文）、`Checkbutton`（必须勾选"我已阅读并同意"）、`Checkbutton`（可选"不再提示"）、`Button`（"继续"：勾选同意后启用）、`Button`（"退出"）。
    - 平台下拉框 `ttk.Combobox(values=["抖音", "TikTok"])`.
    - 链接输入 `tk.Text(height=8)`.
    - 保存路径 `ttk.Entry` + `ttk.Button("浏览")` 触发 `filedialog.askdirectory()`.
    - 按钮行：`开始下载`（空闲时）/ `取消下载`（下载中）、`打开输出目录`.
    - 进度条 `ttk.Progressbar`.
    - 日志区 `tk.Text(state="disabled")`，为错误文字定义 tag（如 `"error" -> foreground red`）.
    - 状态栏 `ttk.Label`。
  - 界面布局与排版；支持窗口最小尺寸与 resizable。
  - 中英文文案通过读取 `LANG` 常量切换。
- **Acceptance Criteria Addressed**: AC-1, AC-7, AC-11
- **Test Requirements**:
  - `human-judgement` TR-2.1: 启动窗口出现免责声明对话框，不勾选无法进入主界面；勾选并继续后进入主界面。
  - `human-judgement` TR-2.2: 主界面元素按 FR-3 描述完整出现，无错位/重叠。
  - `human-judgement` TR-2.3: 切换 `config.json` `"lang": "en"` 后重启，界面变为英文。

## [ ] Task 3: 连接 GUI 事件与后台下载线程
- **Priority**: P0
- **Depends On**: Task 2
- **Description**: 
  - 维护一个 `threading.Event` 实例 `self.cancel_event`，初始为未设置状态。
  - `App.on_start_download()`：
    - 校验输入非空。
    - 重置 `cancel_event`（`clear()`）。
    - 将主按钮文本改为"取消下载"，绑定 `on_cancel()`。
    - 启动后台线程执行 `run_download(..., cancel_event=self.cancel_event)`。
    - 主线程使用 `self.after(100, self.poll_log_queue)` 轮询 `queue.Queue`，将日志追加到日志区、更新进度。
  - `App.on_cancel()`：设置 `cancel_event`（`set()`），日志追加"正在取消..."，按钮恢复为"开始下载"。
  - `App.on_done(success, fail, cancelled, path)`：由后台线程通过 `queue.put(("done", ...))` 发送，主线程处理时恢复按钮并在状态栏显示"完成 (成功: N / 失败: M / 已取消)"或"已取消"。
  - `App.on_browse_output_dir()`：使用 `os.startfile` 打开目录；若目录不存在则先 `os.makedirs`。
  - `App.on_browse()`：弹出目录选择器；更新路径并写入 `config.json`。
- **Acceptance Criteria Addressed**: AC-3, AC-7, AC-8
- **Test Requirements**:
  - `human-judgement` TR-3.1: 点击"开始下载"后按钮变为"取消下载"；点击后下载停止，按钮恢复为"开始下载"，状态栏显示"已取消"。
  - `human-judgement` TR-3.2: 下载期间日志窗口持续追加文字，进度条更新。
  - `human-judgement` TR-3.3: 点击"打开输出目录"正常弹出资源管理器定位到目录。

## [ ] Task 4: 读取/写入 `config.json` 支持
- **Priority**: P1
- **Depends On**: Task 1
- **Description**: 
  - 在 `gui_downloader.py` 中提供：
    - `load_config() -> dict`：读取 exe 或脚本所在目录的 `config.json`；不存在则返回默认 `{"lang": "zh"}`。
    - `save_config(cfg: dict)`：将配置写回；包括 `lang`、`last_output_dir`、`disclaimer_agreed`。
  - 启动时：
    - 若 `disclaimer_agreed == true`，跳过免责声明；否则显示。
    - 若存在 `last_output_dir`，使用其作为保存路径；否则使用默认桌面路径。
- **Acceptance Criteria Addressed**: AC-2, AC-11
- **Test Requirements**:
  - `programmatic` TR-4.1: 删除 `config.json` 后启动，默认路径为桌面的 `douyin_downloads`。
  - `programmatic` TR-4.2: 修改 `config.json` 为 `{"lang":"en", "disclaimer_agreed":true}`，再次启动不弹窗且显示英文。
  - `programmatic` TR-4.3: 浏览并选择新目录后，`config.json` 中写入了 `last_output_dir` 字段。

## [ ] Task 5: 异常处理与错误日志高亮
- **Priority**: P1
- **Depends On**: Task 3
- **Description**: 
  - 在 `run_download` 中用 `try/except` 包裹整个工作流，捕获异常后通过日志队列发送 `("error", msg)` 消息。
  - `App` 处理时将 `error` 消息以红色 tag 渲染。
  - 对 `os.startfile`、`filedialog.askdirectory`、文件写入等都做防御性异常处理。
- **Acceptance Criteria Addressed**: AC-9, NFR-4
- **Test Requirements**:
  - `human-judgement` TR-5.1: 粘贴一个无效 URL（如 `https://example.com/invalid`），日志以红色提示解析失败，GUI 不崩溃。
  - `human-judgement` TR-5.2: 将保存路径设置为只读路径（或虚构磁盘），错误以红色文字提示。

## [ ] Task 6: 提供 PyInstaller 打包脚本 `build_exe.bat`
- **Priority**: P0
- **Depends On**: Task 5
- **Description**: 
  - 新建 `build_exe.bat`（Windows 批处理脚本）：
    - 检查 Python 与依赖。
    - 运行 `pip install playwright Pillow pyinstaller`（可选步骤）。
    - 运行 `python -m playwright install chromium`（仅打包时可选择跳过，但建议在脚本中提示用户首次运行 exe 时自动安装）。
    - 运行 PyInstaller 命令：
      ```
      pyinstaller --noconfirm --onefile --noconsole ^
        --name "MediaDownloader_GUI" ^
        --collect-all playwright ^
        --collect-all PIL ^
        gui_downloader.py
      ```
    - 完成后在 `dist/` 生成 `MediaDownloader_GUI.exe`。
  - 在脚本首部添加简单说明文字（使用 `REM` 注释）。
- **Acceptance Criteria Addressed**: AC-10
- **Test Requirements**:
  - `programmatic` TR-6.1: 在安装了依赖的 Windows 环境运行 `build_exe.bat`，退出码为 0 且 `dist/MediaDownloader_GUI.exe` 存在。
  - `human-judgement` TR-6.2: 双击生成的 exe，启动流程与 python 运行一致；能进入主界面并执行下载。

## [ ] Task 7 ~~: 启动检查更新与浏览器就绪提示~~（已移除：更新功能不在 GUI 中实现）

## [ ] Task 8: 中文路径兼容性验证
- **Priority**: P1
- **Depends On**: Task 3, Task 6
- **Description**: 
  - 在 `run_download` 中，对 `output_dir` 做 `os.makedirs(output_dir, exist_ok=True)` 并确保 Python 脚本以 UTF-8 模式运行（PyInstaller 打包通常已处理）。
  - 在 Windows 上使用中文路径做一次下载验收。
- **Acceptance Criteria Addressed**: AC-12
- **Test Requirements**:
  - `human-judgement` TR-8.1: 将保存路径设置为 `C:\Users\用户\桌面\我的下载`，执行一次下载并确认文件落盘成功。

## [ ] Task 9: 编写最小验证脚本 `verify_gui_smoke.py`（非交互冒烟测试）
- **Priority**: P2
- **Depends On**: Task 1
- **Description**: 
  - 新建 `verify_gui_smoke.py`：
    - 断言 `get_default_output_dir(...)` 返回正确默认路径。
    - 导入 `douyin_image_downloader.extract_urls_from_text` 与 `tiktok_downloader.extract_urls_from_text`，对若干样本输入做断言。
    - 不启动真实 GUI 或下载，仅验证核心函数的可用性与正确性。
- **Acceptance Criteria Addressed**: AC-2, AC-3
- **Test Requirements**:
  - `programmatic` TR-9.1: `python verify_gui_smoke.py` 退出码为 0。
  - `programmatic` TR-9.2: 输出显示若干 "PASS" 标记。

## Summary of Task Order
1. Task 1（核心逻辑封装，含 threading.Event 取消标志）
2. Task 2 + Task 4（GUI 结构 + config.json 读写，可并发）
3. Task 3（事件与线程桥接，含取消下载按钮逻辑）
4. Task 5（异常处理与错误日志高亮）
5. ~~Task 7~~（已移除，更新功能不在 GUI 中实现；浏览器就绪提示在 Task 3 的下载流程中自然覆盖）
6. Task 6（打包脚本）
7. Task 8（中文路径验证）
8. Task 9（冒烟测试脚本）
