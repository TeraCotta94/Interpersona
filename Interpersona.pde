// Version 4.1

PFont font;
int scaleFactor = 4;
int windowWidth = 3030/scaleFactor;   // for real Deep Space this should be 3030
int windowHeight = 3712/scaleFactor;  // for real Deep Space this should be 3712
int wallHeight = 1914/scaleFactor;    // for real Deep Space this should be 1914 (Floor is 1798)

ArrayList<People> people = new ArrayList<People>();    // list of people in the room
int counter = 0;    // counter for the fade out

int colorCounter = 0;
int[][] colors = new int[][]{ {0, 190, 255},     // light blue
                              {150, 0, 255},     // purple
                              {255, 255, 0},     // yellow
                              {150, 255, 0},     // lime
                              {255, 60, 0},      // red
                              {0, 255, 180},     // turquois
                              {255, 180, 0},     // orange                              
                              {0, 50, 255},      // blue
                              {240, 0, 220},     // pink
                              {0, 180, 0}};      // green
                              

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
    if (people.size() <= GetCursorID(trackID)) {
      print(people.size());
      people.add(new People(colors[colorCounter++%10], GetPathPointX(trackID, GetNumPathPoints(trackID)-1), GetPathPointY(trackID, GetNumPathPoints(trackID)-1), GetCursorID(trackID)));
    } 
    // otherwise the person is updated
    else {
      people.get(GetCursorID(trackID)).update(GetPathPointX(trackID, GetNumPathPoints(trackID)-1), GetPathPointY(trackID, GetNumPathPoints(trackID)-1));
    }
  }
}