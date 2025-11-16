# 💼 Gawean - Job Finder App
---

## ✨ Features

## 📱 Features

- 🔐 **Authentication**: Email/password, Google, Facebook OAuth
- 🔍 **Job Search**: Browse, filter, and search for jobs
- 💼 **Job Management**: Save jobs, apply for positions
- 🏢 **Company Profiles**: View company information and jobs
- 📝 **Application Tracking**: Track your job applications
- 🔔 **Notifications**: Real-time notifications for updates
- 👤 **User Profile**: Manage profile, upload CV and avatar

## 🏗️ Tech Stack

### Frontend (Flutter)
- **State Management**: BLoC Pattern (flutter_bloc)
- **HTTP Client**: Dio with auto-retry
- **Routing**: go_router
- **Authentication**: Firebase Auth (optional), JWT
- **UI**: Material Design 3
- **Local Storage**: SharedPreferences

### Backend (Node.js)
- **Framework**: Express.js
- **Database**: PostgreSQL 16
- **ORM**: Sequelize
- **Authentication**: JWT (jsonwebtoken)
- **Password Hashing**: bcryptjs
- **Logging**: Winston
- **Container**: Docker & Docker Compose

## � Screenshots

### Authentication Screens
<div style="display: flex; gap: 10px;">
  <img src="screenshots/welcome.png" width="200" alt="Welcome Screen"/>
  <img src="screenshots/login.png" width="200" alt="Login Screen"/>
  <img src="screenshots/register.png" width="200" alt="Register Screen"/>
  <img src="screenshots/reset_password.png" width="200" alt="Reset Password"/>
</div>

> **Note:** Add your screenshots to the `screenshots/` folder

---

## �📁 Project Structure

```
job_finder_app/
├── lib/                                    # Flutter Application
│   ├── config/
│   │   ├── constants/
│   │   │   └── api_constants.dart         # API endpoints configuration
│   │   └── theme/
│   │       ├── app_colors.dart            # Color palette
│   │       └── app_theme.dart             # Material 3 theme
│   ├── core/
│   │   ├── repositories/
│   │   │   └── auth_repository.dart       # Authentication repository
│   │   ├── services/
│   │   │   └── dio_client.dart            # HTTP client with interceptors
│   │   └── utils/
│   │       └── storage_service.dart       # Local storage wrapper
│   ├── features/
│   │   ├── auth/
│   │   │   ├── bloc/                      # BLoC State Management
│   │   │   │   ├── auth_bloc.dart
│   │   │   │   ├── auth_event.dart
│   │   │   │   └── auth_state.dart
│   │   │   └── presentation/
│   │   │       └── pages/
│   │   │           ├── welcome_page.dart
│   │   │           ├── login_page.dart
│   │   │           ├── register_page.dart
│   │   │           └── reset_password_page.dart
│   │   └── home/
│   │       └── presentation/
│   │           └── pages/
│   │               └── home_page.dart
│   └── main.dart                          # App entry point
│
├── backend/                                # Node.js Backend
│   ├── src/
│   │   ├── config/
│   │   │   └── database.js                # Sequelize configuration
│   │   ├── controllers/
│   │   │   └── authController.js          # Auth business logic
│   │   ├── middlewares/
│   │   │   └── auth.js                    # JWT authentication
│   │   ├── models/
│   │   │   ├── index.js                   # Model aggregator
│   │   │   ├── User.js                    # User model
│   │   │   └── Job.js                     # Job model
│   │   ├── routes/
│   │   │   ├── authRoutes.js              # Auth endpoints
│   │   │   ├── jobRoutes.js               # Job endpoints
│   │   │   ├── companyRoutes.js
│   │   │   ├── applicationRoutes.js
│   │   │   ├── categoryRoutes.js
│   │   │   └── notificationRoutes.js
│   │   └── utils/
│   │       └── logger.js                  # Winston logger
│   ├── .dockerignore
│   ├── .env.example                       # Environment template
│   ├── docker-compose.yml                 # Multi-container setup
│   ├── Dockerfile                         # API container
│   ├── package.json
│   ├── README.md                          # Backend documentation
│   └── server.js                          # Express server
│
├── .gitignore
├── PROJECT_STATUS.md                      # Development progress
├── SETUP_GUIDE.md                         # Setup instructions
├── analysis_options.yaml
├── pubspec.yaml                           # Flutter dependencies
└── README.md                              # This file
```

