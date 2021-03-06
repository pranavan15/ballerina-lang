/*
 *  Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

package org.ballerinalang.stdlib.utils;

import io.netty.buffer.ByteBufAllocator;
import io.netty.handler.codec.http.HttpHeaderNames;
import io.netty.handler.codec.http.HttpRequest;
import io.netty.handler.codec.http.multipart.DefaultHttpDataFactory;
import io.netty.handler.codec.http.multipart.FileUpload;
import io.netty.handler.codec.http.multipart.HttpDataFactory;
import io.netty.handler.codec.http.multipart.HttpPostRequestEncoder;
import io.netty.handler.codec.http.multipart.InterfaceHttpData;
import io.netty.util.internal.StringUtil;
import org.ballerinalang.launcher.util.BCompileUtil;
import org.ballerinalang.launcher.util.CompileResult;
import org.ballerinalang.mime.util.EntityBodyHandler;
import org.ballerinalang.mime.util.HeaderUtil;
import org.ballerinalang.mime.util.MimeConstants;
import org.ballerinalang.mime.util.MimeUtil;
import org.ballerinalang.model.values.BMap;
import org.ballerinalang.model.values.BString;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.model.values.BValueArray;
import org.ballerinalang.net.http.HttpConstants;
import org.ballerinalang.net.http.HttpUtil;
import org.ballerinalang.stdlib.io.channels.base.Channel;
import org.ballerinalang.stdlib.mime.FileUploadContentHolder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.wso2.carbon.messaging.Header;
import org.wso2.transport.http.netty.message.HttpCarbonMessage;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static org.ballerinalang.mime.util.MimeConstants.BODY_PARTS;
import static org.ballerinalang.mime.util.MimeConstants.CONTENT_DISPOSITION_NAME;
import static org.ballerinalang.mime.util.MimeConstants.MULTIPART_ENCODER;
import static org.ballerinalang.mime.util.MimeConstants.REQUEST_ENTITY_FIELD;
import static org.ballerinalang.mime.util.MimeConstants.TEMP_FILE_EXTENSION;
import static org.ballerinalang.mime.util.MimeConstants.TEMP_FILE_NAME;
import static org.ballerinalang.stdlib.mime.Util.getEntityStruct;
import static org.ballerinalang.stdlib.mime.Util.getMediaTypeStruct;

/**
 * Utility functions for multipart handling.
 */
public class MultipartUtils {

    private static final Logger LOG = LoggerFactory.getLogger(MultipartUtils.class);

    private static final String CARBON_MESSAGE = "CarbonMessage";
    private static final String BALLERINA_REQUEST = "BallerinaRequest";
    private static final String MULTIPART_ENTITY = "MultipartEntity";
    private static final String REQUEST_STRUCT = HttpConstants.REQUEST;
    private static final String PROTOCOL_PACKAGE_HTTP = HttpConstants.PROTOCOL_PACKAGE_HTTP;
    private static HttpDataFactory dataFactory = null;

    /**
     * Create prerequisite messages that are needed to proceed with the test cases.
     *
     * @param path                Represent path to the ballerina resource
     * @param topLevelContentType Content type that needs to be set to the top level message
     * @param result              Result of ballerina file compilation
     * @return A map of relevant messages
     */
    public static Map<String, Object> createPrerequisiteMessages(String path, String topLevelContentType,
                                                          CompileResult result) {
        Map<String, Object> messageMap = new HashMap<>();
        BMap<String, BValue> request = getRequestStruct(result);
        HTTPTestRequest cMsg = MessageUtils.generateHTTPMessageForMultiparts(path, HttpConstants.HTTP_METHOD_POST);
        HttpUtil.addCarbonMsg(request, cMsg);
        BMap<String, BValue> entity = getEntityStruct(result);
        MimeUtil.setContentType(getMediaTypeStruct(result), entity, topLevelContentType);
        messageMap.put(CARBON_MESSAGE, cMsg);
        messageMap.put(BALLERINA_REQUEST, request);
        messageMap.put(MULTIPART_ENTITY, entity);
        return messageMap;
    }

    /**
     * Create multipart entity and fill the carbon message with body parts.
     *
     * @param messageMap Represent the map of prerequisite messages
     * @param bodyParts  Represent body parts that needs to be added to multipart entity
     * @return A test carbon message to be used for invoking the service with.
     */
    public static HTTPTestRequest getCarbonMessageWithBodyParts(Map<String, Object> messageMap, BValueArray bodyParts) {
        HTTPTestRequest cMsg = (HTTPTestRequest) messageMap.get(CARBON_MESSAGE);
        BMap<String, BValue> request = (BMap<String, BValue>) messageMap.get(BALLERINA_REQUEST);
        BMap<String, BValue> entity = (BMap<String, BValue>) messageMap.get(MULTIPART_ENTITY);
        entity.addNativeData(BODY_PARTS, bodyParts);
        request.put(REQUEST_ENTITY_FIELD, entity);
        setCarbonMessageWithMultiparts(request, cMsg);
        return cMsg;
    }

