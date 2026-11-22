# Lightweight Local Web Server for The Artisan Thread Web Application
# No Node.js or Python required - uses built-in Windows .NET HttpListener

param(
    [int]$Port = 8080,
    [switch]$NoBrowser
)

$HostAddress = "http://localhost:$Port/"
$RootPath = $PSScriptRoot

$MimeTypes = @{
    ".html" = "text/html; charset=utf-8"
    ".htm"  = "text/html; charset=utf-8"
    ".css"  = "text/css; charset=utf-8"
    ".js"   = "application/javascript; charset=utf-8"
    ".json" = "application/json; charset=utf-8"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
}

$Listener = New-Object System.Net.HttpListener
$Listener.Prefixes.Add($HostAddress)

try {
    $Listener.Start()
} catch {
    Write-Host "Failed to start listener on port $Port : $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "==========================================================" -ForegroundColor Green
Write-Host "  The Artisan Thread - Web Application Server" -ForegroundColor Cyan
Write-Host "  Running at: $HostAddress" -ForegroundColor Yellow
Write-Host "  Root folder: $RootPath" -ForegroundColor Gray
Write-Host "  Press Ctrl+C to stop the server." -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Green

if (-not $NoBrowser) {
    Start-Process $HostAddress
}

while ($Listener.IsListening) {
    try {
        $Context = $Listener.GetContext()
        $Request = $Context.Request
        $Response = $Context.Response

        $RawUrl = $Request.Url.LocalPath
        if ($RawUrl -eq "/" -or [string]::IsNullOrWhiteSpace($RawUrl)) {
            $RawUrl = "/index.html"
        }

        # Normalize relative path
        $RelativePath = $RawUrl.TrimStart("/").Replace("/", "\")
        $FilePath = Join-Path $RootPath $RelativePath

        if (Test-Path $FilePath -PathType Leaf) {
            $Ext = [System.IO.Path]::GetExtension($FilePath).ToLower()
            $ContentType = $MimeTypes[$Ext]
            if (-not $ContentType) { $ContentType = "application/octet-stream" }

            $Bytes = [System.IO.File]::ReadAllBytes($FilePath)
            $Response.ContentType = $ContentType
            $Response.ContentLength64 = $Bytes.Length
            $Response.AddHeader("Access-Control-Allow-Origin", "*")
            $Response.OutputStream.Write($Bytes, 0, $Bytes.Length)
            $Response.StatusCode = 200
        } else {
            $Response.StatusCode = 404
            $NotFoundBytes = [System.Text.Encoding]::UTF8.GetBytes("404 - File Not Found: $RawUrl")
            $Response.ContentLength64 = $NotFoundBytes.Length
            $Response.ContentType = "text/plain"
            $Response.OutputStream.Write($NotFoundBytes, 0, $NotFoundBytes.Length)
        }
        $Response.Close()
    } catch {
        break
    }
}
