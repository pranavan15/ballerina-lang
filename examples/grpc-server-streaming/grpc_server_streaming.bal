// This is the server implementation for the server streaming scenario.
import ballerina/grpc;
import ballerina/log;

service HelloWorld on new grpc:Listener(9090) {
    // The annotation indicates how the service resource operates as server streaming.
    @grpc:ResourceConfig { streaming: true }
    resource function lotsOfReplies(grpc:Caller caller, string name) {

        log:printInfo("Server received hello from " + name);
        string[] greets = ["Hi", "Hey", "GM"];

        // Send multiple messages to the caller.
        foreach string greet in greets {
            string msg = greet + " " + name;
            error? err = caller->send(msg);
            if (err is error) {
                log:printError("Error from Connector: " + err.reason() + " - "
                                                + <string>err.detail().message);
            } else {
                log:printInfo("Send reply: " + msg);
            }
        }

        // Once all the messages are sent, the server notifies the caller with a `complete` message.
        _ = caller->complete();
    }

}
