using System;
using System.Collections;
using System.Collections.Generic;
using G6HotFix.LuaScripts;
using UnityEngine;
using UnityEngine.AddressableAssets;
using XLua;

[LuaCallCSharp]
public class XLuaBehaviour : MonoBehaviour
{
    [SerializeField]
    private string luaScriptPath;
    public Injection[] injections;

    private Action luaStart;
    private Action luaUpdate;
    private Action luaFixedUpdate;
    private Action luaOnDestroy;

    private LuaTable scriptEnv;

    void Awake()
    {
        LuaEnv luaEnv = LuaScriptManager.Instance.GetLuaEnv();
        scriptEnv = luaEnv.NewTable();

        LuaTable meta = luaEnv.NewTable();
        meta.Set("__index", luaEnv.Global);
        scriptEnv.SetMetaTable(meta);
        meta.Dispose();

        scriptEnv.Set("self", this);
        foreach (var injection in injections)
        {
            scriptEnv.Set(injection.name, injection.value);
        }

        string luaScirpts = LuaScriptManager.Instance.GetLuaScriptText(luaScriptPath);
        luaEnv.DoString(luaScirpts, "LuaBehaviour", scriptEnv);

        Action luaAwake = scriptEnv.Get<Action>("awake");
        scriptEnv.Get("start", out luaStart);
        scriptEnv.Get("update", out luaUpdate);
        scriptEnv.Get("fixedUpdate", out luaFixedUpdate);
        scriptEnv.Get("ondestroy", out luaOnDestroy);

        if (luaAwake != null)
        {
            luaAwake();
        }
    }

    // Use this for initialization
    void Start()
    {
        if (luaStart != null)
        {
            luaStart();
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (luaUpdate != null)
        {
            luaUpdate();
        }
    }

    void FixedUpdate()
    {
        if (luaFixedUpdate != null)
        {
            luaFixedUpdate();
        }
    }

    void OnDestroy()
    {
        if (luaOnDestroy != null)
        {
            luaOnDestroy();
        }
        luaOnDestroy = null;
        luaUpdate = null;
        luaStart = null;
        scriptEnv.Dispose();
        injections = null;
    }
}
