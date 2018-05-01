class Ground {
  final static int FAR = -11000;
  final static int CLO = 0;
  final static int MID = 0;
  final static int BTM = 540;
  final static int LT  = -480;
  final static int RT  = 480;
  final static int TP  = -480;

  int left;
  int right;
  int tiltCoef;
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
    this.left = -width / 2;
    this.right = width / 2;
    this.changes = new ArrayList<Gap>();
    this.obstacles = new ArrayList<Obstacle>();
    this.changes.add(new Gap(FAR, this.left, this.right));
    this.speed = 10;
    this.gapCount = 0;
    this.obstacleCount = 0;
    this.tiltTo = 0;
    this.tiltCoef = 0;
    this.foot = 0;
    this.handUp = false;
    this.score = 0;
    this.shield = 0;
    this.dead = false;
    this.listener = _listener;
  }
  
  void tilt() {
    if (this.listener.tilt == -1) this.tiltCoef = this.tiltCoef >= RT ? this.tiltCoef : this.tiltCoef + 10; 
    else if (this.listener.tilt == 1) this.tiltCoef = this.tiltCoef <= LT ? this.tiltCoef : this.tiltCoef - 10;
    else {
      if (this.tiltCoef != 0) this.tiltCoef = this.tiltCoef > 0 ? this.tiltCoef - 10 : this.tiltCoef + 10;
    }
    translate(this.tiltCoef, 0, 0);
    
    if (this.tiltCoef == RT) this.tiltTo = -1;
    else if (this.tiltCoef == LT) this.tiltTo = 1;
    else this.tiltTo = 0;
  }
  
  void updatePosture() {
    this.foot = this.listener.foot;
    this.handUp = this.listener.handUp;
  }
  
  void bump() {
    this.score += 5;
    if (this.left == LT || this.right == RT) {
      if (this.foot == 0) this.dead = true;
      if (this.foot != -1 && this.left == LT) this.dead = true;
      if (this.foot != 1 && this.right == RT) this.dead = true;
    }
    
    //if (changes.size() > 2) {
    //  Gap head = changes.get(1);
    //  if (head.z > CLO) {
    //    if (head.type == 1) {
    //      this.left = this.left == -width / 2 ? this.left / 2 : this.left * 2;
    //    } else if (head.type == 2) {
    //      this.right = this.right == width / 2 ? this.right / 2 : this.right * 2;
    //    }
    //    this.changes.remove(1);
    //  }
    //}
    Gap head = this.changes.get(0);
    if (head.z > CLO) {
      this.left = head.left;
      this.right = head.right;
      this.changes.remove(0);
    }
    
    if (this.obstacles.size() > CLO && this.obstacles.get(0).z > 0) {
      Obstacle o = obstacles.get(0);
      if (o.type == 0) {
        if ((o.isLeft && this.tiltTo != 1) || (!o.isLeft && this.tiltTo != -1)) {
          this.dead = true; 
        }
      }
      else {
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
    this.gapCount += this.speed;
    this.obstacleCount += this.speed;
    if (this.gapCount > 10000) {
      Gap tail = this.changes.get(this.changes.size() - 1);
      if (tail.left == LT || tail.right == RT) {
        this.addGap(-width / 2, width / 2);
      }
      else {
        if (random(1) > 0.5) this.addGap(LT, width / 2);
        else                 this.addGap(-width / 2, RT);
      }
      this.gapCount = 0;
    }
    
    if (this.obstacleCount > 6000) {
      this.obstacles.add(new Obstacle(FAR, int(random(0, 2)), random(1) > 0.5, random(1) > 0.5));
      this.obstacleCount = 0;
    }
    this.speed = this.speed >= 30 ? this.speed : this.speed + 0.02;
  }

  void addGap(int left, int right) {
    this.changes.add(new Gap(FAR, left, right));
  }
  
  void displayObstacles() {
    for (Obstacle o : this.obstacles) {
      o.z += this.speed;
      o.display(); 
    }
  }

  void display() {
    pushStyle();
    stroke(255);
    strokeWeight(5);
    int lt = this.left;
    int rt = this.right;
    float z = CLO;
    for (int i = 0; i < this.changes.size(); i++) {
      Gap curr = this.changes.get(i);
      line(lt, BTM, z, lt, BTM, curr.z);
      line(rt, BTM, z, rt, BTM, curr.z);
      if      (lt != curr.left) line(lt, BTM, curr.z, curr.left, BTM, curr.z);
      else if (rt != curr.right) line(rt, BTM, curr.z, curr.right, BTM, curr.z);
      lt = curr.left;
      rt = curr.right;
      z = curr.z;
      
      //line(lt, this.bottom, curr.z, lt, this.bottom, next.z);
      //line(rt, this.bottom, curr.z, rt, this.bottom, next.z);
      //if (next.type == 1) {
      //  if (rt == width / 4) {
      //    rt = width / 2;
      //    line(width / 2, this.bottom, next.z, width / 4, this.bottom, next.z);
      //  } else {
      //    lt = lt == -width / 2 ? lt / 2 : lt * 2;
      //    line(-width / 2, this.bottom, next.z, -width / 4, this.bottom, next.z);
      //  }
      //} else {
      //  if (lt == -width / 4) {
      //    lt = -width / 2;
      //    line(-width / 2, this.bottom, next.z, -width / 4, this.bottom, next.z);
      //  } else {
      //    rt = rt == width / 2 ? rt / 2 : rt * 2;
      //    line(width / 2, this.bottom, next.z, width / 4, this.bottom, next.z);
      //  }
      //}
    }
    Gap tail = this.changes.get(this.changes.size() - 1);
    line(tail.left, BTM, tail.z, lt, BTM, FAR);
    line(tail.right, BTM, tail.z, rt, BTM, FAR);
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