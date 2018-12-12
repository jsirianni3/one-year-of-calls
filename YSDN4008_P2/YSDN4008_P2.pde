//PROJECT 2 - JOSHUA SIRIANNI

//CONTROL P5
import   controlP5.*; ControlP5 cp5;
boolean  myo=true,    myi=true,      inc=true,     out=true;

//ZOOM & PAN
boolean  isUp=false,  isDown=false,  isLeft=false, isRight=false, isShift=false;
float    originX, originY;
float    zoom = 1.0;
float    speed = 0.18;

//FONTS
PFont    robotoMonoRegular;

//SHARED GLOBAL
Table    callData;

int      rowCount,    callMonth, callDay,  callTimeHours, callTimeMinutes;
String   callWeekday, callType,  callTime, callTimeCheck;
float    callDuration;

//WEEKS
int      cWeek,  pWeek, i;                   //currentWeek, previousWeek, index
int   [] weekDUR =      new int   [53];     //total call duration for 52 weeks
float [] weekOUT =      new float [53];     //total outgoing for 52 weeks
float [] weekINC =      new float [53];     //total incoming for 52 weeks
float [] weekMYO =      new float [53];     //total my buddy outgoing for 52 weeks
float [] weekMYI =      new float [53];     //total my buddy incoming for 52 weeks
                                            //we put 53 to avoid array out of bound because DEC 31st is technically on an extra week
//POLAR COORDINATES
float    theta;
float    rD,     rO,     rI;                           //radius duration,   radius outer,   radius inner
float    xD,     yD,     xO,     yO,     xI,     yI;   //xy durationCircle, xy outerCircle, xy innerCircle
float    minDUR, minOUT, minINC, minMYO, minMYI = MAX_FLOAT;
float    maxDUR, maxOUT, maxINC, maxMYO, maxMYI = MIN_FLOAT; 

