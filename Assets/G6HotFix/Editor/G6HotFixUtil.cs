using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using G6HotFix.LuaScripts;
using UnityEditor;
using UnityEditor.AddressableAssets;
using UnityEditor.Build.Player;
using UnityEditor.Build.Reporting;
using UnityEngine;
using Debug = System.Diagnostics.Debug;

namespace G6HotFix.Editor
{
    public class G6HotFixUtil
    {
        public const string DLL_LOCAL_ORIGIN_PATH = @"Temp/gradleOut/src/main/assets/bin/Data/Managed/";
        public const string DLL_NAME = "Assembly-CSharp.dll";
        public const string ANDROID_REMOTE_CUSTOM_DLL_PATH = @"/sdcard/Android/data/{0}/files/custom/Managed/{1}";

        //发送新的lua代码
        public static void SendLuaSciprtSource(string fileName, bool isFilePath)
        {
            if (HttpPushHostingService.GetAsyncSocket().isConnected)
            {
                string luaFullPath = fileName;
                if (!isFilePath)
                {
                    luaFullPath = (G6HotFixConst.LUA_SOURCES_PATH + fileName).Replace('.', '/');
                }

                if (File.Exists(luaFullPath))
                {
                    string luaName = LuaScriptManager.ConvertProjectPathToScriptPath(luaFullPath);
                    var sendMsg = $"#LuaPush#luaName={luaName}#luaSrc={File.ReadAllText(luaFullPath)}";
                    HttpPushHostingService.GetAsyncSocket().Send(sendMsg);
                }
                else
                {
                    G6Debugger.LogError("lua file does't exist!");
                }
            }
            else
            {
                G6Debugger.LogErrorFormat("PushServer is't connected!");
            }
        }

        //采用新的ScriptableBuildPipeline 构建方式
        [MenuItem("G6HotFix/PublishAssetsAndLaunch")]
        public static void BuildAssets()
        {
            ContentUpdateScript.BuildContentUpdate(AddressableAssetSettingsDefaultObject.Settings, ContentUpdateScript.GetContentStateDataPath(false));
            LaunchGameOnAndroid();
        }

        //采用新的ScriptableBuildPipeline 构建方式
        [MenuItem("G6HotFix/PublishScriptsAndLaunch")]
        public static void ScriptableBuildAndPushDll()
        {
            InternalScriptableBuildAndPushDll();
        }

//        [MenuItem("G6HotFix/Build&Push Dll")]
        public static void BuildAndPushDll()
        {
            InternalBuildAndPushDll(false);
        }

        //Before you can use BuildScriptsOnly, you need to build the whole Project. Then you can run builds that only have script changes.
//        [MenuItem("G6HotFix/BuildScriptsOnly&Push Dll")]
        public static void BuildScriptsOnlyAndPushDll()
        {
            InternalBuildAndPushDll(true);
        }

        //
        public static void InternalBuildAndPushDll(bool isScriptsOnly)
        {
            var buildPlayerOptions = new BuildPlayerOptions();
            var scenes = new List<string>();
            foreach (var t in EditorBuildSettings.scenes)
            {
                if (t.enabled)
                {
                    scenes.Add(t.path);
                }
            }

            buildPlayerOptions.scenes = scenes.ToArray();
            buildPlayerOptions.locationPathName = $"AndroidBuild/{Application.productName}.apk";
            buildPlayerOptions.target = BuildTarget.Android;

            buildPlayerOptions.options = isScriptsOnly
                ? BuildOptions.Development | BuildOptions.BuildScriptsOnly
                : BuildOptions.Development;

            var report = BuildPipeline.BuildPlayer(buildPlayerOptions);
            var summary = report.summary;

            switch (summary.result)
            {
                case BuildResult.Succeeded:
                    G6Debugger.Log("Build succeeded: " + summary.totalSize + " bytes");
                    string projectPath = Application.dataPath.Replace("Assets", "");
                    string srcDllPath = $@"{projectPath}{DLL_LOCAL_ORIGIN_PATH}{DLL_NAME}";
                    PushDll(srcDllPath);
                    break;
                case BuildResult.Failed:
                    G6Debugger.Log("Build failed");
                    break;
                case BuildResult.Unknown:
                    break;
                case BuildResult.Cancelled:
                    break;
                default:
                    throw new ArgumentOutOfRangeException();
            }
        }

        // 采用新的ScriptableBuildPipeline
        private static void InternalScriptableBuildAndPushDll()
        {
            EditorUtility.DisplayProgressBar("BuildingDll", "Building Dll...", 0);

            string projectPath = Application.dataPath.Replace("Assets", "");
            string srcDllFolder = $@"{projectPath}AndroidDll/{Application.productName}";
            ScriptCompilationSettings scriptCompilationSettings = new ScriptCompilationSettings();
            scriptCompilationSettings.group = BuildTargetGroup.Android;
            scriptCompilationSettings.target = BuildTarget.Android;
            try
            {
                ScriptCompilationResult scriptCompilationResult = PlayerBuildInterface.CompilePlayerScripts(scriptCompilationSettings, srcDllFolder);
                string srcDllPath = $@"{srcDllFolder}/{DLL_NAME}";
                PushDll(srcDllPath);
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }

            EditorUtility.ClearProgressBar();
        }

        // 利用adb，将dll从pc push到手机上
        // 需要pc中安装adb并配置对应环境变量， 还需要手机上安装的apk是用修改后的UnityAndroidPlayer build出来的
        private static void PushDll(string srcDllPath)
        {
            string dstDllPath = string.Format(ANDROID_REMOTE_CUSTOM_DLL_PATH, Application.identifier, DLL_NAME);

            if (!File.Exists(srcDllPath))
            {
                G6Debugger.LogErrorFormat("File does 't exist in path {0}! ", srcDllPath);
                return;
            }
            //通过命令行的形式调用adb，并输出指令，第三方调用了。
            //“adb push src dst”
            //命令的内容为更新一个dll
            ProcessCommand("adb", $"push {srcDllPath} {dstDllPath}");
            LaunchGameOnAndroid();
        }

        // 调用cmd
        private static void ProcessCommand(string command, string argument)
        {
            var info =
                new System.Diagnostics.ProcessStartInfo(command)
                {
                    Arguments = argument,
                    CreateNoWindow = false,
                    ErrorDialog = true,
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    RedirectStandardInput = true,
                    StandardOutputEncoding = Encoding.UTF8,
                    StandardErrorEncoding = Encoding.UTF8
                };


            System.Diagnostics.Process process = System.Diagnostics.Process.Start(info);

            Debug.Assert(process != null, nameof(process) + " != null");
            G6Debugger.Log(process.StandardOutput);
            G6Debugger.Log(process.StandardError);

            process.WaitForExit();
            process.Close();
        }

        private static void LaunchGameOnAndroid()
        {
            ProcessCommand("adb", $"shell am start -n {Application.identifier}/com.unity3d.player.UnityPlayerActivity");
        }
    }
}