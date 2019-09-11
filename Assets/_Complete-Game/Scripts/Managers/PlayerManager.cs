using CompleteProject;
using UnityEditor;
using UnityEngine;

public class PlayerManager {

    private static PlayerManager instance;

    public static PlayerManager Instance
    {
        get
        {
            if (instance == null)
            {
                instance = new PlayerManager();
            }

            return instance;
        }
    }

    public int startingHealth = 10000;                            // The amount of health the player starts the game with.
    public int currentHealth;                                   // The current health the player has.

    bool isDead;                                                // Whether the player is dead.
    bool damaged;                                               // True when the player gets damaged.

    public bool IsDead
    {
        get
        {
            return isDead;
        }

        private set
        {
            isDead = value;
        }
    }

    public bool Damaged
    {
        get
        {
            return damaged;
        }

        private set
        {
            damaged = value;
        }
    }

    public PlayerHealth PlayerBehaviour
    {
        get
        {
            return playerBehaviour;
        }

        set
        {
            playerBehaviour = value;
        }
    }

    public GameObject Player
    {
        get
        {
            return player;
        }

        set
        {
            player = value;
        }
    }

    public Bounds GetPlayerBounds()
    {
        return player.GetComponent<CapsuleCollider>().bounds;
    }

    private PlayerHealth playerBehaviour;
    private GameObject player;

    public void SetPlayer(GameObject player)
    {
        this.player = player;
        this.playerBehaviour = player.GetComponent<PlayerHealth>();

        InitHealth();
    }

    // Set the initial health of the player.
    public void InitHealth()
    {
        currentHealth = startingHealth;
    }

    public void TakeDamage(int amount)
    {
        // Set the damaged flag so the screen will flash.
        Damaged = true;
        // Reduce the current health by the damage amount.
        currentHealth -= amount;

        PlayerBehaviour.TakeDamage();

        // If the player has lost all it's health and the death flag hasn't been set yet...
        if (currentHealth <= 0 && !isDead)
        {
            // ... it should die.
            Death();
        }
    }


    void Death()
    {
        // Set the death flag so this function won't be called again.
        isDead = true;
        PlayerBehaviour.Death();
    }

    public void Quit()
    {
#if UNITY_EDITOR
        EditorApplication.isPlaying = false;
#else
		Application.Quit();
#endif
    }
}
