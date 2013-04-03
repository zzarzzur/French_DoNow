class SceneManager {
  XML[] DoNows;
  int DoNow = -1;
  int step = 0;
  DoNow cdonow;
  ListBox l;
  int cnt = 0;
  SceneManager() {
  }
  void loadFiles(String _dir) {
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
  void draw() {
    if (DoNow == -1) {
      text("Please select your DoNow", 15, 15);
    } 
    else {
      cdonow.draw();
    }
  }
  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isGroup() && theEvent.name().equals("DoNowSelect")) {
      int test = (int)theEvent.group().value();
      loadDoNow(test);
      l.setPosition(-1000, -1000);
    }
  }
  void loadDoNow(int don) {
    DoNow = don;
    cdonow = new DoNow();
    cdonow.parseXML(DoNows[DoNow]);
  }
  void mousePressed() {
    if (cdonow != null) cdonow.mousePressed();
  }
  void mouseDragged() {
    if (cdonow != null) cdonow.mouseDragged();
  }
  void mouseReleased() {
    if (cdonow != null) cdonow.mouseReleased();
  }
  class DoNow {
    MixMatch mixm;
    MakeASentence mas;
    String agenda;
    String dow;
    String day;
    String aim;
    String month;
    String montht;
    String year;
    int texs;
    color back, texc;
    String[] students;
    DoNow() {
    }
    void parseXML(XML _parse) {
      XML child = _parse.getChild("donow");
      XML agendae = child.getChild("agenda");
      XML aime = child.getChild("aim");
      XML datee = child.getChild("date");
      XML activitye = child.getChild("activity");
      XML stylee = child.getChild("style");
      //XML students = loadXML("Students.xml");
      //XML studentsc = students.getChild("student");
      //XML[] studentse = studentsc.getChildren("st");

      agenda = agendae.getContent();

      aim = aime.getContent();
      day = datee.getString("day");
      month = datee.getString("month");
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
      //println(year());
      year = str(year());
      String dater = month + day + year;
      //Date date = sdf.parse("2008");
      cal.set(int(year), int(month), int(day));
      int tdow = cal.get(Calendar.DAY_OF_WEEK);
      if (tdow == 3) dow = "Saturday";
      if (tdow == 4) dow = "Sunday";
      if (tdow == 5) dow = "Monday";
      if (tdow == 6) dow = "Tuesday";
      if (tdow == 7) dow = "Wednesday";
      if (tdow == 1) dow = "Thurday";
      if (tdow == 2) dow = "Friday";
      //println(tdow);
      if (int(month) == 1) montht = "Janurary";
      if (int(month) == 2) montht = "Feburary";
      if (int(month) == 3) montht = "March";
      if (int(month) == 4) montht = "April";
      if (int(month) == 5) montht = "May";
      if (int(month) == 6) montht = "June";
      if (int(month) == 7) montht = "July";
      if (int(month) == 8) montht = "Auguest";
      if (int(month) == 9) montht = "September";
      if (int(month) == 10) montht = "October";
      if (int(month) == 11) montht = "November";
      if (int(month) == 12) montht = "December";
      println("Loading Activity-"+activitye.getString("type")+"-");
      String ac = activitye.getString("type");
      if (ac.equals("mixandmatch")) {
        println("Activity Mix And Match");
        int gap = activitye.getInt("gap");
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
        mixm.gap = gap;
      }
      if (ac.equals("fillinblank")) {
      }
      XML textcolore = stylee.getChild("textcolor");
      if (textcolore.getContent().substring(4).equals("rgb:")) {
      } 
      else {
        if (toColorCode(textcolore.getContent()) !=-1) {
          texc = color(toColorCode(textcolore.getContent()));
        }
      }
      XML backgrounde = stylee.getChild("background");
      if (backgrounde.getContent().substring(4).equals("rgb:")) {
      } 
      else {
        if (toColorCode(backgrounde.getContent()) !=-1) {
          back = color(toColorCode(backgrounde.getContent()));
        }
      }
      XML textsizee = stylee.getChild("textsize");
      texs = int(textsizee.getContent());
      textSize(texs);
      String acen = activitye.getString("center");
      if (acen.equals("yes") || acen.equals("true")) {
        mixm.startx = (width/2)-(mixm.gap/1.3);
        mixm.starty = (height/2)-((mixm.en.length*(texs/2))/3);
      }
      agenda = "Agenda: " + agenda;
      String nagenda = "";
      int charl = int(width/(texs/1.9));
      println("I Apparently have:" + charl);
      for (int i=0;i<agenda.length();i++) {
        nagenda = nagenda + agenda.charAt(i);
        if (i >= 1) { 
          //if (i == charl || i==charl*2 || i==charl*3 || i==charl*4 || i==charl*5)nagenda+="\n";
        }
      }
      //agenda = nagenda;
      aim = "Aim: " + aim;
      String naim = "";
      //int charl = int(width/(texs/1.9));
      //println("I Apparently have:" + charl);
      for (int i=0;i<aim.length();i++) {
        naim = naim + aim.charAt(i);
        if (i >= 1) { 
          //if (i == charl || i==charl*2 || i==charl*3 || i==charl*4 || i==charl*5)naim+="\n";
        }
      }
      //aim = naim;
    }

    void draw() {
      background(back);
      int origc = int(g.fill);
      int origs = int(g.stroke);
      fill(texc);
      stroke(texc);
      text(wordWrap(aim + "\n" + agenda + "\n" + dow + ", " + montht + " " + day + ", " + year, width-15), 15, texs);
      //text("Agenda: "+ agenda, 15, texs*2);
      //text(dow + ", " + montht + " " + day + ", " + year, 15, texs*3);

      if (mixm != null) mixm.draw();
      /*if(keyPressed) {
       if(key == 'g') {
       mixm.startx+=10;
       mixm.starty+=10;
       }
       }*/
      fill(origc);
      stroke(origs);
    }
    void mousePressed() {
      if (mixm != null) mixm.mousePressed();
    }
    void mouseDragged() {
      if (mixm != null) mixm.mouseDragged();
    }
    void mouseReleased() {
      if (mixm != null) mixm.mouseReleased();
    }
    class MixMatch {
      String[] en, fr;
      int[] eno, fro;
      int[] conl, conr;
      int sels=-1;
      int sel=-1;
      int gap=0;
      float startx=150;
      float starty=150;
      MixMatch(String[] _en, String[] _fr) {
        en = _en;
        fr = _fr;
        eno = new int[en.length];
        fro = new int[fr.length];

        conl = new int[en.length];
        conr = new int[fr.length];
        int[] temp = new int[en.length];
        int conlp=0;
        int conrp=0;
        for (int i=0;i<temp.length;i++) {
          temp[i] = i;
          eno[i] = -1;
          fro[i] = -1;
        }
        for (int i=0;i<conl.length;i++) {
          boolean found=false;
          int test = 0;
          while (found==false) {
            test = int(random(0, temp.length));
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
            test = int(random(0, temp.length));
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

      void draw() {
        int origc = int(g.fill);
        int origs = int(g.stroke);
        fill(texc);
        stroke(texc);
        strokeWeight(texs/10);

        for (int i=0;i<eno.length;i++) {
          if (eno[i] != -1) {
            if (conl[i] == conr[eno[i]]) stroke(0, 255, 0);
            else stroke(255, 0, 0);
            line(startx+(((texs/2)*en[conl[i]].length())), (starty-10)+(texs*i), (startx+gap)+(texs*5), (starty-10)+(texs*eno[i]));
          }
        }
        for (int i=0;i<conl.length;i++) {

          text(en[conl[i]], startx, starty+((texs)*i));
          text(fr[conr[i]], (startx+gap)+(texs*5), starty+((texs)*i));
        }
        noFill();
        for (int i=0;i<conr.length;i++) {
          //rect((150+gap)+(texs*5), 150+(texs*i)-texs, (150+gap)+(((texs/2)*fr[conr[i]].length())), (150+(texs*i)));
        }
        fill(origc);
        stroke(origs);
        if (sels != -1 && sel != -1) {
          float istrw = g.strokeWeight;
          strokeWeight(2);
          if (sels == 0)line(startx+(((texs/2)*en[conl[sel]].length())), (starty-10)+(texs*sel), mouseX, mouseY);
          if (sels == 1)line(((startx+15)+gap)+(texs*sel), starty+(texs*sel), mouseX, mouseY);
          strokeWeight(istrw);
        }
      }
      void mousePressed() {
        println("Received MousePressed");
        if (mouseX >= startx && mouseX <=startx+(gap*1.5)) {
          println("In the first collumn");
          for (int i=0;i<conl.length;i++) {
            if (mouseY >= starty+(texs*i)-texs && mouseY <= (starty+(texs*i))) {
              println("Bingo");
              sels = 0;
              sel=i;
            }
          }
        }
      }
      void mouseDragged() {
      }
      void mouseReleased() {
        if (mouseX >= ((startx+gap)+(texs*5))-(texs*2) && mouseX <=width) { //(150+gap)+(((texs/2)*fr[conr[i]].length()))
          println("In the Second collumn");
          for (int i=0;i<conr.length;i++) {

            if (mouseY >= starty+(texs*i)-texs && mouseY <= (starty+(texs*i))) {
              eno[sel] = i;
              fro[i] = sel;
            }
          }
        }
        sel=-1;
        sels=-1;
      }
    }
    class MakeASentence {
      String[] sentences;
      String[] words;
      int[] sentor;
      int[] wordor;
      MakeASentence(String[] _sentences, String[] _words) {
        int[] temp = new int[_sentences.length];
        words = new String[_words.length];
        sentences = new String[_sentences.length];
        sentor = new int[_sentences.length];
        wordor = new int[_words.length];
        int senlp=0;
        int worrp=0;
        for (int i=0;i<temp.length;i++) {
          temp[i] = i;
          sentor[i] = -1;
          wordor[i] = -1;
        }
        for (int i=0;i<sentor.length;i++) {
          boolean found=false;
          int test = 0;
          while (found==false) {
            test = int(random(0, temp.length));
            for (int h=0;h<temp.length;h++) {
              if (test == temp[h]) {
                found = true;
                temp[h] = -1;
              }
            }
          }
          sentor[i] = test;
        }
        temp = null;
        temp = new int[_words.length];
        for (int i=0;i<temp.length;i++) {
          temp[i] = i;
        }
        for (int i=0;i<wordor.length;i++) {
          boolean found=false;
          int test = 0;
          while (found==false) {
            test = int(random(0, temp.length));
            for (int h=0;h<temp.length;h++) {
              if (test == temp[h]) {
                found = true;
                temp[h] = -1;
              }
            }
          }
          wordor[i] = test;
        }
      }
    }
  }
}

