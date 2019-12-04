class SquareTileCollider extends TileCollider{
  
  float getRadius(){ return 0; }
  PVector getPosition(){ return tile.startPosition.get(); }
  PVector getSize(){ return new PVector(xSize, ySize); }
  PVector[] vertices = new PVector[4];
  PShape debugShape;
    
  void manageDebugShape(boolean isComplex){
    if (isComplex){
      String k = vertices[0].toString() + vertices[1].toString() + vertices[2].toString() + vertices[3].toString();
      
      if (complexShapes.containsKey(k)){
        debugShape = complexShapes.get(k);
      } 
      else {
        debugShape = createShape();
        debugShape.beginShape();
        debugShape.vertex(vertices[0].x, vertices[0].y);
        debugShape.vertex(vertices[1].x, vertices[1].y);
        debugShape.vertex(vertices[2].x, vertices[2].y);
        debugShape.vertex(vertices[3].x, vertices[3].y);
        debugShape.endShape();
        complexShapes.put(k, debugShape);
      }
    }
    else{
       debugShape = basicShapes.get(Shape.RECTANGLE);
    }
  }
  
  
  void display(Camera camera){

      stroke (0);
      fill (xSize, xSize, xSize, 255);
      shapeMode(CORNER);

      shape(debugShape, tile.startPosition.x - camera.getPosition().x, tile.startPosition.y - camera.getPosition().y, xSize, ySize);
 }
  
  
  void setVertices(){
    PVector pos = getPosition();
    PVector size = getSize();

    vertices[0] = pos;
    vertices[1] = new PVector(pos.x, pos.y + size.y);
    vertices[2] = new PVector(pos.x + size.x, pos.y + size.y);
    vertices[3] = new PVector(pos.x + size.y, pos.y);
  }
  
  void setVertices(PVector[] _vertices){

    vertices[0] = _vertices[0];
    vertices[1] = _vertices[1];
    vertices[2] = _vertices[2];
    vertices[3] = _vertices[3];
  }
  
  PVector[] getVertices(){
    return vertices;
  }
  
  SquareTileCollider(Tile _tile, int _xSize, int _ySize){
    super(_tile, _xSize, _ySize);
    colliderType = ColliderType.SQUARE;
    setVertices();
    manageDebugShape(false);
  }
  
  SquareTileCollider(Tile _tile, int _xSize, int _ySize, PVector vertex1, PVector vertex2, PVector vertex3, PVector vertex4){
    super(_tile, _xSize, _ySize);
    colliderType = ColliderType.SQUARE;
    PVector[] _vertices = {vertex1, vertex2, vertex3, vertex4};
    setVertices(_vertices);
    manageDebugShape(true);
  }
  
  void manageCollision(ICollidable against){}

}
