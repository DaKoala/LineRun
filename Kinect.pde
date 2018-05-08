import KinectPV2.KJoint;
import KinectPV2.*;

class Listener {
  float tall, wid;
  float headX, headY;
  float baseX, baseY;
  ArrayList<Float> pbottomY;
  float bottomY;
  float leftFootY, rightFootY;
  float leftHandY, rightHandY;
  float leftShoulderX, rightShoulderX;
  int foot;
  int tilt;
  boolean handUp;
  boolean squad;
  boolean jump;
  
  Listener() {
    this.tall = 0;
    this.wid = 0;
    this.baseX = 0;
    this.baseY = 0;
    this.headX = 0;
    this.headY = 0;
    this.pbottomY = new ArrayList<Float>();
    for (int i = 0; i < 5; i++) {
      pbottomY.add(0.0);
    }
    this.bottomY = 0;
    this.leftFootY = 0;
    this.rightFootY = 0;
    this.leftHandY = 0;
    this.rightHandY = 0;
    this.leftShoulderX = 0;
    this.rightShoulderX = 0;
    this.foot = 0;
    this.tilt = 0;
    this.handUp = false;
    this.squad = false;
  }
  
  void update() {
    float upBody = this.baseY - this.headY;
    float downBody = (this.leftFootY > this.rightFootY ? this.leftFootY : this.rightFootY) - this.baseY;
    this.tall = upBody * 2;
    this.wid = this.rightShoulderX - this.leftShoulderX;
    this.bottomY = this.leftFootY > this.rightFootY ? this.leftFootY : this.rightFootY;
    
    if (this.leftFootY - this.rightFootY > this.tall * 0.05) this.foot = 1;
    else if (this.leftFootY - this.rightFootY < -this.tall * 0.05) this.foot = -1;
    else this.foot = 0;
    
    if (this.headX - this.baseX < -this.wid * 0.15) this.tilt = -1;
    else if (this.headX - this.baseX > this.wid * 0.15) this.tilt = 1;
    else this.tilt = 0;
    
    if (this.leftHandY < this.headY || this.rightHandY < this.headY) this.handUp = true;
    else this.handUp = false;
    
    if (upBody > downBody * 1.2) this.squad = true;
    else this.squad = false;
    
    if (this.pbottomY.get(0) - this.bottomY > this.tall * 0.05 && !this.squad) this.jump = true;
    else this.jump = false;
    this.pbottomY.remove(0);
    this.pbottomY.add(this.bottomY);
  }
  
  void test() {
    println("-----");
    println("Tall: " + this.tall);
    println("Foot: " + this.foot);
    println("Tilt: " + this.tilt);
    if (this.handUp) println("Hand up!");
    if (this.jump) println("Jump!");
    if (this.squad) println("Squad!");
  }
}

KinectPV2 kinect;
Listener listener;

void setupKinect() {
  kinect = new KinectPV2(this);

  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);

  kinect.init();
  
  listener = new Listener();
}


void updateKinect() {
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      listener.baseX = joints[KinectPV2.JointType_SpineBase].getX();
      listener.baseY = joints[KinectPV2.JointType_SpineBase].getY();
      listener.headX = joints[KinectPV2.JointType_Head].getX();
      listener.headY = joints[KinectPV2.JointType_Head].getY();
      listener.leftFootY = joints[KinectPV2.JointType_FootLeft].getY();
      listener.rightFootY = joints[KinectPV2.JointType_FootRight].getY();
      listener.leftHandY = joints[KinectPV2.JointType_HandLeft].getY();
      listener.rightHandY = joints[KinectPV2.JointType_HandRight].getY();
      listener.leftShoulderX = joints[KinectPV2.JointType_ShoulderLeft].getX();
      listener.rightShoulderX = joints[KinectPV2.JointType_ShoulderRight].getX();
    }
  }
}