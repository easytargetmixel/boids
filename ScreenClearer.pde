class ScreenClearer {

  color color_;
  int alpha;

  ScreenClearer(final color color_, final int alpha) {
    this.color_ = color_;
    this.alpha = alpha;
  }

  void perform() {
    noStroke();
    fill(getColorWithAlpha());
    rect(0f, 0f, width, height);
  }

  color getColorWithAlpha() {
    return (color_ & 0xFFFFFF) | (alpha << 24);
  }
}
