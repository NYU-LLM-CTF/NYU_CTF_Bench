package coffee;

import javax.servlet.http.*;
import java.util.HashMap;

public class Auth {
  private HashMap<Integer, String> secret;
  private String sign = "c@ram31m4cchi@o";
  private String key;

  public Auth() {
    this.secret = new HashMap<Integer, String>();
  }

  public void loadPassword(String password) {
    this.key = password;
    this.secret.put(this.key.hashCode(), sign);
  }

  public String lookup(Integer hash) {
    return this.secret.get(hash);
  }
}
