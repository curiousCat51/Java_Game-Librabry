class AnimationImage implements ImageContainer{
  
  PImage[] images;
  String[] imagePaths;
  
  float animation_speed;
  float animation_progress = 0;
  int image_numbers;
  boolean end = false;
  
  AnimationImage(String pathPrefix, int imageNumbers, float animationSpeed){
    
    image_numbers = imageNumbers;
    animation_speed = animationSpeed;
    images = new PImage[imageNumbers];
    imagePaths = new String[imageNumbers];
    
    for(int i = 0; i < imageNumbers; i++){
      
      imagePaths[i] = pathPrefix + (i + 1);
      images[i] = imageCache.load(imagePaths[i]);
    }
  }
  
  void drawImage(float x, float y){
   
    int frame = constrain(round(animation_progress), 0, image_numbers - 1);
    PImage renderImage = imageCache.getRescaled(imagePaths[frame], images[frame]);
    image(renderImage, x, y);
    updateAnimation();
  }
  
  void updateAnimation(){
    
    if(!end){
      
      animation_progress += animation_speed;
      
      if(animation_progress >= image_numbers - 1){
        animation_progress = image_numbers - 1;
        end = true;
      }
    }
  }
  
  // Setze die Animation für einen neuen Bewegungsablauf zurück.
  void resetAnimation(){
    end = false;
    animation_progress = 0;
  }
  
  float getProgress() {return animation_progress;}
}
