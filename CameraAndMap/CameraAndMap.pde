/**
 * Modular Folklore 
 * by Marinus Schepen. 
 */
 
 
import processing.video.*;

Capture video;
boolean cheatScreen;

Tuple[] captureColors;
Tuple[] drawColors;
int[] bright;

// CHANGE THIS: adjust the range, so that it works best
int range = 25;
// following are the colors for calculation (from the camera)
int CLR_RED[] = {200,70,90};
int CLR_BLUE[] = {80,120,180};
int CLR_MAGENTA[] = {255,190,230};
int CLR_PURPLE[] = {120,80,130};
int CLR_GREEN[] = {70,120,100};
int CLR_YELLOW[] = {160,160,90};

// following are the colors of the dots that visitors see on the screen
color DRAW_CLR_RED = color(231, 53, 49);
color DRAW_CLR_BLUE = color(25, 62, 150);
color DRAW_CLR_MAGENTA = color(248, 78, 133);
color DRAW_CLR_PURPLE = color(133, 49, 144);
color DRAW_CLR_GREEN = color(65, 200, 104);
color DRAW_CLR_YELLOW = color(252, 223, 3);

float redSmoothed = 0;
float blueSmoothed = 0;
float magentaSmoothed = 0;
float purpleSmoothed = 0;
float greenSmoothed = 0;
float yellowSmoothed = 0;

// CHANGE THIS: how smoothly do the circles get bigger or smaller
float smoothFactor = 0.9; // between 0.0 and 1.0. the higher, the smoother, the lower the quicker
float circleSize = 1.0; // smaller is smaller, bigger is bigger

int mouseRGB[] = {-1,-1,-1};

// How many pixels to skip in either direction
int increment = 1;

PFont font;

PImage map;
PShape location;

// CHANGE THE LOCATION OF CONTINENT-DOTS (relative to screen)
RelativePoint2D northAmerica = new RelativePoint2D(0.21,0.317);
RelativePoint2D europe = new RelativePoint2D(0.487,0.31);
RelativePoint2D asia = new RelativePoint2D(0.70,0.33);
RelativePoint2D southAmerica = new RelativePoint2D(0.296,0.66);
RelativePoint2D africa = new RelativePoint2D(0.525,0.515);
RelativePoint2D oceania = new RelativePoint2D(0.822,0.67);

RelativePoint2D combinedLocation = new RelativePoint2D(0.5,0.5);

// CHANGE THIS: how smoothly does the location-svg move around the screen, again, bigger is slower, smaller is quicker
float smoothLocation = 0.95;


