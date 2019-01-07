// This is the server implementation for the unary blocking/unblocking scenario.
import ballerina/grpc;
import ballerina/log;

service HelloWorld on new grpc:Listener(9090) {

    resource function hello (grpc:Caller caller, string name,
                             grpc:Headers headers) {
        log:printInfo("Server received hello from " + name);
        string message = "Hello " + name;
        // Reads custom headers in request message.
        string reqHeader = headers.get("client_header_key") ?: "none";
        log:printInfo("Server received header value: " + reqHeader);

        // Writes custom headers to response message.
        grpc:Headers resHeader = new;
        resHeader.setEntry("server_header_key", "Response Header value");

        // Sends response message with headers.
        error? err = caller->send(message, headers = resHeader);
        if (err is error) {
            log:printError("Error from Connector: " + err.reason() + " - "
                                             + <string>err.detail().message);
        }

        // Sends `completed` notification to caller.
        _ = caller->complete();
    }
}
