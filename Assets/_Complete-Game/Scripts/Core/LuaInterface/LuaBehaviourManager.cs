using G6HotFix.LuaScripts;
using UnityEngine;
using XLua;

[CSharpCallLua]
public interface ILuaBehaviourManager
{
    void CreateBehaviour(string typename, GameObject obj);
    void CleanBehaviourCache(string typename);
    void ReloadBehaviour(string typename);
    LuaTable GetBehaviour(int id);
    void Update();
}

public class LuaBehaviourManager : SingletonDontDestroy<LuaBehaviourManager>
{
    private ILuaBehaviourManager luaBehaviourManager;

    void Awake()
    {
    }

    public void Init()
    {
        var luaEnv = LuaScriptManager.Instance.GetLuaEnv();
        luaBehaviourManager = luaEnv.Global.Get<ILuaBehaviourManager>("__BehaviourManager");
    }

    public void CreateBehaviour(string typename, GameObject obj)
    {
        luaBehaviourManager.CreateBehaviour(typename, obj);
    }
	
    public void CleanBehaviourCache(string typename)
    {
        luaBehaviourManager.CleanBehaviourCache(typename);
    }

    public void ReloadBehaviour(string typename)
    {
        luaBehaviourManager.ReloadBehaviour(typename);
    }

    public LuaTable GetLuaBehaviour(int instanceId)
    {
        return luaBehaviourManager.GetBehaviour(instanceId);
    }

    void Update() 
    {
#if UNITY_EDITOR
        if (luaBehaviourManager == null)
            return;
#endif
        luaBehaviourManager.Update();
	}
}
