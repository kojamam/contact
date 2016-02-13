import com.leapmotion.leap.Controller;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.Frame;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.Tool;
import com.leapmotion.leap.Vector;
import com.leapmotion.leap.processing.*;


Controller controller = new Controller();
LeapMotion leapMotion;
int updown = -1; //-1 => DOWM, 1=>up

void setup()
{
  size(720,  1280);
  background(20);

  leapMotion = new LeapMotion(this);
}


void draw()
{
  fill(20);
  rect(0, 0, width, height);
}



void onFrame(final Controller controller)
{
  Frame frame = controller.frame();
  int i = 0;
  if (!frame.hands().isEmpty()) {
    for (Hand hand : frame.hands()) {
      Vector pos = (Vector) hand.palmPosition();
      Vector velocity = hand.palmVelocity();
      float velocityY = velocity.get(1);
      float posY = pos.get(1);
      //   System.out.println(pos);

      if(i == 0){
        if(updown == -1 && velocityY > 0){//極小
          updown = 1;
          System.out.println("min");
        }
        if(updown == 1 && velocityY < 0){//極大
          updown = -1;
          System.out.println("max");
        }
      }
      println(hand.grabStrength());
    }
  }
  // println(frame.hands().get(0).grabStrength());
}
