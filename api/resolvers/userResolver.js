'use strict';
import bcrypt from 'bcrypt';
import User from '../models/user';
import Organization from "../models/organization";
import {AuthenticationError} from 'apollo-server-express';

export default {
    Query: {
        user: async (parent, args, {user}) => {
            if (!user) {
                throw new AuthenticationError('Invalid credentials');
            }
            return User.findById(args.id);
        },
        login: async (parent, {username, password}, context) => {
            const {user} = await context.authenticate("graphql-local", {
                username,
                password
            });
            if (!user) {
                throw new AuthenticationError('Invalid credentials');
            }

            return user;
        },
    },
    Mutation: {
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
    },
};
