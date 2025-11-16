const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Job = sequelize.define('Job', {
  id: {
    type: DataTypes.UUID,
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false
  },
  slug: {
    type: DataTypes.STRING,
    unique: true
  },
  company_id: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'companies',
      key: 'id'
    }
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  requirements: {
    type: DataTypes.ARRAY(DataTypes.TEXT),
    defaultValue: []
  },
  responsibilities: {
    type: DataTypes.ARRAY(DataTypes.TEXT),
    defaultValue: []
  },
  benefits: {
    type: DataTypes.ARRAY(DataTypes.STRING),
    defaultValue: []
  },
  category: {
    type: DataTypes.STRING,
    allowNull: false
  },
  job_type: {
    type: DataTypes.ENUM('full-time', 'part-time', 'contract', 'freelance', 'internship'),
    allowNull: false
  },
  work_mode: {
    type: DataTypes.ENUM('onsite', 'remote', 'hybrid'),
    allowNull: false
  },
  experience_level: {
    type: DataTypes.ENUM('entry', 'mid', 'senior', 'lead'),
    allowNull: false
  },
  education: {
    type: DataTypes.STRING,
    allowNull: true
  },
  salary_min: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: true
  },
  salary_max: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: true
  },
  salary_currency: {
    type: DataTypes.STRING,
    defaultValue: 'USD'
  },
  salary_period: {
    type: DataTypes.ENUM('hourly', 'monthly', 'yearly'),
    defaultValue: 'monthly'
  },
  location_address: {
    type: DataTypes.STRING,
    allowNull: true
  },
  location_city: {
    type: DataTypes.STRING,
    allowNull: false
  },
  location_country: {
    type: DataTypes.STRING,
    allowNull: false
  },
  location_lat: {
    type: DataTypes.DECIMAL(10, 8),
    allowNull: true
  },
  location_lng: {
    type: DataTypes.DECIMAL(11, 8),
    allowNull: true
  },
  skills: {
    type: DataTypes.ARRAY(DataTypes.STRING),
    defaultValue: []
  },
  number_of_positions: {
    type: DataTypes.INTEGER,
    defaultValue: 1
  },
  application_deadline: {
    type: DataTypes.DATE,
    allowNull: true
  },
  status: {
    type: DataTypes.ENUM('open', 'closed', 'draft'),
    defaultValue: 'open'
  },
  is_featured: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  is_urgent: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  view_count: {
    type: DataTypes.INTEGER,
    defaultValue: 0
  },
  application_count: {
    type: DataTypes.INTEGER,
    defaultValue: 0
  },
  posted_by: {
    type: DataTypes.UUID,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id'
    }
  }
}, {
  tableName: 'jobs',
  hooks: {
    beforeCreate: (job) => {
      if (!job.slug) {
        job.slug = job.title
          .toLowerCase()
          .replace(/[^a-z0-9]+/g, '-')
          .replace(/(^-|-$)/g, '') + 
          '-' + Math.random().toString(36).substring(2, 8);
      }
    }
  },
  indexes: [
    {
      fields: ['title']
    },
    {
      fields: ['category']
    },
    {
      fields: ['location_city', 'location_country']
    },
    {
      fields: ['status']
    },
    {
      fields: ['created_at']
    }
  ]
  });

  return Job;
};
