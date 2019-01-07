import ballerina/sql;
import ballerina/h2;
import ballerina/time;
import ballerina/io;

type ResultCustomers record {
    string FIRSTNAME;
};

type CustomerFullName record {
    string FIRSTNAME;
    string LASTNAME;
};

type ResultIntType record {
    int INT_TYPE;
};

type ResultBlob record {
    byte[] BLOB_TYPE;
};

type ResultRowIDBlob record {
    int row_id;
};

type ResultDataType record {
    int INT_TYPE;
    int LONG_TYPE;
    float FLOAT_TYPE;
    float DOUBLE_TYPE;
};

type ResultCount record {
    int COUNTVAL;
};

type ResultArrayType record {
    int[] INT_ARRAY;
    int[] LONG_ARRAY;
    float[] DOUBLE_ARRAY;
    boolean[] BOOLEAN_ARRAY;
    string[] STRING_ARRAY;
    float[] FLOAT_ARRAY;
};

type ResultDates record {
    string DATE_TYPE;
    string TIME_TYPE;
    string TIMESTAMP_TYPE;
    string DATETIME_TYPE;
};

type ResultBalTypes record {
    int INT_TYPE;
    int LONG_TYPE;
    float FLOAT_TYPE;
    float DOUBLE_TYPE;
    boolean BOOLEAN_TYPE;
    string STRING_TYPE;
    float NUMERIC_TYPE;
    float DECIMAL_TYPE;
    float REAL_TYPE;
};

type Employee record {
    int id;
    string name;
    string address;
};

function testInsertTableData() returns (int) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });
    var result = testDB->update("Insert into Customers (firstName,lastName,registrationID,creditLimit,country)
                                         values ('James', 'Clerk', 3, 5000.75, 'USA')");
    int insertCount = getIntResult(result);
    testDB.stop();
    return insertCount;
}

function testCreateTable() returns (int) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });
    var result = testDB->update("CREATE TABLE IF NOT EXISTS Students(studentID int, LastName varchar(255))");
    int returnValue = getIntResult(result);
    testDB.stop();
    return returnValue;
}

function testUpdateTableData() returns (int) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    var result = testDB->update("Update Customers set country = 'UK' where registrationID = 1");
    int updateCount = getIntResult(result);
    testDB.stop();
    return updateCount;
}

function testGeneratedKeyOnInsert() returns (string) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    string returnVal = "";

    var x = testDB->updateWithGeneratedKeys("insert into Customers (firstName,lastName,
            registrationID,creditLimit,country) values ('Mary', 'Williams', 3, 5000.75, 'USA')", ());

    if (x is (int, string[])) {
        int a;
        string[] b;
        (a, b) = x;
        returnVal = b[0];
    } else  if (x is error) {
        returnVal = x.reason();
    }
    testDB.stop();
    return returnVal;
}

function testGeneratedKeyOnInsertEmptyResults() returns (int|string) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    int|string returnVal = "";

    var x = testDB->updateWithGeneratedKeys("insert into CustomersNoKey (firstName,lastName,
            registrationID,creditLimit,country) values ('Mary', 'Williams', 3, 5000.75, 'USA')", ());

    if (x is (int, string[])) {
        int a;
        string[] b;
        (a, b) = x;
        returnVal = b.length();
    } else if (x is error) {
        returnVal = x.reason();
    }
    testDB.stop();
    return returnVal;
}


function testGeneratedKeyWithColumn() returns (string) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    int insertCount;
    string[] generatedID;
    string[] keyColumns = ["CUSTOMERID"];
    string returnVal = "";

    string queryString;
    queryString = "insert into Customers (firstName,lastName,registrationID,creditLimit,country) values ('Kathy',
        'Williams', 4, 5000.75, 'USA')";

    var x = testDB->updateWithGeneratedKeys(queryString, keyColumns);

    if (x is (int, string[])) {
        int a;
        string[] b;
        (a, b) = x;
        returnVal = b[0];
    } else if (x is error){
        returnVal = x.reason();
    }
    testDB.stop();
    return returnVal;
}

function testSelectData() returns (string) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });
    var dt = testDB->select("SELECT  FirstName from Customers where registrationID = 1", ResultCustomers);
    string firstName = getTableFirstNameColumn(dt);
    testDB.stop();
    return firstName;
}

function testSelectIntFloatData() returns (int, int, float, float) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    var dt = testDB->select("SELECT  int_type, long_type, float_type, double_type from DataTypeTable
        where row_id = 1", ResultDataType);
    int int_type = -1;
    int long_type = -1;
    float float_type = -1;
    float double_type = -1;
    if (dt is table<ResultDataType>) {
        while (dt.hasNext()) {
            var rs = dt.getNext();
            if (rs is ResultDataType) {
                int_type = rs.INT_TYPE;
                long_type = rs.LONG_TYPE;
                float_type = rs.FLOAT_TYPE;
                double_type = rs.DOUBLE_TYPE;
            }
        }
    }
    testDB.stop();
    return (int_type, long_type, float_type, double_type);
}

function testCallProcedure() returns (string, string) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 2 }
        });

    string returnValue = "";
    var ret = testDB->call("{call InsertPersonData(100,'James')}", ());

    if (ret is table<record {}>[]) {
        returnValue = "table";
    } else if (ret is ()) {
        returnValue = "nil";
    } else if (ret is error) {
        returnValue = "error";
    }
    var dt = testDB->select("SELECT  FirstName from Customers where registrationID = 100", ResultCustomers);
    string firstName = getTableFirstNameColumn(dt);
    testDB.stop();
    return (firstName, returnValue);
}

function testCallProcedureWithResultSet() returns (string) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    string firstName = "";
    var ret = testDB->call("{call SelectPersonData()}", [ResultCustomers]);

    if (ret is table<record {}>[]) {
        firstName = getTableFirstNameColumn(ret[0]);
    } else if (ret is ()) {
        firstName = "error";
    }
    testDB.stop();
    return firstName;
}

function testQueryParameters() returns (string) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });
    var dt = testDB->select("SELECT  FirstName from Customers where registrationID = ?", ResultCustomers, 1);
    string firstName = getTableFirstNameColumn(dt);
    testDB.stop();
    return firstName;
}

function testQueryParameters2() returns (string) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    sql:Parameter p1 = { sqlType: sql:TYPE_INTEGER, value: 1 };
    var dt = testDB->select("SELECT  FirstName from Customers where registrationID = ?", ResultCustomers, p1);
    string firstName = getTableFirstNameColumn(dt);
    testDB.stop();
    return firstName;
}

