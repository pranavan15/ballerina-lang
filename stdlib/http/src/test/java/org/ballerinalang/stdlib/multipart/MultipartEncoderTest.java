/*
*  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
*
*  WSO2 Inc. licenses this file to you under the Apache License,
*  Version 2.0 (the "License"); you may not use this file except
*  in compliance with the License.
*  You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
*  Unless required by applicable law or agreed to in writing,
*  software distributed under the License is distributed on an
*  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
*  KIND, either express or implied.  See the License for the
*  specific language governing permissions and limitations
*  under the License.
*/

package org.ballerinalang.stdlib.multipart;

import io.netty.handler.codec.http.HttpHeaderNames;
import org.ballerinalang.launcher.util.BCompileUtil;
import org.ballerinalang.launcher.util.BServiceUtil;
import org.ballerinalang.launcher.util.CompileResult;
import org.ballerinalang.mime.util.MimeUtil;
import org.ballerinalang.mime.util.MultipartDataSource;
import org.ballerinalang.mime.util.MultipartDecoder;
import org.ballerinalang.model.values.BMap;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.net.http.HttpConstants;
import org.ballerinalang.stdlib.utils.HTTPTestRequest;
import org.ballerinalang.stdlib.utils.MessageUtils;
import org.ballerinalang.stdlib.utils.Services;
import org.jvnet.mimepull.MIMEPart;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testng.Assert;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;
import org.wso2.transport.http.netty.message.HttpCarbonMessage;
import org.wso2.transport.http.netty.message.HttpMessageDataStreamer;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import javax.activation.MimeTypeParseException;

import static org.ballerinalang.mime.util.MimeConstants.CONTENT_DISPOSITION_FIELD;
import static org.ballerinalang.mime.util.MimeConstants.CONTENT_DISPOSITION_FILENAME_FIELD;
import static org.ballerinalang.mime.util.MimeConstants.CONTENT_DISPOSITION_NAME_FIELD;
import static org.ballerinalang.mime.util.MimeConstants.DISPOSITION_FIELD;
import static org.ballerinalang.stdlib.mime.Util.getContentDispositionStruct;
import static org.ballerinalang.stdlib.mime.Util.getEntityStruct;
import static org.ballerinalang.stdlib.mime.Util.getMultipartEntity;
import static org.ballerinalang.stdlib.mime.Util.getNestedMultipartEntity;
import static org.ballerinalang.stdlib.mime.Util.validateBodyPartContent;
import static org.ballerinalang.stdlib.utils.MultipartUtils.createNestedPartRequest;

/**
 * Unit tests for multipart encoder.
 *
 * @since 0.963.0
 */
public class MultipartEncoderTest {
    private static final Logger log = LoggerFactory.getLogger(MultipartEncoderTest.class);

    private CompileResult result, serviceResult;
    private static final String MOCK_ENDPOINT_NAME = "mockEP";

    @BeforeClass
    public void setup() {
        //Used only to get an instance of CompileResult.
        String sourceFilePath = "test-src/multipart/dummy.bal";
        result = BCompileUtil.compile(sourceFilePath);
        String sourceFilePathForServices = "test-src/multipart/multipart-response.bal";
        serviceResult = BServiceUtil.setupProgramFile(this, sourceFilePathForServices);
    }

    @Test(description = "Test whether the body parts get correctly encoded for multipart/mixed")
    public void testMultipartWriterForMixed() {
        BMap<String, BValue> multipartEntity = getMultipartEntity(result);
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        String multipartDataBoundary = MimeUtil.getNewMultipartDelimiter();
        MultipartDataSource multipartDataSource = new MultipartDataSource(multipartEntity, multipartDataBoundary);
        multipartDataSource.serialize(outputStream);
        InputStream inputStream = new ByteArrayInputStream(outputStream.toByteArray());
        try {
            List<MIMEPart> mimeParts = MultipartDecoder.decodeBodyParts("multipart/mixed; boundary=" +
                    multipartDataBoundary, inputStream);
            Assert.assertEquals(mimeParts.size(), 4);
            BMap<String, BValue> bodyPart = getEntityStruct(result);
            validateBodyPartContent(mimeParts, bodyPart);
        } catch (MimeTypeParseException e) {
            log.error("Error occurred while testing mulitpart/mixed encoding", e.getMessage());
        } catch (IOException e) {
            log.error("Error occurred while decoding binary part", e.getMessage());
        }
    }

    @Test(description = "Test whether the body parts get correctly encoded for any new multipart sub type")
    public void testMultipartWriterForNewSubTypes() {
        BMap<String, BValue> multipartEntity = getMultipartEntity(result);
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        String multipartDataBoundary = MimeUtil.getNewMultipartDelimiter();
        MultipartDataSource multipartDataSource = new MultipartDataSource(multipartEntity, multipartDataBoundary);
        multipartDataSource.serialize(outputStream);
        InputStream inputStream = new ByteArrayInputStream(outputStream.toByteArray());
        try {
            List<MIMEPart> mimeParts = MultipartDecoder.decodeBodyParts("multipart/new-sub-type; boundary=" +
                    multipartDataBoundary, inputStream);
            Assert.assertEquals(mimeParts.size(), 4);
            BMap<String, BValue> bodyPart = getEntityStruct(result);
            validateBodyPartContent(mimeParts, bodyPart);
        } catch (MimeTypeParseException e) {
            log.error("Error occurred while testing mulitpart/mixed encoding", e.getMessage());
        } catch (IOException e) {
            log.error("Error occurred while decoding binary part", e.getMessage());
        }
    }

