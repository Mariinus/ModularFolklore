/**
 * Modular Folklore 
 * by Marinus Schepen. 
 */
 
 
import processing.video.*;

Capture video;
boolean cheatScreen;

int[] bright;

// CHANGE THIS: adjust the range, so that it works best
int range = 25;

// CHANGE THIS: how smoothly do the circles get bigger or smaller
float smoothFactor = 0.9; // between 0.0 and 1.0. the higher, the smoother, the lower the quicker
float circleSize = 1.0; // smaller is smaller, bigger is bigger

// initialize mouseRGB for colorpicking
int mouseRGB[] = {-1,-1,-1};

// various things, self-explanatory
PFont debugfont;
PFont mediumfont;
PFont bigfont;
PImage map;
PShape location;

// shift around the unique territory to your pleasure change them in setup()
int yourTerritoryYPos;
int yourTerritoryXPos;
int uniqueTerritoryYPos;
int uniqueTerritoryXPos;

// the position of the location-arrows will be stored here
RelativePoint2D combinedLocation = new RelativePoint2D(0.5,0.5);

// for convenience I put all values connected to a continent in a Continent-class.
// more about this you will find in the file "Continent.pde"
// basically it makes the code more readable. And this is nice.
Continent northAmerica = new Continent(
  new RelativePoint2D(0.21,0.317),
  new int[]{200,70,90},
  color(231, 53, 49),
  new String[]{"North","America"}
  );

Continent europe = new Continent(
  new RelativePoint2D(0.487,0.31),
  new int[]{80,120,180},
  color(25, 62, 150),
  new String[]{"Europe"}
  );

Continent asia = new Continent(
  new RelativePoint2D(0.77,0.33),
  new int[]{255,190,230},
  color(248, 78, 133),
  new String[]{"Asia"}
  );

Continent southAmerica = new Continent(
  new RelativePoint2D(0.296,0.66),
  new int[]{120,80,130},
  color(133, 49, 144),
  new String[]{"South","America"}
  );

Continent africa = new Continent(
  new RelativePoint2D(0.525,0.515),
  new int[]{70,120,100},
  color(65, 200, 104),
  new String[]{"Africa"}
  );

Continent oceania = new Continent(
  new RelativePoint2D(0.822,0.67),
  new int[]{160,160,90},
  color(252, 223, 3),
  new String[]{"Oceania"}
  );

// CHANGE THIS: how smoothly does the location-svg move around the screen, again, bigger is slower, smaller is quicker
float smoothLocation = 0.95;

void setup() {
  size(displayWidth, displayHeight); // Processing has this neat parameters to retrieve your screens dimensions.
  sketchFullScreen(); // make it fullscreen obviously. don't forget the sketchFullScreen function at the bottom if you implement it somewhere else!
  
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    // print avaibale cameras
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + " : " + cameras[i]);
    }
    // take the camera you want. you might have to change the name
    video = new Capture(this, 160, 120, "FaceTime HD Camera (Built-in)", 30);// " Trust Webcam" CHECK IF THIS IS THE NAME OF YOUR CAMERA (it is printed in the console)
    video.start();     
  }  
  
  debugfont = createFont("Helvetica", 12); // access your system fonts like this
  mediumfont = createFont("inconsolata.ttf", 24); // exchange "inconsolata.tff" with your favourite custom font file. put the font in the data folder (where also inconsolata.ttf is)
  bigfont = createFont("inconsolata.ttf", 36); // same here. the number after the fontname is the size.
  textFont(bigfont);


  
  map = loadImage("map.png");
  location = loadShape("location.svg");
  background(231,53,49);

  // CHANGE THIS: shift around the unique territory to your pleasure
  yourTerritoryYPos = height - 80;
  yourTerritoryXPos = width - 560;
  uniqueTerritoryYPos = height - 30;
  uniqueTerritoryXPos = width - 560;
 
}


