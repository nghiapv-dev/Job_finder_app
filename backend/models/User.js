const { DataTypes } = require('sequelize');
const bcrypt = require('bcryptjs');
const sequelize = require('../config/database');

const User = sequelize.define('User', {
  id: { type: DataTypes.BIGINT, primaryKey: true, autoIncrement: true },
  email: { type: DataTypes.STRING(255), allowNull: false, unique: true, validate: { isEmail: { msg: 'Email không hợp lệ' } } },
  password: { type: DataTypes.STRING(255), allowNull: false, validate: { len: { args: [6], msg: 'Mật khẩu phải có ít nhất 6 ký tự' } } },
  full_name: { type: DataTypes.STRING(255), allowNull: false, validate: { notEmpty: { msg: 'Họ tên không được để trống' } } },
  role: { type: DataTypes.ENUM('job_seeker', 'employer'), allowNull: false, defaultValue: 'job_seeker' }
}, {
  tableName: 'users',
  timestamps: true,
  underscored: true,
  hooks: {
    beforeCreate: async (user) => {
      if (user.password) {
        const salt = await bcrypt.genSalt(10);
        user.password = await bcrypt.hash(user.password, salt);
      }
    },
    beforeUpdate: async (user) => {
      if (user.changed('password')) {
        const salt = await bcrypt.genSalt(10);
        user.password = await bcrypt.hash(user.password, salt);
      }
    }
  }
});
// so sánh mật khẩu
User.prototype.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};
// ẩn mật khẩu khi trả về JSON 
User.prototype.toJSON = function() {
  const values = { ...this.get() };
  delete values.password;
  return values;
};

module.exports = User;
