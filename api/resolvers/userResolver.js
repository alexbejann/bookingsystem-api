'use strict';
import bcrypt from 'bcrypt';
import User from '../models/user';
import Organization from '../models/organization';
import {AuthenticationError} from 'apollo-server-express';
import {checkPermission, login} from '../utils/auth';

export default {
    Query: {
        user: async (parent, args, {user}) => {
            checkPermission(user, false);
            return User.findById(args.id);
        },
    },
    Mutation: {
        login: async (parent, args, {req}) => {
            req.body = args;
            try {
                return await login(req);
            } catch (e) {
                throw new AuthenticationError('Username or password invalid');
            }
        },
        registerUser: async (parent, args) => {
            try {
                console.log(parent, args);
                const foundOrg = await Organization.findById(args.organization);
                const hash = await bcrypt.hash(args.password, 10);
                const userWithHash = {
                    ...args,
                    organization: foundOrg,
                    password: hash,
                };
                const newUser = new User(userWithHash);
                return await newUser.save();
            } catch (err) {
                throw new Error(err);
            }
        },
        changePassword: async (parent, args, {user}) => {
            try {
                /// TODO do i want to keep this?
                checkPermission(user, true);
                console.log(parent, args);
                const hash = await bcrypt.hash(args.password, 10);
                return await User.findByIdAndUpdate(args.userID, {password: hash}, {new: true,});
            } catch (err) {
                throw new Error(err);
            }
        },
    },
};
