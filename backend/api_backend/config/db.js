const mongoose = require('mongoose');

const connection = mongoose.createConnection(process.env.MONGO_URI).on('open', () => {
  console.log('MongoDB connection successfully');
}).on('error', (err) => {
  console.error('MongoDB connection error:', err);
});

module.exports = connection;