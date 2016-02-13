import com.leapmotion.leap.Controller;
import com.leapmotion.leap.processing.LeapMotion;
import com.leapmotion.leap.Frame;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.HandList;
import com.leapmotion.leap.Vector;




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
  if (frame.hands().count() > 0) {
      Hand hand = frame.hand(0);
      Vector pos = hand.palmPosition();
      Vector velocity = hand.palmVelocity();
      float velocityY = velocity.get(1);
      float posY = pos.get(1);
      


      if(velocityY > 0 && updown == -1){
          updown = 1;
        //   timeMax = new Date();
      }else if(velocityY < 0 && updown == 1){
          updown = -1;
    //       timeMin = new Date();
      }



  }

}