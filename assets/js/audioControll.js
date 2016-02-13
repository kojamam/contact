//Audio
var TARGET = document.getElementById('sound');

var musicBPM = 125;

function play(){
    TARGET.play();
}
function pause(){
    TARGET.pause();
}

function changeRate(Num){
    // play()後反映、1が通常、0が停止
    TARGET.play();
    TARGET.playbackRate = Num;
}
function volume(Num){
  TARGET.volume = Num;
}

//キューの実装 移動平均につかう
function Queue(capacity) {
    this.data = [];
    this.capacity = capacity;	//保有するデータの数
}
Queue.prototype.push = function (val) {
    if (this.data.length >= this.capacity) {
        this.pop();
    }
    this.data.push(val);
    console.log(this.data);
    return val;
};
Queue.prototype.pop = function () {
    return this.data.shift();
};
Queue.prototype.front = function () {
    return this.data[0];
};
Queue.prototype.size = function () {
    return this.data.length;
};
Queue.prototype.empty = function () {
    return this.data.length === 0;
};
Queue.prototype.average = function () {
    var average = 0;
    var length = this.data.length;
    for (var i = 0; i < length; i++) {
        average += this.data[i];
    }
    average /= length;
    return average;
};
Queue.prototype.calcBPM = function(){
    bpm =  parseInt(60000 / (this.data[this.data.length-1] - this.data[0]));
    return bpm;
};
Queue.prototype.calcRate = function (bpm) {  //制限関数
    var max = 3;
    var min = 0.5;  //Rateは0.5が最小値、それ以下は無音になってしまう
    this.calcBPM();
    var rate = bpm/musicBPM;       // musicBPMに対するrate
    if (rate > max) {
        return max;
    } else if (rate < min) {
        return min;
    } else {
        return rate;
    }
};
Queue.prototype.diff30 = function(){
    return Math.abs(this.data[this.data.length-1] - this.data[0]);
};


var q = new Queue(3); //最大サイズ3のキュー 極大極小の時間が格納されてる
var bpmQ = new Queue(3); //サイズ3のキュー bpmの平均取る
// var posYQ = new Queue(30);

// Leap Motionの処理

var updown = -1; //-1 => DOWM, 1=>up
var min = 0;
var max = 10000;
var amplitude; //振幅

// var controller = new Leap.Controller();

Leap.loop({enableGestures: true}, function(frame){
    // フレーム毎の処理
    var handId = 0;
    var hands = frame.hands;
    for(handId = 0; handId < hands.length; handId++) {//手を一個ずつ処理
        var hand = frame.hands[handId];

        var pos = hand.palmPosition;
        var posY = pos[1];
        var velocity = hand.palmVelocity;
        var velocityY = parseInt(velocity[1]);
        var grabStrength = hand.grabStrength;

        if(handId === 0){ //一個目の時だけBPMに関連する

            // posYQ.push(posY);


            if(updown == -1 && velocityY > 0){//極小
                min = posY;
                amplitude = Math.abs(max - min);
                if(amplitude > 15){//小さすぎる振幅は無視
                    updown = 1;
                    update();
                    stopCount = 0;
                }else{
                    stopCount++;
                }
            }else if(updown == 1 && velocityY < 0){//極大
                max = posY;
                amplitude = Math.abs(max - min);
                if(amplitude > 15){
                    updown = -1;
                    update();
                    stopCount = 0;
                }else{
                    stopCount++;
                }
            }

            // console.log(controller.frame(10));
            // if(posYQ.diff30 < 10){
            //     pause();
            // }

        }
    }
});

function update(){
    q.push(new Date());
    bpm = q.calcBPM();
    bpmQ.push(bpm);
    averageBpm = bpmQ.average();
    rate = q.calcRate(averageBpm);
    if(!isNaN(rate)){ changeRate(rate);}
    var volumeValue = amplitude/100 * 0.5;
    volume(volumeValue < 1 ? volumeValue : 1);
    // console.log(averageBpm);

}
