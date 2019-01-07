import ballerina/io;
import ballerina/http;

listener http:MockListener testEP = new(9090);

@http:ServiceConfig {
    basePath:"/ecommerceservice"
}
service Ecommerce on testEP {
    @http:ResourceConfig {
        methods:["GET"],
        path:"/products/{productId}/{regId}"
    }
    resource function productsInfo1 (http:Caller caller, http:Request req, string productId, string regId) {
        string orderId = req.getHeader("X-ORDER-ID");
        io:println("Order ID " + orderId);
        io:println("Product ID " + productId);
        io:println("Reg ID " + regId);
        json responseJson = {"X-ORDER-ID":orderId, "ProductID":productId, "RegID":regId};
        io:println(responseJson.toString());

        http:Response res = new;
        res.setJsonPayload(untaint responseJson);
        _ = caller->respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/products2/{productId}/{regId}/item"
    }
    resource function productsInfo2 (http:Caller caller, http:Request req, string productId, string regId) {
        json responseJson;
        io:println("Product ID " + productId);
        io:println("Reg ID " + regId);
        responseJson = {"Template":"T2", "ProductID":productId, "RegID":regId};
        io:println(responseJson.toString());

        http:Response res = new;
        res.setJsonPayload(untaint responseJson);
        _ = caller->respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/products3/{productId}/{regId}/*"
    }
    resource function productsInfo3 (http:Caller caller, http:Request req, string productId, string regId) {
        json responseJson;
        io:println("Product ID " + productId);
        io:println("Reg ID " + regId);
        responseJson = {"Template":"T3", "ProductID":productId, "RegID":regId};
        io:println(responseJson.toString());

        http:Response res = new;
        res.setJsonPayload(untaint responseJson);
        _ = caller->respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/products/{productId}"
    }
    resource function productsInfo4 (http:Caller caller, http:Request req, string productId) {
        json responseJson;
        string rID = req.getQueryParams().regID;
        io:println("Product ID " + productId);
        io:println("Reg ID " + rID);
        responseJson = {"Template":"T4", "ProductID":productId, "RegID":rID};
        io:println(responseJson.toString());

        http:Response res = new;
        res.setJsonPayload(untaint responseJson);
        _ = caller->respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/products"
    }
    resource function productsInfo6 (http:Caller caller, http:Request req) {
        json responseJson;
        map<string> params = req.getQueryParams();
        string prdID = params.prodID;
        string rID= params.regID;
        io:println ("Product ID " + prdID);
        io:println ("Reg ID " + rID);
        responseJson = {"Template":"T6", "ProductID":prdID, "RegID":rID};
        io:println (responseJson.toString ());

        http:Response res = new;
        res.setJsonPayload(untaint responseJson);
        _ = caller->respond(res);
    }

    @http:ResourceConfig {
        methods:["GET"],
        path:"/products5/{productId}/reg"
    }
    resource function productsInfo5 (http:Caller caller, http:Request req, string productId) {
        json responseJson;
        string rID = req.getQueryParams().regID;
        io:println("Product ID " + productId);
        io:println("Reg ID " + rID);
        responseJson = {"Template":"T5", "ProductID":productId, "RegID":rID};
        io:println(responseJson.toString());

        http:Response res = new;
        res.setJsonPayload(untaint responseJson);
        _ = caller->respond(res);
    }

    @http:ResourceConfig {
        path:""
    }
    resource function echo1 (http:Caller caller, http:Request req) {
        http:Response res = new;
        json responseJson = {"echo11":"echo11"};
        res.setJsonPayload(responseJson);
        _ = caller->respond(res);
    }
}

@http:ServiceConfig {
    basePath:"/options"
}
service echo111 on testEP {

    @http:ResourceConfig {
        methods:["POST", "UPDATE"],
        path : "/test"
    }
    resource function productsInfo99 (http:Caller caller, http:Request req) {
        http:Response res = new;
        _ = caller->respond(res);
    }

    @http:ResourceConfig {
        methods:["OPTIONS"],
        path : "/hi"
    }
    resource function productsOptions (http:Caller caller, http:Request req) {
        http:Response res = new;
        json responseJson = {"echo":"wso2"};
        res.setJsonPayload(responseJson);
        _ = caller->respond(res);
    }

    @http:ResourceConfig {
        methods:["GET", "PUT"],
        path : "/test"
    }
    resource function productsInfo98 (http:Caller caller, http:Request req) {
        http:Response res = new;
        _ = caller->respond(res);

    }

    @http:ResourceConfig {
        methods:["GET"],
        path : "/getme"
    }
    resource function productsGet (http:Caller caller, http:Request req) {
        http:Response res = new;
        json responseJson = {"echo":"get"};
        res.setJsonPayload(responseJson);
        _ = caller->respond(res);
    }

    @http:ResourceConfig {
        methods:["POST"],
        path : "/post"
    }
    resource function productsPOST (http:Caller caller, http:Request req) {
        http:Response res = new;
        json responseJson = {"echo":"post"};
        res.setJsonPayload(responseJson);
        _ = caller->respond(res);
    }

    @http:ResourceConfig {
        methods:["PUT"],
        path : "/put/add"
    }
    resource function productsPUT (http:Caller caller, http:Request req) {
        http:Response res = new;
        json responseJson = {"echo":"put"};
        res.setJsonPayload(responseJson);
        _ = caller->respond(res);
    }

    @http:ResourceConfig {
        methods:["DELETE"],
        path : "/put/{abc}"
    }
    resource function productsDELETE (http:Caller caller, http:Request req, string abc) {
        http:Response res = new;
        json responseJson = {"echo":"delete"};
        res.setJsonPayload(responseJson);
        _ = caller->respond(res);
    }
}

@http:ServiceConfig {
    basePath:"/noResource"
}
service echo112 on testEP {
}

@http:ServiceConfig {
    basePath:"hello/"
}
service serviceHello on testEP {

    @http:ResourceConfig {
        methods:["GET"],
        path:"/test/"
    }
    resource function productsInfo (http:Caller caller, http:Request req) {
        http:Response res = new;
        json responseJson = {"echo":"sanitized"};
        res.setJsonPayload(responseJson);
        _ = caller->respond(res);
    }
}

@http:ServiceConfig {
    basePath:"/ech[o"
}
service echo113 on testEP {

    @http:ResourceConfig {
        methods:["GET"],
        path:"/ech[o/{foo}"
    }
    resource function productsInfo (http:Caller caller, http:Request req, string foo) {
        http:Response res = new;
        json responseJson = {"echo113": foo};
        res.setJsonPayload(untaint responseJson);
        _ = caller->respond(res);
    }
}

@http:ServiceConfig {
    basePath:"/ech%5Bo14"
}
service echo114 on testEP {

    @http:ResourceConfig {
        methods:["GET"],
        path:"/ech%5Bo14/{foo}"
    }
    resource function productsInfo (http:Caller caller, http:Request req, string foo) {
        http:Response res = new;
        json responseJson = {"echo114": foo};
        res.setJsonPayload(untaint responseJson);
        _ = caller->respond(res);
    }
}
