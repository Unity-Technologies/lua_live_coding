using System;
using System.Net;
using System.Net.Sockets;
using System.Text;

namespace G6HotFix.Scripts.Core
{
    public class AsyncSocketServer : BaseAsyncSocket
    {
        private SocketStateObject clientSocketState;

        private Socket socketListener;

        public bool isConnected;

        public override void Start(IPEndPoint ipEndPoint)
        {
            // Socket
            // Bind the socket to the local endpoint and listen for incoming connections.  
            try
            {
                socketListener = new Socket(ipEndPoint.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
                socketListener.Bind(ipEndPoint);
                socketListener.Listen(5);

                // Start an asynchronous socket to listen for connections.  
                G6Debugger.Log("Waiting for a connection...");
                socketListener.BeginAccept(
                    new AsyncCallback(AcceptCallback),
                    socketListener);
            }
            catch (Exception e)
            {
                G6Debugger.LogError(e.ToString());
            }
        }

        public void Stop()
        {
            if (socketListener != null)
            {
                socketListener.Close();
                socketListener = null;
            }

            if (clientSocketState != null)
            {
                clientSocketState.Dispose();
            }

            isConnected = false;
        }

        private void AcceptCallback(IAsyncResult ar)
        {
            // Get the socket that handles the client request.  
            Socket listener = (Socket)ar.AsyncState;
            Socket handler = listener.EndAccept(ar);

            // Create the state object.
            clientSocketState = new SocketStateObject();
            clientSocketState.workSocket = handler;
            handler.BeginReceive(clientSocketState.buffer, 0, SocketStateObject.BufferSize, 0,
                new AsyncCallback(ReceiveCallback), clientSocketState);

            isConnected = true;
        }

        public override void Send(String data)
        {
            byte[] byteData = Encoding.UTF8.GetBytes(data);
            Buffer.BlockCopy(BitConverter.GetBytes(byteData.Length), 0, clientSocketState.sendBuffer, 0, 4);
            Buffer.BlockCopy(byteData, 0, clientSocketState.sendBuffer, 4, byteData.Length);

            // Begin sending the data to the remote device.  
            clientSocketState.workSocket.BeginSend(clientSocketState.sendBuffer, 0, byteData.Length + 4, 0,
                new AsyncCallback(SendCallback), clientSocketState.workSocket);
        }

        protected override void SendCallback(IAsyncResult ar)
        {
            try
            {
                // Retrieve the socket from the state object.  
                Socket handler = (Socket)ar.AsyncState;

                // Complete sending the data to the remote device.  
                int bytesSent = handler.EndSend(ar);
                G6Debugger.LogFormat("Sent {0} bytes to client.", bytesSent);
            }
            catch (Exception e)
            {
                G6Debugger.LogError(e.ToString());
            }
        }
    }
}