//STATIC CALCULATIONS
void setup() {
  
  size  (  1200, 1080  );
  smooth(              );
  
  //SET THE DEFAULT ORIGIN
  originX = width/2;
  originY = height/2;
  
  //FONT BODY COPY
  robotoMonoRegular = createFont("RobotoMono-Regular.ttf", 16); textFont(robotoMonoRegular);
  
  callData = loadTable("all_year_data_combined.csv", "header");
  rowCount = callData.getRowCount();
  
  //INITIALIZE CP5
  cp5 = new ControlP5(this); 
  
    //TOGGLE OUT
    cp5.addToggle          (  "out"                    )  
      .setPosition         (  70,980                   )  
      .setSize             (  20,20                    )  
      .setColorActive      (  color(102, 45, 145)      )  
      .setColorForeground  (  color(102, 45, 145)      )  
      .setColorBackground  (  color(102, 45, 145, 90)  )
      ;   
    //TOGGLE INC
    cp5.addToggle          (  "inc"                    )
      .setPosition         (  95,980                   )
      .setSize             (  20,20                    )
      .setColorActive      (  color(253, 190, 44)      )
      .setColorForeground  (  color(253, 190, 44)      )
      .setColorBackground  (  color(253, 190, 44, 80)  )
      ;  
    //TOGGLE MYO
    cp5.addToggle          (  "myo"                    )
      .setPosition         (  120,980                  )
      .setSize             (  20,20                    )
      .setColorActive      (  color(102, 45, 145)      )
      .setColorForeground  (  color(102, 45, 145)      )
      .setColorBackground  (  color(102, 45, 145, 90)  )
      ;
    //TOGGLE MYI
    cp5.addToggle          (  "myi"                    )
      .setPosition         (  145,980                  )
      .setSize             (  20,20                    )
      .setColorActive      (  color(253, 190, 44)      )
      .setColorForeground  (  color(253, 190, 44)      )
      .setColorBackground  (  color(253, 190, 44, 80)  )
      ; 
     
  //TABLE DATA LOOP 
  for  (  int row = 0; row < rowCount; row++  ) {
          callMonth     = callData.getInt     (  row, "month"     );
          callDay       = callData.getInt     (  row, "day"       );
          callWeekday   = callData.getString  (  row, "weekday"   );
          callType      = callData.getString  (  row, "callType"  );
          callDuration  = callData.getInt     (  row, "duration"  );
          callTime      = callData.getString  (  row, "callTime"  );
          callTimeCheck = callTime.substring  (  1, 2             );
          
          //ASSIGN CURRENT WEEKDAYS TO INDEX VALUE
          if      (  callWeekday.equals("MON")  ) {
                     cWeek = 0;}   
          else if (  callWeekday.equals("TUE")  ) {
                     cWeek = 1;}   
          else if (  callWeekday.equals("WED")  ) {
                     cWeek = 2;} 
          else if (  callWeekday.equals("THU")  ) {
                     cWeek = 3;} 
          else if (  callWeekday.equals("FRI")  ) {
                     cWeek = 4;} 
          else if (  callWeekday.equals("SAT")  ) {
                     cWeek = 5;} 
          else if (  callWeekday.equals("SUN")  ) {
                     cWeek = 6;}
          
          //CHECK IF PREVIOUS WEEK IS GREATER THAN CURRENT WEEK, IF SO GO TO NEW INDEX
          if      (  pWeek > cWeek              ) {  i = i+1;  }
          
          //ADD UP CALLS OF EACH CALLTYPE IN WEEK               
          if      (  callType.equals("INC")  ||  callType.equals("IRM")  ) {
                     weekINC [i] = weekINC[i]+1;}
          else if (  callType.equals("MYI")  ||  callType.equals("RBM")  ) {
                     weekMYI [i] = weekMYI[i]+1;}
          else if (  callType.equals("OUT")                              ) {
                     weekOUT [i] = weekOUT[i]+1;}
          else if (  callType.equals("MYO")                              ) {
                     weekMYO [i] = weekMYO[i]+1;}
          
          //ADD UP CALL DURATIONS OF ALL WEEKDAYS IN WEEK
          weekDUR[i] = weekDUR[i]+int(callDuration);
          
          //SET PREVIOUS WEEK TO CURENT WEEK FOR NEXT LOOP
          pWeek = cWeek;
        
          //PRINT WEEK CALCULATOR OUTPUT
          println  ("week " + i + "  row " + row + "  duration " +  weekDUR[i] + "  INC " + weekINC[i]
                    + "  MYI " + weekMYI[i] + "  OUT " + weekOUT[i] + "  MYO " + weekMYO[i]);
    }

}

