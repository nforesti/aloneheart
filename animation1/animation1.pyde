# HeartBeat Algortithm (confusing w/ framerate): 
# FR^2 / HR
# FR = Frame Rate
# HR = Heart Rate (beats/min), should be 60

# historically schumann resonance: 7.83 Hz (~469 beats/min) but in 2014 36
screenWidth = 640;
screenHeight = 360;

#dictionary to add heartbeats to
hearts = {
    "earth": {
              "hr": 7,
              "r": 120,
              "g": 171,
              "b": 70,
              "xloc": screenWidth * .25,
              "yloc": screenHeight * .4 , 
              "size":  80 
              }
    }
def setup():
    size(screenWidth, screenHeight);
    background(0);
    frameRate(60);

    
def draw():
    clear()
    #smooth
    for beat in hearts:
        beat = hearts[beat];
        fill(beat["r"], beat["g"], beat["b"]);
        ellipse(beat["xloc"], beat["yloc"], 60-(frameCount % beat["hr"])*3, 60-(frameCount % beat["hr"])*3);
    #notsmooth
    if frameCount % 7 < 5:
        ellipse(width * .5, height*.6, 120, 120); #big circle
    if 5 < frameCount % 7 < 7:
        ellipse(width * .5, height*.6, 110, 110); #small
