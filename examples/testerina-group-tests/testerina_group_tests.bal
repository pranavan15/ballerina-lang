import ballerina/io;
import ballerina/test;

// Test function, which belongs to group `g1`
@test:Config {
    groups: ["g1"]
}
function testFunction1() {
    io:println("I'm in test belonging to group g1!");
    test:assertTrue(true, msg = "Failed!");
}

// Test function, which belongs to groups `g1`, and `g2`
@test:Config {
    groups: ["g1", "g2"]
}
function testFunction2() {
    io:println("I'm in test belonging to groups g1 and g2!");
    test:assertTrue(true, msg = "Failed!");
}

// This test doesn't belong to any group
@test:Config
function testFunction3() {
    io:println("I'm the ungrouped test");
    test:assertTrue(true, msg = "Failed!");
}
