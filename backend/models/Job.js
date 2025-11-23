const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Job = sequelize.define('Job', {
  id: {
    type: DataTypes.BIGINT,
    primaryKey: true,
    autoIncrement: true,
  },
  company_id: {
    type: DataTypes.BIGINT,
    allowNull: false,
    references: {
      model: 'companies',
      key: 'id',
    },
    onDelete: 'CASCADE',
  },
  title: {
    type: DataTypes.STRING(255),
    allowNull: false,
  },
  job_type: {
    type: DataTypes.ENUM('full_time', 'part_time', 'remote', 'contract'),
    allowNull: false,
  },
  salary_min: {
    type: DataTypes.DECIMAL(15, 2),
    allowNull: true,
  },
  salary_max: {
    type: DataTypes.DECIMAL(15, 2),
    allowNull: true,
  },
  location: {
    type: DataTypes.STRING(255),
    allowNull: true,
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  requirements: {
    type: DataTypes.TEXT,
    allowNull: true,
    comment: 'Stores JSON or HTML list',
  },
  status: {
    type: DataTypes.ENUM('active', 'closed', 'draft'),
    allowNull: false,
    defaultValue: 'active',
  },
  posted_at: {
    type: DataTypes.DATE,
    allowNull: false,
    defaultValue: DataTypes.NOW,
  },
}, {
  tableName: 'jobs',
  timestamps: false,
  underscored: true,
});

module.exports = Job;
