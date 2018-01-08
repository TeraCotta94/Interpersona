// Version 4.1
import processing.sound.*;

PFont font;
int scaleFactor = 15;
int windowWidth = 3030/scaleFactor;   // for real Deep Space this should be 3030
int windowHeight = 3712/scaleFactor;  // for real Deep Space this should be 3712
int wallHeight = 1914/scaleFactor;    // for real Deep Space this should be 1914 (Floor is 1798)

ArrayList<People> people = new ArrayList<People>();    // list of people in the room
int counter = 0;      // counter for the fade out
int collDist = 50;    // distance for collision calculation

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
SoundFile sound;

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

  images = new PShape[]{loadShape("Symbole/Symbol-01.svg"), 
    loadShape("Symbole/Symbol-02.svg"), 
    loadShape("Symbole/Symbol-03.svg"), 
    loadShape("Symbole/Symbol-04.svg"), 
    loadShape("Symbole/Symbol-05.svg"), 
    loadShape("Symbole/Symbol-06.svg"), 
    loadShape("Symbole/Symbol-07.svg"), 
    loadShape("Symbole/Symbol-08.svg"), 
    loadShape("Symbole/Symbol-09.svg")};
    
    sound = new SoundFile(this, "Forest_Atmo.aif");
    sound.loop();
    sound.amp(0.1);
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

/*
  while (people.size() <= GetCursorID(GetNumTracks()-1)) {
    print(people.size());
    int current = people.size();
    people.add(new People(colors[colorCounter++%9], images[colorCounter++%9], GetPathPointX(current, GetNumPathPoints(current)-1), GetPathPointY(current, GetNumPathPoints(current)-1), GetCursorID(current)));
  }*/


  // calculate and draw behaviour of people currently in the room
  for (int trackID=0; trackID<GetNumTracks (); trackID++) 
  {      
    // if a new person enters the room a new entity is added to People
    if (people.size() <= GetCursorID(trackID)) {
      print(people.size());
      people.add(new People(colors[colorCounter++%9], images[colorCounter++%9], GetPathPointX(trackID, GetNumPathPoints(trackID)-1), GetPathPointY(trackID, GetNumPathPoints(trackID)-1), GetCursorID(trackID)));
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
        //println(GetCursorID(trackID) + " and " + GetCursorID(i) + " overlap");
      }
    }
  }
}