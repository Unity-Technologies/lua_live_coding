------------------------------------------
--- G6Helper
--- 全局Lua公用函数库
------------------------------------------

--
--Create an class.
--
function _G.clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function _G.Class(classname, super)
    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object
        cls = {}

        if superType == "table" then
            -- copy fields from super
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
        end

        cls.ctor    = function() end
        cls.__cname = classname
        cls.__ctype = 1

        function cls.New(...)
            local instance = cls.__create(...)
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            instance.class = cls
            instance:ctor(...)
            return instance
        end

    else
        -- inherited from Lua Object
        if super then
            cls = clone(super)
            cls.super = super
        else
            cls = {ctor = function() end}
        end

        cls.__cname = classname
        cls.__ctype = 2 -- lua
        cls.__index = cls

        function cls.New(...)
            local instance = setmetatable({}, cls)
            instance.class = cls
            instance:ctor(...)
            return instance
        end
    end

    return cls, super
end

function _G.CreateUIBehaviour(name, parent)
    parent = parent or "LuaScripts.G6Framework.G6Core.Core.LuaBehaviour"
    local parent_lua = require(parent)
    return _G.Class(name, parent_lua)
end

--- 打印表内容
---@overload fun(tbl: table):string
---@param TableToPrint table
---@param MaxIntent number
---@return string
function _G.TableToString (TableToPrint, MaxIntent)
    local HandlerdTable = {}
    local function ItretePrintTable(TP, Indent)
        if not Indent then Indent = 0 end
        if type(TP) ~= "table" then return tostring(TP) end

        if(Indent > MaxIntent) then return tostring(TP) end

        if HandlerdTable[TP] then
            return "";
        end
        HandlerdTable[TP] = true
        local StrToPrint = string.rep(" ", Indent) .. "{\r\n"
        Indent = Indent + 2
        for k, v in pairs(TP) do
            StrToPrint = StrToPrint .. string.rep(" ", Indent)
            if (type(k) == "number") then
                StrToPrint = StrToPrint .. "[" .. k .. "] = "
            elseif (type(k) == "string") then
                StrToPrint = StrToPrint  .. k ..  "= "
            else
                StrToPrint = StrToPrint  .. tostring(k) ..  " = "
            end
            if (type(v) == "number") then
                StrToPrint = StrToPrint .. v .. ",\r\n"
            elseif (type(v) == "string") then
                StrToPrint = StrToPrint .. "\"" .. v .. "\",\r\n"
            elseif (type(v) == "table") then
                StrToPrint = StrToPrint .. tostring(v) .. ItretePrintTable(v, Indent + 2) .. ",\r\n"
            else
                StrToPrint = StrToPrint .. "\"" .. tostring(v) .. "\",\r\n"
            end
        end
        StrToPrint = StrToPrint .. string.rep(" ", Indent-2) .. "}"
        return StrToPrint
    end

    if MaxIntent == nil then
        MaxIntent = 64
    end
    return ItretePrintTable(TableToPrint)
end

------------------------------------------------------------------------------------------------------------------------
-- 拷贝表 userdata不拷贝，可能造成释放问题。
------------------------------------------------------------------------------------------------------------------------
function _G.TableDeepCopy( obj )
    local allcopyed = {}  --记录已拷贝过的数据，避免类似 A.__index = A 造成死循环
    local function DeepCopy(obj)
        if allcopyed[obj] ~= nil then
          return allcopyed[obj]
        end
        if type(obj) ~= "table" then
            return obj;
        end

        allcopyed[obj] = obj

        local NewTable = {};
        for k,v in pairs(obj) do  --把旧表的key和Value赋给新表
            local newKey = DeepCopy(k)
            local newValue = DeepCopy(v)
            if type(k) ~= "userdata" and type(v) ~= "userdata" then
                allcopyed[k] = newKey
                allcopyed[v] = newValue
                NewTable[newKey] = newValue;
            end
        end
        return setmetatable(NewTable, getmetatable(obj))--赋值元表
    end
    return DeepCopy(obj)
end

---------------------------------------------
-- 合并表,注意: key会覆盖
---------------------------------------------
function _G.MergeTable(tSrc,tDst)
    local tResult = {};
    if (nil ~= tSrc) then
       for _k,_v in pairs(tSrc) do
          tResult[_k] = _v;
       end
    end
    if (nil ~= tDst) then
       for _k,_v in pairs(tDst) do
          tResult[_k] = _v;
       end
    end
    return tResult;
end

function _G.CompareTable(t1, t2)
    --print(TableToString(t1))
    --print(TableToString(t2))
    local keySet = {}

    if t1 == t2 then return true end

    local o1Type = type(t1)
    local o2Type = type(t2)
    if o1Type ~= o2Type then return false end
    if o1Type ~= 'table' then return false end

    if keySet[t1] == true then
        return true
    end

    for key1, value1 in pairs(t1) do
        --print("key1", key1, value1, t2[key1])
        if string.find(key1, "__") == 1 then
        elseif type(value1) == "table" then
            if CompareTable(value1, t2[key1]) == false then
                return false
            end
            keySet[key1] = true
        elseif type(value1) == "function" or type(value1) == "userdata" then
        else
            local value2 = t2[key1]
            if value2 == nil then return false end
            if value2 ~= value1 then return false end
            keySet[key1] = true
        end
    end

    for key2, val2 in pairs(t2) do
        --print(key2, keySet[key2])
        if type(val2) ~= "function" and type(val2) ~= "userdata" then
            if not keySet[key2] then
                --print("3")
                return false
            end
        end
    end
    return true
