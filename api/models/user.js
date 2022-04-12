'use strict';
import mongoose from 'mongoose';

const Schema = mongoose.Schema;

const userSchema = new Schema({
    username: {type: String, unique: true},
    password: {type: String, required: true},
    admin: {type: Boolean, default: false},
    /// TODO add organization for multi tenant
    ///organization: {type: String}
});

export default mongoose.model('User', userSchema);
