local LuaBehaviourUtil = {}

local function LuaBehaviourUtilError( ... )
    print(...)
end

local go_util = CS.GameObjectUtil

function LuaBehaviourUtil.FindGameObject(root_go, element_path, lb, necessary)
    if element_path == "." then
        return root_go
    else
        local go = go_util.FindGameObjectStrictly(root_go, element_path)
        if go == nil then
            if necessary == nil or necessary == true then
                LuaBehaviourUtilError("[" .. lb:class():name() .. "]" .. "LuaBehaviour Setting seems incorrect, Can't Find GameObject " .. element_path .. " in Strictly mode, fix it")
            end
            go = go_util.FindGameObject(root_go, element_path)
        end

        return go
    end
end

function LuaBehaviourUtil.BindElement(lb, lb_go, element, field_name, is_array, element_path)
    local element_go = LuaBehaviourUtil.FindGameObject(lb_go, element_path, lb, element.Necessary)
    if element_go == nil then
        
        if element.Necessary == nil or element.Necessary == true then
            LuaBehaviourUtilError("[" .. lb:class():name() .. "]" .. "LuaBehaviour Setting seems incorrect, Can't Find GameObject " .. element_path)
        end

        return
    end

    local obj = nil
    if element.Type then
        obj = element_go:GetComponent(typeof(element.Type))
        if not obj then
            if element.Necessary == nil or element.Necessary == true then
                LuaBehaviourUtilError("[" .. lb:class():name() .. "]" .. "LuaBehaviour Setting seems incorrect, " .. tostring(field_name) .. " has no specific type")
            end
            return
        end
    else
        obj = element_go
    end

    if is_array then
        table.insert(lb[field_name], obj)
    else
        lb[field_name] = obj
    end
    
    if element.Handles then
        local field = obj
        if not field then
            LuaBehaviourUtilError("[" .. lb:class():name() .. "]" .. "LuaBehaviour Setting seems incorrect, Can't Find Field " .. tostring(field_name))
            return
        end
        
        for msg, rsp in pairs(element.Handles) do
            if not field[msg] then
                LuaBehaviourUtilError("[" .. lb:class():name() .. "]" .. "LuaBehaviour Setting seems incorrect, Can't Find Function " .. msg)
            else
                local rsp_type = type(rsp)
                if rsp_type == "string" then
--                    field[msg]:Add(CS.EventDelegate(function()
--                        lb[rsp](lb)
--                    end))
                    field[msg]:AddListener(function()
                        lb[rsp](lb)
                    end)
                elseif rsp_type == "function" then
                    field[msg]:Add(CS.EventDelegate(rsp))
                end
            end
        end
    end
    
    if element.Hide then
       element_go:SetActive(false)
    end

    if element.Child then
        -- 嵌套定义
        local children = element.Child
        for i = 1, #children do
            local childElement = children[i]
            local field_name = childElement.Alias or childElement.Name

            if childElement.Count then
                lb[field_name] = {}
                for i = 1, childElement.Count do
                    if childElement.NamePostfix then
                        LuaBehaviourUtil.BindElement(lb, lb_go, childElement, field_name, true, string.format("%s/%s%d%s", element_path, childElement.Name, i, tostring(childElement.NamePostfix)))
                    else
                        LuaBehaviourUtil.BindElement(lb, lb_go, childElement, field_name, true, string.format("%s/%s%d", element_path, childElement.Name, i))
                    end
                end
            else
                LuaBehaviourUtil.BindElement(lb, lb_go, childElement, field_name, false, string.format("%s/%s", element_path, childElement.Name))
            end
        end
    end
end

function LuaBehaviourUtil.BindBehaviour(lb, lb_go, behaviour, field_name, is_array, behaviour_path)
    local behaviour_go = LuaBehaviourUtil.FindGameObject(lb_go, behaviour_path, lb, behaviour.Necessary)
    if behaviour_go == nil then
        
        if behaviour.Necessary == nil or behaviour.Necessary == true then
            LuaBehaviourUtilError("[" .. lb:class():name() .. "]" .. "lb Setting seems incorrect, Can't Find GameObject " .. behaviour_path)
        end
        
        return
    end

    local obj = __BehaviourManager:GetBehaviour(behaviour_go:GetInstanceID())
    if not obj then
        --尝试生成behaviour
        local luaOpration = behaviour_go:GetComponent(typeof(CS.LuaOperation))
        if luaOpration then
            luaOpration:AwakeByBehaviour()
            obj = __BehaviourManager:GetBehaviour(behaviour_go:GetInstanceID())
        end
    end

    if is_array then
        table.insert(lb[field_name], obj)
    else
        lb[field_name] = obj
    end
end

function LuaBehaviourUtil.BindElements(lb)
    local lb_go = lb._target
    local elements = lb._setting.Elements

    if not lb_go then
        LuaBehaviourUtilError("Error to bind LuaBehaviour : " .. lb:class():name())
        return
    end

    if elements == nil then
        return
    end

    for i = 1, #elements do
        local element = elements[i]
        local field_name = element.Alias or element.Name

        if element.Count then
            lb[field_name] = {}
            for i = 1, element.Count do
                if element.NamePostfix then
                    LuaBehaviourUtil.BindElement(lb, lb_go, element, field_name, true, element.Name .. i .. tostring(element.NamePostfix))
                else
                    LuaBehaviourUtil.BindElement(lb, lb_go, element, field_name, true, element.Name .. i)
                end
            end
        else
            LuaBehaviourUtil.BindElement(lb, lb_go, element, field_name, false, element.Name)
        end
    end
end

function LuaBehaviourUtil.BindBehaviours(lb)
    local lb_go = lb._target
    local behaviours = lb._setting.Behaviours

    if not lb_go then
        LuaBehaviourUtilError("Error to bind LuaBehaviour : " .. lb:class():name())
        return
    end

    if behaviours == nil then
        return
    end

    for i = 1, #behaviours do
        local behaviour = behaviours[i]
        local field_name = behaviour.Alias or behaviour.Name
        
        if behaviour.Count then
            lb[field_name] = {}
            for i = 1, behaviour.Count do
                LuaBehaviourUtil.BindBehaviour(lb, lb_go, behaviour, field_name, true, behaviour.Name .. i)
            end
        else
            LuaBehaviourUtil.BindBehaviour(lb, lb_go, behaviour, field_name, false, behaviour.Name)
        end
    end
end

function LuaBehaviourUtil.BindEvents(lb)
    local events = lb._setting.Events

    if events == nil then
        return
    end

    for k, v in pairs(events) do
        local handler = lb[v]
        if handler ~= nil then
            _G.EventSys:RegistedEvent(k,lb,handler,lb)
        end
    end
end

function LuaBehaviourUtil.UnbindEvents(lb)
    _G.EventSys:UnRegistedScopeEvent(lb)
end

return LuaBehaviourUtil
