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
float min = 0;
float max = 10000;
float amplitude;

void setup()
{
  size(720,  1280);
  background(20);

  controller = new Controller();
  leapMotion = new LeapMotion(this);
  timeQueue = new TimeQueue();

  ac = new AudioContext();
  try{
    sp = new SamplePlayer(ac, new Sample(sketchPath("") +"What Makes You Beautiful.mp3"));
    rateValue = new Glide(ac, 1.0);
    sp.setRate(rateValue);
    rateValue = new Glide(ac, 1.0);
    sp.setPitch(rateValue);
    sp.setValue(2);
    sp.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
    sp.start();
    gainValue= new Glide(ac, 0.8, 30);
    sampleGain = new Gain(ac, 1, gainValue);
    sampleGain.addInput(sp);
    ac.out.addInput(sampleGain);
    ac.start();
  }catch(Exception e){
    println("Error");
  }

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
          float strength = hand.grabStrength();

          if(handId++ == 0){//BPM判定に使うのは片手だけ

            if(updown == -1 && velocityY > 0){//極小
              min = posY;
              amplitude = Math.abs(max - min);
              if(amplitude > 15){//小さすぎる振幅は無視
                updown = 1;
                bpm = timeQueue.push(System.currentTimeMillis());
                changeRate(bpm);
                // System.out.println("MINIMAL");
              }
            }
            println(strength);
            if(updown == 1 && velocityY < 0){//極大
              max = posY;
              amplitude = Math.abs(max - min);
              if(amplitude > 15){
                updown = -1;
                bpm = timeQueue.push(System.currentTimeMillis());
              }
            }

            System.out.println("BPM: " + bpm + ", Amplitude: " + amplitude);

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
