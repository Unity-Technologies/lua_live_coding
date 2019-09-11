---@class DebuggerPanel : LuaBehaviour
local DebuggerPanel, super = _G.CreateUIBehaviour("DebuggerPanel")

local setting =
{
    Elements =
    {
        {
            Name = "Panel",
            Alias = "OpenPanel",
        },
        {
            Name = "Panel/Log",
            Alias = "Log",
            Type = CS.UnityEngine.UI.Text,
        },
        {
            Name = "OpenBtn",
            Type = CS.UnityEngine.UI.Button,
            Alias = "OpenBtn",
            Handles =
            {
                onClick = "OnClickOpen",
            },
        },
        {
            Name = "Panel/HideBtn",
            Type = CS.UnityEngine.UI.Button,
            Alias = "HideBtn",
            Handles =
            {
                onClick = "OnClickHide",
            },
        },
        {
            Name = "Panel/HotfixBtn",
            Type = CS.UnityEngine.UI.Button,
            Alias = "HotfixBtn",
            Handles =
            {
                onClick = "OnClickHotfix",
            },
        },
        {
            Name = "Panel/ClearBtn",
            Type = CS.UnityEngine.UI.Button,
            Alias = "ClearBtn",
            Handles =
            {
                onClick = "OnClearClicked",
            },
        },
    },
    Events =
    {
    },
    Behaviours =
    {
    },
}

local testCount = 0
--local lastLogTime
local testLogInterval = 3

function DebuggerPanel:ctor(go)
    super.ctor(self, go, setting)
end

function DebuggerPanel:OnStart()
    self:OnClickHide()

    self.lastLogTime = CS.UnityEngine.Time.timeSinceLevelLoad
    self.testCount2 = 0
end

function DebuggerPanel:OnUpdate()
    self.Log.text = CS.G6Debugger.GetUILog()
    self:Test()
end

function DebuggerPanel:Test()
    if CS.UnityEngine.Time.timeSinceLevelLoad - self.lastLogTime >= testLogInterval then
        self.lastLogTime = CS.UnityEngine.Time.timeSinceLevelLoad
        testCount = testCount + 1
        self.testCount2 = self.testCount2 + 1
        CS.G6Debugger.Log(string.format("Lua HotFixTedfdfst:localValue{%s} self{%s}", testCount, self.testCount2))
    end
end

function DebuggerPanel:OnDestroy()
end

function DebuggerPanel:OnClearClicked()
    CS.G6Debugger.ClearUILog()
end

function DebuggerPanel:OnClickOpen()
    self.OpenPanel:SetActive(true)
    self.OpenBtn.gameObject:SetActive(false)
end

function DebuggerPanel:OnClickHide()
    self.OpenPanel:SetActive(false)
    self.OpenBtn.gameObject:SetActive(true)
end

function DebuggerPanel:OnClickHotfix()
    CS.G6HotFix.HotfixManager.Instance:StartConnectSocketServer()
end

return DebuggerPanel
