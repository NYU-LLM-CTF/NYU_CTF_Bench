using System.Collections;
using System.Collections.Generic;
using System.Text;
using System;
using System.Security.Cryptography;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class Gacha : MonoBehaviour
{
    // Start is called before the first frame update

    public AudioSource winaudio;
    public AudioSource loseaudio;

    public GameObject mainpage;
    public GameObject loading;
    public GameObject success;
    public GameObject failure;
    public GameObject error;
    public GameObject flag;

    string server = "http://rev.chal.csaw.io:10010";
    string value;
    int value_masker;
    byte[] counter;
    SHA256 mySHA256 = SHA256.Create();

    void Start()
    {
        Debug.Log("Main Logic Starts");
        counter = Encoding.ASCII.GetBytes("wakuwaku");
        value_masker = UnityEngine.Random.Range(1, 999);
        value = mask_value(100);

        byte[] testsha256 = mySHA256.ComputeHash(counter);
        Debug.Log(Convert.ToBase64String(testsha256));
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public int get_value()
    {
        return unmask_value(value);
    }

    string mask_value(int v) 
    {
        v = v ^ value_masker;
        byte[] byteArray = BitConverter.GetBytes(v);
        string base64String = Convert.ToBase64String(byteArray);
        return base64String;
    }

    int unmask_value(string m)
    {
        byte[] byteArray = Convert.FromBase64String(m);
        int v = BitConverter.ToInt32(byteArray, 0);
        return v ^ value_masker;
    }

    public void wish()
    {
        int currvalue = unmask_value(value);
        if (currvalue < 10)
        {
            insufficient_value();
            return;
        }
        currvalue = currvalue - 10;
        value = mask_value(currvalue);
        counter = mySHA256.ComputeHash(counter);

        loading.SetActive(true);
        StartCoroutine(Upload());
    }

    void insufficient_value() 
    {
        mainpage.SetActive(false);
        error.SetActive(true);
        Debug.Log("Insufficient Value");
    }
    void fail() 
    {
        loseaudio.Play();
        mainpage.SetActive(false);
        failure.SetActive(true);
        Debug.Log("Got nothing");
    }

    void succeed(string f) 
    {
        winaudio.Play();
        mainpage.SetActive(false);
        success.SetActive(true);
        flag.GetComponent<Text>().text = f;
        Debug.Log("Got Anya!");
    }

    public void backfrom(GameObject g)
    {
        g.SetActive(false);
        mainpage.SetActive(true);
    }

    IEnumerator Upload()
    {
        WWWForm formData = new WWWForm();
        string b64counter = Convert.ToBase64String(counter);
        //b64counter = "r2wV9hl+9GMBT9IpD6YWJJB6DkMq6HSYVhHD/lRx58w=";
        formData.AddField("data", b64counter);

        UnityWebRequest www = UnityWebRequest.Post(server, formData);
        Debug.Log("Posted: "+b64counter);
        yield return www.SendWebRequest();

        if (www.result != UnityWebRequest.Result.Success)
        {
            Debug.Log(www.error);
        }
        else
        {
            loading.SetActive(false);
            string response = www.downloadHandler.text;
            if (response == "")
            {
                fail();
            }
            else
            {
                succeed(response);
            }
        }
    }
}

