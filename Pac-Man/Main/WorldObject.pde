class WorldObject{
  float pixel_x;
  float pixel_y;
  int grid_x;
  int grid_y;
  WorldTypes type;
  ImageContainer image_container;
  
  WorldObject(WorldTypes type, int grid_x, int grid_y){
    this.type = type;
    this.grid_x = grid_x;
    this.grid_y = grid_y;
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
  
  int getGridX(){return grid_x;}
  int getGridY(){return grid_y;}
  
  void setGridX(int grid_x){this.grid_x = grid_x;}
  void setGridY(int grid_y){this.grid_y = grid_y;}
  
  void setPixelX(float pixel_x){this.pixel_x = pixel_x;}
  void setPixelY(float pixel_y){this.pixel_y = pixel_y;}
  
  int[] getPosition(){
    return new int[]{getGridX(), getGridY()};
  }
  
  void setPosition(int grid_x, int grid_y){
   setGridX(grid_x);
   setPixelX(convertToPixel(grid_x));
   setGridY(grid_y);
   setPixelY(convertToPixel(grid_y));
  }
}