    /**
     * Add body parts to carbon message.
     *
     * @param request Ballerina request struct
     * @param cMsg    Represent carbon message
     */
    private static void setCarbonMessageWithMultiparts(BMap<String, BValue> request, HTTPTestRequest cMsg) {
        prepareRequestWithMultiparts(cMsg, request);
        try {
            HttpPostRequestEncoder nettyEncoder = (HttpPostRequestEncoder) request.getNativeData(MULTIPART_ENCODER);
            addMultipartsToCarbonMessage(cMsg, nettyEncoder);
        } catch (Exception e) {
            LOG.error("Error occurred while adding multiparts to carbon message in setCarbonMessageWithMultiparts",
                    e.getMessage());
        }
    }

    /**
     * Read http content chunk by chunk from netty encoder and add it to carbon message.
     *
     * @param httpRequestMsg Represent carbon message that the content should be added to
     * @param nettyEncoder   Represent netty encoder that holds the actual http content
     * @throws Exception In case content cannot be read from netty encoder
     */
    private static void addMultipartsToCarbonMessage(HttpCarbonMessage httpRequestMsg,
            HttpPostRequestEncoder nettyEncoder) throws Exception {
        while (!nettyEncoder.isEndOfInput()) {
            httpRequestMsg.addHttpContent(nettyEncoder.readChunk(ByteBufAllocator.DEFAULT));
        }
        nettyEncoder.cleanFiles();
    }

    /**
     * Prepare carbon request message with multiparts.
     *
     * @param outboundRequest Represent outbound carbon request
     * @param requestStruct   Ballerina request struct which contains multipart data
     */
    private static void prepareRequestWithMultiparts(HttpCarbonMessage outboundRequest,
            BMap<String, BValue> requestStruct) {
        BMap<String, BValue> entityStruct = requestStruct.get(REQUEST_ENTITY_FIELD) != null ?
                (BMap<String, BValue>) requestStruct.get(REQUEST_ENTITY_FIELD) : null;
        if (entityStruct != null) {
            BValueArray bodyParts = entityStruct.getNativeData(BODY_PARTS) != null ?
                    (BValueArray) entityStruct.getNativeData(BODY_PARTS) : null;
            if (bodyParts != null) {
                HttpDataFactory dataFactory = new DefaultHttpDataFactory(DefaultHttpDataFactory.MINSIZE);
                setDataFactory(dataFactory);
                try {
                    HttpPostRequestEncoder nettyEncoder = new HttpPostRequestEncoder(dataFactory,
                            outboundRequest.getNettyHttpRequest(), true);
                    for (int i = 0; i < bodyParts.size(); i++) {
                        BMap<String, BValue> bodyPart = (BMap<String, BValue>) bodyParts.getRefValue(i);
                        encodeBodyPart(nettyEncoder, outboundRequest.getNettyHttpRequest(),
                                bodyPart);
                    }
                    nettyEncoder.finalizeRequest();
                    requestStruct.addNativeData(MULTIPART_ENCODER, nettyEncoder);
                } catch (HttpPostRequestEncoder.ErrorDataEncoderException e) {
                    LOG.error("Error occurred while creating netty request encoder for multipart data binding",
                            e.getMessage());
                }
            }
        }
    }

     /**
     * Two body parts have been wrapped inside multipart/mixed which in turn acts as the child part for the parent
     * multipart/form-data.
     *
     * @param path Resource path
     * @return HTTPTestRequest with nested parts as the entity body
     */
    public static HTTPTestRequest createNestedPartRequest(String path) {
        List<Header> headers = new ArrayList<>();
        String multipartDataBoundary = MimeUtil.getNewMultipartDelimiter();
        String multipartMixedBoundary = MimeUtil.getNewMultipartDelimiter();
        headers.add(new Header(HttpHeaderNames.CONTENT_TYPE.toString(), "multipart/form-data; boundary=" +
                multipartDataBoundary));
        String multipartBodyWithNestedParts = "--" + multipartDataBoundary + "\r\n" +
                "Content-Disposition: form-data; name=\"parent1\"" + "\r\n" +
                "Content-Type: text/plain; charset=UTF-8" + "\r\n" +
                "\r\n" +
                "Parent Part" + "\r\n" +
                "--" + multipartDataBoundary + "\r\n" +
                "Content-Disposition: form-data; name=\"parent2\"" + "\r\n" +
                "Content-Type: multipart/mixed; boundary=" + multipartMixedBoundary + "\r\n" +
                "\r\n" +
                "--" + multipartMixedBoundary + "\r\n" +
                "Content-Disposition: attachment; filename=\"file-02.txt\"" + "\r\n" +
                "Content-Type: text/plain" + "\r\n" +
                "Content-Transfer-Encoding: binary" + "\r\n" +
                "\r\n" +
                "Child Part 1" + StringUtil.NEWLINE +
                "\r\n" +
                "--" + multipartMixedBoundary + "\r\n" +
                "Content-Disposition: attachment; filename=\"file-02.txt\"" + "\r\n" +
                "Content-Type: text/plain" + "\r\n" +
                "Content-Transfer-Encoding: binary" + "\r\n" +
                "\r\n" +
                "Child Part 2" + StringUtil.NEWLINE +
                "\r\n" +
                "--" + multipartMixedBoundary + "--" + "\r\n" +
                "--" + multipartDataBoundary + "--" + "\r\n";
        return MessageUtils.generateHTTPMessage(path, HttpConstants.HTTP_METHOD_POST, headers,
                multipartBodyWithNestedParts);
    }

