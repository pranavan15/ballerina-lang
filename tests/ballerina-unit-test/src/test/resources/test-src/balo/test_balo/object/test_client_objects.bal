import testorg/foo version v1;

function testCheck () returns error? {
    var a = testCheckFunction();
    return a;
}

function testCheckFunction () returns error?{
    check foo:dyEP -> invoke1("foo");
    return ();
}

function testNewEP(string a) returns string {
    foo:DummyEndpoint ep1 = new;
    string r = ep1->invoke2(a);
    return r;
}