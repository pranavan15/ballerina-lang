import ballerina/http;
import ballerina/io;

listener http:MockListener passthruEP  = new(9090);

@http:ServiceConfig {
    basePath:"/hello6/{version}/bar",
    versioning:{
        pattern:"v{Minor}",
        matchMajorVersion:true
    }
}
service hello6 on passthruEP {

    @http:ResourceConfig {
        path:"/go"
    }
    resource function sample (http:Caller caller, http:Request req) {
        http:Response res = new;
        res.setJsonPayload({hello:"only match major but no major"});
        _ = caller->respond(res);
    }
}
