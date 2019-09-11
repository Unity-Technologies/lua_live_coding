using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class UIMenuUtil : MonoBehaviour {

    [MenuItem("GameObject/GetPath", false, 10)]
    static void PathOfGameObject(MenuCommand menuCommand)
    {
        GameObject obj = Selection.activeObject as GameObject;

        string path = GameObjectPathTool.GetPathOfGameObject(obj, (go) =>
        {
            return go == null || go.GetComponent<LuaOperation>() != null;
        });

        TextEditor te = new TextEditor();
        te.text = path;
        te.OnFocus();
        te.Copy();
    }
}

public class GameObjectPathTool
{
    // 不能继续了，就返回true
    public delegate bool GetPathOfGameObjectChecker(Transform go);

    public static string GetPathOfGameObject(GameObject obj, GetPathOfGameObjectChecker checker)
    {
        string path = obj.name;

        Transform curr = obj.transform;
        while (!checker(curr.parent))
        {
            curr = curr.parent;

            path = curr.name + "/" + path;
        }

        return path;
    }
}
