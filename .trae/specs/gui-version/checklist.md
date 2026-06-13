# GUI 版本验证清单（Checklist）

## 功能验证

- [ ] **Checkpoint 1: 项目根目录存在 `gui_downloader.py` 文件。
- [ ] **Checkpoint 2: 运行 `python gui_downloader.py` 成功启动，并弹出免责声明对话框。
- [ ] **Checkpoint 3: 免责声明对话框包含：
  - 只读免责声明全文（不可编辑）。
  - "我已阅读并同意以上免责声明" 复选框（必须勾选，"继续"按钮在未勾选时禁用）。
  - "不再提示" 复选框（可选）。
  - "继续" 按钮：勾选同意后启用，点击进入主界面。
  - "退出" 按钮：拒绝免责声明，退出程序。
- [ ] **Checkpoint 4: 点击 "退出" / 关闭对话框时程序安全退出，无未处理异常。
- [ ] **Checkpoint 4a: 勾选"不再提示"后点击"继续"，`config.json` 中写入 `disclaimer_agreed: true`；下次启动直接进入主界面，不弹出免责声明。
- [ ] **Checkpoint 5: 默认保存路径正确
  - 平台 = 抖音：路径以 `Desktop\douyin_downloads` 结尾
  - 平台 = TikTok：路径以 `Desktop\tiktok_downloads` 结尾
- [ ] **Checkpoint 6: 通过 "浏览" 按钮可更改保存路径，输入框随之更新。
- [ ] **Checkpoint 7: 保存路径被写入 `config.json` 的 `last_output_dir` 字段；下次启动自动加载该路径。
- [ ] **Checkpoint 8: 链接输入支持粘贴多条链接，启动下载前提取并去重。
- [ ] **Checkpoint 9: 抖音视频下载后，保存路径下存在 `{id}_{title}.mp4` 文件。
- [ ] **Checkpoint 10: 抖音图文下载后，保存路径下存在子目录及多张 `image_{n}.jpg`。
- [ ] **Checkpoint 11: TikTok 视频下载后，保存路径下存在视频文件。
- [ ] **Checkpoint 12: 下载期间 GUI 不冻结、窗口可拖动、日志持续滚动、进度条持续更新。
- [ ] **Checkpoint 13: 下载期间按钮显示 "取消下载"（而非禁用）；点击后下载停止（已完成的不回滚），按钮恢复为 "开始下载"，状态栏显示 "已取消"。
- [ ] **Checkpoint 14: "打开输出目录" 按钮能在资源管理器中打开目标目录（目录不存在时自动创建）。
- [ ] **Checkpoint 15: 网络错误或解析失败时，以红色文字在日志区显示，不崩溃。
- [ ] **Checkpoint 16: 设置 `config.json` 中 `"lang": "en"` 后，界面按钮与日志为英文。
- [ ] **Checkpoint 17: 中文路径（如 `桌面\我的下载`）下下载正常，无 `Unicode` 错误。
- [ ] **Checkpoint 18: 首次运行无浏览器时，日志清晰反映 Chromium 自动安装过程；安装完成后下载正常。
- [ ] ~~Checkpoint 19: 启动时日志/状态栏提示 "有新版本"（若 GitHub 检查更新发现新版本）~~（已移除：GUI 不含更新功能）

## 打包验证

- [ ] **Checkpoint 20: 项目根目录存在 `build_exe.bat` 脚本。
- [ ] **Checkpoint 21: 在 Windows 上执行 `build_exe.bat` 退出码为 0；`dist\MediaDownloader_GUI.exe` 文件存在。
- [ ] **Checkpoint 22: 双击 `dist\MediaDownloader_GUI.exe` 启动 GUI 并可进入主界面，完成一次下载流程成功，文件落盘。

## 代码质量 / 可维护性验证

- [ ] **Checkpoint 23: 未对既有 `douyin_image_downloader.py` 与 `tiktok_downloader.py` 进行功能性修改（或仅有必要的最小重构）。
- [ ] **Checkpoint 24: 下载逻辑在后台线程运行，主线程仅做 UI 渲染，无阻塞 I/O。
- [ ] **Checkpoint 25: `verify_gui_smoke.py` 运行成功（`python verify_gui_smoke.py` 退出码 0）。
