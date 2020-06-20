class Point
{
  int x, y;
  Point(int posX,int posY){
    x = posX;
    y = posY;
  }
  
  void PrintCord(){
    print("x:",x," y:",y,"\n");
  }
  
  void Show(){
   point(x,y);
  }
  
}

class Segment
{
  
  Point[] points;
  int len;
  
  Segment(Point[] p,int l){
    points = p;
    len = l;    
  }
  
  Segment(int l){
    points = new Point[l];
    len = l;
  }
  
  Segment(Point p1, Point p2){
    points = new Point[2];
    len = 2;
    points[0] = p1;
    points[1] = p2;
  }
  
  Segment(){
    points = new Point[2];
    len = 2;
  }
  
  float Length(){
    float out = 0;
    
    for(int i = 1; i < len; i++){
      out += dist(points[i-1].x, points[i-1].y, points[i].x, points[i].y);
    }
    return out;
  }
  
  void ShowLine(){
    
    for(int i = 1; i < len; i++){
      line(points[i-1].x, points[i-1].y, points[i].x, points[i].y);
    }
  }
  
  void ShowPoints(){
    for(int i = 0; i < len; i++){
      points[i].Show();
    }
  }
  
}
