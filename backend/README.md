# Job Finder Backend

Backend đơn giản cho ứng dụng Job Finder - chỉ có đăng ký và đăng nhập.

##  Cấu trúc

```
backend/
 config/
    database.js       # Cấu hình PostgreSQL
 middleware/
    auth.js          # Middleware JWT
 models/
    User.js          # Model User
 routes/
    auth.js          # Routes auth
 .env                 # Config
 package.json
 server.js            # Entry point
```

##  Cài đặt

```bash
cd backend
npm install
```

##  PostgreSQL (Docker)

```bash
docker run --name job-finder-postgres -e POSTGRES_DB=job_finder_db -e POSTGRES_USER=jobfinder -e POSTGRES_PASSWORD=jobfinder123 -p 5432:5432 -d postgres:16-alpine
```

##  Chạy server

```bash
npm start       # Production
npm run dev     # Development
```

Server: `http://localhost:5000`

##  API

### Đăng ký
POST `/api/auth/register`
```json
{
  "email": "test@example.com",
  "password": "123456",
  "fullName": "Nguyễn Văn A",
  "role": "job_seeker"
}
```

### Đăng nhập
POST `/api/auth/login`
```json
{
  "email": "test@example.com",
  "password": "123456"
}
```

### Lấy thông tin user
GET `/api/auth/me`
Header: `Authorization: Bearer <token>`

##  Test (PowerShell)

```powershell
$body = @{
  email = "test@example.com"
  password = "123456"
  fullName = "Test User"
  role = "job_seeker"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/auth/register" -Method POST -Body $body -ContentType "application/json"
```
