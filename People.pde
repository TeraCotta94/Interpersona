class People{
  
  int wallHeight = 1914/4;     // wallHeight to differenciate between the floor and wall projection
  
  //attributes of the person
  int[] pColor = new int[3];   // color of the person
  int oldX, oldY;              // last position of the person
  int name;                    // number tag of the person (sorted by time of entering the area)
  
  //generall attributes
  float coneSize = 25;         // light cone size on the floor projection
  double minDist = 478.5;           // if a person moves less than this attribute, the person is assumed to stay still  228000
  int counter = 0;             // counter for the time a person stays in one place
  
  public People(int[] pColor, int x, int y, int name){
    this.pColor = pColor;
    oldX = x;
    oldY = y-wallHeight;
    this.name = name;
  }
  
  public void update(int posX, int posY){
    stroke(pColor[0], pColor[1], pColor[2]);
    strokeWeight(1.2);
    fill(pColor[0], pColor[1], pColor[2]);
    
    double dist = Math.sqrt(Math.pow(posX-oldX,2)+Math.pow(posY-oldY,2));
    if(dist<minDist){
      counter ++;
      
      if (counter == 60){   
        println("count " + name + " " + dist);
        ellipse(posX, posY-wallHeight, coneSize, coneSize);
        counter = 0;
      }
    }
    else if(counter != 0){
      counter = 0;
      println("reset " + name + " " + dist);
    }
    
    line(oldX, oldY, posX, posY-wallHeight);
    noStroke();  
    ellipse(posX, posY, coneSize, coneSize);
    fill(0);
    text(name, posX, posY);
    
    oldX = posX;
    oldY = posY-wallHeight;
  }
  
  
}