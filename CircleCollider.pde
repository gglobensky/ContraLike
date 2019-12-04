class CircleCollider extends Collider{
  
  float radius;
  CollisionInfo currentCollisionInfo = new CollisionInfo();
  
  CircleCollider(GameObject _gameObject, float _radius, boolean _isSolid){
    super(_gameObject, _isSolid);
    colliderType = ColliderType.CIRCLE;
    radius = _radius;
  }
  
  PVector[] getVertices(){
   PVector[] vertices = new PVector[(int)Math.ceil(TWO_PI / 0.1f)];
   
   int count = 0;
   for (float a = 0; a < TWO_PI; a += 0.1) {
     vertices[count++] = new PVector(cos(a) * radius, sin(a) * radius);
   } 
   return vertices;
  }
  
  PVector getSize() { return new PVector(radius * 2, radius * 2); }
  
  void resolveCollision(ICollidable other){
    if (isSolid && physicsBody != null){
      if (other.isSolid()){
        if (other.getPhysicsBody() != null){    
          physicsBody.elasticCollision(other, GameEngine.getCollisionInfo(this, other));
        }
        else{
          physicsBody.worldCollision(other, GameEngine.getCollisionInfo(this, other));
        }
      }
    }
  }
  
  public void setSize(PVector _size){
    radius = _size.x;
  }
  
  
  void manageCollision(ICollidable against){

     PVector center = gameObject.transform.getPosition();
     center.add(new PVector(radius, radius));
     
     if (against.getColliderType() == ColliderType.SQUARE){
      CollisionInfo collisionInfo = CollisionHelper.squareCircleCollision(this, against);
      
      if (collisionInfo != null){
        if (against.isSolid())
          collidedAgainstSolid = true;
        isHit = true;
        against.setCollided(true);
        currentCollisionInfo.collisionPoint = collisionInfo.collisionPoint;
        currentCollisionInfo.surfaceNormal = collisionInfo.surfaceNormal;

        GameEngine.addCollision(this, against, collisionInfo);
        collidedWith.put(against, collisionInfo);
        against.addCollidedWith(this, collisionInfo);
       
      }
      return;
   } else if (against.getColliderType() == ColliderType.CIRCLE){
     
      CollisionInfo collisionInfo = CollisionHelper.circleCircleCollision(this, against);
      if (collisionInfo != null){
        if (against.isSolid())
          collidedAgainstSolid = true;
        isHit = true;
        
        against.setCollided(true);
        currentCollisionInfo.collisionPoint = collisionInfo.collisionPoint;
        currentCollisionInfo.surfaceNormal = collisionInfo.surfaceNormal;

        GameEngine.addCollision(this, against, collisionInfo);
        collidedWith.put(against, collisionInfo);
        against.addCollidedWith(this, collisionInfo);
      }

      return;
   } else if (against.getColliderType() == ColliderType.TRIANGLE){
      PVector position = getPosition();
      
      CollisionInfo collisionInfo = CollisionHelper.getPolyCircleIntersection(against, this);
      if (collisionInfo != null){
        if (against.isSolid())
          collidedAgainstSolid = true;
        isHit = true;
        
        against.setCollided(true);
        currentCollisionInfo.collisionPoint = collisionInfo.collisionPoint;
        currentCollisionInfo.surfaceNormal = collisionInfo.surfaceNormal;
        GameEngine.addCollision(this, against, collisionInfo);
        collidedWith.put(against, collisionInfo);
        against.addCollidedWith(this, collisionInfo);
      }

      return;
   }
    
   return;
 }
 
 void display(Camera camera){
    
    PVector viewPos = PVector.add(gameObject.transform.getPosition(), new PVector(radius, radius));
    viewPos.sub(camera.getPosition());
    fill(255);
    circle(viewPos.x, viewPos.y, radius * 2);
    if (currentCollisionInfo != null && currentCollisionInfo.collisionPoint != null)
      circle(PVector.sub(currentCollisionInfo.collisionPoint, camera.getPosition()).x, PVector.sub(currentCollisionInfo.collisionPoint, camera.getPosition()).y, radius);
 }
 
}
