import express from 'express';
import { ApolloServer } from 'apollo-server-express';
import typeDefs from './schemas/index';
import resolvers from './resolvers/index';
import dotenv from 'dotenv';
import db from './utils/db';
import pass from './utils/pass';
import helmet from 'helmet';
import {checkAuth} from './utils/auth';
import cors from 'cors';
const port = process.env.PORT || 3000;

(async () => {
    try {
        const server = new ApolloServer({
            typeDefs,
            resolvers,
            context: async ({ req }) => {
                if (req) {
                    const user = await checkAuth(req);
                    return { user, req };
                }
            },

        });

        const app = express();
        app.use(express.static('public-flutter'));
        app.use(cors());
        app.options('*', cors());
        app.use(
            helmet({
                contentSecurityPolicy: false,
                crossOriginEmbedderPolicy: false,
            })
        );
        await server.start();

        server.applyMiddleware({ app });

        db.on('connected', () => {
            console.log('DB connected successfully');
        }).on('error', (err) => {
            console.log('Error while connecting to database ', err.message);
        });
        app.listen({ port: port }, () =>
            console.log(
                `🚀 Server ready at http://localhost:3000${server.graphqlPath}`
            )
        );


    } catch (e) {
        console.log('server error: ' + e.message);
    }
})();

///'use strict';
//
// require('dotenv').config();
// const express = require('express');
// const app = express();
//
// app.enable('trust proxy');
//
// // Add a handler to inspect the req.secure flag (see
// // http://expressjs.com/api#req.secure). This allows us
// // to know whether the request was via http or https.
// // https://github.com/aerwin/https-redirect-demo/blob/master/server.js
// app.use ((req, res, next) => {
//   if (req.secure) {
//     // request was via https, so do no special handling
//     next();
//   } else {
//     // if express app run under proxy with sub path URL
//     // e.g. http://www.myserver.com/app/
//     // then, in your .env, set PROXY_PASS=/app
//     // Adapt to your proxy settings!
//     const proxypath = process.env.PROXY_PASS || ''
//     // request was via http, so redirect to https
//     res.redirect(301, `https://${req.headers.host}${proxypath}${req.url}`);
//   }
// });
//
// app.listen(3000);