FROM mcr.microsoft.com/playwright/python:v1.40.0-jammy

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV PYTHONUNBUFFERED=1
ENV DOWNLOAD_DIR=/downloads
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# 复制依赖配置
COPY requirements.txt .
# 补充 WebUI 必须的依赖
RUN pip install --no-cache-dir -r requirements.txt gradio playwright-stealth

# 复制全部代码
COPY . .

# 暴露 Gradio 默认端口
EXPOSE 7860

# 启动 WebUI
CMD ["python", "webui.py"]
