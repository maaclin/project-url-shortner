# from fastapi import FastAPI, HTTPException, Request
# from fastapi.responses import RedirectResponse
# import os, hashlib, time

# from ddb import put_mapping, get_mapping

# app = FastAPI()

# @app.get("/healthz")
# def health():
#     return {"status": "ok", "ts": int(time.time())}

# @app.post("/shorten")
# async def shorten(req: Request):
#     body = await req.json()
#     url = body.get("url")
#     if not url:
#         raise HTTPException(400, "url required")
#     short = hashlib.sha256(url.encode()).hexdigest()[:8]
#     put_mapping(short, url)
#     return {"short": short, "url": url}

# @app.get("/{short_id}")
# def resolve(short_id: str):
#     item = get_mapping(short_id)
#     if not item:
#         raise HTTPException(404, "not found")
#     return RedirectResponse(item["url"])

from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import RedirectResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
import os, hashlib, time

from ddb import put_mapping, get_mapping

app = FastAPI()

@app.get("/", response_class=HTMLResponse)
def home():
    return """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>URL Shortener</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            
            .container {
                background: white;
                border-radius: 20px;
                padding: 40px;
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
                width: 100%;
                max-width: 500px;
                text-align: center;
            }
            
            h1 {
                color: #333;
                margin-bottom: 10px;
                font-size: 2.5em;
                font-weight: 700;
            }
            
            .subtitle {
                color: #666;
                margin-bottom: 40px;
                font-size: 1.1em;
            }
            
            .input-group {
                margin-bottom: 30px;
                text-align: left;
            }
            
            label {
                display: block;
                margin-bottom: 8px;
                color: #333;
                font-weight: 500;
            }
            
            input[type="url"] {
                width: 100%;
                padding: 15px;
                border: 2px solid #e1e5e9;
                border-radius: 10px;
                font-size: 16px;
                transition: border-color 0.3s ease;
            }
            
            input[type="url"]:focus {
                outline: none;
                border-color: #667eea;
            }
            
            .btn {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 15px 30px;
                border-radius: 10px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: transform 0.2s ease;
                width: 100%;
            }
            
            .btn:hover {
                transform: translateY(-2px);
            }
            
            .btn:disabled {
                opacity: 0.6;
                cursor: not-allowed;
                transform: none;
            }
            
            .result {
                margin-top: 30px;
                padding: 20px;
                border-radius: 10px;
                display: none;
            }
            
            .result.success {
                background: #d4edda;
                border: 1px solid #c3e6cb;
                color: #155724;
            }
            
            .result.error {
                background: #f8d7da;
                border: 1px solid #f5c6cb;
                color: #721c24;
            }
            
            .short-url {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                margin: 15px 0;
                word-break: break-all;
                font-family: monospace;
                border: 1px solid #dee2e6;
            }
            
            .copy-btn {
                background: #28a745;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 5px;
                cursor: pointer;
                margin-top: 10px;
                font-size: 14px;
            }
            
            .copy-btn:hover {
                background: #218838;
            }
            
            .stats {
                margin-top: 20px;
                padding: 15px;
                background: #f8f9fa;
                border-radius: 8px;
                text-align: center;
                color: #666;
                font-size: 14px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🔗 URL Shortener</h1>
            <p class="subtitle">Transform long URLs into short, shareable links</p>
            
            <form id="urlForm">
                <div class="input-group">
                    <label for="url">Enter your URL:</label>
                    <input type="url" id="url" name="url" placeholder="https://example.com" required>
                </div>
                <button type="submit" class="btn" id="submitBtn">Shorten URL</button>
            </form>
            
            <div id="result" class="result">
                <div id="resultContent"></div>
            </div>
            
            <div class="stats">
                <div>✨ Fast • Secure • Simple</div>
            </div>
        </div>

        <script>
            document.getElementById('urlForm').addEventListener('submit', async function(e) {
                e.preventDefault();
                
                const url = document.getElementById('url').value;
                const submitBtn = document.getElementById('submitBtn');
                const result = document.getElementById('result');
                const resultContent = document.getElementById('resultContent');
                
                // Show loading state
                submitBtn.disabled = true;
                submitBtn.textContent = 'Shortening...';
                result.style.display = 'none';
                
                try {
                    const response = await fetch('/shorten', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({ url: url })
                    });
                    
                    const data = await response.json();
                    
                    if (response.ok) {
                        const shortUrl = window.location.origin + '/' + data.short;
                        resultContent.innerHTML = `
                            <h3>✅ Success!</h3>
                            <p>Your shortened URL:</p>
                            <div class="short-url">${shortUrl}</div>
                            <button class="copy-btn" onclick="copyToClipboard('${shortUrl}')">📋 Copy Link</button>
                            <p style="margin-top: 15px;">
                                <a href="${shortUrl}" target="_blank">🔗 Test your link</a>
                            </p>
                        `;
                        result.className = 'result success';
                    } else {
                        throw new Error(data.detail || 'Something went wrong');
                    }
                } catch (error) {
                    resultContent.innerHTML = `
                        <h3>❌ Error</h3>
                        <p>${error.message}</p>
                    `;
                    result.className = 'result error';
                }
                
                // Reset button and show result
                submitBtn.disabled = false;
                submitBtn.textContent = 'Shorten URL';
                result.style.display = 'block';
            });
            
            function copyToClipboard(text) {
                navigator.clipboard.writeText(text).then(function() {
                    // Show feedback
                    const btn = event.target;
                    const originalText = btn.textContent;
                    btn.textContent = '✅ Copied!';
                    setTimeout(() => {
                        btn.textContent = originalText;
                    }, 2000);
                });
            }
        </script>
    </body>
    </html>
    """

@app.get("/healthz")
def health():
    return {"status": "ok", "ts": int(time.time())}

@app.post("/shorten")
async def shorten(req: Request):
    body = await req.json()
    url = body.get("url")
    if not url:
        raise HTTPException(400, "url required")
    short = hashlib.sha256(url.encode()).hexdigest()[:8]
    put_mapping(short, url)
    return {"short": short, "url": url}

@app.get("/{short_id}")
def resolve(short_id: str):
    try:
        item = get_mapping(short_id)
        if not item:
            raise HTTPException(404, "Short URL not found")
        return RedirectResponse(item["url"])
    except HTTPException:
        raise  # Re-raise HTTP exceptions  
    except Exception as e:
        raise HTTPException(503, "Database temporarily unavailable")