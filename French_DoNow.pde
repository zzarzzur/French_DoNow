//import codeanticode.protablet.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import controlP5.*;
ControlP5 cp5;
SceneManager scene;
Calendar cal;
int frames = 0;
French french;
void setup() {

  size(displayWidth, displayHeight);
}
String dots = ".";
void draw() {
  //println(wordWrap("sdfvadsfasdfasfvavasvsdfvadsfasdfasfvavasvsdfvadsfasdfasfvavasvsdfvadsfasdfasfvavasvsdfvadsfasdfasfvavasvsdfvadsfasdfasfvavasvsdfvadsfasdfasfvavasvsdfvadsfasdfasfvavasvsdfvadsfasdfasfvavasvsdfvadsfasdfasfvavasvsdfvadsfasdfasfvavasvsdfvadsfasdfasfvavasvsdfvadsfasdfasfvavasvsdfvadsfasdfasfvavasvsdfvadsfasdfasfvavasvsdfvadsfasdfasfvavasv", 15));
  //exit();
  //println(150 % 50);
  background(0, 0, 25);
  //scene.draw();
  frameRate(30);
  frames++;

  if (frames == 15) {
    asetup();
  }
  if (frames <= 15) {
    text("Loading"+dots, width/2, height/2, 25);
    dots+=".";
    if (dots == "....")dots=".";
  } 
  else {
    scene.draw();
  }
  //println(frames);
}
void asetup() {
  cp5 = new ControlP5(this);
  scene = new SceneManager();
  scene.loadFiles(sketchPath("") + "DoNows/");
  french = new French();
  cal = Calendar.getInstance();
}
void controlEvent(ControlEvent theEvent) {
  scene.controlEvent(theEvent);
}
void mousePressed() {
  scene.mousePressed();
}
void mouseDragged() {
  scene.mouseDragged();
}
void mouseReleased() {
  scene.mouseReleased();
}
int toColorCode(String _colo) {
  String colo = _colo.toLowerCase();
  if (colo.equals("black")) return 0;
  if (colo.equals("white")) return 255;
  if (colo.equals("green")) return int(color(255, 0, 255));
  return int(color(125, 125, 125));
} 
String wordWrap(String s, int wid) {
  if(textWidth(s) <= wid) return s;
  String[] sa = split(s, " ");
  String[] lines = new String[sa.length];
  int linesc = 0;
  String temp = "";
  for (int i=0;i<sa.length;i++) {
    if(sa[i] != "" && sa[i] != null) {
    if (textWidth(temp + " " + sa[i]) > wid) {
      lines[linesc] = temp;
      temp = "";
      linesc++;
    } 

      temp+=sa[i] + " ";
    
    }
  }
  String compile = "";
  for (int i=0;i<lines.length;i++) {
    if (lines[i] != "" && lines[i] != null) {
      compile+=lines[i] + "\n";
      println("Parsed line:" + lines[i]);
    }
  }
  return compile;
}




