class People {
  int scaleFactor = 4;
  int wallHeight = 1914/scaleFactor;     // wallHeight to differenciate between the floor and wall projection

  //attributes of the person
  int[] pColor = new int[4];   // color of the person
  PShape image;
  float oldX, oldY;              // last position of the person
  int name;                    // number tag of the person (sorted by time of entering the area)

  //symbol & cone sizes & line width
  float coneSize = 100/scaleFactor;         // light cone size on the floor projection
  float changeCone = 0.02/scaleFactor;
  float maxConeSize = 200/scaleFactor;
  
  float symbolSize = 50/scaleFactor;
  
  float lineWidth = 4.8/scaleFactor;
  float changeLine = 0.001/scaleFactor;
  float maxLineWidth = 12/scaleFactor;

  //interactions over time
  float interactionCounter = 0.0;
  int time = 0;
  int timeCounter = 0;
  public boolean interaction = false;
  int interactionX =-1, interactionY =-1;
  float minDistance = 1900/scaleFactor;
  
  //sound
  Minim sound;
  AudioPlayer playerInteraction;

  public People(int[] pColor, PShape img, int x, int y, int name, Minim sound) {
    this.pColor = pColor;
    image = img;
    oldX = x;
    oldY = y-wallHeight;
    this.name = name;
    
    this.sound = sound;
    playerInteraction = sound.loadFile("Heartbeat_Meeting.aif");
    playerInteraction.setGain(-10);
  }

  public void update(int posX, int posY) {
    time ++;

    if (time>200 ) {
      updateBehaviour();
      
      if(time%50 == 0){
        processInteraction(posX, posY);
      }
    }


    stroke(pColor[0], pColor[1], pColor[2], pColor[3]);
    strokeWeight(lineWidth);
    line(oldX, oldY, posX, posY-wallHeight);
    noStroke();  

    fill(pColor[0], pColor[1], pColor[2], pColor[3]);
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

    interactionCounter++;
  }
  
  protected void processInteraction(int posX, int posY){
    if (interaction==true) {
      if(interactionX == -1 && interactionY ==-1 || Math.sqrt(Math.pow(posX-interactionX,2)+Math.pow(posY-interactionY, 2)) < minDistance){       
        fill(255);
        ellipse(posX, posY-wallHeight, symbolSize*1.5, symbolSize*1.5);
        shape(image, posX-symbolSize/2.0, posY-wallHeight-symbolSize/2.0, symbolSize, symbolSize);
        interactionX = posX;
        interactionY = posY;
        
        playerInteraction.play();
        playerInteraction.rewind();
      }
      
      interaction = false;
    }
  }
  
  protected void updateBehaviour() {
    float interactionsOverTime = interactionCounter/time;

    if (interactionsOverTime<0.06) {
      timeCounter++;    
      if (timeCounter>15) {
        pColor[3]--;     
        timeCounter = 0;
      }

      if(coneSize>=changeCone){ 
        coneSize-=changeCone;
      }
      
      if(lineWidth>=changeLine){       
        lineWidth -= changeLine;
      }
      
    } else {
      if (pColor[3]<255) {
        timeCounter++;    
        if (timeCounter>30) {
          pColor[3]++;     
          timeCounter = 0;
        }
      } 

      if (coneSize<maxConeSize) {
        coneSize+=changeCone;
      }

      if (lineWidth<maxLineWidth) {
        lineWidth += changeLine;
      }
    }
  }
}