    /**
     * Encode a given body part and add it to multipart request encoder.
     *
     * @param nettyEncoder Helps encode multipart/form-data
     * @param httpRequest  Represent top level http request that should hold multiparts
     * @param bodyPart     Represent a ballerina body part
     * @throws HttpPostRequestEncoder.ErrorDataEncoderException when an error occurs while encoding
     */
    private static void encodeBodyPart(HttpPostRequestEncoder nettyEncoder, HttpRequest httpRequest,
            BMap<String, BValue> bodyPart)
            throws HttpPostRequestEncoder.ErrorDataEncoderException {
        try {
            InterfaceHttpData encodedData;
            Channel byteChannel = EntityBodyHandler.getByteChannel(bodyPart);
            FileUploadContentHolder contentHolder = new FileUploadContentHolder();
            contentHolder.setRequest(httpRequest);
            contentHolder.setBodyPartName(getBodyPartName(bodyPart));
            contentHolder.setFileName(TEMP_FILE_NAME + TEMP_FILE_EXTENSION);
            contentHolder.setContentType(MimeUtil.getBaseType(bodyPart));
            contentHolder.setBodyPartFormat(MimeConstants.BodyPartForm.INPUTSTREAM);
            String contentTransferHeaderValue = HeaderUtil.getHeaderValue(bodyPart,
                    HttpHeaderNames.CONTENT_TRANSFER_ENCODING
                            .toString());
            if (contentTransferHeaderValue != null) {
                contentHolder.setContentTransferEncoding(contentTransferHeaderValue);
            }
            if (byteChannel != null) {
                contentHolder.setContentStream(byteChannel.getInputStream());
                encodedData = getFileUpload(contentHolder);
                if (encodedData != null) {
                    nettyEncoder.addBodyHttpData(encodedData);
                }
            }
        } catch (IOException e) {
            LOG.error("Error occurred while encoding body part in ", e.getMessage());
        }
    }

    /**
     * Get a body part as a file upload.
     *
     * @param contentHolder Holds attributes required for creating a body part
     * @return InterfaceHttpData which represent an encoded file upload part for the given
     * @throws IOException In case an error occurs while creating file part
     */
    private static InterfaceHttpData getFileUpload(FileUploadContentHolder contentHolder)
            throws IOException {
        FileUpload fileUpload = dataFactory.createFileUpload(contentHolder.getRequest(), contentHolder.getBodyPartName()
                , contentHolder.getFileName(), contentHolder.getContentType(),
                contentHolder.getContentTransferEncoding(), contentHolder.getCharset(), contentHolder.getFileSize());
        switch (contentHolder.getBodyPartFormat()) {
        case INPUTSTREAM:
            fileUpload.setContent(contentHolder.getContentStream());
            break;
        case FILE:
            fileUpload.setContent(contentHolder.getFile());
            break;
        }
        return fileUpload;
    }

    /**
     * Set the data factory that needs to be used for encoding body parts.
     *
     * @param dataFactory which enables creation of InterfaceHttpData objects
     */
    private static void setDataFactory(HttpDataFactory dataFactory) {
        MultipartUtils.dataFactory = dataFactory;
    }

    /**
     * Get the body part name and if the user hasn't set a name set a random string as the part name.
     *
     * @param bodyPart Represent a ballerina body part
     * @return A string denoting the body part's name
     */
    private static String getBodyPartName(BMap<String, BValue> bodyPart) {
        String contentDisposition = MimeUtil.getContentDisposition(bodyPart);
        if (!contentDisposition.isEmpty()) {
            BMap<String, BValue> paramMap = HeaderUtil.getParamMap(contentDisposition);
            if (paramMap != null) {
                BString bodyPartName = paramMap.get(CONTENT_DISPOSITION_NAME) != null ?
                        (BString) paramMap.get(CONTENT_DISPOSITION_NAME) : null;
                if (bodyPartName != null) {
                    return bodyPartName.toString();
                } else {
                    return getRandomString();
                }
            } else {
                return getRandomString();
            }
        } else {
            return getRandomString();
        }
    }

    private static String getRandomString() {
        return UUID.randomUUID().toString();
    }

    private static BMap<String, BValue> getRequestStruct(CompileResult result) {
        return BCompileUtil.createAndGetStruct(result.getProgFile(), PROTOCOL_PACKAGE_HTTP, REQUEST_STRUCT);
    }
}
