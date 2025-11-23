const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Interview = sequelize.define('Interview', {
  id: {
    type: DataTypes.BIGINT,
    primaryKey: true,
    autoIncrement: true,
  },
  application_id: {
    type: DataTypes.BIGINT,
    allowNull: false,
    references: {
      model: 'applications',
      key: 'id',
    },
    onDelete: 'CASCADE',
  },
  scheduled_time: {
    type: DataTypes.DATE,
    allowNull: false,
  },
  type: {
    type: DataTypes.ENUM('video_call', 'voice_call', 'offline'),
    allowNull: false,
  },
  meeting_link: {
    type: DataTypes.STRING(255),
    allowNull: true,
  },
  message: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  created_at: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW,
  },
}, {
  tableName: 'interviews',
  timestamps: false,
  underscored: true,
});

module.exports = Interview;
