//PROJECT 2 - JOSHUA SIRIANNI

//CONTROL P5
import   controlP5.*;  ControlP5 cp5one;  ControlP5 cp5two;
boolean  myo=true,  myi=true,  inc=true,  out=true,  info=false;

//TOGGLES
PImage   tOut,  tMyo,  tInc,  tMyi,  tDis,  tDisO,  tOpen,  tClose;

//UI
PShape   mLabels;
PImage   fLabels,  title, infopane;

//DURATION SLIDER
Range    rangeDUR, rangeTIME;

//DIAMETER SPACING
int      spacing = 0;

//TIME SLIDER
int   [] weekTime = new int [53];

//EXECUTIVE REPORT
float    totalDUR, totalCALL;

//ZOOM & PAN
float    zoom  = 1.0;
float    speed = 0.18;
float    originX,     originY;
boolean  isUp=false,  isDown=false,  isLeft=false, isRight=false, isShift=false;

//FONTS
PFont    robotoMS,    robotoML;

//SHARED GLOBAL
Table    callData;
int      rowCount,    callMonth, callDay,  callTimeHours, callTimeMinutes;
String   callWeekday, callType,  callTime, callTimeCheck;
float    callDuration;

//WEEKS
int      cWeek,  pWeek, i;                  //currentWeek, previousWeek, index
float [] weekDUR =      new float [53];     //total call duration for 52 weeks
float [] weekOUT =      new float [53];     //total outgoing for 52 weeks
float [] weekINC =      new float [53];     //total incoming for 52 weeks
float [] weekMYO =      new float [53];     //total my buddy outgoing for 52 weeks
float [] weekMYI =      new float [53];     //total my buddy incoming for 52 weeks
                                            //---we put 53 to avoid array out of bound because DEC 31st is technically on an extra week
//POLAR COORDINATES
float    theta;
float    rD,     rO,     rI;                                 //radius duration,   radius outer,   radius inner
float    xD,     yD,     xO,     yO,     xI,     yI;         //xy durationCircle, xy outerCircle, xy innerCircle
float    minDUR, minR, minH, minOUT, minINC, minMYO, minMYI = MAX_FLOAT;
float    maxDUR, maxR, maxH, maxOUT, maxINC, maxMYO, maxMYI = MIN_FLOAT; 

