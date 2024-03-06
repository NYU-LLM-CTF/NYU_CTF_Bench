package com.example.dropper;

import androidx.appcompat.app.AppCompatActivity;

import android.app.AlertDialog;
import android.content.Context;
import android.util.Base64;
import android.os.StrictMode;
import android.os.Bundle;


import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.reflect.Method;
import java.lang.reflect.InvocationTargetException;

import dalvik.system.DexClassLoader;


public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // load dex
        writeDropped((Context) this);
        loadDex();

        // show the flag
        showFlag((Context)this, "test");

        // close app
        this.finish();
        System.exit(0);
    }


    public void showFlag(Context context, String s) {
        AlertDialog.Builder alertDialog = new AlertDialog.Builder(context);
        alertDialog.setMessage(s);
        alertDialog.show();
    }


    private void loadDex() {
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);

        File path = new File(getFilesDir(),"dropped.dex");

        DexClassLoader dx = new DexClassLoader(path.getAbsolutePath(), getCacheDir().getAbsolutePath(), null, getClassLoader());
        Class<Object> dropper = null;
        Method getFlag = null;
        Object objDropper = null;
        try {
            dropper = (Class<Object>)dx.loadClass("com.example.dropped.Dropped");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        try {
            objDropper = dropper.newInstance();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        }
        try {
            getFlag = dropper.getMethod("getFlag", null); // get the method you want to call
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
        try {
            getFlag.invoke(objDropper);
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }

        // delete the file
        path.delete();

    }

    private void writeDropped(Context context) {
        try {
            // dropped.dex
            String droppedB64 = "ZGV4CjAzNQDhPlk5aYWw+e4V0CCP3pyxhM31Ymhljq+gBwAAcAAAAHhWNBIAAAAAAAAAANwGAAAoAAAAcAAAABMAAAAQAQAACwAAAFwBAAABAAAA4AEAABAAAADoAQAAAQAAAGgCAAAYBQAAiAIAAPYDAAD4AwAAAAQAAA4EAAARBAAAFAQAABoEAAAeBAAAPQQAAFkEAABzBAAAigQAAKEEAAC+BAAA0AQAAOcEAAD7BAAADwUAAC0FAAA9BQAAVwUAAHMFAACHBQAAigUAAI4FAACSBQAAlgUAAJ8FAACnBQAAswUAAL8FAADIBQAA2AUAAP0FAAAJBgAADgYAAB4GAAAvBgAAOQYAAEAGAAADAAAABwAAAAgAAAAJAAAACgAAAAsAAAAMAAAADQAAAA4AAAAPAAAAEAAAABEAAAASAAAAEwAAABQAAAAVAAAAFgAAABgAAAAZAAAABAAAAAUAAAAAAAAABAAAAAoAAAAAAAAABQAAAAoAAADMAwAABAAAAA0AAAAAAAAABAAAAA4AAAAAAAAAFgAAABAAAAAAAAAAFwAAABAAAADYAwAAFwAAABAAAADgAwAAFwAAABAAAADoAwAAFwAAABAAAADwAwAABgAAABEAAADoAwAAAQARACEAAAABAAUAAQAAAAEAAQAeAAAAAQACACIAAAADAAcAAQAAAAMAAQAlAAAABgAGAAEAAAAIAAUAJAAAAAkABQABAAAACgAJAAEAAAALAAUAGgAAAAsABQAcAAAACwAAAB8AAAAMAAgAAQAAAAwAAwAjAAAADgAKABsAAAAPAAQAHQAAAAEAAAABAAAACQAAAAAAAAACAAAAxAYAAKEGAAAAAAAABAAAAAMAAgCoAwAASwAAAAAAIgAMABoBIABwIAwAEABuEA0AAAAMAB8ACwBuEAkAAAAiAQMAIgIGAG4QCwAAAAwDcCAFADIAcCADACEAbhAEAAEADAFuEAoAAAAoDA0BKB8NAW4QBgABAG4QCgAAABoBAABxAA8AAAAMAG4gDgAQAAwAaQAAABMAEwETATIBEwIqAHEwAgAQAgwAEQBuEAoAAAAnAQAADgAAABUAAQAqAAAAAwAFAAJ/CCknACcABwADAAIAAAC/AwAAGQAAALFFI1ASABIBNVEPAGICAACQAwQBSAICA7dijiJQAgAB2AEBASjyIgQKAHAgCAAEABEEAAABAAEAAQAAAKQDAAAEAAAAcBAHAAAADgAKAA4AEQAOHnhqPOFOPBwpHj08LqamAnkdPAAnAwAAAA48PKM+AAAAAwAAAAAAAAAAAAAAAQAAAAUAAAABAAAABwAAAAEAAAAKAAAAAQAAABIAAAAGPGluaXQ+AAxEcm9wcGVkLmphdmEAAUkAAUwABExJSUkAAkxMAB1MY29tL2V4YW1wbGUvZHJvcHBlZC9Ecm9wcGVkOwAaTGRhbHZpay9hbm5vdGF0aW9uL1Rocm93czsAGExqYXZhL2lvL0J1ZmZlcmVkUmVhZGVyOwAVTGphdmEvaW8vSU9FeGNlcHRpb247ABVMamF2YS9pby9JbnB1dFN0cmVhbTsAG0xqYXZhL2lvL0lucHV0U3RyZWFtUmVhZGVyOwAQTGphdmEvaW8vUmVhZGVyOwAVTGphdmEvbGFuZy9FeGNlcHRpb247ABJMamF2YS9sYW5nL09iamVjdDsAEkxqYXZhL2xhbmcvU3RyaW5nOwAcTGphdmEvbmV0L0h0dHBVUkxDb25uZWN0aW9uOwAOTGphdmEvbmV0L1VSTDsAGExqYXZhL25ldC9VUkxDb25uZWN0aW9uOwAaTGphdmEvdXRpbC9CYXNlNjQkRGVjb2RlcjsAEkxqYXZhL3V0aWwvQmFzZTY0OwABVgACVkwAAltCAAJbQwAHY29ubmVjdAAGZGVjb2RlAApkaXNjb25uZWN0AApnZXREZWNvZGVyAAdnZXRGbGFnAA5nZXRJbnB1dFN0cmVhbQAjaHR0cDovL2FuZHJvaWQtZHJvcHBlci5jc2F3LmlvOjMwMDMACm5vdFRoZUZsYWcAA29iZgAOb3BlbkNvbm5lY3Rpb24AD3ByaW50U3RhY2tUcmFjZQAIcmVhZExpbmUABXZhbHVlAFd+fkQ4eyJjb21waWxhdGlvbi1tb2RlIjoiZGVidWciLCJoYXMtY2hlY2tzdW1zIjpmYWxzZSwibWluLWFwaSI6MSwidmVyc2lvbiI6IjIuMS43LXIxIn0AAgIBJhwBGAQBAAMAAAgAgYAEjAcBCYgFAQnIBgAAAAAAAAABAAAAmQYAALgGAAAAAAAAAQAAAAAAAAABAAAAvAYAABAAAAAAAAAAAQAAAAAAAAABAAAAKAAAAHAAAAACAAAAEwAAABABAAADAAAACwAAAFwBAAAEAAAAAQAAAOABAAAFAAAAEAAAAOgBAAAGAAAAAQAAAGgCAAABIAAAAwAAAIgCAAADIAAAAwAAAKQDAAABEAAABQAAAMwDAAACIAAAKAAAAPYDAAAEIAAAAQAAAJkGAAAAIAAAAQAAAKEGAAADEAAAAgAAALgGAAAGIAAAAQAAAMQGAAAAEAAAAQAAANwGAAA=";
            byte[] data = Base64.decode(droppedB64, Base64.DEFAULT);
            FileOutputStream outputStream = context.openFileOutput("dropped.dex",Context.MODE_PRIVATE);
            outputStream.write(data);
            outputStream.flush();
            outputStream.close();
        }
        catch (IOException e) {
            e.printStackTrace();
        }
    }


}