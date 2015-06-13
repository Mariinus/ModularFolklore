/**
 * Color Sorting  
 * by Ben Fry. 
 *
 * Example that sorts all colors from the incoming video
 * and arranges them into vertical bars.
 */
 
 
import processing.video.*;

Capture video;
boolean cheatScreen;

Tuple[] captureColors;
Tuple[] drawColors;
int[] bright;

int range = 25;
int CLR_RED[] = {200,70,90};
int CLR_BLUE[] = {80,120,180};
int CLR_MAGENTA[] = {255,190,230};
int CLR_PURPLE[] = {120,80,130};
int CLR_GREEN[] = {70,120,100};
int CLR_YELLOW[] = {160,160,90};

color DRAW_CLR_RED = color(255, 0, 0);
color DRAW_CLR_BLUE = color(0, 0, 255);
color DRAW_CLR_MAGENTA = color(255, 0, 255);
color DRAW_CLR_PURPLE = color(120, 80, 130);
color DRAW_CLR_GREEN = color(0, 255, 0);
color DRAW_CLR_YELLOW = color(255, 255, 0);

int mouseRGB[] = {-1,-1,-1};

// How many pixels to skip in either direction
int increment = 1;

PFont font;

void setup() {
  size(1280, 800);
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
    video = new Capture(this, 160, 120, "Trust Webcam #2", 30);// cameras[0]);
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
      
      popStyle();
      
      
      
      //image(video, 0, height - video.height);
      // Faster method of displaying pixels array on screen
      set(0, 0, video);
    }
  }
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


// Functions to handle sorting the color data


void sort(int length, int[] a, Tuple[] stuff) {
  sortSub(a, stuff, 0, length - 1);
}


void sortSwap(int[] a, Tuple[] stuff, int i, int j) {
  int T = a[i];
  a[i] = a[j];
  a[j] = T;

  Tuple v = stuff[i];
  stuff[i] = stuff[j];
  stuff[j] = v;
}


void sortSub(int[] a, Tuple[] stuff, int lo0, int hi0) {
  int lo = lo0;
  int hi = hi0;
  int mid;

  if (hi0 > lo0) {
    mid = a[(lo0 + hi0) / 2];

    while (lo <= hi) {
      while ((lo < hi0) && (a[lo] < mid)) {
        ++lo;
      }
      while ((hi > lo0) && (a[hi] > mid)) {
        --hi;
      }
      if (lo <= hi) {
        sortSwap(a, stuff, lo, hi);
        ++lo;
        --hi;
      }
    }

    if (lo0 < hi)
      sortSub(a, stuff, lo0, hi);

    if (lo < hi0)
      sortSub(a, stuff, lo, hi0);
  }
}

boolean sketchFullScreen() {
  return true;
}
