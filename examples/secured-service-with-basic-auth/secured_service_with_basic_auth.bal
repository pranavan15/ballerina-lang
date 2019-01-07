import ballerina/http;

http:AuthProvider basicAuthProvider = {
    scheme: "basic",
    authStoreProvider: "config"
};

// The endpoint used here is `http:Listener`, which by default tries to
// authenticate and authorize each request. The developer has the option to
// override the authentication and authorization at the service level and
// resource level.
listener http:Listener ep = new(9090, config = {
    authProviders: [basicAuthProvider],
    // The secure hello world sample uses https.
    secureSocket: {
        keyStore: {
            path: "${ballerina.home}/bre/security/ballerinaKeystore.p12",
            password: "ballerina"
        }
    }
});

@http:ServiceConfig {
    basePath: "/hello",
    authConfig: {
        authentication: { enabled: true },
        scopes: ["scope1"]
    }
}
// Auth configuration comprises of two parts - authentication & authorization.
// Authentication can be enabled by setting the `authentication:{enabled:true}`
// annotation attribute. 
// Authorization is based on scopes, where a scope maps to one or more groups.
// For a user to access a resource, the user should be in the same groups as
// the scope.
// To specify one or more scopes of a resource, the `scopes` annotation
// attribute can be used.
service echo on ep {

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/sayHello",
        authConfig: {
            scopes: ["scope2"]
        }
    }
    // The authentication and authorization settings can be overridden at
    // resource level.
    // The hello resource would inherit the `authentication:{enabled:true}`
    // flag from the service level, and override the scope defined in the
    // service level (i.e., scope1) with scope2.
    resource function hello(http:Caller caller, http:Request req) {
        _ = caller->respond("Hello, World!!!");
    }
}
