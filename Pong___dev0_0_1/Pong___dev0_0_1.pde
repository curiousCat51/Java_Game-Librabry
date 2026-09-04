float spieler1_x;
float spieler1_y;
float spieler2_x;
float spieler2_y;
float ball_x;
float ball_y;
float ball_geschwindigkeit_x;
float ball_geschwindigkeit_y;

int punkte1 = 0;
int punkte2 = 0;

boolean keyW = false;
boolean keyS = false;
boolean keyUP = false;
boolean keyDOWN = false;

void setup(){
  spieler1_x = 20;
  spieler1_y = 250;
  spieler2_x = 780;
  spieler2_y = 250;
  ball_x = 400;
  ball_y = 300;
  ball_geschwindigkeit_x = -4;
  ball_geschwindigkeit_y = 0;
  size(800, 600);
  rectMode(CENTER);
}
void draw(){
  background(0);
  rect(spieler1_x, spieler1_y, 20, 100);
  rect(spieler2_x, spieler2_y, 20, 100);
  rect(ball_x, ball_y, 10, 10);
  if(keyS){
    if(spieler1_y < 550){
      spieler1_y += 6;
    }
  }
  if(keyW){
    if(spieler1_y > 50){
      spieler1_y -= 6;
    }
  }
  if(keyDOWN){
    if(spieler2_y < 550){
      spieler2_y += 6;
    }
  }
  if(keyUP){
    if(spieler2_y > 50){
      spieler2_y -= 6;
    }
  }
  
  ball_x = ball_x + ball_geschwindigkeit_x;
  ball_y = ball_y + ball_geschwindigkeit_y;
  
  if(ball_x < 30){
      if(ball_y < (spieler1_y + 55) && ball_y > (spieler1_y - 55)){
        ball_geschwindigkeit_x = (-ball_geschwindigkeit_x) + 1;
        ball_geschwindigkeit_y = ball_geschwindigkeit_y - (spieler1_y - ball_y) * 0.1;
      }
      else{
        punkte2 = punkte2 + 1;
        ball_x = 400;
        ball_y = 300;
        ball_geschwindigkeit_x = -4;
        ball_geschwindigkeit_y = 0;
      }
  }
  
  if(ball_x > 770){
    if(ball_y < (spieler2_y + 55) && ball_y > (spieler2_y - 55)){
      ball_geschwindigkeit_x = (-ball_geschwindigkeit_x) + 1;
      ball_geschwindigkeit_y = ball_geschwindigkeit_y - (spieler2_y - ball_y) * 0.1;
    }
    else{
      punkte1 = punkte1 + 1;
      ball_x = 400;
      ball_y = 300;
      ball_geschwindigkeit_x = -4;
      ball_geschwindigkeit_y = 0;
    }
  }
  
  
  if(ball_y > 595 || ball_y < 5){
    ball_geschwindigkeit_y = -ball_geschwindigkeit_y;
  }
  
  text(punkte1 + " : " + punkte2, 400, 20);
  //text("Ball Position X: " + ball_x + "\nBall Position Y: " + ball_y, 600, 500);
}

void keyPressed(){
  if(key == 'w' || key == 'W') keyW = true;
  if(key == 's' || key == 'S') keyS = true;
  if(keyCode == UP) keyUP = true;
  if(keyCode == DOWN) keyDOWN = true;
}

void keyReleased(){
  if(key == 'w' || key == 'W') keyW = false;
  if(key == 's' || key == 'S') keyS = false;
  if(keyCode == UP) keyUP = false;
  if(keyCode == DOWN) keyDOWN = false;
}
