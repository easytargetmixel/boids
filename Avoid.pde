class Avoid {
   private PVector position;
   
   Avoid (final PVector position) {
     this.position = position;
   }
   
   PVector getPosition() {
     return position;
   }
   
   float getX() {
     return position.x;
   }
   
   float getY() {
     return position.y;
   }
}
