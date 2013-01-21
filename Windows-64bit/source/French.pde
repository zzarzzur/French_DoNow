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
  String enToFr(String een) {
    for(int i=0;i<en.length;i++) {
      if(en[i] == een) {
        return fr[i];
      }
    }
    return "Not Found";
  }
    String frToEn(String efr) {
    for(int i=0;i<fr.length;i++) {
      if(fr[i] == efr) {
        return en[i];
      }
    }
    return "Not Found";
  }
}
