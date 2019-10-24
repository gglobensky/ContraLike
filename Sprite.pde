class Sprite extends Graphical{
  PImage texture;
  
  Sprite(GameObject _gameObject, int _layer, String filePath, Camera camera){
    super(_gameObject, Sprite.class, _layer, camera);
    texture = loadImage(filePath);
    texture.resize((int)(gameObject.transform.size.x * relativeScale.x), (int)(gameObject.transform.size.y * relativeScale.y));
  }
  
  void display(Camera camera){
     PVector currentPos = PVector.add(gameObject.transform.position(), relativePos);
     image(texture, currentPos.x - drawPos.x, currentPos.y - drawPos.y); 
  }
}