function testInsertTableDataWithParameters() returns (int) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    string s1 = "Anne";
    sql:Parameter para1 = { sqlType: sql:TYPE_VARCHAR, value: s1, direction: sql:DIRECTION_IN };
    sql:Parameter para2 = { sqlType: sql:TYPE_VARCHAR, value: "James", direction: sql:DIRECTION_IN };
    sql:Parameter para3 = { sqlType: sql:TYPE_INTEGER, value: 3, direction: sql:DIRECTION_IN };
    sql:Parameter para4 = { sqlType: sql:TYPE_DOUBLE, value: 5000.75, direction: sql:DIRECTION_IN };
    sql:Parameter para5 = { sqlType: sql:TYPE_VARCHAR, value: "UK", direction: sql:DIRECTION_IN };

    var result = testDB->update("Insert into Customers (firstName,lastName,registrationID,creditLimit,country)
                                     values (?,?,?,?,?)", para1, para2, para3, para4, para5);
    int insertCount = getIntResult(result);
    testDB.stop();
    return insertCount;
}

function testInsertTableDataWithParameters2() returns (int) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    var result = testDB->update("Insert into Customers (firstName,lastName,registrationID,creditLimit,country)
                                     values (?,?,?,?,?)", "Anne", "James", 3, 5000.75, "UK");
    int insertCount = getIntResult(result);
    testDB.stop();
    return insertCount;
}

function testInsertTableDataWithParameters3() returns (int) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    string s1 = "Anne";
    var result = testDB->update("Insert into Customers (firstName,lastName,registrationID,creditLimit,country)
                                     values (?,?,?,?,?)", s1, "James", 3, 5000.75, "UK");
    int insertCount = getIntResult(result);
    testDB.stop();
    return insertCount;
}

function testArrayofQueryParameters() returns (string) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    int[] intDataArray = [1, 4343];
    string[] stringDataArray = ["A", "B"];
    float[] doubleArray = [233.4, 433.4];
    sql:Parameter para0 = { sqlType: sql:TYPE_VARCHAR, value: "Johhhn" };
    sql:Parameter para1 = { sqlType: sql:TYPE_INTEGER, value: intDataArray };
    sql:Parameter para2 = { sqlType: sql:TYPE_VARCHAR, value: stringDataArray };
    sql:Parameter para3 = { sqlType: sql:TYPE_DOUBLE, value: doubleArray };

    var dt = testDB->select("SELECT  FirstName from Customers where FirstName = ? or lastName = 'A' or
        lastName = '\"BB\"' or registrationID in(?) or lastName in(?) or creditLimit in(?)", ResultCustomers,
        para0, para1, para2, para3);
    string firstName = getTableFirstNameColumn(dt);
    testDB.stop();
    return firstName;
}

function testBoolArrayofQueryParameters() returns (int) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    boolean accepted1 = false;
    boolean accepted2 = false;
    boolean accepted3 = true;
    boolean[] boolDataArray = [accepted1, accepted2, accepted3];

    string[] stringDataArray = ["Hello", "World", "Test"];

    sql:Parameter para1 = { sqlType: sql:TYPE_BOOLEAN, value: boolDataArray };
    sql:Parameter para2 = { sqlType: sql:TYPE_VARCHAR, value: stringDataArray };

    var dt = testDB->select("SELECT int_type from DataTypeTable where row_id = ? and boolean_type in(?) and
        string_type in (?)", ResultIntType, 1, para1, para2);
    int value = -1;
    if (dt is table<ResultIntType>) {
        while (dt.hasNext()) {
            var rs = dt.getNext();
            if (rs is ResultIntType) {
                value = rs.INT_TYPE;
            }
        }
    }
    testDB.stop();
    return value;
}

function testBlobArrayQueryParameter() returns int {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    var dt1 = testDB->select("SELECT blob_type from BlobTable where row_id = 7", ResultBlob);
    byte[] blobData = [];
    if (dt1 is table<ResultBlob>) {
        while (dt1.hasNext()) {
            var rs = dt1.getNext();
            if (rs is ResultBlob) {
                blobData = rs.BLOB_TYPE;
            }
        }
    }
    byte[][] blobDataArray = [blobData, blobData];

    sql:Parameter para1 = { sqlType: sql:TYPE_BLOB, value: blobDataArray };

    var dt = testDB->select("SELECT row_id from BlobTable where row_id = ? and blob_type in (?)", ResultRowIDBlob, 7, para1);
    int value = -1;
    if (dt is table<ResultRowIDBlob>) {
        while (dt.hasNext()) {
            var rs = dt.getNext();
            if (rs is ResultRowIDBlob) {
                value = rs.row_id;
            }
        }
    }
    testDB.stop();
    return value;
}

function testArrayInParameters() returns (int, int[], int[], float[],
            string[], boolean[], float[]) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    int[] intArray = [1];
    int[] longArray = [1503383034226, 1503383034224, 1503383034225];
    float[] floatArray = [245.23, 5559.49, 8796.123];
    float[] doubleArray = [1503383034226.23, 1503383034224.43, 1503383034225.123];
    boolean[] boolArray = [true, false, true];
    string[] stringArray = ["Hello", "Ballerina"];
    sql:Parameter para2 = { sqlType: sql:TYPE_ARRAY, value: intArray };
    sql:Parameter para3 = { sqlType: sql:TYPE_ARRAY, value: longArray };
    sql:Parameter para4 = { sqlType: sql:TYPE_ARRAY, value: floatArray };
    sql:Parameter para5 = { sqlType: sql:TYPE_ARRAY, value: doubleArray };
    sql:Parameter para6 = { sqlType: sql:TYPE_ARRAY, value: boolArray };
    sql:Parameter para7 = { sqlType: sql:TYPE_ARRAY, value: stringArray };

    int[] int_arr = [];
    int[] long_arr = [];
    float[] double_arr = [];
    string[] string_arr = [];
    boolean[] boolean_arr = [];
    float[] float_arr = [];

    var result = testDB->update("INSERT INTO ArrayTypes (row_id, int_array, long_array,
        float_array, double_array, boolean_array, string_array) values (?,?,?,?,?,?,?)", 2, para2, para3, para4,
        para5, para6, para7);
    int insertCount = getIntResult(result);

    var dt = testDB->select("SELECT int_array, long_array, double_array, boolean_array,
        string_array, float_array from ArrayTypes where row_id = 2", ResultArrayType);
    if (dt is table<ResultArrayType>) {
        while (dt.hasNext()) {
            var rs = dt.getNext();
            if (rs is ResultArrayType) {
                int_arr = rs.INT_ARRAY;
                long_arr = rs.LONG_ARRAY;
                double_arr = rs.DOUBLE_ARRAY;
                boolean_arr = rs.BOOLEAN_ARRAY;
                string_arr = rs.STRING_ARRAY;
                float_arr = rs.FLOAT_ARRAY;
            }
        }
    }
    testDB.stop();
    return (insertCount, int_arr, long_arr, double_arr, string_arr, boolean_arr, float_arr);
}

