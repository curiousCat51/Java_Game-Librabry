ArrayList<Ground> Gd;
ArrayList<Background> Bd;
ArrayList<Spike> Se;
ArrayList<Bird> B;

// Speed of the game
float speed = 1;

// Time between 1. spike and 2. spike
float time = 150;
float timer = 150;

// Number of spikes
float spike_count = 0;
float spike_max = 5;

// Player points
int points = 0;

// Distance between the upper and lower spike parts
float distance = 100;

// Number of the current bird image
int b_state = 1;
int b_state_count = 1;

// Key input detect
boolean kSpace = false;


int counter = 0;


void setup(){
  Se = new ArrayList<Spike>();
  Bd = new ArrayList<Background>();
  Bd.add(new Background(0));
  Bd.add(new Background(320));
  Gd = new ArrayList<Ground>();
  Gd.add(new Ground(0));
  Gd.add(new Ground(128));
  Gd.add(new Ground(256));
  Gd.add(new Ground(384));
  Gd.add(new Ground(512));
  Gd.add(new Ground(640));
  B = new ArrayList<Bird>();
  B.add(new Bird(0));
  B.add(new Bird(1));
  B.add(new Bird(2));
  B.add(new Bird(3));
  size(640, 304); 
}

void draw(){
  background(0);
  
  Frame();
  
  ScoreBoard();
  
  background(0);
  
  Frame();
  
  ScoreBoard();
  
  delay(20);
}

void keyPressed(){
  if(keyCode == ' '){
    kSpace = true;
  }
}

void keyReleased(){
  if(keyCode == ' '){
    kSpace = false;
  }
}

void BackgroundMove(){
  for(int i = 0; i < Bd.size(); i++){
    Background b = Bd.get(i);
    b.drawing();
    b.act();
  }
}

void GroundMove(){
  for(int i = 0; i < Gd.size(); i++){
    Ground g = Gd.get(i);
    g.grounding();
    g.act();
  }
}

void SpikeAdd(){
  if(spike_count <= spike_max && time == timer){
    Se.add(new Spike(distance));
    spike_count++;
    timer = 0;
  }
}

void SpikeMoveAndRemove(){
  for(int i = 0; i < Se.size(); i++){
    Spike s = Se.get(i);
    s.spiking();
    s.act();
    if(s.getX() <= -11){
      Se.remove(i);
      spike_count--;
      // points++;
    }
    
    if(points == 10){
      speed = 2;
    }
    if(points == 20){
      time = 100;
    }
    if(points == 30){
      spike_max = 10;
    }
    if(points == 40){
      distance = (100 - (distance / 5));
    }
    if(points == 50){
      distance = (100 - (distance / 2));
    }
  }
}

void TimeAndTimer(){
  if(timer < time){
    timer++;
  }
  
  
  if(timer > time){
    Se.add(new Spike(distance));
    spike_count++;
    timer = 0;
  }
}

void BirdState(){
  if(b_state_count == 1){
    if(b_state <= 2){
      b_state++;
    }
    else{
      b_state = 1;
    }
    b_state_count++;
  }
  else if(b_state_count == 2){
    b_state_count++;
  }
  else{
    b_state_count = 1;
  }
}

void BirdAction(){
  if(kSpace){
    B.get(b_state).fly();
    counter++;
  }
  else{
    B.get(b_state).fall();
  }
}

void ScoreBoard(){
  text("Punkte: " + points, 550, 20);
  text("Klicks: " + counter, 550, 40);
}

void Frame(){
  BackgroundMove();
  
  GroundMove();
  
  SpikeAdd();
  
  TimeAndTimer();
  
  SpikeMoveAndRemove();
  
  B.get(b_state).birding();
  BirdAction();
}
