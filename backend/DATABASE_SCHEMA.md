# Database Schema - Job Finder App (Gawean)

## 📋 Tổng quan

Database sử dụng PostgreSQL 16 với Sequelize ORM.
Schema được thiết kế theo chuẩn MySQL/MariaDB từ file jobfinder.sql.

## 🗂️ Danh sách các bảng (10 tables)

### 1. **users** - Tài khoản người dùng
```sql
- id: BIGINT (Primary Key, Auto Increment)
- email: VARCHAR(255) - Unique, Not Null
- password_hash: VARCHAR(255) - Hashed, Not Null
- role: ENUM('job_seeker', 'recruiter', 'admin') - Default: 'job_seeker'
- is_verified: BOOLEAN - Default: FALSE
- created_at: TIMESTAMP
- updated_at: TIMESTAMP
```

**Relationships:**
- Has One: SeekerProfile (if role = job_seeker)
- Has Many: Companies (if role = recruiter)
- Has Many: Applications, SavedJobs, Messages
- Many-to-Many: Conversations (through conversation_participants)

---

### 2. **seeker_profiles** - Hồ sơ người tìm việc
```sql
- user_id: BIGINT (Primary Key, Foreign Key → users.id)
- full_name: VARCHAR(255) - Not Null
- phone: VARCHAR(20)
- avatar_url: VARCHAR(255)
- occupation: VARCHAR(100) - Ex: UI/UX Designer
- resume_url: VARCHAR(255) - Link to PDF CV file
- address: VARCHAR(255)
- dob: DATE - Date of birth
```

**Relationships:**
- Belongs To: User (One-to-One)

---

### 3. **companies** - Hồ sơ công ty (do Recruiter quản lý)
```sql
- id: BIGINT (Primary Key, Auto Increment)
- recruiter_id: BIGINT (Foreign Key → users.id) - Not Null
- name: VARCHAR(255) - Not Null
- logo_url: VARCHAR(255)
- industry: VARCHAR(100) - Ex: Technology, Finance
- size: VARCHAR(50) - Ex: 50-100 employees
- address: TEXT
- website: VARCHAR(255)
- description: TEXT
```

**Relationships:**
- Belongs To: User (recruiter)
- Has Many: Jobs

---

### 4. **jobs** - Tin tuyển dụng
```sql
- id: BIGINT (Primary Key, Auto Increment)
- company_id: BIGINT (Foreign Key → companies.id) - Not Null
- title: VARCHAR(255) - Not Null
- job_type: ENUM('full_time', 'part_time', 'remote', 'contract') - Not Null
- salary_min: DECIMAL(15,2)
- salary_max: DECIMAL(15,2)
- location: VARCHAR(255)
- description: TEXT
- requirements: TEXT - Stores JSON or HTML list
- status: ENUM('active', 'closed', 'draft') - Default: 'active'
- posted_at: TIMESTAMP - Default: NOW
```

**Relationships:**
- Belongs To: Company
- Has Many: Applications, SavedJobs

---

### 5. **applications** - Đơn ứng tuyển
```sql
- id: BIGINT (Primary Key, Auto Increment)
- job_id: BIGINT (Foreign Key → jobs.id) - Not Null
- seeker_id: BIGINT (Foreign Key → users.id) - Not Null
- status: ENUM('applied', 'interview', 'rejected', 'accepted') - Default: 'applied'
- resume_snapshot_url: VARCHAR(255) - CV version at time of apply
- cover_letter: TEXT
- applied_at: TIMESTAMP - Default: NOW
```

**Relationships:**
- Belongs To: Job, User (seeker)
- Has Many: Interviews

---

### 6. **interviews** - Lịch phỏng vấn
```sql
- id: BIGINT (Primary Key, Auto Increment)
- application_id: BIGINT (Foreign Key → applications.id) - Not Null
- scheduled_time: DATETIME - Not Null
- type: ENUM('video_call', 'voice_call', 'offline') - Not Null
- meeting_link: VARCHAR(255)
- message: TEXT
- created_at: TIMESTAMP - Default: NOW
```

**Relationships:**
- Belongs To: Application

---

### 7. **saved_jobs** - Việc làm đã lưu
```sql
- id: BIGINT (Primary Key)
- job_id: BIGINT (Foreign Key → jobs.id) - Not Null
- user_id: BIGINT (Foreign Key → users.id) - Not Null
- note: TEXT - Personal note
- created_at: TIMESTAMP
- updated_at: TIMESTAMP
```

