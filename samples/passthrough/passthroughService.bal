package samples.passthrough;

import ballerina.lang.message;
import ballerina.net.http;
import ballerina.lang.json;


@BasePath ("/stock")
@Source (interface = "passthroughinterface")
@Service(title = "NYSEService", description = "NYSE service")
Service PassthroughService {

http.HttpConnector nyseEP = new http.HttpConnector("http://localhost:8080/exchange/nyse/", {"timeOut" : 30000});


@GET
@PUT
@POST
@Path ("/passthrough")
resource passthrough (message m) {
  message response;
  response = http.sendPost (nyseEP, m);
  reply response;

}

}
