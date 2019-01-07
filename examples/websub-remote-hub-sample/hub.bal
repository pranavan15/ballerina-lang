// The Main program that brings up the Ballerina WebSub Hub.
import ballerina/io;
import ballerina/http;
import ballerina/runtime;
import ballerina/websub;

public function main() {

    // Start up the internal Ballerina Hub on port 9191, allowing remote publishers to register topics and publish
    // updates for the topics.
    io:println("Starting up the Ballerina Hub Service");

    var result = websub:startHub(new http:Listener(9191), hubConfiguration = {
                remotePublish : {
                    enabled : true
                }});
    websub:WebSubHub webSubHub = result is websub:HubStartedUpError ?
                                               result.startedUpHub : result;

    // Wait for the subscriber to subscribe at this hub and for the publisher to publish the notifications.
    runtime:sleep(10000);

}
