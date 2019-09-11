---@class XLua.LuaDLL.Lua : System.Object
local m = {}

---@static
---@param L System.IntPtr
---@param index number
---@return System.IntPtr
function m.lua_tothread(L, index) end

---@static
---@return number
function m.xlua_get_lib_version() end

---@static
---@param L System.IntPtr
---@param what XLua.LuaGCOptions
---@param data number
---@return number
function m.lua_gc(L, what, data) end

---@static
---@param L System.IntPtr
---@param funcindex number
---@param n number
---@return System.IntPtr
function m.lua_getupvalue(L, funcindex, n) end

---@static
---@param L System.IntPtr
---@param funcindex number
---@param n number
---@return System.IntPtr
function m.lua_setupvalue(L, funcindex, n) end

---@static
---@param L System.IntPtr
---@return number
function m.lua_pushthread(L) end

---@static
---@param L System.IntPtr
---@param stackPos number
---@return boolean
function m.lua_isfunction(L, stackPos) end

---@static
---@param L System.IntPtr
---@param stackPos number
---@return boolean
function m.lua_islightuserdata(L, stackPos) end

---@static
---@param L System.IntPtr
---@param stackPos number
---@return boolean
function m.lua_istable(L, stackPos) end

---@static
---@param L System.IntPtr
---@param stackPos number
---@return boolean
function m.lua_isthread(L, stackPos) end

---@static
---@param L System.IntPtr
---@param message string
---@return number
function m.luaL_error(L, message) end

---@static
---@param L System.IntPtr
---@param stackPos number
---@return number
function m.lua_setfenv(L, stackPos) end

---@static
---@return System.IntPtr
function m.luaL_newstate() end

---@static
---@param L System.IntPtr
function m.lua_close(L) end

---@static
---@param L System.IntPtr
function m.luaopen_xlua(L) end

---@static
---@param L System.IntPtr
function m.luaL_openlibs(L) end

---@static
---@param L System.IntPtr
---@param stackPos number
---@return number
function m.xlua_objlen(L, stackPos) end

---@static
---@param L System.IntPtr
---@param narr number
---@param nrec number
function m.lua_createtable(L, narr, nrec) end

---@static
---@param L System.IntPtr
function m.lua_newtable(L) end

---@static
---@param L System.IntPtr
---@param name string
---@return number
function m.xlua_getglobal(L, name) end

---@static
---@param L System.IntPtr
---@param name string
---@return number
function m.xlua_setglobal(L, name) end

---@static
---@param L System.IntPtr
function m.xlua_getloaders(L) end

---@static
---@param L System.IntPtr
---@param newTop number
function m.lua_settop(L, newTop) end

---@static
---@param L System.IntPtr
---@param amount number
function m.lua_pop(L, amount) end

---@static
---@param L System.IntPtr
---@param newTop number
function m.lua_insert(L, newTop) end

---@static
---@param L System.IntPtr
---@param index number
function m.lua_remove(L, index) end

---@static
---@param L System.IntPtr
---@param index number
---@return number
function m.lua_rawget(L, index) end

---@static
---@param L System.IntPtr
---@param index number
function m.lua_rawset(L, index) end

---@static
---@param L System.IntPtr
---@param objIndex number
---@return number
function m.lua_setmetatable(L, objIndex) end

---@static
---@param L System.IntPtr
---@param index1 number
---@param index2 number
---@return number
function m.lua_rawequal(L, index1, index2) end

---@static
---@param L System.IntPtr
---@param index number
function m.lua_pushvalue(L, index) end

---@static
---@param L System.IntPtr
---@param fn System.IntPtr
---@param n number
function m.lua_pushcclosure(L, fn, n) end

---@static
---@param L System.IntPtr
---@param index number
function m.lua_replace(L, index) end

---@static
---@param L System.IntPtr
---@return number
function m.lua_gettop(L) end

---@static
---@param L System.IntPtr
---@param index number
---@return XLua.LuaTypes
function m.lua_type(L, index) end

---@static
---@param L System.IntPtr
---@param index number
---@return boolean
function m.lua_isnil(L, index) end

---@static
---@param L System.IntPtr
---@param index number
---@return boolean
function m.lua_isnumber(L, index) end

---@static
---@param L System.IntPtr
---@param index number
---@return boolean
function m.lua_isboolean(L, index) end

