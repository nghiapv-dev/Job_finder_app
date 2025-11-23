const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const ConversationParticipant = sequelize.define('ConversationParticipant', {
  conversation_id: {
    type: DataTypes.BIGINT,
    primaryKey: true,
    references: {
      model: 'conversations',
      key: 'id',
    },
    onDelete: 'CASCADE',
  },
  user_id: {
    type: DataTypes.BIGINT,
    primaryKey: true,
    references: {
      model: 'users',
      key: 'id',
    },
    onDelete: 'CASCADE',
  },
}, {
  tableName: 'conversation_participants',
  timestamps: false,
  underscored: true,
});

module.exports = ConversationParticipant;
