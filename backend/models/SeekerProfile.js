const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const SeekerProfile = sequelize.define('SeekerProfile', {
  user_id: {
    type: DataTypes.BIGINT,
    primaryKey: true,
    references: {
      model: 'users',
      key: 'id',
    },
    onDelete: 'CASCADE',
  },
  full_name: {
    type: DataTypes.STRING(255),
    allowNull: false,
  },
  phone: {
    type: DataTypes.STRING(20),
    allowNull: true,
  },
  avatar_url: {
    type: DataTypes.STRING(255),
    allowNull: true,
  },
  occupation: {
    type: DataTypes.STRING(100),
    allowNull: true,
    comment: 'Ex: UI/UX Designer',
  },
  resume_url: {
    type: DataTypes.STRING(255),
    allowNull: true,
    comment: 'Link to PDF CV file',
  },
  address: {
    type: DataTypes.STRING(255),
    allowNull: true,
  },
  dob: {
    type: DataTypes.DATEONLY,
    allowNull: true,
  },
}, {
  tableName: 'seeker_profiles',
  timestamps: false,
  underscored: true,
});

module.exports = SeekerProfile;
