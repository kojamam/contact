startTimer();
var startTime; //timer

//Audio
var TARGET = document.getElementById('sound');
function play(){
  TARGET.play();
}
function pause(){
  TARGET.pause();
}
function go(seconds){
  TARGET.currentTime = seconds;
}
function skip(seconds){
  TARGET.currentTime += seconds;
}
function reset(){
  TARGET.pause();
  TARGET.currentTime = 0;
  TARGET.playbackRate = 1;
}
function mute(){
  if(TARGET.muted){
    TARGET.muted = false;
  }else{
    TARGET.muted = true;
  }
}
function ratechange(Num){
  // play()後反映、1が通常、0が停止
  TARGET.play();
  TARGET.playbackRate = Num;
}
function rateup(Num){
  TARGET.play();
  TARGET.playbackRate += Num;
}
function ratedown(Num){
  TARGET.play();
  TARGET.playbackRate -= Num;
}
function volume(Num){
  TARGET.volume = Num;
}


//キューの実装 移動平均につかう
function Queue(Num) {
	this.data = [];
	this.num = Num;	//保有するデータの数
}
Queue.prototype.push = function (val) {
	if (this.data.length >= this.num) {
		this.pop();
	}
	this.data.push(val);
  return val;
}
Queue.prototype.pop = function () {
  return this.data.shift();
}
Queue.prototype.front = function () {
  return this.data[0];
}
Queue.prototype.size = function () {
  return this.data.length;
}
Queue.prototype.empty = function () {
  return this.data.length == 0;
}
Queue.prototype.average = function () {
	var average = 0;
	var length = this.data.length;
	for (var i = 0; i < length; i++) {
		average += this.data[i];
	}
	average /= length;
  return average;
}

// Leap Motionの処理
Leap.loop({enableGestures: true}, function(frame){
	// フレーム毎の処理
	var q = new Queue(1);	//最大サイズ30のキュー
  startTime = new Date();
	if(frame.hands.length > 0) {
    var hand = frame.hands[0];
    var position = hand.palmPosition;
    var velocity = hand.palmVelocity;
    var direction = hand.direction;
    velocityY = parseInt(velocity[1]);

    //    q.push(velocityY);
    // if(velocityY < 0) {
    // 	velocityY = -velocityY;
    // }
    //    if (velocityY < 15) {
    //    	q.push(0);
    //    } else {
    //    	q.push(velocityY);
    //    }
    //    ratechange(q.average()/300);
  }
});

function getTime() {
  var currentTime = new Date();
  return currentTime - startTime;
}
