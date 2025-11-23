const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { Company } = require('../models');

// @route   GET /api/companies
// @desc    Get all companies (public)
// @access  Public
router.get('/', async (req, res) => {
  try {
    const { page = 1, limit = 10, industry } = req.query;
    const offset = (page - 1) * limit;

    const where = {};
    if (industry) {
      where.industry = industry;
    }

    const { count, rows: companies } = await Company.findAndCountAll({
      where,
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [['id', 'DESC']],
    });

    res.json({
      success: true,
      data: {
        companies,
        pagination: {
          total: count,
          page: parseInt(page),
          limit: parseInt(limit),
          totalPages: Math.ceil(count / limit),
        },
      },
    });
  } catch (error) {
    console.error('Error fetching companies:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi lấy danh sách công ty.', error: error.message });
  }
});

// @route   GET /api/companies/:id
// @desc    Get company by ID
// @access  Public
router.get('/:id', async (req, res) => {
  try {
    const company = await Company.findByPk(req.params.id, {
      include: [{
        association: 'jobs',
        where: { status: 'active' },
        required: false,
      }],
    });

    if (!company) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy công ty.' });
    }

    res.json({ success: true, data: company });
  } catch (error) {
    console.error('Error fetching company:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi lấy thông tin công ty.', error: error.message });
  }
});

// @route   POST /api/companies
// @desc    Create new company (Recruiter only)
// @access  Private (Recruiter)
router.post('/', authenticate, async (req, res) => {
  try {
    if (req.user.role !== 'recruiter') {
      return res.status(403).json({ success: false, message: 'Chỉ recruiter mới có thể tạo công ty.' });
    }

    const { name, logo_url, industry, size, address, website, description } = req.body;

    if (!name) {
      return res.status(400).json({ success: false, message: 'Tên công ty là bắt buộc.' });
    }

    const company = await Company.create({
      recruiter_id: req.user.id,
      name,
      logo_url,
      industry,
      size,
      address,
      website,
      description,
    });

    res.status(201).json({
      success: true,
      message: 'Tạo công ty thành công!',
      data: company,
    });
  } catch (error) {
    console.error('Error creating company:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi tạo công ty.', error: error.message });
  }
});

// @route   PUT /api/companies/:id
// @desc    Update company (Owner only)
// @access  Private (Recruiter - Owner)
router.put('/:id', authenticate, async (req, res) => {
  try {
    const company = await Company.findByPk(req.params.id);

    if (!company) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy công ty.' });
    }

    // Check if user is the owner
    if (company.recruiter_id !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Bạn không có quyền chỉnh sửa công ty này.' });
    }

    const { name, logo_url, industry, size, address, website, description } = req.body;

    await company.update({
      name: name || company.name,
      logo_url: logo_url !== undefined ? logo_url : company.logo_url,
      industry: industry !== undefined ? industry : company.industry,
      size: size !== undefined ? size : company.size,
      address: address !== undefined ? address : company.address,
      website: website !== undefined ? website : company.website,
      description: description !== undefined ? description : company.description,
    });

    res.json({
      success: true,
      message: 'Cập nhật công ty thành công!',
      data: company,
    });
  } catch (error) {
    console.error('Error updating company:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi cập nhật công ty.', error: error.message });
  }
});

// @route   DELETE /api/companies/:id
// @desc    Delete company (Owner only)
// @access  Private (Recruiter - Owner)
router.delete('/:id', authenticate, async (req, res) => {
  try {
    const company = await Company.findByPk(req.params.id);

    if (!company) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy công ty.' });
    }

    if (company.recruiter_id !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Bạn không có quyền xóa công ty này.' });
    }

    await company.destroy();

    res.json({ success: true, message: 'Xóa công ty thành công!' });
  } catch (error) {
    console.error('Error deleting company:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi xóa công ty.', error: error.message });
  }
});

// @route   GET /api/companies/my/list
// @desc    Get companies of current recruiter
// @access  Private (Recruiter)
router.get('/my/list', authenticate, async (req, res) => {
  try {
    if (req.user.role !== 'recruiter') {
      return res.status(403).json({ success: false, message: 'Chỉ recruiter mới có thể xem danh sách công ty của mình.' });
    }

    const companies = await Company.findAll({
      where: { recruiter_id: req.user.id },
      order: [['id', 'DESC']],
    });

    res.json({ success: true, data: companies });
  } catch (error) {
    console.error('Error fetching my companies:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi lấy danh sách công ty.', error: error.message });
  }
});

module.exports = router;
