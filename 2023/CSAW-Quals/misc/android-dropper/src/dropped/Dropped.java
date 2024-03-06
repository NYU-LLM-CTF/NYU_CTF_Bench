package com.example.dropped;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;

public class Dropped {

    static byte[] notTheFlag;


    public static String getFlag() throws IOException {

        String dataFromServer = "";
        URL url = new URL("http://android-dropper.csaw.io:3003"); // replace
        HttpURLConnection urlConnection = (HttpURLConnection) (url).openConnection();
        try {
            urlConnection.connect();
            BufferedReader in = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));
            dataFromServer = in.readLine();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            urlConnection.disconnect();
        }

        notTheFlag = Base64.getDecoder().decode(dataFromServer);
        //Log.d("uhhhhh", notTheFlag.toString());
        String data = obf(275, 306, 42); // match to numbers in server.py

        return data;

    }

    public static String obf(int i, int i2, int i3) {
        char[] cArr = new char[i2 - i];
        for (int i4 = 0; i4 < i2 - i; i4++) {
            cArr[i4] = (char) (notTheFlag[i + i4] ^ i3);
        }
        return new String(cArr);
    }
}
