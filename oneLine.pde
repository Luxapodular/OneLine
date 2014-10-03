import java.awt.MouseInfo;
import java.awt.Point;

LineMan guy;
boolean mouseInFrame;
int lastMouseX;
int lastMouseY;

void setup() {
  size(800,600);
  lastMouseX = 0;
  lastMouseY = 0;
  mouseInFrame = false;
  guy = new LineMan(width/2, height/2);
}

void draw() {
  background(255);
  checkForMouse();
  guy.update();
  guy.drawMe();
}

void checkForMouse() {
  Point mousePos = (MouseInfo.getPointerInfo().getLocation());
  int mWinX = mousePos.x;
  int mWinY = mousePos.y;
  int fX = frame.getLocation().x;
  int fY = frame.getLocation().y;
  if ((mWinX > fX && mWinX < fX + width) &&
     (mWinY > fY && mWinY < fY + height)) {
   mouseInFrame = true;
  } else {
   mouseInFrame = false;
  } 
  if (lastMouseX != mouseX){
    lastMouseX = mouseX;
  }
  if (lastMouseY != mouseY) {
    lastMouseY = mouseY;
  }
}

class LineMan {
  float x;
  float y;
  float lineLength;
  float thickness;
  float headX;
  float headY;
  float bottomX;
  float bottomY;
  float hoverValue;
  float shakeValue;
  float speed;
  boolean inPlace;
  float shakeChange;
  boolean noRelocate;
  Position target;
  int lastSeenX; 
  int lastSeenY;
  float scared;
  float originalSpeed;
  
  LineMan(float x, float y) {
   this.lastSeenX = 0;
   this.lastSeenY = 0;
   
   this.x = x;
   this.y = y;
   
   this.lineLength = random(height*.05, height*.1);
   this.thickness = random(width*.005, width*.01);
   
   this.originalSpeed = (max(width * .2 , height * .2) / (this.lineLength * this.thickness));
   this.speed = this.originalSpeed;
   
   this.headX = x;
   this.headY = y - this.lineLength / 2;
   
   this.bottomX = x;
   this.bottomY = y + this.lineLength /2;
   
   this.hoverValue = random(0, 6.28);
   this.shakeValue = random(0, 6.28);
   
   this.shakeChange = .1;
   this.inPlace = false;
   
   this.scared = 1;
   
   target = new Position(width * .1, width * .9, height * .1, height *.9);
  }
  
  void move() {
      float distance = dist(this.x, this.y, this.target.x, this.target.y);
      if (distance < (max(width,height) * .05)) {
        this.inPlace = true;
      } else {
        this.inPlace = false;
      }
      if (!this.inPlace) {
          this.x += this.speed *  -((this.x - this.target.x)/distance);
          this.y += this.speed *  -((this.y - this.target.y)/distance);
      } 
    this.headX = this.x; 
    this.headY = this.y - lineLength/2;
    this.bottomX = this.x;
    this.bottomY = this.y + lineLength/2;
  }
  
  void hover() {
    float xChange = cos(this.shakeValue) * (width * .02);
    float yChange = sin(this.hoverValue) * (height * .02);
    this.headX += xChange;
    this.bottomX += xChange;
    this.headY += yChange;
    this.bottomY += yChange;
    this.hoverValue = (this.hoverValue + this.shakeChange) % 6.28;

  }
  
  void drawMe() {
    strokeWeight(this.thickness);
    line(headX,headY, bottomX, bottomY);
  }
  
  void relocate() {
    float distance;
    float erratic = .1; // bigger value means more erratic behavior. 
    if (mouseInFrame) { // Relocate on screen to a new position if the mouse is on screen
    //These Changes will be erratic and make the line look scared.
      if ((random(10) < erratic) || (lastMouseX != this.lastSeenX || lastMouseY != this.lastSeenY)) {
        this.lastSeenX = lastMouseX;
        this.lastSeenY = lastMouseY;
          if (mouseY < height / 2) { // Top half
            if (mouseX < width/2) { //left
              this.target = new Position(width/2, width, height/2, height); //bottom right
            } else { // right
              this.target = new Position(0, width/2, height/2, height); // bottom left
            }
          } else { //Bottom Half
            if (mouseX < width/2) { //left
              this.target = new Position(width/2, width, 0, height/2); // top Right
            } else { //right
              this.target = new Position(0, width/2, 0, height/2); // top left
            }
          }
      }
    } else { 
      float chance = .1; // Bigger values means more relocation when mouse off screen.
      if (random(10) < chance) { // Relocate in the window sometimes 
        this.target = new Position(width * .1, width * .9, height * .1, height * .9);
      }
    }
  } 

  void worry() {
   if (mouseInFrame) {
      this.shakeValue = (this.shakeValue + (this.shakeChange * this.scared)) % 6.28;
      if (!(this.speed >= this.originalSpeed * 2)) {
        this.speed *= 1.01;
      }
      if (!(this.scared >= 3)) {
        this.scared *= 1.01;
      }
    } else {
        if (!(this.scared <= 1)) {
          this.scared *= .999;
        }
        if (!(this.shakeValue <= .1)) {
          this.shakeValue -= .005;
        }
        if (!(this.speed <= this.originalSpeed)) {
          this.speed *= .999;
        }
      }
  }  
  
  void update() {
    this.worry();
    this.move();
    this.hover();
    this.relocate();
  }
    
}

class Position {
    float x;
    float y;
    
    Position(float startX, float endX, float startY, float endY) {
      this.x = random(startX, endX);
      this.y = random(startY, endY);
    }
}


  
  
   
   
