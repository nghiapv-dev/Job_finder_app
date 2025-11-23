const express = require('express');
const router = express.Router();
const { authenticate } = require('../middleware/auth');
const { SavedJob, Job, Company } = require('../models');

// @route   GET /api/saved-jobs
// @desc    Get my saved jobs
// @access  Private (Job Seeker)
router.get('/', authenticate, async (req, res) => {
  try {
    const savedJobs = await SavedJob.findAll({
      where: { user_id: req.user.id },
      include: [{
        model: Job,
        as: 'job',
        include: [{
          model: Company,
          as: 'company',
          attributes: ['id', 'name', 'logo_url'],
        }],
      }],
      order: [['saved_at', 'DESC']],
    });

    res.json({ success: true, data: savedJobs });
  } catch (error) {
    console.error('Error fetching saved jobs:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi lấy danh sách công việc đã lưu.', error: error.message });
  }
});

// @route   POST /api/saved-jobs
// @desc    Save a job
// @access  Private
router.post('/', authenticate, async (req, res) => {
  try {
    const { job_id, note } = req.body;

    if (!job_id) {
      return res.status(400).json({ success: false, message: 'job_id là bắt buộc.' });
    }

    // Check if job exists
    const job = await Job.findByPk(job_id);
    if (!job) {
      return res.status(404).json({ success: false, message: 'Công việc không tồn tại.' });
    }

    // Check if already saved
    const existingSave = await SavedJob.findOne({
      where: { user_id: req.user.id, job_id },
    });

    if (existingSave) {
      return res.status(400).json({ success: false, message: 'Công việc đã được lưu rồi.' });
    }

    const savedJob = await SavedJob.create({
      user_id: req.user.id,
      job_id,
      note,
    });

    const savedJobWithDetails = await SavedJob.findByPk(savedJob.id, {
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
      message: 'Lưu công việc thành công!',
      data: savedJobWithDetails,
    });
  } catch (error) {
    console.error('Error saving job:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi lưu công việc.', error: error.message });
  }
});

// @route   DELETE /api/saved-jobs/:id
// @desc    Remove saved job
// @access  Private (Owner)
router.delete('/:id', authenticate, async (req, res) => {
  try {
    const savedJob = await SavedJob.findByPk(req.params.id);

    if (!savedJob) {
      return res.status(404).json({ success: false, message: 'Không tìm thấy công việc đã lưu.' });
    }

    if (savedJob.user_id !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Bạn không có quyền xóa.' });
    }

    await savedJob.destroy();

    res.json({ success: true, message: 'Xóa công việc đã lưu thành công!' });
  } catch (error) {
    console.error('Error deleting saved job:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi xóa công việc đã lưu.', error: error.message });
  }
});

// @route   DELETE /api/saved-jobs/job/:job_id
// @desc    Unsave job by job_id
// @access  Private
router.delete('/job/:job_id', authenticate, async (req, res) => {
  try {
    const savedJob = await SavedJob.findOne({
      where: {
        user_id: req.user.id,
        job_id: req.params.job_id,
      },
    });

    if (!savedJob) {
      return res.status(404).json({ success: false, message: 'Công việc chưa được lưu.' });
    }

    await savedJob.destroy();

    res.json({ success: true, message: 'Bỏ lưu công việc thành công!' });
  } catch (error) {
    console.error('Error unsaving job:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi bỏ lưu công việc.', error: error.message });
  }
});

// @route   GET /api/saved-jobs/check/:job_id
// @desc    Check if job is saved
// @access  Private
router.get('/check/:job_id', authenticate, async (req, res) => {
  try {
    const savedJob = await SavedJob.findOne({
      where: {
        user_id: req.user.id,
        job_id: req.params.job_id,
      },
    });

    res.json({ 
      success: true, 
      data: { 
        isSaved: !!savedJob,
        savedJobId: savedJob ? savedJob.id : null,
      },
    });
  } catch (error) {
    console.error('Error checking saved job:', error);
    res.status(500).json({ success: false, message: 'Lỗi khi kiểm tra công việc đã lưu.', error: error.message });
  }
});

module.exports = router;
