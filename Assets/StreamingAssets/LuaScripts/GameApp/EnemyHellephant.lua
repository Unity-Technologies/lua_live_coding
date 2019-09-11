---@class EnemyHellephant : Enemy
local EnemyHellephant, super = _G.CreateUIBehaviour("EnemyHellephant", "LuaScripts.GameApp.Enemy")

local setting =
{
    Elements =
    {
        -- Reference to the animator component.
        {
            Name = ".",
            Alias = "anim",
            Type = CS.UnityEngine.Animator,
        },
        -- Reference to the audio source.
        {
            Name = ".",
            Alias = "enemyAudio",
            Type = CS.UnityEngine.AudioSource,
        },
        -- Reference to the particle system that plays when the enemy is damaged.
        {
            Name = "HitParticles",
            Alias = "hitParticles",
            Type = CS.UnityEngine.ParticleSystem,
        },
        -- Reference to the particle system that plays when the enemy is damaged.
        {
            Name = "DeathParticles",
            Alias = "DeathParticles",
            Type = CS.UnityEngine.ParticleSystem,
        },
        -- Reference to the capsule collider.
        {
            Name = ".",
            Alias = "capsuleCollider",
            Type = CS.UnityEngine.CapsuleCollider,
        },
        {
            Name = ".",
            Alias = "NavMeshAgent",
            Type = CS.UnityEngine.AI.NavMeshAgent,
        },
        {
            Name = ".",
            Alias = "Rigidbody",
            Type = CS.UnityEngine.Rigidbody,
        },
        --
        {
            Name = ".",
            Alias = "root",
        },
    },
    Events =
    {
        ["ShootEnemy"] = "OnShootEnemy",
    },
    Behaviours =
    {
    },
}

function EnemyHellephant:ctor(go)
    super.ctor(self, go, setting)
end

function EnemyHellephant:OnStart()
    self.playerInRange = false  -- Whether player is within the trigger collider and can be attacked.
    self.timer = 0  -- Timer for counting up to the next attack.
    self.startingHealth = 1000   -- The amount of health the enemy starts the game with.
    self.currentHealth = self.startingHealth    -- The current health the enemy has.
    self.sinkSpeed = 2.5              -- The speed at which the enemy sinks through the floor when dead.
    self.scoreValue = 10                 -- The amount added to the player's score when the enemy dies.
    self.isDead = false --Whether the enemy is dead.
    self.isSinking = false  --Whether the enemy has started sinking through the floor.
end

return EnemyHellephant