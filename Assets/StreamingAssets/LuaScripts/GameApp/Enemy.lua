
---@class Enemy : LuaBehaviour
local Enemy, super = _G.CreateUIBehaviour("Enemy")

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
        --
        {
            Name = "MeshCt",
            Alias = "Mesh",
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

local timeBetweenAttacks = 2     -- The time in seconds between each attack.
local attackDamage = 10             -- The amount of health taken away per attack.

function Enemy:ctor(go)
    super.ctor(self, go, setting)
end

function Enemy:OnStart()
    self.playerInRange = false  -- Whether player is within the trigger collider and can be attacked.
    self.timer = 0  -- Timer for counting up to the next attack.
    self.startingHealth = 100   -- The amount of health the enemy starts the game with.
    self.currentHealth = self.startingHealth    -- The current health the enemy has.
    self.sinkSpeed = 2.5              -- The speed at which the enemy sinks through the floor when dead.
    self.scoreValue = 10                 -- The amount added to the player's score when the enemy dies.
    self.isDead = false --Whether the enemy is dead.
    self.isSinking = false  --Whether the enemy has started sinking through the floor.
end

function Enemy:OnUpdate()
    -- Add the time since Update was last called to the timer.
    self.timer = self.timer + CS.UnityEngine.Time.deltaTime

    local curEnemyColliderBounds = self.capsuleCollider.bounds
    local playerColliderBounds = CS.PlayerManager.Instance:GetPlayerBounds()
    self.playerInRange = curEnemyColliderBounds:Intersects(playerColliderBounds)

    -- If the timer exceeds the time between attacks, the player is in range and this enemy is alive...
    if self.timer >= timeBetweenAttacks and self.playerInRange and self.currentHealth > 0 then
        self:Attack()
    end
    self.anim.speed = 0

    -- If the player has zero or less health...
    if CS.PlayerManager.Instance.currentHealth <= 0 then
        self.anim:SetTrigger ("PlayerDead")
    else
        if self.currentHealth > 0 then
            -- ... set the destination of the nav mesh agent to the player.
            self.NavMeshAgent:SetDestination (CS.PlayerManager.Instance.Player.transform.position)
            -- Otherwise...
        else
            -- ... disable the nav mesh agent.
            self.NavMeshAgent.enabled = false
        end
    end

    -- If the enemy should be sinking...
    if self.isSinking then
        -- move the enemy down by the sinkSpeed per second.
        self.root.transform:Translate (-CS.UnityEngine.Vector3.up * self.sinkSpeed * CS.UnityEngine.Time.deltaTime)
    end
end

function Enemy:OnDestroy()
end

function Enemy:Attack()
    -- Reset the timer.
    self.timer = 0

    -- If the player has health to lose...
    if CS.PlayerManager.Instance.currentHealth > 0 then
        -- ... damage the player.
        CS.PlayerManager.Instance:TakeDamage (attackDamage)
    end
end

function Enemy:OnShootEnemy(instanceID, damage, hitPoint)
    if instanceID == self.root:GetInstanceID() then
        self:TakeDamage(damage,  hitPoint)
    end
end

function Enemy:TakeDamage(amount, hitPoint)
    -- If the enemy is dead...
    if self.isDead then
        -- no need to take damage so exit the function.
        return
    end

    -- Play the hurt sound effect.
    self.enemyAudio:Play()

    -- Reduce the current health by the amount of damage sustained.
    self.currentHealth = self.currentHealth - amount

    -- Set the position of the particle system to where the hit was sustained.
    self.hitParticles.transform.position = hitPoint

    -- And play the particles.
    self.hitParticles:Play()

    self:BeatBack(hitPoint)

    -- If the current health is less than or equal to zero...
    if self.currentHealth <= 0 then
        -- ... the enemy is dead.
        self:Death()
    end
end

function Enemy:BeatBack(hitPoint)
    local backPos = self.root.transform.position + (self.root.transform.position - hitPoint) * 2
    self.root.transform.position = backPos
end

function Enemy:Death()
    -- The enemy is dead.
    self.isDead = true

    -- Turn the collider into a trigger so shots can pass through it.
    self.capsuleCollider.isTrigger = true

    -- Tell the animator that the enemy is dead.
    self.anim:SetTrigger("Dead")

    ---- Change the audio clip of the audio source to the death clip and play it (this will stop the hurt clip playing).
    --self.enemyAudio.clip = deathClip
    --self.enemyAudio:Play()

    self.DeathParticles:Play()

    self:StartSinking()
end

function Enemy:StartSinking()
    -- Find and disable the Nav Mesh Agent.
    self.NavMeshAgent.enabled = false

    -- Find the rigidbody component and make it kinematic (since we use Translate to sink the enemy).
    self.Rigidbody.isKinematic = true

    -- The enemy should no sink.
    self.isSinking = true

    -- Increase the score by the enemy's score value.
    CS.CompleteProject.ScoreManager.score = CS.CompleteProject.ScoreManager.score + self.scoreValue

    -- After 2 seconds destory the enemy.
    CS.UnityEngine.GameObject.Destroy(self.root, 2)
end

return Enemy



