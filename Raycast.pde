class Raycast implements IGraphic{
   PVector origin;
   PVector direction;
   boolean isCulled;
   Map<Camera, Integer> cameras = new HashMap();//Camera, Layer
   
   public Raycast(PVector _origin, PVector _direction){
     origin = _origin;
     direction = _direction;
   }
   
   boolean raycastHit(){
     int len = GameEngine.colliderObjects.size();
     boolean result = false;
     PVector lineEnd = origin.get();
     lineEnd.add(direction);

     for (int i = 0; i < len; i++){
     
     ICollidable against = GameEngine.colliderObjects.get(i);    
     PVector againstPos = against.getPosition();
     PVector againstSize = against.getSize();
     
     boolean xEndInside = false;
     boolean xOriginInside = (origin.x >= againstPos.x && origin.x < againstPos.x + againstSize.x);
     //if (!xOriginInside)
       xEndInside = (lineEnd.x >= againstPos.x && lineEnd.x < againstPos.x + againstSize.x);

     boolean yEndInside = false;
     boolean yOriginInside = (origin.y >= againstPos.y && origin.y < againstPos.y + againstSize.y);
     //if (!yOriginInside)
       yEndInside = (lineEnd.y >= againstPos.y && lineEnd.y < againstPos.y + againstSize.y);
     
     
     boolean xThrough = (origin.x <= againstPos.x && lineEnd.x >= againstPos.x + againstSize.x);
     boolean yThrough = (origin.y <= againstPos.y && lineEnd.y >= againstPos.y + againstSize.y);
     
     //WILL HAVE TO TEST THOROUGHLY IF OPTIMISATION WORKS...
     
     if ((xOriginInside && (yOriginInside || yEndInside || yThrough)) || (xEndInside && (yOriginInside || yEndInside || yThrough)) || 
     (yOriginInside && (xOriginInside || xEndInside || xThrough)) || (yEndInside && (xOriginInside || xEndInside || xThrough))
     || (xThrough && yThrough) || (xOriginInside && xEndInside) || (yOriginInside && yEndInside)){
       if (against.getColliderType() == ColliderType.SQUARE){
          PVector[] vertex = { againstPos, new PVector(againstPos.x, againstPos.y + againstSize.y), 
                              new PVector(againstPos.x + againstSize.x, againstPos.y + againstSize.y), 
                              new PVector(againstPos.x + againstSize.x, againstPos.y) };
                              
         result = CollisionHelper.pointRect(origin, againstPos, againstSize);
         if (!result)
           result = CollisionHelper.pointRect(lineEnd, againstPos, againstSize);
         if (!result)
           result = CollisionHelper.linePolyCollision(origin, lineEnd, vertex);
         
       } else if (against.getColliderType() == ColliderType.CIRCLE){
         
         PVector againstCenter = against.getPosition();
         float againstRadius = against.getSize().x / 2f;
         
         againstCenter.add(new PVector(againstRadius, againstRadius));
         
         result = CollisionHelper.lineCircle(origin.x, origin.y, lineEnd.x, lineEnd.y, againstCenter.x, againstCenter.y , againstRadius);
         
       }
       if (result)
         return result;
    }
   }
    return false;
  }
  
  public void removeFromGraphicsList(Camera camera, int layer){
    camera.removeFromGraphicsList(this, cameras.get(camera));
  }
  
  public void addToGraphicsList(Camera camera, int layer){
    attachCamera(camera, layer);
    setLayer(camera, layer);
    camera.addToGraphicsList(this, layer);
  }
  
  void display(Camera camera){
    PVector viewStart = origin.get();
    PVector viewEnd = PVector.add(viewStart, direction);
     /* stroke (0);
      //fill (xSize, xSize, xSize, 255);
      shapeMode(CORNER);
      PShape t = createShape();
      t.beginShape();
      t.vertex(0, 0);
      t.vertex(direction.x, direction.y);
      t.endShape();
      shape(t, viewStart.x - camera.getPosition().x, viewStart.y - camera.getPosition().y);*/

    line(viewStart.x - camera.getPosition().x, viewStart.y - camera.getPosition().y, viewEnd.x - camera.getPosition().x, viewEnd.y - camera.getPosition().y);
 }
 
 public boolean isCulled(){
    return isCulled; 
 }
  
     
 public void checkCulling(Camera camera){
   PVector startPos;
   PVector endPos;
   PVector lineEnd = origin.get();
   lineEnd.add(direction);
   
   if (origin.x > lineEnd.x){
     startPos = lineEnd.get();
     endPos = origin.get();
   }
   else{
     startPos = origin.get();
     endPos = lineEnd.get(); 
   }
   
   startPos.add(camera.getPosition());
   PVector currentSize = endPos;
   currentSize.sub(startPos);
   
   isCulled = camera.isInFrame(startPos, currentSize, camera.getPosition());
 }
  
  public void attachCamera(Camera camera, int layer){
   //if (cameras.get(camera) != null)
    cameras.put(camera, layer);
  }
  
  public void setLayer(Camera camera, int _layer){
    camera.removeFromGraphicsList(this, cameras.get(camera));
    Integer layer = cameras.get(camera);
    layer = _layer;
    camera.addToGraphicsList(this, cameras.get(camera));
  }
  
  public void toggleRaycastDisplay(Camera camera, int layer, boolean toggleOn){
   if (toggleOn)
     addToGraphicsList(camera, layer);
   else
     removeFromGraphicsList(camera, layer);
   }
  
}
