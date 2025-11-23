const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const SavedJob = sequelize.define('SavedJob', {
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
  user_id: {
    type: DataTypes.BIGINT,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id',
    },
    onDelete: 'CASCADE',
  },
  note: {
    type: DataTypes.TEXT,
    allowNull: true,
    comment: 'Personal note about why saved',
  },
}, {
  tableName: 'saved_jobs',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  indexes: [
    {
      unique: true,
      fields: ['job_id', 'user_id'],
      name: 'unique_saved_job',
    },
  ],
});

module.exports = SavedJob;
