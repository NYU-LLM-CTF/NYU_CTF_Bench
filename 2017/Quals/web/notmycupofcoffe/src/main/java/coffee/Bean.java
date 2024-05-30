package coffee;

import java.io.Serializable;
import java.io.IOException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.File;
import java.util.Random;

public class Bean implements Serializable {
  private static final long serialVersionUID = 1;
  protected String name;
  private Bean parent1;
  private Bean parent2;
  private Bean inherit;

  // public String roast() {
  //   if (this.description == null) {
  //     if (this.inherit == null) {
  //       return "Uh oh it's an orphan bean";
  //     }
  //     return this.inherit.roast();
  //   }
  //   return this.description;
  // }

  public Bean getInherit() { return this.inherit; }

  public void setParent(final Bean parent1, final Bean parent2) {
    this.parent1 = parent1;
    this.parent2 = parent2;

    Random rand = new Random();
    if (rand.nextInt(1) == 0) {
      this.inherit = parent1;
    } else {
      this.inherit = parent2;
    }
  }

  public String getParent1() {
    if (parent1 == null) {
      return "n/a";
    }
    return parent1.getName();
  }

  public String getParent2() {
    if (parent2 == null) {
      return "n/a";
    }
    return parent2.getName();
  }

  public String getName() {
    return this.name;
  }

  public void setName(final String name) {
    this.name = name;
  }
}
