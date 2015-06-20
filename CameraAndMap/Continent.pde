// this is the Continent-class. All variables that were lose before, are now nicely stored in this pretty Container.
class Continent {
  // first, all variables are listed. the ones which do not have to be defined when initialized, are already given a starting value
  RelativePoint2D position;
  public int value = 0;
  float smoothedValue = 0;
  int[] rawColor;
  color drawColor;
  String[] name;
  float xpos = 0;
  float xposSmoothfactor = 0.5;

  // this defines how this class must be initialized, so you can't forget anything
  public Continent(RelativePoint2D position, int[] rawColor, color drawColor, String[] name){
    this.position = position;
    this.rawColor = rawColor;
    this.drawColor = drawColor;
    this.name = name;
  }
  // it is good practice to define functions when you want to access variables from within a class.
  public float getSmoothedValue(){
    return smoothedValue;
  }
  // this is cool, later we just have to call this function and it will be smoothed automatically. Less code for free!
  public void smoothValue(){
    smoothedValue = smoothFactor * smoothedValue + (1.0-smoothFactor) * value;
  }
  public float getXpos(){
    return xpos;
  }
  public void smoothXpos(float xpos){
    this.xpos = xposSmoothfactor * this.xpos + (1.0-xposSmoothfactor) * xpos;
  }
  public color getDrawColor(){
    return drawColor;
  }
  public int[] getRawColor(){
    return rawColor;
  }
  public void setRawColor(int[] rawColor){
    this.rawColor = rawColor;
  }
  public RelativePoint2D getPosition(){
    return position;
  }
  public String[] getName(){
    return name;
  }
};