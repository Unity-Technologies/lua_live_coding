using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement;
using XLua;

namespace G6HotFix.LuaScripts
{
    [CSharpCallLua]
    public interface ILuaScriptsLoader
    {
        void ReloadScripts();
    }

    [CSharpCallLua]
    public delegate void UpdateEventSystemDelegate(float dt);

    [CSharpCallLua]
    public interface ILuaModelManager
    {
        void InitModels();
    }

    [LuaCallCSharp]
    public class LuaScriptManager : ObjectSingleton<LuaScriptManager>
    {
        private LuaEnv luaEnv;
        private LuaTable scriptEnv;
        private float scriptDeltaTime;

        private UpdateEventSystemDelegate updateFunc;

        public LuaScriptManager()
        {
            luaEnv = new LuaEnv();
            scriptEnv = luaEnv.NewTable();

            LuaTable meta = luaEnv.NewTable();
            meta.SetInPath("__index", luaEnv.Global);
            scriptEnv.SetMetaTable(meta);
            meta.Dispose();
        }

        public LuaEnv GetLuaEnv()
        {
            return luaEnv;
        }

        public LuaTable GetScriptEnv()
        {
            return scriptEnv;
        }

        private const string booterscript = @"
                local whitelist = {
                    ['_G'] = true,
                    ['bit'] = true,
                    ['debug'] = true,
                    ['coroutine'] = true,
                    ['io'] = true,
                    ['jit'] = true,
                    ['jit.opt'] = true,
                    ['libtdrlua'] = true,
                    ['math'] = true,
                    ['table'] = true,
                    ['os'] = true,
                    ['package'] = true,
                    ['perf'] = true,
                    ['socket'] = true,
                    ['stringtable'] = true,
                }

                --清空加载表，便于重载脚本
                for k, v in pairs(package.loaded) do
                    if whitelist[k] == nil then
                        package.loaded[k] = nil
                    end
                end

                --加载path目录文件
                local status, errmsg = pcall(require, 'LuaScripts.GamePath')
                if status == false then
                   print(errmsg)
                   return
                end

                status, errmsg = pcall(require, 'LuaScripts.GameBooter')
                if status == false then
                    print(errmsg)
                    return
                end
            ";

        /// <summary>
        /// 载入所有脚本
        /// </summary>
        /// <returns>成功返回true</returns>
        public bool LoadScripts()
        {
            luaEnv.DoString(booterscript, "LuaBooter", scriptEnv);

            LuaBehaviourManager.Instance.Init();

            var loader = luaEnv.Global.Get<ILuaScriptsLoader>("GameBooter");
            loader.ReloadScripts();

            OnLuaScriptLoaded();

            return true;
        }


        private void OnLuaScriptLoaded()
        {
//            updateFunc = luaEnv.Global.Get<UpdateEventSystemDelegate>("UpdateEventSystem");

            this.SetGCParam();

            this.GetLuaEnv().FullGc();
        }

        /// <summary>
        /// Sets the GC parameter.
        /// 在脚本加载完成后，设置GC参数，使之更积极地GC
        /// </summary>
        private void SetGCParam()
        {
            luaEnv.GcPause = 100;
            luaEnv.GcStepmul = 5000;

            this.GC();
        }

        public void Dispose()
        {
            luaEnv.Dispose();
        }

        public void GC()
        {
            luaEnv.GC();
        }

        public LuaTable GetLuaTable(string key)
        {
            return luaEnv.Global.GetInPath<LuaTable>(key);
        }

        private float memDeltaTime = 0;
        public void UpdateScript(float deltatime)
        {
            scriptDeltaTime += deltatime;
            memDeltaTime += deltatime;

            if (memDeltaTime > 60.0f)
            {
                //UnityEngine.Debug.Log("Lua: -------------- mem " + luaEnv.Memroy);
                memDeltaTime = 0;
            }

            if (scriptDeltaTime < 0.03f)
            {
                return;
            }

            // 更新游戏的事件系统
            //            if (updateFunc != null)
            //            {
            //                updateFunc(scriptDeltaTime);
            //            }

            scriptDeltaTime = 0.0f;

            luaEnv.Tick();
        }

