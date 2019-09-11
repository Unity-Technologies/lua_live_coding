using G6HotFix;
using UnityEngine;

namespace CompleteProject
{
    public class GameOverManager : MonoBehaviour
    {
        Animator anim;                          // Reference to the animator component.      


        void Awake ()
        {
            // Set up the reference.
            anim = GetComponent <Animator> ();
        }


        void Update ()
        {
            // If the player has run out of health...
            if(PlayerManager.Instance.currentHealth <= 0)
            {
                // ... tell the animator the game is over.
                anim.SetTrigger ("GameOver");
            }
        }
    }
}