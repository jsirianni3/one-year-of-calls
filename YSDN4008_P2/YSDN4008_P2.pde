//Project 2 - Joshua Sirianni

//SHARED GLOBAL
Table callData;
int rowCount, callMonth, callDay, callTimeHours, callTimeMinutes;
String callWeekday, callType, callTime;
float callDuration;

//SUM WEEKS GLOBAL
int cWeek, pWeek, i;                 //currentWeek, previousWeek, index
int [] weekDuration = new int [53];  //total call duration for 52 weeks 
float [] weekOUT = new float [53];       //total outgoing for 52 weeks
float [] weekINC = new float [53];       //total incoming for 52 weeks
float [] weekMYO = new float [53];       //total my buddy outgoing for 52 weeks
float [] weekMYI = new float [53];       //total my buddy incoming for 52 weeks

//POLAR GLOBAL
float rI, rO;
float theta;
float x1, x2, y1, y2;
float minOUT, minINC, minMYO, minMYI = MAX_FLOAT;
float maxOUT, maxINC, maxMYO, maxMYI = MIN_FLOAT; 

//SETUP AND CALCULATIONS
void setup() {
  size(1200, 1000);
  callData = loadTable("all_year_data_combined.csv", "header");
  rowCount = callData.getRowCount();
   
  for(int row = 0; row < rowCount; row++ ) {
        callMonth = callData.getInt(row, "month");
        callDay = callData.getInt(row, "day");
        callWeekday = callData.getString(row, "weekday");
        callType = callData.getString(row, "callType");
        callDuration = callData.getInt(row, "duration");
        
        if      (callWeekday.equals("MON")) {
                    cWeek = 0;}   
        else if (callWeekday.equals("TUE")) {
                    cWeek = 1;} 
        else if (callWeekday.equals("WED")) {
                    cWeek = 2;} 
        else if (callWeekday.equals("THU")) {
                    cWeek = 3;} 
        else if (callWeekday.equals("FRI")) {
                    cWeek = 4;} 
        else if (callWeekday.equals("SAT")) {
                    cWeek = 5;} 
        else if (callWeekday.equals("SUN")) {
                    cWeek = 6;}
        
        if      (pWeek > cWeek) { i = i+1;}
                      
        if      (callType.equals("INC") || callType.equals("IRM")) {
                    weekINC [i] = weekINC[i]+1;}
        else if (callType.equals("MYI") || callType.equals("RBM")) {
                    weekMYI [i] = weekMYI[i]+1;}
        else if (callType.equals("OUT")) {
                    weekOUT [i] = weekOUT[i]+1;}
        else if (callType.equals("MYO")) {
                    weekMYO [i] = weekMYO[i]+1;}
                
        weekDuration[i] = weekDuration[i]+int(callDuration); 
        pWeek = cWeek;
            
        println("week " + i + " " + "row " + row + " " + "duration " + weekDuration[i] + " " + "INC " + " " + weekINC[i]
        + " " + "MYI " + " " + weekMYI[i] + " " + "OUT " + " " + weekOUT[i] + " " + "MYO " + " " + weekMYO[i]);
    }
}

