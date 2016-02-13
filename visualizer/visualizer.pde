import com.leapmotion.leap.Controller;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Frame;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.Tool;
import com.leapmotion.leap.Vector;
import com.leapmotion.leap.processing.*;

Controller controller;
LeapMotion leapMotion;
TimeQueue timeQueue;
int updown = -1; //-1 => DOWM, 1=>up
long bpm = 240;
float min = 0;
float max = 10000;
float amplitude;
float rightX, rightY, leftX, leftY;

Ball[] ballOf = new Ball[31];

float bps;
int count=0;
//int trans;
int rotate;
PImage ballImg;
PImage backImg;
float speed=1.0;
float colorval;
PImage maruImg;
int time;


void setup() {
  colorMode(HSB);
  size(1280, 720);
  frameRate(35);
  ballImg = loadImage("ball.png");
  backImg = loadImage("back.png");
  maruImg = loadImage("maru.png");
  imageMode(CENTER);
  colorval=255-bpm;
  for (int h=0; h<=30; h++) {
    ballOf[h] = new Ball(100, floor(random(0, 360)), 640, 640, floor(random(colorval+30, colorval-30)), 200, 200);
  }

    controller = new Controller();
    leapMotion = new LeapMotion(this);
    timeQueue = new TimeQueue();
}

void draw() {
  speed=bpm/108;
  if (bpm<=255&&bpm>=0) {
    colorval=255-bpm;
  }

  pushMatrix();
  for (int i = 0; i < height/4; i++)
  {
    int c = 255*i/height;
    stroke(colorval+c, 200, 100);
    strokeWeight(4);
    line(0, i*4, width, i*4);
  }

  popMatrix();

  translate(640, 360);
  noStroke();




  tint(colorval-30, 200, 200);
  image(backImg, 0, 0, 1280, 720);
  rotate += 0;
  //trans += 10;

  tint(colorval-30, 255, 255);
  image(maruImg, rightX + 400, -rightY+300 + 100, 200, 200);
  image(maruImg, leftX - 400, -leftY+300 + 100, 200, 200);

  time=floor(15/speed);

  if (count==0) {
    for (int i=1; i<=4; i++) {
      ballOf[i] = new Ball(100, floor(random(0, 360)), 0, 0, random(colorval-30, colorval+30), 200, 200);
      count++;
    }
  } else if (count==time) {

    for (int i=5; i<=8; i++) {
      ballOf[i] = new Ball(100, floor(random(0, 360)), 0, 0, random(colorval-30, colorval+30), 200, 200);
      count++;
    }
  } else if (count==time*2) {

    for (int i=9; i<=12; i++) {
      ballOf[i] = new Ball(100, floor(random(0, 360)), 0, 0, random(colorval-30, colorval+30), 200, 200);
      count++;
    }
  } else if (count==time*3) {
    for (int i=13; i<=16; i++) {
      ballOf[i] = new Ball(100, floor(random(0, 360)), 0, 0, random(colorval-30, colorval+30), 200, 200);
      count++;
    }
  } else if (count>=time*4) {
    for (int i=17; i<=20; i++) {
      count=0;
    }
  } else {
    count++;
  }
  for (int i=0; i<=30; i++) {


    ballOf[i].ballMove(speed);
  }
  //print(floor(random(colorval+30, colorval-30)));
  //print("    ");
  //println(count);
}


class Ball {
  int ballScale;
  int ballTranslate;
  int ballRotate;
  int ballX;
  int ballY;
  float ballH;
  int ballS;
  int ballB;
  int trans;

  Ball(int Sc, int Ro, int ballx, int bally, float H, int S, int B)
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
    tint(ballH, ballS, ballB, 185);
    image(ballImg, 0, 0, ballScale*trans/50, ballScale*trans/50);






    popMatrix();

    //ここまで時計
  }
}


void onFrame(final Controller controller)
{
    Frame frame = controller.frame();
    int handId = 0;
    if (!frame.hands().isEmpty())
    {
        for (Hand hand : frame.hands())
        {
            Vector pos = (Vector) hand.palmPosition();
            Vector stabilizedPos = hand.stabilizedPalmPosition();
            Vector velocity = hand.palmVelocity();
            float velocityY = velocity.get(1);
            float posY = pos.get(1);
            
           
            if(hand.isRight()){
              rightX = stabilizedPos.get(0);
              rightY = stabilizedPos.get(1);
            }else{
              leftX = stabilizedPos.get(0);
              leftY = stabilizedPos.get(1);
            }
            System.out.println(stabilizedPos);

            if(handId++ == 0){//BPM判定に使うのは片手だけ

                if(updown == -1 && velocityY > 0){//極小
                    min = posY;
                    amplitude = Math.abs(max - min);
                    if(amplitude > 15){//小さすぎる振幅は無視
                        updown = 1;
                        bpm = timeQueue.push(System.currentTimeMillis());
                        //changeRate(bpm);
                    }
                }

                if(updown == 1 && velocityY < 0){//極大
                    max = posY;
                    amplitude = Math.abs(max - min);
                    if(amplitude > 15){
                        updown = -1;
                        bpm = timeQueue.push(System.currentTimeMillis());
                        //changeRate(bpm);

                    }
                }

                //System.out.println("BPM: " + bpm + ", Amplitude: " + amplitude);

            }
        }
    }

}



class TimeQueue{
    long time[] =  new long[3];

    public long push(long val) {
        for(int i = 2; i > 0; i--){
            this.time[i] = this.time[i-1];
        }
        this.time[0] = val;
        return this.calcBPM();
    }

    private long calcBPM(){
        return 60000 / (this.time[0] - this.time[2]); 
    }
}