const jwt = require('jsonwebtoken');
const UserModel = require('../models/user.model');

const auth = async (req, res, next) => {
    try {
        const token = req.header('Authorization')?.replace('Bearer ', '');
        
        if (!token) {
            return res.status(401).json({ status: false, message: 'Access denied. No token provided.' });
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const user = await UserModel.findById(decoded._id);
        
        if (!user) {
            return res.status(401).json({ status: false, message: 'Invalid token.' });
        }

        req.user = user; // Gắn thông tin user vào request
        next();
    } catch (err) {
        res.status(401).json({ status: false, message: 'Invalid token.' });
    }
};

module.exports = auth;
