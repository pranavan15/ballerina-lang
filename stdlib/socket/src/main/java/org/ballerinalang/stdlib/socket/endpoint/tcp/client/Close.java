/*
 * Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.ballerinalang.stdlib.socket.endpoint.tcp.client;

import org.ballerinalang.bre.Context;
import org.ballerinalang.bre.bvm.BlockingNativeCallableUnit;
import org.ballerinalang.model.types.TypeKind;
import org.ballerinalang.model.values.BMap;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.natives.annotations.BallerinaFunction;
import org.ballerinalang.natives.annotations.Receiver;
import org.ballerinalang.stdlib.socket.tcp.SelectorDispatcher;
import org.ballerinalang.stdlib.socket.tcp.SelectorManager;
import org.ballerinalang.stdlib.socket.tcp.SocketService;
import org.ballerinalang.stdlib.socket.tcp.SocketUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.channels.SocketChannel;

import static org.ballerinalang.stdlib.socket.SocketConstants.CLIENT;
import static org.ballerinalang.stdlib.socket.SocketConstants.IS_CLIENT;
import static org.ballerinalang.stdlib.socket.SocketConstants.SOCKET_KEY;
import static org.ballerinalang.stdlib.socket.SocketConstants.SOCKET_PACKAGE;
import static org.ballerinalang.stdlib.socket.SocketConstants.SOCKET_SERVICE;

/**
 * 'close' method implementation of the socket caller action.
 *
 * @since 0.985.0
 */
@BallerinaFunction(
        orgName = "ballerina",
        packageName = "socket",
        functionName = "close",
        receiver = @Receiver(type = TypeKind.OBJECT, structType = CLIENT, structPackage = SOCKET_PACKAGE),
        isPublic = true
)
public class Close extends BlockingNativeCallableUnit {
    private static final Logger log = LoggerFactory.getLogger(Close.class);

    @Override
    public void execute(Context context) {
        BMap<String, BValue> clientEndpoint = (BMap<String, BValue>) context.getRefArgument(0);
        final SocketChannel socketChannel = (SocketChannel) clientEndpoint.getNativeData(SOCKET_KEY);
        try {
            // SocketChannel can be null if something happen during the onAccept. Hence the null check.
            if (socketChannel != null) {
                socketChannel.close();
                SelectorManager.getInstance().unRegisterChannel(socketChannel);
            }
            final Object client = clientEndpoint.getNativeData(IS_CLIENT);
            // This need to handle to support multiple client close.
            if (client != null && Boolean.getBoolean(client.toString())) {
                SelectorManager.getInstance().stop();
            }
            SocketService socketService = (SocketService) clientEndpoint.getNativeData(SOCKET_SERVICE);
            // Check whether client has the attached callback service.
            // ResourceMap shouldn't be null if callback service attached.
            if (socketService != null && socketService.getResources() != null) {
                SelectorDispatcher.invokeOnClose(socketService);
            }
        } catch (IOException e) {
            log.error("Unable to close the connection", e);
            context.setReturnValues(
                    SocketUtils.createSocketError(context, "Unable to close the client socket connection"));
            return;
        }
        context.setReturnValues();
    }
}
