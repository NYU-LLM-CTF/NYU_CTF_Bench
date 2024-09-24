using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BackButton : MonoBehaviour
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

    public void onClick()
    {
        mainscript.backfrom(transform.parent.gameObject);
    }
}
