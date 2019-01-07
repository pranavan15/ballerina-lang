import ballerina/grpc;
import ballerina/io;

// Generated blocking client endpoint based on the service definition.
public type HelloWorldBlockingClient client object {
    private grpc:Client grpcClient = new;
    private grpc:ClientEndpointConfig config = {};
    private string url;

    function __init(string url, grpc:ClientEndpointConfig? config = ()) {
        self.config = config ?: {};
        self.url = url;
        // Initialize client endpoint.
        grpc:Client c = new;
        c.init(self.url, self.config);
        error? result = c.initStub("blocking", ROOT_DESCRIPTOR,
                                                            getDescriptorMap());
        if (result is error) {
            panic result;
        } else {
            self.grpcClient = c;
        }
    }


    remote function hello(string req, grpc:Headers? headers = ())
                                        returns ((string, grpc:Headers)|error) {
        var payload = check self.grpcClient->blockingExecute(
                                                 "service.HelloWorld/hello", req,
                                                 headers = headers);
        grpc:Headers resHeaders = new;
        any result = ();
        (result, resHeaders) = payload;
        return (string.convert(result), resHeaders);
    }

};

// Generated non-blocking client endpoint based on the service definition.
public type HelloWorldClient client object {
    private grpc:Client grpcClient = new;
    private grpc:ClientEndpointConfig config = {};
    private string url;

    function __init(string url, grpc:ClientEndpointConfig? config = ()) {
        self.config = config ?: {};
        self.url = url;
        // Initialize client endpoint.
        grpc:Client c = new;
        c.init(self.url, self.config);
        error? result = c.initStub("non-blocking", ROOT_DESCRIPTOR,
                                                            getDescriptorMap());
        if (result is error) {
            panic result;
        } else {
            self.grpcClient = c;
        }
    }


    remote function hello(string req, service msgListener,
                                    grpc:Headers? headers = ()) returns (error?) {
        return self.grpcClient->nonBlockingExecute("service.HelloWorld/hello",
                                            req, msgListener, headers = headers);
    }

};


const string ROOT_DESCRIPTOR = "0A1048656C6C6F576F726C642E70726F746F1207736572766963651A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F32510A0A48656C6C6F576F726C6412430A0568656C6C6F121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33";
function getDescriptorMap() returns map<string> {
    return {
        "HelloWorld.proto":
        "0A1048656C6C6F576F726C642E70726F746F1207736572766963651A1E676F6F676C652"
        + "F70726F746F6275662F77726170706572732E70726F746F32510A0A48656C6C6F576F"
        + "726C6412430A0568656C6C6F121C2E676F6F676C652E70726F746F6275662E5374726"
        + "96E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E675661"
        + "6C7565620670726F746F33",
        "google/protobuf/wrappers.proto":
        "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676"
        + "F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A057661"
        + "6C7565180120012801520576616C756522220A0A466C6F617456616C756512140A057"
        + "6616C7565180120012802520576616C756522220A0A496E74363456616C756512140A"
        + "0576616C7565180120012803520576616C756522230A0B55496E74363456616C75651"
        + "2140A0576616C7565180120012804520576616C756522220A0A496E74333256616C75"
        + "6512140A0576616C7565180120012805520576616C756522230A0B55496E743332566"
        + "16C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56"
        + "616C756512140A0576616C7565180120012808520576616C756522230A0B537472696"
        + "E6756616C756512140A0576616C7565180120012809520576616C756522220A0A4279"
        + "74657356616C756512140A0576616C756518012001280C520576616C756542570A136"
        + "36F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50"
        + "015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F62756"
        + "62E57656C6C4B6E6F776E5479706573620670726F746F33"

    };
}
