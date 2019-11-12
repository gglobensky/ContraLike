class FluidBody extends Component implements PhysicsObserver{
 private float xSize;
 private float ySize;
 Collider collider;
 float density;
 float frictionCoeff;
 Map<Camera, Integer> cameras = new HashMap();//Camera, Layer
 boolean isCulled;
  
 FluidBody(GameObject _gameObject, float _density, float _frictionCoeff){
   super(_gameObject, FluidBody.class);
   GameEngine.addToPhysicsList(this);
   xSize = gameObject.transform.size.x;
   ySize = gameObject.transform.size.y;
   density = _density;
   frictionCoeff = _frictionCoeff;

  
   collider = gameObject.getComponent(Collider.class);
    if (collider == null){
      print("\nFluidBody does not possess a collider!\n");
    }
 }
 
 boolean isHit(){ if (collider != null) return collider.hasCollided(); else return false; }
 
 void update(){
   HashMap<ICollidable, CollisionInfo> collidedWith = collider.getCollidedWith();

   if (collidedWith.size() > 0){   
     for (Map.Entry<ICollidable, CollisionInfo> entry : collidedWith.entrySet()) {
        ICollidable other = entry.getKey();
        if (other.getPhysicsBody() != null){
          other.getPhysicsBody().applyForce(getDragForce(other.getPhysicsBody()));
        }
      }
   }
   
 }

 PVector getDragForce(PhysicsBody mover){
  
   float velocityMagnitude = mover.velocity.mag();
   
   if (mover.collider == null || !mover.collider.collidedAgainstSolid){
     float dragMagnitude = this.density * this.frictionCoeff * velocityMagnitude;
     PVector drag = mover.velocity.get();
     drag.normalize();
     drag.mult(-mover.surfaceArea);
     drag.mult(dragMagnitude);

     return drag;
   }
   return PVector.zero();
 }
}