function testOutParameters() returns (any, any, any, any, any, any, any,
            any, any, any, any, any, any) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    sql:Parameter paraID = { sqlType: sql:TYPE_INTEGER, value: "1" };
    sql:Parameter paraInt = { sqlType: sql:TYPE_INTEGER, direction: sql:DIRECTION_OUT };
    sql:Parameter paraLong = { sqlType: sql:TYPE_BIGINT, direction: sql:DIRECTION_OUT };
    sql:Parameter paraFloat = { sqlType: sql:TYPE_FLOAT, direction: sql:DIRECTION_OUT };
    sql:Parameter paraDouble = { sqlType: sql:TYPE_DOUBLE, direction: sql:DIRECTION_OUT };
    sql:Parameter paraBool = { sqlType: sql:TYPE_BOOLEAN, direction: sql:DIRECTION_OUT };
    sql:Parameter paraString = { sqlType: sql:TYPE_VARCHAR, direction: sql:DIRECTION_OUT };
    sql:Parameter paraNumeric = { sqlType: sql:TYPE_NUMERIC, direction: sql:DIRECTION_OUT };
    sql:Parameter paraDecimal = { sqlType: sql:TYPE_DECIMAL, direction: sql:DIRECTION_OUT };
    sql:Parameter paraReal = { sqlType: sql:TYPE_REAL, direction: sql:DIRECTION_OUT };
    sql:Parameter paraTinyInt = { sqlType: sql:TYPE_TINYINT, direction: sql:DIRECTION_OUT };
    sql:Parameter paraSmallInt = { sqlType: sql:TYPE_SMALLINT, direction: sql:DIRECTION_OUT };
    sql:Parameter paraClob = { sqlType: sql:TYPE_CLOB, direction: sql:DIRECTION_OUT };
    sql:Parameter paraBinary = { sqlType: sql:TYPE_BINARY, direction: sql:DIRECTION_OUT };

    _ = testDB->call("{call TestOutParams(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}", (),
        paraID, paraInt, paraLong, paraFloat, paraDouble, paraBool, paraString, paraNumeric,
        paraDecimal, paraReal, paraTinyInt, paraSmallInt, paraClob, paraBinary);

    testDB.stop();

    return (paraInt.value, paraLong.value, paraFloat.value, paraDouble.value, paraBool.value, paraString.value,
    paraNumeric.value, paraDecimal.value, paraReal.value, paraTinyInt.value, paraSmallInt.value, paraClob.value,
    paraBinary.value);
}

function testBlobOutInOutParameters() returns (any, any) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    // OUT param
    sql:Parameter paraID1 = { sqlType: sql:TYPE_INTEGER, value: "1" };
    sql:Parameter paraBlobOut = { sqlType: sql:TYPE_BLOB, direction: sql:DIRECTION_OUT };

    // INOUT param
    sql:Parameter paraID2 = { sqlType: sql:TYPE_INTEGER, value: 5 };
    sql:Parameter paraBlobInOut = { sqlType: sql:TYPE_BLOB, value: "YmxvYiBkYXRh", direction: sql:DIRECTION_INOUT };

    _ = testDB->call("{call TestOUTINOUTParamsBlob(?,?,?,?)}", (), paraID1, paraID2, paraBlobOut, paraBlobInOut);

    testDB.stop();

    return (paraBlobOut.value, paraBlobInOut.value);
}

function testNullOutParameters() returns (any, any, any, any, any, any,
            any, any, any, any, any, any, any) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    sql:Parameter paraID = { sqlType: sql:TYPE_INTEGER, value: "2" };
    sql:Parameter paraInt = { sqlType: sql:TYPE_INTEGER, direction: sql:DIRECTION_OUT };
    sql:Parameter paraLong = { sqlType: sql:TYPE_BIGINT, direction: sql:DIRECTION_OUT };
    sql:Parameter paraFloat = { sqlType: sql:TYPE_FLOAT, direction: sql:DIRECTION_OUT };
    sql:Parameter paraDouble = { sqlType: sql:TYPE_DOUBLE, direction: sql:DIRECTION_OUT };
    sql:Parameter paraBool = { sqlType: sql:TYPE_BOOLEAN, direction: sql:DIRECTION_OUT };
    sql:Parameter paraString = { sqlType: sql:TYPE_VARCHAR, direction: sql:DIRECTION_OUT };
    sql:Parameter paraNumeric = { sqlType: sql:TYPE_NUMERIC, direction: sql:DIRECTION_OUT };
    sql:Parameter paraDecimal = { sqlType: sql:TYPE_DECIMAL, direction: sql:DIRECTION_OUT };
    sql:Parameter paraReal = { sqlType: sql:TYPE_REAL, direction: sql:DIRECTION_OUT };
    sql:Parameter paraTinyInt = { sqlType: sql:TYPE_TINYINT, direction: sql:DIRECTION_OUT };
    sql:Parameter paraSmallInt = { sqlType: sql:TYPE_SMALLINT, direction: sql:DIRECTION_OUT };
    sql:Parameter paraClob = { sqlType: sql:TYPE_CLOB, direction: sql:DIRECTION_OUT };
    sql:Parameter paraBinary = { sqlType: sql:TYPE_BINARY, direction: sql:DIRECTION_OUT };

    _ = testDB->call("{call TestOutParams(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}", (),
        paraID, paraInt, paraLong, paraFloat, paraDouble, paraBool, paraString, paraNumeric,
        paraDecimal, paraReal, paraTinyInt, paraSmallInt, paraClob, paraBinary);
    testDB.stop();
    return (paraInt.value, paraLong.value, paraFloat.value, paraDouble.value, paraBool.value, paraString.value,
    paraNumeric.value, paraDecimal.value, paraReal.value, paraTinyInt.value, paraSmallInt.value, paraClob.value,
    paraBinary.value);
}

function testNullOutInOutBlobParameters() returns (any, any) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    // OUT params
    sql:Parameter paraID1 = { sqlType: sql:TYPE_INTEGER, value: "2" };
    sql:Parameter paraBlobOut = { sqlType: sql:TYPE_BLOB, direction: sql:DIRECTION_OUT };

    // INOUT params
    sql:Parameter paraID2 = { sqlType: sql:TYPE_INTEGER, value: "6" };
    sql:Parameter paraBlobInOut = { sqlType: sql:TYPE_BLOB, direction: sql:DIRECTION_INOUT };

    _ = testDB->call("{call TestOUTINOUTParamsBlob(?,?,?,?)}", (), paraID1, paraID2, paraBlobOut, paraBlobInOut);
    testDB.stop();
    return (paraBlobOut.value, paraBlobInOut.value);
}

