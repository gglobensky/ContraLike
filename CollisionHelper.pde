static class CollisionHelper { //<>//
  // TRIANGLE/POINT
  static boolean triPoint(float x1, float y1, float x2, float y2, float x3, float y3, float px, float py) {

    // get the area of the triangle
    float areaOrig = abs( (x2-x1)*(y3-y1) - (x3-x1)*(y2-y1) );

    // get the area of 3 triangles made between the point
    // and the corners of the triangle
    float area1 =    abs( (x1-px)*(y2-py) - (x2-px)*(y1-py) );
    float area2 =    abs( (x2-px)*(y3-py) - (x3-px)*(y2-py) );
    float area3 =    abs( (x3-px)*(y1-py) - (x1-px)*(y3-py) );

    // if the sum of the three areas equals the original,
    // we're inside the triangle!
    if (area1 + area2 + area3 == areaOrig) {
      return true;
    }
    return false;
  } 

  // CIRCLE/CIRCLE
  static CollisionInfo circleCircleCollision(ICollidable collider, ICollidable against) {
    
    // get distance between the circle's centers
    // use the Pythagorean Theorem to compute the distance
    PVector direction = collider.getPosition();
    direction.sub(against.getPosition());
    float c1r = collider.getSize().x / 2f;
    float c2r = against.getSize().x / 2f;
    
    float sqrDistance = direction.sqrMag();

    // if the distance is less than the sum of the circle's
    // radii, the circles are touching!
    if (sqrDistance <= (c1r+c2r) * (c1r+c2r)) {
      PVector collisionPoint = collider.getPosition();
      collisionPoint.add(new PVector(c1r, c1r));
      direction.div(2f);
      collisionPoint.sub(direction);
      
      /*PVector normal = collider.getPosition();
      PVector halfSize = collider.getSize();
      halfSize.div(2);
      normal.add(halfSize);
      normal.sub(collisionPoint);*/
      
      CollisionInfo collisionInfo = new CollisionInfo(collisionPoint, PVector.zero());
      
      return collisionInfo;
    }
    return null;
  }

  // POLYGON/CIRCLE
  static boolean polyCircle(PVector[] vertices, float cx, float cy, float r) {

    // go through each of the vertices, plus
    // the next vertex in the list
    int next = 0;
    for (int current=0; current<vertices.length; current++) {

      // get next vertex in list
      // if we've hit the end, wrap around to 0
      next = current+1;
      if (next == vertices.length) next = 0;

      // get the PVectors at our current position
      // this makes our if statement a little cleaner
      PVector vc = vertices[current];    // c for "current"
      PVector vn = vertices[next];       // n for "next"

      // check for collision between the circle and
      // a line formed between the two vertices

      boolean collision = lineCircle(vc.x, vc.y, vn.x, vn.y, cx, cy, r);
      if (collision) return true;
    }

    // the above algorithm only checks if the circle
    // is touching the edges of the polygon – in most
    // cases this is enough, but you can un-comment the
    // following code to also test if the center of the
    // circle is inside the polygon

    // boolean centerInside = polygonPoint(vertices, cx,cy);
    // if (centerInside) return true;

    // otherwise, after all that, return false
    return false;
  }

  static CollisionInfo getPolyCircleIntersection(ICollidable poly, ICollidable circle) {

    PVector circleCenter = circle.getPosition();
    float r = circle.getSize().x / 2;
    circleCenter.add(new PVector(r, r));
    float cx = circleCenter.x + circle.getVelocity().x;
    float cy = circleCenter.y + circle.getVelocity().y;

    PVector[] vertices = poly.getVertices();
    // go through each of the vertices, plus
    // the next vertex in the list
    int next = 0;
    for (int current=0; current<vertices.length; current++) {

      // get next vertex in list
      // if we've hit the end, wrap around to 0
      next = current+1;
      if (next == vertices.length) next = 0;

      // get the PVectors at our current position
      // this makes our if statement a little cleaner
      PVector vc = vertices[current];    // c for "current"
      PVector vn = vertices[next];       // n for "next"

      // check for collision between the circle and
      // a line formed between the two vertices

      PVector intersection = getLineCircleIntersection(vc.x, vc.y, vn.x, vn.y, cx, cy, r);
      if (intersection != null){
        PVector normal = vn.get();
        normal.sub(vc);
        normal = new PVector(normal.y, -normal.x);
        CollisionInfo collisionInfo = new CollisionInfo(intersection, PVector.normalize(normal));
        return collisionInfo;
      }
    }

    // the above algorithm only checks if the circle
    // is touching the edges of the polygon – in most
    // cases this is enough, but you can un-comment the
    // following code to also test if the center of the
    // circle is inside the polygon

    // boolean centerInside = polygonPoint(vertices, cx,cy);
    // if (centerInside) return true;

    // otherwise, after all that, return false
    return null;
  }

  static PVector getLineCircleIntersection(float x1, float y1, float x2, float y2, float cx, float cy, float r) {

    // get length of the line
    float distX = x1 - x2;
    float distY = y1 - y2;
    float len = sqrt( (distX*distX) + (distY*distY) );

    // get dot product of the line and circle
    float dot = ( ((cx-x1)*(x2-x1)) + ((cy-y1)*(y2-y1)) ) / pow(len, 2);

    // find the closest point on the line
    float closestX = x1 + (dot * (x2-x1));
    float closestY = y1 + (dot * (y2-y1));

    // is this point actually on the line segment?
    // if so keep going, but if not, return false
    boolean onSegment = linePoint(x1, y1, x2, y2, closestX, closestY);
    if (!onSegment) return null;

    // get distance to closest point
    distX = closestX - cx;
    distY = closestY - cy;
    float distance = sqrt( (distX*distX) + (distY*distY) );

    // is the circle on the line?
    if (distance <= r) {
      return new PVector(closestX, closestY);
    }
    return null;
  }

  // LINE/CIRCLE
  static boolean lineCircle(float x1, float y1, float x2, float y2, float cx, float cy, float r) {

    // is either end INSIDE the circle?
    // if so, return true immediately
    boolean inside1 = pointCircle(x1, y1, cx, cy, r);
    boolean inside2 = pointCircle(x2, y2, cx, cy, r);
    if (inside1 || inside2) return true;

    // get length of the line
    float distX = x1 - x2;
    float distY = y1 - y2;
    float len = sqrt( (distX*distX) + (distY*distY) );

    // get dot product of the line and circle
    float dot = ( ((cx-x1)*(x2-x1)) + ((cy-y1)*(y2-y1)) ) / pow(len, 2);

    // find the closest point on the line
    float closestX = x1 + (dot * (x2-x1));
    float closestY = y1 + (dot * (y2-y1));

    // is this point actually on the line segment?
    // if so keep going, but if not, return false
    boolean onSegment = linePoint(x1, y1, x2, y2, closestX, closestY);
    if (!onSegment) return false;

    // get distance to closest point
    distX = closestX - cx;
    distY = closestY - cy;

    float distance = sqrt( (distX*distX) + (distY*distY) );

    // is the circle on the line?
    if (distance <= r) {
      return true;
    }
    return false;
  }


  // LINE/POINT
  static boolean linePoint(float x1, float y1, float x2, float y2, float px, float py) {

    // get distance from the point to the two ends of the line
    float d1 = dist(px, py, x1, y1);
    float d2 = dist(px, py, x2, y2);

    // get the length of the line
    float lineLen = dist(x1, y1, x2, y2);

    // since floats are so minutely accurate, add
    // a little buffer zone that will give collision
    float buffer = 0.1;    // higher # = less accurate

    // if the two distances are equal to the line's
    // length, the point is on the line!
    // note we use the buffer here to give a range, rather
    // than one #
    if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer) {
      return true;
    }
    return false;
  }


  // POINT/CIRCLE
  static boolean pointCircle(float px, float py, float cx, float cy, float r) {

    // get distance between the point and circle's center
    // using the Pythagorean Theorem
    float distX = px - cx;
    float distY = py - cy;
    float distance = sqrt( (distX*distX) + (distY*distY) );

    // if the distance is less than the circle's 
    // radius the point is inside!
    if (distance <= r) {
      return true;
    }
    return false;
  }


  // POLYGON/POINT
  // only needed if you're going to check if the circle
  // is INSIDE the polygon
  static boolean polygonPoint(PVector[] vertices, float px, float py) {
    boolean collision = false;

    // go through each of the vertices, plus the next
    // vertex in the list
    int next = 0;
    for (int current=0; current<vertices.length; current++) {

      // get next vertex in list
      // if we've hit the end, wrap around to 0
      next = current+1;
      if (next == vertices.length) next = 0;

      // get the PVectors at our current position
      // this makes our if statement a little cleaner
      PVector vc = vertices[current];    // c for "current"
      PVector vn = vertices[next];       // n for "next"

      // compare position, flip 'collision' variable
      // back and forth
      if (((vc.y > py && vn.y < py) || (vc.y < py && vn.y > py)) &&
        (px < (vn.x-vc.x)*(py-vc.y) / (vn.y-vc.y)+vc.x)) {
        collision = !collision;
      }
    }
    return collision;
  }

  static PVector[] getElasticResponse(ICollidable collider, ICollidable other, CollisionInfo collisionInfo) {
    
    
    float colMass = collider.getMass();
    PVector colVeloc = collider.getVelocity();

    float otherMass = other.getMass();
    PVector otherVeloc = other.getVelocity();

    float e = otherVeloc.x - colVeloc.x;
    float f = colMass * colVeloc.x + otherMass * otherVeloc.x;

    PVector results = Helper.solveTwoEquationSystem(1, -1, colMass, otherMass, e, f);

    float colX = results.x;
    float otherX = results.y;

    e = otherVeloc.y - colVeloc.y;
    f = colMass * colVeloc.y + otherMass * otherVeloc.y;

    results = Helper.solveTwoEquationSystem(1, -1, colMass, otherMass, e, f);
    float colY = results.x;
    float otherY = results.y;

    PVector[] result = { new PVector(colX, colY), new PVector(otherX, otherY) };
    
    if (result[0].sqrMag() < 20f && result[1].sqrMag() < 20f){
      PVector colPos = collider.getSize();
      colPos.div(2);
      colPos.add(collider.getPosition());
      
      PVector otherPos = other.getSize();
      otherPos.div(2);
      otherPos.add(other.getPosition());
      
      float restitutionCoeff = (collider.getRestitutionCoeff() + other.getRestitutionCoeff()) / 2;
      PVector direction = collisionInfo.collisionPoint.get();
      if (colPos.y < otherPos.y){
        direction.sub(colPos);
        direction.normalize();
        direction.mult(-1.01);
        direction.mult(restitutionCoeff);
        direction.y = Math.min(direction.y, -Math.abs(otherVeloc.y));
        result[0] = direction;
        result[1].mult(restitutionCoeff);
      }
      else
      {
        direction.sub(otherPos);
        direction.normalize();
        direction.mult(-1.01);
        direction.mult(restitutionCoeff);
        direction.y = Math.min(direction.y, -Math.abs(colVeloc.y));
        result[1] = direction;
        result[0].mult(restitutionCoeff);
      }
    }
    
    return result;
    
  }
  
  static PVector getWorldCollision(ICollidable collider, ICollidable other, CollisionInfo collisionInfo){
    
      PVector normal = collisionInfo.surfaceNormal;
      PVector result = collider.getVelocity();
      float restitutionCoeff = (collider.getRestitutionCoeff() + other.getRestitutionCoeff()) / 2;
      
    if (collider.getColliderType() == ColliderType.TRIANGLE || other.getColliderType() == ColliderType.TRIANGLE){

      
      double _rad = Math.atan2((double)normal.y, (double)normal.x) + HALF_PI;  
      double cs = Math.cos(_rad);
      double sn = Math.sin(_rad);
      
      PVector dir = result.get();
  
      double px = dir.x * cs - dir.y * sn; 
      double py = dir.x * sn + dir.y * cs;
    
      result = new PVector((float)px * restitutionCoeff, (float)py * restitutionCoeff);
    }
    else
    {
      result.x *= (normal.x * restitutionCoeff);
      result.y *= (normal.y * restitutionCoeff);
      
    }
    //println(result);
    return result;
  }
  
  static CollisionInfo squareCircleCollision(ICollidable circleCollider, ICollidable squareCollider) {
    // temporary variables to set edges for testing

    float cx = circleCollider.getPosition().x + circleCollider.getSize().x / 2 + circleCollider.getVelocity().x;
    float cy = circleCollider.getPosition().y + circleCollider.getSize().y / 2 + circleCollider.getVelocity().y;

    PVector squarePos = squareCollider.getPosition();
    squarePos.add(squareCollider.getVelocity());

    float rx = squarePos.x;
    float ry = squarePos.y;
    float rw = squareCollider.getSize().x;
    float rh = squareCollider.getSize().y;
   // PVector[] vertices = { new PVector(rx, ry), new PVector(rx + rw, ry), new PVector(rx + rw, ry + rh), new PVector(rx, ry + rh) };
    float testX = cx;
    float testY = cy;

    // which edge is closest?
    if (cx < rx) testX = rx;            // test left edge
    else if (cx > rx+rw) testX = rx+rw; // right edge
    if (cy < ry) testY = ry;            // top edge
    else if (cy > ry+rh) testY = ry+rh; // bottom edge
    
    PVector normal = PVector.zero();
    
    if (testX + 1 > rx + rw){
      /*normal = vertices[2].get();
      normal.sub(vertices[1].get());*/
      normal = new PVector(1, 0);
    }
    else if (testX - 1 < rx){
      /*normal = vertices[3].get();
      normal.sub(vertices[0].get());*/
      normal = new PVector(-1, 0);
    }
    else if (testY + 1 > ry + rh){
      /*normal = vertices[2].get();
      normal.sub(vertices[3].get());*/
      normal = new PVector(0, 1);
    }
    else if (testY - 1 < ry){
      /*normal = vertices[1].get();
      normal.sub(vertices[0].get());*/
      normal = new PVector(0, -1);
    }
      
    // get distance from closest edges
    float distX = cx-testX;
    float distY = cy-testY;
    //print(cx + " " + cy + "\n");
    float distance = (distX*distX) + (distY*distY);
    //print((distance <= radius) + "\n");
    // if the distance is less than the radius, collision!
    float radius = circleCollider.getSize().x / 2;
    
    if (distance <= radius * radius) {   
      CollisionInfo collisionInfo = new CollisionInfo(new PVector(testX, testY), PVector.normalize(normal));
      return collisionInfo;

    }
    return null;
  }

  static boolean linePolyCollision(PVector lineStart, PVector lineEnd, PVector[] vertex) {
    int len = vertex.length;

    for (int i = 0; i < len; i++) {
      int next = i + 1;
      if (next == len)
        next = 0;

      if (lineLineCollision(lineStart, lineEnd, vertex[i], vertex[next]))
        return true;
    }
    return false;
  }
  
  static CollisionInfo squareSquareCollision(ICollidable collider, ICollidable other) {
    //HOW WILL IT HANDLE WHEN SQUARE IS INSIDE ANOTHER?
     PVector colVel = collider.getVelocity();
     PVector colPos = collider.getPosition();
     float x1 = colPos.x + colVel.x;
     float y1 = colPos.y + colVel.y;
     PVector colSize = collider.getSize();
     float x2 = x1 + colSize.x;
     float y2 = y1 + colSize.y;
     
     PVector otherPos = other.getPosition();
     float x3 = otherPos.x;
     float y3 = otherPos.y;
     PVector otherSize = other.getSize();
     float x4 = x3 + otherSize.x;
     float y4 = y3 + otherSize.y;
     
     if (x2 < x3 || x1 > x4 || y2 < y3 || y1 > y4){
       
       return null;
     }
     
     PVector colCenter = new PVector(x1 + colSize.x / 2, y1 + colSize.y / 2);
     PVector otherCenter = new PVector(x3 + otherSize.x / 2, y3 + otherSize.y / 2);
     
     PVector delta = PVector.sub(colCenter, otherCenter);
     PVector normal = PVector.zero();
     PVector collisionPoint = PVector.zero();
     boolean done = false;
     
     if (Math.abs(delta.y) <= otherSize.y / 2){
       if (delta.x > 0){
         if (colVel.x < 0){
           //println("left");
           collisionPoint = new PVector(x1, y1 + (Math.min(y2, y4) - Math.max(y1, y3)) / 2);
           normal = new PVector(1, 0);
           done = true;
         }
       }
       else if (delta.x < 0){
         if (colVel.x > 0){
           //println("right");
           collisionPoint = new PVector(x2, y1 + (Math.min(y2, y4) - Math.max(y1, y3)) / 2);
           normal = new PVector(-1, 0);
           done = true;
         }
       }
     }
     
     if (!done && Math.abs(delta.x) <= otherSize.x / 2){
       if (delta.y > 0){
         if (colVel.y < 0){
           //println("top");
           collisionPoint = new PVector(x1 + (Math.min(x2, x4) - Math.max(x1, x3)) / 2, y1);
           normal = new PVector(0, 1);
           done = true;
         }
       }
       else if (delta.y < 0){
         if (colVel.y > 0){
           //println("bottom");
           collisionPoint = new PVector(x1 + (Math.min(x2, x4) - Math.max(x1, x3)) / 2, y2);
           normal = new PVector(0, -1);
           done = true;
         }
       }
     }
     
     //WILL HAVE TO VERIFY CORNER COLLISION POINTS
     if (!done && delta.x > otherSize.x / 2){
       if (colVel.x < 0){
         if (delta.y < -otherSize.y / 2){
           //println("up left side");
           collisionPoint = new PVector(x4, y3);
           normal = new PVector(1, 1);
           done = true;
         }
         else if (delta.y > otherSize.y / 2){
           //println("down left side");
           collisionPoint = new PVector(x4, y4);
           normal = new PVector(1, -1);
           done = true;
         }
       }
     }
     else if (delta.x < -otherSize.x / 2){
       if (colVel.x > 0){
         if (delta.y < -otherSize.y / 2){
           //println("up right side");
           collisionPoint = new PVector(x3, y3);
           normal = new PVector(-1, 1);
         }
         else if (delta.y > otherSize.y / 2){
           //println("down right side");
           collisionPoint = new PVector(x3, y4);
           normal = new PVector(-1, -1);
         }
       }
     }
     
     return new CollisionInfo(collisionPoint, normal);
     
    //}
    //return null;
  }
  
  static boolean lineLineCollision(PVector firstLineStart, PVector firstLineEnd, PVector secondLineStart, PVector secondLineEnd) {

    // calculate the distance to intersection point
    float uA = ((secondLineEnd.x - secondLineStart.x) * (firstLineStart.y - secondLineStart.y) - (secondLineEnd.y - secondLineStart.y) * (firstLineStart.x - secondLineStart.x)) / ((secondLineEnd.y - secondLineStart.y) * (firstLineEnd.x - firstLineStart.x) - (secondLineEnd.x - secondLineStart.x) * (firstLineEnd.y - firstLineStart.y));
    float uB = ((firstLineEnd.x - firstLineStart.x) * (firstLineStart.y - secondLineStart.y) - (firstLineEnd.y - firstLineStart.y) * (firstLineStart.x - secondLineStart.x)) / ((secondLineEnd.y - secondLineStart.y) * (firstLineEnd.x - firstLineStart.x) - (secondLineEnd.x - secondLineStart.x) * (firstLineEnd.y - firstLineStart.y));

    // if uA and uB are between 0-1, lines are colliding
    if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
      return true;
    }
    return false;
  }
}
