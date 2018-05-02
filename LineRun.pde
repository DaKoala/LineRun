PImage block, award, leftHand, rightHand;
ArrayList<PImage> images = new ArrayList<PImage>();
float FOV = PI / 3;
int tilt = 0;
int tiltCoef = 0;
int timeCount;
Ground ground;


void setup() {
  size(1920, 1080, P3D);
  setupKinect();
  
  block = loadImage("block.png");
  award = loadImage("award.png");
  leftHand = loadImage("lefthand.png");
  rightHand = loadImage("righthand.png");
  float cameraZ = (height / 2.0) / tan(FOV / 2.0);
  perspective(FOV, float(width) / float(height), cameraZ / 10.0, cameraZ * 30.0);
  ground = new Ground(listener);
}

void draw() {
  background(0);
  updateKinect();
  listener.update();
  listener.test();
  pushMatrix();
  fill(255);
  textSize(36);
  text(ground.score, 10, 30);
  text(ground.shield, 10, 60);
  text(int(ground.isDead()), 10, 90);
  translate(width / 2, height / 2);
  ground.updatePosture();
  ground.tilt();
  println(ground.foot);
  ground.bump();
  ground.displayObstacles();
  ground.update();
  ground.display();
  popMatrix();
  
  hint(DISABLE_DEPTH_TEST);
  blendMode(DIFFERENCE);
  image(leftHand, 0, 600);
}