void draw() {
  if(!cheatScreen){
  // we don't want the mousecursor floating around the beautiful design, do we?
    noCursor();
  } else {
  // but we want it, when in debug-mode!
    cursor(ARROW);
  }
  // if there is video........... there better should be ;-)
  if (video.available()) {
    
    // stuff
    video.read();
    video.loadPixels();
    
    // just to be sure, that there are no strokes drawn when we draw our things
    noStroke();

    // the value is the only variable we access directly without a function.
    // reason for this are that we want to be sure that java doesn't fuck with our plans.
    // the other variables are safer the other way. think about it and you might understand.
    northAmerica.value = 0;
    europe.value = 0;
    asia.value = 0;
    southAmerica.value = 0;
    africa.value = 0;
    oceania.value = 0;

    int index = 0;
    for (int j = 0; j < video.height; j ++) {
      for (int i = 0; i < video.width; i ++) {
        int pixelColor = video.pixels[j*video.width + i];

        // uuuh, this is confusing for beginners.
        // basically, we get pixelColor as one number, and here we are cutting it at the right places into three. red. africa.value. europe.value.
        // this is the faster way to do it, so we're doing it this way. read about bitshifting and masking if you're curious.
        // but don't expect to understand it quickly. 
        int r = (pixelColor >> 16) & 0xff;
        int g = (pixelColor >> 8) & 0xff;
        int b = pixelColor & 0xff;
        
        // yeeeeeah, here you can simply pick the color from the video. nice, huh?
        if(cheatScreen && mouseX == i && mouseY == j){
          mouseRGB[0] = r;
          mouseRGB[1] = g;
          mouseRGB[2] = b;
        }
        
        // The magic! actually not magic, because it's all very logical and quite simple.
        if ( Math.abs(r - northAmerica.getRawColor()[0]) < range && Math.abs(g - northAmerica.getRawColor()[1]) < range && Math.abs(b - northAmerica.getRawColor()[2]) < range ) {
          northAmerica.value++;
        }  
        if ( Math.abs(r - europe.getRawColor()[0]) < range && Math.abs(g - europe.getRawColor()[1]) < range && Math.abs(b - europe.getRawColor()[2]) < range ) {
          europe.value++;
        }  
        if ( Math.abs(r - asia.getRawColor()[0]) < range && Math.abs(g - asia.getRawColor()[1]) < range && Math.abs(b - asia.getRawColor()[2]) < range ) {
          asia.value++;
        }  
        if ( Math.abs(r - southAmerica.getRawColor()[0]) < range && Math.abs(g - southAmerica.getRawColor()[1]) < range && Math.abs(b - southAmerica.getRawColor()[2]) < range ) {
          southAmerica.value++;
        }  
        if ( Math.abs(r - africa.getRawColor()[0]) < range && Math.abs(g - africa.getRawColor()[1]) < range && Math.abs(b - africa.getRawColor()[2]) < range ) {
          africa.value++;
        }
        if ( Math.abs(r - oceania.getRawColor()[0]) < range && Math.abs(g - oceania.getRawColor()[1]) < range && Math.abs(b - oceania.getRawColor()[2]) < range ) {
          oceania.value++;
        }

        index++;
      }
    }
    
    // smoothing stuff, simple as shit now
    northAmerica.smoothValue();
    europe.smoothValue();
    asia.smoothValue();
    southAmerica.smoothValue();
    africa.smoothValue();
    oceania.smoothValue();
    
    // calculate the combined location
    int totalValues = northAmerica.value+europe.value+asia.value+southAmerica.value+africa.value+oceania.value;
    RelativePoint2D currentCombined = new RelativePoint2D(
                        (map(northAmerica.value,0,totalValues,0,1) * northAmerica.getPosition().x) +
                        (map(europe.value,0,totalValues,0,1) * europe.getPosition().x) + 
                        (map(asia.value,0,totalValues,0,1) * asia.getPosition().x) + 
                        (map(southAmerica.value,0,totalValues,0,1) * southAmerica.getPosition().x) + 
                        (map(africa.value,0,totalValues,0,1) * africa.getPosition().x) + 
                        (map(oceania.value,0,totalValues,0,1) * oceania.getPosition().x),
                        
                        (map(northAmerica.value,0,totalValues,0,1) * northAmerica.getPosition().y) +
                        (map(europe.value,0,totalValues,0,1) * europe.getPosition().y) + 
                        (map(asia.value,0,totalValues,0,1) * asia.getPosition().y) + 
                        (map(southAmerica.value,0,totalValues,0,1) * southAmerica.getPosition().y) + 
                        (map(africa.value,0,totalValues,0,1) * africa.getPosition().y) + 
                        (map(oceania.value,0,totalValues,0,1) * oceania.getPosition().y) );
                        
    if(currentCombined.x > 0 && currentCombined.x < 1 &&  currentCombined.y > 0 && currentCombined.y < 1){                 
      combinedLocation.x = combinedLocation.x * smoothLocation + currentCombined.x * (1.0-smoothLocation);
      combinedLocation.y = combinedLocation.y * smoothLocation + currentCombined.y * (1.0-smoothLocation);
    }
     
    fill(231,53,49,200);
    rect(0, 0, width, height);

    // drawing the actual application
    image(map,0,0,width,height);
    
    pushStyle();
    // draw content... circles
    fill(northAmerica.getDrawColor());
    circle(northAmerica.getPosition().x*width,northAmerica.getPosition().y*height,northAmerica.getSmoothedValue()*0.1*circleSize);
    fill(europe.getDrawColor());
    circle(europe.getPosition().x*width,europe.getPosition().y*height,europe.getSmoothedValue()*0.1*circleSize);
    fill(asia.getDrawColor());
    circle(asia.getPosition().x*width,asia.getPosition().y*height,asia.getSmoothedValue()*0.1*circleSize);
    fill(southAmerica.getDrawColor());
    circle(southAmerica.getPosition().x*width,southAmerica.getPosition().y*height,southAmerica.getSmoothedValue()*0.1*circleSize);
    fill(africa.getDrawColor());
    circle(africa.getPosition().x*width,africa.getPosition().y*height,africa.getSmoothedValue()*0.1*circleSize);
    fill(oceania.getDrawColor());
    circle(oceania.getPosition().x*width,oceania.getPosition().y*height,oceania.getSmoothedValue()*0.1*circleSize);
    
    shape(location,combinedLocation.x*width,combinedLocation.y*height);
    
    popStyle();

    textFont(mediumfont);
    fill(255,255,255);
    text("YOUR TERRITORY:",yourTerritoryXPos, yourTerritoryYPos);

    textFont(bigfont);

    float totalSmoothedValues = northAmerica.getSmoothedValue() + europe.getSmoothedValue() + asia.getSmoothedValue() + southAmerica.getSmoothedValue() + africa.getSmoothedValue() + oceania.getSmoothedValue();
    String northAmerica_sub = getSubstring(northAmerica, "front", totalSmoothedValues);
    text(northAmerica_sub,uniqueTerritoryXPos,uniqueTerritoryYPos);
    float xpos = textWidth(northAmerica_sub);

    String europe_sub = getSubstring(europe, "middle", totalSmoothedValues);
    europe.smoothXpos(xpos);
    text(europe_sub,europe.getXpos() + uniqueTerritoryXPos,uniqueTerritoryYPos);
    xpos += textWidth(europe_sub);

    String asia_sub = getSubstring(asia, "middle", totalSmoothedValues);
    asia.smoothXpos(xpos);
    text(asia_sub,asia.getXpos() + uniqueTerritoryXPos,uniqueTerritoryYPos);
    xpos += textWidth(asia_sub);

    String southAmerica_sub = getSubstring(southAmerica, "middle", totalSmoothedValues);
    southAmerica.smoothXpos(xpos);
    text(southAmerica_sub,southAmerica.getXpos() + uniqueTerritoryXPos,uniqueTerritoryYPos);
    xpos += textWidth(southAmerica_sub);

    String africa_sub = getSubstring(africa, "middle", totalSmoothedValues);
    africa.smoothXpos(xpos);
    text(africa_sub,africa.getXpos() + uniqueTerritoryXPos,uniqueTerritoryYPos);
    xpos += textWidth(africa_sub);

    String oceania_sub = getSubstring(oceania, "middle", totalSmoothedValues);
    oceania.smoothXpos(xpos);
    text(oceania_sub,oceania.getXpos() + uniqueTerritoryXPos,uniqueTerritoryYPos);
    xpos += textWidth(oceania_sub);



    if (cheatScreen) {
      fill(0,0,0,200);
      rect(0,0,width,height);
      pushStyle();
      pushMatrix();
      textFont(debugfont);
//      bars of the colors
      translate(0,video.height);
      fill(northAmerica.getRawColor()[0],northAmerica.getRawColor()[1],northAmerica.getRawColor()[2]);
      text("northAmerica(n): " + round(northAmerica.getSmoothedValue()),20,20+20);
      rect(150,20,northAmerica.getSmoothedValue()*0.25,20);
      fill(europe.getRawColor()[0],europe.getRawColor()[1],europe.getRawColor()[2]);
      text("europe(e): " + round(europe.getSmoothedValue()),20,40+20);
      rect(150,40,europe.getSmoothedValue()*0.25,20);
      fill(asia.getRawColor()[0],asia.getRawColor()[1],asia.getRawColor()[2]);
      text("asia(a): " + round(asia.getSmoothedValue()),20,60+20);
      rect(150,60,asia.getSmoothedValue()*0.25,20);
      fill(southAmerica.getRawColor()[0],southAmerica.getRawColor()[1],southAmerica.getRawColor()[2]);
      text("southAmerica(s): " + round(southAmerica.getSmoothedValue()),20,80+20);
      rect(150,80,southAmerica.getSmoothedValue()*0.25,20);
      fill(africa.getRawColor()[0],africa.getRawColor()[1],africa.getRawColor()[2]);
      text("africa(f): " + round(africa.getSmoothedValue()),20,100+20);
      rect(150,100,africa.getSmoothedValue()*0.25,20);
      fill(oceania.getRawColor()[0],oceania.getRawColor()[1],oceania.getRawColor()[2]);
      text("oceania(o): " + round(oceania.getSmoothedValue()),20,120+20);
      rect(150,120,oceania.getSmoothedValue()*0.25,20);

      text("to pick a color, move your mouse to over the desired color in the video & hit the key int the brackets. e.g. 'n' for northAmerica",20,140+20);
      
      
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
    }
  }
};

