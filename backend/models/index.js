const User = require('./User');
const SeekerProfile = require('./SeekerProfile');
const Company = require('./Company');
const Job = require('./Job');
const Application = require('./JobApplication');
const SavedJob = require('./SavedJob');
const Interview = require('./Interview');
const Conversation = require('./Conversation');
const ConversationParticipant = require('./ConversationParticipant');
const Message = require('./Message');

// Define relationships

// User - SeekerProfile (One-to-One)
User.hasOne(SeekerProfile, { foreignKey: 'user_id', as: 'seekerProfile' });
SeekerProfile.belongsTo(User, { foreignKey: 'user_id', as: 'user' });

// User - Company (One-to-Many) - Recruiter manages companies
User.hasMany(Company, { foreignKey: 'recruiter_id', as: 'companies' });
Company.belongsTo(User, { foreignKey: 'recruiter_id', as: 'recruiter' });

// Company - Job (One-to-Many)
Company.hasMany(Job, { foreignKey: 'company_id', as: 'jobs' });
Job.belongsTo(Company, { foreignKey: 'company_id', as: 'company' });

// User - Application (One-to-Many) - Seeker applies to jobs
User.hasMany(Application, { foreignKey: 'seeker_id', as: 'applications' });
Application.belongsTo(User, { foreignKey: 'seeker_id', as: 'seeker' });

// Job - Application (One-to-Many)
Job.hasMany(Application, { foreignKey: 'job_id', as: 'applications' });
Application.belongsTo(Job, { foreignKey: 'job_id', as: 'job' });

// Application - Interview (One-to-Many)
Application.hasMany(Interview, { foreignKey: 'application_id', as: 'interviews' });
Interview.belongsTo(Application, { foreignKey: 'application_id', as: 'application' });

// User - SavedJob (One-to-Many)
User.hasMany(SavedJob, { foreignKey: 'user_id', as: 'savedJobs' });
SavedJob.belongsTo(User, { foreignKey: 'user_id', as: 'user' });

// Job - SavedJob (One-to-Many)
Job.hasMany(SavedJob, { foreignKey: 'job_id', as: 'savedBy' });
SavedJob.belongsTo(Job, { foreignKey: 'job_id', as: 'job' });

// Conversation - Message (One-to-Many)
Conversation.hasMany(Message, { foreignKey: 'conversation_id', as: 'messages' });
Message.belongsTo(Conversation, { foreignKey: 'conversation_id', as: 'conversation' });

// User - Message (sender)
User.hasMany(Message, { foreignKey: 'sender_id', as: 'sentMessages' });
Message.belongsTo(User, { foreignKey: 'sender_id', as: 'sender' });

// Người dùng - Cuộc trò chuyện (Nhiều-nhiều thông qua ConversationParticipant)
User.belongsToMany(Conversation, { 
  through: ConversationParticipant, 
  foreignKey: 'user_id',
  otherKey: 'conversation_id',
  as: 'conversations'
});
Conversation.belongsToMany(User, { 
  through: ConversationParticipant, 
  foreignKey: 'conversation_id',
  otherKey: 'user_id',
  as: 'participants'
});

module.exports = {
  User,
  SeekerProfile,
  Company,
  Job,
  Application,
  SavedJob,
  Interview,
  Conversation,
  ConversationParticipant,
  Message,
};
