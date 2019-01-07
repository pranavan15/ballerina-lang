import ballerina/http;
import ballerina/log;

final string ASSOCIATED_CONNECTION = "ASSOCIATED_CONNECTION";
// The Url of the remote backend.
final string REMOTE_BACKEND = "ws://echo.websocket.org";

@http:WebSocketServiceConfig {
    path: "/proxy/ws"
}
service SimpleProxyService on new http:WebSocketListener(9090) {

    // This resource triggered when a new client is connected.
    // Since messages to the server are not read by service until `onOpen` resource execution finishes,
    // operations which should happen before reading messages should be done in `onOpen` resource.
    resource function onOpen(http:WebSocketCaller caller) {

        http:WebSocketClient wsClientEp = new(
            REMOTE_BACKEND,
            config = {callbackService: ClientService,
            // When creating client endpoint, if `readyOnConnect` flag is set to
            // `false` client endpoint does not start reading frames automatically.
            readyOnConnect: false
        });
        //Associate connections before starting to read messages.
        wsClientEp.attributes[ASSOCIATED_CONNECTION] = caller;
        caller.attributes[ASSOCIATED_CONNECTION] = wsClientEp;

        // Once the client is ready to receive frames the remote function `ready`
        // of the client need to be called separately.
        var err = wsClientEp->ready();
        if (err is error) {
            log:printError("Error calling ready on client", err = err);
        }
    }

    //This resource is triggered when a new text frame is received from a client.
    resource function onText(http:WebSocketCaller caller, string text,
                                boolean finalFrame) {

        http:WebSocketClient clientEp =
                    getAssociatedClientEndpoint(caller);
        var err = clientEp->pushText(text, finalFrame = finalFrame);
        if (err is error) {
            log:printError("Error occurred when sending text message",
                            err = err);
        }
    }

    //This resource is triggered when a new binary frame is received from a client.
    resource function onBinary(http:WebSocketCaller caller, byte[] data,
                                boolean finalFrame) {

        http:WebSocketClient clientEp =
                        getAssociatedClientEndpoint(caller);
        var err = clientEp->pushBinary(data, finalFrame = finalFrame);
        if (err is error) {
            log:printError("Error occurred when sending binary message",
                            err = err);
        }
    }

    //This resource is triggered when an error occurs in the connection.
    resource function onError(http:WebSocketCaller caller, error err) {

        http:WebSocketClient clientEp =
                        getAssociatedClientEndpoint(caller);
        var e = clientEp->close(statusCode = 1011,
                        reason = "Unexpected condition");
        if (e is error) {
            log:printError("Error occurred when closing the connection",
                            err = e);
        }
        _ = caller.attributes.remove(ASSOCIATED_CONNECTION);
        log:printError("Unexpected error hense closing the connection",
                        err = err);
    }

    //This resource is triggered when a client connection is closed from the client side.
    resource function onClose(http:WebSocketCaller caller, int statusCode,
                                string reason) {

        http:WebSocketClient clientEp =
                        getAssociatedClientEndpoint(caller);
        var err = clientEp->close(statusCode = statusCode, reason = reason);
        if (err is error) {
            log:printError("Error occurred when closing the connection",
                            err = err);
        }
        _ = caller.attributes.remove(ASSOCIATED_CONNECTION);
    }
}

//Client service to receive frames from the remote server.
service ClientService = @http:WebSocketServiceConfig {} service {

    //This resource is triggered when a new text frame is received from the remote backend.
    resource function onText(http:WebSocketClient caller, string text,
                                boolean finalFrame) {

        http:WebSocketCaller serverEp =
                        getAssociatedServerEndpoint(caller);
        var err = serverEp->pushText(text, finalFrame = finalFrame);
        if (err is error) {
            log:printError("Error occurred when sending text message",
                            err = err);
        }
    }

    //This resource is triggered when a new binary frame is received from the remote backend.
    resource function onBinary(http:WebSocketClient caller, byte[] data,
                                boolean finalFrame) {

        http:WebSocketCaller serverEp =
                        getAssociatedServerEndpoint(caller);
        var err = serverEp->pushBinary(data, finalFrame = finalFrame);
        if (err is error) {
           log:printError("Error occurred when sending binary message",
                            err = err);
        }
    }

    //This resource is triggered when an error occurs in the connection.
    resource function onError(http:WebSocketClient caller, error err) {

        http:WebSocketCaller serverEp =
                        getAssociatedServerEndpoint(caller);
        var e = serverEp->close(statusCode = 1011,
                        reason = "Unexpected condition");
        if (e is error) {
            log:printError("Error occurred when closing the connection",
                            err = e);
        }
        _ = caller.attributes.remove(ASSOCIATED_CONNECTION);
        log:printError("Unexpected error hense closing the connection",
                        err = err);
    }

    //This resource is triggered when a client connection is closed by the remote backend.
    resource function onClose(http:WebSocketClient caller, int statusCode,
                                string reason) {

        http:WebSocketCaller serverEp =
                        getAssociatedServerEndpoint(caller);
        var err = serverEp->close(statusCode = statusCode, reason = reason);
            if (err is error) {
                log:printError("Error occurred when closing the connection",
                                err = err);
            }
        _ = caller.attributes.remove(ASSOCIATED_CONNECTION);
    }
};

// Function to retrieve associated client for a particular caller.
function getAssociatedClientEndpoint(http:WebSocketCaller ep)
                                        returns (http:WebSocketClient) {
    http:WebSocketClient wsClient =
            <http:WebSocketClient>ep.attributes[ASSOCIATED_CONNECTION];
    return wsClient;
}

// Function to retrieve the associated caller for a client.
function getAssociatedServerEndpoint(http:WebSocketClient ep)
                                        returns (http:WebSocketCaller) {
    http:WebSocketCaller wsEndpoint =
            <http:WebSocketCaller>ep.attributes[ASSOCIATED_CONNECTION];
    return wsEndpoint;
}
