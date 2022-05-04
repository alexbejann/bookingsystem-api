'use strict';
import mongoose from 'mongoose';
import organization from './organization';
import role from './role';

const Schema = mongoose.Schema;
/*
    {
        username: "Alex",
        password: "test123",
        admin: true,
        roles:
        organizationID: "4314132fewfwf23"
    }
 */
const userSchema = new Schema({
    username: {type: String, unique: true},
    password: {type: String, required: true},
    admin: {type: Boolean, default: false},
    role: { type: mongoose.Types.ObjectId, ref: role, default: undefined },
    organizationID: {type: mongoose.Types.ObjectId, ref: organization, required: true},
});

export default mongoose.model('User', userSchema);
