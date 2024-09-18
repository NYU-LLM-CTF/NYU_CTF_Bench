//package com.example.dropped;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;
/* loaded from: /Users/g/csaw_test/dropped.dex */
public class Dropped {
    static byte[] notTheFlag;

    //public static String getFlag() throws IOException {
    public static void main(String[] args) throws IOException {
        String str;
        HttpURLConnection httpURLConnection = (HttpURLConnection) new URL("http://0.0.0.0:3003").openConnection();
        //HttpURLConnection httpURLConnection = (HttpURLConnection) new URL("http://android-dropper.csaw.io:3003").openConnection();
        try {
            try {
                httpURLConnection.connect();
                str = new BufferedReader(new InputStreamReader(httpURLConnection.getInputStream())).readLine();
            } catch (Exception e) {
                e.printStackTrace();
                httpURLConnection.disconnect();
                str = "";
            }
            notTheFlag = Base64.getDecoder().decode(str);
            //return obf(275, 306, 42);
            System.out.println(Dropped.obf(275, 306, 42));
        } finally {
            httpURLConnection.disconnect();
        }
    }

    public static String obf(int i, int i2, int i3) {
        int i4 = i2 - i;
        char[] cArr = new char[i4];
        for (int i5 = 0; i5 < i4; i5++) {
            cArr[i5] = (char) (notTheFlag[i + i5] ^ i3);
        }
        return new String(cArr);
    }
}
