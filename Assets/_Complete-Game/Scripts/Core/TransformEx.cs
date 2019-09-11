using UnityEngine;
using System.Collections;

[XLua.LuaCallCSharp]
public static class TransformEx
{
    public static Transform FindChild(Transform root, string name)
    {
        if (root == null)
        {
            return null;
        }

        Transform _temp = root.Find(name);
        if (_temp)
        {
            return _temp;
        }

        for (int index = 0; index < root.childCount; ++index)
        {
            Transform child = root.GetChild(index);
            _temp = FindChild(child, name);
            if (_temp)
            {
                return _temp;
            }
        }

        return _temp;
    }

    public static Transform Find(this Transform trans, string name, bool recursively)
    {
        if (!trans)
        {
            return null;
        }

        if (recursively)
        {
            return FindChild(trans, name);
        }
        else
        {
            return trans.Find(name);
        }
    }

    public static Transform RemoveAllChild(this Transform transform)
    {
        for (int index = 0; index < transform.childCount; ++index)
        {
            Transform child = transform.GetChild(index);
            GameObject.Destroy(child.gameObject);
        }

        return transform;
    }

    static public GameObject GetChildGameObject(GameObject fromGameObject, string withName)
    {
        Transform temp = FindChild(fromGameObject.transform, withName);
        if (temp != null)
            return temp.gameObject;
        return null;
    }
}
