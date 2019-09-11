using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement;

public class EnemyBornList : MonoBehaviour
{
    public Transform[] spawnPoints;         // An array of the spawn points enemy can spawn from.

    public static IAsyncOperation Instantiate(AssetReference assetReference, Vector3 position, Quaternion rotation, Transform parent = null)
    {
        return assetReference.Instantiate<GameObject>(position, rotation, parent);
    }
}
