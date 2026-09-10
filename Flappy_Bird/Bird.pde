class Bird{
  String image_path1 = "data/flappy bird (pink)/PNG/frame-1.png";
  String image_path2 = "data/flappy bird (pink)/PNG/frame-2.png";
  String image_path3 = "data/flappy bird (pink)/PNG/frame-3.png";
  String image_path4 = "data/flappy bird (pink)/PNG/frame-4.png";
  
  float bird_x = 152;
  float bird_y = 170;
  
  float bird_width = 40;
  float bird_height = 50;
  
  PImage bird1;
  PImage bird2;
  PImage bird3;
  PImage bird4;
  
  int b_switch;
  int min = 205;
  int max = 0;
  
  Bird(int b_switch){
    bird1 = loadImage(image_path1);
    bird2 = loadImage(image_path2);
    bird3 = loadImage(image_path3);
    bird4 = loadImage(image_path4);
    this.b_switch = b_switch;
    imageMode(CENTER);
  }
  
  void birding(){
    if(b_switch == 0){
      image(bird1, bird_x, bird_y, bird_width, bird_height);
    }
    else if(b_switch == 1){
      image(bird2, bird_x, bird_y, bird_width, bird_height);
    }
    else if(b_switch == 2){
      image(bird3, bird_x, bird_y, bird_width, bird_height);
    }
    else if(b_switch == 3){
      image(bird4, bird_x, bird_y, bird_width, bird_height);
    }
  }
  
  void fall(){
    if(bird_y < min){
      bird_y++; 
    }
  }
  
  void fly(){
    if(bird_y > max + 5){
      bird_y -=5;
    }
  }
}
