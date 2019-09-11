using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Sockets;
using G6HotFix.Editor;
using G6HotFix.Scripts.Core;
using G6HotFix;
using UnityEditor;
using UnityEditor.AddressableAssets;
using UnityEngine;

public class HttpPushHostingService : BaseHostingService
{
    private const string k_hostingServicePortKey = "HostingServicePort";
    private const int k_fileReadBufferSize = 64 * 1024;

    private static readonly IPEndPoint DefaultLoopbackEndpoint = new IPEndPoint(IPAddress.Loopback, 0);
    private readonly Dictionary<string, string> m_profileVariables;
    private int m_servicePort;

    private static AsyncSocketServer socketListener;

    public static AsyncSocketServer GetAsyncSocket()
    {
        return socketListener;
    }

    /// <summary>
    ///     Create a new <see cref="HttpHostingService" />
    /// </summary>
    public HttpPushHostingService()
    {
        m_profileVariables = new Dictionary<string, string>();
        HostingServiceContentRoots = new List<string>();
        MyHttpListener = new HttpListener();
    }

    protected HttpListener MyHttpListener { get; set; }

    /// <summary>
    ///     The port number on which the service is listening
    /// </summary>
    // ReSharper disable once MemberCanBePrivate.Global
    public int HostingServicePort
    {
        get { return m_servicePort; }
        protected set
        {
            if (IsPortAvailable(value))
                m_servicePort = value;
        }
    }

    private string testMsg;
    public string TestMsg
    {
        get
        {
            return testMsg;
        }
        set
        {
            testMsg = value;
        }
    }

    /// <inheritdoc />
    public override bool IsHostingServiceRunning => MyHttpListener != null && MyHttpListener.IsListening;

    /// <inheritdoc />
    public override List<string> HostingServiceContentRoots { get; }

    /// <inheritdoc />
    public override Dictionary<string, string> ProfileVariables
    {
        get
        {
            m_profileVariables[k_hostingServicePortKey] = HostingServicePort.ToString();
            m_profileVariables[DisambiguateProfileVar(k_hostingServicePortKey)] = HostingServicePort.ToString();
            return m_profileVariables;
        }
    }

    /// <inheritdoc />
    public override void StartHostingService()
    {
        if (IsHostingServiceRunning)
            return;

        if (HostingServicePort <= 0)
        {
            HostingServicePort = GetAvailablePort();
        }
        else if (!IsPortAvailable(HostingServicePort))
        {
            LogError("Port {0} is in use, cannot start service!", HostingServicePort);
            return;
        }

        if (HostingServiceContentRoots.Count == 0)
            throw new Exception(
                "ContentRoot is not configured; cannot start service. This can usually be fixed by modifying the BuildPath for any new groups and/or building content.");

        ConfigureHttpListener();
        MyHttpListener.Start();
        MyHttpListener.BeginGetContext(HandleRequest, null);
        Log("Started. Listening on port {0}", HostingServicePort);

        //
        if (socketListener == null)
        {
            socketListener = new AsyncSocketServer();
        }
        var socketLocalEndPoint = new IPEndPoint(IPAddress.Parse("127.0.0.1"), HotfixManager.Instance.ipPort);
        socketListener.Start(socketLocalEndPoint);
    }

    /// <inheritdoc />
    public override void StopHostingService()
    {
        if (!IsHostingServiceRunning) return;
        Log("Stopping");
        MyHttpListener.Stop();
        socketListener.Stop();

        socketListener = null;
    }

    /// <inheritdoc />
    public override void OnGUI()
    {
        EditorGUILayout.BeginHorizontal();
        {
            var newPort = EditorGUILayout.DelayedIntField("Port", HostingServicePort);
            if (newPort != HostingServicePort)
            {
                if (IsPortAvailable(newPort))
                    ResetListenPort(newPort);
                else
                    LogError("Cannot listen on port {0}; port is in use", newPort);
            }

            if (GUILayout.Button("Reset", GUILayout.MaxWidth(150)))
                ResetListenPort();

            //GUILayout.Space(rect.width / 2f);
        }
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.BeginHorizontal();
        {
            TestMsg = EditorGUILayout.TextField("TestMsg", TestMsg);
            if (GUILayout.Button("Send", GUILayout.MaxWidth(150)))
            {
                SendMsg(TestMsg);
            }
        }
        EditorGUILayout.EndHorizontal();
    }

    /// <inheritdoc />
    public override void OnBeforeSerialize(KeyDataStore dataStore)
    {
        dataStore.SetData(k_hostingServicePortKey, HostingServicePort);
        base.OnBeforeSerialize(dataStore);
    }

    /// <inheritdoc />
    public override void OnAfterDeserialize(KeyDataStore dataStore)
    {
        HostingServicePort = dataStore.GetData(k_hostingServicePortKey, 0);
        base.OnAfterDeserialize(dataStore);
    }

    /// <summary>
    ///     Listen on a new port then next time the server starts. If the server is already running, it will be stopped
    ///     and restarted automatically.
    /// </summary>
    /// <param name="port">Specify a port to listen on. Default is 0 to choose any open port</param>
    // ReSharper disable once MemberCanBePrivate.Global
    public void ResetListenPort(int port = 0)
    {
        var isRunning = IsHostingServiceRunning;
        StopHostingService();
        HostingServicePort = port;

        if (isRunning)
            StartHostingService();
    }

