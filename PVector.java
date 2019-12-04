import java.util.Random;

class PVector {
  
  float x;
  float y;
  
  static PVector zero(){ return new PVector(0, 0); } 
  
  public static PVector rotateVector(float _rad, PVector _direction){
    PVector direction = _direction.get();

    double cs = Math.cos(_rad);
    double sn = Math.sin(_rad);
    
    double px = direction.x * cs - direction.y * sn; 
    double py = direction.x * sn + direction.y * cs;
    
    return new PVector((float)px, (float)py);
  }
  
  public float dot(PVector v) {
   return (this.x * v.x + this.y * v.y);
  }

  public float dot(float vx, float vy) {
   return (this.x * vx + this.y * vy);
  }

  public static float dot(PVector v1, PVector v2) {
   return v1.x * v2.x + v1.y * v2.y;
  }

  
  void equals(int x, int y){
   this.x = x;
   this.y = y;
  }
  
  void equals(float x, float y){
   this.x = x;
   this.y = y;
  }
  
  void equals(PVector v){
   this.x = v.x;
   this.y = v.y;
  }
  
  PVector (float x_, float y_) {
    this.x = x_;
    this.y = y_;
  }
  
  PVector (PVector v) {
    this.x = v.x;
    this.y = v.y;
  }
  
  void add (PVector v) {
    this.y += v.y;
    this.x += v.x;
  }
  
  void sub (PVector v) {
    this.y -= v.y;
    this.x -= v.x;
  }
  
  void mult (float n) {
    this.x *= n;
    this.y *= n;
  }
  
  void div (float n) {
    this.x /= n;
    this.y /= n;
  }
  
  float mag() {
    return (float)Math.sqrt(x*x + y*y);
  }
  
  float sqrMag() {
    return (float)(x*x + y*y);
  }
  
  void normalize() {
    float m = mag();
    
    if (m != 0) {
      div (m);
    }
  }
  
   static PVector normalize(PVector vector) {
    PVector v = vector.get();
    float m = v.mag();
    
    if (m != 0) {
      v.div (m);
    }
    return v;
  }
  
 static PVector getIntersectionPoint(PVector center1, float radius1, PVector center2, float radius2){
   /// Trouver le point de collision
    /// sans trigo
    float collisionPointX =
        ((center1.x * radius2) + (center2.x * radius1))
        / (radius1 + radius2);
    
    float collisionPointY =
        ((center1.y * radius2) + (center2.y * radius1))
        / (radius1 + radius2);

    return new PVector(collisionPointX, collisionPointY);
    
} 
  
  static PVector getIntersectionPoint(PVector segmentStart, PVector segmentEnd, PVector center, float radius){
  /// get length of the line
  float len = PVector.distance(segmentStart, segmentEnd);
  float cx = center.x;
  float cy = center.y;
  
  float x1 = segmentStart.x;
  float y1 = segmentStart.y;
  float x2 = segmentEnd.x;
  float y2 = segmentEnd.y;
  
  /// get dot product of the line and circle
  float dot = ( ((cx-x1)*(x2-x1)) + ((cy-y1)*(y2-y1)) ) / (float)Math.pow(len,2);

  /// find the closest point on the line
  float closestX = x1 + (dot * (x2-x1));
  float closestY = y1 + (dot * (y2-y1));

  /// get distance to closest point

  float distance = PVector.distance(new PVector(closestX, closestY), center);

  if (distance <= radius) {
    return new PVector(closestX, closestY);
  }
  return null; 
    
  }
  
   static float distance(PVector vector1, PVector vector2) {
    float distX = vector1.x - vector2.x;
    
    float distY = vector1.y - vector2.y;
    
    float distance = (float)Math.sqrt( (distX*distX) + (distY*distY) );
    
    return distance;
  }
  
  /// Limiter la magnitude d'un vecteur
  void limit (float max) {
    if (this.sqrMag() > max * max) {
      this.normalize();
      this.mult (max);
    }
  }
  
  void toZero() {
    this.x = 0;
    this.y = 0;
  }
  
  PVector get () {
    PVector copy = new PVector (this.x, this.y);
    
    return copy;
  }
  
  static PVector add (PVector v1, PVector v2) {
    PVector v3 = new PVector (v1.x + v2.x, v1.y + v2.y);
    return v3;
  }
  
  static PVector sub (PVector v1, PVector v2) {
    PVector v3 = new PVector (v1.x - v2.x, v1.y - v2.y);
    return v3;
  }
  
  static PVector mult (PVector v, float m) {
    return new PVector (v.x * m, v.y * m);
  }
  
  static PVector div (PVector v, float d) {
    if ( d != 0)
      return new PVector (v.x / d, v.y / d);
    else
      return null;
  }
  
  static PVector random2D () {
    Random rnd = new Random();
    
    PVector result = new PVector (rnd.nextInt(100), rnd.nextInt(100));
    
    result.normalize();
    return result;
    
  }
  
  public String toString() {
     return "(" + x + ", " + y + ")";
  }
  
}
