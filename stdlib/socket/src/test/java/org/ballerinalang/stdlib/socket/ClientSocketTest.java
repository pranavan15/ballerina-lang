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
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.ballerinalang.stdlib.socket;

import org.ballerinalang.launcher.util.BCompileUtil;
import org.ballerinalang.launcher.util.BRunUtil;
import org.ballerinalang.launcher.util.CompileResult;
import org.ballerinalang.model.values.BError;
import org.ballerinalang.model.values.BMap;
import org.ballerinalang.model.values.BString;
import org.ballerinalang.model.values.BValue;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import java.io.File;
import java.io.IOException;
import java.net.Socket;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Unit tests for client socket.
 */
@Test(timeOut = 120000)
public class ClientSocketTest {

    private static final Logger log = LoggerFactory.getLogger(ClientSocketTest.class);

    private CompileResult socketClient;
    private ExecutorService executor;
    private MockSocketServer mockSocketServer;

    @BeforeClass
    public void setup() {
        boolean connectionStatus;
        int numberOfRetryAttempts = 20;
        try {
            executor = Executors.newSingleThreadExecutor();
            mockSocketServer = new MockSocketServer();
            executor.execute(mockSocketServer);
            Thread.sleep(2000);
            connectionStatus = isConnected(MockSocketServer.SERVER_HOST, numberOfRetryAttempts);
            if (!connectionStatus) {
                Assert.fail("Unable to open connection with the test TCP server");
            }
        } catch (InterruptedException e) {
            log.error("Unable to open Socket Server: " + e.getMessage(), e);
            Assert.fail(e.getMessage());
        }
        String resourceRoot = new File(getClass().getProtectionDomain().getCodeSource().getLocation().getPath())
                .getAbsolutePath();
        Path testResourceRoot = Paths.get(resourceRoot, "test-src");
        socketClient = BCompileUtil.compile(testResourceRoot.resolve("client_socket.bal").toString());
    }

    /**
     * Closes a provided socket connection.
     *
     * @param socket socket which should be closed.
     */
    private void close(Socket socket) {
        try {
            socket.close();
        } catch (IOException e) {
            log.error("Error occurred while closing the Socket connection", e);
        }
    }

    /**
     * Will enforce to sleep the thread for the provided time.
     *
     * @param retryInterval the time in milliseconds the thread should sleep
     */
    private void sleep(int retryInterval) {
        try {
            Thread.sleep(retryInterval);
        } catch (InterruptedException ignore) {
            Thread.currentThread().interrupt();
        }
    }

    /**
     * Attempts to establish a connection with the test server.
     *
     * @param hostName        hostname of the server.
     * @param numberOfRetries number of retry attempts.
     * @return true if the connection is established successfully.
     */
    private boolean isConnected(String hostName, int numberOfRetries) {
        Socket temporarySocketConnection = null;
        boolean isConnected = false;
        final int retryInterval = 1000;
        final int initialRetryCount = 0;
        for (int retryCount = initialRetryCount; retryCount < numberOfRetries && !isConnected; retryCount++) {
            try {
                //Attempts to establish a connection with the server
                temporarySocketConnection = new Socket(hostName, MockSocketServer.SERVER_PORT);
                isConnected = true;
            } catch (IOException e) {
                log.error("Error occurred while establishing a connection with test server", e);
                sleep(retryInterval);
            } finally {
                if (null != temporarySocketConnection) {
                    //We close the connection once completed.
                    close(temporarySocketConnection);
                }
            }
        }
        return isConnected;
    }

    @AfterClass
    public void cleanup() {
        mockSocketServer.stop();
        executor.shutdownNow();
    }

    @Test(description = "Open client socket connection to the remote server and write content")
    public void testOneWayWrite() {
        String msg = "Hello Ballerina\\n";
        BValue[] args = { new BString(msg) };
        BRunUtil.invoke(socketClient, "oneWayWrite", args);
        Assert.assertEquals(mockSocketServer.getReceivedString(), msg);
    }

    @Test(description = "Write some content, then shutdown the write and try to write it again",
          dependsOnMethods = "testOneWayWrite")
    public void testShutdownWrite() {
        String firstMsg = "Hello Ballerina1\\n";
        String secondMsg = "Hello Ballerina2\\n";
        BValue[] args = { new BString(firstMsg), new BString(secondMsg) };
        final BValue[] shutdownWritesResult = BRunUtil.invoke(socketClient, "shutdownWrite", args);
        BError error = (BError) shutdownWritesResult[0];
        Assert.assertEquals(((BMap) error.getDetails()).getMap().get("message").toString(),
                "Client socket close already.");
        Assert.assertEquals(mockSocketServer.getReceivedString(), firstMsg);
    }
}
