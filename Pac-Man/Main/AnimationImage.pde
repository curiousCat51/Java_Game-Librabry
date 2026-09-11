class AnimationImage implements ImageContainer{
  PImage[] images;
  float animation_speed;
  float animation_progress = 0;
  int image_numbers;
  
  AnimationImage(String path_prefix, int image_numbers, float animation_speed){
    images = new PImage[image_numbers];
    for(int i = 0; i < image_numbers; i++){
     int image_number = i + 1; 
     images[i] = loadImage(path_prefix + image_number + ".png");
    }
    
    this.image_numbers = image_numbers;
    this.animation_speed = animation_speed;
  }
  
  void drawImage(float x, float y){
    animation_progress += animation_speed;
    int image_number = (int) animation_progress;
    
    if(image_number >= image_numbers){
      animation_progress = 0; 
      image_number = 0;
    }
    
    image(images[image_number], x, y, images[image_number].width * SCALE, images[image_number].height * SCALE);
  }  
}
