/*
  A quick Processing sketch to shoot time lapsed images.
  Use the 
*/

// Time lapse parameters
int cameraNum = 85;                      // choose shich webcam to use from the array of available ones
int shootEvery = 1000;                  // in millis
boolean showImageOnScreen = false;       // display shot image on window? false will make the sketch faster
String fileFormat = "jpg";              // png, jpg, tiff... 

// Sketch variables
PImage lastShot; 
long time, shotTime;
boolean takeShot = false;
String folderName, fileName; 

import processing.video.*;
import java.util.Date;

Capture cam;

void setup() {
  size(640, 480);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + " " + cameras[i]);
    }
    
    if (cameraNum > cameras.length) {
      cameraNum = 0;
    } 
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[cameraNum]);
    cam.start();     
  }      
  
  folderName = sketchPath() + File.separator + year() + "-" + nf(month(), 2) + "-" + nf(day(), 2);
  File dir = new File(folderName);
  dir.mkdir();
}

void draw() {
  time = millis();
  if (time - shotTime >= shootEvery) {
    takeShot = true;
  }
  
  if (takeShot && cam.available() == true) {
    cam.read();
    
    int mil = (int) ((new Date().getTime()) % 1000);
    String fileStr = "TL_" + year() + nf(month(), 2) + nf(day(), 2) + "_" + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2) + nf(mil, 3) + "." + fileFormat;
    fileName = folderName + File.separator + fileStr;
    
    lastShot = cam.copy();
    lastShot.save(fileName);
        
    shotTime += shootEvery;  // try to stick to the pace as much as possible 
    takeShot = false;
    
    println("Saved " + fileName); 
  }
  
  if (showImageOnScreen) {
    image(lastShot, 0, 0, width, height);
  }
}
