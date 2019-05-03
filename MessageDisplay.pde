class MessageDisplay {

  private int maxMessageTimerSeconds = 3;
  private int messageTimer = 0;
  private String messageText = "";

  void showMessage(final String messageText) {
    this.messageText = messageText;
    messageTimer = (int) frameRate * maxMessageTimerSeconds;
  }
  
  void showMessage(final String prefixText, final boolean onOffValue) {
    showMessage(prefixText + on(onOffValue));
  }

  private void draw_() {
    if (messageTimer-- <= 0) {
      return;
    }

    fill((min(30f, messageTimer) / 30f) * 255f);
    text(messageText, 10f, height - 20f);
  }

  private String s(final int count) {
    return (count != 1) ? "s" : "";
  }

  private String on(final boolean in) {
    return in ? "on" : "off";
  }

  private void drawText (String s, float x, float y) {
    fill(0);
    text(s, x, y);
    fill(200);
    text(s, x-1, y-1);
  }
}