        #region lua缓存和加载方式

        private Dictionary<string, TextAsset> luaScriptsMap = new Dictionary<string, TextAsset>();

        public void SetLuaSource(IList<IResourceLocation> context, IList<TextAsset> luaSource)
        {
            for (int i = 0; i < luaSource.Count; i++)
            {
                luaScriptsMap[context[i].InternalId] = luaSource[i];
            }
        }

        public void ReplaceLuaSource(IList<IResourceLocation> context, IList<TextAsset> luaSource)
        {
            for (int i = 0; i < luaSource.Count; i++)
            {
                if (luaScriptsMap[context[i].InternalId] != null)
                {
                    Addressables.ReleaseInstance(luaScriptsMap[context[i].InternalId]);
                }
                luaScriptsMap[context[i].InternalId] = luaSource[i];
            }
        }

        public void ReplaceLuaSrcText(string name, string src)
        {
            luaScriptsMap[name] = new TextAsset(src);

            string packageName = ConvertScriptPathToPackageName(name);
            LuaBehaviourManager.Instance.ReloadBehaviour(packageName);
        }

        public bool IsContainsLuaScript(string luaName)
        {
            return luaScriptsMap.ContainsKey(luaName);
        }

        public string GetLuaScriptText(string luaName)
        {
            if (IsContainsLuaScript(luaName))
            {
                return luaScriptsMap[luaName].text;
            }

            var filepath = UnityEngine.Application.streamingAssetsPath + "/" + luaName;

#if UNITY_ANDROID
            UnityEngine.WWW www = new UnityEngine.WWW(filepath);
                while (true)
                {
                    if (www.isDone || !string.IsNullOrEmpty(www.error))
                    {
                        System.Threading.Thread.Sleep(50);
                        return www.text;
                    }
                }
#else
            string text = string.Empty;
            if (File.Exists(filepath))
            {
                text = File.ReadAllText(filepath, Encoding.UTF8);
            }
            return text;
#endif
        }

        public byte[] GetLuaScriptBytes(string luaName)
        {
            return luaScriptsMap[luaName].bytes;
        }

        #endregion


        public static LuaFunction LoadLuaFile(string luaName, string mode, LuaTable env)
        {
            if (luaName.Length < 1)
            {
                return null;
            }
    
            string Data = LuaScriptManager.Instance.GetLuaScriptText(luaName);
            if (string.IsNullOrEmpty(Data))
            {
                return null;
            }

            return LuaScriptManager.Instance.GetLuaEnv().LoadString(Data, luaName, env);
        }

        //------------------------
        //  todo
        // 路径之前的各种转换
        //------------------------
        private static string luaFilePathPrefix = UnityEngine.Application.streamingAssetsPath;
        
        public static string ConvertPackageNameToFileFullPath(string packageName)
        {

            string filename = packageName.Replace('.', '/') + ".lua";
            var filepath = luaFilePathPrefix + filename;
            return filepath;
        }

        public static string ConvertFileFullPathToPackageName(string filePath)
        {
            string packageName = filePath;
            if (packageName.EndsWith(".lua"))
            {
                packageName = filePath.Remove(filePath.Length - 4);
            }
            packageName = packageName.Replace(luaFilePathPrefix, "").Replace('/', '.');
            return packageName;
        }

        //
        public static string ConvertProjectPathToScriptPath(string filePath)
        {
            return filePath.Replace("Assets/StreamingAssets/", "");
        }

        public static string ConvertScriptPathToPackageName(string filePath)
        {
            if (filePath.EndsWith(".lua"))
            {
                filePath = filePath.Remove(filePath.Length - 4);
            }
            return filePath.Replace('/', '.');
        }
    }
}