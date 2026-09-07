// Gap between spikes gets smaller over time
// Time between appearance of new spikes gets shorter over time

class Spike{
  String image_path = "data/spikes/transparent PNG/spike D.png";  
  
  PImage top_spike;
  PImage bottom_spike;
  
  // Spike spawn
  float spike_x = 640;
  
  float s_height;
  
  // Sum spikes + distance between the spikes
  float height_sum = 256;
  
  // The distance between the spikes
  float s_distance = distance;
  
   Spike(float distance){
    top_spike = loadImage(image_path);
    bottom_spike = loadImage(image_path);
    s_distance = distance;
    // Spike size
    s_height= generateSize();
   }
   
   float getX(){
     return spike_x;
   }
   
   float getSpikeDistance(){
     return s_distance;
   }
   
   void setSpikeDistance(float s_distance){
     this.s_distance = s_distance;
   }
   
   float getHeight(){
     return s_height;
   }
   
   void spiking(){
     pushMatrix();
     scale(1, -1);
     image(top_spike, spike_x, -s_height, 20, s_height); // background 256 - 2 * height 100 = 56
     popMatrix();
     
     pushMatrix();
     scale(1, 1);
     image(bottom_spike, spike_x, s_height + s_distance, 20, calcHeight());
     popMatrix();
   }
  // Spikes move to the left
  void act(){
    if(spike_x >= -11){
      spike_x -= speed;
    }
  }
  
  // Calculates the size of the bottom spike
  float calcHeight(){
    float calced_Height = height_sum - (s_height + s_distance);
    return calced_Height;
  }
  
  // Generates a size for the top spike
  int generateSize(){
    int size = int(random(40, (height_sum - s_distance) + 1));
    return size;
  }
}
