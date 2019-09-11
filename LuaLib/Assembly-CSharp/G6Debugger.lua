---@class G6Debugger : System.Object
local m = {}

---@static
---@param message string
function m.LogString(message) end

---@overload fun(message:any) @static
---@static
---@param message any
---@param obj UnityEngine.Object
function m.Log(message, obj) end

---@overload fun(message:any) @static
---@static
---@param message any
---@param obj UnityEngine.Object
function m.LogWithoutCondition(message, obj) end

---@overload fun(message:any) @static
---@static
---@param message any
---@param obj UnityEngine.Object
function m.LogWarningWithoutCondition(message, obj) end

---@overload fun(message:any) @static
---@static
---@param message any
---@param obj UnityEngine.Object
function m.LogWarning(message, obj) end

---@overload fun(message:any, obj:UnityEngine.Object) @static
---@static
---@param message any
function m.LogError(message) end

---@static
---@param e System.Exception
function m.LogException(e) end

---@overload fun(start:UnityEngine.Vector3, _end:UnityEngine.Vector3, color:UnityEngine.Color, duration:number, depthTest:boolean) @static
---@overload fun(start:UnityEngine.Vector3, _end:UnityEngine.Vector3, color:UnityEngine.Color, duration:number) @static
---@overload fun(start:UnityEngine.Vector3, _end:UnityEngine.Vector3) @static
---@static
---@param start UnityEngine.Vector3
---@param _end UnityEngine.Vector3
---@param color UnityEngine.Color
function m.DrawLine(start, _end, color) end

---@overload fun(format:string) @static
---@overload fun(context:UnityEngine.Object, format:string, ...:any|any[]) @static
---@overload fun(context:UnityEngine.Object, format:string) @static
---@static
---@param format string
---@param ... any|any[]
function m.LogFormat(format, ...) end

---@overload fun(format:string) @static
---@overload fun(context:UnityEngine.Object, format:string, ...:any|any[]) @static
---@overload fun(context:UnityEngine.Object, format:string) @static
---@static
---@param format string
---@param ... any|any[]
function m.LogErrorFormat(format, ...) end

---@overload fun(condition:boolean, message:any) @static
---@static
---@param condition boolean
function m.Assert(condition) end

---@overload fun(format:string) @static
---@overload fun(context:UnityEngine.Object, format:string, ...:any|any[]) @static
---@overload fun(context:UnityEngine.Object, format:string) @static
---@static
---@param format string
---@param ... any|any[]
function m.LogWarningFormat(format, ...) end

---@static
function m.Break() end

---@static
---@return string
function m.GetUILog() end

---@static
function m.ClearUILog() end

G6Debugger = m
return m
