// Model Job định nghĩa cấu trúc dữ liệu công việc (job posting) trong hệ thống
// Sử dụng Sequelize DataTypes để khai báo kiểu dữ liệu cho từng trường
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  // Định nghĩa model 'Job' ánh xạ tới bảng 'jobs' trong database
  const Job = sequelize.define('Job', {
  // ID duy nhất của job posting (UUID để bảo mật và phân tán tốt hơn)
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  // Tiêu đề công việc (VD: "Senior Frontend Developer")
  title: {
    type: DataTypes.STRING,
    allowNull: false
  },
  // Slug thân thiện SEO (tự sinh từ title, VD: "senior-frontend-developer-abc123")
  slug: {
    type: DataTypes.STRING,
    unique: true
  },
  // ID công ty đăng tin (tạm thời bỏ foreign key vì chưa có bảng companies)
  company_id: {
    type: DataTypes.UUID,
    allowNull: true, // Đổi thành true để không bắt buộc
    // references: {
    //   model: 'companies',
    //   key: 'id'
    // }
  },
  // Mô tả chi tiết công việc (dạng văn bản dài)
  description: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  // Yêu cầu công việc (mảng văn bản). VD: ["3+ năm kinh nghiệm React", "Tiếng Anh tốt"]
  requirements: {
    type: DataTypes.ARRAY(DataTypes.TEXT),
    defaultValue: []
  },
  // Trách nhiệm công việc (mảng). VD: ["Phát triển giao diện web", "Code review"]
  responsibilities: {
    type: DataTypes.ARRAY(DataTypes.TEXT),
    defaultValue: []
  },
  // Quyền lợi, phúc lợi (mảng). VD: ["Bảo hiểm đầy đủ", "13th month salary", "Laptop"]
  benefits: {
    type: DataTypes.ARRAY(DataTypes.STRING),
    defaultValue: []
  },
  // Danh mục công việc (VD: "Software Development", "Marketing", "Design")
  category: {
    type: DataTypes.STRING,
    allowNull: false
  },
  // Loại hình công việc: toàn thời gian, bán thời gian, hợp đồng, freelance, thực tập
  job_type: {
    type: DataTypes.ENUM('full-time', 'part-time', 'contract', 'freelance', 'internship'),
    allowNull: false
  },
  // Hình thức làm việc: tại văn phòng, từ xa, hoặc kết hợp
  work_mode: {
    type: DataTypes.ENUM('onsite', 'remote', 'hybrid'),
    allowNull: false
  },
  // Cấp độ kinh nghiệm: entry (mới vào nghề), mid, senior, lead
  experience_level: {
    type: DataTypes.ENUM('entry', 'mid', 'senior', 'lead'),
    allowNull: false
  },
  // Yêu cầu trình độ học vấn (VD: "Cử nhân CNTT", "không yêu cầu bằng cấp")
  education: {
    type: DataTypes.STRING,
    allowNull: true
  },
  // Mức lương tối thiểu (decimal cho độ chính xác cao)
  salary_min: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: true
  },
  // Mức lương tối đa
  salary_max: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: true
  },
  // Đơn vị tiền tệ (mặc định USD, có thể VND, EUR, ...)
  salary_currency: {
    type: DataTypes.STRING,
    defaultValue: 'USD'
  },
  // Chu kỳ trả lương: theo giờ, tháng, hoặc năm
  salary_period: {
    type: DataTypes.ENUM('hourly', 'monthly', 'yearly'),
    defaultValue: 'monthly'
  },
  // Địa chỉ cụ thể (số nhà, tên đường)
  location_address: {
    type: DataTypes.STRING,
    allowNull: true
  },
  // Thành phố (VD: "Hà Nội", "Ho Chi Minh City")
  location_city: {
    type: DataTypes.STRING,
    allowNull: false
  },
  // Quốc gia (VD: "Vietnam", "USA")
  location_country: {
    type: DataTypes.STRING,
    allowNull: false
  },
  // Tọa độ latitude (dùng cho map, tìm kiếm gần)
  location_lat: {
    type: DataTypes.DECIMAL(10, 8),
    allowNull: true
  },
  // Tọa độ longitude
  location_lng: {
    type: DataTypes.DECIMAL(11, 8),
    allowNull: true
  },
  // Danh sách kỹ năng yêu cầu (mảng). VD: ["React", "Node.js", "TypeScript"]
  skills: {
    type: DataTypes.ARRAY(DataTypes.STRING),
    defaultValue: []
  },
  // Số lượng vị trí cần tuyển (mặc định 1)
  number_of_positions: {
    type: DataTypes.INTEGER,
    defaultValue: 1
  },
  // Hạn chót nộp hồ sơ (null = không giới hạn thời gian)
  application_deadline: {
    type: DataTypes.DATE,
    allowNull: true
  },
  // Trạng thái tin tuyển dụng: open (đang mở), closed (đã đóng), draft (bản nháp chưa công bố)
  status: {
    type: DataTypes.ENUM('open', 'closed', 'draft'),
    defaultValue: 'open'
  },
  // Đánh dấu tin nổi bật (hiển thị ưu tiên trên trang chủ)
  is_featured: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  // Đánh dấu tin gấp (thường kèm biểu tượng 🔥)
  is_urgent: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  // Số lượt xem tin (phục vụ thống kê)
  view_count: {
    type: DataTypes.INTEGER,
    defaultValue: 0
  },
  // Số lượng ứng viên đã nộp hồ sơ (tăng khi có application mới)
  application_count: {
    type: DataTypes.INTEGER,
    defaultValue: 0
  },
  // ID người đăng tin (employer hoặc admin), foreign key tới bảng users
  posted_by: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id'
    }
  }
}, {
  tableName: 'jobs', // Tên bảng trong database
  hooks: {
    // Hook chạy trước khi tạo bản ghi: tự sinh slug từ title nếu chưa có
    beforeCreate: (job) => {
      if (!job.slug) {
        job.slug = job.title
          .toLowerCase()                         // Chuyển thường
          .replace(/[^a-z0-9]+/g, '-')          // Thay ký tự đặc biệt bằng dấu gạch ngang
          .replace(/(^-|-$)/g, '') +            // Xóa dấu gạch đầu/cuối
          '-' + Math.random().toString(36).substring(2, 8); // Thêm chuỗi ngẫu nhiên để đảm bảo unique
      }
    }
  },
  // Tạo indexes để tăng tốc truy vấn
  indexes: [
    {
      fields: ['title']  // Index cho tìm kiếm theo tiêu đề
    },
    {
      fields: ['category']  // Index cho filter theo danh mục
    },
    {
      fields: ['location_city', 'location_country']  // Index composite cho filter theo địa điểm
    },
    {
      fields: ['status']  // Index cho filter theo trạng thái (open, closed, draft)
    },
    {
      fields: ['created_at']  // Index cho sắp xếp theo thời gian đăng (mới nhất)
    }
  ]
  });

  return Job;
};