---@overload fun(L:System.IntPtr): @static
---@static
---@param L System.IntPtr
---@param registryIndex number
---@return number
function m.luaL_ref(L, registryIndex) end

---@static
---@param L System.IntPtr
---@param tableIndex number
---@param index number
function m.xlua_rawgeti(L, tableIndex, index) end

---@static
---@param L System.IntPtr
---@param tableIndex number
---@param index number
function m.xlua_rawseti(L, tableIndex, index) end

---@static
---@param L System.IntPtr
---@param reference number
function m.lua_getref(L, reference) end

---@static
---@param L System.IntPtr
---@param error_func_ref number
---@param func_ref number
---@return number
function m.pcall_prepare(L, error_func_ref, func_ref) end

---@static
---@param L System.IntPtr
---@param registryIndex number
---@param reference number
function m.luaL_unref(L, registryIndex, reference) end

---@static
---@param L System.IntPtr
---@param reference number
function m.lua_unref(L, reference) end

---@static
---@param L System.IntPtr
---@param index number
---@return boolean
function m.lua_isstring(L, index) end

---@static
---@param L System.IntPtr
---@param index number
---@return boolean
function m.lua_isinteger(L, index) end

---@static
---@param L System.IntPtr
function m.lua_pushnil(L) end

---@overload fun(L:System.IntPtr, _function:fun(L:System.IntPtr):) @static
---@static
---@param L System.IntPtr
---@param _function fun(L:System.IntPtr):
---@param n number
function m.lua_pushstdcallcfunction(L, _function, n) end

---@static
---@param n number
---@return number
function m.xlua_upvalueindex(n) end

---@static
---@param L System.IntPtr
---@param nArgs number
---@param nResults number
---@param errfunc number
---@return number
function m.lua_pcall(L, nArgs, nResults, errfunc) end

---@static
---@param L System.IntPtr
---@param index number
---@return number
function m.lua_tonumber(L, index) end

---@static
---@param L System.IntPtr
---@param index number
---@return number
function m.xlua_tointeger(L, index) end

---@static
---@param L System.IntPtr
---@param index number
---@return number
function m.xlua_touint(L, index) end

---@static
---@param L System.IntPtr
---@param index number
---@return boolean
function m.lua_toboolean(L, index) end

---@static
---@param L System.IntPtr
---@param index number
---@return System.IntPtr
function m.lua_topointer(L, index) end

---@static
---@param L System.IntPtr
---@param index number
---@return System.IntPtr, System.IntPtr
function m.lua_tolstring(L, index) end

---@static
---@param L System.IntPtr
---@param index number
---@return string
function m.lua_tostring(L, index) end

---@static
---@param L System.IntPtr
---@param panicf fun(L:System.IntPtr):
---@return System.IntPtr
function m.lua_atpanic(L, panicf) end

---@static
---@param L System.IntPtr
---@param number number
function m.lua_pushnumber(L, number) end

---@static
---@param L System.IntPtr
---@param value boolean
function m.lua_pushboolean(L, value) end

---@static
---@param L System.IntPtr
---@param value number
function m.xlua_pushinteger(L, value) end

---@static
---@param L System.IntPtr
---@param value number
function m.xlua_pushuint(L, value) end

---@overload fun(L:System.IntPtr, str:string) @static
---@static
---@param L System.IntPtr
---@param str string
function m.lua_pushstring(L, str) end

---@static
---@param L System.IntPtr
---@param str string
---@param size number
function m.xlua_pushlstring(L, str, size) end

---@static
---@param L System.IntPtr
---@param str string
function m.xlua_pushasciistring(L, str) end

---@static
---@param L System.IntPtr
---@param index number
---@return string
function m.lua_tobytes(L, index) end

---@static
---@param L System.IntPtr
---@param meta string
---@return number
function m.luaL_newmetatable(L, meta) end

---@static
---@param L System.IntPtr
---@param idx number
---@return number
function m.xlua_pgettable(L, idx) end

---@static
---@param L System.IntPtr
---@param idx number
---@return number
function m.xlua_psettable(L, idx) end

---@static
---@param L System.IntPtr
---@param meta string
function m.luaL_getmetatable(L, meta) end

---@static
---@param L System.IntPtr
---@param buff string
---@param size number
---@param name string
---@return number
function m.xluaL_loadbuffer(L, buff, size, name) end

