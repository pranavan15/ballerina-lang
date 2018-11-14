import ballerina/io;
import ballerina/http;

endpoint http:Listener frontendEP {
    port: 9090
};

endpoint http:Client backendClientEP {
    url: "http://localhost:7090",
    // HTTP version is set to 2.0.
    httpVersion: "2.0"
};

@http:ServiceConfig {
    basePath: "/frontend"
}
service<http:Service> frontendHttpService bind frontendEP {

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/"
    }
    frontendHttpResource(endpoint caller, http:Request clientRequest) {

        http:Request serviceReq = new;
        http:HttpFuture httpFuture = new;
        // Submit a request
        var submissionResult = backendClientEP->submit("GET", "/backend/main", serviceReq);
        if (submissionResult is http:HttpFuture) {
            httpFuture = submissionResult;
        } else if (submissionResult is error) {
            io:println("Error occurred while submitting a request");
            json errMsg = { "error": "error occurred while submitting a request" };
            _ = caller->respond(errMsg);
            done;
        }

        // Check whether promises exists
        http:PushPromise[] promises = [];
        int promiseCount = 0;
        boolean hasPromise = backendClientEP->hasPromise(httpFuture);
        while (hasPromise) {
            http:PushPromise pushPromise = new;
            // Get the next promise
            var nextPromiseResult = backendClientEP->getNextPromise(httpFuture);
            if (nextPromiseResult is http:PushPromise) {
                pushPromise = nextPromiseResult;
            } else if (nextPromiseResult is error) {
                io:println("Error occurred while fetching a push promise");
                json errMsg = { "error": "error occurred while fetching a push promise" };
                _ = caller->respond(errMsg);
                done;
            }

            io:println("Received a promise for " + pushPromise.path);
            // Store required promises
            promises[promiseCount] = pushPromise;
            promiseCount = promiseCount + 1;
            hasPromise = backendClientEP->hasPromise(httpFuture);
        }
        // By this time 3 promises should be received, if not send an error response
        if (promiseCount != 3) {
            json errMsg = { "error": "expected number of promises not received" };
            _ = caller->respond(errMsg);
            done;
        }
        io:println("Number of promises received : " + promiseCount);

        // Get the requested resource
        http:Response response = new;
        var result = backendClientEP->getResponse(httpFuture);
        if (result is http:Response) {
            response = result;
        } else if (result is error) {
            io:println("Error occurred while fetching response");
            json errMsg = { "error": "error occurred while fetching response" };
            _ = caller->respond(errMsg);
            done;
        }

        var responsePayload = response.getJsonPayload();
        json responseJsonPayload = {};
        if (responsePayload is json) {
            responseJsonPayload = responsePayload;
        } else if (responsePayload is error) {
            json errMsg = { "error": "expected response message not received" };
            _ = caller->respond(errMsg);
            done;
        }
        // Check whether correct response received
        string responseStringPayload = responseJsonPayload.toString();
        if (!(responseStringPayload.contains("main"))) {
            json errMsg = { "error": "expected response message not received" };
            _ = caller->respond(errMsg);
            done;
        }
        io:println("Response : " + responseStringPayload);

        // Fetch required promised responses
        foreach promise in promises {
            http:Response promisedResponse = new;
            var promisedResponseResult = backendClientEP->getPromisedResponse(promise);
            if (promisedResponseResult is http:Response) {
                promisedResponse = promisedResponseResult;
            } else if (promisedResponseResult is error) {
                io:println("Error occurred while fetching promised response");
                json errMsg = { "error": "error occurred while fetching promised response" };
                _ = caller->respond(errMsg);
                done;
            }

            json promisedJsonPayload = {};
            var promisedPayload = promisedResponse.getJsonPayload();
            if (promisedPayload is json) {
                promisedJsonPayload = promisedPayload;
            } else if (promisedPayload is error) {
                json errMsg = { "error": "expected promised response not received" };
                _ = caller->respond(errMsg);
                done;
            }

            // check whether expected
            string expectedVal = promise.path.substring(1, 10);
            string promisedStringPayload = promisedJsonPayload.toString();
            if (!(promisedStringPayload.contains(expectedVal))) {
                json errMsg = { "error": "expected promised response not received" };
                _ = caller->respond(errMsg);
                done;
            }
            io:println("Promised resource : " + promisedStringPayload);
        }

        // By this time everything has went well, hence send a success response
        json successMsg = { "status": "successful" };
        _ = caller->respond(successMsg);
    }
}

endpoint http:Listener backendEP {
    port: 7090,
    // HTTP version is set to 2.0
    httpVersion: "2.0"
};

@http:ServiceConfig {
    basePath: "/backend"
}
service<http:Service> backendHttp2Service bind backendEP {

    @http:ResourceConfig {
        path: "/main"
    }
    backendHttp2Resource(endpoint caller, http:Request req) {

        io:println("Request received");

        // Send a Push Promise
        http:PushPromise promise1 = new(path = "/resource1", method = "POST");
        _ = caller->promise(promise1);

        // Send another Push Promise
        http:PushPromise promise2 = new(path = "/resource2", method = "POST");
        _ = caller->promise(promise2);

        // Send one more Push Promise
        http:PushPromise promise3 = new;
        // create with default params
        promise3.path = "/resource3";
        // set parameters
        promise3.method = "POST";
        _ = caller->promise(promise3);

        // Construct requested resource
        json msg = { "response": { "name": "main resource" } };

        // Send the requested resource
        _ = caller->respond(msg);

        // Construct promised resource1
        http:Response push1 = new;
        msg = { "push": { "name": "resource1" } };
        push1.setJsonPayload(msg);

        // Push promised resource1
        _ = caller->pushPromisedResponse(promise1, push1);

        http:Response push2 = new;
        msg = { "push": { "name": "resource2" } };
        push2.setJsonPayload(msg);

        // Push promised resource2
        _ = caller->pushPromisedResponse(promise2, push2);

        http:Response push3 = new;
        msg = { "push": { "name": "resource3" } };
        push3.setJsonPayload(msg);

        // Push promised resource3
        _ = caller->pushPromisedResponse(promise3, push3);
    }
}
