# historically schumann resonance: 7.83 Hz (~469 beats/min) but in 2014 36
screenWidth = 640;
screenHeight = 360;

#dictionary to add heartbeats to
hearts = {
    "earth": {
              "hr": 469,
              "r": 43,
              "g": 45,
              "b": 56,
              "xloc": screenWidth * .25,
              "yloc": screenHeight * .4 , 
              "size":  20 
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
        fill(46);
        print(beat);
        print(hearts[beat]["xloc"]);
        ellipse(hearts[beat]["xloc"], hearts[beat]["yloc"], 60-frameCount % hearts[beat]["size"], 60-frameCount % hearts[beat]["size"]);
    #notsmooth
    if frameCount % 30 < 16:
        ellipse(width * .5, height*.6, 60, 60); #big circle
    if 15 < frameCount % 30 < 30:
        ellipse(width * .5, height*.6, 30, 30); #small
