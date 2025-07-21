const {UserModel, ProfileModel} = require('../models/user.model');
const jwt = require('jsonwebtoken');

class UserService {
    static async registerUser(email, phonenumber, password) {
        try {
            const createUser = new UserModel({
                email,
                phonenumber,
                password,
            });
            return await createUser.save();
        } catch (err) {
            throw err;
        }
    }

    static async checkUser(email, phonenumber) {
        try {
            return await UserModel.findOne({
                $or: [
                    { email: email },
                    { phonenumber: phonenumber }
                ]
            });
        } catch (err) {
            throw err;
        }
    }

    static async generateToken(tokenData, secretKey, jwt_expire) {
        return jwt.sign(tokenData, secretKey, {expiresIn: jwt_expire});
    }
}

module.exports = {UserService, ProfileModel};