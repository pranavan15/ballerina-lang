import ballerina/observe;

function testMaxSummary() returns (float) {
    map<string> tags = { "method": "POST" };
    observe:Gauge gauge = new("response_size", desc = "Size of a response.", tags = tags);
    gauge.setValue(1.0);
    gauge.setValue(2.0);
    gauge.setValue(3.0);
    observe:Snapshot[]? summarySnapshot = gauge.getSnapshot();
    if summarySnapshot is observe:Snapshot[] {
        return summarySnapshot[0].max;
    } else {
        return 0.0;
    }
}

function testMeanSummary() returns (float) {
    map<string> tags = { "method": "UPDATE" };
    observe:Gauge gauge = new("response_size", desc = "Size of a response.", tags = tags);
    gauge.setValue(1.0);
    gauge.setValue(2.0);
    gauge.setValue(3.0);
    observe:Snapshot[]? summarySnapshot = gauge.getSnapshot();
    if summarySnapshot is observe:Snapshot[] {
        return summarySnapshot[0].mean;
    } else {
        return 0.0;
    }
}

function testPercentileSummary() returns (observe:PercentileValue[]?) {
    map<string> tags = { "method": "DELETE" };
    observe:Gauge gauge = new("response_size", desc = "Size of a response.", tags = tags);
    gauge.setValue(1.0);
    gauge.setValue(2.0);
    gauge.setValue(3.0);
    gauge.setValue(4.0);
    gauge.setValue(5.0);
    gauge.setValue(6.0);
    observe:Snapshot[]? summarySnapshot = gauge.getSnapshot();
    if summarySnapshot is observe:Snapshot[] {
        return summarySnapshot[0].percentileValues;
    } else {
        return ();
    }
}

function testValueSummary() returns (float) {
    map<string> tags = { "method": "DELETE" };
    observe:Gauge gauge = new("response_size", desc = "Size of a response.", tags = tags);
    gauge.increment();
    gauge.increment(amount = 1000.0);
    gauge.decrement();
    gauge.decrement(amount = 500.0);
    return gauge.getValue();
}

function testSummaryWithoutTags() returns (float) {
    observe:Gauge gauge = new("new_response_size");
    gauge.setValue(1.0);
    gauge.setValue(2.0);
    gauge.setValue(3.0);
    observe:Snapshot[]? summarySnapshot = gauge.getSnapshot();
    if summarySnapshot is observe:Snapshot[] {
        return summarySnapshot[0].mean;
    } else {
        return 0.0;
    }
}

function registerAndIncrement() returns (float) {
    observe:Gauge gauge = new("register_response_size");
    _ = gauge.register();
    gauge.increment();
    return gauge.getValue();
}
