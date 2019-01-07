import ballerina/io;

public function main() {
    // Define an anonymous function.
    function (string, string) returns (string) anonFunction =
            function (string x, string y) returns (string) {
                return x + y;
            };
    io:println("Output: " + anonFunction.call("Hello ", "World.!!!"));

    // Define an anonymous function with `var`.
    var anonFunction2 = function (string x, string y) returns (string) {
                            return x + y;
                        };
    io:println("Output: " + anonFunction2.call("Hello ", "World.!!!"));

    // If an anonymous function contains only the return statement in the body,
    // you can use the `arrow function expression` instead of the anonymous function.
    // The types of the input parameters are inferred from the left-hand side.
    // The return of the arrow function expression is determined by the
    // evaluation of the expression to the right-hand side of the `=>` symbol.
    function (string, string) returns (string) arrowExpr = (x, y) => x + y;
    io:println("Output: " + arrowExpr.call("Hello ", "World.!!!"));
}
