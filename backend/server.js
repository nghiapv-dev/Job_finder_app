require('dotenv').config();
const express = require('express');
const cors = require('cors');
const sequelize = require('./config/database');

// Import tất cả models và relationships
const models = require('./models');

// Import routes
const authRoutes = require('./routes/auth');
const companiesRoutes = require('./routes/companies');
const jobsRoutes = require('./routes/jobs');
const applicationsRoutes = require('./routes/applications');
const seekerProfilesRoutes = require('./routes/seeker-profiles');
const savedJobsRoutes = require('./routes/saved-jobs');

const app = express();
const PORT = process.env.PORT || 5000;
// Cấu hình CORS cho phép tất cả các nguồn truy cập (API public)
app.use(cors({
  origin: '*',
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'], 
  allowedHeaders: ['Content-Type', 'Authorization'] // cho phép gửi header Authorization
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get('/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Server đang hoạt động!',
    timestamp: new Date().toISOString()
  });
});

// Mount routes
app.use('/api/auth', authRoutes);
app.use('/api/users', authRoutes); // /api/users/me endpoint
app.use('/api/companies', companiesRoutes);
app.use('/api/jobs', jobsRoutes);
app.use('/api/applications', applicationsRoutes);
app.use('/api/seeker-profiles', seekerProfilesRoutes);
app.use('/api/saved-jobs', savedJobsRoutes);

// Xử lý lỗi 404 cho các route không tồn tại
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route không tồn tại.'
  });
});
// Middleware xử lý lỗi chung
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({
    success: false,
    message: 'Lỗi server.',
    error: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});
// Đồng bộ database và khởi động server
const startServer = async () => {
  try {
    // Sync tất cả models với relationships
    await sequelize.sync({ alter: true });
    console.log('✅ Đồng bộ database thành công!');
    console.log('📋 Các bảng đã được tạo:');
    console.log('   - users, seeker_profiles, companies');
    console.log('   - jobs, applications, interviews');
    console.log('   - saved_jobs, conversations, messages');
    
    app.listen(PORT, () => {
      console.log(`\n🚀 Server đang chạy tại http://localhost:${PORT}\n`);
      console.log('📡 API Endpoints:');
      console.log('   Auth:');
      console.log(`     POST   /api/auth/register`);
      console.log(`     POST   /api/auth/login`);
      console.log(`     GET    /api/auth/me (🔒)`);
      console.log(`     PUT    /api/users/me (🔒)`);
      console.log('   ');
      console.log('   Companies:');
      console.log(`     GET    /api/companies`);
      console.log(`     GET    /api/companies/:id`);
      console.log(`     POST   /api/companies (🔒 recruiter)`);
      console.log(`     PUT    /api/companies/:id (🔒 owner)`);
      console.log(`     GET    /api/companies/my/list (🔒 recruiter)`);
      console.log('   ');
      console.log('   Jobs:');
      console.log(`     GET    /api/jobs`);
      console.log(`     GET    /api/jobs/:id`);
      console.log(`     POST   /api/jobs (🔒 recruiter)`);
      console.log(`     PUT    /api/jobs/:id (🔒 owner)`);
      console.log(`     GET    /api/jobs/:id/applications (🔒 recruiter)`);
      console.log('   ');
      console.log('   Applications:');
      console.log(`     GET    /api/applications/my (🔒 seeker)`);
      console.log(`     GET    /api/applications/:id (🔒)`);
      console.log(`     POST   /api/applications (🔒 seeker)`);
      console.log(`     PUT    /api/applications/:id/status (🔒 recruiter)`);
      console.log('   ');
      console.log('   Seeker Profiles:');
      console.log(`     GET    /api/seeker-profiles/me (🔒 seeker)`);
      console.log(`     POST   /api/seeker-profiles (🔒 seeker)`);
      console.log(`     PUT    /api/seeker-profiles/me (🔒 seeker)`);
      console.log('   ');
      console.log('   Saved Jobs:');
      console.log(`     GET    /api/saved-jobs (🔒)`);
      console.log(`     POST   /api/saved-jobs (🔒)`);
      console.log(`     DELETE /api/saved-jobs/:id (🔒)`);
      console.log('   ');
      console.log('   🔒 = Requires Authentication Token');
    });
  } catch (error) {
    console.error('Lỗi khi khởi động server:', error);
    process.exit(1);
  }
};

startServer();
