package coffee;

import com.google.common.hash.Hashing;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.lang.ClassNotFoundException;
import java.lang.IllegalAccessException;
import java.lang.InstantiationException;
import java.lang.reflect.InvocationTargetException;
import java.lang.NoSuchMethodException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Base64;
import java.lang.reflect.Constructor;


public class LegumeLoader {
  private String legumefolder;
  private String sign = "c@ram31m4cchi@o";
  private ArrayList<Bean> beans;
  private String[] beanNames = {"Covfefe", "Dennis", "Ghost", "Hyper", "MG",
                                "Passion", "Raid", "Tnek", "Yeet"};
  private static HashMap<String, String> beanDescriptions;

  public LegumeLoader(String legumefolder) throws ClassNotFoundException, IllegalAccessException, InstantiationException, InvocationTargetException, NoSuchMethodException {
    this.legumefolder = legumefolder;
    beans = new ArrayList<Bean>();
    for (String name : this.beanNames) {
      beans.add(this.getBean(name + "Bean"));
    }
    this.beanDescriptions = new HashMap<String, String>();
    this.beanDescriptions.put("Covfefe", "The best trade deal in the history of trade deals");
    this.beanDescriptions.put("Dennis", "Dennis Sun has been removed from the group");
    this.beanDescriptions.put("Ghost", "spoopy");
    this.beanDescriptions.put("Hyper", "<a target=\"_blank\" href=\"https://github.com/isislab/CSAW-CTF-2016-Quals/tree/master/Web/wtf.sh\">wtf</a>");
    this.beanDescriptions.put("MG", "p r e z");
    this.beanDescriptions.put("Passion", "Leon is a programmer who aspires to create programs that help people do less. He wants to put automation first, and scalability alongside. He dreams of a world where the endless and the infinite become realities to mankind, and where the true value of life is preserved.");
    this.beanDescriptions.put("Raid", "<a target=\"_blank\" href=\"https://www.youtube.com/watch?v=6a6wI8BPuTI\">raid</a>");
    this.beanDescriptions.put("Tnek", "I'll save you");
    this.beanDescriptions.put("Yeet", "yeet");
    this.beanDescriptions.put("Flag", System.getenv("flag"));
  }

  public ArrayList<Bean> getBeans() {
    return beans;
  }

  public Bean getBean(String name) throws ClassNotFoundException, NoSuchMethodException, InstantiationException, IllegalAccessException, InvocationTargetException {
    Class<?> beanClass = Class.forName("coffee." + name);
    Constructor<?> constructor = beanClass.getConstructor();
    Bean bean = (Bean) constructor.newInstance();
    return bean;
  }

  public String sendBean(Bean bean) throws IOException {
    final ByteArrayOutputStream baos = new ByteArrayOutputStream();
    final ObjectOutputStream oos = new ObjectOutputStream(baos);
    oos.writeObject(bean);
    oos.flush();
    String result = new String(Base64.getEncoder().encode(baos.toByteArray()));
    final String hashed = Hashing.sha256()
          .hashString(result + this.sign, StandardCharsets.UTF_8)
          .toString();
    return result + "-" + hashed;
  }

  public Boolean beanExists(String name) {
    for (Bean b : this.beans) {
      if (b.getName().equals(name)) {
        return true;
      }
    }
    return false;
  }

  public Boolean beanLimit() {
    if (beans.size() > 50) {
      return true;
    }
    return false;
  }

  public void addBean(Bean bean, String description) {
    if (!beanLimit()) {
      this.beans.add(bean);
      if (bean.getName().equals("Flag")) return;
      if (description.trim().equals("")) {
        description = null;
      } else if (description.length() > 100) {
        description = description.substring(0, 100);
      }
      this.beanDescriptions.put(bean.getName(), description);
    }
  }

  public String roast(Bean bean) {
    if (bean.getName().equals("Flag") && !bean.getClass().getSimpleName().equals("FlagBean")) return "not allowed";
    String description = this.beanDescriptions.get(bean.getName());
    if (description == null) {
      return this.roast(bean.getInherit());
    } else {
      return description;
    }
  }
}
