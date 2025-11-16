const express = require('express');
const router = express.Router();
const { authenticate } = require('../middlewares/auth');

/**
 * @route   GET /api/applications
 * @desc    Get user's applications
 * @access  Private
 */
router.get('/', authenticate, async (req, res) => {
  res.status(501).json({
    success: false,
    message: 'Get applications not yet implemented',
  });
});

/**
 * @route   POST /api/applications
 * @desc    Apply for a job
 * @access  Private
 */
router.post('/', authenticate, async (req, res) => {
  res.status(501).json({
    success: false,
    message: 'Apply for job not yet implemented',
  });
});

module.exports = router;
