using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WishButton : MonoBehaviour
{
    // Start is called before the first frame update
    public GameObject LogicController;
    Gacha mainscript;
    void Start()
    {
        mainscript = LogicController.GetComponent<Gacha>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void makeWish()
    {
        Debug.Log("Clicked");
        mainscript.wish();
    }
}
