import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import codeanticode.protablet.*; 
import java.text.SimpleDateFormat; 
import java.util.Calendar; 
import java.util.Date; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class French_DoNow extends PApplet {






 ControlP5 cp5;
SceneManager scene;
Calendar cal;
int frames = 0;
French french;
public void setup() {

  size(displayWidth,displayHeight);
}
String dots = ".";
public void draw() {
  background(0,0,25);
  //scene.draw();
  frameRate(30);
  frames++;
  
  if(frames == 15) {
    asetup();
  }
  if(frames <= 15) {
    text("Loading"+dots, width/2, height/2, 25);
    dots+=".";
    if(dots == "....")dots=".";
  } else {
    scene.draw();
  }
  //println(frames);
}
public void asetup() {
        cp5 = new ControlP5(this);
  scene = new SceneManager();
  scene.loadFiles(sketchPath("") + "DoNows/");
  french = new French();
  cal = Calendar.getInstance();
}
public void controlEvent(ControlEvent theEvent) {
  scene.controlEvent(theEvent);
}
public void mousePressed() {
  scene.mousePressed();
}
public void mouseDragged() {
  scene.mouseDragged();
}
public void mouseReleased() {
  scene.mouseReleased();
}
class French {
  XML converter = loadXML(sketchPath("") + "data/EN_FR.lanc");
  String[] en, fr;
  French() {
    XML child = converter.getChild("EN_FR");
    XML[] cstr = child.getChildren("string");
    en = new String[cstr.length];
    fr = new String[cstr.length];
    for(int i=0;i<cstr.length;i++){
      en[i] = cstr[i].getString("en");
      fr[i] = cstr[i].getString("fr");
    }
  }
  public String enToFr(String een) {
    for(int i=0;i<en.length;i++) {
      if(en[i] == een) {
        return fr[i];
      }
    }
    return "Not Found";
  }
    public String frToEn(String efr) {
    for(int i=0;i<fr.length;i++) {
      if(fr[i] == efr) {
        return en[i];
      }
    }
    return "Not Found";
  }
}
class SceneManager {
  XML[] DoNows;
  int DoNow = -1;
  int step = 0;
  DoNow cdonow;
  ListBox l;
  int cnt = 0;
  SceneManager() {
  }
  public void loadFiles(String _dir) {
    java.io.File folder = new java.io.File(_dir);
    String[] filenames = folder.list();
    String[] DoNowsN1, DoNowsN;
    DoNowsN1 =  new String[filenames.length];
    int j = 0;
    for (int i = 0; i < filenames.length; i++) {
      if (filenames[i].toLowerCase().endsWith(".donow")) {
        DoNowsN1[j] = filenames[i];
        j++;
      }
    }
    DoNowsN = new String[j];
    for (int i=0;i<j;i++) {
      DoNowsN[i] = DoNowsN1[i];
    }

    println(DoNowsN.length + " Do Nows Loaded");
    DoNows = new XML[DoNowsN.length];
    for (int i=0;i<DoNowsN.length;i++) {
      try {
        DoNows[i] = loadXML(_dir + DoNowsN[i]);
        println(_dir.substring( 0, _dir.length()-1) + DoNowsN[i]);
      } 
      catch (Exception e) {
        println("Do Now Failed");
      }
    }
    l = cp5.addListBox("DoNowSelect")
      .setPosition(15, 50)
        .setSize(250, 250)
          .setItemHeight(25)
            .setBarHeight(25)
              .setColorBackground(color(255, 128))
                .setColorActive(color(0))
                  .setColorForeground(color(255, 100, 0))
                    ;

    //l.captionLabel().toUpperCase(true);
    l.captionLabel().set("Do Nows");
    l.captionLabel().setColor(0xffff0000);
    l.captionLabel().style().marginTop = 3;
    l.valueLabel().style().marginTop = 3;
    println("Going To Add Items");
    for (int i=0;i<DoNows.length;i++) {
      //println("1-HIt");
      try {
        //XML templ = loadXML(_dir + DoNowsN[i]);
        XML[] children = DoNows[i].getChildren("donow");
        for (int h=0;h<children.length;h++) {

          XML date = children[h].getChild("date");
          ListBoxItem lbi = l.addItem(date.getInt("month") +"-"+date.getInt("day"), i);
          //println("Adding Listbox");
        }
      } 
      catch(Exception e) {
        println("Initializing Do Now Failed");
      }
    }
  }
  public void draw() {
    if (DoNow == -1) {
      text("Please select your DoNow", 15, 15);
    } 
    else {
      cdonow.draw();
    }
  }
  public void controlEvent(ControlEvent theEvent) {
    if (theEvent.isGroup() && theEvent.name().equals("DoNowSelect")) {
      int test = (int)theEvent.group().value();
      loadDoNow(test);
      l = null;
    }
  }
  public void loadDoNow(int don) {
    DoNow = don;
    cdonow = new DoNow();
    cdonow.parseXML(DoNows[DoNow]);
  }
  public void mousePressed() {
    if (cdonow != null) cdonow.mousePressed();
  }
  public void mouseDragged() {
    if (cdonow != null) cdonow.mouseDragged();
  }
  public void mouseReleased() {
    if (cdonow != null) cdonow.mouseReleased();
  }
  class DoNow {
    MixMatch mixm;
    //MakeASentence mas;
    String agenda;
    String dow;
    String day;
    String aim;
    String month;
    String montht;
    String year;
    DoNow() {
    }
    public void parseXML(XML _parse) {
      XML child = _parse.getChild("donow");
      XML agendae = child.getChild("agenda");
      XML aime = child.getChild("aim");
      XML datee = child.getChild("date");
      XML activitye = child.getChild("activity");
      agenda = agendae.getContent();
      aim = aime.getContent();
      day = datee.getString("day");
      month = datee.getString("month");
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
      //println(year());
      year = str(year());
      String dater = month + day + year;
      //Date date = sdf.parse("2008");
      cal.set(PApplet.parseInt(year), PApplet.parseInt(month), PApplet.parseInt(day));
      int tdow = cal.get(Calendar.DAY_OF_WEEK);
      if (tdow == 3) dow = "Saturday";
      if (tdow == 4) dow = "Sunday";
      if (tdow == 5) dow = "Monday";
      if (tdow == 6) dow = "Tuesday";
      if (tdow == 7) dow = "Wednesday";
      if (tdow == 1) dow = "Thurday";
      if (tdow == 2) dow = "Friday";
      //println(tdow);
      if (PApplet.parseInt(month) == 1) montht = "Janurary";
      if (PApplet.parseInt(month) == 2) montht = "Feburary";
      if (PApplet.parseInt(month) == 3) montht = "March";
      if (PApplet.parseInt(month) == 4) montht = "April";
      if (PApplet.parseInt(month) == 5) montht = "May";
      if (PApplet.parseInt(month) == 6) montht = "June";
      if (PApplet.parseInt(month) == 7) montht = "July";
      if (PApplet.parseInt(month) == 8) montht = "Auguest";
      if (PApplet.parseInt(month) == 9) montht = "September";
      if (PApplet.parseInt(month) == 10) montht = "October";
      if (PApplet.parseInt(month) == 11) montht = "November";
      if (PApplet.parseInt(month) == 12) montht = "December";
      println("Loading Activity-"+activitye.getString("type")+"-");
      String actt = activitye.getString("type");
      //if (ac == "mixandmatch") {
      println("Activity Mix And Match");
      XML[] dataene = activitye.getChildren("en");
      XML[] datafre = activitye.getChildren("fr");
      String en[] = new String[dataene.length];
      String fr[] = new String[datafre.length];
      for (int f=0;f<dataene.length;f++) {
        en[dataene[f].getInt("id")] = dataene[f].getContent();
      }
      for (int f=0;f<datafre.length;f++) {
        fr[datafre[f].getInt("id")] = datafre[f].getContent();
      }
      mixm = new MixMatch(en, fr);
    }
    //}
    public void draw() {
      
      text("Aim: "+ aim, 15, 15);
      text("Agenda: "+ agenda, 15, 30);
      text(dow + ", " + montht + " " + day + ", " + year, 15, 45);
      if (mixm != null) mixm.draw();
    }
    public void mousePressed() {
      if (mixm != null) mixm.mousePressed();
    }
    public void mouseDragged() {
      if (mixm != null) mixm.mouseDragged();
    }
    public void mouseReleased() {
      if (mixm != null) mixm.mouseReleased();
    }
    class MixMatch {
      String[] en, fr;
      int[] eno, fno;
      int[] conl, conr;
      int sels=-1;
      int sel=-1;
      MixMatch(String[] _en, String[] _fr) {
        en = _en;
        fr = _fr;
        eno = new int[en.length];
        fno = new int[fr.length];
        conl = new int[en.length];
        conr = new int[fr.length];
        int[] temp = new int[en.length];
        int conlp=0;
        int conrp=0;
        for (int i=0;i<temp.length;i++) {
          temp[i] = i;
        }
        for (int i=0;i<conl.length;i++) {
          boolean found=false;
          int test = 0;
          while (found==false) {
            test = PApplet.parseInt(random(0, temp.length));
            for (int h=0;h<temp.length;h++) {
              if (test == temp[h]) {
                found = true;
                temp[h] = -1;
              }
            }
          }
          conl[i] = test;
        }
        temp = null;
        temp = new int[fr.length];
        for (int i=0;i<temp.length;i++) {
          temp[i] = i;
        }
        for (int i=0;i<conr.length;i++) {
          boolean found=false;
          int test = 0;
          while (found==false) {
            test = PApplet.parseInt(random(0, temp.length));
            for (int h=0;h<temp.length;h++) {
              if (test == temp[h]) {
                found = true;
                temp[h] = -1;
              }
            }
          }
          conr[i] = test;
        }
      }

      public void draw() {
        for (int i=0;i<conl.length;i++) {
          text(en[conl[i]], 150, 150+(15*i));
          text(fr[conr[i]], 250, 150+(15*i));
        }
        if(sels != -1 && sel != -1) {
          float istrw = g.strokeWeight;
          strokeWeight(2);
          if(sels == 0)line(165, 150+(15*sel), mouseX, mouseY);
          if(sels == 1)line(265, 150+(15*sel), mouseX, mouseY);
          strokeWeight(istrw);
        }
      }
      public void mousePressed() {
        println("Received MousePressed");
        if (mouseX >= 150 && mouseX <=225) {
          println("In the first collumn");
          for (int i=0;i<conl.length;i++) {
            if (mouseY >= 150+(15*i) && mouseY <= (150+(15*i))+15) {
              println("Bingo");
              sels = 0;
              sel=i;
            }
          }
        }
      }
      public void mouseDragged() {
      }
      public void mouseReleased() {
        sels = -1;
        sel = -1;
      }
    }
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "French_DoNow" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
