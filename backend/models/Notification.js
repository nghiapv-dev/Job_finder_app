const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Notification = sequelize.define('Notification', {
  id: {
    type: DataTypes.BIGINT,
    primaryKey: true,
    autoIncrement: true,
  },
  user_id: {
    type: DataTypes.BIGINT,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id',
    },
    onDelete: 'CASCADE',
  },
  type: {
    type: DataTypes.ENUM(
      'application_update',
      'new_message',
      'job_recommendation',
      'saved_job_update',
      'interview_scheduled',
      'application_viewed',
      'system'
    ),
    allowNull: false,
  },
  title: {
    type: DataTypes.STRING(255),
    allowNull: false,
  },
  message: {
    type: DataTypes.TEXT,
    allowNull: false,
  },
  data: {
    type: DataTypes.JSON,
    allowNull: true,
    comment: 'Dữ liệu bổ sung như job_id, application_id, v.v.',
  },
  is_read: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false,
  },
  read_at: {
    type: DataTypes.DATE,
    allowNull: true,
  },
  action_url: {
    type: DataTypes.STRING(500),
    allowNull: true,
    comment: 'Liên kết sâu hoặc URL để điều hướng khi nhấp',
  },
}, {
  tableName: 'notifications',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  indexes: [
    {
      fields: ['user_id', 'is_read', 'created_at'],
      name: 'idx_user_notifications',
    },
  ],
});

module.exports = Notification;
