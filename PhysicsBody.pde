interface PhysicsObserver{
  void update();
  boolean isHit();
}

class PhysicsBody extends Component implements PhysicsObserver{
  boolean isStable = false;
  private PVector velocity;
  PVector frameVelocity = PVector.zero();
  PVector allowedPos = PVector.zero();
  float angularVelocity;
  float angularAcceleration;
  PVector acceleration;
  Collider collider;
  float topSpeed = 1000f;
  float mass;
  float surfaceArea;
  boolean reboundOnScreenEdges = false;
  boolean elasticCollided = false;
  boolean applyGravity = true;
  boolean hasCollided = false;
  
  PhysicsBody (GameObject _gameObject) {
    super(_gameObject, PhysicsBody.class);
    GameEngine.addToPhysicsList(this);
    this.velocity = new PVector (0, 0);
    this.acceleration = new PVector (0, 0);
    surfaceArea = 1;
    this.mass = 1;
    collider = gameObject.getComponent(Collider.class);
    if (collider == null){
      print("\nPhysicsBody does not possess a collider!\n");
    }
    else{
      collider.addPhysicsBody(this);
    }
  }  
  
  void onDestroy(){}

  boolean isHit(){ if (collider != null) return collider.hasCollided(); else return false; }
  PVector getVelocity(){ return velocity.get(); }
  
  void setVelocity(float x, float y){
    velocity.x = x;
    velocity.y = y;
  }
  
  void update () {
    if (elasticCollided){
      velocity = frameVelocity.get();
      velocity.div(collisionCount);
    }
    else{
      frameVelocity.mult(0);     
      collisionCount = 0;
    }
    applyGravity();
    velocity.add (acceleration);
    PVector position = gameObject.transform.getPosition();
    position.add (velocity);
    gameObject.transform.setPosition(position);
    
    acceleration.mult (0);
    
    angularVelocity += angularAcceleration;
    
    float angularDragCoeff = Helper.ensureRange(1 - (1 / ((mass * 100f / surfaceArea))), 0, 0.9975f);

    angularVelocity = ((angularVelocity * 1000f) * angularDragCoeff) / 1000f;
    
    if (angularVelocity < 0.001f)
      angularVelocity = 0;
    
    gameObject.transform.rotateOnAxis(angularVelocity);

    angularAcceleration = 0.0;

    velocity.x = Helper.ensureRange(velocity.x, -topSpeed, topSpeed);
    velocity.y = Helper.ensureRange(velocity.y, -topSpeed, topSpeed);
  
    if (!collider.collidedAgainstSolid)
      elasticCollided = false;

  }

  void applyGravity(){
    PVector gravity = PVector.zero();
    isStable = false;
    
   if (applyGravity)
     gravity = new PVector (0, GameEngine.gravityForce * mass);

       if (collider != null && collider.collidedAgainstSolid){
         gameObject.transform.setPosition(allowedPos);
         PVector t = velocity.get();
         t.mult(-1);
         
         if (t.sqrMag() > 0.1f){
           applyForce(t);
           //Will have to test if applyForce(gravity) causes problem with complex collisions
           //applyForce(gravity);
         }
         else{
           isStable = true;
         }
       }else if (!collider.collidedAgainstSolid){
         applyForce(gravity);
         allowedPos = gameObject.transform.getPosition();
       }
   
  }
  
  void applyForce (PVector force) {
    PVector f = force.get();
    float _mass = mass;
    if (_mass < 1f)
      mass = 1f;
    f.div (mass);
   
    this.acceleration.add(f);
  }
  
  int collisionCount = 0;
  
  void elasticCollision(ICollidable other, CollisionInfo collisionInfo){
    //if (collider != null && collider.isSolid){
          PVector[] velocities = CollisionHelper.getElasticResponse(collider, other, collisionInfo);
          other.setVelocity(velocities[1]);
          
          if (velocities[0].sqrMag() > 1f){

            elasticCollided = true;
          }
          
          frameVelocity.add(velocities[0]);
          collisionCount++;
    //}
  }
  
  void worldCollision(ICollidable other, CollisionInfo collisionInfo){
    PVector _velocity = CollisionHelper.getWorldCollision(collider, other, collisionInfo);
          
    if (_velocity.sqrMag() > 1f){

       elasticCollided = true;
    }
          
    frameVelocity.add(_velocity);
    collisionCount++;
  }
  
}