function testINParameters() returns (int) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    sql:Parameter paraID = { sqlType: sql:TYPE_INTEGER, value: 3 };
    sql:Parameter paraInt = { sqlType: sql:TYPE_INTEGER, value: 1 };
    sql:Parameter paraLong = { sqlType: sql:TYPE_BIGINT, value: 9223372036854774807 };
    sql:Parameter paraFloat = { sqlType: sql:TYPE_FLOAT, value: 123.34 };
    sql:Parameter paraDouble = { sqlType: sql:TYPE_DOUBLE, value: 2139095039 };
    sql:Parameter paraBool = { sqlType: sql:TYPE_BOOLEAN, value: true };
    sql:Parameter paraString = { sqlType: sql:TYPE_VARCHAR, value: "Hello" };
    sql:Parameter paraNumeric = { sqlType: sql:TYPE_NUMERIC, value: 1234.567 };
    sql:Parameter paraDecimal = { sqlType: sql:TYPE_DECIMAL, value: 1234.567 };
    sql:Parameter paraReal = { sqlType: sql:TYPE_REAL, value: 1234.567 };
    sql:Parameter paraTinyInt = { sqlType: sql:TYPE_TINYINT, value: 1 };
    sql:Parameter paraSmallInt = { sqlType: sql:TYPE_SMALLINT, value: 5555 };
    sql:Parameter paraClob = { sqlType: sql:TYPE_CLOB, value: "very long text" };
    sql:Parameter paraBinary = { sqlType: sql:TYPE_BINARY, value: "d3NvMiBiYWxsZXJpbmEgYmluYXJ5IHRlc3Qu" };

    var result = testDB->update("INSERT INTO DataTypeTable (row_id,int_type, long_type,
            float_type, double_type, boolean_type, string_type, numeric_type, decimal_type, real_type, tinyint_type,
            smallint_type, clob_type, binary_type) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
        paraID, paraInt, paraLong, paraFloat, paraDouble, paraBool, paraString, paraNumeric,
        paraDecimal, paraReal, paraTinyInt, paraSmallInt, paraClob, paraBinary);
    int insertCount = getIntResult(result);
    testDB.stop();
    return insertCount;
}

function testBlobInParameter() returns (int, byte[]) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    sql:Parameter paraID = { sqlType: sql:TYPE_INTEGER, value: 3 };
    sql:Parameter paraBlob = { sqlType: sql:TYPE_BLOB, value: "YmxvYiBkYXRh" };

    byte[] blobVal = [];

    var result = testDB->update("INSERT INTO BlobTable (row_id,blob_type) VALUES (?,?)",
        paraID, paraBlob);
    int insertCount = getIntResult(result);
    var dt = testDB->select("SELECT blob_type from BlobTable where row_id=3", ResultBlob);
    if (dt is table<ResultBlob>) {
        while (dt.hasNext()) {
            var rs = dt.getNext();
            if (rs is ResultBlob) {
                blobVal = rs.BLOB_TYPE;
            }
        }
    }
    testDB.stop();
    return (insertCount, blobVal);
}

function testINParametersWithDirectValues() returns (int, int, float,
        float, boolean, string, float, float, float) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    var result = testDB->update("INSERT INTO DataTypeTable (row_id, int_type, long_type, float_type,
        double_type, boolean_type, string_type, numeric_type, decimal_type, real_type) VALUES (?,?,?,?,?,?,?,?,?,?)",
        25, 1, 9223372036854774807, 123.34, 2139095039.1, true, "Hello", 1234.567, 1234.567, 1234.567);
    int insertCount = getIntResult(result);
    var dt = testDB->select("SELECT int_type, long_type,
            float_type, double_type, boolean_type, string_type, numeric_type, decimal_type, real_type from
            DataTypeTable where row_id = 25", ResultBalTypes);
    int i = -1;
    int l = -1;
    float f = -1;
    float d = -1;
    boolean b = false;
    string s = "";
    float n = -1;
    float dec = -1;
    float real = -1;
    if (dt is table<ResultBalTypes>) {
        while (dt.hasNext()) {
            var rs = dt.getNext();
            if (rs is ResultBalTypes) {
                i = rs.INT_TYPE;
                l = rs.LONG_TYPE;
                f = rs.FLOAT_TYPE;
                d = rs.DOUBLE_TYPE;
                s = rs.STRING_TYPE;
                n = rs.NUMERIC_TYPE;
                dec = rs.DECIMAL_TYPE;
                real = rs.REAL_TYPE;
            }
        }
    }
    testDB.stop();
    return (i, l, f, d, b, s, n, dec, real);
}

function testINParametersWithDirectVariables() returns (int, int, float,
        float, boolean, string, float, float, float) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    int rowid = 26;
    int intType = 1;
    int longType = 9223372036854774807;
    float floatType = 123.34;
    float doubleType = 2139095039.1;
    boolean boolType = true;
    string stringType = "Hello";
    float numericType = 1234.567;
    float decimalType = 1234.567;
    float realType = 1234.567;

    var result = testDB->update("INSERT INTO DataTypeTable (row_id, int_type, long_type,
            float_type, double_type, boolean_type, string_type, numeric_type, decimal_type, real_type)
            VALUES (?,?,?,?,?,?,?,?,?,?)", rowid, intType, longType, floatType, doubleType, boolType,
            stringType, numericType, decimalType, realType);
    int insertCount = getIntResult(result);
    var dt = testDB->select("SELECT int_type, long_type,
            float_type, double_type, boolean_type, string_type, numeric_type, decimal_type, real_type from
            DataTypeTable where row_id = 26", ResultBalTypes);
    int i = -1;
    int l = -1;
    float f = -1;
    float d = -1;
    boolean b = false;
    string s = "";
    float n = -1;
    float dec = -1;
    float real = -1;

    if (dt is table<ResultBalTypes>) {
        while (dt.hasNext()) {
            var rs = dt.getNext();
            if (rs is ResultBalTypes) {
                i = rs.INT_TYPE;
                l = rs.LONG_TYPE;
                f = rs.FLOAT_TYPE;
                d = rs.DOUBLE_TYPE;
                s = rs.STRING_TYPE;
                n = rs.NUMERIC_TYPE;
                dec = rs.DECIMAL_TYPE;
                real = rs.REAL_TYPE;
            }
        }
    }
    testDB.stop();
    return (i, l, f, d, b, s, n, dec, real);
}

function testNullINParameterValues() returns (int) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    sql:Parameter paraID = { sqlType: sql:TYPE_INTEGER, value: 4 };
    sql:Parameter paraInt = { sqlType: sql:TYPE_INTEGER, value: () };
    sql:Parameter paraLong = { sqlType: sql:TYPE_BIGINT, value: () };
    sql:Parameter paraFloat = { sqlType: sql:TYPE_FLOAT, value: () };
    sql:Parameter paraDouble = { sqlType: sql:TYPE_DOUBLE, value: () };
    sql:Parameter paraBool = { sqlType: sql:TYPE_BOOLEAN, value: () };
    sql:Parameter paraString = { sqlType: sql:TYPE_VARCHAR, value: () };
    sql:Parameter paraNumeric = { sqlType: sql:TYPE_NUMERIC, value: () };
    sql:Parameter paraDecimal = { sqlType: sql:TYPE_DECIMAL, value: () };
    sql:Parameter paraReal = { sqlType: sql:TYPE_REAL, value: () };
    sql:Parameter paraTinyInt = { sqlType: sql:TYPE_TINYINT, value: () };
    sql:Parameter paraSmallInt = { sqlType: sql:TYPE_SMALLINT, value: () };
    sql:Parameter paraClob = { sqlType: sql:TYPE_CLOB, value: () };
    sql:Parameter paraBinary = { sqlType: sql:TYPE_BINARY, value: () };

    var result = testDB->update("INSERT INTO DataTypeTable (row_id, int_type, long_type,
            float_type, double_type, boolean_type, string_type, numeric_type, decimal_type, real_type, tinyint_type,
            smallint_type, clob_type, binary_type) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
        paraID, paraInt, paraLong, paraFloat, paraDouble, paraBool, paraString, paraNumeric,
        paraDecimal, paraReal, paraTinyInt, paraSmallInt, paraClob, paraBinary);
    int insertCount = getIntResult(result);
    testDB.stop();
    return insertCount;
}

