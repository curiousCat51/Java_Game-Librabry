class Background{
 String image_path = "/data/background/tilesetOpenGameBackground.png";
 int pos_x;
 
 PImage background1;
 PImage background2;
 
  float background1_x = 0;
  float background2_x = width;
  
  float background_width = 320;
  float background_height = 256;
  float background_y = background_height%2;
  float range = 10;
 
 Background(int pos_x){
   background1 = loadImage(image_path);
   background2 = loadImage(image_path);
   this.pos_x = pos_x;
 }
 
 void drawing(){
   image(background1, background1_x + pos_x, background_y, background_width, background_height);
   image(background2, background2_x + pos_x, background_y, background_width, background_height);
 }
 
 void act(){
     background1_x -= speed;
     background2_x -= speed;
     
     if(background1_x <= -width + range){
       background1_x = width;
     }
     
     if(background2_x <= -width + range){
       background2_x = width;
     }
  }
}
