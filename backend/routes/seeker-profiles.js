const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { SeekerProfile } = require('../models');

// @route   GET /api/seeker-profiles/me
// @desc    Get my seeker profile
// @access  Private (Job Seeker)
router.get('/me', authenticate, async (req, res) => {
  try {
    if (req.user.role !== 'job_seeker') {
      return res.status(403).json({ success: false, message: 'Chỉ job seeker mới có profile.' });
    }

    const profile = await SeekerProfile.findByPk(req.user.id);

    if (!profile) {
      return res.status(404).json({ 
        success: false, 
        message: 'Chưa có profile. Vui lòng tạo profile.' 
      });
    }

    res.json({ success: true, data: profile });
  } catch (error) {
    console.error('Error fetching profile:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi lấy thông tin profile.', error: error.message });
  }
});

// @route   POST /api/seeker-profiles
// @desc    Create seeker profile
// @access  Private (Job Seeker)
router.post('/', authenticate, async (req, res) => {
  try {
    if (req.user.role !== 'job_seeker') {
      return res.status(403).json({ success: false, message: 'Chỉ job seeker mới có thể tạo profile.' });
    }

    // Check if profile already exists
    const existingProfile = await SeekerProfile.findByPk(req.user.id);
    if (existingProfile) {
      return res.status(400).json({ 
        success: false, 
        message: 'Profile đã tồn tại. Sử dụng PUT để cập nhật.' 
      });
    }

    const { full_name, phone, avatar_url, occupation, resume_url, address, dob } = req.body;

    if (!full_name) {
      return res.status(400).json({ success: false, message: 'full_name là bắt buộc.' });
    }

    const profile = await SeekerProfile.create({
      user_id: req.user.id,
      full_name,
      phone,
      avatar_url,
      occupation,
      resume_url,
      address,
      dob,
    });

    res.status(201).json({
      success: true,
      message: 'Tạo profile thành công!',
      data: profile,
    });
  } catch (error) {
    console.error('Error creating profile:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi tạo profile.', error: error.message });
  }
});

// @route   PUT /api/seeker-profiles/me
// @desc    Update my seeker profile
// @access  Private (Job Seeker)
router.put('/me', authenticate, async (req, res) => {
  try {
    if (req.user.role !== 'job_seeker') {
      return res.status(403).json({ success: false, message: 'Chỉ job seeker mới có thể cập nhật profile.' });
    }

    let profile = await SeekerProfile.findByPk(req.user.id);

    // If profile doesn't exist, create it
    if (!profile) {
      const { full_name, phone, avatar_url, occupation, resume_url, address, dob } = req.body;
      
      if (!full_name) {
        return res.status(400).json({ success: false, message: 'full_name là bắt buộc.' });
      }

      profile = await SeekerProfile.create({
        user_id: req.user.id,
        full_name,
        phone,
        avatar_url,
        occupation,
        resume_url,
        address,
        dob,
      });

      return res.status(201).json({
        success: true,
        message: 'Tạo profile thành công!',
        data: profile,
      });
    }

    // Update existing profile
    const { full_name, phone, avatar_url, occupation, resume_url, address, dob } = req.body;

    await profile.update({
      full_name: full_name || profile.full_name,
      phone: phone !== undefined ? phone : profile.phone,
      avatar_url: avatar_url !== undefined ? avatar_url : profile.avatar_url,
      occupation: occupation !== undefined ? occupation : profile.occupation,
      resume_url: resume_url !== undefined ? resume_url : profile.resume_url,
      address: address !== undefined ? address : profile.address,
      dob: dob !== undefined ? dob : profile.dob,
    });

    res.json({
      success: true,
      message: 'Cập nhật profile thành công!',
      data: profile,
    });
  } catch (error) {
    console.error('Error updating profile:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi cập nhật profile.', error: error.message });
  }
});

// @route   GET /api/seeker-profiles/:user_id
// @desc    Get seeker profile by user_id (public info)
// @access  Public (for recruiters to view applicants)
router.get('/:user_id', async (req, res) => {
  try {
    const profile = await SeekerProfile.findByPk(req.params.user_id);

    if (!profile) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy profile.' });
    }

    // Return public info only
    const publicProfile = {
      full_name: profile.full_name,
      occupation: profile.occupation,
      avatar_url: profile.avatar_url,
    };

    res.json({ success: true, data: publicProfile });
  } catch (error) {
    console.error('Error fetching profile:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi lấy thông tin profile.', error: error.message });
  }
});

module.exports = router;