## 🚀 Quick Start

### Prerequisites

- **Flutter SDK**: >=3.9.2
- **Node.js**: >=20.x
- **Docker Desktop**: Latest version
- **Git**: Latest version

### 1. Clone Repository

```bash
git clone <repository-url>
cd job_finder_app
```

### 2. Setup Backend

```bash
# Navigate to backend directory
cd backend

# Create .env file
copy .env.example .env

# Edit .env with your configurations
notepad .env

# Start Docker containers
docker-compose up -d

# Install dependencies (if running without Docker)
npm install

# Run migrations (when available)
npm run migrate
```

The backend will be available at:
- **API**: http://localhost:5000
- **PostgreSQL**: localhost:5432
- **pgAdmin**: http://localhost:5050

### 3. Setup Flutter App

```bash
# Navigate to root directory
cd ..

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 📚 API Documentation

### Authentication Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/auth/register` | Register new user | No |
| POST | `/api/auth/login` | User login | No |
| POST | `/api/auth/logout` | User logout | Yes |
| POST | `/api/auth/refresh-token` | Refresh access token | No |
| POST | `/api/auth/forgot-password` | Request password reset | No |
| POST | `/api/auth/reset-password` | Reset password | No |
| GET | `/api/auth/verify-email` | Verify email | No |
| POST | `/api/auth/google` | Google OAuth | No |
| POST | `/api/auth/facebook` | Facebook OAuth | No |

### User Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/users/me` | Get current user | Yes |
| PUT | `/api/users/me` | Update profile | Yes |
| PUT | `/api/users/me/password` | Change password | Yes |
| POST | `/api/users/me/avatar` | Upload avatar | Yes |

### Job Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/jobs` | Get all jobs | No |
| GET | `/api/jobs/featured` | Get featured jobs | No |
| GET | `/api/jobs/recent` | Get recent jobs | No |
| GET | `/api/jobs/recommended` | Get recommended jobs | Yes |
| GET | `/api/jobs/:id` | Get job details | No |

## 🔧 Configuration

### Backend Environment Variables

```env
NODE_ENV=development
PORT=5000
DATABASE_URL=postgresql://user:pass@localhost:5432/db
JWT_SECRET=your_secret_key
JWT_EXPIRES_IN=7d
JWT_REFRESH_SECRET=your_refresh_secret
JWT_REFRESH_EXPIRES_IN=30d
```

### Flutter API Configuration

Edit `lib/config/constants/api_constants.dart`:

```dart
static const String baseUrl = 'http://localhost:5000/api';
```

For Android emulator, use: `http://10.0.2.2:5000/api`

## 🧪 Testing

### Backend Tests
```bash
cd backend
npm test
```

### Flutter Tests
```bash
flutter test
```

## 📦 Build & Deploy

### Build Flutter App

**Android:**
```bash
flutter build apk --release
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

### Deploy Backend

1. Set production environment variables
2. Build Docker image:
```bash
docker build -t job-finder-api .
docker push your-registry/job-finder-api
```

## 🛠️ Development

### Run Backend in Development Mode
```bash
cd backend
npm run dev
```

### Run Flutter with Hot Reload
```bash
flutter run
```

### Database Migrations
```bash
cd backend
npm run migrate
npm run seed  # Optional: seed sample data
```

## 📖 Documentation

- [Setup Guide](SETUP_GUIDE.md) - Detailed setup instructions
- [Backend README](backend/README.md) - Backend API documentation

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👥 Authors

- Your Name - Initial work

## 🙏 Acknowledgments

- Flutter community
- Node.js community
- All contributors
#   J o b _ f i n d e r _ a p p  
 