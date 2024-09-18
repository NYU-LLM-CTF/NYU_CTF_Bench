package solver;

import java.util.Arrays;

public class PasswordMatch {
  Integer match;

  public PasswordMatch(String match) {
    this.match = match.hashCode();
  }

  public String generate(String start) {
    char [] input = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz".toCharArray();
    for (int i = 0; i < start.length(); i++) {
      String retval = gen(start, i, input);
      if (retval != null) {
        return retval;
      }
    }
    return null;
  }

  public String gen(String start, int index, char[] input) {
    char [] test = start.toCharArray();
    for (char c : input) {
      test[3] = c;
      for (char b : input) {
        test[index] = b;
        String check = new String(test, 0, start.length());
        if (check.hashCode() == this.match) {
          // System.out.println(check.hashCode());
          return check;
        }
      }
    }
    return null;
  }


  public static void main(String args[]) {
    PasswordMatch pm = new PasswordMatch("Pas$ion");
    System.out.println(pm.generate(""));
  }
}
