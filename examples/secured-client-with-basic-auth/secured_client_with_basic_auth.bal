import ballerina/config;
import ballerina/http;
import ballerina/log;

// Define the basic auth client endpoint to call the backend services.
// Basic authentication is enabled by setting the `scheme: http:BASIC_AUTH`
// The `username` and `password` should be specified as needed.
http:Client httpEndpoint = new("https://localhost:9090", config = {
    auth: {
        scheme: http:BASIC_AUTH,
        username: "tom",
        password: "1234"
    }
});

public function main() {
    // This defines the authentication credentials of the HTTP service.
    config:setConfig("b7a.users.tom.password", "1234");

    // Send a `GET` request to the specified endpoint.
    var response = httpEndpoint->get("/hello/sayHello");
    if (response is http:Response) {
        var result = response.getPayloadAsString();
        log:printInfo((result is error) ? "Failed to retrieve payload."
                                        : result);
    } else {
        log:printError("Failed to call the endpoint.", err = response);
    }
}

// Create a basic authentication provider with the relevant configurations.
http:AuthProvider basicAuthProvider = {
    scheme: "basic",
    authStoreProvider: "config"
};

listener http:Listener ep  = new(9090, config = {
    authProviders: [basicAuthProvider],
    secureSocket: {
        keyStore: {
            path: "${ballerina.home}/bre/security/ballerinaKeystore.p12",
            password: "ballerina"
        },
        trustStore: {
            path: "${ballerina.home}/bre/security/ballerinaTruststore.p12",
            password: "ballerina"
        }
    }
});

@http:ServiceConfig {
    basePath: "/hello",
    authConfig: {
        authentication: { enabled: true }
    }
}
service echo on ep {

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/sayHello"
    }
    resource function hello(http:Caller caller, http:Request req) {
        _ = caller->respond("Hello, World!!!");
    }
}
