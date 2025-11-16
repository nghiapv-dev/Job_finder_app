const express = require('express');
const router = express.Router();

/**
 * @route   GET /api/companies
 * @desc    Get all companies
 * @access  Public
 */
router.get('/', async (req, res) => {
  res.status(501).json({
    success: false,
    message: 'Get companies not yet implemented',
  });
});

/**
 * @route   GET /api/companies/:id
 * @desc    Get company details
 * @access  Public
 */
router.get('/:id', async (req, res) => {
  res.status(501).json({
    success: false,
    message: 'Get company details not yet implemented',
  });
});

module.exports = router;
