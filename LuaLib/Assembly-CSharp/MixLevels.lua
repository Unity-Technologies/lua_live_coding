---@class MixLevels : UnityEngine.MonoBehaviour
---@field public masterMixer UnityEngine.Audio.AudioMixer
local m = {}

---@param sfxLvl number
function m:SetSfxLvl(sfxLvl) end

---@param musicLvl number
function m:SetMusicLvl(musicLvl) end

MixLevels = m
return m
