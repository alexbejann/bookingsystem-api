import express from 'express';
import { ApolloServer } from 'apollo-server-express';
import typeDefs from './schemas/index';
import resolvers from './resolvers/index';
import dotenv from 'dotenv';
import connectMongo from './utils/db';
import User from './models/user';
import {buildContext} from 'graphql-passport';
import pass from './utils/pass';
import helmet from 'helmet';

dotenv.config();

(async () => {
    try {
        const conn = await connectMongo();
        if (conn) {
            console.log('Connected successfully.');
        } else {
            throw new Error('db not connected');
        }

        const server = new ApolloServer({
            typeDefs,
            resolvers,
            context: ({ req, res }) => buildContext({ req, res, User })
        });

        const app = express();
        app.use(helmet());
        app.use(pass.initialize());
        await server.start();

        server.applyMiddleware({ app });

        app.listen({ port: process.env.PORT || 3000 }, () =>
            console.log(
                `🚀 Server ready at http://localhost:3000${server.graphqlPath}`
            )
        );
    } catch (e) {
        console.log('server error: ' + e.message);
    }
})();
