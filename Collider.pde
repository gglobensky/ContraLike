interface ICollidable<T>{
  void manageCollision(ICollidable against);
  PVector getPosition();
  PVector getSize();
  void manageCollider();
  void toggleColliderDisplay(Camera camera, int layer, boolean toggleOn);
  ColliderType getColliderType();
  boolean isSolid();
  PVector getVelocity();
  void setVelocity(PVector _velocity);
  float getMass();
  String getTag();
  void setTag(String _tag);
  HashMap<ICollidable, CollisionInfo> getCollidedWith();
  void addCollidedWith(ICollidable collider, CollisionInfo collisionInfo);
  void setCollided(boolean hasCollided);
  boolean hasCollided();
  void resolveCollision(ICollidable against);
  PVector[] getVertices();
  boolean hasMoved();
  PhysicsBody getPhysicsBody();
  float getRestitutionCoeff();//0 to 1
}

public enum ColliderType { SQUARE, CIRCLE, TRIANGLE, POINT, LINE, POLYGON };

abstract class Collider extends Component implements IGraphic, ICollidable{
  boolean isHit = false;
  boolean collidedAgainstSolid = false;
  boolean isSolid;
  boolean hasMoved = true;
  ColliderType colliderType;
  Map<Camera, Integer> cameras = new HashMap();//Camera, Layer
  boolean isCulled;
  PVector relativePosition = PVector.zero();
  PVector movementBuffer = PVector.zero();
  PhysicsBody physicsBody;
  float restitutionCoeff = 0.1f;
  HashMap<ICollidable, CollisionInfo> collidedWith = new HashMap();
  
  public void attachCamera(Camera camera, int layer){
   //if (cameras.get(camera) != null)
    cameras.put(camera, layer);
  }
  
  public void addToGraphicsList(Camera camera, int layer){
      attachCamera(camera, layer);
      setLayer(camera, layer);
      camera.addToGraphicsList(this, layer);
  }
  
  public void setTag(String _tag){
    gameObject.tag = _tag;
  }
  public String getTag() { return gameObject.tag; }
  float getRestitutionCoeff() { return restitutionCoeff; }
  float getMass() { return physicsBody != null? physicsBody.mass : 1; }
  PVector getVelocity() { return physicsBody != null? physicsBody.getVelocity() : PVector.zero(); }
  void setVelocity(PVector _velocity){ if (physicsBody != null) physicsBody.velocity = _velocity; }
  
  void addPhysicsBody(PhysicsBody pb){
    physicsBody = pb;
    //print(pb);
  }
  
  PhysicsBody getPhysicsBody(){
   return physicsBody; 
  }
  
  boolean isSolid(){ return isSolid; }
  HashMap<ICollidable, CollisionInfo> getCollidedWith(){ return collidedWith; }
  
  public PVector getPosition(){
   PVector position = gameObject.transform.getPosition();
   position.add(relativePosition);
   return position;
  }
  
  public void removeFromGraphicsList(Camera camera, int layer){
      camera.removeFromGraphicsList(this, cameras.get(camera));
  }
  
  public void setLayer(Camera camera, int _layer){
    camera.removeFromGraphicsList(this, cameras.get(camera));
    Integer layer = cameras.get(camera);
    layer = _layer;
    camera.addToGraphicsList(this, cameras.get(camera));
  }
  
  void addCollidedWith(ICollidable collider, CollisionInfo collisionInfo){
    collidedWith.put(collider, collisionInfo);
  }
  
  void setCollided(boolean hasCollided){ if (physicsBody != null) physicsBody.hasCollided = hasCollided; }
  boolean hasCollided(){ return isHit; }
  
   public boolean isCulled(){
    return isCulled; 
   }
  
   public void toggleColliderDisplay(Camera camera, int layer, boolean toggleOn){
     if (toggleOn)
       addToGraphicsList(camera, layer);
     else
       removeFromGraphicsList(camera, layer);
   }
    
   public void checkCulling(Camera camera){
     PVector currentPos = gameObject.transform.getPosition();
     currentPos.add(camera.getPosition());
     PVector currentSize = gameObject.transform.size.get();
     isCulled = camera.isInFrame(currentPos, currentSize, camera.getPosition());
   }

  Collider(GameObject _gameObject, boolean _isSolid){
    super(_gameObject, Collider.class);
    GameEngine.addToColliderList(this);
    //colliders.add(this);
    isSolid = _isSolid;
    //addToLists();
  }
   
  void onDestroy(){

  }
 
  public ColliderType getColliderType(){
   return colliderType; 
  }
  
  abstract void setSize(PVector _size);
  
  boolean hasMoved(){ return hasMoved; }
  
  void manageCollider(){
     isHit = false;
     collidedAgainstSolid = false;
     PVector currentPosition = getPosition();
     collidedWith.clear();
     PVector diff = PVector.sub(movementBuffer, currentPosition);
     if (!(diff.x == 0 && diff.y == 0) || physicsBody != null){
       hasMoved = true;
     }
     else{
       hasMoved = false;
     }
     movementBuffer = currentPosition;
  }
  
  
}
