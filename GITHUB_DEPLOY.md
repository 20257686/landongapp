# GitHub Actions 部署指南

## 快速开始

### 1. 在服务器上操作（通过腾讯云VNC登录）

```bash
# 杀掉可能卡死的构建进程
pkill -9 -f flutter 2>/dev/null
pkill -9 -f gradle 2>/dev/null
pkill -9 -f java 2>/dev/null

# 设置环境变量
export PATH="/opt/flutter/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:$PATH"
export ANDROID_HOME="/opt/android-sdk"
export JAVA_HOME="/usr/lib/jvm/java-17-konajdk-17.0.19-1.oc9"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
export PUB_HOSTED_URL="https://pub.flutter-io.cn"

# 写入bashrc持久化
cat >> /root/.bashrc << 'EOF'
export PATH="/opt/flutter/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:$PATH"
export ANDROID_HOME="/opt/android-sdk"
export JAVA_HOME="/usr/lib/jvm/java-17-konajdk-17.0.19-1.oc9"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
export PUB_HOSTED_URL="https://pub.flutter-io.cn"
EOF
```

### 2. 重新生成完整项目

```bash
cd /www/wwwroot/app.landong.cn

# 备份现有业务代码
cp -r flutter_app/lib /tmp/flutter_lib_backup
cp flutter_app/pubspec.yaml /tmp/pubspec_backup.yaml

# 删除旧项目，重新创建
rm -rf flutter_app
flutter create --org cn.landong --project-name landong_app flutter_app
cd flutter_app

# 恢复业务代码
rm -rf lib
cp -r /tmp/flutter_lib_backup lib
cp /tmp/pubspec_backup.yaml pubspec.yaml

# 安装依赖
flutter pub get
```

### 3. 推送到 GitHub

```bash
cd /www/wwwroot/app.landong.cn/flutter_app

git init
git config user.name "20257686"
git config user.email "20257686@users.noreply.github.com"
git add .
git commit -m "feat: 蓝动激光APP初始版本"
git remote add origin https://20257686:Spiderxp202576@github.com/20257686/landongapp.git
git branch -M main
git push -u origin main
```

### 4. 下载 APK

推送完成后，GitHub Actions 会自动构建：

1. 打开 https://github.com/20257686/landongapp/actions
2. 等待构建完成（约5-10分钟）
3. 点击最新的工作流运行记录
4. 在页面底部「Artifacts」区域下载 `landong-app-release.zip`
5. 解压后就是 `app-release.apk`

## 后续更新

每次修改代码后：
```bash
cd /www/wwwroot/app.landong.cn/flutter_app
git add .
git commit -m "更新说明"
git push
```

GitHub Actions 会自动重新构建 APK。

## 注意事项

- GitHub 公开仓库每月免费 2000 分钟构建时间
- APK 构建完成后保留 30 天
- 构建环境：Ubuntu + Flutter 3.24.0 + Java 17
