require('dotenv').config();
const express = require('express');
const cors = require('cors');
const sequelize = require('./config/database');
const User = require('./models/User');
const authRoutes = require('./routes/auth');

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

app.use('/api/auth', authRoutes);
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
    await sequelize.sync({ alter: true });
    console.log('Đồng bộ database thành công!');
    app.listen(PORT, () => {
      console.log(`Server đang chạy tại http://localhost:${PORT}`);
      console.log('API Endpoints:');
      console.log(`  - POST http://localhost:${PORT}/api/auth/register`);
      console.log(`  - POST http://localhost:${PORT}/api/auth/login`);
      console.log(`  - GET  http://localhost:${PORT}/api/auth/me (cần token)`);
    });
  } catch (error) {
    console.error('Lỗi khi khởi động server:', error);
    process.exit(1);
  }
};

startServer();
