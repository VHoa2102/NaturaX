const router = require('express').Router();
const UserController = require('../controllers/user.controller');
const auth = require('../middleware/auth');

// Auth routes (không cần đăng nhập)
router.post('/register', UserController.register);
router.post('/login', UserController.login);

// Profile routes (cần đăng nhập)
router.post('/profile', auth, UserController.createProfile);
router.get('/profile', auth, UserController.getMyProfile);
router.put('/profile', auth, UserController.updateProfile);

module.exports = router;