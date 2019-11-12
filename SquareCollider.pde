class SquareCollider extends Collider{
  
  float xSize;
  float ySize;
  
  PVector getSize(){ return new PVector(xSize, ySize); }
  CollisionInfo currentCollisionInfo = new CollisionInfo();
  
  void display(Camera camera){


      stroke (0);
      fill (xSize, xSize, xSize, 255);
      shapeMode(CORNER);
      PShape t = createShape();
      t.beginShape();
      t.vertex(0, ySize * gameObject.transform.scale.y);
      t.vertex(xSize * gameObject.transform.scale.x, ySize * gameObject.transform.scale.y);
      t.vertex(xSize * gameObject.transform.scale.x, 0);
      t.vertex(0, 0);
      t.endShape();
      shape(t, relativePosition.x + gameObject.transform.getPosition().x - camera.getPosition().x, relativePosition.y + gameObject.transform.getPosition().y - camera.getPosition().y);
      if (currentCollisionInfo != null && currentCollisionInfo.collisionPoint != null){
        circle(PVector.sub(currentCollisionInfo.collisionPoint, camera.getPosition()).x, PVector.sub(currentCollisionInfo.collisionPoint, camera.getPosition()).y, 25);
      }
 }
  

  SquareCollider(GameObject _gameObject, boolean _isSolid){
    super(_gameObject, _isSolid);
    xSize = gameObject.transform.size.x;
    ySize = gameObject.transform.size.y;

    colliderType = ColliderType.SQUARE;
    //colliders.add(this);
  }

  PVector[] getVertices(){
    PVector pos = getPosition();
    PVector size = getSize();
    PVector[] vertices = new PVector[4];
    vertices[0] = pos;
    vertices[1] = new PVector(pos.x, pos.y + size.y);
    vertices[2] = new PVector(pos.x + size.x, pos.y + size.y);
    vertices[3] = new PVector(pos.x + size.x, pos.y);
        
    return vertices;
  }
  
  public void setSize(PVector _size){
    xSize = _size.x;
    ySize = _size.y;
  }
  
  
  
  /*public PVector getPosition(){
   PVector position = gameObject.transform.getPosition();
   position.add(relativePosition);
   return position;
  }*/
  
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
  
  void manageCollision(ICollidable against){//NEEDS TO BE UPDATE TO USE THE COLLIDER'S SIZE AND POS VALUES
     if (against.getColliderType() == ColliderType.SQUARE){
      
      CollisionInfo collisionInfo = CollisionHelper.squareSquareCollision(this, against);
      
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
     
      CollisionInfo collisionInfo = CollisionHelper.squareCircleCollision(against, this);
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
        isHit = true;
        
        against.setCollided(true);
        currentCollisionInfo.collisionPoint = collisionInfo.collisionPoint;
        currentCollisionInfo.surfaceNormal = collisionInfo.surfaceNormal;
        //println(currentCollisionInfo.surfaceNormal);
        GameEngine.addCollision(this, against, collisionInfo);
        collidedWith.put(against, collisionInfo);
      }

      return;
   }
    
   return;

  
 }

}
