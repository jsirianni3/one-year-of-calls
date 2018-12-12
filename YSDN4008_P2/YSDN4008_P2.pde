//Project 2 - Joshua Sirianni

Table data; //initialize table
int rowCount; //total rows
int callTimeHours, callTimeMinutes;
String callTime, callType;
float rI, rO; //radii for inner and outer circles
float theta; //angle for polar coordinate
float x1, x2, y1, y2; //to draw data points
float callDuration; //call duration from table
float minDuration = MAX_FLOAT; //temp set to max value
float maxDuration = MIN_FLOAT; //temp set to min value


void setup() {
  size(1200, 1000);
  data = loadTable("filtereddataCSV.csv", "header");
  rowCount = data.getRowCount();
  println(rowCount);
  textAlign(CENTER);
}

void draw() {
  
  //Interface
  background(#060116);
  
  //Main loop
  for(int row = 0; row < rowCount; row ++) {
    callTime = data.getString(row, "callTime");
    callType = data.getString(row, "callType");
    callDuration = data.getInt(row, "durationMinutes");
    String callTimeCheck = callTime.substring(1, 2);
    
    //Extracting time from format xx:xx in table
    if (callTimeCheck.equals(":") == true) {
      callTimeHours   = int(callTime.substring(0, 1));
      callTimeMinutes = int(callTime.substring(2));
    } else {
      callTimeHours   = int(callTime.substring(0, 2));
      callTimeMinutes = int(callTime.substring(3));
    }
    
    //calculate min and max durations
    if(callDuration > maxDuration) {maxDuration = callDuration;}
    if(callDuration< minDuration) {minDuration = callDuration;}
    
    callDuration = map(callDuration, minDuration, maxDuration, 15, 150);

    
    //Colour circles based on call type
    noFill();
    if      (callType.equals("MYO")) {             stroke(147, 39, 143);} 
    else if (callType.equals("MYI")) {             stroke(251, 176, 59);}
    else if (callType.equals("OUT")) { noStroke(); fill(102, 45, 145, 80);}
    else if (callType.equals("INC")) { noStroke(); fill(247, 147, 30, 80);}

 
    
    //Calculate time
    int calculatedTime = (callTimeHours * 60) + callTimeMinutes;
  
    //Registering the original point of reference
    pushMatrix();
    //Shifting the reference point to the center of canvas
    translate(width/2, height/2);
    // radius or the distance from the center
    rI = 200;
    rO = 350;
    //polar coordinates based on the calculatedTime
    theta = calculatedTime * (2*PI/1439); //1440 is total number of minutes in a day, dont want first and last minute to overlap, so do one less
    
    //convert polar coordinates to cartesian (our x and y for plotting)
    x1 = (rI * cos(theta));
    y1 = (rI * sin(theta));
    x2 = (rO * cos(theta));
    y2 = (rO * sin(theta));
  
    //drawing the points

    if (callType.equals("MYI") || callType.equals("INC")) {
      ellipse(x1, y1, callDuration, callDuration);
    } else {
      ellipse(x2, y2, callDuration, callDuration);
    }
 
    //callouts inner circle
    float callOut = dist(x1, y1, mouseX - width/2, mouseY- height/2);
    if (callOut < 5) {
      textAlign(CENTER);
      fill(255);
      text(callTime, mouseX - width/2 +20, mouseY- height/2);
    }
    
    //callouts outer circle
    float callOut2 = dist(x2, y2, mouseX - width/2, mouseY- height/2);
    if (callOut2 < 5) {
      textAlign(CENTER);
      fill(255);
      text(callTime, mouseX - width/2 +20, mouseY- height/2);
    }
  
    //relocate point of reference to its original location
    popMatrix();

  }
}
