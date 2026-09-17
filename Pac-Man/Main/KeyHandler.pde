class KeyHandler{
  boolean key_UP;
  boolean key_DOWN;
  boolean key_LEFT;
  boolean key_RIGHT;
  
  KeyHandler(){
    key_UP = false;
    key_DOWN = false;
    key_LEFT = false;
    key_RIGHT = false;
  }
  
  void Pressed(){
    if(keyCode == UP){
      key_UP = true;
    }
    if(keyCode == DOWN){
      key_DOWN = true;
    }
    if(keyCode == LEFT){
      key_LEFT = true;
    }
    if(keyCode == RIGHT){
      key_RIGHT = true;
    }
  }
  
  void Released(){
    if(keyCode == UP){
      key_UP = false;
    }
    if(keyCode == DOWN){
      key_DOWN = false;
    }
    if(keyCode == LEFT){
      key_LEFT = false;
    }
    if(keyCode == RIGHT){
      key_RIGHT = false;
    }
  }
  
  boolean getKeyUP(){return key_UP;}
  boolean getKeyDOWN(){return key_DOWN;}
  boolean getKeyLEFT(){return key_LEFT;}
  boolean getKeyRIGHT(){return key_RIGHT;}

}
