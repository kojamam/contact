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
long bpm = 0;

void setup()
{
  size(720,  1280);
  background(20);

  controller = new Controller();
  leapMotion = new LeapMotion(this);
  timeQueue = new TimeQueue();

}


void draw()
{
  fill(20);
  rect(0, 0, width, height);
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
          Vector velocity = hand.palmVelocity();
          float velocityY = velocity.get(1);
          float posY = pos.get(1);
        //   System.out.println(pos);

          if(handId++ == 0){
              if(updown == -1 && velocityY > 0){//極小
                  updown = 1;
                  bpm = timeQueue.push(System.currentTimeMillis());
                  System.out.println(bpm);
              }

              if(updown == 1 && velocityY < 0){//極大
                  updown = -1;
                  bpm = timeQueue.push(System.currentTimeMillis());
                  System.out.println(bpm);
              }

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
