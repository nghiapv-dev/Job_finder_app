const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { Application, Job, Company } = require('../models');

// @route   GET /api/applications/my
// @desc    Get my applications (Job seeker)
// @access  Private (Job Seeker)
router.get('/my', authenticate, async (req, res) => {
  try {
    if (req.user.role !== 'job_seeker') {
      return res.status(403).json({ success: false, message: 'Chỉ job seeker mới có thể xem đơn ứng tuyển.' });
    }

    const applications = await Application.findAll({
      where: { seeker_id: req.user.id },
      include: [{
        model: Job,
        as: 'job',
        include: [{
          model: Company,
          as: 'company',
          attributes: ['id', 'name', 'logo_url'],
        }],
      }],
      order: [['applied_at', 'DESC']],
    });

    res.json({ success: true, data: applications });
  } catch (error) {
    console.error('Error fetching my applications:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi lấy danh sách đơn ứng tuyển.', error: error.message });
  }
});

// @route   GET /api/applications/:id
// @desc    Get application by ID
// @access  Private (Owner or Recruiter)
router.get('/:id', authenticate, async (req, res) => {
  try {
    const application = await Application.findByPk(req.params.id, {
      include: [
        {
          model: Job,
          as: 'job',
          include: [{
            model: Company,
            as: 'company',
          }],
        },
        {
          association: 'seeker',
          attributes: ['id', 'email'],
          include: [{
            association: 'seekerProfile',
          }],
        },
      ],
    });

    if (!application) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy đơn ứng tuyển.' });
    }

    // Check permission: seeker owns it OR recruiter owns the company
    const isOwner = application.seeker_id === req.user.id;
    const isRecruiter = application.job.company.recruiter_id === req.user.id;

    if (!isOwner && !isRecruiter) {
      return res.status(403).json({ success: false, message: 'Bạn không có quyền xem đơn ứng tuyển này.' });
    }

    res.json({ success: true, data: application });
  } catch (error) {
    console.error('Error fetching application:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi lấy thông tin đơn ứng tuyển.', error: error.message });
  }
});

// @route   POST /api/applications
// @desc    Apply for a job
// @access  Private (Job Seeker)
router.post('/', authenticate, async (req, res) => {
  try {
    if (req.user.role !== 'job_seeker') {
      return res.status(403).json({ success: false, message: 'Chỉ job seeker mới có thể ứng tuyển.' });
    }

    const { job_id, resume_snapshot_url, cover_letter } = req.body;

    if (!job_id) {
      return res.status(400).json({ success: false, message: 'job_id là bắt buộc.' });
    }

    // Check if job exists and is active
    const job = await Job.findOne({
      where: { id: job_id, status: 'active' },
    });

    if (!job) {
      return res.status(404).json({ success: false, message: 'Công việc không tồn tại hoặc đã đóng.' });
    }

    // Check if already applied
    const existingApplication = await Application.findOne({
      where: { 
        job_id, 
        seeker_id: req.user.id,
      },
    });

    if (existingApplication) {
      return res.status(400).json({ success: false, message: 'Bạn đã ứng tuyển vào công việc này rồi.' });
    }

    const application = await Application.create({
      job_id,
      seeker_id: req.user.id,
      resume_snapshot_url,
      cover_letter,
      status: 'applied',
    });

    const applicationWithDetails = await Application.findByPk(application.id, {
      include: [{
        model: Job,
        as: 'job',
        include: [{
          model: Company,
          as: 'company',
        }],
      }],
    });

    res.status(201).json({
      success: true,
      message: 'Ứng tuyển thành công!',
      data: applicationWithDetails,
    });
  } catch (error) {
    console.error('Error creating application:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi ứng tuyển.', error: error.message });
  }
});

// @route   PUT /api/applications/:id/status
// @desc    Update application status (Recruiter only)
// @access  Private (Recruiter)
router.put('/:id/status', authenticate, async (req, res) => {
  try {
    const { status } = req.body;

    if (!status || !['applied', 'interview', 'rejected', 'accepted'].includes(status)) {
      return res.status(400).json({ 
        success: false, 
        message: 'Status phải là: applied, interview, rejected, hoặc accepted.' 
      });
    }

    const application = await Application.findByPk(req.params.id, {
      include: [{
        model: Job,
        as: 'job',
        include: [{
          model: Company,
          as: 'company',
        }],
      }],
    });

    if (!application) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy đơn ứng tuyển.' });
    }

    // Check if recruiter owns the company
    if (application.job.company.recruiter_id !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Bạn không có quyền cập nhật đơn ứng tuyển này.' });
    }

    await application.update({ status });

    res.json({
      success: true,
      message: 'Cập nhật trạng thái thành công!',
      data: application,
    });
  } catch (error) {
    console.error('Error updating application status:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi cập nhật trạng thái.', error: error.message });
  }
});

// @route   DELETE /api/applications/:id
// @desc    Withdraw application (Seeker only)
// @access  Private (Job Seeker - Owner)
router.delete('/:id', authenticate, async (req, res) => {
  try {
    const application = await Application.findByPk(req.params.id);

    if (!application) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy đơn ứng tuyển.' });
    }

    if (application.seeker_id !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Bạn không có quyền rút đơn ứng tuyển này.' });
    }

    await application.destroy();

    res.json({ success: true, message: 'Rút đơn ứng tuyển thành công!' });
  } catch (error) {
    console.error('Error deleting application:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi rút đơn ứng tuyển.', error: error.message });
  }
});

module.exports = router;
