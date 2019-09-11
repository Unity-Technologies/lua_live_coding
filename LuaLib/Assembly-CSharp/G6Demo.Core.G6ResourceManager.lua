---@class G6Demo.Core.G6ResourceManager : SingletonDontDestroy_1_G6Demo_Core_G6ResourceManager_
---@field public IsLoadCompleted boolean
---@field public EnemyLocations UnityEngine.ResourceManagement.IResourceLocation[]
local m = {}

function m:Init() end

function m:LoadEnemyAssets() end

---@overload fun(assetReference:UnityEngine.ResourceManagement.IResourceLocation, position:UnityEngine.Vector3, rotation:UnityEngine.Quaternion): @static
---@static
---@param assetReference UnityEngine.ResourceManagement.IResourceLocation
---@param position UnityEngine.Vector3
---@param rotation UnityEngine.Quaternion
---@param parent UnityEngine.Transform
---@return UnityEngine.ResourceManagement.IAsyncOperation
function m.Instantiate(assetReference, position, rotation, parent) end

G6Demo.Core.G6ResourceManager = m
return m
