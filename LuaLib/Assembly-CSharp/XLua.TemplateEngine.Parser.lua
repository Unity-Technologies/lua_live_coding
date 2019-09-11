---@class XLua.TemplateEngine.Parser : System.Object
---@field public RegexString string @static
local m = {}

---@static
---@param snippet string
---@return XLua.TemplateEngine.Chunk[]
function m.Parse(snippet) end

XLua.TemplateEngine.Parser = m
return m