//STATIC CALCULATIONS
void setup() { 
  size                  (  1200, 1080                              );
  smooth                (                                          );
  frameRate             (  20                                      );
  
  //SET THE DEFAULT ORIGIN
  originX  = width/2;
  originY  = height/2;
  
  //FONT BODY COPY
  robotoMS = createFont (  "RobotoMono-Regular.ttf", 18            );
  robotoML = createFont (  "RobotoMono-Light.ttf", 67              ); 
  
  //LOAD TABLE DATA
  callData = loadTable  (  "all_year_data_combined.csv", "header"  );
  rowCount = callData      .getRowCount();
  
  //LOAD IMAGES
  title    = loadImage  (  "title.png"                             );
  mLabels  = loadShape  (  "mlabels.svg"                           );
  fLabels  = loadImage  (  "flabels.png"                           );
  infopane = loadImage  (  "infopane.png"                          );
  tOpen    = loadImage  (  "topen.png"                             );
  tClose   = loadImage  (  "tclose.png"                            );
  tOut     = loadImage  (  "tout.png"                              );
  tMyo     = loadImage  (  "tmyo.png"                              );
  tInc     = loadImage  (  "tinc.png"                              );
  tMyi     = loadImage  (  "tmyi.png"                              );
  tDis     = loadImage  (  "tdis.png"                              );
  tDisO    = loadImage  (  "tdiso.png"                             );

  //TABLE DATA LOOP 
  for  (  int row = 0; row < rowCount; row++  ) {
          callMonth     = callData.getInt     (  row, "month"      );
          callDay       = callData.getInt     (  row, "day"        );
          callWeekday   = callData.getString  (  row, "weekday"    );
          callType      = callData.getString  (  row, "callType"   );
          callDuration  = callData.getInt     (  row, "duration"   );
          callTime      = callData.getString  (  row, "callTime"   );
          callTimeCheck = callTime.substring  (  1, 2              );
          
          //EXTRACT HH & MM FROM FORMAT XX:XX IN TABLE
          if      (  callTimeCheck.equals(":") == true  )   {
                     callTimeHours   = int(callTime.substring(0, 1) );
                     callTimeMinutes = int(callTime.substring(2))   ;}
          else    {
                     callTimeHours   = int(callTime.substring(0, 2) );
                     callTimeMinutes = int(callTime.substring(3))   ;}
          
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
                     weekINC[i] = weekINC[i]+1;}
          else if (  callType.equals("MYI")  ||  callType.equals("RBM")  ) {
                     weekMYI[i] = weekMYI[i]+1;}
          else if (  callType.equals("OUT")                              ) {
                     weekOUT[i] = weekOUT[i]+1;}
          else if (  callType.equals("MYO")                              ) {
                     weekMYO[i] = weekMYO[i]+1;}

          //ADD UP CALL DURATIONS OF ALL WEEKDAYS
          weekDUR[i] = weekDUR[i]  +  int(callDuration);
          
          //SET PREVIOUS WEEK TO CURENT WEEK FOR NEXT LOOP
          pWeek      = cWeek;
          
          weekTime[i] = callTimeHours + callTimeMinutes /60;
          
          //ADD UP CALL DURATIONS OF ALL WEEKS      
          totalDUR   = totalDUR    +  int(callDuration);
          
          //PRINT WEEK CALCULATOR OUTPUT
          //println  ("week " + i + "  row " + row + "  duration " +  weekDUR[i] + "  INC " + weekINC[i]
          //          + "  MYI " + weekMYI[i] + "  OUT " + weekOUT[i] + "  MYO " + weekMYO[i]); 
  }
  
  //STATIC WEEK LOOP
  for  (  i = 0; i < 52; i++  ) {
          //CALCULATE MIN & MAX VALUES FOR TIME, DURATION & CALL TYPE 
          if   (  weekTime[i] > maxH   ) {  maxH = weekTime[i];   }
          if   (  weekTime[i] < minH   ) {  minH = weekTime[i];   }
          
          if   (  weekDUR[i] > maxR    ) {  maxR = weekDUR[i];    }
          if   (  weekDUR[i] < minR    ) {  minR = weekDUR[i];    }
          
          if   (  weekOUT[i] > maxOUT  ) {  maxOUT = weekOUT[i];  }
          if   (  weekOUT[i] < minOUT  ) {  minOUT = weekOUT[i];  }
        
          if   (  weekINC[i] > maxINC  ) {  maxINC = weekINC[i];  }
          if   (  weekINC[i] < minINC  ) {  minINC = weekINC[i];  }
                
          if   (  weekMYO[i] > maxMYO  ) {  maxMYO = weekMYO[i];  }
          if   (  weekMYO[i] < minMYO  ) {  minMYO = weekMYO[i];  }
        
          if   (  weekMYI[i] > maxMYI  ) {  maxMYI = weekMYI[i];  }
          if   (  weekMYI[i] < minMYI  ) {  minMYI = weekMYI[i];  }
          
          maxH   = 24;
          maxDUR = maxR;  //Create a copy of maxDUR for the range slider
          minDUR = minR;  //Create a copy of minDUR for the range slider
     
          //ADD UP TOTAL CALLS OF EVERY TYPE
          totalCALL  = totalCALL  +  weekINC[i] + weekMYI[i] + weekOUT[i] + weekMYO[i];      
  }
  
  //INITIALIZE CP5
  cp5one = new ControlP5(this);
  cp5two = new ControlP5(this);
    //TOGGLE OUT
    cp5one.addToggle       (  "out"                    )
      .setImages           (  tDis, tOut               )
      .setPosition         (  525,970                  )  
      .setSize             (  40,40                    );
      
    //TOGGLE MYO
    cp5one.addToggle       (  "myo"                    )
      .setImages           (  tDisO, tMyo              )
      .setPosition         (  565,970                  )
      .setSize             (  40,40                    );
      
    //TOGGLE INC
    cp5one.addToggle       (  "inc"                    )
      .setImages           (  tDis, tInc               )
      .setPosition         (  605,970                  )
      .setSize             (  40,40                    );
  
      
    //TOGGLE MYI
    cp5one.addToggle       (  "myi"                    )
      .setImages           (  tDisO, tMyi              )
      .setPosition         (  645,970                  )
      .setSize             (  40,40                    );
      
    //SLIDER DURATION
    rangeDUR = cp5one.addRange(  "duration"            )
      .setBroadcast        (  false                    ) 
      .setPosition         (  950,970                  )
      .setSize             (  200,30                   )
      .setHandleSize       (  10                       )
      .setDecimalPrecision (  0                        )
      .setRange            (  minR,maxR                )
      .setRangeValues      (  minR,maxR                )
      .setBroadcast        (  true                     )
      .setColorForeground  (  color(#282454)           )
      .setColorBackground  (  color(28, 20, 60)        )
      .setColorActive      (  color(#282454)           )
      .setLabel            (  ""                       );
    
    //SLIDER TIME
    rangeTIME =cp5one.addRange(  "time"                )
      .setBroadcast        (  false                    ) 
      .setPosition         (  50,970                   )
      .setSize             (  200,30                   )
      .setHandleSize       (  10                       )
      .setDecimalPrecision (  0                        )
      .setRange            (  minH,maxH                )
      .setRangeValues      (  minH,maxH                )
      .setBroadcast        (  true                     )
      .setColorForeground  (  color(#282454)           )
      .setColorBackground  (  color(28, 20, 60)        )
      .setColorActive      (  color(#282454)           )
      .setLabel            (  ""                       );
      
    //SLIDER SPACING  
    cp5one.addSlider       (  "spacing"                )
     .setPosition          (  950, 900                 )
     .setSize              (  200,12                   )
     .setRange             (  -5, 5                    )
     .setDecimalPrecision  (  1                        )
     .setColorForeground   (  color(#282454)           )
     .setColorBackground   (  color(28, 20, 60)        )
     .setColorActive       (  color(#282454)           )
     .setLabel             (  ""                       );
      
    //TOGGLE INFO
    cp5two.addToggle       (  "info"                   )
      .setImages           (  tOpen, tClose            )
      .setPosition         (  50, 50                   )
      .setSize             (  40,40                    );
}

void draw() {   
  //SETUP
  background  ( #09041E                   );
  smooth      (                           );
  textLeading (  22                       );
  textAlign   (  CENTER                   );

  
  //UNSCALABLE UI ELEMENTS
  if (zoom <= 1) {        
  image       (  title, 600-305/2,  55    );
  image       (  fLabels, -1, 920         );
  }
  
  //SET COORDINATES TO CENTER
  pushMatrix  (                           );
  translate   (  originX, originY-15      );
  scale       (  zoom                     );
  
  //SCALABLE UI ELEMENTS
  shape       (  mLabels,-600, -540       );

  //EXECUTIVE REPORT
  fill        (  #C3BEEA                  );
  textFont    (  robotoML                 );
  text        (  int(totalDUR ), 10, 80   );
  totalDUR = 0;
  text        (  int(totalCALL), 10, -80  );
  totalCALL = 0;
 
  //EXECUTIVE REPORT SUBTEXT
  textFont    (  robotoMS                 );
  fill        (  #605599                  );
  text        (  "CALLS", 10, -50         );
  text        (  "MINUTES", 10, 110       );

  //DYNAMIC WEEK LOOP
  for  (  i = 0; i < 52; i++  ) {   

          //RADIUS' OF POLAR PLOT
          rD =           320;
          if (spacing < 0) {rD = 320 + abs(spacing)*10;} //INCREASE SPACING OF DURATION WHEN SPACING FILTER IS NEGATIVE
          
          rO =           300 - spacing;
          rI =           290 + spacing;
          
          //CALCULATE POLAR COORDINATES
          theta = i * ( (2*PI/52)         ); 
          
          //SAVE CURRENT PAN COORDINATES FOR DRAWING
          pushMatrix();
        
          //CONVERT POLAR COORDINATES TO CARTESIAN (our x and y for plotting)
          xD =        ( (rD * cos(theta)  ) + (  map(weekDUR[i], minDUR, maxDUR, 10, 60) * cos(theta))  );  //To calculate polar x offsets for duration 
          yD =        ( (rD * sin(theta)  ) + (  map(weekDUR[i], minDUR, maxDUR, 10, 60) * sin(theta))  );  //To calculate polar y offsets for duration
          xO =        (  rO * cos(theta)  );
          yO =        (  rO * sin(theta)  );
          xI =        (  rI * cos(theta)  );
          yI =        (  rI * sin(theta)  );
          
          //DRAW BASED ON FILTER SETTINGS
          if (  weekTime[i] >= minH && weekTime[i] <= maxH  )  {
          if (  weekDUR[i]  >= minR && weekDUR[i]  <= maxR  )  {
                
               //RECALCULATE TOTAL CALLS AND TOTAL DURATION
               totalDUR   =   totalDUR    +   weekDUR[i];
               totalCALL  =   totalCALL   +   weekINC[i]  +  weekMYI[i]  +  weekOUT[i]  +  weekMYO[i];

               if (spacing <= 0) {
                   //DRAWING THE CIRCLES ALIGNED TO A BASELINE
                   if   (  out  ) {  noStroke();  fill(102, 45, 145, 130);  
                                                  ellipse  (  xO + map(weekOUT[i], minOUT, maxOUT, 10, 60) *cos(theta)/2, 
                                                              yO + map(weekOUT[i], minOUT, maxOUT, 10, 60) *sin(theta)/2, 
                                                                   map(weekOUT[i], minOUT, maxOUT, 10, 60), 
                                                                   map(weekOUT[i], minOUT, maxOUT, 10, 60)               );}
                   else           {  noFill()                                                                             ;}
                   
                   
                   if   (  inc  ) {  noStroke();  fill(247, 147, 30, 130);  
                                                  ellipse  (  xI - map(weekINC[i], minINC, maxINC, 10, 60) *cos(theta)/2, 
                                                              yI - map(weekINC[i], minINC, maxINC, 10, 60) *sin(theta)/2, 
                                                                   map(weekINC[i], minINC, maxINC, 10, 60), 
                                                                   map(weekINC[i], minINC, maxINC, 10, 60)               );}
                   else           {  noFill()                                                                             ;}
                   
                   
                   if   (  myo  ) {  noFill();    stroke(147, 39, 143);     
                                                  ellipse  (  xO + map(weekMYO[i], minMYO, maxMYO, 10, 60) *cos(theta)/2, 
                                                              yO + map(weekMYO[i], minMYO, maxMYO, 10, 60) *sin(theta)/2, 
                                                                   map(weekMYO[i], minMYO, maxMYO, 10, 60), 
                                                                   map(weekMYO[i], minMYO, maxMYO, 10, 60)               );}
                   else           {  noStroke()                                                                           ;}  
                   
                   
                   if   (  myi  ) {  noFill();    stroke(251, 176, 59);     
                                                  ellipse  (  xI - map(weekMYI[i], minMYI, maxMYI, 10, 60) *cos(theta)/2, 
                                                              yI - map(weekMYI[i], minMYI, maxMYI, 10, 60) *sin(theta)/2, 
                                                                   map(weekMYI[i], minMYI, maxMYI, 10, 60), 
                                                                   map(weekMYI[i], minMYI, maxMYI, 10, 60));               }
                   else           {  noStroke()                                                                           ;}}
                   
                   
               else if (spacing > 0) {
                   //DRAWING THE CIRCLES ALIGNED CENTER
                   if   (  out  ) {  noStroke();  fill(102, 45, 145, 130);  
                                                  ellipse  (  xO, 
                                                              yO, 
                                                                  map(weekOUT[i], minOUT, maxOUT, 10, 60), 
                                                                  map(weekOUT[i], minOUT, maxOUT, 10, 60)                );}
                   else           {  noFill()                                                                             ;}
                   
                   
                   if   (  inc  ) {  noStroke();  fill(247, 147, 30, 80);  
                                                  ellipse  (  xI, 
                                                              yI, 
                                                                  map(weekINC[i], minINC, maxINC, 10, 60), 
                                                                  map(weekINC[i], minINC, maxINC, 10, 60)                );}
                   else           {  noFill()                                                                             ;}
                   
                   
                   if   (  myo  ) {  noFill();    stroke(147, 39, 143);     
                                                  ellipse  (  xO, 
                                                              yO, 
                                                                  map(weekMYO[i], minMYO, maxMYO, 10, 60), 
                                                                  map(weekMYO[i], minMYO, maxMYO, 10, 60)                );}
                   else           {  noStroke()                                                                           ;}
                   
                   
                   if   (  myi  ) {  noFill();    stroke(251, 176, 59);     
                                                  ellipse  (  xI, 
                                                              yI, 
                                                                  map(weekMYI[i], minMYI, maxMYI, 10, 60), 
                                                                  map(weekMYI[i], minMYI, maxMYI, 10, 60)                );}
                   else           {  noStroke()                                                                           ;}}

               //DRAWING THE DURATION CIRCLES
               fill    (  255           );
               noStroke(                );
               rect    (  xD, yD, 5, 5  );
               noFill  (                );
                
               ////NOT IMPLIMENTED YET - DRAWING THE DURATION ARCS
               //float c = (2*PI/52);
               //float d = 2*(2*PI/52);
               //stroke(255);
               //arc(xD, yD, 25, 25, c, d);
               //noStroke();

               //CALLOUTS DURATION
               float  callOutDuration = dist(xD + 10 *cos(theta), yD + 10 *sin(theta), mouseX - width/2, mouseY- height/2          );
               if  (  callOutDuration < 20   )  {
                      textAlign(NORMAL       );
                      fill    (  255         );
                      text    (  "Week " + (i+1) + "\n" + int(weekDUR[i]) + " minutes", mouseX - width/2 +20, mouseY- height/2  )  ;} 
                       
               //CALLOUTS OUT & MYO
               float  callOutOuter = dist(xO + 15 *cos(theta) - spacing, yO + 15 *sin(theta) - spacing, mouseX - width/2, mouseY- height/2);
               if  (  callOutOuter < 15      )  {
                      textAlign(NORMAL       );
                      fill    (  255         );
                      if      (  out && myo  )  {  text("Week " + (i+1) + "\n" + int(weekOUT[i]) + " OUT" + "\n" + int(weekMYO[i]) + " MYO", mouseX - width/2 +20, mouseY- height/2);}
                      else if (  out         )  {  text("Week " + (i+1) + "\n" + int(weekOUT[i]) + " OUT", mouseX - width/2 +20, mouseY- height/2)                                  ;}
                      else if (  myo         )  {  text("Week " + (i+1) + "\n" + int(weekMYO[i]) + " MYO", mouseX - width/2 +20, mouseY- height/2)                                  ;}} 
    
               //CALLOUTS INC & MYI
               float  callOutInner = dist(xI - 15 *cos(theta) +spacing, yI - 15 *sin(theta)+spacing, mouseX - width/2, mouseY- height/2);
               if  (  callOutInner < 15      )  {
                      textAlign( NORMAL      );
                      fill    (  255         );
                      if      (  inc && myi  )  {  text("Week " + (i+1) + "\n" + int(weekINC[i]) + " INC" + "\n" + int(weekMYI[i]) + " MYI", mouseX - width/2 +20, mouseY- height/2);}
                      else if (  inc         )  {  text("Week " + (i+1) + "\n" + int(weekINC[i]) + " INC", mouseX - width/2 +20, mouseY- height/2)                                  ;}
                      else if (  myi         )  {  text("Week " + (i+1) + "\n" + int(weekMYI[i]) + " MYI", mouseX - width/2 +20, mouseY- height/2)                                  ;}}
                      
                //PRINT WEEK CALCULATOR OUTPUT
                //println  ("week " + i + "  duration " +  weekDUR[i] + "  INC " + weekINC[i]
                //    + "  MYI " + weekMYI[i] + "  OUT " + weekOUT[i] + "  MYO " + weekMYO[i]);
          }
        }

          //RESTORE ORIGINAL PAN COORDINATES AFTER DRAWING
          popMatrix();

          //IF SHIFT + ARROW KEY PRESSED MOVE ORIGIN
          if  (  isShift && isUp     )  {  originY = originY + speed  ;}
          if  (  isShift && isDown   )  {  originY = originY - speed  ;}
          if  (  isShift && isLeft   )  {  originX = originX + speed  ;}
          if  (  isShift && isRight  )  {  originX = originX - speed  ;} 
  } 

  //RESTORE SAVED REFERENCE POINT
  popMatrix();
  
  //SHOW INFOPANE IF TOGGLED AND BLUR VISUALIZATION
  if      (  info                       )  {  cp5one.hide();filter(BLUR,7); image(infopane, 0, 0)  ;}
  if      ( !info                       )  {  cp5one.show()                                        ;}
  
  //CHANGE CURSOR IF CONTTROL IS HOVERED
  if      (  cp5one.isMouseOver() == true || cp5two.isMouseOver() == true  )  {  cursor(HAND)      ;} 
  else    {  cursor(ARROW)                                                                         ;}
  
  //DISABLE CONTROLS IF ZOOMED IN 
  if      (  zoom >  1.0                )  {  cp5one.hide(); cp5two.hide()                         ;}
  else if (  zoom <= 1.0 && !info       )  {  cp5one.show(); cp5two.show()                         ;}
  
  //PRINT POLAR COORDINATE OUTPUT
  //println("xI "+xI+" "+"xO "+xO+" "+"yI "+yI+" "+"yO "+yO);
}

//LISTEN FOR CONTROLL EVENT
void controlEvent(ControlEvent theControlEvent) {
  if  (  theControlEvent.isFrom("duration")    )  {
           minR = int(theControlEvent.getController().getArrayValue(0))  ;
           maxR = int(theControlEvent.getController().getArrayValue(1))  ;}
           
  if  (  theControlEvent.isFrom("time")        )  {
           minH = int(theControlEvent.getController().getArrayValue(0))  ;
           maxH = int(theControlEvent.getController().getArrayValue(1))  ;}
}
       
//ASSIGNING ZOOM TO UP/DOWN, LISTENING FOR BOOLEAN AND CHANGING ARROW KEY FUNCTIONALITY TO PAN
void keyPressed() {
  if  (  key  == CODED  )  {
        if      (  info == false && keyCode == UP    && isShift == false  )  {  zoom = constrain (zoom + speed, 0, 10)       ;}
        else if (  info == false && keyCode == DOWN  && isShift == false  )  {  zoom = constrain (zoom - speed, 0, 10)       ;}
  } 
        if      (  info == false && key     == ' '                        )  {  zoom = 1.0;  
                                                                                originX = width/2;  originY = height/2; 
                                                                                cp5one.getController("spacing").setValue(0)  ;}
                                                                                
        if      (  info == false && keyCode == SHIFT && isShift == false  )  {  isShift = true                               ;}
        if      (  info == false && keyCode == UP    && isUp    == false  )  {  isUp    = true                               ;}
        if      (  info == false && keyCode == DOWN  && isDown  == false  )  {  isDown  = true                               ;}
        if      (  info == false && keyCode == LEFT  && isLeft  == false  )  {  isLeft  = true                               ;}
        if      (  info == false && keyCode == RIGHT && isRight == false  )  {  isRight = true                               ;}
}

//HAS KEY BEEN RELEASED?
void keyReleased() {
        if      (  info == false && keyCode == SHIFT                      )  {  isShift = false                              ;}
        if      (  info == false && keyCode == UP                         )  {  isUp = false                                 ;}
        if      (  info == false && keyCode == DOWN                       )  {  isDown = false                               ;}
        if      (  info == false && keyCode == LEFT                       )  {  isLeft = false                               ;}
        if      (  info == false && keyCode == RIGHT                      )  {  isRight = false                              ;}
}

//ASSIGNING ZOOM TO SCROLL
void mouseWheel(MouseEvent scroll) {
        if      (  info == false && scroll.getCount() > 1                 )  {  zoom = constrain (zoom - speed, 0, 10)       ;}
        else if (  info == false && scroll.getCount() < 1                 )  {  zoom = constrain (zoom + speed, 0, 10)       ;}
}

//ASSIGNING PAN TO MOUSE DRAG
void mouseDragged() { 
        if      (  info == false && cp5one.isMouseOver() == false 
                   && cp5two.isMouseOver() == false                       )  {  originX = originX + (mouseX - pmouseX);
                                                                                originY = originY + (mouseY - pmouseY)        ;}  //Disable Pan if mouse is clicking a control
}
