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
    //println("-----");
    //println("Tall: " + this.tall);
    //println("Foot: " + this.foot);
    //println("Tilt: " + this.tilt);

    //if (this.handUp) println("Hand up!");
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
  //image(kinect.getColorImage(), 0, 0, width, height);

  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();

  //individual JOINTS
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      
      // update the PVector variables that we already declared
      //handL.x = joints[KinectPV2.JointType_HandLeft].getX();
      //handL.y = joints[KinectPV2.JointType_HandLeft].getY();
      
      //handR.x = joints[KinectPV2.JointType_HandRight].getX();
      //handR.y = joints[KinectPV2.JointType_HandRight].getY();
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


//DRAW BODY
//void drawBody(KJoint[] joints) {
//  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Neck);
//  drawBone(joints, KinectPV2.JointType_Neck, KinectPV2.JointType_SpineShoulder);
//  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_SpineMid);
//  drawBone(joints, KinectPV2.JointType_SpineMid, KinectPV2.JointType_SpineBase);
//  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderRight);
//  drawBone(joints, KinectPV2.JointType_SpineShoulder, KinectPV2.JointType_ShoulderLeft);
//  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipRight);
//  drawBone(joints, KinectPV2.JointType_SpineBase, KinectPV2.JointType_HipLeft);

//  // Right Arm
//  drawBone(joints, KinectPV2.JointType_ShoulderRight, KinectPV2.JointType_ElbowRight);
//  drawBone(joints, KinectPV2.JointType_ElbowRight, KinectPV2.JointType_WristRight);
//  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_HandRight);
//  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandTipRight);
//  drawBone(joints, KinectPV2.JointType_WristRight, KinectPV2.JointType_ThumbRight);

//  // Left Arm
//  drawBone(joints, KinectPV2.JointType_ShoulderLeft, KinectPV2.JointType_ElbowLeft);
//  drawBone(joints, KinectPV2.JointType_ElbowLeft, KinectPV2.JointType_WristLeft);
//  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_HandLeft);
//  drawBone(joints, KinectPV2.JointType_HandLeft, KinectPV2.JointType_HandTipLeft);
//  drawBone(joints, KinectPV2.JointType_WristLeft, KinectPV2.JointType_ThumbLeft);

//  // Right Leg
//  drawBone(joints, KinectPV2.JointType_HipRight, KinectPV2.JointType_KneeRight);
//  drawBone(joints, KinectPV2.JointType_KneeRight, KinectPV2.JointType_AnkleRight);
//  drawBone(joints, KinectPV2.JointType_AnkleRight, KinectPV2.JointType_FootRight);

//  // Left Leg
//  drawBone(joints, KinectPV2.JointType_HipLeft, KinectPV2.JointType_KneeLeft);
//  drawBone(joints, KinectPV2.JointType_KneeLeft, KinectPV2.JointType_AnkleLeft);
//  drawBone(joints, KinectPV2.JointType_AnkleLeft, KinectPV2.JointType_FootLeft);

//  drawJoint(joints, KinectPV2.JointType_HandTipLeft);
//  drawJoint(joints, KinectPV2.JointType_HandTipRight);
//  drawJoint(joints, KinectPV2.JointType_FootLeft);
//  drawJoint(joints, KinectPV2.JointType_FootRight);

//  drawJoint(joints, KinectPV2.JointType_ThumbLeft);
//  drawJoint(joints, KinectPV2.JointType_ThumbRight);

//  drawJoint(joints, KinectPV2.JointType_Head);
//}

////draw joint
//void drawJoint(KJoint[] joints, int jointType) {
//  pushMatrix();
//  translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
//  ellipse(0, 0, 25, 25);
//  popMatrix();
//}

////draw bone
//void drawBone(KJoint[] joints, int jointType1, int jointType2) {
//  pushMatrix();
//  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
//  ellipse(0, 0, 25, 25);
//  popMatrix();
//  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
//}

////draw hand state
//void drawHandState(KJoint joint) {
//  noStroke();
//  handState(joint.getState());
//  pushMatrix();
//  translate(joint.getX(), joint.getY(), joint.getZ());
//  ellipse(0, 0, 70, 70);
//  popMatrix();
//}

///*
//Different hand state
// KinectPV2.HandState_Open
// KinectPV2.HandState_Closed
// KinectPV2.HandState_Lasso
// KinectPV2.HandState_NotTracked
// */
//void handState(int handState) {
//  switch(handState) {
//  case KinectPV2.HandState_Open:
//    fill(0, 255, 0);
//    break;
//  case KinectPV2.HandState_Closed:
//    fill(255, 0, 0);
//    break;
//  case KinectPV2.HandState_Lasso:
//    fill(0, 0, 255);
//    break;
//  case KinectPV2.HandState_NotTracked:
//    fill(255, 255, 255);
//    break;
//  }
//}