---@static
---@param L System.IntPtr
---@param buff string
---@param name string
---@return number
function m.luaL_loadbuffer(L, buff, name) end

---@static
---@param L System.IntPtr
---@param obj number
---@return number
function m.xlua_tocsobj_safe(L, obj) end

---@static
---@param L System.IntPtr
---@param obj number
---@return number
function m.xlua_tocsobj_fast(L, obj) end

---@static
---@param L System.IntPtr
---@return number
function m.lua_error(L) end

---@static
---@param L System.IntPtr
---@param extra number
---@return boolean
function m.lua_checkstack(L, extra) end

---@static
---@param L System.IntPtr
---@param index number
---@return number
function m.lua_next(L, index) end

---@static
---@param L System.IntPtr
---@param udata System.IntPtr
function m.lua_pushlightuserdata(L, udata) end

---@static
---@return System.IntPtr
function m.xlua_tag() end

---@static
---@param L System.IntPtr
---@param level number
function m.luaL_where(L, level) end

---@static
---@param L System.IntPtr
---@param key number
---@param cache_ref number
---@return number
function m.xlua_tryget_cachedud(L, key, cache_ref) end

---@static
---@param L System.IntPtr
---@param key number
---@param meta_ref number
---@param need_cache boolean
---@param cache_ref number
function m.xlua_pushcsobj(L, key, meta_ref, need_cache, cache_ref) end

---@static
---@param L System.IntPtr
---@return number
function m.gen_obj_indexer(L) end

---@static
---@param L System.IntPtr
---@return number
function m.gen_obj_newindexer(L) end

---@static
---@param L System.IntPtr
---@return number
function m.gen_cls_indexer(L) end

---@static
---@param L System.IntPtr
---@return number
function m.gen_cls_newindexer(L) end

---@static
---@param L System.IntPtr
---@param Ref number
---@return number
function m.load_error_func(L, Ref) end

---@static
---@param L System.IntPtr
---@return number
function m.luaopen_i64lib(L) end

---@static
---@param L System.IntPtr
---@return number
function m.luaopen_socket_core(L) end

---@static
---@param L System.IntPtr
---@param n number
function m.lua_pushint64(L, n) end

---@static
---@param L System.IntPtr
---@param n number
function m.lua_pushuint64(L, n) end

---@static
---@param L System.IntPtr
---@param idx number
---@return boolean
function m.lua_isint64(L, idx) end

---@static
---@param L System.IntPtr
---@param idx number
---@return boolean
function m.lua_isuint64(L, idx) end

---@static
---@param L System.IntPtr
---@param idx number
---@return number
function m.lua_toint64(L, idx) end

---@static
---@param L System.IntPtr
---@param idx number
---@return number
function m.lua_touint64(L, idx) end

---@static
---@param L System.IntPtr
---@param fn System.IntPtr
---@param n number
function m.xlua_push_csharp_function(L, fn, n) end

---@static
---@param L System.IntPtr
---@param message string
---@return number
function m.xlua_csharp_str_error(L, message) end

---@static
---@param L System.IntPtr
---@return number
function m.xlua_csharp_error(L) end

---@static
---@param buff System.IntPtr
---@param offset number
---@param field number
---@return boolean
function m.xlua_pack_int8_t(buff, offset, field) end

---@static
---@param buff System.IntPtr
---@param offset number
---@return boolean, System.Byte
function m.xlua_unpack_int8_t(buff, offset) end

---@static
---@param buff System.IntPtr
---@param offset number
---@param field number
---@return boolean
function m.xlua_pack_int16_t(buff, offset, field) end

---@static
---@param buff System.IntPtr
---@param offset number
---@return boolean, System.Int16
function m.xlua_unpack_int16_t(buff, offset) end

---@static
---@param buff System.IntPtr
---@param offset number
---@param field number
---@return boolean
function m.xlua_pack_int32_t(buff, offset, field) end

---@static
---@param buff System.IntPtr
---@param offset number
---@return boolean, System.Int32
function m.xlua_unpack_int32_t(buff, offset) end

---@static
---@param buff System.IntPtr
---@param offset number
---@param field number
---@return boolean
function m.xlua_pack_int64_t(buff, offset, field) end

---@static
---@param buff System.IntPtr
---@param offset number
---@return boolean, System.Int64
function m.xlua_unpack_int64_t(buff, offset) end

