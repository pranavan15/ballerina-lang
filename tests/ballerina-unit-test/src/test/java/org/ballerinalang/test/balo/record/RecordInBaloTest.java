/*
 * Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.ballerinalang.test.balo.record;

import org.ballerinalang.launcher.util.BCompileUtil;
import org.ballerinalang.launcher.util.BRunUtil;
import org.ballerinalang.launcher.util.CompileResult;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.test.balo.BaloCreator;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import static org.testng.Assert.assertEquals;

/**
 * BALO test cases for records.
 *
 * @since 0.990.0
 */
public class RecordInBaloTest {

    @BeforeClass
    public void setup() {
        BaloCreator.createAndSetupBalo("test-src/balo/test_projects/test_project/", "testorg", "records");
    }

    @Test
    public void testRestFieldTypeDefAfterRecordDef() {
        CompileResult result = BCompileUtil.compile("test-src/record/rest_in_balo.bal");

        BValue[] returns = BRunUtil.invoke(result, "testORRestFieldInOR");
        assertEquals(returns[0].stringValue(), "{name:\"Open Foo\", ob:{x:1.0}}");

        returns = BRunUtil.invoke(result, "testORRestFieldInCR");
        assertEquals(returns[0].stringValue(), "{name:\"Closed Foo\", ob:{x:2.0}}");

        returns = BRunUtil.invoke(result, "testCRRestFieldInOR");
        assertEquals(returns[0].stringValue(), "{name:\"Open Foo\", cb:{x:3.0}}");

        returns = BRunUtil.invoke(result, "testCRRestFieldInCR");
        assertEquals(returns[0].stringValue(), "{name:\"Closed Foo\", cb:{x:4.0}}");
    }
}
