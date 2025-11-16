const express = require('express');
const router = express.Router();

/**
 * @route   GET /api/categories
 * @desc    Get all categories
 * @access  Public
 */
router.get('/', async (req, res) => {
  res.status(501).json({
    success: false,
    message: 'Get categories not yet implemented',
  });
});

module.exports = router;
