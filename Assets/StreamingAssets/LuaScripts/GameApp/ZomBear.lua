local ZomBear, super = _G.CreateUIBehaviour("ZomBear", "LuaScripts.GameApp.Enemy")

function ZomBear:ctor(go)
    super.ctor(self, go, setting)
end

function ZomBear:OnStart()
    self.playerInRange = false  -- Whether player is within the trigger collider and can be attacked.
    self.timer = 0  -- Timer for counting up to the next attack.
    self.startingHealth = 200   -- The amount of health the enemy starts the game with.
    self.currentHealth = self.startingHealth    -- The current health the enemy has.
    self.sinkSpeed = 2.5              -- The speed at which the enemy sinks through the floor when dead.
    self.scoreValue = 10                 -- The amount added to the player's score when the enemy dies.
    self.isDead = false --Whether the enemy is dead.
    self.isSinking = false  --Whether the enemy has started sinking through the floor.

    self.anim.speed = 0
end

return ZomBear