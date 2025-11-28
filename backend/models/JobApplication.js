const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Application = sequelize.define('Application', {
  id: {
    type: DataTypes.BIGINT,
    primaryKey: true,
    autoIncrement: true,
  },
  job_id: {
    type: DataTypes.BIGINT,
    allowNull: false,
    references: {
      model: 'jobs',
      key: 'id',
    },
    onDelete: 'CASCADE',
  },
  seeker_id: {
    type: DataTypes.BIGINT,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id',
    },
    onDelete: 'CASCADE',
  },
  status: {
    type: DataTypes.ENUM('applied', 'interview', 'rejected', 'accepted'),
    allowNull: false,
    defaultValue: 'applied',
  },
  resume_snapshot_url: {
    type: DataTypes.STRING(255),
    allowNull: true,
    comment: 'Phiên bản CV tại thời điểm nộp đơn',
  },
  cover_letter: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  applied_at: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW,
  },
}, {
  tableName: 'applications',
  timestamps: false,
  underscored: true,
});

module.exports = Application;
