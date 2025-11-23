# API Documentation - Job Finder App

Base URL: `http://localhost:5000`

## 🔐 Authentication

All protected routes require JWT token in Authorization header:
```
Authorization: Bearer <your_token>
```

---

## 📋 Auth Routes

### POST /api/auth/register
Register a new user.

**Body:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "fullName": "John Doe", 
  "role": "job_seeker" // or "recruiter"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Đăng ký thành công!",
  "data": {
    "user": { "id": 1, "email": "...", "role": "job_seeker" },
    "token": "eyJhbGc..."
  }
}
```

### POST /api/auth/login
Login user.

**Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

### GET /api/auth/me 🔒
Get current user info.

### PUT /api/users/me 🔒
Update user profile (role, full_name, etc.).

---

## 🏢 Companies Routes

### GET /api/companies
Get all companies (public, with pagination).

**Query Params:**
- `page` (default: 1)
- `limit` (default: 10)
- `industry` (filter by industry)

### GET /api/companies/:id
Get company details with active jobs.

### POST /api/companies 🔒 (Recruiter only)
Create new company.

**Body:**
```json
{
  "name": "Google Inc.",
  "logo_url": "https://...",
  "industry": "Technology",
  "size": "10000+ employees",
  "address": "Mountain View, CA",
  "website": "https://google.com",
  "description": "We are..."
}
```

### PUT /api/companies/:id 🔒 (Owner only)
Update company (only company owner can update).

### DELETE /api/companies/:id 🔒 (Owner only)
Delete company.

### GET /api/companies/my/list 🔒 (Recruiter)
Get all companies owned by current recruiter.

---

## 💼 Jobs Routes

### GET /api/jobs
Get all active jobs (with filters).

**Query Params:**
- `page`, `limit` (pagination)
- `job_type` (full_time, part_time, remote, contract)
- `location` (search by location)
- `search` (search in title/description)
- `company_id` (filter by company)

**Response:**
```json
{
  "success": true,
  "data": {
    "jobs": [...],
    "pagination": {
      "total": 50,
      "page": 1,
      "limit": 10,
      "totalPages": 5
    }
  }
}
```

### GET /api/jobs/:id
Get job details with company info.

### POST /api/jobs 🔒 (Recruiter only)
Create new job posting.

**Body:**
```json
{
  "company_id": 1,
  "title": "Senior UI/UX Designer",
  "job_type": "full_time",
  "salary_min": 2000.00,
  "salary_max": 4000.00,
  "location": "Ho Chi Minh City",
  "description": "We are looking for...",
  "requirements": "- 3+ years experience...",
  "status": "active" // or "draft", "closed"
}
```

### PUT /api/jobs/:id 🔒 (Owner)
Update job (only company owner can update).

### DELETE /api/jobs/:id 🔒 (Owner)
Delete job.

### GET /api/jobs/:id/applications 🔒 (Recruiter)
Get all applications for a job (only job owner can view).

---

## 📝 Applications Routes

### GET /api/applications/my 🔒 (Job Seeker)
Get my applications with job & company details.

### GET /api/applications/:id 🔒
Get application details (owner or recruiter can view).

### POST /api/applications 🔒 (Job Seeker)
Apply for a job.

**Body:**
```json
{
  "job_id": 1,
  "resume_snapshot_url": "https://...",
  "cover_letter": "I am interested in..."
}
```

**Note:** Cannot apply twice to the same job.

### PUT /api/applications/:id/status 🔒 (Recruiter)
Update application status.

**Body:**
```json
{
  "status": "interview" // applied, interview, rejected, accepted
}
```

### DELETE /api/applications/:id 🔒 (Seeker - Owner)
Withdraw application.

---

## 👤 Seeker Profiles Routes

### GET /api/seeker-profiles/me 🔒 (Job Seeker)
Get my seeker profile.

### POST /api/seeker-profiles 🔒 (Job Seeker)
Create seeker profile (first time).

**Body:**
```json
{
  "full_name": "Nguyen Van A",
  "phone": "0909123456",
  "avatar_url": "https://...",
  "occupation": "UI/UX Designer",
  "resume_url": "https://...",
  "address": "123 Street, District 1",
  "dob": "2000-01-15"
}
```

### PUT /api/seeker-profiles/me 🔒 (Job Seeker)
Update or create seeker profile.

### GET /api/seeker-profiles/:user_id
Get public profile info of a seeker (for recruiters).

---

## ⭐ Saved Jobs Routes

### GET /api/saved-jobs 🔒
Get my saved jobs with details.

### POST /api/saved-jobs 🔒
Save a job.

**Body:**
```json
{
  "job_id": 1,
  "note": "Interesting position"
}
```

### DELETE /api/saved-jobs/:id 🔒
Remove saved job by saved_job_id.

### DELETE /api/saved-jobs/job/:job_id 🔒
Unsave job by job_id.

### GET /api/saved-jobs/check/:job_id 🔒
Check if job is saved.

**Response:**
```json
{
  "success": true,
  "data": {
    "isSaved": true,
    "savedJobId": 5
  }
}
```

---

## 🔒 Access Control

| Route | Job Seeker | Recruiter | Admin |
|-------|-----------|-----------|-------|
| Auth (register, login) | ✅ | ✅ | ✅ |
| Companies (GET) | ✅ | ✅ | ✅ |
| Companies (POST, PUT) | ❌ | ✅ (own) | ✅ |
| Jobs (GET) | ✅ | ✅ | ✅ |
| Jobs (POST, PUT) | ❌ | ✅ (own) | ✅ |
| Applications (POST) | ✅ | ❌ | ✅ |
| Applications (status update) | ❌ | ✅ (own jobs) | ✅ |
| Seeker Profiles | ✅ | View only | ✅ |
| Saved Jobs | ✅ | ✅ | ✅ |

---

## 📊 Response Format

### Success Response
```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

### Error Response
```json
{
  "success": false,
  "message": "Error message",
  "error": "Detailed error (development only)"
}
```

### Common Status Codes
- `200` - Success
- `201` - Created
- `400` - Bad Request (validation error)
- `401` - Unauthorized (missing/invalid token)
- `403` - Forbidden (insufficient permissions)
- `404` - Not Found
- `500` - Server Error

---

## 🧪 Testing

### Using cURL

```bash
# Register
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"seeker@test.com","password":"123456","fullName":"Test Seeker","role":"job_seeker"}'

# Login
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"seeker@test.com","password":"123456"}'

# Get jobs (with token)
curl http://localhost:5000/api/jobs \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Using Postman/Thunder Client

1. Create environment variable `base_url` = `http://localhost:5000`
2. Create environment variable `token` after login
3. Use `{{base_url}}/api/...` in requests
4. Add `Authorization: Bearer {{token}}` in headers for protected routes

---

**Last Updated:** November 23, 2025
