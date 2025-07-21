require('dotenv').config();

const app = require('./app');
const db = require('./config/db');
const {UserModel, ProfileModel} = require('./models/user.model');

const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('Hello, Worldxzczcz!');
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Server is running on http://localhost:${port}`);
});

