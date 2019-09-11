---@class EnemyBornList : UnityEngine.MonoBehaviour
---@field public spawnPoints UnityEngine.Transform[]
local m = {}

---@overload fun(assetReference:UnityEngine.AddressableAssets.AssetReference, position:UnityEngine.Vector3, rotation:UnityEngine.Quaternion): @static
---@static
---@param assetReference UnityEngine.AddressableAssets.AssetReference
---@param position UnityEngine.Vector3
---@param rotation UnityEngine.Quaternion
---@param parent UnityEngine.Transform
---@return UnityEngine.ResourceManagement.IAsyncOperation
function m.Instantiate(assetReference, position, rotation, parent) end

EnemyBornList = m
return m
