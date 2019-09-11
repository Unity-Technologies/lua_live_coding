using System;
using System.Net;
using System.Net.Sockets;
using System.Text;

namespace G6HotFix.Scripts.Core
{
    public class AsyncSocketClient:BaseAsyncSocket
    {
        private SocketStateObject curSocketStateObject;

        public override void Start(IPEndPoint ioEndPoint)
        {
            // Connect to a remote device.  
            try
            {
                // Create a TCP/IP socket.  
                Socket client = new Socket(ioEndPoint.Address.AddressFamily,
                    SocketType.Stream, ProtocolType.Tcp);

                // Connect to the remote endpoint.  
                G6Debugger.Log("ClientSocket begin connect!");
                client.BeginConnect(ioEndPoint,
                    new AsyncCallback(ConnectCallback), client);
            }
            catch (Exception e)
            {
                G6Debugger.LogError(e.ToString());
            }
        }

        private void ConnectCallback(IAsyncResult ar)
        {
            try
            {
                // Retrieve the socket from the state object.  
                Socket client = (Socket)ar.AsyncState;

                curSocketStateObject = new SocketStateObject();
                curSocketStateObject.workSocket = client;

                client.BeginReceive(curSocketStateObject.buffer, 0, SocketStateObject.BufferSize, 0,
                    new AsyncCallback(ReceiveCallback), curSocketStateObject);
                
                G6Debugger.Log("Hotfix server Connected!!!!!!!!");
            }
            catch (Exception e)
            {
                G6Debugger.LogError(e.ToString());
            }
        }

        public override void Send(String data)
        {
            byte[] byteData = Encoding.UTF8.GetBytes(data);
            Buffer.BlockCopy(BitConverter.GetBytes(byteData.Length), 0, curSocketStateObject.sendBuffer, 0, 4);
            Buffer.BlockCopy(byteData, 0, curSocketStateObject.sendBuffer, 4, byteData.Length);

            // Begin sending the data to the remote device.  
            curSocketStateObject.workSocket.BeginSend(curSocketStateObject.sendBuffer, 0, byteData.Length + 4, 0,
                new AsyncCallback(SendCallback), curSocketStateObject.workSocket);
        }

        protected override void SendCallback(IAsyncResult ar)
        {
            try
            {
                // Retrieve the socket from the state object.  
                Socket client = (Socket)ar.AsyncState;

                // Complete sending the data to the remote device.  
                int bytesSent = client.EndSend(ar);
                G6Debugger.LogFormat("Sent {0} bytes to server.", bytesSent);
            }
            catch (Exception e)
            {
                G6Debugger.LogError(e.ToString());
            }
        }

    }
}