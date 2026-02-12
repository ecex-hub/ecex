# 从服务器获取 composer.lock 文件
# 用法: .\get-composer-lock.ps1

$SERVER_IP = "8.212.40.70"
$CONTAINER_NAME = "ecex-backend"
$LOCAL_PATH = "e:\ecex\server\composer.lock"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "从服务器获取 composer.lock 文件" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 步骤1: 从容器复制到服务器临时目录
Write-Host "[1/3] 从容器复制 composer.lock 到服务器..." -ForegroundColor Yellow
ssh root@$SERVER_IP "docker cp ${CONTAINER_NAME}:/var/www/html/composer.lock /tmp/composer.lock"

if ($LASTEXITCODE -ne 0) {
    Write-Host "错误: 无法从容器复制文件" -ForegroundColor Red
    Write-Host "请确保:" -ForegroundColor Yellow
    Write-Host "  1. 容器 $CONTAINER_NAME 正在运行" -ForegroundColor Yellow
    Write-Host "  2. 容器内存在 composer.lock 文件" -ForegroundColor Yellow
    Write-Host "" 
    Write-Host "检查容器状态:" -ForegroundColor Yellow
    ssh root@$SERVER_IP "docker ps | grep $CONTAINER_NAME"
    exit 1
}

# 步骤2: 从服务器下载到本地
Write-Host "[2/3] 从服务器下载到本地..." -ForegroundColor Yellow
scp root@${SERVER_IP}:/tmp/composer.lock $LOCAL_PATH

if ($LASTEXITCODE -ne 0) {
    Write-Host "错误: 无法下载文件" -ForegroundColor Red
    exit 1
}

# 步骤3: 验证文件
Write-Host "[3/3] 验证文件..." -ForegroundColor Yellow
if (Test-Path $LOCAL_PATH) {
    $fileSize = (Get-Item $LOCAL_PATH).Length
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "成功!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "文件路径: $LOCAL_PATH" -ForegroundColor Green
    Write-Host "文件大小: $fileSize 字节" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Check file: cat server/composer.lock" -ForegroundColor White
    Write-Host "  2. Add to Git: git add server/composer.lock" -ForegroundColor White
    Write-Host "  3. Commit and push: git commit -m 'Add composer.lock' && git push" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "错误: 文件未找到" -ForegroundColor Red
    exit 1
}