---@static
---@param buff System.IntPtr
---@param offset number
---@param field number
---@return boolean
function m.xlua_pack_float(buff, offset, field) end

---@static
---@param buff System.IntPtr
---@param offset number
---@return boolean, System.Single
function m.xlua_unpack_float(buff, offset) end

---@static
---@param buff System.IntPtr
---@param offset number
---@param field number
---@return boolean
function m.xlua_pack_double(buff, offset, field) end

---@static
---@param buff System.IntPtr
---@param offset number
---@return boolean, System.Double
function m.xlua_unpack_double(buff, offset) end

---@static
---@param L System.IntPtr
---@param size number
---@param meta_ref number
---@return System.IntPtr
function m.xlua_pushstruct(L, size, meta_ref) end

---@static
---@param L System.IntPtr
---@param field_count number
---@param meta_ref number
function m.xlua_pushcstable(L, field_count, meta_ref) end

---@static
---@param L System.IntPtr
---@param idx number
---@return System.IntPtr
function m.lua_touserdata(L, idx) end

---@static
---@param L System.IntPtr
---@param idx number
---@return number
function m.xlua_gettypeid(L, idx) end

---@static
---@return number
function m.xlua_get_registry_index() end

---@static
---@param L System.IntPtr
---@param idx number
---@param path string
---@return number
function m.xlua_pgettable_bypath(L, idx, path) end

---@static
---@param L System.IntPtr
---@param idx number
---@param path string
---@return number
function m.xlua_psettable_bypath(L, idx, path) end

---@static
---@param buff System.IntPtr
---@param offset number
---@param f1 number
---@param f2 number
---@return boolean
function m.xlua_pack_float2(buff, offset, f1, f2) end

---@static
---@param buff System.IntPtr
---@param offset number
---@return boolean, System.Single, System.Single
function m.xlua_unpack_float2(buff, offset) end

---@static
---@param buff System.IntPtr
---@param offset number
---@param f1 number
---@param f2 number
---@param f3 number
---@return boolean
function m.xlua_pack_float3(buff, offset, f1, f2, f3) end

---@static
---@param buff System.IntPtr
---@param offset number
---@return boolean, System.Single, System.Single, System.Single
function m.xlua_unpack_float3(buff, offset) end

---@static
---@param buff System.IntPtr
---@param offset number
---@param f1 number
---@param f2 number
---@param f3 number
---@param f4 number
---@return boolean
function m.xlua_pack_float4(buff, offset, f1, f2, f3, f4) end

---@static
---@param buff System.IntPtr
---@param offset number
---@return boolean, System.Single, System.Single, System.Single, System.Single
function m.xlua_unpack_float4(buff, offset) end

---@static
---@param buff System.IntPtr
---@param offset number
---@param f1 number
---@param f2 number
---@param f3 number
---@param f4 number
---@param f5 number
---@return boolean
function m.xlua_pack_float5(buff, offset, f1, f2, f3, f4, f5) end

---@static
---@param buff System.IntPtr
---@param offset number
---@return boolean, System.Single, System.Single, System.Single, System.Single, System.Single
function m.xlua_unpack_float5(buff, offset) end

---@static
---@param buff System.IntPtr
---@param offset number
---@param f1 number
---@param f2 number
---@param f3 number
---@param f4 number
---@param f5 number
---@param f6 number
---@return boolean
function m.xlua_pack_float6(buff, offset, f1, f2, f3, f4, f5, f6) end

---@static
---@param buff System.IntPtr
---@param offset number
---@return boolean, System.Single, System.Single, System.Single, System.Single, System.Single, System.Single
function m.xlua_unpack_float6(buff, offset) end

---@static
---@param buff System.IntPtr
---@param offset number
---@param dec System.Decimal
---@return boolean, System.Decimal
function m.xlua_pack_decimal(buff, offset, dec) end

---@static
---@param buff System.IntPtr
---@param offset number
---@return boolean, System.Byte, System.Byte, System.Int32, System.UInt64
function m.xlua_unpack_decimal(buff, offset) end

---@overload fun(L:System.IntPtr, index:number, str:string, str_len:number): @static
---@static
---@param L System.IntPtr
---@param index number
---@param str string
---@return boolean
function m.xlua_is_eq_str(L, index, str) end

---@static
---@param L System.IntPtr
---@return System.IntPtr
function m.xlua_gl(L) end

XLua.LuaDLL.Lua = m
return m
