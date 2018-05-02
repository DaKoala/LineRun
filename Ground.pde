class Ground {
  final static int FAR = -10000;
  final static int CLO = 0;
  final static int MID = 0;
  final static int BTM = 740;
  final static int LT  = -240;
  final static int RT  = 240;
  final static int TP  = -240;
  final static float G   = 0.1;

  int left;
  int right;
  int tiltCoef;
  float velY;
  float heightCoef;
  int tiltTo;
  int foot;
  int score;
  int shield;
  boolean handUp;
  boolean dead;
  float speed;
  float gapCount;
  float obstacleCount;
  ArrayList<Gap> changes;
  ArrayList<Obstacle> obstacles;
  Listener listener;

  class Gap {
    float z;
    int left, right;

    Gap(float _z, int _left, int _right) {
      this.z = _z;
      this.left = _left;
      this.right = _right;
    }
  }

  class Obstacle {
    final static int SIZE = 50;

    float z;
    int type; // 0 block, 1 award
    boolean isTop;
    boolean isLeft;

    Obstacle(float _z, int _type, boolean _isTop, boolean _isLeft) {
      this.type = _type;
      this.z = _z;
      this.isTop = _isTop;
      this.isLeft = _isLeft;
    }

    void display() {
      pushMatrix();
      fill(0, 255);
      noStroke();
      if (this.isTop && this.type == 1) translate(0, TP, 0);

      if (this.isLeft) translate(LT, 0, 0);
      else             translate(RT, 0, 0);
      translate(0, 0, this.z);
      beginShape();
      if (type == 0) texture(block);
      else          texture(award);
      vertex(-SIZE, -SIZE, 0, 0);
      vertex(SIZE, -SIZE, 100, 0);
      vertex(SIZE, SIZE, 100, 100);
      vertex(-SIZE, SIZE, 0, 100);
      endShape();
      popMatrix();
    }
  }

  Ground(Listener _listener) {
    this.left = -width / 4;
    this.right = width / 4;
    this.changes = new ArrayList<Gap>();
    this.obstacles = new ArrayList<Obstacle>();
    this.speed = 10;
    this.gapCount = 0;
    this.obstacleCount = 0;
    this.tiltTo = 0;
    this.tiltCoef = 0;
    this.heightCoef = 0;
    this.velY = 0;
    this.foot = 0;
    this.handUp = false;
    this.score = 0;
    this.shield = 0;
    this.dead = false;
    this.listener = _listener;
  }

  void move() {
    if (this.listener.tilt == -1) this.tiltCoef = this.tiltCoef >= RT ? this.tiltCoef : this.tiltCoef + 10; 
    else if (this.listener.tilt == 1) this.tiltCoef = this.tiltCoef <= LT ? this.tiltCoef : this.tiltCoef - 10;
    else {
      if (this.tiltCoef != 0) this.tiltCoef = this.tiltCoef > 0 ? this.tiltCoef - 10 : this.tiltCoef + 10;
    }
    translate(this.tiltCoef, 0, 0);

    if (this.tiltCoef == RT) this.tiltTo = -1;
    else if (this.tiltCoef == LT) this.tiltTo = 1;
    else this.tiltTo = 0;

    if (this.listener.squad) {
      if (this.heightCoef > -200 && this.heightCoef <= 0) this.velY = -5;
      else this.velY = 0;
    } else if (this.listener.jump) {
      if (this.heightCoef == 0) this.velY = 8;
      else this.velY -= G;
    } else {
      if (this.heightCoef >= -200 && this.heightCoef < 0) this.velY = 5;
      else if (this.heightCoef > 0) this.velY -= G;
      else this.velY = 0;
    }
    if (this.heightCoef > 0 && this.heightCoef + this.velY < 0) this.heightCoef = 0;
    else if (this.heightCoef < -200) this.heightCoef = -200;
    else this.heightCoef += this.velY;
    translate(0, this.heightCoef, 0);
  }

  void updatePosture() {
    this.foot = this.listener.foot;
    this.handUp = this.listener.handUp;
  }

  void bump() {
    this.score += 10;
    if (this.left == LT || this.right == RT) {
      if (this.foot == 0) this.dead = true;
      if (this.foot != -1 && this.left == LT) this.dead = true;
      if (this.foot != 1 && this.right == RT) this.dead = true;
    }

    if (!this.changes.isEmpty()) {
      Gap head = this.changes.get(0);
      if (head.z > CLO) {
        this.left = head.left;
        this.right = head.right;
        this.changes.remove(0);
      }
    }
    
    if (this.obstacles.size() > CLO && this.obstacles.get(0).z > 0) {
      Obstacle o = obstacles.get(0);
      if (o.type == 0) {
        if ((o.isLeft && this.tiltTo != 1) || (!o.isLeft && this.tiltTo != -1)) {
          this.dead = true;
        }
      } else {
        if ((o.isLeft && this.tiltTo != 1) || (!o.isLeft && this.tiltTo != -1)) {
          if ((this.handUp && o.isTop) || !o.isTop) {
            this.shield = this.shield >= 10 ? this.shield : this.shield + 1;
            this.score += 3000;
          }
        }
      }
      this.obstacles.remove(0);
    }
  }

  void update() {
    for (int i = changes.size() - 1; i >= 0; i--) {
      Gap curr = changes.get(i);
      curr.z += this.speed;
    }
    this.obstacleCount += this.speed;
    if (this.obstacleCount > 5000) {
      float r = random(1);
      if (r > 0.5) {
        if (random(1) > 0.5) {
          this.addGap(FAR, LT, width / 4);
          this.addGap(FAR - 2000, -width / 4, width / 4);
        } else {
          this.addGap(FAR, -width / 4, RT);
          this.addGap(FAR - 2000, -width / 4, width / 4);
        }
      } else {
        this.obstacles.add(new Obstacle(FAR, int(random(0, 2)), random(1) > 0.5, random(1) > 0.5));
      }
      this.obstacleCount = 0;
    }
    this.speed = this.speed >= 30 ? this.speed : this.speed + 0.02;
  }

  void addGap(int z, int left, int right) {
    this.changes.add(new Gap(z, left, right));
  }

  void displayObstacles() {
    for (Obstacle o : this.obstacles) {
      o.z += this.speed;
      o.display();
    }
  }

  void displayLine() {
    pushStyle();
    stroke(255);
    strokeWeight(5);
    int lt = this.left;
    int rt = this.right;
    float z = CLO;
    for (int i = 0; i < this.changes.size(); i++) {
      Gap curr = this.changes.get(i);
      if (lt == LT) stroke(255, 0, 0);
      else          stroke(0, 255, 0);
      line(lt, BTM, z, lt, BTM, curr.z);
      if (rt == RT) stroke(255, 0, 0);
      else          stroke(0, 255, 0);
      line(rt, BTM, z, rt, BTM, curr.z);
      stroke(255, 255, 0);
      if      (lt != curr.left) line(lt, BTM, curr.z, curr.left, BTM, curr.z);
      else if (rt != curr.right) line(rt, BTM, curr.z, curr.right, BTM, curr.z);
      lt = curr.left;
      rt = curr.right;
      z = curr.z;
      if (i == this.changes.size() - 1) {
        if (lt == LT) stroke(255, 0, 0);
        else          stroke(0, 255, 0);
        line(lt, BTM, z, lt, BTM, FAR);
        if (rt == RT) stroke(255, 0, 0);
        else          stroke(0, 255, 0);
        line(rt, BTM, z, rt, BTM, FAR);
      }
    }
    if (this.changes.isEmpty()) {
      stroke(0, 255, 0);
      line(this.left, BTM, CLO, this.left, BTM, FAR);
      line(this.right, BTM, CLO, this.right, BTM, FAR);
    }
    popStyle();
  }

  boolean isDead() {
    if (this.dead && this.shield == 10) {
      this.shield = 0;
      this.dead = false;
    }
    return this.dead;
  }
}