end

function _G.StringSplit( str,reps )
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
        table.insert(resultStrList,w)
    end)
    return resultStrList
end

-- 用于去除字符串的前后空格的函数
function _G.Trim(String)
    return String:gsub("^%s*(.-)%s*$", "%1", 1)
end

function _G.error_handler(err)
    print(err .. debug.traceback())
end

function _G.IsFileExist(strFileName)
    return UEIsFileExists(strFileName);
end

function _G.GetFileModifyTime(strFileName)
    local fullName = strFileName
    if G6ENV and G6ENV._LUA_ROOT_PATH then
        fullName = G6ENV._LUA_ROOT_PATH .. strFileName
    end
    return 0    --UEGetFileDateTime(fullName);
end

function _G.IsPlatformPC()
    return (G6ENV._PLATFORM == "PLATFORM_WINDOWS" or G6ENV._PLATFORM == "PLATFORM_MAC");
end

function _G.Number2Bytes(num, width)
  local function _n2b(t, width, num, rem)
    if width == 0 then return table.concat(t) end
    table.insert(t, 1, string.char(rem * 256))
    return _n2b(t, width-1, math.modf(num/256))
  end
  return _n2b({}, width, math.modf(num/256))
end

function _G.Bytes2Number(str)
  local function _b2n(num, digit, ...)
    if not digit then return num end
    return _b2n(num*256 + digit, ...)
  end
  return _b2n(0, string.byte(str, 1, -1))
end

local G6Util = {}

--- 获取文件名不包含扩展名
--- @return string
function G6Util.GetFileNameWithoutExt(strFileName)
    local idx = strFileName:match(".+()%.%w+$");
    if(idx) then
        return strFileName:sub(1, idx-1);
    else
        return strFileName;
    end
end

--- 获取扩展名
--- @return string
function G6Util.GetFileExtension(strFileName)
    return strFileName:match(".+%.(%w+)$")
end

--- 计算无序table的长度
--- @return number
function G6Util.GetTableLen(ltable)
    local Count = 0;
    for k,v in pairs(ltable) do
        Count = Count + 1;
    end

    return Count;
end

--- @param  Path string 文件夹路径
--- @return string
function G6Util.NormalizePath(Path)
    if G6ENV._PLATFORM == 'PLATFORM_WINDOWS' then
      return (Path:gsub("\\", "/"))
    else
      return Path
    end
  end

--- 文件或文件夹是否存在
--- @param  Path string 文件夹路径
--- @return boolean
function G6Util.FileExists(Path)
    require "lfs"
	return lfs.attributes(Path, "mode") ~= nil
  end

--- 获取文件夹路径
--- @param  Path string 文件夹路径
--- @return string
function G6Util.GetDirname(PathOrFileName)
	local path = PathOrFileName:gsub("[^/]+/*$", "")
	if path == "" then
	  return PathOrFileName
	end
	return path
  end

--Recursive directory creation
--- @param  Path string 文件夹路径
--- @return boolean, string
function G6Util.rmkdir(Path)
    Path = G6Util.NormalizePath(Path)
	if lfs.attributes(Path, 'mode') == 'directory' then
	  return true
	end
	if G6Util.GetDirname(Path) == Path then
	  -- We're being asked to create the root directory!
	  return nil,"mkdir: unable to create root directory"
	end
	local r,err = G6Util.rmkdir(G6Util.GetDirname(Path))
	if not r then
	  return nil,err.." (creating "..Path..")"
	end
	return lfs.mkdir(Path)
end

--- 删除文件夹
--- @param  Path string 文件夹路径
function G6Util.DeleteDir(Path)
--lfs.mdir(PathNeedDelete) 只能删除空文件夹，所以做了封装
 --ios 9 之后 去掉了 system，execute 使用 posix_spawn
--os.execute("/bin/rm", "-rf", PathNeedDelete) 在MAC上成功，IOS上返回1（权限不足）
    -- if G6ENV._PLATFORM == 'PLATFORM_WINDOWS' then
    --     os.execute("rd /s /q " .. "\"" .. PathNeedDelete .. "\"" )
    -- end
    require "lfs"
    if not G6Util.FileExists(Path) then
        return
    end

    for file in lfs.dir(Path) do
        local file_path = Path..'/'..file
        if file ~= "." and file ~= ".." then
            if lfs.attributes(file_path, 'mode') == 'file' then
                os.remove(file_path)
            elseif lfs.attributes(file_path, 'mode') == 'directory' then
                G6Util.DeleteDir(file_path)
            end
        end
    end
    lfs.rmdir(Path)
end

_G.G6Util = G6Util