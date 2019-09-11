---@class EnemyManager : LuaBehaviour
local EnemyManager, super = _G.CreateUIBehaviour("EnemyManager")

local setting =
{
    Elements =
    {
        {
            Name = ".",
            Alias = "EnemyBornList",
            Type = CS.EnemyBornList,
        },
    },
    Events =
    {
    },
    Behaviours =
    {
    },
}

local firstCreateDelay = {200, 5, 5, 10}
local createIntervals = {100, 999, 999, 999}

function EnemyManager:ctor(go)
    super.ctor(self, go, setting)
end

function EnemyManager:OnStart()
    self.enemyAssetRefs = CS.G6Demo.Core.G6ResourceManager.Instance.EnemyLocations
    self.timesRecords = {}
    for i = 1, #firstCreateDelay do
        self.timesRecords[i] = createIntervals[i] - firstCreateDelay[i]
    end
end

function EnemyManager:OnUpdate()
    -- If the player has no health left...
    if CS.PlayerManager.Instance.currentHealth <= 0 or self.enemyAssetRefs == nil then
        -- ... exit the function.
        return
    end

    local deltaTime = CS.UnityEngine.Time.deltaTime

    local bornPositions = self.EnemyBornList.spawnPoints
    for i = 1, self.enemyAssetRefs.Count do
        self.timesRecords[i] = self.timesRecords[i] + deltaTime
        if self.timesRecords[i] > createIntervals[i] then
            self.timesRecords[i] = 0
            -- Find a random index between zero and one less than the number of spawn points.
            local spawnPointIndex = CS.UnityEngine.Random.Range (0, bornPositions.Length)
            -- Create an instance of the enemy prefab at the randomly selected spawn point's position and rotation.
            CS.G6Demo.Core.G6ResourceManager.Instantiate (self.enemyAssetRefs[i-1], bornPositions[spawnPointIndex].position, bornPositions[spawnPointIndex].rotation)
        end
    end
end

return EnemyManager
