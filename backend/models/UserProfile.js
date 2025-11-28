const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const UserProfile = sequelize.define('UserProfile', {
  id: {
    type: DataTypes.BIGINT,
    primaryKey: true,
    autoIncrement: true,
  },
  user_id: {
    type: DataTypes.BIGINT,
    allowNull: false,
    unique: true,
    references: {
      model: 'users',
      key: 'id',
    },
    onDelete: 'CASCADE',
  },
  bio: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  skills: {
    type: DataTypes.JSON,
    allowNull: true,
    comment: 'Mảng các đối tượng kỹ năng với tên và cấp độ',
  },
  languages: {
    type: DataTypes.JSON,
    allowNull: true,
    comment: 'Mảng các đối tượng ngôn ngữ',
  },
  education: {
    type: DataTypes.JSON,
    allowNull: true,
    comment: 'Mảng lịch sử học vấn',
  },
  experience: {
    type: DataTypes.JSON,
    allowNull: true,
    comment: 'Mảng kinh nghiệm làm việc',
  },
  certifications: {
    type: DataTypes.JSON,
    allowNull: true,
    comment: 'Mảng các chứng chỉ',
  },
  portfolio_url: {
    type: DataTypes.STRING(500),
    allowNull: true,
  },
  github_url: {
    type: DataTypes.STRING(500),
    allowNull: true,
  },
  linkedin_url: {
    type: DataTypes.STRING(500),
    allowNull: true,
  },
  website_url: {
    type: DataTypes.STRING(500),
    allowNull: true,
  },
  resume_url: {
    type: DataTypes.STRING(500),
    allowNull: true,
  },
  phone: {
    type: DataTypes.STRING(20),
    allowNull: true,
  },
  expected_salary_min: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: true,
  },
  expected_salary_max: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: true,
  },
  job_preferences: {
    type: DataTypes.JSON,
    allowNull: true,
    comment: 'Các loại công việc ưu tiên, địa điểm, v.v.',
  },
  availability: {
    type: DataTypes.ENUM('immediate', '2-weeks', '1-month', 'not-looking'),
    allowNull: true,
    defaultValue: 'immediate',
  },
  profile_visibility: {
    type: DataTypes.ENUM('public', 'private', 'connections-only'),
    allowNull: false,
    defaultValue: 'public',
  },
  is_profile_complete: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false,
  },
}, {
  tableName: 'user_profiles',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
});

module.exports = UserProfile;
