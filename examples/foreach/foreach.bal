import ballerina/io;

public function main() {
    io:println("Iterating over a string array :");
    string[] fruits = ["apple", "banana", "cherry"];

    // Foreach statement can be used to iterate over an array. Each iteration returns an element in the array. Note
    // that the index of the corresponding element is not returned.
    foreach var v in fruits {
        io:println("fruit: " + v);
    }

    io:println("\nIterating over a map :");
    map<string> words = { a: "apple", b: "banana", c: "cherry" };

    // Iterating over a `map` will return the key (`string`) and the value as a `tuple` variable.
    // We can use tuple destructuring to split the tuple variable in to two variables.
    foreach var (k, v) in words {
        io:println("letter: " + k + ", word: " + v);
    }

    io:println("\nIterating over a json object :");
    json apple = { name: "apple", colors: ["red", "green"], price: 5 };
    map<json> mapValue = <map<json>> map<json>.convert(apple);
    // Iterating over a JSON is not supported. To iterate over a JSON, first convert the JSON to a map and then iterate
    // over the newly created map.
    foreach var (i, j) in mapValue {
        if (j is string) {
            io:println("string value: ", j);
        } else if (j is int) {
            io:println("int value: ", j);
        } else if (j is json[]) {
            io:println("json array value: ", j);
        } else {
            // JSON is a union type for () or null | int | float | decimal | string | json[] | map<json>,
            // `j` in else block if type cannot be inferred then it is type `anydata`.
            io:println("non-string value: ", j);
        }
    }

    io:println("\nIterating over a json array :");
    // To Iterate over a JSON array, you need to first cast it into an array of json (`json[]`).
    json[] colors = <json[]>apple.colors;
    int counter = 0;
    foreach var j in colors {
        io:println("color ", counter, ": ", j);
        counter += 1;
    }

    io:println("\nIterating over an xml :");
    xml book = xml `<book>
                        <name>Sherlock Holmes</name>
                        <author>Sir Arthur Conan Doyle</author>
                    </book>`;
    // Iterating over an XML will return each element in each iteration.
    counter = 0;
    foreach var x in book.*.elements(){
        io:println("xml at ", counter, ": ", x);
        counter += 1;
    }

    io:println("\nIterating over a closed integer range :");
    int endValue = 10;
    int sum = 0;
    // A closed integer range in the `foreach` statement represents an incremental integer value range from the start
    // expression (`1`) to the end expression (`endValue`) inclusively.
    foreach var i in 1...endValue {
        sum = sum + i;
    }
    io:println("summation from 1 to " + endValue + " is " + sum);

    io:println("\nIterating over a half open integer range :");
    sum = 0;
    // A half open integer range in the `foreach` statement represents an incremental integer value range from the start
    // expression (`1`) inclusively, to the end expression (`endValue`) exclusively.
    foreach var i in 1..<endValue {
        sum = sum + i;
    }
    io:println("summation from 1 to " + endValue + " excluding "
                    + endValue + " is " + sum);
}
