import os
import sys

# 设置 Playwright 浏览器全局缓存路径，适配 Docker
os.environ['PLAYWRIGHT_BROWSERS_PATH'] = '/ms-playwright'

try:
    import gradio as gr
except ImportError:
    print("请先安装 Gradio: pip install gradio")
    sys.exit(1)

from douyin_image_downloader import download_douyin_links
from tiktok_downloader import download_tiktok_links

OUTPUT_DIR = os.environ.get("DOWNLOAD_DIR", "/downloads")

def start_download(platform, text):
    if not text.strip():
        return "❌ 请输入链接"
        
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    links = [line.strip() for line in text.split('\n') if line.strip()]
    
    try:
        if platform == "Douyin (抖音)":
            download_douyin_links(links, OUTPUT_DIR)
        else:
            download_tiktok_links(links, OUTPUT_DIR)
        return f"✅ 下载完成！\n文件已保存至 NAS 挂载目录: {OUTPUT_DIR}"
    except Exception as e:
        return f"❌ 下载失败: {e}"

with gr.Blocks(title="MediaDownloader WebUI", theme=gr.themes.Soft()) as demo:
    gr.Markdown(
        """
        # 🚀 MediaDownloader WebUI (NAS 专版)
        **无需客户端，直接在浏览器中粘贴链接即可下载抖音/TikTok无水印视频与图文。**
        下载的文件将自动保存到您在 NAS (如 fnos) 中映射的 `/downloads` 文件夹内，并且会自动按作者名称建好文件夹！
        """
    )
    
    with gr.Row():
        platform_radio = gr.Radio(["Douyin (抖音)", "TikTok"], label="选择平台", value="Douyin (抖音)")
        
    links_input = gr.Textbox(label="粘贴分享文本或链接 (支持多行批量)", lines=5, placeholder="https://v.douyin.com/xxxxxx/")
    
    download_btn = gr.Button("🚀 立即提取下载", variant="primary")
    status_output = gr.Textbox(label="运行状态", interactive=False)
    
    download_btn.click(
        fn=start_download,
        inputs=[platform_radio, links_input],
        outputs=status_output
    )

if __name__ == "__main__":
    print(f"[*] 启动 WebUI 服务器，默认下载目录: {OUTPUT_DIR}")
    # 监听 0.0.0.0 以允许外部/局域网访问，端口 7860
    demo.launch(server_name="0.0.0.0", server_port=7860, share=False)
