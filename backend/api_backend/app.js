const express = require('express');
const body_parser = require('body-parser');
const userRouter = require('./routers/user.router');

const app = express();

app.use(express.json());

app.use('/api', userRouter);

module.exports = app;