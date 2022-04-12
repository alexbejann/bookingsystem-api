'use strict';
import bcrypt from 'bcrypt';
import User from '../models/user';
import {login} from '../utils/auth';
import {AuthenticationError} from 'apollo-server-express';

export default {
    Query: {
        user: async (parent, args, {user}) => {
            if (!user) {
                throw new AuthenticationError('Invalid credentials');
            }
            return User.findById(args.id);
        },
        login: async (parent, args, {req}) => {
            req.body = args;
            return await login(req);
        },
    },
    Mutation: {
        registerUser: async (parent, args) => {
            try {
                const hash = await bcrypt.hash(args.password, 10);
                const userWithHash = {
                    ...args,
                    password: hash,
                };
                const newUser = new User(userWithHash);
                return await newUser.save();
            } catch (err) {
                throw new Error(err);
            }
        },
    },
};
