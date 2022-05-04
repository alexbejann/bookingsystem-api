'use strict';
import bcrypt from 'bcrypt';
import User from '../models/user';
import Organization from '../models/organization';
import {AuthenticationError} from 'apollo-server-express';
import {checkPermission, login} from '../utils/auth';

export default {
    Query: {
        user: async (parent, args, {user}) => {
            await checkPermission(user);
            return User.findById(args.id);
        },
    },
    Mutation: {
        login: async (parent, args, {req}) => {
            req.body = args;
            try {
                const user = await login(req);
                console.log(user);
                return user;
            } catch (e) {
                throw new AuthenticationError('Username or password invalid');
            }
        },
        registerUser: async (parent, args, {user}) => {
            try {
                // TODo don't allow user to add users to other organizations
                await checkPermission(user, 'ORGANIZATION_ADMIN');
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
                // TODO don't allow user to change other users passwords
                await checkPermission(user, 'ROOT');
                console.log(parent, args);
                const hash = await bcrypt.hash(args.password, 10);
                return await User.findByIdAndUpdate(args.userID, {password: hash}, {new: true,});
            } catch (err) {
                throw new Error(err);
            }
        },
        changeUserRole: async (parent, args, {user}) => {
            try {
                // TODo don't allow user to change role of a ROOT user
                await checkPermission(user, 'ROOT');
                console.log(parent, args);
                return await User.findByIdAndUpdate(args.userID, {role: args.roleID}, {new: true,});
            } catch (err) {
                throw new Error(err);
            }
        },
    },
};
