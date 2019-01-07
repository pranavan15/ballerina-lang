import ballerina/http;

listener http:MockListener echoEP = new(9090);

@http:ServiceConfig {
    basePath:"/signature"
}
service echo on echoEP {

    @http:ResourceConfig {
        methods:["POST"],
        body:"person"
    }
    resource function echo1 (http:Caller caller, http:Request req, string key, int person) {
        http:Response res = new;
        _ = caller->respond(res);
    }
}
