using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Text;

namespace G6HotFix.Scripts.Core
{
    public class BaseAsyncSocket
    {
        private List<string> responses = new List<string>();

        public string PopResponse()
        {
            if (responses.Count > 0)
            {
                string response = responses[0];
                responses.RemoveAt(0);
                return response;
            }

            return null;
        }

        protected void AddResponse(string response)
        {
            responses.Add(response);
        }

        public virtual void Start(IPEndPoint ipEndPoint)
        {
        }

        public virtual void Send(String data)
        {

        }

        protected virtual void SendCallback(IAsyncResult ar)
        {

        }

        protected void Receive(Socket client)
        {

        }

        private bool isPackageSplit;

        private byte[] emptyArr = new byte[64 * 1024];
        private byte[] dataArr = new byte[64 * 1024];
        private int packagelen;
        private int unreceiveLen;
        private int byteIndex;

        protected virtual void ReceiveCallback(IAsyncResult ar)
        {
            SocketStateObject state = (SocketStateObject)ar.AsyncState;
            Socket handler = state.workSocket;
            try
            {
                int byteRead = handler.EndReceive(ar);

                if (byteRead > 0)
                {
                    if (!isPackageSplit)
                    {
                        Buffer.BlockCopy(emptyArr, 0, dataArr, 0, 64 * 1024);
                        //获取数据长度;
                        byte[] datalengtharr = new byte[4];
                        Buffer.BlockCopy(state.buffer, 0, datalengtharr, 0, 4);
                        packagelen = BitConverter.ToInt32(datalengtharr, 0);
                        G6Debugger.LogFormat("receive: byteRead={0} length = {1}", byteRead, packagelen);

                        //获取数据主体;
                        Buffer.BlockCopy(state.buffer, 4, dataArr, 0, byteRead - 4);
                        byteIndex = byteRead - 4;
                        unreceiveLen = packagelen - (byteRead - 4);
                    }
                    else
                    {
                        int enableLen = Math.Min(byteRead, unreceiveLen);
                        Buffer.BlockCopy(state.buffer, 0, dataArr, byteIndex, enableLen);
                        byteIndex = byteIndex + enableLen;
                        unreceiveLen = unreceiveLen - enableLen;
                        G6Debugger.LogFormat("receive break: byteRead={0} length={1} byteIndex={2}", byteRead, packagelen, byteIndex);
                    }
                    G6Debugger.LogFormat("ReceiveCallback unreceiveLen:{0}", unreceiveLen);

                    //判断数据长度，是否接收完全;
                    if (unreceiveLen <= 0)
                    {
                        isPackageSplit = false;
                        AddResponse(Encoding.UTF8.GetString(dataArr, 0, packagelen));
                    }
                    else
                    {
                        isPackageSplit = true;
                    }
                }

                handler.BeginReceive(state.buffer, 0, SocketStateObject.BufferSize, 0,
                    new AsyncCallback(ReceiveCallback), state);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }
    }
}