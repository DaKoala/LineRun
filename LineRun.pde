import java.io.FileWriter;

PImage block, award, thorn, thornTop, gapImg;
ArrayList<PImage> poses = new ArrayList<PImage>();
PFont font;
float FOV = PI / 3;
boolean keyTest = true;
int stage = 0;
int highest;
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
  gapImg = loadImage("gapImg.png");
  float cameraZ = (height / 2.0) / tan(FOV / 2.0);
  perspective(FOV, float(width) / float(height), cameraZ / 10.0, cameraZ * 50.0);
  ground = new Ground(listener);

  font = loadFont("AvenirNext-Heavy-48.vlw");
  textFont(font);

  String[] lines = loadStrings("highest.txt");
  highest = parseInt(lines[0]);
}

void draw() {
  background(0);

  updateKinect();
  listener.update();
  listener.test();
  if (keyTest && keyPressed) {
    if (key == 'w' || key == 'W') listener.jump = true;
    if (key == 's' || key == 'S') listener.squad = true;
    if (key == 'r' || key == 'R') listener.handUp = true;
    listener.tilt = 0;
    if (key == 'a' || key == 'A') listener.tilt = -1;
    if (key == 'd' || key == 'D') listener.tilt = 1;
    listener.foot = 0;
    if (key == 'q' || key == 'Q') listener.foot = -1;
    if (key == 'e' || key == 'E') listener.foot = 1;
  }

  if (stage == 0) {
    instruct(120, 300, award, "Collect it to charge\nthe shield. Raise your\nhand if it is too high.", color(0, 255, 0));
    instruct(570, 300, block, "Tilt your head to\navoid.", color(255, 0, 0));
    instruct(920, 300, thorn, "Jump before you\nbump into it.", color(255, 0, 0));
    instruct(1270, 300, thornTop, "Squat before you\nbump into it.", color(255, 0, 0));
    instruct(1620, 300, gapImg, "Lift your on the\nside it appears.", color(255, 0, 0));
    fill(abs(frameCount * 2 % 510 - 255));
    textSize(72);
    text("Raise hands to start", 600, 800);
    if (listener.handUp) {
      stage = 1;
    }
  }

  if (stage == 1) {
    pushMatrix();
    translate(width / 2, height / 2);
    ground.updatePosture();
    println("Height: " + ground.heightCoef + "| Vel: " + ground.velY);
    ground.move();
    ground.bump();
    ground.update();
    ground.displayLine();
    ground.displayObstacles();
    popMatrix();
    ground.displayScore();
    ground.displayShield();
    blendMode(ALPHA); // only for alpha blending
    blendMode(NORMAL); // in terms of other blending modes
    image(poses.get((frameCount / 4) % 7), 0, 0);

    if (ground.isDead()) {
      stage = 2;
    }
  }

  if (stage == 2) {
    fill(255, 204, 0);
    textSize(80);
    if (ground.score >= highest) {
      text("New record!!!", 480, 300);
      highest = ground.score;
      try {
        FileWriter output = new FileWriter(sketchPath() + "\\data\\highest.txt", false);
        output.write(str(highest));
        output.flush();
        output.close();
      }
      catch (IOException e) {
        println("Could not write into the file!");
        e.printStackTrace();
      }
    } else {
      text("Better luck next time!", 480, 300);
    }
    fill(255);
    textSize(64);
    text("Your score: " + ground.score, 480, 400);
    text("Highest score: " + highest, 480, 500);
  }
}

void instruct(int x, int y, PImage game, String instruction, color clr) {
  image(game, x, y);
  //image(person, x, y + 200);
  fill(clr);
  textSize(24);
  text(instruction, x, y + 220);
}