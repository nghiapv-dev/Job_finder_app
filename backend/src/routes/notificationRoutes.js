const express = require('express');
const router = express.Router();
const { authenticate } = require('../middlewares/auth');

/**
 * @route   GET /api/notifications
 * @desc    Get user's notifications
 * @access  Private
 */
router.get('/', authenticate, async (req, res) => {
  res.status(501).json({
    success: false,
    message: 'Get notifications not yet implemented',
  });
});

module.exports = router;
