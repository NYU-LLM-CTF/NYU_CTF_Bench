using UnityEngine.UI;
using UnityEngine;

public class ValueDisplay : MonoBehaviour
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
        int value = mainscript.get_value();
        gameObject.GetComponent<Text>().text = value.ToString();
    }
}
