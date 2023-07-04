using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LevelManager : MonoBehaviour
{
    public void PlayGame()
    {
       
        SceneManager.LoadScene("Final_Shaders");
    }
    public void QuitGame()
    {
        print("Quiting game...");
        Application.Quit();
    }
    public void MainMenu()
    {
       
        SceneManager.LoadScene("MainMenu");
    }
}