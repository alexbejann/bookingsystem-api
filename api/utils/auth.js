'use strict';
import dotenv from 'dotenv';
import passport from './pass';
import jwt from 'jsonwebtoken';
import {AuthenticationError} from "apollo-server-express";
import Role from '../models/role';

dotenv.config();

const checkAuth = (req) => {
    return new Promise((resolve) => {
        passport.authenticate('jwt', {session: false}, (err, user) => {
            if (err || !user) {
                resolve(false);
            }
            resolve(user);
        })(req);
    });
};

const login = (req) => {
    return new Promise((resolve, reject) => {
        passport.authenticate('local', {session: false}, (err, user, info) => {
            if (err || !user) {
                reject(info.message);
            }
            req.login(user, {session: false}, (err) => {
                if (err) {
                    reject(err);
                }
                // generate a signed son web token with the contents of user object and return it in the response
                const token = jwt.sign(user, process.env.TOKEN_SECRET);
                resolve({...user, token, id: user._id, admin: user.admin, role: user.role});
            });
        })(req);
    });
};

const checkPermission = async (user, requestedRole) => {
    if (!user) {
        throw new AuthenticationError('Not authenticated');
    }
    if (requestedRole === undefined) {
        return true;
    }
    const role = await Role.findOne({_id: user.role});
    if (role.name !== requestedRole) {
        throw new AuthenticationError('You do not have permission for this action!')
    }
    return true;
};

export {
    checkAuth,
    login,
    checkPermission
};
