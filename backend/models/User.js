const { DataTypes } = require('sequelize');
const bcrypt = require('bcryptjs');
const sequelize = require('../config/database');

const User = sequelize.define('User', {
  id: { 
    type: DataTypes.BIGINT, 
    primaryKey: true, 
    autoIncrement: true 
  },
  email: { 
    type: DataTypes.STRING(255), 
    allowNull: false, 
    unique: true, 
    validate: { isEmail: { msg: 'Email không hợp lệ' } } 
  },
  password_hash: { 
    type: DataTypes.STRING(255), 
    allowNull: false, 
    validate: { len: { args: [6], msg: 'Mật khẩu phải có ít nhất 6 ký tự' } } 
  },
  full_name: {
    type: DataTypes.STRING(255),
    allowNull: true
  },
  avatar_url: {
    type: DataTypes.STRING(500),
    allowNull: true
  },
  role: { 
    type: DataTypes.ENUM('job_seeker', 'recruiter', 'admin'), 
    allowNull: false, 
    defaultValue: 'job_seeker' 
  },
  is_verified: { 
    type: DataTypes.BOOLEAN, 
    allowNull: false, 
    defaultValue: false 
  }
}, {
  tableName: 'users',
  timestamps: true,
  underscored: true,
  hooks: {
    beforeCreate: async (user) => {
      if (user.password_hash) {
        const salt = await bcrypt.genSalt(10);
        user.password_hash = await bcrypt.hash(user.password_hash, salt);
      }
    },
    beforeUpdate: async (user) => {
      if (user.changed('password_hash')) {
        const salt = await bcrypt.genSalt(10);
        user.password_hash = await bcrypt.hash(user.password_hash, salt);
      }
    }
  }
});
// so sánh mật khẩu
User.prototype.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password_hash);
};
// ẩn mật khẩu khi trả về JSON 
User.prototype.toJSON = function() {
  const values = { ...this.get() };
  delete values.password_hash;
  return values;
};

module.exports = User;
