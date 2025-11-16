# � Gawean - Hướng Dẫn Cài Đặt Chi Tiết

Tài liệu này hướng dẫn cách cài đặt và chạy ứng dụng Job Finder từ đầu đến cuối.

---

## 📋 Mục Lục

- [Yêu Cầu Hệ Thống](#-yêu-cầu-hệ-thống)
- [Cài Đặt Môi Trường](#-cài-đặt-môi-trường)
- [Cài Đặt Backend](#-cài-đặt-backend)
- [Cài Đặt Flutter](#-cài-đặt-flutter)
- [Chạy Ứng Dụng](#-chạy-ứng-dụng)
- [Xử Lý Lỗi Thường Gặp](#-xử-lý-lỗi-thường-gặp)

---

## 🖥️ Yêu Cầu Hệ Thống

### Windows
- **OS**: Windows 10 hoặc mới hơn (64-bit)
- **RAM**: Tối thiểu 8GB (khuyến nghị 16GB)
- **Dung lượng**: Ít nhất 10GB trống

### macOS
- **OS**: macOS 10.15 (Catalina) hoặc mới hơn
- **RAM**: Tối thiểu 8GB (khuyến nghị 16GB)
- **Dung lượng**: Ít nhất 10GB trống

### Linux
- **OS**: Ubuntu 20.04 LTS hoặc tương đương
- **RAM**: Tối thiểu 8GB (khuyến nghị 16GB)
- **Dung lượng**: Ít nhất 10GB trống

---

## 🔧 Cài Đặt Môi Trường

### 1. Cài Đặt Flutter SDK

#### Windows

```powershell
# Tải Flutter SDK từ https://docs.flutter.dev/get-started/install/windows
# Giải nén vào thư mục (ví dụ: C:\src\flutter)

# Thêm Flutter vào PATH
$env:Path += ";C:\src\flutter\bin"

# Kiểm tra cài đặt
flutter doctor
```

#### macOS

```bash
# Tải Flutter SDK
cd ~/development
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_3.9.2-stable.zip
unzip flutter_macos_3.9.2-stable.zip

# Thêm Flutter vào PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Thêm vào ~/.zshrc hoặc ~/.bashrc để tự động
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc

# Kiểm tra cài đặt
flutter doctor
```

#### Linux

```bash
# Tải Flutter SDK
cd ~/development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.9.2-stable.tar.xz
tar xf flutter_linux_3.9.2-stable.tar.xz

# Thêm Flutter vào PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Thêm vào ~/.bashrc
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc

# Kiểm tra cài đặt
flutter doctor
```

### 2. Cài Đặt Android Studio

1. Tải Android Studio từ: https://developer.android.com/studio
2. Cài đặt và mở Android Studio
3. Vào **SDK Manager** > **SDK Platforms** > Chọn Android 13.0 (API 33)
4. Vào **SDK Tools** > Cài đặt:
   - Android SDK Build-Tools
   - Android SDK Command-line Tools
   - Android Emulator
   - Android SDK Platform-Tools

5. Tạo Android Virtual Device (AVD):
   - Mở **AVD Manager**
   - Nhấn **Create Virtual Device**
   - Chọn Pixel 7 Pro
   - Chọn System Image: Android 13.0 (API 33)
   - Nhấn **Finish**

### 3. Cài Đặt Xcode (Chỉ macOS)

```bash
# Tải từ App Store hoặc:
xcode-select --install

# Chấp nhận license
sudo xcodebuild -license accept

# Cài đặt CocoaPods
sudo gem install cocoapods
```

### 4. Cài Đặt Node.js

#### Windows (PowerShell)

```powershell
# Tải Node.js 20.x từ: https://nodejs.org/
# Hoặc dùng Chocolatey:
choco install nodejs-lts --version=20.11.0
```

#### macOS

```bash
# Dùng Homebrew
brew install node@20

# Hoặc dùng nvm (khuyến nghị)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20
nvm use 20
```

#### Linux

```bash
# Dùng nvm (khuyến nghị)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20
nvm use 20

# Hoặc dùng apt (Ubuntu/Debian)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### 5. Cài Đặt Docker Desktop

#### Windows

1. Tải Docker Desktop: https://www.docker.com/products/docker-desktop/
2. Cài đặt và khởi động lại máy
3. Mở Docker Desktop
4. Vào **Settings** > **Resources** > Đặt Memory: 4GB, CPUs: 2

#### macOS

```bash
# Tải Docker Desktop từ: https://www.docker.com/products/docker-desktop/
# Hoặc dùng Homebrew
brew install --cask docker
```

#### Linux

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Thêm user vào docker group
sudo usermod -aG docker $USER
newgrp docker
```

### 6. Cài Đặt Git

#### Windows

```powershell
# Tải từ: https://git-scm.com/download/win
# Hoặc dùng Chocolatey
choco install git
```

#### macOS/Linux

```bash
# macOS (Homebrew)
brew install git

# Linux (Ubuntu/Debian)
sudo apt-get install git
```

---

## 🚀 Cài Đặt Backend

### Bước 1: Clone Repository

```bash
git clone <repository-url>
cd job_finder_app/backend
```

### Bước 2: Tạo File .env

#### Windows (PowerShell)

```powershell
Copy-Item .env.example .env
notepad .env
```

#### macOS/Linux

```bash
cp .env.example .env
nano .env
```

### Bước 3: Cấu Hình .env

Mở file `.env` và chỉnh sửa:

```env
# Server Configuration
NODE_ENV=development
PORT=5000

# Database Configuration
DB_HOST=postgres
DB_PORT=5432
DB_NAME=job_finder_db
DB_USER=postgres
DB_PASSWORD=your_strong_password_here

# JWT Configuration
JWT_SECRET=your_jwt_secret_key_min_32_characters
JWT_EXPIRES_IN=7d
JWT_REFRESH_SECRET=your_refresh_secret_key_min_32_characters
JWT_REFRESH_EXPIRES_IN=30d

# Email Configuration (Optional)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_app_password

# OAuth (Optional)
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_APP_SECRET=your_facebook_app_secret
```

**Lưu ý:** Thay đổi `DB_PASSWORD`, `JWT_SECRET`, và `JWT_REFRESH_SECRET` bằng các giá trị bảo mật của bạn.

### Bước 4: Khởi Động Docker Containers

```bash
# Khởi động tất cả services
docker-compose up -d

# Kiểm tra trạng thái
docker-compose ps

# Xem logs
docker-compose logs -f api
```

Các services sẽ chạy tại:
- **API Server**: http://localhost:5000
- **PostgreSQL**: localhost:5432
- **pgAdmin**: http://localhost:5050 (email: admin@admin.com, password: admin)

### Bước 5: Kiểm Tra Backend

```bash
# Test API health
curl http://localhost:5000/api/health

# Hoặc mở trình duyệt
# http://localhost:5000/api/health
```

---

## 📱 Cài Đặt Flutter

### Bước 1: Vào Thư Mục Root

```bash
cd ../  # Quay về root của project
```

### Bước 2: Cài Đặt Dependencies

```bash
# Tải packages
flutter pub get

# Kiểm tra issues
flutter doctor
```

### Bước 3: Cấu Hình API URL

Mở file `lib/config/constants/api_constants.dart`:

```dart
class ApiConstants {
  // Development
  static const String baseUrl = 'http://localhost:5000/api';
  
  // Cho Android Emulator, dùng:
  // static const String baseUrl = 'http://10.0.2.2:5000/api';
  
  // Cho iOS Simulator, dùng:
  // static const String baseUrl = 'http://localhost:5000/api';
  
  // Cho thiết bị thật, dùng IP máy tính:
  // static const String baseUrl = 'http://192.168.x.x:5000/api';
}
```

**Tìm IP máy tính:**

```bash
# Windows
ipconfig
# Tìm "IPv4 Address" của WiFi/Ethernet adapter

# macOS/Linux
ifconfig
# Hoặc
ip addr show
```

---

## ▶️ Chạy Ứng Dụng

### Chạy Trên Android Emulator

```bash
# Liệt kê devices
flutter devices

# Khởi động emulator (nếu chưa chạy)
flutter emulators --launch <emulator_id>

# Chạy app
flutter run
```

### Chạy Trên iOS Simulator (macOS Only)

```bash
# Mở simulator
open -a Simulator

# Chạy app
flutter run
```

### Chạy Trên Thiết Bị Thật

#### Android

1. Bật **Developer Options** trên điện thoại:
   - Vào **Settings** > **About Phone**
   - Nhấn **Build Number** 7 lần

2. Bật **USB Debugging**:
   - **Settings** > **Developer Options** > **USB Debugging**

3. Kết nối USB và chạy:
```bash
flutter devices
flutter run
```

#### iOS (macOS Only)

1. Kết nối iPhone qua USB
2. Mở Xcode > Chọn device
3. Trust device trên iPhone
4. Chạy:
```bash
flutter run
```

---

## 🐛 Xử Lý Lỗi Thường Gặp

### Flutter Doctor Issues

#### ❌ Android toolchain issues

```bash
# Chạy
flutter doctor --android-licenses

# Nhấn 'y' để chấp nhận tất cả licenses
```

#### ❌ VS Code not found

Cài đặt VS Code từ: https://code.visualstudio.com/

```bash
# Cài extension Flutter
code --install-extension Dart-Code.flutter
```

### Docker Issues

#### ❌ Port already in use

```bash
# Kiểm tra port đang sử dụng
# Windows
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# macOS/Linux
lsof -i :5000
kill -9 <PID>
```

#### ❌ Container fails to start

```bash
# Xem logs chi tiết
docker-compose logs api

# Restart containers
docker-compose restart

# Rebuild nếu cần
docker-compose down
docker-compose up --build -d
```

### Database Connection Issues

#### ❌ Cannot connect to PostgreSQL

```bash
# Kiểm tra container đang chạy
docker-compose ps

# Kiểm tra logs
docker-compose logs postgres

# Restart database
docker-compose restart postgres
```

### Flutter Build Issues

#### ❌ Gradle build failed (Android)

```bash
# Clean build
flutter clean
flutter pub get

# Rebuild
cd android
./gradlew clean
cd ..
flutter run
```

#### ❌ Pod install failed (iOS)

```bash
# Clean pods
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..
flutter run
```

### API Connection Issues

#### ❌ Cannot connect to API from app

1. **Kiểm tra backend đang chạy:**
```bash
curl http://localhost:5000/api/health
```

2. **Đúng IP cho từng platform:**
   - Android Emulator: `http://10.0.2.2:5000/api`
   - iOS Simulator: `http://localhost:5000/api`
   - Real Device: `http://YOUR_COMPUTER_IP:5000/api`

3. **Tắt firewall tạm thời (Windows):**
```powershell
# Chạy PowerShell as Administrator
New-NetFirewallRule -DisplayName "Node.js" -Direction Inbound -Protocol TCP -LocalPort 5000 -Action Allow
```

---

## 📞 Hỗ Trợ

Nếu gặp vấn đề:

1. Kiểm tra [Issues](../../issues) trên GitHub
2. Đọc [FAQ](../FAQ.md)
3. Tạo Issue mới với:
   - Mô tả vấn đề chi tiết
   - Output của `flutter doctor`
   - Logs từ terminal
   - Screenshot (nếu có)

---

## 🎉 Hoàn Thành!

Bạn đã cài đặt thành công ứng dụng Job Finder!

**Các tài khoản test:**
- Email: `test@example.com`
- Password: `password123`

**pgAdmin:**
- URL: http://localhost:5050
- Email: `admin@admin.com`
- Password: `admin`

**Bước tiếp theo:**
- Đọc [README.md](../README.md) để hiểu cấu trúc project
- Xem [API Documentation](../README.md#-api-documentation)
- Bắt đầu phát triển tính năng mới!

---

## 🛠️ BƯỚC 1: CÀI ĐẶT DEPENDENCIES

### Flutter
```powershell
# Di chuyển vào thư mục project
cd d:\Workspace\Flutter\job_finder_app

# Cài đặt packages
flutter pub get

# Nếu gặp lỗi, chạy:
flutter clean
flutter pub get
```

### Backend
```powershell
# Di chuyển vào thư mục backend
cd backend

# Cài đặt Node.js packages
npm install

# Tạo file .env từ template
Copy-Item .env.example .env

# Chỉnh sửa .env với thông tin của bạn
notepad .env
```

---

## 🐳 BƯỚC 2: CHẠY DOCKER

### Yêu cầu
- Docker Desktop đã cài đặt và đang chạy

### Khởi động services
```powershell
cd backend

# Khởi động tất cả services (PostgreSQL, API, pgAdmin)
docker-compose up -d

# Xem logs
docker-compose logs -f

# Dừng services
docker-compose down

# Dừng và xóa volumes (reset database)
docker-compose down -v
```

### Truy cập services
- **API**: http://localhost:5000
- **Health Check**: http://localhost:5000/health
- **pgAdmin**: http://localhost:5050
  - Email: admin@jobfinder.com
  - Password: admin123
- **PostgreSQL**: localhost:5432
  - User: jobfinder
  - Password: jobfinder123
  - Database: job_finder_db

---

## 💻 BƯỚC 3: CHẠY ỨNG DỤNG

### Backend (nếu không dùng Docker)
```powershell
cd backend
npm run dev
```

### Flutter
```powershell
cd d:\Workspace\Flutter\job_finder_app

# Chạy trên Chrome
flutter run -d chrome

# Chạy trên Android
flutter run -d android

# Chạy trên Windows
flutter run -d windows
```

---

## 📝 BƯỚC 4: CẤU HÌNH DATABASE

### Kết nối pgAdmin với PostgreSQL

1. Mở http://localhost:5050
2. Login với thông tin ở trên
3. Add New Server:
   - Name: Job Finder
   - Host: postgres (tên container)
   - Port: 5432
   - Username: jobfinder
   - Password: jobfinder123

### Chạy Migrations (sau khi tạo migration files)
```powershell
cd backend
npm run migrate
```

---

## 🎯 BƯỚC 5: CÁC FILE CẦN TẠO TIẾP

### Backend - Ưu tiên cao

1. **Routes** (src/routes/)
```javascript
// authRoutes.js
// userRoutes.js
// jobRoutes.js
// companyRoutes.js
// applicationRoutes.js
```

2. **Controllers** (src/controllers/)
```javascript
// authController.js - Login, Register, OAuth
// userController.js - CRUD users
// jobController.js - CRUD jobs
// companyController.js - CRUD companies
// applicationController.js - Job applications
```

3. **Middlewares** (src/middlewares/)
```javascript
// auth.js - JWT verification
// validation.js - Input validation
// errorHandler.js - Error handling
// upload.js - File upload (multer)
```

4. **Models** (src/models/)
```javascript
// Company.js
// Application.js
// Category.js
// Notification.js
```

### Flutter - Ưu tiên cao

1. **Models** (lib/core/models/)
```dart
// user_model.dart
// job_model.dart
// company_model.dart
// application_model.dart
```

2. **Screens** (lib/features/auth/screens/)
```dart
// splash_screen.dart
// login_screen.dart
// register_screen.dart
// forgot_password_screen.dart
```

3. **Repositories** (lib/core/repositories/)
```dart
// job_repository.dart
// company_repository.dart
// application_repository.dart
```

4. **BLoCs** (lib/features/*/bloc/)
```dart
// home_bloc.dart + events + states
// job_bloc.dart + events + states
// profile_bloc.dart + events + states
```

---

## 🧪 BƯỚC 6: TESTING

### Test Backend API
```powershell
# Health check
curl http://localhost:5000/health

# Test với Postman hoặc Thunder Client (VS Code extension)
```

### Test Flutter
```powershell
flutter test
```

---

## 📚 HƯỚNG DẪN SỬ DỤNG BLOC

### 1. Tạo Event
```dart
// Dispatch event from UI
context.read<AuthBloc>().add(
  const AuthLoginRequested(
    email: 'user@example.com',
    password: 'password123',
  ),
);
```

### 2. Lắng nghe State
```dart
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) {
      return CircularProgressIndicator();
    }
    if (state is AuthAuthenticated) {
      return Text('Welcome ${state.user['full_name']}');
    }
    if (state is AuthError) {
      return Text('Error: ${state.message}');
    }
    return LoginForm();
  },
)
```

### 3. BlocProvider setup trong main.dart
```dart
void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(),
          ),
        ),
        // Add more BLoCs here
      ],
      child: MyApp(),
    ),
  );
}
```

---

## 🔐 SECURITY CHECKLIST

### Backend
- ✅ JWT token authentication
- ✅ Password hashing (bcryptjs)
- ✅ Rate limiting
- ✅ Helmet security headers
- ✅ CORS configuration
- ⏳ Input validation (express-validator)
- ⏳ SQL injection protection (Sequelize ORM)

### Flutter
- ✅ Token storage (SharedPreferences)
- ✅ Automatic token refresh
- ⏳ Secure storage for sensitive data
- ⏳ SSL certificate pinning (production)

---

## 🐛 TROUBLESHOOTING

### Docker không khởi động
```powershell
# Kiểm tra Docker Desktop đang chạy
docker --version

# Xem logs chi tiết
docker-compose logs postgres
docker-compose logs api
```

### Flutter pub get fails
```powershell
flutter clean
flutter pub cache repair
flutter pub get
```

### Cannot connect to PostgreSQL
- Kiểm tra Docker container đang chạy: `docker ps`
- Kiểm tra logs: `docker-compose logs postgres`
- Đảm bảo port 5432 không bị chiếm dụng

### API connection error từ Flutter
- Thay đổi `localhost` thành `10.0.2.2` (Android emulator)
- Hoặc IP máy tính thực (để test trên thiết bị thật)

---

## 📖 TÀI LIỆU THAM KHẢO

### Flutter BLoC
- https://bloclibrary.dev/
- https://pub.dev/packages/flutter_bloc

### Node.js + Sequelize
- https://sequelize.org/docs/
- https://expressjs.com/

### Docker
- https://docs.docker.com/compose/

---

## 🎯 NEXT STEPS

1. **Hoàn thiện Backend**
   - Tạo remaining routes & controllers
   - Implement validation middleware
   - Setup migrations

2. **Hoàn thiện Flutter**
   - Tạo UI screens
   - Implement remaining BLoCs
   - Add routing (GoRouter)

3. **Testing**
   - Unit tests cho BLoCs
   - API integration tests
   - UI widget tests

4. **Deployment**
   - Backend: Deploy to AWS/Heroku
   - Flutter: Build APK/IPA
   - Database: PostgreSQL on cloud

---

**Chúc bạn code thành công! 🚀**

*Nếu cần giúp đỡ thêm, hãy hỏi tôi!*
