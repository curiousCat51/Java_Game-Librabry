class Screens {
  void GAME_OVER() {
    drawCenteredMessage("GAME OVER");
  }

  void VICTORY() {
    drawCenteredMessage("VICTORY!");
  }

  void PAUSE() {
    drawCenteredMessage("PAUSE");
  }

  void drawCenteredMessage(String title) {
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(48);
    text(title, width * 0.5f, height * 0.5f - 30);
    textSize(24);
    text("Score: " + score, width * 0.5f, height * 0.5f + 30);
  }
}