void draw() {  
  
    //Interface
    background(#060116);
    for(i = 0; i < 52; i++ ) {
        //callTime = callData.getString(row, "callTime");
        //callType = callData.getString(i, "callType");
        //callDuration = callData.getInt(row, "duration");
        //String callTimeCheck = callTime.substring(1, 2);
        
        
        ////Extracting time from format xx:xx in table
        //if (callTimeCheck.equals(":") == true) {
        //  callTimeHours   = int(callTime.substring(0, 1));
        //  callTimeMinutes = int(callTime.substring(2));
        //} else {
        //  callTimeHours   = int(callTime.substring(0, 2));
        //  callTimeMinutes = int(callTime.substring(3));
        //}
        
        //calculate min and max durations
        if(weekOUT[i] > maxOUT) {maxOUT = weekOUT[i];}
        if(weekOUT[i] < minOUT) {minOUT = weekOUT[i];}
        
        if(weekINC[i] > maxINC) {maxINC = weekINC[i];}
        if(weekINC[i] < minINC) {minINC = weekINC[i];}
                
        if(weekMYO[i] > maxMYO) {maxMYO = weekMYO[i];}
        if(weekMYO[i] < minMYO) {minMYO = weekMYO[i];}
        
        if(weekMYI[i] > maxMYI) {maxMYI = weekMYI[i];}
        if(weekMYI[i] < minMYI) {minMYI = weekMYI[i];}
        
        //weekOUT[i] = map(weekOUT[i], minOUT, maxOUT, 15, 50);
        //weekINC[i] = map(weekINC[i], minINC, maxINC, 15, 50);
        //weekMYO[i] = map(weekMYO[i], minMYO, maxMYO, 15, 50);
        //weekMYI[i] = map(weekMYI[i], minMYI, maxMYI, 15, 50);
    
        
        //Colour circles based on call type
        //noFill();
        //if      (callType.equals("MYO")) {             stroke(147, 39, 143);} 
        //else if (callType.equals("MYI")) {             stroke(251, 176, 59);}
        //else if (callType.equals("OUT")) { noStroke(); fill(102, 45, 145, 80);}
        //else if (callType.equals("INC")) { noStroke(); fill(247, 147, 30, 80);}
    
     
        
                        //Calculate time
                        //int calculatedTime = (callTimeHours * 60) + callTimeMinutes;
      
        //Registering the original point of reference
        pushMatrix();
        //Shifting the reference point to the center of canvas
        translate(width/2, height/2);
        // radius or the distance from the center
        rI = 200;
        rO = 350;
        //polar coordinates based on the calculatedTime
        //theta = calculatedTime * (2*PI/1439); //1440 is total number of minutes in a day, dont want first and last minute to overlap, so do one less
        theta = i * (2*PI/52); 
        
        ////convert polar coordinates to cartesian (our x and y for plotting)
        x1 = (rI * cos(theta));
        y1 = (rI * sin(theta));
        x2 = (rO * cos(theta));
        y2 = (rO * sin(theta));
      
        ////drawing the points
        //if      (callType.equals("OUT")){
        //              noStroke(); fill(102, 45, 145, 80);             
        //              ellipse(x2, y2, weekOUT[i], weekOUT[i]);}
        //else if (callType.equals("INC")){
        //              fill(247, 147, 30, 80);
        //              ellipse(x1, y1, weekINC[i], weekINC[i]);}
        //else if (callType.equals("MYO")){
        //              noFill(); stroke(147, 39, 143); 
        //              ellipse(x2, y2, weekMYO[i], weekMYO[i]);}
        //else if (callType.equals("MYI")){
        //              stroke(251, 176, 59);
        //              ellipse(x1, y1, weekMYI[i], weekMYI[i]);}
                      
                //drawing the points
    
        noStroke();fill(102, 45, 145, 80);             
        ellipse(x2, y2, weekOUT[i], weekOUT[i]);
     
        fill(247, 147, 30, 80);
        ellipse(x1, y1, weekINC[i], weekINC[i]);
  
        noFill(); stroke(147, 39, 143); 
        ellipse(x2, y2, weekMYO[i], weekMYO[i]);

        stroke(251, 176, 59);
        ellipse(x1, y1, weekMYI[i], weekMYI[i]);
     
        ////callouts inner circle
        //float callOut = dist(x1, y1, mouseX - width/2, mouseY- height/2);
        //if (callOut < 5) {
        //  textAlign(CENTER);
        //  fill(255);
        //  text(callTime, mouseX - width/2 +20, mouseY- height/2);
        //}
        
        ////callouts outer circle
        //float callOut2 = dist(x2, y2, mouseX - width/2, mouseY- height/2);
        //if (callOut2 < 5) {
        //  textAlign(CENTER);
        //  fill(255);
        //  text(callTime, mouseX - width/2 +20, mouseY- height/2);
        //}
      
        //relocate point of reference to its original location
        popMatrix();
      }
      println("x1 "+x1+" "+"x2 "+x2+" "+"y1 "+y1+" "+"y2 "+y2);
}
