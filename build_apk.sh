#!/bin/bash
# 蓝动激光 Flutter APP 一键构建脚本
# 使用方法：./build_apk.sh [release|debug]

set -e

BUILD_TYPE=${1:-release}
PROJECT_DIR="/www/wwwroot/app.landong.cn/flutter_app"
OUTPUT_DIR="/www/wwwroot/app.landong.cn/mobile/app"
APP_NAME="landong-latest.apk"

# 环境变量
export PATH=$PATH:/opt/flutter/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools
export ANDROID_HOME=/opt/android-sdk
export JAVA_HOME=/usr/lib/jvm/java-17-konajdk
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

echo "=========================================="
echo "蓝动激光 APP 构建脚本"
echo "构建类型: $BUILD_TYPE"
echo "=========================================="

cd $PROJECT_DIR

echo ""
echo "[1/4] 获取依赖..."
flutter pub get

echo ""
echo "[2/4] 清理旧构建..."
flutter clean
flutter pub get

echo ""
echo "[3/4] 构建 APK..."
if [ "$BUILD_TYPE" = "release" ]; then
    flutter build apk --release
    APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
else
    flutter build apk --debug
    APK_PATH="build/app/outputs/flutter-apk/app-debug.apk"
fi

echo ""
echo "[4/4] 复制到输出目录..."
mkdir -p $OUTPUT_DIR
cp $APK_PATH $OUTPUT_DIR/$APP_NAME

echo ""
echo "=========================================="
echo "构建完成！"
echo "APK 位置: $OUTPUT_DIR/$APP_NAME"
echo "文件大小: $(du -h $OUTPUT_DIR/$APP_NAME | cut -f1)"
echo "=========================================="
