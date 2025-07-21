const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const db = require('../config/db');

const { Schema } = mongoose;

const userSchema = new Schema({
  email: {
    type: String,
    lowercase: true,
    required: true,
    unique: true,
  },
  phonenumber: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  }, 
});

userSchema.pre('save', async function() {
  try {
    var user = this;
    const salt = await bcrypt.genSalt(10);
    const hashpass = await bcrypt.hash(user.password, salt);

    user.password = hashpass;

  } catch (err) {
    throw err;
  }
});

userSchema.methods.comparePassword = async function(userPassword) {
  try {
    const isMatch = await bcrypt.compare(userPassword, this.password);
    return isMatch;
  } catch (err) {
    throw err;
  }
};

const profileSchema = new Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
        required: true,
        unique: true
    },
    fullName: {
        type: String,
        lowercase: true,
        required: true
    },
    bio: {
        type: String,
        lowercase: true,
        default: ''
    },
    address: {
        type: String,
        lowercase: true,
        default: ''
    },
    createdAt: {
        type: Date,
        default: Date.now
    }
});


const ProfileModel = db.model('profile', profileSchema);
const UserModel = db.model('user', userSchema);

module.exports = {UserModel, ProfileModel};