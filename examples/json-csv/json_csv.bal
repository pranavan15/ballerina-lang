import ballerina/io;
import ballerina/log;

// Converts a `json` value to an array of strings.
// Returns the result as a tuple which contains the headers and fields
function getFields(json rec) returns (string[], string[]) {
    int count = 0;
    string [] headers = [];
    string [] fields = [];
    headers = rec.getKeys();
    foreach var field in headers {
        fields[count] = rec[field].toString();
        count = count + 1;
    }
    return (headers, fields);
}

// Writes `json` content to CSV.
function writeCsv(json content, string path) returns error? {
    io:WritableCSVChannel csvch = io:openWritableCsvFile(path);
    int recIndex = 0;
    int recLen = content.length();
    while (recIndex < recLen) {
        (string [], string []) result = getFields(content[recIndex]);
        var (headers, fields) = result;
        if (recIndex == 0) {
            //We ignore the result as this would mean a nill return
            check csvch.write(headers);
        }
        check csvch.write(fields);
        recIndex = recIndex + 1;
    }
    return;
}

public function main() {
    // Sample `json` which will be written.
    json sample = {
            "employees": {
                "employee": [
                    {
                        "id": "1",
                        "firstName": "Tom",
                        "lastName": "Cruise",
                        "photo": "https://ballerina-team/profile/3737.jpg"
                    },
                    {
                        "id": "2",
                        "firstName": "Maria",
                        "lastName": "Sharapova",
                        "photo": "https://ballerina-team/profile/5676.jpg"
                    },
                    {
                        "id": "3",
                        "firstName": "James",
                        "lastName": "Bond",
                        "photo": "https://ballerina-team/profile/6776.jpg"
                    }
                ]
            }};
    // Writes json into a csv
    string path = "./files/sample.csv";
    // Specify the json array which should be transformed into csv
    // Also provide the location the csv should be written
    var result = writeCsv(sample.employees.employee, path);
    if (result is error) {
        log:printError("Error occurred while writing csv record :",
                        err = result);
    } else {
        io:println("json record successfully transformed to a csv, file could" +
                    " be found in " + path);
    }
}
