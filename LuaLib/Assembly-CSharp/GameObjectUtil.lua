---@class GameObjectUtil : System.Object
local m = {}

---@static
---@param prefab UnityEngine.GameObject
---@return UnityEngine.GameObject
function m.InstantiateGameObject(prefab) end

---@static
---@param go UnityEngine.GameObject
---@param name string
---@return UnityEngine.GameObject[]
function m.FindAllGameObjects(go, name) end

---@static
---@param go UnityEngine.GameObject
---@param name string
---@return UnityEngine.GameObject
function m.FindGameObject(go, name) end

---@static
---@param go UnityEngine.GameObject
---@param name string
---@return UnityEngine.Transform
function m.FindTransform(go, name) end

---@static
---@param root UnityEngine.GameObject
---@param path string
---@return UnityEngine.GameObject
function m.FindGameObjectStrictly(root, path) end

---@static
---@param root UnityEngine.GameObject
---@param operation fun(obj:UnityEngine.GameObject)
function m.ApplyAllGameObjects(root, operation) end

---@static
---@param root UnityEngine.GameObject
---@param layer number
function m.SetLayerRecur(root, layer) end

---@static
---@param root UnityEngine.GameObject
function m.DestroyAllChildren(root) end

---@static
---@param root UnityEngine.GameObject
function m.DestroyAllChildrenImmediate(root) end

---@static
---@param a UnityEngine.Object
---@param b UnityEngine.Object
---@return boolean
function m.GameObjectCheckEqual(a, b) end

---@static
---@param obj UnityEngine.Object
---@return boolean
function m.GameObjectCheckNull(obj) end

---@overload fun(transform:UnityEngine.Transform): @static
---@static
---@param go UnityEngine.GameObject
---@return UnityEngine.Component
function m.GetOrAddComponent(go) end

---@overload fun(transform:UnityEngine.Transform) @static
---@static
---@param go UnityEngine.GameObject
function m.RemoveComponent(go) end

---@overload fun(trans:UnityEngine.Transform): @static
---@overload fun(go:UnityEngine.GameObject, defaultName:string): @static
---@overload fun(go:UnityEngine.GameObject): @static
---@static
---@param trans UnityEngine.Transform
---@param defaultName string
---@return string
function m.GetHierarchyName(trans, defaultName) end

---@overload fun(go:UnityEngine.GameObject) @static
---@static
---@param transform UnityEngine.Transform
function m.ResetTransform(transform) end

---@overload fun(name:string): @static
---@static
---@param name string
---@param parent UnityEngine.GameObject
---@return UnityEngine.GameObject
function m.CreateGameObject(name, parent) end

---@static
---@param go UnityEngine.GameObject
function m.DontDestroyOnLoadGameObject(go) end

---@static
---@param go UnityEngine.GameObject
function m.ReleaseGameObject(go) end

GameObjectUtil = m
return m
