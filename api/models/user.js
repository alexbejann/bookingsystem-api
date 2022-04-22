'use strict';
import mongoose from 'mongoose';
import organization from './organization';

const Schema = mongoose.Schema;
/*
    {
        username: "Alex",
        password: "test123",
        admin: true,
        organizationID: "4314132fewfwf23"
    }
 */
const userSchema = new Schema({
    username: {type: String, unique: true},
    password: {type: String, required: true},
    admin: {type: Boolean, default: false},
    organizationID: {type: mongoose.Types.ObjectId, ref: organization, required: true},
});

export default mongoose.model('User', userSchema);
