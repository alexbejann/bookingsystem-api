'use strict';
import https from 'https';
import http from 'http';
import fs from 'fs';
import dotenv from 'dotenv';
dotenv.config();
const httpsPort = process.env.HTTPS_PORT || 8000;

const sslkey = fs.readFileSync('ssl-key.pem');
const sslcert = fs.readFileSync('ssl-cert.pem');

const options = {
    key: sslkey,
    cert: sslcert,
};

export default (app, port, server) => {
    https.createServer(options, app).listen(httpsPort, () => {
        console.log(
            `🚀 Server ready in development at https://localhost:${httpsPort}${server.graphqlPath}`
        );
    });

    http.createServer((req, res) => {
        res.writeHead(301, {
            Location: `https://localhost:${httpsPort}` + req.url,
        });
        res.end();
    }).listen(port);
};
