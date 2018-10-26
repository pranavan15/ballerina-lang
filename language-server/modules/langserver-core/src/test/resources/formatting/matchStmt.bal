import ballerina/io;

type KeyNotFoundError record {
    string message;
    error? cause;
    string key;
};

// The values of this map are constrained to the values of the optional string type.
map<string?> values = {"key1": "value1", "key2": ()};

// This function returns either a `string`, a `KeyNotFoundError` or nil.
function getValue(string key) returns string?|KeyNotFoundError {
    if (!values.hasKey(key)) {
        KeyNotFoundError err = {message: "key '" + key + "' not found", key: key};
        return err;
    } else {
        return values[key];
    }
}

function print(string?|KeyNotFoundError result) {
    // This match statement executes the code block based on the type of the result variable reference.
    match   result{string   value=>io:println("value: " + value)  ;
  ()=>io:println("value is ()") ;
                   KeyNotFoundError  e=>{
    io:println(e.message) ; match getValue("key1") {
                                            string value => io:println("value: " + value);() => io:println("value is ()");
                                            KeyNotFoundError sd => {io:println(sd.message);
                                          }}}}
}