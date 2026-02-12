# GitHub仓库设置脚本
# 使用方法: .\setup-github.ps1

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "GitHub 仓库初始化脚本" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否在项目根目录
if (-not (Test-Path "vue") -or -not (Test-Path "server")) {
    Write-Host "错误: 请在项目根目录运行此脚本" -ForegroundColor Red
    exit 1
}

# 1. 配置Git用户信息
Write-Host "步骤 1/7: 配置Git用户信息" -ForegroundColor Yellow
Write-Host ""
$userName = Read-Host "请输入你的GitHub用户名"
$userEmail = Read-Host "请输入你的GitHub邮箱"

git config --global user.name "$userName"
git config --global user.email "$userEmail"

Write-Host "✅ Git用户信息配置完成" -ForegroundColor Green
Write-Host ""

# 2. 初始化Git仓库
Write-Host "步骤 2/7: 初始化Git仓库" -ForegroundColor Yellow
if (Test-Path ".git") {
    Write-Host "⚠️  Git仓库已存在，跳过初始化" -ForegroundColor Yellow
} else {
    git init
    Write-Host "✅ Git仓库初始化完成" -ForegroundColor Green
}
Write-Host ""

# 3. 添加文件到暂存区
Write-Host "步骤 3/7: 添加文件到暂存区" -ForegroundColor Yellow
git add .
Write-Host "✅ 文件已添加到暂存区" -ForegroundColor Green
Write-Host ""

# 4. 提交到本地仓库
Write-Host "步骤 4/7: 提交到本地仓库" -ForegroundColor Yellow
$commitMessage = Read-Host "请输入提交信息 (直接回车使用默认信息)"
if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = "Initial commit: 添加Docker容器化配置，使用Caddy Web Server"
}
git commit -m "$commitMessage"
Write-Host "✅ 已提交到本地仓库" -ForegroundColor Green
Write-Host ""

# 5. 添加远程仓库
Write-Host "步骤 5/7: 添加远程仓库" -ForegroundColor Yellow
Write-Host ""
Write-Host "请先在GitHub上创建仓库，然后输入仓库信息：" -ForegroundColor Cyan
Write-Host "示例: https://github.com/zhangsan/ecex.git" -ForegroundColor Gray
Write-Host ""
$repoUrl = Read-Host "请输入GitHub仓库URL"

# 检查是否已有远程仓库
$remoteExists = git remote | Select-String -Pattern "origin"
if ($remoteExists) {
    Write-Host "⚠️  远程仓库origin已存在，正在更新..." -ForegroundColor Yellow
    git remote set-url origin $repoUrl
} else {
    git remote add origin $repoUrl
}
Write-Host "✅ 远程仓库配置完成" -ForegroundColor Green
Write-Host ""

# 6. 推送到GitHub
Write-Host "步骤 6/7: 推送到GitHub" -ForegroundColor Yellow
Write-Host ""
Write-Host "⚠️  注意：推送时需要输入GitHub凭据" -ForegroundColor Yellow
Write-Host "   用户名: 你的GitHub用户名" -ForegroundColor Gray
Write-Host "   密码: Personal Access Token (不是GitHub密码!)" -ForegroundColor Gray
Write-Host ""
Write-Host "如果还没有创建Token，请按以下步骤操作：" -ForegroundColor Cyan
Write-Host "1. 访问 https://github.com/settings/tokens" -ForegroundColor Gray
Write-Host "2. 点击 'Generate new token (classic)'" -ForegroundColor Gray
Write-Host "3. 勾选 'repo' 和 'write:packages' 权限" -ForegroundColor Gray
Write-Host "4. 生成并复制Token" -ForegroundColor Gray
Write-Host ""
$continue = Read-Host "准备好了吗？按回车继续推送，或输入 'n' 取消"

if ($continue -ne "n") {
    git branch -M main
    git push -u origin main
    Write-Host "✅ 代码已推送到GitHub" -ForegroundColor Green
} else {
    Write-Host "⚠️  已取消推送" -ForegroundColor Yellow
}
Write-Host ""

# 7. 显示后续步骤
Write-Host "步骤 7/7: 配置GitHub Actions" -ForegroundColor Yellow
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "✅ 本地配置完成！" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "接下来需要在GitHub上配置Secrets：" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. 访问你的仓库: $repoUrl" -ForegroundColor Cyan
Write-Host "2. 点击 Settings → Secrets and variables → Actions" -ForegroundColor Cyan
Write-Host "3. 点击 'New repository secret'" -ForegroundColor Cyan
Write-Host "4. 添加密钥：" -ForegroundColor Cyan
Write-Host "   Name: GHCR_TOKEN" -ForegroundColor Gray
Write-Host "   Secret: 粘贴你的Personal Access Token" -ForegroundColor Gray
Write-Host ""
Write-Host "5. 查看GitHub Actions运行状态：" -ForegroundColor Cyan
Write-Host "   访问: $repoUrl/actions" -ForegroundColor Gray
Write-Host ""
Write-Host "6. 构建成功后，查看Docker镜像：" -ForegroundColor Cyan
Write-Host "   访问: https://github.com/$userName?tab=packages" -ForegroundColor Gray
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "🎉 全部完成！" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan

