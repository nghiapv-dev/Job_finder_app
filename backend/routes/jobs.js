const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { Job, Company, Application } = require('../models');
const { Op } = require('sequelize');

// @route   GET /api/jobs
// @desc    Get all active jobs (with filters)
// @access  Public
router.get('/', async (req, res) => {
  try {
    const { 
      page = 1, 
      limit = 10, 
      job_type, 
      location, 
      search,
      company_id,
    } = req.query;
    
    const offset = (page - 1) * limit;

    const where = { status: 'active' };
    
    if (job_type) {
      where.job_type = job_type;
    }
    
    if (location) {
      where.location = { [Op.iLike]: `%${location}%` };
    }
    
    if (search) {
      where[Op.or] = [
        { title: { [Op.iLike]: `%${search}%` } },
        { description: { [Op.iLike]: `%${search}%` } },
      ];
    }

    if (company_id) {
      where.company_id = company_id;
    }

    const { count, rows: jobs } = await Job.findAndCountAll({
      where,
      include: [{
        model: Company,
        as: 'company',
        attributes: ['id', 'name', 'logo_url', 'industry'],
      }],
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [['posted_at', 'DESC']],
    });

    res.json({
      success: true,
      data: {
        jobs,
        pagination: {
          total: count,
          page: parseInt(page),
          limit: parseInt(limit),
          totalPages: Math.ceil(count / limit),
        },
      },
    });
  } catch (error) {
    console.error('Error fetching jobs:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi lấy danh sách công việc.', error: error.message });
  }
});

// @route   GET /api/jobs/:id
// @desc    Get job by ID with details
// @access  Public
router.get('/:id', async (req, res) => {
  try {
    const job = await Job.findByPk(req.params.id, {
      include: [{
        model: Company,
        as: 'company',
      }],
    });

    if (!job) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy công việc.' });
    }

    res.json({ success: true, data: job });
  } catch (error) {
    console.error('Error fetching job:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi lấy thông tin công việc.', error: error.message });
  }
});

// @route   POST /api/jobs
// @desc    Create new job (Recruiter only)
// @access  Private (Recruiter)
router.post('/', authenticate, async (req, res) => {
  try {
    if (req.user.role !== 'recruiter') {
      return res.status(403).json({ success: false, message: 'Chỉ recruiter mới có thể đăng tin tuyển dụng.' });
    }

    const { 
      company_id, 
      title, 
      job_type, 
      salary_min, 
      salary_max, 
      location, 
      description, 
      requirements,
      status = 'active',
    } = req.body;

    if (!company_id || !title || !job_type) {
      return res.status(400).json({ 
        success: false, 
        message: 'company_id, title và job_type là bắt buộc.' 
      });
    }

    // Verify company belongs to recruiter
    const company = await Company.findOne({
      where: { 
        id: company_id,
        recruiter_id: req.user.id,
      },
    });

    if (!company) {
      return res.status(403).json({ 
        success: false, 
        message: 'Công ty không tồn tại hoặc bạn không có quyền đăng tin cho công ty này.' 
      });
    }

    const job = await Job.create({
      company_id,
      title,
      job_type,
      salary_min,
      salary_max,
      location,
      description,
      requirements,
      status,
    });

    const jobWithCompany = await Job.findByPk(job.id, {
      include: [{ model: Company, as: 'company' }],
    });

    res.status(201).json({
      success: true,
      message: 'Đăng tin tuyển dụng thành công!',
      data: jobWithCompany,
    });
  } catch (error) {
    console.error('Error creating job:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi đăng tin tuyển dụng.', error: error.message });
  }
});

// @route   PUT /api/jobs/:id
// @desc    Update job (Company owner only)
// @access  Private (Recruiter)
router.put('/:id', authenticate, async (req, res) => {
  try {
    const job = await Job.findByPk(req.params.id, {
      include: [{ model: Company, as: 'company' }],
    });

    if (!job) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy công việc.' });
    }

    // Check if user owns the company
    if (job.company.recruiter_id !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Bạn không có quyền chỉnh sửa công việc này.' });
    }

    const { 
      title, 
      job_type, 
      salary_min, 
      salary_max, 
      location, 
      description, 
      requirements,
      status,
    } = req.body;

    await job.update({
      title: title || job.title,
      job_type: job_type || job.job_type,
      salary_min: salary_min !== undefined ? salary_min : job.salary_min,
      salary_max: salary_max !== undefined ? salary_max : job.salary_max,
      location: location !== undefined ? location : job.location,
      description: description !== undefined ? description : job.description,
      requirements: requirements !== undefined ? requirements : job.requirements,
      status: status || job.status,
    });

    const updatedJob = await Job.findByPk(job.id, {
      include: [{ model: Company, as: 'company' }],
    });

    res.json({
      success: true,
      message: 'Cập nhật công việc thành công!',
      data: updatedJob,
    });
  } catch (error) {
    console.error('Error updating job:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi cập nhật công việc.', error: error.message });
  }
});

// @route   DELETE /api/jobs/:id
// @desc    Delete job (Company owner only)
// @access  Private (Recruiter)
router.delete('/:id', authenticate, async (req, res) => {
  try {
    const job = await Job.findByPk(req.params.id, {
      include: [{ model: Company, as: 'company' }],
    });

    if (!job) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy công việc.' });
    }

    if (job.company.recruiter_id !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Bạn không có quyền xóa công việc này.' });
    }

    await job.destroy();

    res.json({ success: true, message: 'Xóa công việc thành công!' });
  } catch (error) {
    console.error('Error deleting job:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi xóa công việc.', error: error.message });
  }
});

// @route   GET /api/jobs/:id/applications
// @desc    Get applications for a job (Recruiter only)
// @access  Private (Recruiter - Job owner)
router.get('/:id/applications', authenticate, async (req, res) => {
  try {
    const job = await Job.findByPk(req.params.id, {
      include: [{ model: Company, as: 'company' }],
    });

    if (!job) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy công việc.' });
    }

    if (job.company.recruiter_id !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Bạn không có quyền xem đơn ứng tuyển này.' });
    }

    const applications = await Application.findAll({
      where: { job_id: job.id },
      include: [{
        association: 'seeker',
        attributes: ['id', 'email', 'role'],
        include: [{
          association: 'seekerProfile',
          attributes: ['full_name', 'phone', 'avatar_url', 'occupation'],
        }],
      }],
      order: [['applied_at', 'DESC']],
    });

    res.json({ success: true, data: applications });
  } catch (error) {
    console.error('Error fetching applications:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi lấy danh sách đơn ứng tuyển.', error: error.message });
  }
});

module.exports = router;
