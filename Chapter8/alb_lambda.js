'use strict';

exports.handler = (event, context, callback) => {
    const request = event;
    const headers = request.headers;

    if (request.path !== '/') {
        // do not process if this is not an A-B test request
        callback(null, request);
        return;
    }

    const cookieExperimentA = 'X-Experiment-Name=A';
    const cookieExperimentB = 'X-Experiment-Name=B';
    const pathExperimentA = '/index.html';
    const pathExperimentB = '/indexB.html';

    let experimentUri;
    if (headers.cookie == cookieExperimentB ) {
        console.log('Experiment B cookie found');
        experimentUri = pathExperimentB;
    } else {
        console.log('No valid cookie found');
        experimentUri = pathExperimentA;
    }

    if (!experimentUri) {
        console.log('Experiment cookie has not been found. Throwing dice...');
        if (Math.random() < 0.75) {
            experimentUri = pathExperimentA;
        } else {
            experimentUri = pathExperimentB;
        }
    }

    request.uri = experimentUri;
    console.log(`Request uri set to "${request.uri}"`);
    callback(null, request);
};