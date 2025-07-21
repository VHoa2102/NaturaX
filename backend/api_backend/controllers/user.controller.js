const {UserService, ProfileModel}  = require('../services/user.service');

exports.register = async (req, res, next) => {
    try {
        const { email, phonenumber, password } = req.body;
        const successRes = await UserService.registerUser(email, phonenumber, password);
        res.json({status:true, message: 'User registered successfully'});
    } catch (err) {
        throw err;
    }
}

exports.login = async (req, res, next) => {
    try {
        const { email, phonenumber, password } = req.body;
        const user = await UserService.checkUser(email, phonenumber);
        console.log(user);
        if (!user) {
            return res.status(401).json({ status: false, message: 'User not found' });
        }
        // Assuming you have a method to compare passwords
        const isMatch = await user.comparePassword(password);
        if (!isMatch) {
            return res.status(401).json({ status: false, message: 'Invalid password' });
        }

        let tokenData = {
            _id: user._id,
            email: user.email,
            phonenumber: user.phonenumber
        };

        const token = await UserService.generateToken(tokenData, process.env.JWT_SECRET, process.env.JWT_EXPIRE);

        res.status(200).json({status: true, token: token});
    } catch (err) {
        next(err);
    }
}

exports.createProfile = async (req, res, next) => {
    try {
        const { fullName, bio, address } = req.body;
        const userId = req.user._id; // Lấy từ middleware auth

        const existingProfile = await ProfileModel.findOne({ userId });
        if (existingProfile) {
            return res.status(400).json({ status: false, message: 'Profile already exists' });
        }

        const profile = new ProfileModel({
            userId,
            fullName,
            bio,
            address
        });

        await profile.save();
        res.status(201).json({ status: true, message: 'Profile created successfully', profile });
    } catch (err) {
        next(err);
    }
};

exports.getMyProfile = async (req, res, next) => {
    try {
        const userId = req.user._id;
        const profile = await ProfileModel.findOne({ userId }).populate('userId', 'email phonenumber');
        
        if (!profile) {
            return res.status(404).json({ status: false, message: 'Profile not found' });
        }

        res.json({ status: true, profile });
    } catch (err) {
        next(err);
    }
};

exports.updateProfile = async (req, res, next) => {
    try {
        const userId = req.user._id;
        const updates = req.body;

        const profile = await ProfileModel.findOneAndUpdate(
            { userId }, 
            updates, 
            { new: true }
        );

        if (!profile) {
            return res.status(404).json({ status: false, message: 'Profile not found' });
        }

        res.json({ status: true, message: 'Profile updated successfully', profile });
    } catch (err) {
        next(err);
    }
};