    @Test(description = "Test whether the nested body parts within a multipart entity can be properly encoded")
    public void testNestedParts() {
        BMap<String, BValue> nestedMultipartEntity = getNestedMultipartEntity(result);
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        String multipartDataBoundary = MimeUtil.getNewMultipartDelimiter();
        MultipartDataSource multipartDataSource = new MultipartDataSource(nestedMultipartEntity, multipartDataBoundary);
        multipartDataSource.serialize(outputStream);
        InputStream inputStream = new ByteArrayInputStream(outputStream.toByteArray());
        try {
            List<MIMEPart> mimeParts = MultipartDecoder.decodeBodyParts("multipart/mixed; boundary=" +
                    multipartDataBoundary, inputStream);
            Assert.assertEquals(mimeParts.size(), 4);
            for (MIMEPart mimePart : mimeParts) {
                testNestedPartContent(mimePart);
            }
        } catch (MimeTypeParseException | IOException e) {
            log.error("Error occurred while testing encoded nested parts", e.getMessage());
        }
    }

    /**
     * When nested parts have been properly encoded, decoding should work as it should.
     *
     * @param mimePart MIMEPart that contains nested parts
     * @throws MimeTypeParseException When an error occurs while parsing body content
     * @throws IOException            When an error occurs while validating body content
     */
    private void testNestedPartContent(MIMEPart mimePart) throws MimeTypeParseException, IOException {
        List<MIMEPart> nestedParts = MultipartDecoder.decodeBodyParts(mimePart.getContentType(),
                mimePart.readOnce());
        Assert.assertEquals(nestedParts.size(), 4);
        BMap<String, BValue> ballerinaBodyPart = getEntityStruct(result);
        validateBodyPartContent(nestedParts, ballerinaBodyPart);
    }

    @Test(description = "Test whether the body part builds the ContentDisposition struct properly for " +
            "multipart/form-data")
    public void testContentDispositionForFormData() {
        BMap<String, BValue> bodyPart = getEntityStruct(result);
        BMap<String, BValue> contentDispositionStruct = getContentDispositionStruct(result);
        MimeUtil.setContentDisposition(contentDispositionStruct, bodyPart,
                "form-data; name=\"filepart\"; filename=\"file-01.txt\"");
        BMap<String, BValue> contentDisposition =
                (BMap<String, BValue>) bodyPart.get(CONTENT_DISPOSITION_FIELD);
        Assert.assertEquals(contentDisposition.get(CONTENT_DISPOSITION_FILENAME_FIELD).stringValue(),
                "file-01.txt");
        Assert.assertEquals(contentDisposition.get(CONTENT_DISPOSITION_NAME_FIELD).stringValue(),
                "filepart");
        Assert.assertEquals(contentDisposition.get(DISPOSITION_FIELD).stringValue(),
                "form-data");
    }

    @Test(description = "Test whether the encoded body parts can be sent through Response, with a given boundary")
    public void testMultipartsInOutResponse() {
        String path = "/multipart/encode_out_response";
        HTTPTestRequest inRequestMsg = MessageUtils.generateHTTPMessage(path, HttpConstants.HTTP_METHOD_GET);
        HttpCarbonMessage response = Services.invokeNew(serviceResult, MOCK_ENDPOINT_NAME, inRequestMsg);
        Assert.assertNotNull(response, "Response message not found");
        InputStream inputStream = new HttpMessageDataStreamer(response).getInputStream();
        try {
            List<MIMEPart> mimeParts = MultipartDecoder.decodeBodyParts("multipart/mixed; boundary=" +
                    "e3a0b9ad7b4e7cdb", inputStream);
            Assert.assertEquals(mimeParts.size(), 4);
            BMap<String, BValue> bodyPart = getEntityStruct(result);
            validateBodyPartContent(mimeParts, bodyPart);
        } catch (MimeTypeParseException e) {
            log.error("Error occurred while testing mulitpart/mixed encoding", e.getMessage());
        } catch (IOException e) {
            log.error("Error occurred while decoding binary part", e.getMessage());
        }
    }

    @Test(description = "Retrieve body parts from the Request and send it across Response")
    public void testNestedPartsInOutResponse() {
        String path = "/multipart/nested_parts_in_outresponse";
        HTTPTestRequest inRequestMsg = createNestedPartRequest(path);
        HttpCarbonMessage response = Services.invokeNew(serviceResult, MOCK_ENDPOINT_NAME, inRequestMsg);
        Assert.assertNotNull(response, "Response message not found");
        InputStream inputStream = new HttpMessageDataStreamer(response).getInputStream();
        try {
            List<MIMEPart> mimeParts = MultipartDecoder.decodeBodyParts(inRequestMsg.getHeader(HttpHeaderNames.
                            CONTENT_TYPE.toString()),
                    inputStream);
            Assert.assertEquals(mimeParts.size(), 2);
            List<MIMEPart> childParts = MultipartDecoder.decodeBodyParts(mimeParts.get(1).getContentType(),
                    mimeParts.get(1).readOnce());
            Assert.assertEquals(childParts.size(), 2);
        } catch (MimeTypeParseException e) {
            log.error("Error occurred while testing mulitpart/mixed encoding", e.getMessage());
        }
    }
}
