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
      println("1-HIt");
      try {
        //XML templ = loadXML(_dir + DoNowsN[i]);
        XML[] children = DoNows[i].getChildren("donow");
        for (int h=0;h<children.length;h++) {

          XML date = children[h].getChild("date");
          ListBoxItem lbi = l.addItem(date.getInt("month") +"-"+date.getInt("day"), i);
          println("Adding Listbox");
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
    } else {
      cdonow.draw();
    }
  }
  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isGroup() && theEvent.name().equals("DoNowSelect")) {
      int test = (int)theEvent.group().value();
      loadDoNow(test);
    }
  }
  void loadDoNow(int don) {
    DoNow = don;
    cdonow = new DoNow();
    cdonow.parseXML(DoNows[DoNow]);
  }
  class DoNow {
    //MixMatch mixm;
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
    void parseXML(XML _parse) {
      XML child = _parse.getChild("donow");
      XML agendae = child.getChild("agenda");
      XML aime = child.getChild("aim");
      XML datee = child.getChild("date");
      agenda = agendae.getContent();
      aim = aime.getContent();
      day = datee.getString("day");
      month = datee.getString("month");
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
      println(year());
      year = str(year());
      String dater = month + day + year;
      //Date date = sdf.parse("2008");
      cal.set(int(year), int(month), int(day));
      int tdow = cal.get(Calendar.DAY_OF_WEEK);
      if(tdow == 3) dow = "Saturday";
      if(tdow == 4) dow = "Sunday";
      if(tdow == 5) dow = "Monday";
      if(tdow == 6) dow = "Tuesday";
      if(tdow == 7) dow = "Wednesday";
      if(tdow == 1) dow = "Thurday";
      if(tdow == 2) dow = "Friday";
      //println(tdow);
      if(int(month) == 1) montht = "Janurary";
      if(int(month) == 2) montht = "Feburary";
      if(int(month) == 3) montht = "March";
      if(int(month) == 4) montht = "April";
      if(int(month) == 5) montht = "May";
      if(int(month) == 6) montht = "June";
      if(int(month) == 7) montht = "July";
      if(int(month) == 8) montht = "Auguest";
      if(int(month) == 9) montht = "September";
      if(int(month) == 10) montht = "October";
      if(int(month) == 11) montht = "November";
      if(int(month) == 12) montht = "December";
    }
    void draw() {
      text("Aim: "+ aim, 15,15);
      text("Agenda: "+ agenda, 15, 30);
      text(dow + ", " + montht + " " + day + ", " + year, 15, 45);
    }
  }
}

