import ballerina/http;

listener http:MockListener echoEP = new(9090);

@http:ServiceConfig {
    basePath:"/signature"
}
service echo on echoEP {
    resource function echo1(http:Caller caller) {
        http:Response res = new;
        _ = caller->respond(res);
    }
}
