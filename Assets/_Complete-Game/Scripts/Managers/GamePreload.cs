using System.Collections.Generic;
using G6HotFix.LuaScripts;
using G6Demo.Core;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement;
using UnityEngine.SceneManagement;

public class GamePreload : MonoBehaviour
{
    private bool isLogoShowCompleted = false;

    private bool isChangingScene = false;

	// Use this for initialization
	void Start () {
#if !UNITY_EDITOR
	    Application.targetFrameRate = 60;
#endif

        LuaScriptManager.Instance.LoadScripts();
        G6ResourceManager.Instance.LoadEnemyAssets();
    }
	
	// Update is called once per frame
	void Update () {
	    if (Time.realtimeSinceStartup > 3f)
	    {
	        isLogoShowCompleted = true;
	    }

	    if (isLogoShowCompleted && !isChangingScene && G6ResourceManager.Instance.IsLoadCompleted)
	    {
	        isChangingScene = true;

            SceneManager.LoadScene("Game");
        }
    }
}
