import java.util.*;

static enum Shape{
  ELLIPSE,
  RECTANGLE,
  TRIANGLE
}

public class ShapesInitializerInstance{

  public void init(){
    if (basicShapes.size() == 0){
      PShape createdShape = null;
  
      createdShape = createShape();
      createdShape.beginShape();
      for (float a = 0; a < TWO_PI; a += 0.1) {
        createdShape.vertex(cos(a)*100, sin(a)*100);
      }
      createdShape.endShape();
      basicShapes.put(Shape.ELLIPSE, createdShape);
      
      createdShape = null;
      
      createdShape = createShape();
      createdShape.beginShape(QUADS);
      createdShape.vertex(0, 0);
      createdShape.vertex(0, 20);
      createdShape.vertex(20, 20);
      createdShape.vertex(20, 0);
      createdShape.endShape();
         
      basicShapes.put(Shape.RECTANGLE, createdShape);
      
      createdShape = null;
    
      createdShape = createShape();
      createdShape.beginShape(TRIANGLES);
      createdShape.vertex(0, 0);
      createdShape.vertex(10, 20);
      createdShape.vertex(20, 0);
      createdShape.endShape();
      
      basicShapes.put(Shape.TRIANGLE, createdShape);
    }
  }
}

public class PGraphical extends Graphical{
  
  PShape myShape;
  color myStrokeColor;
  color myFillColor;
  
  void scale(PVector _relativeScale) {
   relativeScale = _relativeScale;
   //myShape.scale(scale.x * gameObject.transform.scale.x, scale.y * gameObject.transform.scale.y);
 }
  
  void setRotation(float _relativeRotation) {
   relativeAngle = _relativeRotation;
 }
 
 //USE FLY WEIGHT AND SINGLETON
  PShape createBasicShape(Shape shape){
   PShape createdShape = null;
   
   switch (shape){
    case ELLIPSE :
      createdShape = createShape();
      createdShape.beginShape();
      for (float a = 0; a < TWO_PI; a += 0.1) {
        createdShape.vertex(cos(a)*100, sin(a)*100);
      }
      createdShape.endShape();
    return createdShape;
    
    case RECTANGLE :
       createdShape = createShape();
       createdShape.beginShape(QUADS);
       createdShape.vertex(0, 0);
       createdShape.vertex(0, 20);
       createdShape.vertex(20, 20);
       createdShape.vertex(20, 0);
       createdShape.endShape();
    return createdShape;
    
    case TRIANGLE :
    createdShape = createShape();
       createdShape.beginShape(TRIANGLES);
       createdShape.vertex(0, 0);
       createdShape.vertex(10, 20);
       createdShape.vertex(20, 0);
       createdShape.endShape();
    return createdShape;
   }
   
   return null;
   
 }
 
 void setPShape(Shape shape){
  PShape basicShape = basicShapes.get(shape);
  if (basicShape == null)
    basicShape = createBasicShape(shape);
  myShape = basicShape;
  
 }
 
 PGraphical(GameObject _gameObject, PVector _relativeScale, color strokeColor, color fillColor, int _layer, Shape shape, Camera camera) {
   super(_gameObject, PGraphical.class, _layer, camera);
   myStrokeColor = strokeColor;
   myFillColor = fillColor;
   stroke(red(myStrokeColor), green(myStrokeColor), blue(myStrokeColor));
   fill(red(myFillColor), green(myFillColor), blue(myFillColor));
   setPShape(shape);
   relativeScale = new PVector(1, 1);
   relativePos = PVector.zero();
 }
 
 //Display is not relative to the camera
 void display(Camera camera){
   //if (isCulled()){
     shapeMode(CENTER);
     float sx = gameObject.transform.size.x;
     float sy = gameObject.transform.size.y;
    float rx = gameObject.transform.getPosition().x + sx / 2f + camera.getPosition().x;//TEST
    float ry = gameObject.transform.getPosition().y + sy / 2f + camera.getPosition().y;
     pushMatrix();
    // Go to the point around which the shape must rotate
    translate(rx, ry);
    // Rotate the coordinate system
    rotate(gameObject.transform.rotation + relativeAngle);
    pushMatrix();
    // Translate a bit to center the shape on a given point
    translate(0, 0);
    // Draw the shape
    scale(relativeScale);
    shape(myShape, 0, 0, sx, sy);
    popMatrix();
   //}
 }
  
}
