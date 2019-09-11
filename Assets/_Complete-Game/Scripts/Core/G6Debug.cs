using UnityEngine;
using System.Diagnostics;
using System.Text;

public static class G6Debugger
{
    public static void LogString(string message)
    {
        UnityEngine.Debug.Log(message);
//        logSb.AppendLine(message.ToString());
    }
    //    [Conditional("G6_ENABLE_LOG")]
    public static void Log(object message, UnityEngine.Object obj = null)
    {
        UnityEngine.Debug.Log(message, obj);
        logSb.AppendLine(message.ToString());
    }

    public static void LogWithoutCondition(object message, UnityEngine.Object obj = null)
    {
        UnityEngine.Debug.Log(message, obj);
    }

    public static void LogWarningWithoutCondition(object message, UnityEngine.Object obj = null)
    {
        UnityEngine.Debug.LogWarning(message, obj);
    }

//    [Conditional("G6_ENABLE_LOG")]
    public static void LogWarning(object message, UnityEngine.Object obj = null)
    {
        UnityEngine.Debug.LogWarning(message, obj);
    }

    //[Conditional("G6_ENABLE_LOG")]
    public static void LogError(object message)
    {
        UnityEngine.Debug.LogError(message);
    }

    //[Conditional("G6_ENABLE_LOG")]
    public static void LogError(object message, UnityEngine.Object obj)
    {
        UnityEngine.Debug.LogError(message, obj);
    }

//    [Conditional("G6_ENABLE_LOG")]
    public static void LogException(System.Exception e)
    {
        UnityEngine.Debug.LogError(e.Message);
    }

    [Conditional("G6_ENABLE_LOG")]
    public static void DrawLine(Vector3 start, Vector3 end, Color color)
    {
        UnityEngine.Debug.DrawLine(start, end, color);
    }

//    [Conditional("G6_ENABLE_LOG")]
    public static void DrawLine(Vector3 start, Vector3 end, Color color, float duration, bool depthTest)
    {
        UnityEngine.Debug.DrawLine(start, end, color, duration, depthTest);
    }

    [Conditional("G6_ENABLE_LOG")]
    public static void DrawLine(Vector3 start, Vector3 end, Color color, float duration)
    {
        UnityEngine.Debug.DrawLine(start, end, color, duration);
    }

    [Conditional("G6_ENABLE_LOG")]
    public static void DrawLine(Vector3 start, Vector3 end)
    {
        UnityEngine.Debug.DrawLine(start, end);
    }

//    [Conditional("G6_ENABLE_LOG")]
    public static void LogFormat(string format, params object[] args)
    {
        UnityEngine.Debug.LogFormat(format, args);
        logSb.AppendFormat(format, args);
    }

//    [Conditional("G6_ENABLE_LOG")]
    public static void LogFormat(Object context, string format, params object[] args)
    {
        UnityEngine.Debug.LogFormat(context, format, args);
    }

    //[Conditional("G6_ENABLE_LOG")]
    public static void LogErrorFormat(string format, params object[] args)
    {
        UnityEngine.Debug.LogErrorFormat(format, args);
    }

    //[Conditional("G6_ENABLE_LOG")]
    public static void LogErrorFormat(Object context, string format, params object[] args)
    {
        UnityEngine.Debug.LogErrorFormat(context, format, args);
    }

    [Conditional("UNITY_ASSERTIONS")]
    public static void Assert(bool condition)
    {
        UnityEngine.Debug.Assert(condition);
    }
    [Conditional("G6_ENABLE_LOG")]
    public static void LogWarningFormat(string format, params object[] args)
    {
        UnityEngine.Debug.LogWarningFormat(format, args);
    }
    [Conditional("G6_ENABLE_LOG")]
    public static void LogWarningFormat(Object context, string format, params object[] args)
    {
        UnityEngine.Debug.LogWarningFormat(context, format, args);
    }

    [Conditional("UNITY_ASSERTIONS")]
    public static void Assert(bool condition, object message)
    {
        UnityEngine.Debug.Assert(condition, message);
    }

    public static void Break()
    {
        UnityEngine.Debug.Break();
    }

    private static StringBuilder logSb = new StringBuilder();

    public static string GetUILog()
    {
        return logSb.ToString();
    }

    public static void ClearUILog()
    {
        logSb.Clear();
    }
}


