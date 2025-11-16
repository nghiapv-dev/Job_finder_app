const express = require('express');
const router = express.Router();
const { authenticate } = require('../middlewares/auth');

/**
 * @route   GET /api/users/me
 * @desc    Get current user profile
 * @access  Private
 */
router.get('/me', authenticate, async (req, res) => {
  try {
    res.status(200).json({
      success: true,
      data: req.user.toJSON(),
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
    });
  }
});

/**
 * @route   PUT /api/users/me
 * @desc    Update user profile
 * @access  Private
 */
router.put('/me', authenticate, async (req, res) => {
  res.status(501).json({
    success: false,
    message: 'Update profile not yet implemented',
  });
});

/**
 * @route   PUT /api/users/me/password
 * @desc    Change password
 * @access  Private
 */
router.put('/me/password', authenticate, async (req, res) => {
  res.status(501).json({
    success: false,
    message: 'Change password not yet implemented',
  });
});

/**
 * @route   POST /api/users/me/avatar
 * @desc    Upload avatar
 * @access  Private
 */
router.post('/me/avatar', authenticate, async (req, res) => {
  res.status(501).json({
    success: false,
    message: 'Upload avatar not yet implemented',
  });
});

module.exports = router;
