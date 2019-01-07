import ballerina/io;
import ballerina/log;

// Closes a readable channel
function closeRc(io:ReadableCharacterChannel rc) {
    var result = rc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",
                        err = result);
    }
}

// Closes a writable channel
function closeWc(io:WritableCharacterChannel wc) {
    var result = wc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",
                        err = result);
    }
}

// Writes xml content to a given path
function write(xml content, string path) returns error? {
    // Creates a byte channel from the given path
    io:WritableByteChannel wbc = io:openWritableFile(path);
    // Derives the character channel from the byte Channel
    io:WritableCharacterChannel wch = new(wbc, "UTF8");
    var result = wch.writeXml(content);
    if (result is error) {
        closeWc(wch);
        return result;
    } else {
        closeWc(wch);
        return result;
    }
}

// Reads xml from a given path
function read(string path) returns xml|error {
    // Create a byte channel from the given path
    io:ReadableByteChannel rbc = io:openReadableFile(path);
    // Derive the character channel from the byte Channel
    io:ReadableCharacterChannel rch = new(rbc, "UTF8");
    // This is how XML content is read from the character channel
    var result = rch.readXml();
    if (result is xml) {
        closeRc(rch);
        return result;
    } else {
        closeRc(rch);
        return result;
    }
}

public function main() {
    string filePath = "./files/sample.xml";
    // Creates XML content from the string
    xml x1 = xml `<book>The Lost World</book>`;
    io:println("Preparing to write xml file");
    // Writes the content
    var wResult = write(x1, filePath);
    if (wResult is error) {
        log:printError("Error occurred while writing xml: ", err = wResult);
    } else {
        io:println("Preparing to read the content written");
        // Reads the content
        var rResult = read(filePath);
        if (rResult is xml) {
            io:println(rResult);
        } else {
            log:printError("Error occurred while reading xml: ", err = rResult);
        }
    }
}
