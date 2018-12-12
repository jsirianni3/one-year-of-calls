//PROJECT 2 - JOSHUA SIRIANNI

//CONTROL P5
import   controlP5.*;        ControlP5 cp5;
boolean  myo=true, myi=true, inc=true, out=true;

//ZOOM & PAN
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
int      cWeek, pWeek, i;                    //currentWeek, previousWeek, index
int   [] weekDuration = new int   [53];     //total call duration for 52 weeks 
float [] weekOUT =      new float [53];     //total outgoing for 52 weeks
float [] weekINC =      new float [53];     //total incoming for 52 weeks
float [] weekMYO =      new float [53];     //total my buddy outgoing for 52 weeks
float [] weekMYI =      new float [53];     //total my buddy incoming for 52 weeks

//POLAR COORDINATES
float    theta;
float    rI,     rO;
float    xI,     yI,     xO,     yO;
float    minOUT, minINC, minMYO, minMYI = MAX_FLOAT;
float    maxOUT, maxINC, maxMYO, maxMYI = MIN_FLOAT; 

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
          weekDuration[i] = weekDuration[i]+int(callDuration);
          
          //SET PREVIOUS WEEK TO CURENT WEEK FOR NEXT LOOP
          pWeek = cWeek;
        
          //PRINT WEEK CALCULATOR OUTPUT
        //println  ("week " + i + " " + "row " + row + " " + "duration " + weekDuration[i] + " " + "INC " + " " + weekINC[i]
        //          + " " + "MYI " + " " + weekMYI[i] + " " + "OUT " + " " + weekOUT[i] + " " + "MYO " + " " + weekMYO[i]);
    }
}

void draw() {  
  
  //INTERFACE ELEMENTS
  background(#060116);
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
        
          //CALCULATE MIN & MAX VALUES FOR EACH CALL TYPE ARRAY
          if   (  weekOUT[i] > maxOUT  ) {  maxOUT = weekOUT[i];  }
          if   (  weekOUT[i] < minOUT  ) {  minOUT = weekOUT[i];  }
        
          if   (  weekINC[i] > maxINC  ) {  maxINC = weekINC[i];  }
          if   (  weekINC[i] < minINC  ) {  minINC = weekINC[i];  }
                
          if   (  weekMYO[i] > maxMYO  ) {  maxMYO = weekMYO[i];  }
          if   (  weekMYO[i] < minMYO  ) {  minMYO = weekMYO[i];  }
        
          if   (  weekMYI[i] > maxMYI  ) {  maxMYI = weekMYI[i];  }
          if   (  weekMYI[i] < minMYI  ) {  minMYI = weekMYI[i];  }
      
          //SAVE REFERENCE POINT AND MOVE IT TO CENTER

          
          //RADIUS' OF POLAR PLOT
          rO =           360;
          rI =           290;
          
          //CALCULATE POLAR COORDINATES
          theta = i * (  (2*PI/52)  ); 
        
          //CONVERT POLAR COORDINATES TO CARTESIAN (our x and y for plotting)
          xO =        (  rO * cos(theta)  );
          yO =        (  rO * sin(theta)  );
          xI =        (  rI * cos(theta)  );
          yI =        (  rI * sin(theta)  );
          
       
          
          //DRAWING THE CIRCLES
          pushMatrix();
          if   (  out  ) {  noStroke();  fill(102, 45, 145, 80);  ellipse(xO, yO, map(weekOUT[i], minOUT, maxOUT, 10, 60), map(weekOUT[i], minOUT, maxOUT, 10, 60));  }
          else           {  noFill();                                                                                     }
          if   (  inc  ) {  noStroke();  fill(247, 147, 30, 80);  ellipse(xI, yI, map(weekINC[i], minINC, maxINC, 10, 60), map(weekINC[i], minINC, maxINC, 10, 60));  }
          else           {  noFill();                                                                                     }
          if   (  myo  ) {  noFill();    stroke(147, 39, 143);    ellipse(xO, yO, map(weekMYO[i], minMYO, maxMYO, 10, 60), map(weekMYO[i], minMYO, maxMYO, 10, 60));  }
          else           {  noStroke();                                                                                   }
          if   (  myi  ) {  noFill();    stroke(251, 176, 59);    ellipse(xI, yI, map(weekMYI[i], minMYI, maxMYI, 10, 60), map(weekMYI[i], minMYI, maxMYI, 10, 60));  }
          else           {  noStroke();                                                                                   }
          popMatrix();

          //CALLOUTS INC & MYI
          float  callOutInner = dist(xI, yI, mouseX - width/2, mouseY- height/2);
          if  (  callOutInner < 15  )  {
                 textAlign(NORMAL);
                 fill(255);
                 if      (  inc && myi  )  {  text("Week " + i + "\n" + int(weekINC[i]) + " INC" + "\n" + int(weekMYI[i]) + " MYI", mouseX - width/2 +20, mouseY- height/2);  }
                 else if (  inc         )  {  text("Week " + i + "\n" + int(weekINC[i]) + " INC", mouseX - width/2 +20, mouseY- height/2);                                    }
                 else if (  myi         )  {  text("Week " + i + "\n" + int(weekMYI[i]) + " MYI", mouseX - width/2 +20, mouseY- height/2);                                    }}
  
          //CALLOUTS OUT & MYO
          float  callOutOuter = dist(xO, yO, mouseX - width/2, mouseY- height/2);
          if  (  callOutOuter < 15  )  {
                 textAlign(NORMAL);
                 fill(255);
                 if      (  out && myo  )  {  text("Week " + i + "\n" + int(weekOUT[i]) + " OUT" + "\n" + int(weekMYO[i]) + " MYO", mouseX - width/2 +20, mouseY- height/2);  }
                 else if (  out         )  {  text("Week " + i + "\n" + int(weekOUT[i]) + " OUT", mouseX - width/2 +20, mouseY- height/2);                                    }
                 else if (  myo         )  {  text("Week " + i + "\n" + int(weekMYO[i]) + " MYO", mouseX - width/2 +20, mouseY- height/2);                                    }} 
  
  }                 
  //RESTORE SAVED REFERENCE POINT
  popMatrix();
  
  //PRINT POLAR COORDINATE OUTPUT
  //println("xI "+xI+" "+"xO "+xO+" "+"yI "+yI+" "+"yO "+yO);
  
}

//ASSIGNING ZOOM TO KEYS
void keyPressed() {
  if(key == CODED) {
    if      (keyCode == UP)    {zoom = constrain (zoom + speed, 0, 10);}
    else if (keyCode == DOWN)  {zoom = constrain(zoom - speed, 0, 10);}
  } if (key == ' ')       {
    zoom = 1.0; 
    originX = width/2;
    originY = height/2;
    }
}

//ASSIGNING PAN TO MOUSE DRAG
void mouseDragged() { 
  originX = originX + (mouseX - pmouseX);
  originY = originY + (mouseY - pmouseY);
}
