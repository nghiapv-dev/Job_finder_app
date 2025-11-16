# Job Finder Backend API

Backend API cho Job Finder App sử dụng Node.js, Express.js, PostgreSQL và Docker.

## 🚀 Quick Start

### Với Docker (Recommended)
```bash
# Khởi động tất cả services
docker-compose up -d

# Xem logs
docker-compose logs -f

# Dừng services
docker-compose down
```

### Không dùng Docker
```bash
# Cài đặt dependencies
npm install

# Tạo .env file
cp .env.example .env

# Chỉnh sửa .env với database credentials

# Chạy server
npm run dev
```

## 📦 Services

- **API Server**: http://localhost:5000
- **PostgreSQL**: localhost:5432
- **pgAdmin**: http://localhost:5050

## 🔑 Environment Variables

Xem file `.env.example` để biết các biến cần thiết.

## 📚 API Documentation

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/logout` - Logout user
- `POST /api/auth/forgot-password` - Request password reset
- `POST /api/auth/reset-password` - Reset password
- `POST /api/auth/google` - Google OAuth
- `POST /api/auth/facebook` - Facebook OAuth

### Users
- `GET /api/users/me` - Get current user
- `PUT /api/users/me` - Update profile
- `POST /api/users/me/avatar` - Upload avatar
- `POST /api/users/me/cv` - Upload CV

### Jobs
- `GET /api/jobs` - Get all jobs (with filters)
- `GET /api/jobs/:id` - Get job by ID
- `POST /api/jobs` - Create job (employer only)
- `PUT /api/jobs/:id` - Update job
- `DELETE /api/jobs/:id` - Delete job

### Applications
- `GET /api/applications` - Get user's applications
- `POST /api/applications` - Apply for a job
- `GET /api/applications/:id` - Get application details
- `DELETE /api/applications/:id` - Withdraw application

## 🛠️ Development

```bash
# Run in development mode with nodemon
npm run dev

# Run migrations
npm run migrate

# Run seeds
npm run seed
```

## 📝 License

MIT
