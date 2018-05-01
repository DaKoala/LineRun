PImage block, award;
ArrayList<PImage> images = new ArrayList<PImage>();
float FOV = PI / 3;
int tilt = 0;
int tiltCoef = 0;
int timeCount;
Ground ground;


void setup() {
  size(800, 600, P3D);
  block = loadImage("block.png");
  award = loadImage("award.png");
  float cameraZ = (height / 2.0) / tan(FOV / 2.0);
  perspective(FOV, float(width) / float(height), cameraZ / 10.0, cameraZ * 30.0);
  ground = new Ground();
}

void draw() {
  background(0);
  pushMatrix();
  fill(255);
  text(ground.score, 10, 20);
  text(ground.shield, 10, 40);
  text(int(ground.isDead()), 10, 60);
  
  translate(width / 2, height / 2);
  ground.tilt();
  ground.bump();
  ground.displayObstacles();
  ground.update();
  ground.display();
  popMatrix();
}