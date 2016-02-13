Ball[] ballOf = new Ball[31];

float bpm=120;
float bps;
int count=0;
//int trans;
int rotate;
PImage ballImg;
float speed=1.0;


void setup() {
  size(1280, 720);
  frameRate(35);
  ballImg = loadImage("ball.png");
  imageMode(CENTER);
  for (int h=0; h<=30; h++) {
    ballOf[h] = new Ball(100, floor(random(0, 360)), 640, 640, floor(random(0, 255)), 100, 100);
  }
}

void draw() {
  
  translate(640, 360);
  background(255);
  rotate += 0;
  //trans += 10;

  ellipse(0, 0, 100, 100);

  if (count==0) {
    for (int i=1; i<=4; i++) {
      ballOf[i] = new Ball(100, floor(random(0, 360)), 0, 0, floor(random(0, 255)), 100, 100);count++;
    }
  } else if (count==15) {

    for (int i=5; i<=8; i++) {
      ballOf[i] = new Ball(100, floor(random(0, 360)), 0, 0, floor(random(0, 255)), 100, 100);count++;
    }
  } else if (count==30) {

    for (int i=9; i<=12; i++) {
      ballOf[i] = new Ball(100, floor(random(0, 360)), 0, 0, floor(random(0, 255)), 100, 100);count++;
    }
  } else if (count==45) {
    for (int i=13; i<=16; i++) {
      ballOf[i] = new Ball(100, floor(random(0, 360)), 0, 0, floor(random(0, 255)), 100, 100);count++;
    }
  } else if (count>=59) {for (int i=17; i<=20; i++) {
      count=0;
    }
    
  }  else{count++;}
  for (int i=0; i<=30; i++) {


    ballOf[i].ballMove(speed);
  }
  
  println(count);
}


class Ball {
  int ballScale;
  int ballTranslate;
  int ballRotate;
  int ballX;
  int ballY;
  int ballH;
  int ballS;
  int ballB;
  int trans;

  Ball(int Sc, int Ro, int ballx, int bally, int H, int S, int B)
  {
    ballScale=Sc;
    ballRotate=Ro; //回転角
    ballX=ballx;
    ballY=bally;
    ballH=H;
    ballS=S;
    ballB=B;
  }



  void ballMove(float ballSpeed) {
    //ここから時計  
    trans+=10*ballSpeed;
    pushMatrix();

    noFill();
    strokeWeight(4);
    stroke(ballH, ballS, ballB);
    rotate(radians(ballRotate));
    translate(trans*ballScale/50, trans*ballScale/50);
    image(ballImg, 0, 0, ballScale*trans/50, ballScale*trans/50);





    popMatrix();

    //ここまで時計
  }
}