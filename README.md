# 蓝动激光 APP 构建指南

## 项目介绍

蓝动激光官方 APP，使用 Flutter 开发，支持安卓平台。

## 技术栈

- Flutter 3.x + Dart 3.x
- Provider（状态管理）
- Dio（网络请求）
- go_router（路由管理）
- cached_network_image（图片缓存）
- webview_flutter（资讯详情）

## 项目结构

```
lib/
├── main.dart                    # 入口
├── config/                      # 配置
│   ├── api_config.dart          # API 地址
│   └── app_config.dart          # 应用配置
├── models/                      # 数据模型
│   ├── device.dart
│   ├── product_system.dart
│   └── article.dart
├── services/                    # API 服务
│   ├── api_service.dart
│   ├── product_service.dart
│   └── news_service.dart
├── providers/                   # 状态管理
│   ├── product_provider.dart
│   └── news_provider.dart
├── router/                      # 路由
│   └── app_router.dart
├── pages/                       # 页面
│   ├── home/                    # 首页
│   ├── products/                # 产品
│   ├── news/                    # 资讯
│   └── profile/                 # 个人中心
├── widgets/                     # 组件
│   └── main_scaffold.dart       # 底部导航框架
└── utils/                       # 工具
```

## 开发环境搭建

### 方式一：在云服务器上构建

1. 安装 Flutter SDK
```bash
# 下载 Flutter
cd /opt
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.0-stable.tar.xz
tar xf flutter_linux_3.22.0-stable.tar.xz

# 配置环境变量
echo 'export PATH="$PATH:/opt/flutter/bin"' >> ~/.bashrc
echo 'export ANDROID_HOME=/opt/android-sdk' >> ~/.bashrc
echo 'export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"' >> ~/.bashrc
source ~/.bashrc

# 验证
flutter --version
```

2. 安装 Android SDK
```bash
# 下载 command line tools
cd /tmp
wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
mkdir -p /opt/android-sdk/cmdline-tools
unzip commandlinetools-linux-11076708_latest.zip -d /opt/android-sdk/cmdline-tools/
mv /opt/android-sdk/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest

# 接受协议并安装 SDK
yes | sdkmanager --licenses
sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

3. 配置项目
```bash
cd flutter_app
flutter pub get
```

### 方式二：在本地电脑上构建

1. 安装 Flutter SDK：https://docs.flutter.dev/get-started/install
2. 安装 Android Studio
3. 配置 Flutter 环境
4. 用 Android Studio 打开 android 目录
5. 执行构建

## 构建 APK

### 方式一：一键脚本

```bash
chmod +x build_apk.sh
./build_apk.sh
```

构建成功后，APK 在：
```
build/app/outputs/flutter-apk/app-release.apk
```

### 方式二：手动构建

```bash
# 安装依赖
flutter pub get

# 构建 debug 版（测试用）
flutter build apk --debug

# 构建 release 版（发布用）
flutter build apk --release

# 构建同时支持所有架构
flutter build apk --release --split-per-abi
```

### 上传到服务器

```bash
./build_apk.sh --upload
```

或手动上传：
```bash
scp build/app/outputs/flutter-apk/app-release.apk root@111.231.14.40:/www/wwwroot/app.landong.cn/mobile/app/landong-latest.apk
```

## 发布新版本

1. 修改版本号
```bash
# 编辑 pubspec.yaml
version: 1.0.1+2
# 格式：版本名+版本号，版本号每次递增
```

2. 修改更新接口中的版本信息（Drupal 或单独配置）

3. 重新构建
```bash
./build_apk.sh --upload
```

## 应用签名（发布版必须）

### 生成签名密钥

```bash
keytool -genkey -v -keystore ~/landong-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias landong
```

按提示输入密码和信息。

### 配置签名

1. 创建 `android/key.properties`：
```properties
storePassword=你的密钥库密码
keyPassword=你的密钥密码
keyAlias=landong
storeFile=/path/to/landong-keystore.jks
```

2. 在 `android/app/build.gradle` 中配置签名（已配置好，只需确保文件存在）

### 注意

- **密钥文件务必备份好**，丢失了就无法更新 APP 了
- 不要把 key.properties 和 jks 文件提交到代码仓库
- 不同签名的 APK 不能直接覆盖安装，需要卸载重装

## 上架应用商店

### 华为应用市场
1. 注册开发者账号
2. 准备材料：软著、ICP 备案、隐私政策
3. 上传 APK、填写应用信息
4. 提交审核

### 小米应用商店
流程类似，需要企业开发者账号。

### 腾讯应用宝
流程类似。

### 360 手机助手
流程类似。

## 常见问题

### 1. Flutter 命令找不到
检查环境变量是否配置正确：
```bash
echo $PATH | grep flutter
```

### 2. Android SDK 找不到
```bash
flutter doctor --android-licenses
flutter config --android-sdk /opt/android-sdk
```

### 3. 构建失败，报各种错误
```bash
flutter clean
flutter pub get
flutter build apk --release
```

### 4. 安装 APK 失败
- 检查手机是否允许安装未知来源应用
- 检查版本号是否比已安装的高
- 检查签名是否一致

## 联系支持

如有问题，请联系技术支持。
