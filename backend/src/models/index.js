// Khởi tạo kết nối Sequelize (lấy instance sequelize và class Sequelize)
// sequelize: dùng để thực thi query và sync models
// Sequelize: class gốc để truy cập các kiểu dữ liệu (DataTypes, Op, ...) nếu cần
const { sequelize, Sequelize } = require('../config/database');

// Import các model và truyền instance sequelize vào để khởi tạo
// Mỗi file model export một hàm nhận vào sequelize và trả về model đã định nghĩa
const User = require('./User')(sequelize);
const Job = require('./Job')(sequelize);

// Định nghĩa quan hệ giữa các bảng
// Một Job thuộc về một User (nhà tuyển dụng) thông qua khóa ngoại employerId
Job.belongsTo(User, {
  foreignKey: 'employerId',
  as: 'employer', // Alias để truy vấn: job.getEmployer() hoặc include: { model: User, as: 'employer' }
});

// Một User có thể đăng nhiều Job (hasMany). Khóa ngoại nằm ở bảng Job
User.hasMany(Job, {
  foreignKey: 'employerId',
  as: 'postedJobs', // Alias để lấy danh sách job đã đăng: user.getPostedJobs()
});

// Kiểm tra kết nối cơ sở dữ liệu
sequelize
  .authenticate()
  .then(() => {
    console.log('✅ Kết nối database thành công.');
  })
  .catch((err) => {
    console.error('❌ Không thể kết nối database:', err);
  });

// Đồng bộ models với database (CHỈ nên dùng trong development)
// Bật đoạn này để Sequelize tự tạo bảng nếu chưa có.
// CẢNH BÁO: force:true sẽ xóa toàn bộ dữ liệu hiện tại rồi tạo lại bảng.
// alter:true sẽ cố gắng cập nhật cấu trúc bảng để khớp với model mà không xóa dữ liệu.
if (process.env.NODE_ENV === 'development') {
  sequelize.sync({ force: false, alter: true }).then(() => {
    console.log('✅ Đồng bộ models với database hoàn tất.');
  });
}

// Export các model và instance để dùng ở những nơi khác (controller, service, ...)
module.exports = {
  sequelize,
  Sequelize,
  User,
  Job,
};
