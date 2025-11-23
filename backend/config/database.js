require('dotenv').config();
const { Sequelize } = require('sequelize');

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    dialect: 'postgres',
    logging: false,
    pool: { max: 5, min: 0, acquire: 30000, idle: 10000 }
  }
);

const testConnection = async () => {
  try {
    await sequelize.authenticate();
    console.log('Kết nối database PostgreSQL thành công!');
  } catch (error) {
    console.error('Lỗi kết nối database:', error.message);
    process.exit(1);
  }
};

testConnection();

module.exports = sequelize;
