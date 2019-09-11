using System.Net;
using System.Text.RegularExpressions;
using G6HotFix.LuaScripts;
using G6HotFix.Scripts.Core;
using G6Demo.Core;

namespace G6HotFix
{
    public class HotfixManager
    {
        private static HotfixManager instance;

        public static HotfixManager Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new HotfixManager();
                }

                return instance;
            }
        }

        public int ipPort = 11000;
        //
        private AsyncSocketClient asyncSocketClient;

        public AsyncSocketClient GetSocketClient()
        {
            return asyncSocketClient;
        }

        //连接自定义的socket服务器
        public void StartConnectSocketServer()
        {
            // Establish the remote endpoint for the socket.
//            IPHostEntry ipHostInfo = Dns.GetHostEntry("localHost");
//            IPAddress ipAddress = ipHostInfo.AddressList[0];
//            IPEndPoint remoteEP = new IPEndPoint(ipAddress, ipPort);
            IPEndPoint remoteEP = new IPEndPoint(IPAddress.Parse("127.0.0.1"), ipPort);
            asyncSocketClient = new AsyncSocketClient();
            asyncSocketClient.Start(remoteEP);
        }

        //收到要更新的脚本信息
        private void OnReceiveSocketData(string data)
        {
            if (data == null)
            {
                return;
            }

            if (data.StartsWith("#LuaPush#"))
            { 
                Regex r = new Regex(@"^#LuaPush#luaName=(?<name>.+)#luaSrc=(?<src>.+)",
                    RegexOptions.Singleline);
                string luaName = r.Match(data).Groups["name"].Value;
                string luaSrc = r.Match(data).Groups["src"].Value;

                G6Debugger.LogFormat("ReloadLua:{0}", luaName);
                LuaScriptManager.Instance.ReplaceLuaSrcText(luaName, luaSrc);
            }
            else
            {
                G6Debugger.LogFormat("HotfixServer Msg：{0}", data);
            }
        }

        public void Update()
        {
            if (asyncSocketClient == null)
            {
                return;
            }

            while (true)
            {
                string data = asyncSocketClient.PopResponse();
                if (data == null)
                {
                    break;
                }

                OnReceiveSocketData(data);
            }
        }
        
    }
}