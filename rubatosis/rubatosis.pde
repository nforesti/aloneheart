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



import processing.io.*;
SPI MCP3008;

long sampleCounter,lastBeatTime,jitter; // used to keep track of sample rate
int threshSetting,thresh;      // used to find the heart beat
int Signal;                    // holds the latest raw sensor data
int BPM;                       // holds the Beats Per Minute value
int IBI;                       // holds the Interbeat Interval value
int P,T,amp;                   // keeps track of the peak and trough in the pulse wave
int sampleIntervalMs;          // used to find the sample rate
boolean firstBeat,secondBeat;  // used to avoid noise on startup
boolean Pulse;                 // is true when pulse wave is above thresh
// VARIABLES TO TALK TO MCP3008
byte[] outBytes = {(byte)0x01,(byte)0x80,(byte)0x00};  // tell MCP we want to read channel 0
byte[] inBytes = new byte[3]; // used to hold the incoming data from MCP
int MCP_SS = 8;  // the chip select pin number


JSONObject hearts;
JSONObject current = new JSONObject();
int FR = 100;
int nowHR = 8;
int avgHR = 8;


void setup() {
  GPIO.pinMode(MCP_SS,GPIO.OUTPUT);
  //printArray(SPI.list());
  MCP3008 = new SPI(SPI.list()[0]); // use SPI_0
  MCP3008.settings(1000000, SPI.MSBFIRST, SPI.MODE3);
  initPulseSensor();    // initialize the Pulse Sensor variables
  threshSetting = 550;  // adjust this as needed to avoid noise
  
  //size(600, 600);
  fullScreen();
  background(0);
  noStroke();
  //Integer col = new Integer(int(random(25,215)));
  
  int radius = int((displayHeight * .6)/2 + 10);
  print("radius " + radius);
  hearts = loadJSONObject("heartrates.json");
  current.put("r", new Integer(int(random(25,140))));
  current.put("g", new Integer(int(random(10,50))));
  current.put("b", new Integer(int(random(25,215))));
  current.put("xloc", new Integer(int(random(-radius, radius))));
  current.put("yloc", new Integer(int(random(-radius, radius))));
  frameRate(FR);
}

void draw() {
  clear(); 
  getPulse();
  
  int earthSize = int(displayHeight * .6);
  int earthx = int(displayWidth * .3);
  int earthy = int(displayHeight * .5);
  //printRawValues();  // used for debugging
  // show already-measured heart beats
  int col = int((millis() /1000) * 7);
  
  // earth heart beat ~ 7x / sec
  fill(120  - col, 171  - col, 70  - col);
  print("earthx " + earthx);
  print("earthy " + earthy);
  print("earthsize " + earthSize);
  if (frameCount % 7 < 5)
    ellipse(earthx, earthy, earthSize, earthSize);
  else if (frameCount % 7 > 5 && frameCount % 7 < 7)
    ellipse(earthx, earthy, earthSize-7, earthSize-7);
  // participant's heart beat
  fill(184-col*.5,15-col*.5,10-col*.5);
  ellipse(displayWidth * .8, displayHeight *.5, 50 - (frameCount % nowHR) * 3, 50 - (frameCount % nowHR) * 3);
  for (int i = 0 ; i < hearts.size(); i++){
    JSONObject beat = hearts.getJSONObject(""+i);
    if (beat != null){
      //fill(int(beat.getInt("r") - col), int(beat.getInt("g") - col), int(beat.getInt("b") - col));
      fill(int(beat.getInt("r")- col), int(beat.getInt("g") - col), int(beat.getInt("b") - col), 255 - col*2);
      ellipse(earthx + beat.getInt("xloc"), earthy + beat.getInt("yloc"), 50 - (frameCount % beat.getInt("hr")) * 3, 50 - (frameCount % beat.getInt("hr")) * 3);
    }
    col = int(millis()/100 * .5);
  }
}


void keyPressed() {
  switch(key){
    case 's':    // pressing 's' or 'S' will take a jpg of the processing window
    case 'S':
      saveFrame("PulseSensor-####.jpg");    // take a shot of that!
      break;
  }
  if (key == ENTER || key == ESC) {
    current.put("hr", avgHR);
    hearts.put("" + (hearts.size() ), current);
    saveJSONObject(hearts, "data/heartrates.json");
    exit();
  }
}
