PImage block, award, thorn, thornTop, leftHand, rightHand;
ArrayList<PImage> poses = new ArrayList<PImage>();
float FOV = PI / 3;
int tilt = 0;
int tiltCoef = 0;
int timeCount;
Ground ground;


void setup() {
  size(1920, 1080, P3D);
  setupKinect();
  for (int i = 1; i <= 7; i++) {
    poses.add(loadImage("pose" + i + "_.png"));
  }
  block = loadImage("block.png");
  award = loadImage("award.png");
  thorn = loadImage("thorn.png");
  thornTop = loadImage("thorn_top.png");
  leftHand = loadImage("lefthand.png");
  rightHand = loadImage("righthand.png");
  float cameraZ = (height / 2.0) / tan(FOV / 2.0);
  perspective(FOV, float(width) / float(height), cameraZ / 10.0, cameraZ * 50.0);
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
  text(ground.heightCoef, 10, 120);
  translate(width / 2, height / 2);
  ground.updatePosture();
  println("Height: " + ground.heightCoef + "| Vel: " + ground.velY);
  ground.move();
  ground.bump();
  ground.update();
  ground.displayLine();
  ground.displayObstacles();
  

  popMatrix();
  blendMode(ALPHA); // only for alpha blending
  blendMode(NORMAL); // in terms of other blending modes
  image(poses.get((frameCount / 4) % 7), 0, 0);
}