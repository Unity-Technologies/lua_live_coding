using UnityEngine;

//使用该单例在切换场景是不会销毁，需要特别注意，如果存用户数据，则要考虑切换用户带来的隐患
//[XLua.LuaCallCSharp]
public class SingletonDontDestroy<T> : MonoBehaviour where T : MonoBehaviour
{
    private static T _instance;

    private static object _lock = new object();

    public static T Instance
    {
        get
        {
            if (applicationIsQuitting && Application.isPlaying)
            {
                G6Debugger.LogWarning("[Singleton] Instance '" + typeof(T) +
                "' already destroyed on application quit." +
                " Won't create again - returning null.");
                return null;
            }

            lock (_lock)
            {
                if (_instance == null)
                {
                    _instance = (T)FindObjectOfType(typeof(T));

                    if (FindObjectsOfType(typeof(T)).Length > 1)
                    {
                        G6Debugger.LogError("[Singleton] Something went really wrong " +
                        " - there should never be more than 1 singleton!" +
                        " Reopening the scene might fix it.");
                        return _instance;
                    }

                    if (_instance == null)
                    {
                        GameObject singleton = new GameObject();
                        _instance = singleton.AddComponent<T>();
                        singleton.name = "(singleton) " + typeof(T).ToString();

                        if(Application.isPlaying)
                        {
                            DontDestroyOnLoad(singleton);
                        }

                        G6Debugger.Log("[Singleton] An instance of " + typeof(T) +
                        " is needed in the scene, so '" + singleton +
                        "' was created with DontDestroyOnLoad.");
                    }
                    else
                    {
                        G6Debugger.LogWarning("[Singleton] Using instance already created: " +
                        _instance.gameObject.name);
                    }
                }

                return _instance;
            }
        }
    }

    private static bool applicationIsQuitting = false;
    /// <summary>
    /// When Unity quits, it destroys objects in a random order.
    /// In principle, a Singleton is only destroyed when application quits.
    /// If any script calls Instance after it have been destroyed, 
    ///   it will create a buggy ghost object that will stay on the Editor scene
    ///   even after stopping playing the Application. Really bad!
    /// So, this was made to be sure we're not creating that buggy ghost object.
    /// 如果在整个游戏退出前，SingletonDontDestroy并没有产生实例，applicationIsQuitting就
    /// 不会被置为true，这个时候，其他代码中调用单例就会触发ghost object问题
    /// 应该尽量确保SingletonDontDestroy产生实例
    /// </summary>
    protected virtual void OnDestroy()
    {
        applicationIsQuitting = true;
    }
}
