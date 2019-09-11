using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AddressableAssets;
using UnityEngine.ResourceManagement;

namespace G6Demo.Core
{
    public class G6ResourceManager : SingletonDontDestroy<G6ResourceManager>
    {
        public void Init()
        {

        }

        private bool isLoadCompleted;
        public bool IsLoadCompleted
        {
            get
            {
                return isLoadCompleted;
            }
        }

        public void LoadEnemyAssets()
        {
            Addressables.LoadAssets<IResourceLocation>("Enemy", null).Completed += OnEnemyAssetsLoaded;
        }

        private List<IResourceLocation> enemyLocations;

        public List<IResourceLocation> EnemyLocations
        {
            get
            {
                return enemyLocations;
            }
        }

        // ADDRESSABLES UPDATES
        private void OnEnemyAssetsLoaded(IAsyncOperation<IList<IResourceLocation>> op)
        {
            isLoadCompleted = true;
            enemyLocations = new List<IResourceLocation>(op.Result);
        }

        public static IAsyncOperation Instantiate(IResourceLocation assetReference, Vector3 position, Quaternion rotation, Transform parent = null)
        {
            return Addressables.Instantiate<GameObject>(assetReference, position, rotation, parent);
        }
    }
}