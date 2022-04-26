'use strict';
import passport from 'passport';
import Strategy from 'passport-local';
import { Strategy as JWTStrategy, ExtractJwt } from 'passport-jwt';
import bcrypt from 'bcrypt';
import User from '../models/user';
import jwt from 'jsonwebtoken';

passport.use('local',
    new Strategy({},async (username, password, done) => {
        console.log('LocalStrategy', username, password);
        const user = await User.findOne({ username });
        // if user is undefined
        if (!user) {
            return done(null, false, 'user not found');
        }
        // if passwords don't match
        if (!await bcrypt.compare(password, user.password)) {
            return done(null, false, 'password incorrect');
        }
        // see https://www.collectionsjs.com/method/to-object
        const userObj = user.toObject();
        // generate token
        const token = jwt.sign(userObj, process.env.TOKEN_SECRET);

        const strippedUser = {...userObj, token, id: user._id};

        delete strippedUser.password;
        return done(null, strippedUser);
    })
);

passport.use('jwt', new JWTStrategy(
        {
            jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
            secretOrKey: 'lzenfinze18bjsz'
        },
        (payload, done) => {
            done(null, payload);
        }
    )
);

export default passport;
