import android.content.Intent;
import android.os.Bundle;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

PImage button;
PImage buttonPressed;
PImage upButton;
PImage downButton;
boolean overBox = false;
float bx;
float by;
float upX;
float upY;
float downX;
float downY;

//int [] PINS={ 13,12,11,10,9,8,7,6,5,4,3,2};
//int pinCycle;

PFont fontMy;
boolean bReleased = true; //no permament sending when finger is tap
KetaiBluetooth bt;
boolean isConfiguring = true;
String info = "";
KetaiList klist;
ArrayList devicesDiscovered = new ArrayList();
  byte [] ON = { 'H'}; //send on to Arduino
    byte [] OFF = { 'L'}; //send LOW to Arduino
byte  [] pinNum;
int pinCycle;

//********************************************************************
// The following code is required to enable bluetooth at startup.
//********************************************************************

void onCreate(Bundle savedInstanceState) {
 super.onCreate(savedInstanceState);
 bt = new KetaiBluetooth(this);
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
 bt.onActivityResult(requestCode, resultCode, data);
}

void setup() {
 size(displayWidth, displayHeight);

   bx = displayWidth/2;
  by = displayHeight/2;
   upX = width/1.3;
  upY = height/1.25;
  downY = height/1.25;
  downX = width/11;
 pinNum = new byte [pinCycle];
for(pinCycle = 2; pinCycle < pinNum.length; pinCycle++){
  println(pinNum[pinCycle]);

}

 
   button  =loadImage("button.png");
  buttonPressed = loadImage("buttonPressed.png");
    upButton = loadImage("up.png");
  downButton = loadImage("down.png");
  upButton.resize(50, 50);
  downButton.resize(50,50);
  button.resize(200,200);
  buttonPressed.resize(200,200);
  
 //start listening for BT connections
 bt.start();
 //at app start select device…
 isConfiguring = true;
 //font size
 fontMy = createFont("OCRA.ttf", 25);
 textFont(fontMy);
}

void draw() {
   // background(#00878F);

background(#D63222);
imageMode(CENTER);
    /*
    float slideDist = constrain(mouseX, 40, width/1.3);
float PWM = map(slideDist, 40, width/1.3 , 0, 255);
 //at app start select device
 int PWM_SEND = int(PWM);
 fill(0);

rect(slideDist, height/1.4, 20, 40);
strokeWeight(10);
line(40, height/1.37, width/1.3, height/1.37);
byte [] PWM_VAL = new byte [PWM_SEND] ;
bt.broadcast(PWM_VAL);
*/
image(button, bx, by);
     
 if (isConfiguring)
 {
  ArrayList names;
  //background(#00979D);
    background(#D63222);

  klist = new KetaiList(this, bt.getPairedDeviceNames());
  isConfiguring = false;
 }
 else
 {
 if (mouseX > bx-button.width && mouseX < bx+button.width && 
      mouseY > by-button.height && mouseY < by+button.height) {
overBox = true;     
   }
   if(overBox && mousePressed==true) { 

image(buttonPressed, bx, by);
  bt.broadcast(ON);
} 
else
  {
  overBox = false;
  bt.broadcast(OFF);
  }
}
  // text(PWM, width/6, height/1.05);

text("Pin:"+pinCycle, width/3.5, height/1.05);
  
//pinCycle = constrain(pinCycle, 0, pinNum.length );
  
  image(downButton, downX, downY);
  image(upButton, upX, downY);
//bt.broadcast(pinNum);


 }
 
void mousePressed(){
  
    //check id down arrow is pressed to select pins on Arduino
   if (mouseX > downX-downButton.width && mouseX < downX+downButton.width && 
      mouseY > downY-downButton.height && mouseY < downY+downButton.height ) {
  pinCycle--;
 // bt.broadcast(pinNum);


      }     

       if (mouseX > upX-upButton.width && mouseX < upX+upButton.width && 
      mouseY > upY-upButton.height && mouseY < upY+upButton.height && pinCycle <= 13){
      pinCycle++; 
      //bt.broadcast(pinNum);


}

  
}

boolean mouseOverRect() { // Test if mouse is over square
  return ((mouseX >= (width/2-100)) && (mouseX <= (width/2+100)) && (mouseY >= (height/2-100)) && (mouseY <= (height/2+100)));
}

void onKetaiListSelection(KetaiList klist) {
 String selection = klist.getSelection();
 bt.connectToDeviceByName(selection);
 //dispose of list for now
 klist = null;
}

//Call back method to manage data received
void onBluetoothDataEvent(String who, byte[] data) {
 if (isConfiguring)
 return;
 //received
 info += new String(data);
 //clean if string to long
 if(info.length() > 150)
 info = "";
}

/* ARDUINO CODE */  
