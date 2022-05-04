'use strict';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
dotenv.config();
(() => {
    try {
        mongoose.connect(process.env.DB_URL, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
        });
    } catch (e) {
        console.error('Connection to db failed: ', e);
    }
})();

export default mongoose.connection;
