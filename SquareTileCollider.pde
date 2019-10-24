class SquareTileCollider extends TileCollider{
  
  float getRadius(){ return 0; }
  PVector getPosition(){ return tile.startPosition.get(); }
  PVector getSize(){ return new PVector(xSize, ySize); }
  void display(Camera camera){

      stroke (0);
      fill (xSize, xSize, xSize, 255);
      shapeMode(CORNER);
      PShape t = createShape();
      t.beginShape();
      t.vertex(0, ySize);
      t.vertex(xSize, ySize);
      t.vertex(xSize, 0);
      t.vertex(0, 0);
      t.endShape();
      shape(t, tile.startPosition.x - camera.getPosition().x, tile.startPosition.y - camera.getPosition().y);
 }
  
  
  PVector[] getVertices(){
    PVector pos = getPosition();
    PVector size = getSize();
    PVector[] vertices = new PVector[4];
    vertices[0] = pos;
    vertices[1] = new PVector(pos.x, pos.y + size.y);
    vertices[2] = new PVector(pos.x + size.x, pos.y + size.y);
    vertices[3] = new PVector(pos.x + size.y, pos.y);
    
    return vertices;
  }
  
  SquareTileCollider(Tile _tile, int _xSize, int _ySize){
    super(_tile, _xSize, _ySize);
    colliderType = ColliderType.SQUARE;
  }
  
  void manageCollision(ICollidable against){}

}
