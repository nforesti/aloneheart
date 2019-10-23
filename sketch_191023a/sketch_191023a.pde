/*
HeartBeat Algortithm (confusing w/ framerate): 
FR^2 / HR
FR = Frame Rate
HR = Heart Rate (beats/min), should be 60
historically schumann resonance: 7.83 Hz (~469 beats/min) but in 2014 36 
*/
    
JSONObject hearts;

void setup() {
  fullScreen();
  background(0);
  
  hearts = loadJSONObject("heartrates.json");
  print("first hearts " + hearts);
  JSONObject current = new JSONObject();
  current.put("hr", new Integer(100));
  current.put("r", new Integer(100));
  current.put("g", new Integer(100));
  current.put("b", new Integer(100));
  current.put("xloc", new Integer(100));
  current.put("yloc", new Integer(100));
  current.put("size", new Integer(10));
  print("current" + current);
  print("hearts before");
  print(hearts);
  hearts.put("" + (hearts.size() + 1), current);
    print("hearts after");
    print(hearts);
  saveJSONObject(hearts, "data/heartrates.json");
  hearts = loadJSONObject("heartrates.json");
    frameRate(60);



}

void draw() {
  clear(); // smooth 
  for (int i = 0 ; i < hearts.size(); i++){
    JSONObject beat = hearts.getJSONObject(""+i);
    fill(beat.getInt("r"), beat.getInt("g"), beat.getInt("b"));
    ellipse(beat.getInt("xloc"), beat.getInt("yloc"), 60 - (frameCount % beat.getInt("hr")) * 3, 60 - (frameCount % beat.getInt("hr")) * 3);
    fill(120, 171, 70);
    if (frameCount % 7 < 5)
        ellipse(width * .5, height * .6, 120, 120);
    if (frameCount % 7 > 5 && frameCount % 7 < 7)
        ellipse(width * .5, height * .6, 115, 115);
  }
}
