const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Conversation = sequelize.define('Conversation', {
  id: {
    type: DataTypes.BIGINT,
    primaryKey: true,
    autoIncrement: true,
  },
  job_id: {
    type: DataTypes.BIGINT,
    allowNull: true,
    references: {
      model: 'jobs',
      key: 'id',
    },
    comment: 'Optional context',
  },
  created_at: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW,
  },
}, {
  tableName: 'conversations',
  timestamps: false,
  underscored: true,
});

module.exports = Conversation;
