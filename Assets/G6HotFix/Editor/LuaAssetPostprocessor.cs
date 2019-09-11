using UnityEditor;

namespace G6HotFix.Editor
{
    class LuaAssetPostprocessor : AssetPostprocessor
    {
        static void OnPostprocessAllAssets(string[] importedAssets, string[] deletedAssets, string[] movedAssets, string[] movedFromAssetPaths)
        {
            foreach (string str in importedAssets)
            {
                if (str.StartsWith(G6HotFixConst.LUA_SOURCES_PATH))
                {
                    G6HotFixUtil.SendLuaSciprtSource(str, true);
                }
            }
            //        foreach (string str in deletedAssets)
            //        {
            //            Debug.Log("Deleted Asset: " + str);
            //        }
            //
            //        for (int i = 0; i < movedAssets.Length; i++)
            //        {
            //            Debug.Log("Moved Asset: " + movedAssets[i] + " from: " + movedFromAssetPaths[i]);
            //        }
        }
    }
}

