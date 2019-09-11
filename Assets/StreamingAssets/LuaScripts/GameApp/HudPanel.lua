local HudPanel, super = _G.CreateUIBehaviour("HudPanel")

local setting = {
    -- 普通的UI控件
    Elements = {
        {
            Name = ".",
            Alias = "anim",
            Type = CS.UnityEngine.Animator,
        },
        {
            Name = "RestartButton",
            Alias = "RestartButton",
            Type = CS.UnityEngine.UI.Button,
            Handles = {
                onClick = "OnClickRestart",
            }
        },
    },
    Behaviours = {
    },
    Events = {
    },

    -- 自动注册的Timer
    Timers = {},
}

function HudPanel:ctor(go)
    super.ctor(self, go, setting)
end

function HudPanel:OnStart()
end

function HudPanel:OnVisible()
end

function HudPanel:OnUpdate()
    -- If the player has run out of health...
    if CS.PlayerManager.Instance.currentHealth <= 0 then
        -- ... tell the animator the game is over.
        self.anim:SetTrigger ("GameOver")
    end
end

function HudPanel:OnClickRestart()
    CS.UnityEngine.SceneManagement.SceneManager.LoadScene ("Game")
end

return HudPanel