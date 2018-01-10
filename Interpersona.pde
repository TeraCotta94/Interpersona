import ddf.minim.*;

PFont font;
int scaleFactor = 4;
int windowWidth = 3030/scaleFactor;   // for real Deep Space this should be 3030
int windowHeight = 3712/scaleFactor;  // for real Deep Space this should be 3712
int wallHeight = 1914/scaleFactor;    // for real Deep Space this should be 1914 (Floor is 1798)

HashMap<Integer, People> people = new HashMap<Integer, People>();
int counter = 0;      // counter for the fade out
int collDist = 200/scaleFactor;    // distance for collision calculation

int colorCounter = 0;
int[][] colors = new int[][]{ {0, 190, 255, 255}, // light blue
  {150, 0, 255, 255}, // purple
  {255, 255, 0, 255}, // yellow
  {150, 255, 0, 255}, // lime
  {255, 60, 0, 255}, // red
  {255, 180, 0, 255}, // orange                              
  {0, 50, 255, 255}, // blue
  {240, 0, 220, 255}, // pink
  {0, 180, 0, 255}};      // green

PShape[] images;  
Minim sound;
AudioPlayer playerAmbient;

void settings()
{
  size(windowWidth, windowHeight);
}


void setup()
{
  noStroke();
  fill(0);

  font = createFont("Arial", 18);
  textFont(font, 18);
  textAlign(CENTER, CENTER);

  initTracking(false, wallHeight);

  // set upper half of window (=wall projection) white
  fill(255);
  rect(0, 0, windowWidth, wallHeight);

  images = new PShape[]{loadShape("Symbole/Symbole-01.svg"), 
    loadShape("Symbole/Symbole-02.svg"), 
    loadShape("Symbole/Symbole-03.svg"), 
    loadShape("Symbole/Symbole-04.svg"), 
    loadShape("Symbole/Symbole-05.svg"), 
    loadShape("Symbole/Symbole-06.svg"), 
    loadShape("Symbole/Symbole-07.svg"), 
    loadShape("Symbole/Symbole-08.svg"), 
    loadShape("Symbole/Symbole-09.svg")};

  sound = new Minim(this);
  playerAmbient = sound.loadFile("Forest_Ambience.aif");
  playerAmbient.loop();
  playerAmbient.setGain(-25);
}


void draw()
{

  // redraw wall projection to make the lines fade out
  counter++;
  if (counter>120) {
    counter = 0;

    noStroke();
    fill(255, 255, 255, 20);
    rect(0, 0, windowWidth, wallHeight);
  }

  // stuff for the FPS counter
  fill(255);
  rect(0, 0, windowWidth, 24);
  fill(0);
  text((int)frameRate + " FPS", width / 2, 10);

  // redraw floor projection
  rect(0, wallHeight, windowWidth, windowHeight);

  // calculate and draw behaviour of people currently in the room
  for (int trackID=0; trackID<GetNumTracks (); trackID++) 
  {      
    // if a new person enters the room a new entity is added to People
    if(people.get(GetCursorID(trackID))== null){
      people.put(GetCursorID(trackID),new People(colors[colorCounter++%9], images[colorCounter++%9], GetPathPointX(trackID, GetNumPathPoints(trackID)-1), GetPathPointY(trackID, GetNumPathPoints(trackID)-1), GetCursorID(trackID), sound));
    } 

    // otherwise the person is updated
    People pCurrent = people.get(GetCursorID(trackID));
    pCurrent.update(GetPathPointX(trackID, GetNumPathPoints(trackID)-1), GetPathPointY(trackID, GetNumPathPoints(trackID)-1));

    //it is checked if it collides with any other previously checked trackID
    for (int i = 0; i<trackID; i++) {
      People pTemp = people.get(GetCursorID(i));
      double dist = Math.abs(pCurrent.getX() - pTemp.getX()) + Math.abs(pCurrent.getY() - pTemp.getY());
      if (dist<collDist) {  
        int[] cCurrent = pCurrent.getColor();
        int[] cTemp = pTemp.getColor();

        pCurrent.changeColor(cTemp);
        pTemp.changeColor(cCurrent);
        
        pCurrent.interaction = true;
        pTemp.interaction = true;
      }
    }
    
  }
}