void draw() {  
  
  //INTERFACE ELEMENTS
  background(#060116);
  textLeading(22);
  smooth();

  
  pushMatrix();
  translate(originX, originY);
  scale(zoom);
  
  textAlign(CENTER);
  fill(#46416B);

  
  //INDEX CYCLING LOOP
  for  (  i = 0; i < 52; i++  ) {     
          //EXTRACT HH & MM FROM FORMAT XX:XX IN TABLE
          if   (  callTimeCheck.equals(":") == true  )   {
                  callTimeHours   = int(callTime.substring(0, 1)) ;
                  callTimeMinutes = int(callTime.substring(2))    ;}
          else {
                  callTimeHours   = int(callTime.substring(0, 2)) ;
                  callTimeMinutes = int(callTime.substring(3))    ;}
        
          //CALCULATE MIN & MAX VALUES FOR DURATION & CALL TYPE ARRAYS
          if   (  weekDUR[i] > maxDUR  ) {  maxDUR = weekDUR[i];  }
          if   (  weekDUR[i] < minDUR  ) {  minDUR = weekDUR[i];  }
          
          if   (  weekOUT[i] > maxOUT  ) {  maxOUT = weekOUT[i];  }
          if   (  weekOUT[i] < minOUT  ) {  minOUT = weekOUT[i];  }
        
          if   (  weekINC[i] > maxINC  ) {  maxINC = weekINC[i];  }
          if   (  weekINC[i] < minINC  ) {  minINC = weekINC[i];  }
                
          if   (  weekMYO[i] > maxMYO  ) {  maxMYO = weekMYO[i];  }
          if   (  weekMYO[i] < minMYO  ) {  minMYO = weekMYO[i];  }
        
          if   (  weekMYI[i] > maxMYI  ) {  maxMYI = weekMYI[i];  }
          if   (  weekMYI[i] < minMYI  ) {  minMYI = weekMYI[i];  }
      
          //RADIUS' OF POLAR PLOT
          rD =           360;
          rO =           360;
          rI =           290;
          
          //CALCULATE POLAR COORDINATES
          theta = i * (  (2*PI/52)  ); 
        
          //CONVERT POLAR COORDINATES TO CARTESIAN (our x and y for plotting)
          xD =        ( (rD * cos(theta)) + (map(weekDUR[i], minDUR, maxDUR, 10, 60) * cos(theta))  );   //To calculate polar x offsets for duration 
          yD =        ( (rD * sin(theta)) + (map(weekDUR[i], minDUR, maxDUR, 10, 60) * sin(theta))  );   //To calculate polar y offsets for duration
          xO =        (  rO * cos(theta)  );
          yO =        (  rO * sin(theta)  );
          xI =        (  rI * cos(theta)  );
          yI =        (  rI * sin(theta)  );
          
          //filter(BLUR, 6);
          pushMatrix();
          //DRAWING THE CIRCLES
          if   (  out  ) {  noStroke();  fill(102, 45, 145, 130);  ellipse(xO, yO, map(weekOUT[i], minOUT, maxOUT, 10, 60), map(weekOUT[i], minOUT, maxOUT, 10, 60));  }
          else           {  noFill();    }
          if   (  inc  ) {  noStroke();  fill(247, 147, 30, 130);  ellipse(xI, yI, map(weekINC[i], minINC, maxINC, 10, 60), map(weekINC[i], minINC, maxINC, 10, 60));  }
          else           {  noFill();    }
          if   (  myo  ) {  noFill();    stroke(147, 39, 143);     ellipse(xO, yO, map(weekMYO[i], minMYO, maxMYO, 10, 60), map(weekMYO[i], minMYO, maxMYO, 10, 60));  }
          else           {  noStroke();  }
          if   (  myi  ) {  noFill();    stroke(251, 176, 59);     ellipse(xI, yI, map(weekMYI[i], minMYI, maxMYI, 10, 60), map(weekMYI[i], minMYI, maxMYI, 10, 60));  }
          else           {  noStroke();  }
          
          //DRAWING THE DURATION CIRCLES
          fill(255);
          noStroke();
          ellipse(xD, yD, 5, 5);
          noFill();
          
          //DRAWING THE DURATION ARCS
          float c = (2*PI/52);
          float d = 2*(2*PI/52);
          stroke(255);
          arc(xD, yD, 25, 25, c, d);
          noStroke();
          
          
          popMatrix();

          //CALLOUTS DURATION
          float  callOutDuration = dist(xD, yD, mouseX - width/2, mouseY- height/2);
          if  (  callOutDuration < 5  )  {
                 textAlign(NORMAL);
                 fill(255);
                 text("Duration " + weekDUR[i], mouseX - width/2 +20, mouseY- height/2);  } 

          //CALLOUTS OUT & MYO
          float  callOutOuter = dist(xO, yO, mouseX - width/2, mouseY- height/2);
          if  (  callOutOuter < 15  )  {
                 textAlign(NORMAL);
                 fill(255);
                 if      (  out && myo  )  {  text("Week " + i + "\n" + int(weekOUT[i]) + " OUT" + "\n" + int(weekMYO[i]) + " MYO", mouseX - width/2 +20, mouseY- height/2);  }
                 else if (  out         )  {  text("Week " + i + "\n" + int(weekOUT[i]) + " OUT", mouseX - width/2 +20, mouseY- height/2);                                    }
                 else if (  myo         )  {  text("Week " + i + "\n" + int(weekMYO[i]) + " MYO", mouseX - width/2 +20, mouseY- height/2);                                    }} 

          //CALLOUTS INC & MYI
          float  callOutInner = dist(xI, yI, mouseX - width/2, mouseY- height/2);
          if  (  callOutInner < 15  )  {
                 textAlign(NORMAL);
                 fill(255);
                 if      (  inc && myi  )  {  text("Week " + i + "\n" + int(weekINC[i]) + " INC" + "\n" + int(weekMYI[i]) + " MYI", mouseX - width/2 +20, mouseY- height/2);  }
                 else if (  inc         )  {  text("Week " + i + "\n" + int(weekINC[i]) + " INC", mouseX - width/2 +20, mouseY- height/2);                                    }
                 else if (  myi         )  {  text("Week " + i + "\n" + int(weekMYI[i]) + " MYI", mouseX - width/2 +20, mouseY- height/2);                                    }}
          
          //IF SHIFT + ARROW KEY PRESSED MOVE ORIGIN
          if  (  isShift && isUp     )  {  originY = originY + speed;  }
          if  (  isShift && isDown   )  {  originY = originY - speed;  }
          if  (  isShift && isLeft   )  {  originX = originX + speed;  }
          if  (  isShift && isRight  )  {  originX = originX - speed;  }
  }                 
  //RESTORE SAVED REFERENCE POINT
  popMatrix();
  
  //PRINT POLAR COORDINATE OUTPUT
  //println("xI "+xI+" "+"xO "+xO+" "+"yI "+yI+" "+"yO "+yO);
  
}

//ASSIGNING ZOOM TO UP/DOWN, LISTENING FOR BOOLEAN AND CHANGING ARROW KEY FUNCTIONALITY TO PAN
void keyPressed() {
  if(key == CODED)                                      {
    if      (  keyCode == UP    && isShift == false  )  {  zoom = constrain (zoom + speed, 0, 10);               }
    else if (  keyCode == DOWN  && isShift == false  )  {  zoom = constrain (zoom - speed, 0, 10);               }} 
    if      (  key == ' ')                              {  zoom = 1.0;  originX = width/2;  originY = height/2;  }  
    if      (  keyCode == SHIFT && isShift == false  )  {  isShift = true;                                       }
    if      (  keyCode == UP    && isUp == false     )  {  isUp = true;                                          }
    if      (  keyCode == DOWN  && isDown == false   )  {  isDown = true;                                        }
    if      (  keyCode == LEFT  && isLeft == false   )  {  isLeft = true;                                        }
    if      (  keyCode == RIGHT && isRight == false  )  {  isRight = true;                                       }}

//HAS KEY BEEN RELEASED?
void keyReleased() {
  if  (       keyCode  == SHIFT) {  isShift = false;  }
  if  (  char(keyCode) == UP)    {  isUp = false;     }
  if  (  char(keyCode) == DOWN)  {  isDown = false;   }
  if  (  char(keyCode) == LEFT)  {  isLeft = false;   }
  if  (  char(keyCode) == RIGHT) {  isRight = false;  }
}

//ASSIGNING ZOOM TO SCROLL
void mouseWheel(MouseEvent scroll) {
  if       (  scroll.getCount() > 1  ) {  zoom = constrain (zoom - speed, 0, 10);  }
  else if  (  scroll.getCount() < 1  ) {  zoom = constrain (zoom + speed, 0, 10);  }
}


//ASSIGNING PAN TO MOUSE DRAG
void mouseDragged() { 
  originX = originX + (mouseX - pmouseX);
  originY = originY + (mouseY - pmouseY);
}