// this get's a single String for all Continents. I didn't use it in the end, because it wouldn't transition as nicely.
// String getUniqueTerritory(){
//   String uniqueName = "";
//   float totalSmoothedValues = northAmerica.getSmoothedValue() + europe.getSmoothedValue() + asia.getSmoothedValue() + southAmerica.getSmoothedValue() + africa.getSmoothedValue() + oceania.getSmoothedValue();
//   uniqueName += getSubstring(northAmerica, "front", totalSmoothedValues);
//   uniqueName += getSubstring(europe, "middle", totalSmoothedValues);
//   uniqueName += getSubstring(asia, "middle", totalSmoothedValues);
//   uniqueName += getSubstring(southAmerica, "middle", totalSmoothedValues);
//   uniqueName += getSubstring(africa, "middle", totalSmoothedValues);
//   uniqueName += getSubstring(oceania, "end", totalSmoothedValues);
//   return uniqueName;
// }

String getSubstring(Continent continent, String position, float totalSmoothedValues){
  String substring = "";
  for(String namePiece : continent.getName()){
    int nameLength = int(map(continent.getSmoothedValue(),0,totalSmoothedValues,0,namePiece.length()));
    nameLength = nameLength == 0 && continent.getSmoothedValue() > 100 ? 1 : nameLength;
    // nameLength = nameLength > 0 ? min(namePiece.length(),nameLength+1) : 0;
    if( position.indexOf("front") >= 0){
      substring += namePiece.substring(0,nameLength);
    } else if( position.indexOf("middle") >= 0){
      int start = int((namePiece.length() - nameLength)*0.5);
      substring += namePiece.substring(start, start + nameLength);
    } else if( position.indexOf("end") >= 0){
      substring += namePiece.substring(namePiece.length() - nameLength);
    } else {
      System.err.println("Oops, seems like you're trying to get a subString without defining which end to pick. check your getSubstring(bla,bla) functions");
    }
  }
  return substring.toUpperCase();
}

void circle(float x, float y, float size){
  ellipse(x,y,size,size);
}

void keyPressed() {
  if (key == 'd') {
    cheatScreen = !cheatScreen;
  }
  if(key == 'n'){
    northAmerica.setRawColor(mouseRGB.clone());
  }
  if(key == 'e'){
    europe.setRawColor(mouseRGB.clone());
  }
  if(key == 'a'){
    asia.setRawColor(mouseRGB.clone());
  }
  if(key == 's'){
    southAmerica.setRawColor(mouseRGB.clone());
  }
  if(key == 'f'){
    africa.setRawColor(mouseRGB.clone());
  }
  if(key == 'o'){
    oceania.setRawColor(mouseRGB.clone());
  }
  if(key == UP){
    range++;
  }
  if(key == DOWN){
    range = range > 0 ? range-1 : range;
  }
};

boolean sketchFullScreen() {
  return true;
};
