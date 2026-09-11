class WorldObject{
  float pixel_x;
  float pixel_y;
  WorldTypes type;
  ImageContainer image_container;
  
  WorldObject(WorldTypes type, float grid_x, float grid_y){
    this.type = type;
    this.pixel_x = convertToPixel(grid_x);
    this.pixel_y = convertToPixel(grid_y);
  }
  
  void setImageContainer(ImageContainer container){
    this.image_container = container;
  }
  
  void drawObject(){
    image_container.drawImage(pixel_x, pixel_y);
  }
  
  float convertToPixel(float position){
    return position * TILE_SIZE + (TILE_SIZE / 2);
  }
  
  float convertToGrid(float position){
    return Math.round((position - (TILE_SIZE / 2)) / TILE_SIZE);
  }
  
  float getPixelX(){
    return pixel_x;
  }
  
  float getPixelY(){
    return pixel_y;
  }
  
  WorldTypes getType(){
    return type;
  }
}