void setup() {
  size(1280, 800); // CHANGE THIS TO THE IMACS RESOLUTION
  sketchFullScreen();
  
    String[] cameras = Capture.list();
    if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    
    for (int i = 0; i < cameras.length; i++) {
      println(i + " : " + cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
//      video = new Capture(this, 160, 120);
    video = new Capture(this, 160, 120, "Trust Webcam", 30);// CHECK IF THIS IS THE NAME OF YOUR CAMERA (it is printed in the console)
    video.start();     
  }  
  int count = (video.width * video.height) / (increment * increment);
      
  println("count : " + count + " video.width : " + video.width);
  bright = new int[count];
  captureColors = new Tuple[count];
  drawColors = new Tuple[count];
  for (int i = 0; i < count; i++) {
    captureColors[i] = new Tuple();
    drawColors[i] = new Tuple(0.5, 0.5, 0.5);
  }
  
  font = createFont("Helvetica", 12);
  textFont(font);
  
  map = loadImage("map.png");
  location = loadShape("location.svg");
 
}


void draw() {
  if(!cheatScreen){
    noCursor();
  } else {
    cursor(ARROW);
  }
  if (video.available()) {
    
    video.read();
    video.loadPixels();
    
    background(0);
    noStroke();

    int red = 0;
    int blue = 0;
    int magenta = 0;
    int purple = 0;
    int green = 0;
    int yellow = 0;

    int index = 0;
    
    for (int j = 0; j < video.height; j += increment) {
      for (int i = 0; i < video.width; i += increment) {
        int pixelColor = video.pixels[j*video.width + i];

        int r = (pixelColor >> 16) & 0xff;
        int g = (pixelColor >> 8) & 0xff;
        int b = pixelColor & 0xff;
        
        if(mouseX == i && mouseY == j){
          mouseRGB[0] = r;
          mouseRGB[1] = g;
          mouseRGB[2] = b;
        }
        
        if ( Math.abs(r - CLR_RED[0]) < range && Math.abs(g - CLR_RED[1]) < range && Math.abs(b - CLR_RED[2]) < range ) {
          red++;
        }  
        if ( Math.abs(r - CLR_BLUE[0]) < range && Math.abs(g - CLR_BLUE[1]) < range && Math.abs(b - CLR_BLUE[2]) < range ) {
          blue++;
        }  
        if ( Math.abs(r - CLR_MAGENTA[0]) < range && Math.abs(g - CLR_MAGENTA[1]) < range && Math.abs(b - CLR_MAGENTA[2]) < range ) {
          magenta++;
        }  
        if ( Math.abs(r - CLR_PURPLE[0]) < range && Math.abs(g - CLR_PURPLE[1]) < range && Math.abs(b - CLR_PURPLE[2]) < range ) {
          purple++;
        }  
        if ( Math.abs(r - CLR_GREEN[0]) < range && Math.abs(g - CLR_GREEN[1]) < range && Math.abs(b - CLR_GREEN[2]) < range ) {
          green++;
        }
        if ( Math.abs(r - CLR_YELLOW[0]) < range && Math.abs(g - CLR_YELLOW[1]) < range && Math.abs(b - CLR_YELLOW[2]) < range ) {
          yellow++;
        }

        // Technically would be sqrt of the following, but no need to do
        // sqrt before comparing the elements since we're only ordering
//        bright[index] = r*r + g*g + b*b;
//        captureColors[index].set(r, g, b);

        index++;
      }
    }
    
    // smoothing stuff
    
    redSmoothed = redSmoothed * smoothFactor + red * (1.0-smoothFactor);
    blueSmoothed = blueSmoothed * smoothFactor + blue * (1.0-smoothFactor);
    magentaSmoothed = magentaSmoothed * smoothFactor + magenta * (1.0-smoothFactor);
    purpleSmoothed = purpleSmoothed * smoothFactor + purple * (1.0-smoothFactor);
    greenSmoothed = greenSmoothed * smoothFactor + green * (1.0-smoothFactor);
    yellowSmoothed = yellowSmoothed * smoothFactor + yellow * (1.0-smoothFactor);
    
    float max = red+blue+magenta+purple+green+yellow;
    RelativePoint2D currentCombined = new RelativePoint2D(
                        (map(red,0,max,0,1) * northAmerica.x) +
                        (map(blue,0,max,0,1) * europe.x) + 
                        (map(magenta,0,max,0,1) * asia.x) + 
                        (map(purple,0,max,0,1) * southAmerica.x) + 
                        (map(green,0,max,0,1) * africa.x) + 
                        (map(yellow,0,max,0,1) * oceania.x),
                        
                        (map(red,0,max,0,1) * northAmerica.y) +
                        (map(blue,0,max,0,1) * europe.y) + 
                        (map(magenta,0,max,0,1) * asia.y) + 
                        (map(purple,0,max,0,1) * southAmerica.y) + 
                        (map(green,0,max,0,1) * africa.y) + 
                        (map(yellow,0,max,0,1) * oceania.y) );
                        
    if(currentCombined.x > 0 && currentCombined.x < 1 &&  currentCombined.y > 0 && currentCombined.y < 1){                 
      combinedLocation.x = combinedLocation.x * smoothLocation + currentCombined.x * (1.0-smoothLocation);
      combinedLocation.y = combinedLocation.y * smoothLocation + currentCombined.y * (1.0-smoothLocation);
    }
    
    
    if (cheatScreen) {
      
      pushStyle();
      pushMatrix();
//      bars of the colors
      translate(0,video.height);
      fill(CLR_RED[0],CLR_RED[1],CLR_RED[2]);
      text("red: " + red,20,20+20);
      rect(150,20,red,20);
      fill(CLR_BLUE[0],CLR_BLUE[1],CLR_BLUE[2]);
      text("blue: " + blue,20,40+20);
      rect(150,40,blue,20);
      fill(CLR_MAGENTA[0],CLR_MAGENTA[1],CLR_MAGENTA[2]);
      text("magenta: " + magenta,20,60+20);
      rect(150,60,magenta,20);
      fill(CLR_PURPLE[0],CLR_PURPLE[1],CLR_PURPLE[2]);
      text("purple: " + purple,20,80+20);
      rect(150,80,purple,20);
      fill(CLR_GREEN[0],CLR_GREEN[1],CLR_GREEN[2]);
      text("green: " + green,20,100+20);
      rect(150,100,green,20);
      fill(CLR_YELLOW[0],CLR_YELLOW[1],CLR_YELLOW[2]);
      text("yellow: " + yellow,20,120+20);
      rect(150,120,yellow,20);
      
      popMatrix();
      
      fill(mouseRGB[0],mouseRGB[1],mouseRGB[2]);
      rect(170,20,20,20);
      fill(255);
      text("mouse R " + mouseRGB[0], 200, 20);
      text("mouse G " + mouseRGB[1], 200, 40);
      text("mouse B " + mouseRGB[2], 200, 60);
      
      
      text("combinedLocation.x: " + combinedLocation.x,20,420);
      text("combinedLocation.y: " + combinedLocation.y,20,440);
      shape(location,combinedLocation.x*width,combinedLocation.y*height);
      
      popStyle();
      
      
      
      //image(video, 0, height - video.height);
      // Faster method of displaying pixels array on screen
      set(0, 0, video);
    } else {
    // drawing the actual application
    image(map,0,0,width,height);
    
    pushStyle();
    // draw content... circles
    fill(DRAW_CLR_RED);
    circle(northAmerica.x*width,northAmerica.y*height,redSmoothed*0.1*circleSize);
    fill(DRAW_CLR_BLUE);
    circle(europe.x*width,europe.y*height,blueSmoothed*0.1*circleSize);
    fill(DRAW_CLR_MAGENTA);
    circle(asia.x*width,asia.y*height,magentaSmoothed*0.1*circleSize);
    fill(DRAW_CLR_PURPLE);
    circle(southAmerica.x*width,southAmerica.y*height,purpleSmoothed*0.1*circleSize);
    fill(DRAW_CLR_GREEN);
    circle(africa.x*width,africa.y*height,greenSmoothed*0.1*circleSize);
    fill(DRAW_CLR_YELLOW);
    circle(oceania.x*width,oceania.y*height,yellowSmoothed*0.1*circleSize);
    
    fill(0,0,0);
    shape(location,combinedLocation.x*width,combinedLocation.y*height);
    
    popStyle();
    
  }
  }
}

void circle(float x, float y, float size){
  ellipse(x,y,size,size);
}

void keyPressed() {
  if (key == 'd') {
    cheatScreen = !cheatScreen;
  }
  if(key == 'r'){
    CLR_RED = mouseRGB.clone();
  }
  if(key == 'b'){
    CLR_BLUE = mouseRGB.clone();
  }
  if(key == 'm'){
    CLR_MAGENTA = mouseRGB.clone();
  }
  if(key == 'p'){
    CLR_PURPLE = mouseRGB.clone();
  }
  if(key == 'g'){
    CLR_GREEN = mouseRGB.clone();
  }
  if(key == 'y'){
    CLR_YELLOW = mouseRGB.clone();
  }
}

class RelativePoint2D {
  
  public float x;
  public float y;
  
  public RelativePoint2D(float x, float y){
    this.x = x;
    this.y = y;
  }
  
}

boolean sketchFullScreen() {
  return true;
}
