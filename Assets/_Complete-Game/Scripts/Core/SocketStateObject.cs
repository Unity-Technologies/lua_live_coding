using System.Diagnostics;
using System.IO;
using System.Net.Sockets;
using System.Text;

namespace G6HotFix.Scripts.Core
{
    // State object for reading client data asynchronously  
    public class SocketStateObject
    {
        // Client  socket.  
        public Socket workSocket = null;
        // Size of receive buffer.  
        public const int BufferSize = 1024 * 64;
        // Send buffer
        public byte[] sendBuffer = new byte[BufferSize];
        // Receive buffer.  
        public byte[] buffer = new byte[BufferSize];

        public void Dispose()
        {
            if (workSocket != null)
            {
                workSocket.Close();
                workSocket = null;
            }
        }
    }
}