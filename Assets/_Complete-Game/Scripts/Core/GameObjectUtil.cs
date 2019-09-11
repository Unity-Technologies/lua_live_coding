// desc game object util class implementation
// maintainer hugoyu

using System;
using System.Collections.Generic;
using UnityEngine;

[XLua.LuaCallCSharp]
public static class GameObjectUtil
{
    public static GameObject InstantiateGameObject(GameObject prefab)
    {
        return GameObject.Instantiate<GameObject>(prefab);
    }

    static void FindGameObjectRecur(GameObject go, string name, List<GameObject> buffer)
    {
        GameObject temp = TransformEx.GetChildGameObject(go, name);
        if (temp)
        {
            buffer.Add(temp);
        }

        
    }

    public static GameObject[] FindAllGameObjects(GameObject go, string name)
    {
        var goBuffer = new List<GameObject>();
        FindGameObjectRecur(go, name, goBuffer);
        return goBuffer.ToArray();
        
    }

    public static GameObject FindGameObject(GameObject go, string name)
    {
       return TransformEx.GetChildGameObject(go, name);     
    }

    public static Transform FindTransform(GameObject go, string name)
    {
        var findGO = TransformEx.GetChildGameObject(go, name);
        return findGO ? findGO.transform : null;
    }

    // 不递归
    private static GameObject FindGameObjectInChildren(GameObject parent, string name)
    {        
        var childTransform = parent.transform.Find(name);
        return childTransform != null ? childTransform.gameObject : null;
    }

    public static GameObject FindGameObjectStrictly(GameObject root, string path)
    {
        var childTransform = root.transform.Find(path);
        return childTransform != null ? childTransform.gameObject : null;
    }

    // NOTE apply operation to all game objects in root, use DFS
    public static void ApplyAllGameObjects(GameObject root, Action<GameObject> operation)
    {
        if (operation != null)
        {
            // apply to root first
            operation(root);

            // apply to children
            var transform = root.transform;
            int childCount = transform.childCount;
            for (int i = 0; i < childCount; ++i)
            {
                var childTransform = transform.GetChild(i);
                if (childTransform.childCount > 0)
                {
                    ApplyAllGameObjects(childTransform.gameObject, operation);
                }
                else
                {
                    operation(childTransform.gameObject);
                }
            }
        }
    }

    public static void SetLayerRecur(GameObject root, int layer)
    {
        ApplyAllGameObjects(root, (go) => { go.layer = layer; });
    }

    public static void DestroyAllChildren(GameObject root)
    {
        if (root)
        {
            int childCount = root.transform.childCount;
            for (int i = 0; i < childCount; ++i)
            {
                var child = root.transform.GetChild(i);
                if (child)
                {
                    UnityEngine.Object.Destroy(child.gameObject);
                }
            }
        }
    }

    public static void DestroyAllChildrenImmediate(GameObject root)
    {
        if (root)
        {
            int childCount = root.transform.childCount;
            if (childCount > 0)
            {
                var childrenBuffer = new List<Transform>(childCount);
                
                for (int i = 0; i < childCount; ++i)
                {
                    var child = root.transform.GetChild(i);
                    if (child)
                    {
                        childrenBuffer.Add(child);
                    }
                }

                for (int i = 0; i < childrenBuffer.Count; ++i)
                {
                    UnityEngine.Object.DestroyImmediate(childrenBuffer[i].gameObject);
                }
            }
        }
    }

    public static bool GameObjectCheckEqual(UnityEngine.Object a, UnityEngine.Object b)
    {
        return a == b;
    }

    public static bool GameObjectCheckNull(UnityEngine.Object obj)
    {
        return obj == null;
    }

    public static T GetOrAddComponent<T>(GameObject go) where T : Component
    {
        if (go != null)
        {
            var component = go.GetComponent<T>();
            if (component == null)
            {
                component = go.AddComponent<T>();
            }

            return component;
        }

        return null;
    }
    
    public static T GetOrAddComponent<T>(Transform transform) where T : Component
    {
        if (transform != null)
        {
            return GetOrAddComponent<T>(transform.gameObject);
        }

        return null;
    }

    public static void RemoveComponent<T>(GameObject go) where T : Component
    {
        if (go != null)
        {
            var component = go.GetComponent<T>();
            if (component != null)
            {
                UnityEngine.Object.Destroy(component);
            }
        }
    }

    public static void RemoveComponent<T>(Transform transform) where T : Component
    {
        if (transform != null)
        {
            RemoveComponent<T>(transform.gameObject);
        }
    }

    public static string GetHierarchyName(Transform trans, string defaultName = null)
    {
        if (trans != null)
        {
            // get self name
            var name = trans.name;
            // get hierarchy name
            var parent = trans.parent;
            while (parent != null)
            {
                name = parent.name + "." + name;
                parent = parent.parent;
            }
            // add root name
            name = "[SceneRoot]." + name;

            return name;
        }

        return defaultName;
    }

    public static string GetHierarchyName(GameObject go, string defaultName = null)
    {
        if (go != null)
        {
            return GetHierarchyName(go.transform, defaultName);
        }

        return defaultName;
    }

    public static void ResetTransform(Transform transform)
    {
        if (transform)
        {
            transform.localPosition = Vector3.zero;
            transform.localRotation = Quaternion.identity;
            transform.localScale = Vector3.one;
        }
    }

    public static void ResetTransform(GameObject go)
    {
        if (go)
        {
            var transform = go.transform;
            transform.localPosition = Vector3.zero;
            transform.localRotation = Quaternion.identity;
            transform.localScale = Vector3.one;
        }
    }

    public static GameObject CreateGameObject(string name, GameObject parent = null)
    {
        var gameObject = new GameObject(name);
        if (parent)
        {
            gameObject.transform.SetParent(parent.transform, false);
        }

        ResetTransform(gameObject);

        return gameObject;
    }

    public static void DontDestroyOnLoadGameObject(GameObject go)
    {
        if (go)
        {
            UnityEngine.Object.DontDestroyOnLoad(go);
        }
    }

    public static void ReleaseGameObject(GameObject go)
    {
        if (go)
        {
            UnityEngine.Object.Destroy(go);
        }
    }

}
