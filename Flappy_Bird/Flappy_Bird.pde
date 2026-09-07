ArrayList<Ground> Gd;
ArrayList<Background> Bd;
ArrayList<Spike> Se;

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
  size(640, 304); 
}

void draw(){
  background(173, 216, 250);
  
  if(spike_count <= spike_max && time == timer){
    Se.add(new Spike(distance));
    spike_count++;
    timer = 0;
  }
  
  if(timer < time){
    timer++;
  }
  
  for(int i = 0; i < Bd.size(); i++){
    Background b = Bd.get(i);
    b.drawing();
    b.act();
  }
  
  for(int i = 0; i < Gd.size(); i++){
    Ground g = Gd.get(i);
    g.grounding();
    g.act();
  }
  
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
  
  if(timer > time){
    Se.add(new Spike(distance));
    spike_count++;
    timer = 0;
  }
  
  text("Points: " + points, 550, 20);
}
