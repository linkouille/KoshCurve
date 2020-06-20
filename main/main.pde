//Variables:
int margin = 0;
int hauteur = 100;
int bgColor = #1B2631;

//Lines Option
int[] lineColor = {#2E86C1,#229954,#F1C40F, #D35400,#C0392B,#641E16};
int lineWeight = 1;

//Point option
int pointColor = #FFFFFF;
int pointWeight = 3;

//Plafond de récursivité
int itteration = 6;

//Should display point and Line
boolean showPoint = false;
boolean showLine = true;

//Initial segment
Segment s;

//All Segments in the scene
Segment[] koshCurve;

void setup(){
  size(600,600);  
  InitKosh();
  
}

void InitKosh(){
  //Init and Generate a new Kosh Curve
  s = new Segment();
  //We setup An Initial Horizontal Line
  s.points[0] = new Point(margin,height - hauteur);
  s.points[1] = new Point( width - margin,height - hauteur);
  
  koshCurve = new Segment[1];
  koshCurve[0] = s;  
  
  //Start recursive call
  KoshCurveAlgo(s,itteration);
  
}

void draw(){
  background(bgColor);
  
  for(int i = 0; i < koshCurve.length; i++){
    if(showLine){
      //Display Line
      stroke(lineColor[i%6]);     
      strokeWeight(lineWeight);
      koshCurve[i].ShowLine();      
    }
    
    if(showPoint){
      //Display Point
      stroke(pointColor);
      strokeWeight(pointWeight);
      koshCurve[i].ShowPoints();
    }   
    
  }
  
}

void keyPressed(){  
  if(key == CODED){
    //If we change itteration value we Regenerate Kosh Curve
    if(keyCode == UP){
      itteration = ClampValue(itteration + 1,0,8);
      InitKosh();
      delay(1);
    }
    if(keyCode == DOWN){
      itteration = ClampValue(itteration - 1,0,8);
      InitKosh();
      delay(1);
    }
  }
  
}

int ClampValue(int val, int min, int max){
  //Clamp a value between two value
  return val > max ? max : (val < min ? min : val);
}

void KoshCurveAlgo(Segment initS, int itt){
  //Recursive Fonction wich generate
  if(itt == 0){
     return; 
  }
  
  //Compute Segment Points
  Point p1 = new Point(initS.points[0].x,initS.points[0].y);
  
  Point p2 = new Point(initS.points[0].x + round((initS.points[1].x - initS.points[0].x)* 1/3) , initS.points[0].y + round((initS.points[1].y - initS.points[0].y)* 1/3));
  
  Point p3 = new Point(initS.points[0].x + round((initS.points[1].x - initS.points[0].x)* 2/3) , initS.points[0].y + round((initS.points[1].y - initS.points[0].y)* 2/3));
  
  Point p4 = new Point(initS.points[1].x,initS.points[1].y);
  
  //Generate Side segment
  Segment s1 = new Segment(p1,p2);
  Segment s3 = new Segment(p3,p4);
  
  //Remove precedent the segment we splited in 3
  koshCurve = removeSeg(koshCurve, initS);
  
  //Add new Segment to the scene segment Buffer
  koshCurve = (Segment[])append(koshCurve,s3);
  koshCurve = (Segment[])append(koshCurve,s1);
  
  //Make equilateral triangle from p2 and p3
  int x, y;
  float h,l;
  
  //Edge size of the triangle
  l = dist(p2.x, p2.y, p3.x, p3.y);
  //Height of the triangle
  h = l * sqrt(3)/2;
  
  Point midPoint = new Point((p2.x + p3.x)/2,(p2.y + p3.y)/2);
  
  float[] dir = {p3.x - p2.x,p3.y - p2.y}; //vecteur directeur de la droite normalisé  
  float[] norm = {dir[1]/l,-dir[0]/l}; //vecteur normal du coté
  
  x = round(norm[0] * h);
  y = round(norm[1] * h);
  
  Point sommet = new Point(midPoint.x + x, midPoint.y + y);
  
  Segment edge1 = new Segment(p2,sommet);
  Segment edge2 = new Segment(sommet,p3);
  
  koshCurve = (Segment[])append(koshCurve,edge1);
  koshCurve = (Segment[])append(koshCurve,edge2);
  
  //Itter in all edges
  KoshCurveAlgo(s1, itt -1);
  KoshCurveAlgo(edge1, itt -1);  
  KoshCurveAlgo(edge2, itt -1);
  KoshCurveAlgo(s3, itt -1);
  
  return;
  
}

Segment[] removeSeg(Segment[] l, Segment s){
  // Remove a segment from teh scene buffer
  for(int i = 0; i < l.length; i++){
    if(l[i] == s){
      Segment temp = l[l.length -1];
      l[l.length -1] = l[i];
      l[i] = temp;      
      l = (Segment[])shorten(l);
      return l;
    
    }
  }  
  return l;  
}
