class Ground{
  String image_path = "data/background/ground/Ground&Stone/Ground/ground8.png";
  float pos_x;
  
  PImage ground1;
  PImage ground2;
  
  float ground1_x = 0;
  float ground2_x = width;
  
  float ground_y = 286;
  
  Ground(float pos_x){
    ground1 = loadImage(image_path);
    ground2 = loadImage(image_path);
    this.pos_x = pos_x;
  }
  
  void grounding(){
    image(ground1, ground1_x + pos_x, ground_y);
    image(ground2, ground2_x + pos_x, ground_y);
  }
  void act(){
     ground1_x -= speed;
     ground2_x -= speed;
     
     if(ground1_x < -width){
       ground1_x = width;
     }
     
     if(ground2_x < -width){
       ground2_x = width;
     }
  }
}
