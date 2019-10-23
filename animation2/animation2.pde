/*
HeartBeat Algortithm (confusing w/ framerate): 
FR^2 / HR
FR = Frame Rate
HR = Heart Rate (beats/min), should be 60
historically schumann resonance: 7.83 Hz (~469 beats/min) but in 2014 36 
*/
    
JSONObject hearts;

void setup() {
    displayWidth = 640;
    displayHeight = 360;
    int heartRate = 97;

    hearts = loadJSONObject("heartrates.json");
/*
    JSONObject current = new JSONObject();
    current.put("hr", new Integer(100));
    current.put("r", new Integer(100));
    current.put("g", new Integer(100));
    current.put("b", new Integer(100));
    current.put("xloc", new Double(displayWidth * .25));
    current.put("yloc", new Double(displayHeight * .4));
    current.put("size", new Integer(10));

    hearts.put("neve", current);*/



    size(displayWidth, displayHeight);
    textSize(32);
    background(0);
    frameRate(60);
}

void draw() {
  print(hearts);
    clear(); // smooth
    for (int i = 0 ; i < hearts.size(); i++){
      JSONObject beat = hearts.getJSONObject(""+i);
      print(beat);
      fill(beat.getInt("r"), beat.getInt("g"), beat.getInt("b"));
      ellipse(beat.getInt("xloc"), beat.getInt("yloc"), 60 - (frameCount % beat.getInt("hr")) * 3, 60 - (frameCount % beat.getInt("hr")) * 3);
      fill(120, 171, 70);
      if (frameCount % 7 < 5)
          ellipse(width * .5, height * .6, 120, 120);
      if (frameCount % 7 > 5 && frameCount % 7 < 7)
          ellipse(width * .5, height * .6, 115, 115);
    }
}

void stop() {
    saveJSONObject(hearts, "heartrates.json");
}
