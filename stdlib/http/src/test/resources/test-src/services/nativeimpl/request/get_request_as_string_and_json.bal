import ballerina/io;
import ballerina/http;

listener http:MockListener testEP = new(9093);

@http:ServiceConfig { 
    basePath: "/foo" 
}
service MyService on testEP {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/bar"
    }
    resource function myResource(http:Caller caller, http:Request req) {
        var stringValue = req.getPayloadAsString();
        if (stringValue is string) {
            string s = stringValue;
        } else {
            panic stringValue;
        }
        json payload;
        var jsonValue = req.getJsonPayload();
        if (jsonValue is json) {
            payload = jsonValue;
        } else {
            panic jsonValue;
        }
        http:Response res = new;
        res.setPayload(untaint payload.foo);
        var err = caller->respond(res);
        if (err is error) {
            io:println("Error sending response");
        }
    }
}
