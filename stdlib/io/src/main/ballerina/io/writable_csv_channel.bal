// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.


# Represents record separator of the CSV file.
@final string CSV_RECORD_SEPERATOR = "\n";


# Represents colon separator which should be used to identify colon separated files.
@final string FS_COLON = ":";


# Represents minimum number of headers which will be included in CSV.
@final int MINIMUM_HEADER_COUNT = 0;


# Represents a WritableCSVChannel which could be used to write records from CSV file.
public type WritableCSVChannel object {
    private WritableTextRecordChannel? dc;

    # Constructs a CSV channel from a CharacterChannel to read/write CSV records.

    # + channel - ChracterChannel which will represent the content in the CSV
    # + fs - Field separator which will separate between the records in the CSV
    public new(WritableCharacterChannel characterChannel, Separator fs = ",") {
        if (fs == TAB){
            self.dc = new WritableTextRecordChannel(characterChannel, fmt = "TDF");
        } else if (fs == COLON){
            self.dc = new WritableTextRecordChannel(characterChannel, fs = FS_COLON, rs = CSV_RECORD_SEPERATOR);
        } else {
            self.dc = new WritableTextRecordChannel(characterChannel, fmt = "CSV");
        }
    }

    # Writes record to a given CSV file.

    # + csvRecord - A record to be written to the channel
    # + return - Returns an error if the record could not be written properly
    public function write(string[] csvRecord) returns error? {
        return self.dc.write(csvRecord);
    }

    # Closes a given CSVChannel.

    # + return - if an error is encountered
    public function close() returns error? {
        return self.dc.close();
    }
};
