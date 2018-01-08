class People {
  int scaleFactor = 1;
  int wallHeight = (3712-1914)/scaleFactor;     // wallHeight to differenciate between the floor and wall projection

  //attributes of the person
  int[] pColor = new int[4];   // color of the person
  PShape image;
  float oldX, oldY;              // last position of the person
  int name;                    // number tag of the person (sorted by time of entering the area)

  //symbol & cone sizes
  float coneSize = 100/scaleFactor;         // light cone size on the floor projection
  float symbolSize = 50/scaleFactor;

  //standing still factors
  double minDist = 478;           // if a person moves less than this attribute, the person is assumed to stay still  228000
  int counter = 0;             // counter for the time a person stays in one place

  //interactions over time
  float interactionCounter = 0.0;
  int time = 0;
  int timeCounter = 0;


  ArrayList<Double> distances = new ArrayList<Double>();

  public People(int[] pColor, PShape img, int x, int y, int name) {
    this.pColor = pColor;
    image = img;
    oldX = x;
    oldY = y-wallHeight;
    this.name = name;
  }

  public void update(int posX, int posY) {
    time ++;

    if (time>200) {
      updateColor();
    }

    
    stroke(pColor[0], pColor[1], pColor[2], pColor[3]);
    strokeWeight(1.2);
    fill(pColor[0], pColor[1], pColor[2], pColor[3]);

    double currentDistance = Math.sqrt(Math.pow(posX-oldX, 2)+Math.pow(posY-oldY, 2));


    /*distances.add(currentDistance/60);
     if(distances.size()>60){
     distances.remove(0);
     }
     
     double avgDistance = 0.0;
     for(double dist : distances){
     avgDistance += dist;
     }
     
     if(name ==2){
     
     println(avgDistance);
     }
     
     if(avgDistance<476.7 && distances.size()==60){
     shape(image, posX-coneSize/2.0, posY-wallHeight-coneSize/2.0, coneSize, coneSize);
     }*/

    if (currentDistance<minDist) {
      counter ++;

      if (counter == 60) {   
        println("Now");
        shape(image, posX-symbolSize/2.0, posY-wallHeight-symbolSize/2.0, symbolSize, symbolSize);
        counter = 0;
      }
      
    } else if (counter != 0) {
      counter = 0;
    }


    line(oldX, oldY, posX,  posY-wallHeight);
    noStroke();  
    ellipse(posX, posY, coneSize, coneSize);
    fill(0);
    text(name, posX, posY);

    oldX = posX;
    oldY =  posY-wallHeight;
  }

  public float getX() {
    return oldX;
  }

  public float getY() {
    return oldY;
  }

  public int[] getColor() {
    return pColor;
  }

  public void changeColor(int[] otherColor) {
    pColor[0] = (int)(pColor[0]*0.999 + otherColor[0]*0.001);
    pColor[1] = (int)(pColor[1]*0.999 + otherColor[1]*0.001);
    pColor[2] = (int)(pColor[2]*0.999 + otherColor[2]*0.001);
    //pColor[0] = (int)(pColor[0]+(pColor[0]-otherColor[0])*0.005);
    //pColor[1] = (int)(pColor[1]+(pColor[1]-otherColor[1])*0.005);
    //pColor[2] = (int)(pColor[2]+(pColor[2]-otherColor[2])*0.005);

    interactionCounter++;
  }

  protected void updateColor() {
    float interactionsOverTime = interactionCounter/time;

    if (interactionsOverTime<0.06) {
     // println(name + ": " + interactionsOverTime);
      coneSize-=0.005;

      timeCounter++;    
      if (timeCounter>15) {
        //println(name);
        pColor[3]--;     
        timeCounter = 0;
      }
      
    } else if (pColor[3]<255) {
      timeCounter++;    
      if (timeCounter>30) {
        pColor[3]++;     
        timeCounter = 0;
      }
      coneSize+=0.005;
    } else if (coneSize<50) {
      coneSize+=0.005;
    }
  }
}