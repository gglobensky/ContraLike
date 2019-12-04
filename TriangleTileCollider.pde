class TriangleTileCollider extends TileCollider{
  PVector vertices[] = new PVector[3];
  PShape debugShape;
  
  float getRadius(){ return 0; }
  PVector getPosition(){ return tile.startPosition.get(); }
  PVector getSize(){ return new PVector(xSize, ySize); }
  
  void manageDebugShape(){
    String k = vertices[0].toString() + vertices[1].toString() + vertices[2].toString();
    if (complexShapes.containsKey(k)){
      debugShape = complexShapes.get(k);
    } 
    else {
      debugShape = createShape();
      debugShape.beginShape();
      for (int i = 0; i < 3; i++){
        debugShape.vertex(vertices[i].x, vertices[i].y);
      }
      debugShape.endShape();
      complexShapes.put(k, debugShape);
    }
  }
  
  void display(Camera camera){

      stroke (0);
      fill (xSize, xSize, xSize, 255);
      shapeMode(CORNER);

      shape(debugShape, tile.startPosition.x - camera.getPosition().x, tile.startPosition.y - camera.getPosition().y);
 }
  
  TriangleTileCollider(Tile _tile, int _xSize, int _ySize, PVector vertex1, PVector vertex2, PVector vertex3){
    super(_tile, _xSize, _ySize);
    vertices[0] = new PVector(Helper.ensureRange(vertex1.x, 0, _xSize), Helper.ensureRange(vertex1.y, 0, _ySize));
    vertices[1] = new PVector(Helper.ensureRange(vertex2.x, 0, _xSize), Helper.ensureRange(vertex2.y, 0, _ySize));
    vertices[2] = new PVector(Helper.ensureRange(vertex3.x, 0, _xSize), Helper.ensureRange(vertex3.y, 0, _ySize));
    colliderType = ColliderType.TRIANGLE;
    manageDebugShape();
  }
  
  PVector[] getVertices(){ 
  PVector[] _vertices = new PVector[3];
  PVector position = getPosition();
  for (int i = 0; i < 3; i++){
    _vertices[i] = vertices[i].get();
    _vertices[i].add(position);
  }
  
  return _vertices; 
  }
  
  void manageCollision(ICollidable against){}

}
