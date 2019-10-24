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
int FR = 60;
int nowHR = 1;
int avgHR = 0;

void setup() {
  GPIO.pinMode(MCP_SS,GPIO.OUTPUT);
  GPIO.pinMode(pulseLED,GPIO.OUTPUT);
  //printArray(SPI.list());
  MCP3008 = new SPI(SPI.list()[0]); // use SPI_0
  MCP3008.settings(1000000, SPI.MSBFIRST, SPI.MODE3);
  initPulseSensor();    // initialize the Pulse Sensor variables
  threshSetting = 550;  // adjust this as needed to avoid noise
  
  fullScreen();
  background(0);
  Integer col = new Integer(int(random(25,215)));
  hearts = loadJSONObject("heartrates.json");
  current.put("r", col);
  current.put("g", col);
  current.put("b", col);
  current.put("xloc", new Integer(int(random(displayWidth))));
  current.put("yloc", new Integer(int(random(displayHeight))));
  current.put("size", new Integer(int(random(0, displayHeight * .15))));
  frameRate(FR);
}

void draw() {
  clear(); 
  getPulse();
  //printRawValues();  // used for debugging
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
    col = int(millis()/100 * .5);
  }
  // earth heart beat ~ 7x / sec
  fill(120  - col, 171  - col, 70  - col);
  if (frameCount % 7 < 5)
    ellipse(displayWidth * .8, displayHeight * .3, 180, 180);
  else if (frameCount % 7 > 5 && frameCount % 7 < 7)
    ellipse(displayWidth * .8, displayHeight * .3, 175, 175);
  // participant's heart beat
  fill(255,69,0);
  int ellipseSize = 250 - (frameCount % nowHR) * 3;
  if (120 - col < 10){
    ellipseSize = ellipseSize - col;
  }
  ellipse(current.getInt("xloc"), current.getInt("yloc"), 250 - (frameCount % nowHR) * 3, 250 - (frameCount % nowHR) * 3);
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
