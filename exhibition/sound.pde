import beads.*;
import org.jaudiolibs.beads.*;

float current_rate=1.0;
float current_vol=1.0;
float musicbpm = 99.05;

AudioContext ac;
SamplePlayer sp;
Gain sampleGain;
Glide rateValue;
Glide gainValue;
//void setup(){
//  size(500, 500);
//  ac = new AudioContext();
//  try{
//    sp = new SamplePlayer(ac, new Sample(sketchPath("") +"What Makes You Beautiful.mp3"));
//    rateValue = new Glide(ac, 1.0);
//    sp.setRate(rateValue);
//    rateValue = new Glide(ac, 1.0);
//    sp.setPitch(rateValue);
//    sp.setValue(2);
//    sp.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
//    sp.start();
//    gainValue= new Glide(ac, 0.8, 30);
//    sampleGain = new Gain(ac, 1, gainValue);
//    sampleGain.addInput(sp);
//    ac.out.addInput(sampleGain);
//    ac.start();
//  }catch(Exception e){
//    println("Error");
//  }

//}
//void draw(){
//  if(keyPressed == true) {
//    if(key == 'a') {
//       changePitch(0.02);
//    } else if (key == 'd') {
//       changePitch(-0.02);
//    } else if (key == 'w') {
//       changeRate(0.02);
//    } else if (key == 's') {
//       changeRate(-0.02);
//    } else if (key == 'q') {
//       startMusic();
//    } else if (key == 'e') {
//       stopMusic();
//    }
//  }
//}

void changePitch(float bpm) {
  float rate=0;
  rate = bpm/musicbpm;
  current_rate = rate;
  rateValue = new Glide(ac, current_rate);
  sp.setPitch(rateValue);
}

void changeRate(long bpm) {
  float rate=0;
  rate = bpm/musicbpm;
  current_rate = rate;
  rateValue = new Glide(ac, current_rate);
  sp.setRate(rateValue);
}

//void changePitch(float rate) {
//  current_rate += rate;
//  rateValue = new Glide(ac, current_rate);
//  sp.setPitch(rateValue);
//}

//void changeRate(float rate) {
//  current_rate += rate;
//  rateValue = new Glide(ac, current_rate);
//  sp.setRate(rateValue);
//}

void changeVolume(float volume) {
  gainValue= new Glide(ac, volume, 30);
  sampleGain = new Gain(ac, 1, gainValue);
  sampleGain.addInput(sp);
  ac.out.addInput(sampleGain);
}

void stopMusic() {
  //if(current_vol>0) {
  // current_vol-=0.01;
  // if(current_vol<0) {
  //    current_vol=0;
  //    ac.stop();
  // }
  //}
  //changeVolume(current_vol);
  ac.stop();
}

void startMusic() {
  current_vol=1;
  changeVolume(current_vol);
  ac.start();
}