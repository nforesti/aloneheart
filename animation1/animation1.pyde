import json;

# HeartBeat Algortithm (confusing w/ framerate): 
# FR^2 / HR
# FR = Frame Rate
# HR = Heart Rate (beats/min), should be 60

# historically schumann resonance: 7.83 Hz (~469 beats/min) but in 2014 36
screenWidth = 640;
screenHeight = 360;

heartRate = 97;

with open("C:/Users/nevef/OneDrive/hp2documents/Processing/aloneheart/animation1/heartrates.json", "r") as read_file:
    hearts = json.load(read_file)

#dictionary to add heartbeats to
hearts = {
    "neve": {
              "hr": 45,
              "r": 255,
              "g": 255,
              "b": 255,
              "xloc": screenWidth * .25,
              "yloc": screenHeight * .4 , 
              "size":  10 
              }
    }
def setup():
    size(screenWidth, screenHeight);
    textSize(32);
    background(0);
    setupRate();
    frameRate(60);


def setupRate():
    textSize(32);
    text("word", 10, 30); 
    fill(0, 102, 153);
    text("word", 10, 60);
    fill(0, 102, 153, 51);
    text("word", 10, 90); 

def draw():
    clear()
    #smooth
    for beat in hearts:
        beat = hearts[beat];
        fill(beat["r"], beat["g"], beat["b"]);
        ellipse(beat["xloc"], beat["yloc"], 60-(frameCount % beat["hr"])*3, 60-(frameCount % beat["hr"])*3);
    #earth
    fill(120, 171, 70);
    if frameCount % 7 < 5:
        ellipse(width * .5, height*.6, 120, 120); #big circle
    if 5 < frameCount % 7 < 7:
        ellipse(width * .5, height*.6, 115, 115); #small

def stop():
    with open("C:/Users/nevef/OneDrive/hp2documents/Processing/aloneheart/animation1/heartrates.json", "w") as write_file:
        json.dump(hearts, write_file)
