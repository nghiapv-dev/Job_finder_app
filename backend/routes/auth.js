const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const { authenticate } = require('../middleware/auth');

const generateToken = (userId) => {
  return jwt.sign({ id: userId }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN });
};

router.post('/register', async (req, res) => {
  try {
    const { email, password, fullName, role } = req.body;
    if (!email || !password || !fullName) {
      return res.status(400).json({ success: false, message: 'Vui lòng điền đầy đủ thông tin (email, password, fullName).' });
    }
    const existingUser = await User.findOne({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ success: false, message: 'Email đã được đăng ký.' });
    }
    const user = await User.create({ email, password_hash: password, role: role || 'job_seeker' });
    const token = generateToken(user.id);
    res.status(201).json({ success: true, message: 'Đăng ký thành công!', data: { user: user.toJSON(), token } });
  } catch (error) {
    console.error('Lỗi khi đăng ký:', error);
    if (error.name === 'SequelizeValidationError') {
      return res.status(400).json({ success: false, message: 'Dữ liệu không hợp lệ.', errors: error.errors.map(e => e.message) });
    }
    res.status(500).json({ success: false, message: 'Lỗi server khi đăng ký.', error: error.message });
  }
});

router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ success: false, message: 'Vui lòng nhập email và mật khẩu.' });
    }
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(401).json({ success: false, message: 'Email hoặc mật khẩu không đúng.' });
    }
    // kiểm tra mật khẩu nếu đúng thì tạo một token mới, ngược lại trả về lỗi
    const isPasswordValid = await user.comparePassword(password);
    if (!isPasswordValid) {
      return res.status(401).json({ success: false, message: 'Email hoặc mật khẩu không đúng.' });
    }
    const token = generateToken(user.id);
    res.status(200).json({ success: true, message: 'Đăng nhập thành công!', data: { user: user.toJSON(), token } });
  } catch (error) {
    console.error('Lỗi khi đăng nhập:', error);
    res.status(500).json({ success: false, message: 'Lỗi server khi đăng nhập.', error: error.message });
  }
});

router.get('/me', authenticate, async (req, res) => {
  try {
    res.status(200).json({ success: true, data: { user: req.user.toJSON() } });
  } catch (error) {
    console.error('Lỗi khi lấy thông tin user:', error);
    res.status(500).json({ success: false, message: 'Lỗi server.', error: error.message });
  }
});

router.put('/me', authenticate, async (req, res) => {
  try {
    const { role, full_name, date_of_birth, address, occupation, avatar_url } = req.body;
    const updateData = {};
    
    if (role) updateData.role = role;
    if (full_name) updateData.full_name = full_name;
    if (date_of_birth) updateData.date_of_birth = date_of_birth;
    if (address) updateData.address = address;
    if (occupation) updateData.occupation = occupation;
    if (avatar_url) updateData.avatar_url = avatar_url;
    
    if (Object.keys(updateData).length === 0) {
      return res.status(400).json({ success: false, message: 'Không có dữ liệu để cập nhật.' });
    }
    
    await req.user.update(updateData);
    
    res.status(200).json({ success: true, message: 'Cập nhật thành công!', data: { user: req.user.toJSON() } });
  } catch (error) {
    console.error('Lỗi khi cập nhật user:', error);
    res.status(500).json({ success: false, message: 'Lỗi server khi cập nhật.', error: error.message });
  }
});

module.exports = router;
