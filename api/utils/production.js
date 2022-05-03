'use strict';
export default (app, port) => {
    app.enable('trust proxy');
    app.use((req, res, next) => {
        if (req.secure) {
            // request was via https, so do no special handling
            next();
        } else {
            // request was via http, so redirect to https
            res.redirect('https://' + req.headers.host + req.url);
        }
    });

    app.listen(port, () => {
        console.log(`app production listen on port ${port}`);
    });
};
