---@class PauseManager : UnityEngine.MonoBehaviour
---@field public paused UnityEngine.Audio.AudioMixerSnapshot
---@field public unpaused UnityEngine.Audio.AudioMixerSnapshot
local m = {}

function m:Pause() end

function m:Quit() end

PauseManager = m
return m
