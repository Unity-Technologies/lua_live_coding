---@class TransformEx : System.Object
local m = {}

---@static
---@param root UnityEngine.Transform
---@param name string
---@return UnityEngine.Transform
function m.FindChild(root, name) end

---@static
---@param trans UnityEngine.Transform
---@param name string
---@param recursively boolean
---@return UnityEngine.Transform
function m.Find(trans, name, recursively) end

---@static
---@param transform UnityEngine.Transform
---@return UnityEngine.Transform
function m.RemoveAllChild(transform) end

---@static
---@param fromGameObject UnityEngine.GameObject
---@param withName string
---@return UnityEngine.GameObject
function m.GetChildGameObject(fromGameObject, withName) end

TransformEx = m
return m
