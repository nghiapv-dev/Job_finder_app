const { sequelize, Sequelize } = require('../config/database');

// Import models
const User = require('./User')(sequelize);
const Job = require('./Job')(sequelize);

// Define associations
Job.belongsTo(User, {
  foreignKey: 'employerId',
  as: 'employer',
});

User.hasMany(Job, {
  foreignKey: 'employerId',
  as: 'postedJobs',
});

// Test database connection
sequelize
  .authenticate()
  .then(() => {
    console.log('✅ Database connection established successfully.');
  })
  .catch((err) => {
    console.error('❌ Unable to connect to the database:', err);
  });

// Sync models (only in development)
// Uncomment this to auto-create tables (WARNING: will drop existing data if force:true)
// if (process.env.NODE_ENV === 'development') {
//   sequelize.sync({ force: false, alter: false }).then(() => {
//     console.log('✅ Database models synchronized.');
//   });
// }

module.exports = {
  sequelize,
  Sequelize,
  User,
  Job,
};
