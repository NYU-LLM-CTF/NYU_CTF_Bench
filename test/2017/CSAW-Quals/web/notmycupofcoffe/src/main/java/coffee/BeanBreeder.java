package coffee;

import javax.servlet.http.*;

import com.google.common.hash.Hashing;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.lang.ClassNotFoundException;
import java.nio.charset.StandardCharsets;
import java.util.Base64;


public class BeanBreeder {
  public LegumeLoader loader;
  private String sign = "c@ram31m4cchi@o";

  public BeanBreeder(LegumeLoader loader) {
    this.loader = loader;
  }

  public Bean breedBean(Bean parent1, Bean parent2, String name) {
    if (name == null || loader.beanExists(name) || parent1 == null || parent2 == null) {
      return null;
    }

    Bean bean = new Bean();
    bean.setParent(parent1, parent2);
    bean.setName(name);
    return bean;
  }

  public Bean recvBean(String bean) throws IOException, ClassNotFoundException {
    if (bean == null || bean.indexOf('-') < 0) return null;
    String[] parts = bean.split("-");
    String serialbean = parts[0];
    String hashbean = parts[1];
    Bean test = new Bean();
    final String hashed = Hashing.sha256()
          .hashString(serialbean + this.sign, StandardCharsets.UTF_8)
          .toString();
    if (!hashed.equals(hashbean)) {
      return null;
    }
    final byte[] objToBytes = Base64.getDecoder().decode(serialbean);
    ByteArrayInputStream bais = new ByteArrayInputStream(objToBytes);
    ObjectInputStream ois = new ObjectInputStream(bais);
    return (Bean) ois.readObject();
  }

  public Bean process(HttpServletRequest request) throws IOException, ClassNotFoundException {
    final Bean parent1 = this.recvBean(request.getParameter("parent1"));
    final Bean parent2 = this.recvBean(request.getParameter("parent2"));
    String name = request.getParameter("bean-name");
    if (name.trim() == "") {
      name = null;
    }
    return this.breedBean(parent1, parent2, name);
  }
}
