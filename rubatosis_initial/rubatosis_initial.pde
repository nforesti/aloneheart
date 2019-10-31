/*
HeartBeat Algortithm (confusing w/ framerate): 
FR^2 / HR
FR = Frame Rate
HR = Heart Rate (beats/min), should be 60
historically schumann resonance: 7.83 Hz (~469 beats/min) but in 2014 36 

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
  Integer hr = new Integer(int(random(1,60)));
  Integer col = new Integer(int(random(25,200)));
  hearts = loadJSONObject("heartrates.json");
  current.put("hr", hr);
  current.put("r", col);
  current.put("g", col);
  current.put("b", col);
  current.put("xloc", new Integer(int(random(displayWidth))));
  current.put("yloc", new Integer(int(random(displayHeight))));
  current.put("size", new Integer(int(random(0, displayHeight * .15))));
  frameRate(60);
}

void draw() {
  clear(); 
  // show already-measured heart beats
  int col = int((millis() /1000) * 7);
  for (int i = 0 ; i < hearts.size(); i++){
    JSONObject beat = hearts.getJSONObject(""+i);
    if (beat != null){
      int grayCol = beat.getInt("r") - col; 
      if (grayCol < 0){col = beat.getInt("r");}
      fill(int(beat.getInt("r") - col));
      ellipse(beat.getInt("xloc"), beat.getInt("yloc"), beat.getInt("size") - (frameCount % beat.getInt("hr")) * 3, beat.getInt("size") - (frameCount % beat.getInt("hr")) * 3);
    }
  }
  // earth heart beat ~ 7x / sec
  col = int(millis()/100 * .5);
  fill(120  - col, 171  - col, 70  - col);
  if (frameCount % 7 < 5)
    ellipse(displayWidth * .8, displayHeight * .3, 180, 180);
  if (frameCount % 7 > 5 && frameCount % 7 < 7)
    ellipse(displayWidth * .8, displayHeight * .3, 175, 175);
}


void keyPressed() {
  switch(key){
    case 's':    // pressing 's' or 'S' will take a jpg of the processing window
    case 'S':
      saveFrame("PulseSensor-####.jpg");    // take a shot of that!
      break;
  }
  if (key == ENTER || key == ESC) {
    hearts.put("" + (hearts.size() ), current);
    saveJSONObject(hearts, "data/heartrates.json");
    exit();
  }
}
