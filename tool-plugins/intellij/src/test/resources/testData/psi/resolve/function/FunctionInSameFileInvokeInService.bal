import ballerina/http;

service hello on new http:Listener(9090) {
    resource function sayHello(http:Caller caller, http:Request req) {
        /*ref*/fun();
    }
}

function /*def*/fun () {

}