    private void SendMsg(string msg)
    {
        if (msg.StartsWith("#LuaPush#"))
        {
            string luaName = msg.Replace("#LuaPush#", "");
            G6HotFixUtil.SendLuaSciprtSource(luaName, false);
        }
        else
        {
            socketListener.Send(msg);
        }
    }

    /// <summary>
    ///     Handles any configuration necessary for <see cref="MyHttpListener" /> before listening for connections.
    /// </summary>
    protected virtual void ConfigureHttpListener()
    {
        try
        {
            MyHttpListener.Prefixes.Clear();
            MyHttpListener.Prefixes.Add("http://+:" + HostingServicePort + "/");
        }
        catch (Exception e)
        {
            Debug.LogException(e);
        }
    }

    /// <summary>
    ///     Asynchronous callback to handle a client connection request on <see cref="MyHttpListener" />. This method is
    ///     recursive in that it will call itself immediately after receiving a new incoming request to listen for the
    ///     next connection.
    /// </summary>
    /// <param name="ar">Asynchronous result from previous request. Pass null to listen for an initial request</param>
    /// <exception cref="ArgumentOutOfRangeException">thrown when the request result code is unknown</exception>
    protected virtual void HandleRequest(IAsyncResult ar)
    {
        if (!IsHostingServiceRunning)
            return;

        var c = MyHttpListener.EndGetContext(ar);
        MyHttpListener.BeginGetContext(HandleRequest, null);

        var relativePath = c.Request.RawUrl.Substring(1);

        var fullPath = FindFileInContentRoots(relativePath);
        var result = fullPath != null ? ResultCode.Ok : ResultCode.NotFound;
        var info = fullPath != null ? new FileInfo(fullPath) : null;
        var size = info != null ? info.Length.ToString() : "-";
        var remoteAddress = c.Request.RemoteEndPoint != null ? c.Request.RemoteEndPoint.Address : null;
        var timestamp = DateTime.Now.ToString("o");

        Log("{0} - - [{1}] \"{2}\" {3} {4}", remoteAddress, timestamp, fullPath, (int) result, size);

        switch (result)
        {
            case ResultCode.Ok:
                ReturnFile(c, fullPath);
                break;
            case ResultCode.NotFound:
                Return404(c);
                break;
            default:
                throw new ArgumentOutOfRangeException();
        }
    }

    /// <summary>
    ///     Searches for the given relative path within the configured content root directores.
    /// </summary>
    /// <param name="relativePath"></param>
    /// <returns>The full system path to the file if found, or null if file could not be found</returns>
    protected virtual string FindFileInContentRoots(string relativePath)
    {
        foreach (var root in HostingServiceContentRoots)
        {
            var fullPath = Path.Combine(root, relativePath);
            if (File.Exists(fullPath))
                return fullPath;
        }

        return null;
    }

    /// <summary>
    ///     Sends a file to the connected HTTP client
    /// </summary>
    /// <param name="context"></param>
    /// <param name="filePath"></param>
    /// <param name="readBufferSize"></param>
    protected virtual void ReturnFile(HttpListenerContext context, string filePath,
        int readBufferSize = k_fileReadBufferSize)
    {
        context.Response.ContentType = "application/octet-stream";

        var buffer = new byte[readBufferSize];
        using (var fs = File.OpenRead(filePath))
        {
            context.Response.ContentLength64 = fs.Length;
            int read;
            while ((read = fs.Read(buffer, 0, buffer.Length)) > 0)
                context.Response.OutputStream.Write(buffer, 0, read);
        }

        context.Response.OutputStream.Close();
    }

    /// <summary>
    ///     Sets the status code to 404 on the given <see cref="HttpListenerContext" /> object
    /// </summary>
    /// <param name="context"></param>
    protected virtual void Return404(HttpListenerContext context)
    {
        context.Response.StatusCode = 404;
        context.Response.Close();
    }


    /// <summary>
    ///     Tests to see if the given port # is already in use
    /// </summary>
    /// <param name="port">port number to test</param>
    /// <returns>true if there is not a listener on the port</returns>
    protected static bool IsPortAvailable(int port)
    {
        try
        {
            using (var client = new TcpClient())
            {
                var result = client.BeginConnect(IPAddress.Loopback, port, null, null);
                var success = result.AsyncWaitHandle.WaitOne(TimeSpan.FromMilliseconds(500));
                if (!success)
                    return true;

                client.EndConnect(result);
            }
        }
        catch
        {
            return true;
        }

        return false;
    }

    /// <summary>
    ///     Find an open network listen port on the local system
    /// </summary>
    /// <returns>a system assigned port, or 0 if none are available</returns>
    protected static int GetAvailablePort()
    {
        using (var socket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, 0))
        {
            socket.Bind(DefaultLoopbackEndpoint);

            var endPoint = socket.LocalEndPoint as IPEndPoint;
            return endPoint != null ? endPoint.Port : 0;
        }
    }

    protected enum ResultCode
    {
        Ok = 200,
        NotFound = 404
    }
}