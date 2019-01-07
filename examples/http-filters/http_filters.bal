import ballerina/http;
import ballerina/log;

// Header name to be set to the request in the filter.
final string filter_name_header = "X-filterName";
// Header value to be set to the request in the filter.
final string filter_name_header_value = "RequestFilter-1";

// The filter implementation. The filter intercepts the request and adds a new
// header to request before it is dispatched to the HTTP resource.
public type RequestFilter object {
    // Intercepts the request.
    public function filterRequest(http:Caller caller, http:Request request,
                        http:FilterContext context)
                        returns boolean {
        // Set a header to the request inside the filter.
        request.setHeader(filter_name_header, filter_name_header_value);
        // Return true on success.
        return true;
    }

    // Intercepts the response.
    public function filterResponse(http:Response response,
                                   http:FilterContext context)
                                    returns boolean {
        // Return true as response need not be intercepted.
        return true;
    }
};

// Create a new RequestFilter.
RequestFilter filter = new;

// Create an HTTP listener and assign the filter as a config parameter.
listener http:Listener echoListener = new http:Listener(9090,
                                            config = { filters: [filter]});

@http:ServiceConfig {
    basePath: "/hello"
}
service echo on echoListener {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/sayHello"
    }
    resource function echo(http:Caller caller, http:Request req) {
        // Create a new http response.
        http:Response res = new;
        // Set the `filter_name_header` from the request to the response.
        res.setHeader(filter_name_header, req.getHeader(filter_name_header));
        res.setPayload("Hello, World!");
        var result = caller->respond(res);
        if (result is error) {
           log:printError("Error sending response", err = result);
        }
    }
}

