'use strict';
import mongoose from 'mongoose';
import organization from './organization';

const Schema = mongoose.Schema;

const userSchema = new Schema({
    username: {type: String, unique: true},
    password: {type: String, required: true},
    admin: {type: Boolean, default: false},
    organizationID: {type: mongoose.Types.ObjectId, ref: organization, required: true},
});

export default mongoose.model('User', userSchema);
