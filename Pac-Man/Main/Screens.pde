class Screens{
  
  int size_pauseB = 5;
  
  Screens(){
    
  }
  
  // Game Over screen
  void GAME_OVER(){
    background(200);
    fill(255, 50, 90);
    textSize(32);
    textAlign(CENTER);
    text("Game Over", 512, 512);
    textSize(16);
    text("High Score: " + score, 512, 538);
  }
  
  // Pause screen
  void PAUSE(){
    
  }
}