function testNullINParameterBlobValue() returns (int) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    sql:Parameter paraID = { sqlType: sql:TYPE_INTEGER, value: 4 };
    sql:Parameter paraBlob = { sqlType: sql:TYPE_BLOB, value: () };

    var result = testDB->update("INSERT INTO BlobTable (row_id, blob_type) VALUES (?,?)",
        paraID, paraBlob);
    int insertCount = getIntResult(result);
    testDB.stop();
    return insertCount;
}

function testINOutParameters() returns (any, any, any, any, any, any,
            any, any, any, any, any, any, any) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    sql:Parameter paraID = { sqlType: sql:TYPE_INTEGER, value: 5 };
    sql:Parameter paraInt = { sqlType: sql:TYPE_INTEGER, value: 10, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraLong = { sqlType: sql:TYPE_BIGINT, value: "9223372036854774807", direction: sql:DIRECTION_INOUT };
    sql:Parameter paraFloat = { sqlType: sql:TYPE_REAL, value: 123.34, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraDouble = { sqlType: sql:TYPE_DOUBLE, value: 2139095039, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraBool = { sqlType: sql:TYPE_BOOLEAN, value: true, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraString = { sqlType: sql:TYPE_VARCHAR, value: "Hello", direction: sql:DIRECTION_INOUT };
    sql:Parameter paraNumeric = { sqlType: sql:TYPE_NUMERIC, value: 1234.567, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraDecimal = { sqlType: sql:TYPE_DECIMAL, value: 1234.567, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraReal = { sqlType: sql:TYPE_REAL, value: 1234.567, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraTinyInt = { sqlType: sql:TYPE_TINYINT, value: 1, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraSmallInt = { sqlType: sql:TYPE_SMALLINT, value: 5555, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraClob = { sqlType: sql:TYPE_CLOB, value: "very long text", direction: sql:DIRECTION_INOUT };
    sql:Parameter paraBinary = { sqlType: sql:TYPE_BINARY, value: "d3NvMiBiYWxsZXJpbmEgYmluYXJ5IHRlc3Qu", direction: sql
    :
    DIRECTION_INOUT };

    _ = testDB->call("{call TestINOUTParams(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}", (),
        paraID, paraInt, paraLong, paraFloat, paraDouble, paraBool, paraString, paraNumeric,
        paraDecimal, paraReal, paraTinyInt, paraSmallInt, paraClob, paraBinary);
    testDB.stop();
    return (paraInt.value, paraLong.value, paraFloat.value, paraDouble.value, paraBool.value, paraString.value,
    paraNumeric.value, paraDecimal.value, paraReal.value, paraTinyInt.value, paraSmallInt.value, paraClob.value,
    paraBinary.value);
}

function testNullINOutParameters() returns (any, any, any, any, any, any
            , any, any, any, any, any, any, any) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    sql:Parameter paraID = { sqlType: sql:TYPE_INTEGER, value: "6" };
    sql:Parameter paraInt = { sqlType: sql:TYPE_INTEGER, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraLong = { sqlType: sql:TYPE_BIGINT, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraFloat = { sqlType: sql:TYPE_FLOAT, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraDouble = { sqlType: sql:TYPE_DOUBLE, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraBool = { sqlType: sql:TYPE_BOOLEAN, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraString = { sqlType: sql:TYPE_VARCHAR, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraNumeric = { sqlType: sql:TYPE_NUMERIC, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraDecimal = { sqlType: sql:TYPE_DECIMAL, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraReal = { sqlType: sql:TYPE_REAL, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraTinyInt = { sqlType: sql:TYPE_TINYINT, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraSmallInt = { sqlType: sql:TYPE_SMALLINT, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraClob = { sqlType: sql:TYPE_CLOB, direction: sql:DIRECTION_INOUT };
    sql:Parameter paraBinary = { sqlType: sql:TYPE_BINARY, direction: sql:DIRECTION_INOUT };

    _ = testDB->call("{call TestINOUTParams(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}", (),
        paraID, paraInt, paraLong, paraFloat, paraDouble, paraBool, paraString, paraNumeric,
        paraDecimal, paraReal, paraTinyInt, paraSmallInt, paraClob, paraBinary);
    testDB.stop();
    return (paraInt.value, paraLong.value, paraFloat.value, paraDouble.value, paraBool.value, paraString.value,
    paraNumeric.value, paraDecimal.value, paraReal.value, paraTinyInt.value, paraSmallInt.value, paraClob.value,
    paraBinary.value);
}

function testEmptySQLType() returns (int) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });
    var result = testDB->update("Insert into Customers (firstName) values (?)", "Anne");
    int insertCount = getIntResult(result);
    testDB.stop();
    return insertCount;
}

function testArrayOutParameters() returns (any, any, any, any, any, any)
{
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    string firstName;
    sql:Parameter para1 = { sqlType: sql:TYPE_ARRAY, direction: sql:DIRECTION_OUT };
    sql:Parameter para2 = { sqlType: sql:TYPE_ARRAY, direction: sql:DIRECTION_OUT };
    sql:Parameter para3 = { sqlType: sql:TYPE_ARRAY, direction: sql:DIRECTION_OUT };
    sql:Parameter para4 = { sqlType: sql:TYPE_ARRAY, direction: sql:DIRECTION_OUT };
    sql:Parameter para5 = { sqlType: sql:TYPE_ARRAY, direction: sql:DIRECTION_OUT };
    sql:Parameter para6 = { sqlType: sql:TYPE_ARRAY, direction: sql:DIRECTION_OUT };
    _ = testDB->call("{call TestArrayOutParams(?,?,?,?,?,?)}", (), para1, para2, para3, para4, para5, para6);
    testDB.stop();
    return (para1.value, para2.value, para3.value, para4.value, para5.value, para6.value);
}

function testArrayInOutParameters() returns (any, any, any, any, any,
            any, any) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    int[] intArray1 = [10,20,30];
    int[] intArray2 = [10000000, 20000000, 30000000];
    float[] floatArray1 = [2454.23, 55594.49, 87964.123];
    float[] floatArray2 = [2454.23, 55594.49, 87964.123];
    boolean[] booleanArray = [false, false, true];
    string[] stringArray = ["Hello","Ballerina","Lang"];

    sql:Parameter para1 = { sqlType: sql:TYPE_INTEGER, value: 3 };
    sql:Parameter para2 = { sqlType: sql:TYPE_INTEGER, direction: sql:DIRECTION_OUT };
    sql:Parameter para3 = { sqlType: sql:TYPE_ARRAY, value: intArray1, direction: sql:DIRECTION_INOUT };
    sql:Parameter para4 = { sqlType: sql:TYPE_ARRAY, value: intArray2, direction: sql:
    DIRECTION_INOUT };
    sql:Parameter para5 = { sqlType: sql:TYPE_ARRAY, value: floatArray1, direction: sql:
    DIRECTION_INOUT };
    sql:Parameter para6 = { sqlType: sql:TYPE_ARRAY, value: floatArray2, direction: sql:
    DIRECTION_INOUT };
    sql:Parameter para7 = { sqlType: sql:TYPE_ARRAY, value: booleanArray, direction: sql:DIRECTION_INOUT };
    sql:Parameter para8 = { sqlType: sql:TYPE_ARRAY, value: stringArray, direction: sql:DIRECTION_INOUT };

    _ = testDB->call("{call TestArrayInOutParams(?,?,?,?,?,?,?,?)}", (),
        para1, para2, para3, para4, para5, para6, para7, para8);

    testDB.stop();
    return (para2.value, para3.value, para4.value, para5.value, para6.value, para7.value, para8.value);
}

function testBatchUpdate() returns (int[]) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    //Batch 1
    sql:Parameter para1 = { sqlType: sql:TYPE_VARCHAR, value: "Alex" };
    sql:Parameter para2 = { sqlType: sql:TYPE_VARCHAR, value: "Smith" };
    sql:Parameter para3 = { sqlType: sql:TYPE_INTEGER, value: 20 };
    sql:Parameter para4 = { sqlType: sql:TYPE_DOUBLE, value: 3400.5 };
    sql:Parameter para5 = { sqlType: sql:TYPE_VARCHAR, value: "Colombo" };
    sql:Parameter[] parameters1 = [para1, para2, para3, para4, para5];

    //Batch 2
    para1 = { sqlType: sql:TYPE_VARCHAR, value: "Alex" };
    para2 = { sqlType: sql:TYPE_VARCHAR, value: "Smith" };
    para3 = { sqlType: sql:TYPE_INTEGER, value: 20 };
    para4 = { sqlType: sql:TYPE_DOUBLE, value: 3400.5 };
    para5 = { sqlType: sql:TYPE_VARCHAR, value: "Colombo" };
    sql:Parameter[] parameters2 = [para1, para2, para3, para4, para5];

    var ret = testDB->batchUpdate("Insert into Customers (firstName,lastName,registrationID,creditLimit,country)
                                     values (?,?,?,?,?)", parameters1, parameters2);
    int[] updateCount = getBatchUpdateCount(ret);
    testDB.stop();
    return updateCount;
}

type myBatchType string|int|float;

function testBatchUpdateWithValues() returns int[] {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    //Batch 1
    myBatchType[] parameters1 = ["Alex", "Smith", 20, 3400.5, "Colombo"];

    //Batch 2
    myBatchType[] parameters2 = ["John", "Gates", 45, 2400.5, "NY"];

    var ret = testDB->batchUpdate("Insert into Customers (firstName,lastName,registrationID,
                            creditLimit,country) values (?,?,?,?,?)", parameters1, parameters2);
    int[] updateCount = getBatchUpdateCount(ret);
    testDB.stop();
    return updateCount;
}

function testBatchUpdateWithVariables() returns int[] {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    //Batch 1
    string firstName1 = "Alex";
    string lastName1 = "Smith";
    int id = 20;
    float creditlimit = 3400.5;
    string city = "Colombo";

    myBatchType[] parameters1 = [firstName1, lastName1, id, creditlimit, city];

    //Batch 2
    myBatchType[] parameters2 = ["John", "Gates", 45, 2400.5, "NY"];

    var ret = testDB->batchUpdate("Insert into Customers (firstName,lastName,registrationID,
                            creditLimit,country) values (?,?,?,?,?)", parameters1, parameters2);
    int[] updateCount = getBatchUpdateCount(ret);
    testDB.stop();
    return updateCount;
}

function testBatchUpdateWithFailure() returns (int[], int) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    //Batch 1
    sql:Parameter para0 = { sqlType: sql:TYPE_INTEGER, value: 111 };
    sql:Parameter para1 = { sqlType: sql:TYPE_VARCHAR, value: "Alex" };
    sql:Parameter para2 = { sqlType: sql:TYPE_VARCHAR, value: "Smith" };
    sql:Parameter para3 = { sqlType: sql:TYPE_INTEGER, value: 20 };
    sql:Parameter para4 = { sqlType: sql:TYPE_DOUBLE, value: 3400.5 };
    sql:Parameter para5 = { sqlType: sql:TYPE_VARCHAR, value: "Colombo" };
    sql:Parameter[] parameters1 = [para0, para1, para2, para3, para4, para5];

    //Batch 2
    para0 = { sqlType: sql:TYPE_INTEGER, value: 222 };
    para1 = { sqlType: sql:TYPE_VARCHAR, value: "Alex" };
    para2 = { sqlType: sql:TYPE_VARCHAR, value: "Smith" };
    para3 = { sqlType: sql:TYPE_INTEGER, value: 20 };
    para4 = { sqlType: sql:TYPE_DOUBLE, value: 3400.5 };
    para5 = { sqlType: sql:TYPE_VARCHAR, value: "Colombo" };
    sql:Parameter[] parameters2 = [para0, para1, para2, para3, para4, para5];

    //Batch 3
    para0 = { sqlType: sql:TYPE_INTEGER, value: 222 };
    para1 = { sqlType: sql:TYPE_VARCHAR, value: "Alex" };
    para2 = { sqlType: sql:TYPE_VARCHAR, value: "Smith" };
    para3 = { sqlType: sql:TYPE_INTEGER, value: 20 };
    para4 = { sqlType: sql:TYPE_DOUBLE, value: 3400.5 };
    para5 = { sqlType: sql:TYPE_VARCHAR, value: "Colombo" };
    sql:Parameter[] parameters3 = [para0, para1, para2, para3, para4, para5];

    //Batch 4
    para0 = { sqlType: sql:TYPE_INTEGER, value: 333 };
    para1 = { sqlType: sql:TYPE_VARCHAR, value: "Alex" };
    para2 = { sqlType: sql:TYPE_VARCHAR, value: "Smith" };
    para3 = { sqlType: sql:TYPE_INTEGER, value: 20 };
    para4 = { sqlType: sql:TYPE_DOUBLE, value: 3400.5 };
    para5 = { sqlType: sql:TYPE_VARCHAR, value: "Colombo" };
    sql:Parameter[] parameters4 = [para0, para1, para2, para3, para4, para5];

    var ret = testDB->batchUpdate("Insert into Customers (customerId, firstName,lastName,registrationID,
        creditLimit, country) values (?,?,?,?,?,?)", parameters1, parameters2, parameters3, parameters4);
    int[] updateCount = getBatchUpdateCount(ret);
    var dt = testDB->select("SELECT count(*) as countval from Customers where customerId in (111,222,333)",
        ResultCount);
    int count = getTableCountValColumn(dt);
    testDB.stop();
    return (updateCount, count);
}

function testBatchUpdateWithNullParam() returns (int[]) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    var ret = testDB->batchUpdate("Insert into Customers (firstName,lastName,registrationID,creditLimit,country)
                                     values ('Alex','Smith',20,3400.5,'Colombo')");
    int[] updateCount = getBatchUpdateCount(ret);
    testDB.stop();
    return updateCount;
}

function testDateTimeInParameters() returns (int[]) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    string stmt =
    "Insert into DateTimeTypes(row_id,date_type,time_type,datetime_type,timestamp_type) values (?,?,?,?,?)";
    int[] returnValues = [];
    sql:Parameter para1 = { sqlType: sql:TYPE_INTEGER, value: 100 };
    sql:Parameter para2 = { sqlType: sql:TYPE_DATE, value: "2017-01-30-08:01" };
    sql:Parameter para3 = { sqlType: sql:TYPE_TIME, value: "13:27:01.999999+08:33" };
    sql:Parameter para4 = { sqlType: sql:TYPE_TIMESTAMP, value: "2017-01-30T13:27:01.999-08:00" };
    sql:Parameter para5 = { sqlType: sql:TYPE_DATETIME, value: "2017-01-30T13:27:01.999999Z" };

    var result1 = testDB->update(stmt, para1, para2, para3, para4, para5);
    int insertCount1 = getIntResult(result1);

    returnValues[0] = insertCount1;

    para1 = { sqlType: sql:TYPE_INTEGER, value: 200 };
    para2 = { sqlType: sql:TYPE_DATE, value: "-2017-01-30Z" };
    para3 = { sqlType: sql:TYPE_TIME, value: "13:27:01+08:33" };
    para4 = { sqlType: sql:TYPE_TIMESTAMP, value: "2017-01-30T13:27:01.999" };
    para5 = { sqlType: sql:TYPE_DATETIME, value: "-2017-01-30T13:27:01.999999-08:30" };

    var result2 = testDB->update(stmt, para1, para2, para3, para4, para5);
    int insertCount2 = getIntResult(result2);

    returnValues[1] = insertCount2;

    time:Time timeNow = time:currentTime();
    para1 = { sqlType: sql:TYPE_INTEGER, value: 300 };
    para2 = { sqlType: sql:TYPE_DATE, value: timeNow };
    para3 = { sqlType: sql:TYPE_TIME, value: timeNow };
    para4 = { sqlType: sql:TYPE_TIMESTAMP, value: timeNow };
    para5 = { sqlType: sql:TYPE_DATETIME, value: timeNow };

    var result3 = testDB->update(stmt, para1, para2, para3, para4, para5);
    int insertCount3 = getIntResult(result3);
    returnValues[2] = insertCount3;

    testDB.stop();
    return returnValues;
}

function testDateTimeNullInValues() returns (string) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    sql:Parameter para0 = { sqlType: sql:TYPE_INTEGER, value: 33 };
    sql:Parameter para1 = { sqlType: sql:TYPE_DATE, value: () };
    sql:Parameter para2 = { sqlType: sql:TYPE_TIME, value: () };
    sql:Parameter para3 = { sqlType: sql:TYPE_TIMESTAMP, value: () };
    sql:Parameter para4 = { sqlType: sql:TYPE_DATETIME, value: () };
    sql:Parameter[] parameters = [para0, para1, para2, para3, para4];

    _ = testDB->update("Insert into DateTimeTypes
        (row_id, date_type, time_type, timestamp_type, datetime_type) values (?,?,?,?,?)",
        para0, para1, para2, para3, para4);
    var dt = testDB->select("SELECT date_type, time_type, timestamp_type, datetime_type
                from DateTimeTypes where row_id = 33", ResultDates);
    json j = getJsonConversionResult(dt);
    string data = io:sprintf("%s", j);
    testDB.stop();
    return data;
}

function testDateTimeNullOutValues() returns (int) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    sql:Parameter para1 = { sqlType: sql:TYPE_INTEGER, value: 123 };
    sql:Parameter para2 = { sqlType: sql:TYPE_DATE, value: () };
    sql:Parameter para3 = { sqlType: sql:TYPE_TIME, value: () };
    sql:Parameter para4 = { sqlType: sql:TYPE_TIMESTAMP, value: () };
    sql:Parameter para5 = { sqlType: sql:TYPE_DATETIME, value: () };

    sql:Parameter para6 = { sqlType: sql:TYPE_DATE, direction: sql:DIRECTION_OUT };
    sql:Parameter para7 = { sqlType: sql:TYPE_TIME, direction: sql:DIRECTION_OUT };
    sql:Parameter para8 = { sqlType: sql:TYPE_TIMESTAMP, direction: sql:DIRECTION_OUT };
    sql:Parameter para9 = { sqlType: sql:TYPE_DATETIME, direction: sql:DIRECTION_OUT };

    _ = testDB->call("{call TestDateTimeOutParams(?,?,?,?,?,?,?,?,?)}", (),
        para1, para2, para3, para4, para5, para6, para7, para8, para9);

    var dt = testDB->select("SELECT count(*) as countval from DateTimeTypes where row_id = 123", ResultCount);
    int count = getTableCountValColumn(dt);
    testDB.stop();
    return count;
}

function testDateTimeNullInOutValues() returns (any, any, any, any) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    sql:Parameter para1 = { sqlType: sql:TYPE_INTEGER, value: 124 };
    sql:Parameter para2 = { sqlType: sql:TYPE_DATE, value: null, direction: sql:DIRECTION_INOUT };
    sql:Parameter para3 = { sqlType: sql:TYPE_TIME, value: null, direction: sql:DIRECTION_INOUT };
    sql:Parameter para4 = { sqlType: sql:TYPE_TIMESTAMP, value: null, direction: sql:DIRECTION_INOUT };
    sql:Parameter para5 = { sqlType: sql:TYPE_DATETIME, value: null, direction: sql:DIRECTION_INOUT };

    _ = testDB->call("{call TestDateINOUTParams(?,?,?,?,?)}", (), para1, para2, para3, para4, para5);
    testDB.stop();
    return (para2.value, para3.value, para4.value, para5.value);
}

function testDateTimeOutParams(int time, int date, int timestamp)
             returns (int) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    sql:Parameter para1 = { sqlType: sql:TYPE_INTEGER, value: 10 };
    sql:Parameter para2 = { sqlType: sql:TYPE_DATE, value: date };
    sql:Parameter para3 = { sqlType: sql:TYPE_TIME, value: time };
    sql:Parameter para4 = { sqlType: sql:TYPE_TIMESTAMP, value: timestamp };
    sql:Parameter para5 = { sqlType: sql:TYPE_DATETIME, value: timestamp };

    sql:Parameter para6 = { sqlType: sql:TYPE_DATE, direction: sql:DIRECTION_OUT };
    sql:Parameter para7 = { sqlType: sql:TYPE_TIME, direction: sql:DIRECTION_OUT };
    sql:Parameter para8 = { sqlType: sql:TYPE_TIMESTAMP, direction: sql:DIRECTION_OUT };
    sql:Parameter para9 = { sqlType: sql:TYPE_DATETIME, direction: sql:DIRECTION_OUT };

    sql:Parameter[] parameters = [para1, para2, para3, para4, para5, para6, para7, para8, para9];

    _ = testDB->call("{call TestDateTimeOutParams(?,?,?,?,?,?,?,?,?)}", (),
        para1, para2, para3, para4, para5, para6, para7, para8, para9);

    var dt = testDB->select("SELECT count(*) as countval from DateTimeTypes where row_id = 10", ResultCount);
    int count = getTableCountValColumn(dt);
    testDB.stop();
    return count;
}

function testStructOutParameters() returns (any) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    sql:Parameter para1 = { sqlType: sql:TYPE_STRUCT, direction: sql:DIRECTION_OUT };
    _ = testDB->call("{call TestStructOut(?)}", (), para1);
    testDB.stop();
    return para1.value;
}

function testComplexTypeRetrieval() returns (string, string, string,
            string) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    string s1;
    string s2;
    string s3;
    string s4;

    var dt1 = testDB->select("SELECT * from BlobTable where row_id = 1", ());
    xml x1 = getXMLConversionResult(dt1);
    s1 = io:sprintf("%s", x1);

    var dt2 = testDB->select("SELECT * from DateTimeTypes where row_id = 1", ());
    xml x2 = getXMLConversionResult(dt2);
    s2 = io:sprintf("%s", x2);

    var dt3 = testDB->select("SELECT * from BlobTable where row_id = 1", ());
    json j = getJsonConversionResult(dt3);
    s3 = io:sprintf("%s", j);

    var dt4 = testDB->select("SELECT * from DateTimeTypes where row_id = 1", ());
    j = getJsonConversionResult(dt4);
    s4 = io:sprintf("%s", j);

    testDB.stop();
    return (s1, s2, s3, s4);
}

function testSelectLoadToMemory() returns (CustomerFullName[],
            CustomerFullName[], CustomerFullName[]) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    var dt = testDB->select(
        "SELECT firstName, lastName from Customers where registrationID < 3", CustomerFullName , loadToMemory = true);

    CustomerFullName[] fullNameArray1 = [];
    CustomerFullName[] fullNameArray2 = [];
    CustomerFullName[] fullNameArray3 = [];

    if (dt is table<CustomerFullName>) {
        int i = 0;
        foreach var x in dt {
            fullNameArray1[i] = x;
            i += 1;
        }
        i = 0;
        foreach var x in dt {
            fullNameArray2[i] = x;
            i += 1;
        }
        i = 0;
        foreach var x in dt {
            fullNameArray3[i] = x;
            i += 1;
        }
    }
    testDB.stop();
    return (fullNameArray1, fullNameArray2, fullNameArray3);
}

function testLoadToMemorySelectAfterTableClose() returns (
            CustomerFullName[], CustomerFullName[], error?) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });

    var dt = testDB->select(
        "SELECT firstName, lastName from Customers where registrationID < 3", CustomerFullName, loadToMemory = true);

    CustomerFullName[] fullNameArray1 = [];
    CustomerFullName[] fullNameArray2 = [];
    error? e = ();
    if (dt is table<CustomerFullName>) {
        fullNameArray1 = iterateTableAndReturnResultArray(dt);
        fullNameArray2 = iterateTableAndReturnResultArray(dt);
        CustomerFullName[] fullNameArray3 = [];
        dt.close();

        var ret = trap iterateTableAndReturnResultArray(dt);

        if (ret is CustomerFullName[]) {
            fullNameArray3 = ret;
        } else if (ret is error) {
            e = ret;
        }
    }
    testDB.stop();
    return (fullNameArray1, fullNameArray2, e);
}

function iterateTableAndReturnResultArray(table<CustomerFullName> dt) returns CustomerFullName[] {
    CustomerFullName[] fullNameArray = [];
    int i = 0;
    foreach var x in dt {
        fullNameArray[i] = x;
        i += 1;
    }
    return fullNameArray;
}

function testCloseConnectionPool(string connectionCountQuery)
             returns (int) {
    h2:Client testDB = new({
            path: "./target/tempdb/",
            name: "TEST_SQL_CONNECTOR_H2",
            username: "SA",
            password: "",
            poolOptions: { maximumPoolSize: 1 }
        });
    var dt = testDB->select(connectionCountQuery, ResultCount);
    int count = getTableCountValColumn(dt);
    testDB.stop();
    return count;
}

function getIntResult(int|error result) returns int {
    if (result is int) {
        return result;
    }
    return -1;
}

function getTableCountValColumn(table<record {}>|error result) returns int {
    int count = -1;
    if (result is table<record {}>) {
        while (result.hasNext()) {
            var rs = result.getNext();
            if (rs is ResultCount) {
                count = rs.COUNTVAL;
            }
        }
        return count;
    }
    return -1;
}

function getTableFirstNameColumn(table<record {}>|error result) returns string {
    if (result is table<record {}>) {
        string firstName= "";
        while (result.hasNext()) {
            var rs = result.getNext();
            if (rs is ResultCustomers) {
                firstName = rs.FIRSTNAME;
            }
        }
        return firstName;
    }
    return "";
}

function getBatchUpdateCount(int[]|error result) returns int[] {
    if (result is int[]) {
        return result;
    }
    return [];
}

function getJsonConversionResult(table<record {}>|error tableOrError) returns json {
    json retVal = {};
    if (tableOrError is table<record {}>) {
        var jsonConversionResult = json.convert(tableOrError);
        if (jsonConversionResult is json) {
            retVal = jsonConversionResult;
        } else if (jsonConversionResult is error) {
            retVal = {"Error" : string.convert(jsonConversionResult.detail().message)};
        }
    } else if (tableOrError is error) {
        retVal = {"Error" : string.convert(tableOrError.detail().message)};
    }
    return retVal;
}

function getXMLConversionResult(table<record {}>|error tableOrError) returns xml {
    xml retVal = xml `<Error/>`;
    if (tableOrError is table<record {}>) {
        var xmlConversionResult = xml.convert(tableOrError);
        if (xmlConversionResult is xml) {
            retVal = xmlConversionResult;
        } else if (xmlConversionResult is error) {
            string errorXML = string.convert(xmlConversionResult.detail().message);
            retVal = xml `<Error>{{errorXML}}</Error>`;
        }
    } else if (tableOrError is error) {
        string errorXML = string.convert(tableOrError.detail().message);
        retVal = xml `<Error>{{errorXML}}</Error>`;
    }
    return retVal;
}