**Indexes:**
- Unique: (job_id, user_id) - User can only save once per job

**Relationships:**
- Belongs To: Job, User

---

### 8. **conversations** - Hội thoại chat
```sql
- id: BIGINT (Primary Key, Auto Increment)
- job_id: BIGINT (Foreign Key → jobs.id) - Optional context
- created_at: TIMESTAMP - Default: NOW
```

**Relationships:**
- Has Many: Messages
- Many-to-Many: Users (through conversation_participants)

---

### 9. **conversation_participants** - Người tham gia hội thoại
```sql
- conversation_id: BIGINT (Primary Key, Foreign Key → conversations.id)
- user_id: BIGINT (Primary Key, Foreign Key → users.id)
```
**Composite Primary Key:** (conversation_id, user_id)

**Relationships:**
- Belongs To: Conversation, User

---

### 10. **messages** - Tin nhắn
```sql
- id: BIGINT (Primary Key, Auto Increment)
- conversation_id: BIGINT (Foreign Key → conversations.id) - Not Null
- sender_id: BIGINT (Foreign Key → users.id) - Not Null
- content: TEXT
- type: ENUM('text', 'image', 'file', 'call_log') - Default: 'text'
- is_read: BOOLEAN - Default: FALSE
- created_at: TIMESTAMP - Default: NOW
```

**Relationships:**
- Belongs To: Conversation, User (sender)

---

## 🔗 Entity Relationship Diagram (ERD)

```
users (1) ←→ (1) seeker_profiles [job_seeker only]
users (1) ←→ (*) companies [recruiter only]
companies (1) ←→ (*) jobs
users (1) ←→ (*) applications [as seeker]
jobs (1) ←→ (*) applications
applications (1) ←→ (*) interviews
users (1) ←→ (*) saved_jobs
jobs (1) ←→ (*) saved_jobs
users (*) ←→ (*) conversations [through conversation_participants]
conversations (1) ←→ (*) messages
users (1) ←→ (*) messages [as sender]
```

---

## 🚀 Cách sử dụng

### Tạo bảng mới
```javascript
// Tự động sync khi khởi động server
await sequelize.sync({ alter: true });
```

### Truy cập Database
```bash
# Vào PostgreSQL container
docker exec -it job-finder-postgres bash

# Connect to database
psql -U jobfinder -d job_finder_db

# Liệt kê bảng
\dt

# Xem cấu trúc bảng
\d table_name
```

### Thêm Model mới
1. Tạo file trong `backend/models/YourModel.js`
2. Define schema với Sequelize
3. Thêm vào `backend/models/index.js` để setup relationships
4. Restart backend container để sync

---

## 📝 Notes

- **Schema Design**: Dựa trên file `jobfinder.sql` (MySQL/MariaDB dialect)
- **Separation of Concerns**: 
  - `seeker_profiles` riêng cho job seekers
  - `companies` riêng cho recruiters
  - `conversations` + `conversation_participants` cho chat system
- Tất cả Foreign Keys có `ON DELETE CASCADE` để tự động xóa dữ liệu liên quan
- Sử dụng BIGINT cho IDs để hỗ trợ số lượng record lớn
- Composite Primary Key cho `conversation_participants`
- ENUM types để đảm bảo data integrity
- Một số bảng không có timestamps để giữ đơn giản

## 🆕 Key Differences từ schema cũ

| Old Schema | New Schema | Changes |
|------------|------------|---------|
| `user_profiles` (chung) | `seeker_profiles` (riêng) | Chỉ cho job_seeker, đơn giản hóa |
| Jobs có `posted_by` (user) | Jobs có `company_id` | Jobs thuộc về company, không trực tiếp user |
| Không có `companies` | Có `companies` | Recruiter quản lý nhiều companies |
| Không có `interviews` | Có `interviews` | Lịch phỏng vấn riêng biệt |
| `messages` đơn giản | `conversations` + `participants` + `messages` | Chat system rõ ràng hơn |
| Có `notifications` | Không có `notifications` | Sẽ thêm sau nếu cần |

---

**Source**: `jobfinder.sql` (MySQL schema)  
**Implemented**: PostgreSQL 16 + Sequelize ORM  
**Updated**: November 23, 2025
