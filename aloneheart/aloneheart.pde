/*
HeartBeat Algortithm (confusing w/ framerate): 
FR^2 / HR
FR = Frame Rate
HR = Heart Rate (beats/min), should be 60
historically schumann resonance: 7.83 Hz (~469 beats/min) but in 2014 36 
*/


/*
In data/heartrates.json, always start with AT LEAST:
{
  "0": {
    "xloc": 160,
    "b": 255,
    "r": 255,
    "size": 10,
    "g": 255,
    "hr": 45,
    "yloc": 144
  }
}

After each run, copy data from heartrates.json to data/heartrates.json
*/
    
JSONObject hearts;
JSONObject current = new JSONObject();

void setup() {
  fullScreen();
  background(0);
  hearts = loadJSONObject("heartrates.json");
  current.put("hr", new Integer(100));
  current.put("r", new Integer(100));
  current.put("g", new Integer(100));
  current.put("b", new Integer(100));
  current.put("xloc", new Integer(100));
  current.put("yloc", new Integer(100));
  current.put("size", new Integer(10));
  frameRate(60);
}

void draw() {
  clear(); 
  // show already-measured heart beats
  for (int i = 0 ; i < hearts.size(); i++){
    JSONObject beat = hearts.getJSONObject(""+i);
    if (beat != null){
      fill(beat.getInt("r"), beat.getInt("g"), beat.getInt("b"));
      ellipse(beat.getInt("xloc"), beat.getInt("yloc"), 60 - (frameCount % beat.getInt("hr")) * 3, 60 - (frameCount % beat.getInt("hr")) * 3);
      fill(120, 171, 70);
    }

  }
  // earth heart beat ~ 7x / sec
  if (frameCount % 7 < 5)
    ellipse(width * .5, height * .6, 120, 120);
  if (frameCount % 7 > 5 && frameCount % 7 < 7)
    ellipse(width * .5, height * .6, 115, 115);
}


void keyPressed() {
  if (key == ENTER || key == ESC) {
    hearts.put("" + (hearts.size() ), current);
    saveJSONObject(hearts, "data/heartrates.json");
    exit();
  }
}
