abstract class TileCollider implements IGraphic, ICollidable {

  Tile tile;
  float xSize;
  float ySize;
  ColliderType colliderType;
  Map<Camera, Integer> cameras = new HashMap();//Camera, Layer
  boolean isCulled;
  String tag = "";
  
  abstract void display(Camera camera);

  TileCollider(Tile _tile, int _xSize, int _ySize) {
    GameEngine.addToColliderList(this);
    tile = _tile;
    xSize = _xSize;
    ySize = _ySize;
  }
  
  PhysicsBody getPhysicsBody() { return null; }
  
  HashMap<ICollidable, PVector> getCollidedWith() { return null; }
  void resolveCollision(ICollidable against){}
  
  public void setTag(String _tag){ tag = _tag; }
  public String getTag() { return tag; }
  boolean hasMoved() { return false; }
  boolean isSolid(){ return true; }
  float getRestitutionCoeff() { return tile.restitutionCoeff; }
  PVector getVelocity() { return new PVector(0, 0); }
  void setVelocity(PVector _velocity){}
  void setCollided(boolean hasCollided){}
  boolean hasCollided() { return false; }
  float getMass(){ return 1; }
  
  
  public void attachCamera(Camera camera, int layer) {
    cameras.put(camera, layer);
  }

  public void addToGraphicsList(Camera camera, int layer) {
    attachCamera(camera, layer);
    setLayer(camera, layer);
    camera.addToGraphicsList(this, layer);
  }

  public void removeFromGraphicsList(Camera camera, int layer) {
    camera.removeFromGraphicsList(this, cameras.get(camera));
  }

  public void setLayer(Camera camera, int _layer) {
    camera.removeFromGraphicsList(this, cameras.get(camera));
    Integer layer = cameras.get(camera);
    layer = _layer;
    camera.addToGraphicsList(this, cameras.get(camera));
  }

  public boolean isCulled() {
    return isCulled;
  }
  
  void addCollidedWith(ICollidable collider, CollisionInfo collisionInfo){}
  
  public ColliderType getColliderType(){
   return colliderType; 
  }

  public void toggleColliderDisplay(Camera camera, int layer, boolean toggleOn) {
    if (toggleOn)
      addToGraphicsList(camera, layer);
    else
      removeFromGraphicsList(camera, layer);
  }
  
  void setNormal(PVector collisionPoint){}
  PVector getNormal(){ return null; }
  public void manageCollider(){}
  
  public void checkCulling(Camera camera) {
    PVector currentPos = tile.startPosition.get();
    currentPos.add(camera.getPosition());
    PVector currentSize = new PVector(xSize, ySize);
    isCulled = camera.isInFrame(currentPos, currentSize, camera.getPosition());
  }

}
