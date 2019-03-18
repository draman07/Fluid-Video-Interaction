// Daniel Shiffman
// Tracking the average location beyond a given depth threshold
// Thanks to Dan O'Sullivan

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import codeanticode.syphon.*;

// The kinect stuff is happening in another class
KinectTracker tracker;
Kinect kinect;
PGraphics canvas;
SyphonServer server;


void setup() {
  size(640, 520, P3D);
  kinect = new Kinect(this);
  tracker = new KinectTracker();
  canvas = createGraphics(640,520,P3D);
  server = new SyphonServer(this, "Processing Syphon");
}



void draw() {
  canvas.beginDraw();
  background(255);

  // Run the tracking analysis
  tracker.track();
  // Show the image
  tracker.display();

  // Let's draw the raw location
  PVector v1 = tracker.getPos();
  canvas.fill(50, 100, 250, 200);
  canvas.noStroke();
  canvas.ellipse(v1.x, v1.y, 20, 20);

  // Let's draw the "lerped" location
  PVector v2 = tracker.getLerpedPos();
  canvas.fill(100, 250, 50, 200);
  canvas.noStroke();
  canvas.ellipse(v2.x, v2.y, 20, 20);


  // Display some info
  int t = tracker.getThreshold();
  canvas.fill(0);
  canvas.text("threshold: " + t + "    " +  "framerate: " + int(frameRate) + "    " + 
    "UP increase threshold, DOWN decrease threshold", 10, 500);
   canvas.line(0, 0, mouseX, mouseY);
   canvas.endDraw();
   image(canvas,0,0);
   server.sendImage(canvas);
}

// Adjust the threshold with key presses
void keyPressed() {
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=5;
      tracker.setThreshold(t);
    } else if (keyCode == DOWN) {
      t-=5;
      tracker.setThreshold(t);
    }
  }
}
