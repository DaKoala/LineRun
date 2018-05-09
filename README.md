# LineRun
![Processing](https://img.shields.io/badge/Processing-V3.3.6-lightgrey.svg)
![Kinect](https://img.shields.io/badge/Kinect-V2-red.svg)
![OS](https://img.shields.io/badge/OS-Windows-blue.svg)
![license](https://img.shields.io/badge/license-GPL%20v3.0-green.svg)

![logo](https://s1.ax1x.com/2018/05/08/CdrglF.png)

**An endless running game based on Kinect V2**

This project is the final project for the course [Kinetic Interfaces](http://ima.nyu.sh/kinetic-interfaces/) I take this semester and is collaborated with Echo Qu(yq534), who is responsible for the artwork part.

Players should move their bodies to avoid different obstacles in this endless run.

## Installation

### Download

```bash
git clone https://github.com/DaKoala/LineRun.git
```

### Dependencies
**You can only run this game on Windows computers**
* Kinect SDK
* Processing
    + Kinect V2 for Processing
    + Minim
* Kinect V2 connected to the computer

## User Guild

### Start

Run `LineRun.pde` to start.

### Interface Description

![start](https://s1.ax1x.com/2018/05/08/Cd2otA.png)

You can learn different kinds of obstacles here before start. If you are ready, raise either of your hands.

![game](https://s1.ax1x.com/2018/05/08/Cd2Ikd.png)

Try your best to avoid obstacles and collect awards!

![end](https://s1.ax1x.com/2018/05/08/Cd24TH.png)

You can see the score you get in this game and the highest score record. If you want to play again, raise either of your hands.

### Obstacles / Awards

You can change your body direction by tilting your body to left/right. There are totally three directions(left, middle, right). If stand in the middle you will bump obstacles/awards on both sides.

![diamond](https://s1.ax1x.com/2018/05/08/CdDd56.png)

This is the only award in this game. You need to tilt your body to collect it. Sometimes it is high, so you need to put your hands up.

![block](https://s1.ax1x.com/2018/05/08/CdDUV1.png)

You need to tilt your body to avoid it.

![thron](https://s1.ax1x.com/2018/05/08/CdDtbR.png)

You need to jump when you see it. Make sure you do not land before bumping into it.

![thron_top](https://s1.ax1x.com/2018/05/08/CdDJKJ.png)

You need to squat before bumping into it.

![gap](https://s1.ax1x.com/2018/05/08/CdDYr9.png)

You need to lift up the foot corresponding to the side it appears.

## Demo

Please click the image below to view the Demo on Youtube.

[![thumbnail](https://s1.ax1x.com/2018/05/08/Cd2Ikd.png)](https://youtu.be/kWc6uvsxn84)

## Credit

### Libraries

* [Minim](http://code.compartmental.net/tools/minim/)
* [Kinect V2 for Processing](https://github.com/ThomasLengeling/KinectPV2)

### Musics

* Beginning 2(Minecraft Game Music) - C418
* Stay Inside Me(Game Version) - Various Artists

### Special Thanks

Special thanks to my instructor J.H Moon for the supporting in the course.

## License

GPL v3.0