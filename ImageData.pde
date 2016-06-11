PFont font;
PImage img;

Table table;
TableRow row;

Boolean save = false;
Boolean tableStart = false;
Boolean imgLoaded = false;
Boolean dataLoaded = false;
Boolean firstTime = true;
Boolean firstTimeOut = true;

String[] fields = {"type", "label", "link", "cast", "name"};
String temp = "";

String fileName = "";
String filePath = "";
String fileExt = ".csv";

String sourceData = "";
String source = "filename.jpg";
String type = "";
String label = "";
String link = "";
String cast = "";
String name = "";


int x = 0;
int y = 0;
int w = 0;
int h = 0;

int count = 0;
int total = 0;


void setup() {
  size(800, 800);
  frame.setResizable(true);
  selectInput("Select a file to process:", "fileSelected");

  styleFont();
}


void draw() {
  background(160);
  
  //drawDebug();
  
  if (imgLoaded) {
    image(img, 0, 0);
  }
  if (dataLoaded){
    
  }
  if (count > 0) {
    drawRect();
    drawVoice();
    drawCount();
    drawSave();
  }
}

/* ******************************************** */
/*    Draw
/* ******************************************** */

void drawDebug(){
  textAlign(CORNER);
  text("focused = " + str(focused),10,10,width,50);
  text("firstTime = " + str(firstTime),10,40,width,50);
  text("firstTimeOut = " + str(firstTimeOut),10,70,width,50); 
}
void drawSave() {
  if (save) {
    strokeWeight(5);
    stroke(0, 255, 0);
    noFill();
    rect(10, 10, width-20, height-20);
  }
}
void drawRect() {
  noFill();
  strokeWeight(2.5);

  for (int i=0;i<table.getRowCount();i++) {
   println(i);
    TableRow r = table.getRow(i);
    String rsource = r.getString("source");
    int rx = r.getInt("x");
    int ry = r.getInt("y");
    int rw = r.getInt("w");
    int rh = r.getInt("h");

    if (i == count-1) {
      stroke(255, 0, 0);
    }
    else {
      stroke(0, 0, 255);
    }
    
    noFill();
    rect(rx, ry, rw, rh);
    
    if (i==count-1) {
      fill(255, 0, 0);
      text(temp, rx+10, ry-10, rw, rh);
    } 
    else {
      fill(0, 0, 255);
      String ts = "";
      
      for (int j=0; j< fields.length;j++) {
        String ed = (j < fields.length) ? "\n" : "";
        ts += r.getString(fields[j])+ed;
      }
      
      textAlign(LEFT, BOTTOM);
      text(ts, rx+10, ry, rw, rh);
    }
  }
}

void drawCount() {
  textFont(font, 24);
  textLeading(24);
  textAlign(CENTER, CENTER);
  text(str(count) + " of " + str(table.getRowCount()), 30, height-70, width-30, 30);
}

void drawVoice() {
  textFont(font, 24);
  textLeading(24);
  textAlign(CENTER, CENTER);  
  String[] t = split(temp, '\n');
  String val = "";
  for (int i=0; (i<t.length && i<fields.length); i++) {
    String op = (i == t.length-1) ? "?" : ", ";
    val += fields[i] + op;
  }
  fill(255, 0, 0);
  text(val, 0, 15, width, 30);
}






/* ******************************************** */
/*    Mouse Events
/* ******************************************** */

void mousePressed() {
  println("focused = " + focused);
  //if (!focused){
    
    println("focused != " + focused);
    
    if (count > 0) {
      firstTime = false;
      updateData();
    }


    count = table.getRowCount()+1;
    createRow();
    updateSize();

    println("count = " + str(count) + " rowCount = " + str(table.getRowCount()));

 //} else {

   firstTime = true;

 //}
}

void mouseDragged() {
 // if(!firstTime){
    updateSize();
 // }
}

void mouseMoved() {
  //high
}

void mouseReleased() {
  println("mouseReleases");
  //if (!firstTime){
    updateSize();
    updateData();
  //} else {
    println("firstTime = false");
    firstTime = false;
  //}
}



/* ******************************************** */
/*    Keyboard Events
/* ******************************************** */

void keyPressed() {
  if (count > 0) {
    keyCapture();
  }
}
void keyReleased() {
  if (keyCode == 157) {
    save = false;
    println("Save OFF");
  }
}

int xOffset = 0;
int yOffset = 0;
int spacer = 50;

void keyCapture() {
  firstTime = false;
  if (keyCode == BACKSPACE) {
    if (temp.length() > 0) {
      temp = temp.substring(0, temp.length()-1);
      println("Backspace");
    }
  } 
  else if (keyCode == DELETE) {
    temp = "";
    println("Clear");
  }
  else if (keyCode == 157) {
    save = true;
    println("Save ON");
  }
  else if (keyCode == 83 && save) {
    saveAll();
  }
  else if (keyCode == 44) {
  }
  else if (keyCode == 46) {
  }
  else if (keyCode != SHIFT) {
    temp += key;
    trim(temp);
    println("keyCode = " + keyCode);
  } 
  else if (keyCode == UP) {
    yOffset += spacer;
  } 
  else if (keyCode == DOWN) {
    yOffset -= spacer;
  } 
  else if (keyCode == LEFT) {
    xOffset += spacer;
  } 
  else if (keyCode == RIGHT) {
    xOffset -= spacer;
  }
}



/* ******************************************** */
/*    Create
/* ******************************************** */

void createTable() {


  File file = new File(filePath + fileName + ".csv");
  println("-- " + count + "-------");
  if(file.exists()){
    println("------------------------- Loading Table ------------------");
    table = loadTable(filePath + fileName + ".csv", "header");
    count = table.getRowCount();   
  } else {
    println("------------------------- Creating Table ------------------");
    table = new Table();  
    table.addColumn("source");
    table.addColumn("type");
    table.addColumn("label");
    table.addColumn("link");
    table.addColumn("cast");  
    table.addColumn("name");  
    table.addColumn("x");
    table.addColumn("y");
    table.addColumn("w");
    table.addColumn("h");
  }
  println("------- " + count + "-------");
}

void createRow() {
  TableRow r = table.addRow();
  row = r;
  r.setString("source", trim(source));
  r.setString("type", trim(type));
  r.setString("label", trim(label));
  r.setString("link", trim(link));  
  r.setString("cast", trim(cast));
  r.setString("name", trim(name));
  r.setInt("x", mouseX);
  r.setInt("y", mouseY);
  r.setInt("w", mouseX+1);
  r.setInt("h", mouseY+1);
  println("-----------------");
}

void updateSize() {
  TableRow r = table.getRow(count-1);
  r.setInt("w", mouseX-r.getInt("x"));
  r.setInt("h", mouseY-r.getInt("y"));
}

void updateData() {
  String[] w = split(temp, "\n");

  TableRow r = table.getRow(count-1);
  for (int i=0;i<w.length;i++) {
    if (i<fields.length) {
      r.setString(fields[i], trim(w[i]));
    }
  }
}






/* ******************************************** */
/*    SAVE
/* ******************************************** */

void saveAll() {
  updateData();
  saveTable(table, filePath + fileName + ".csv");
  println("Table Saved");
}
 
  
/* ******************************************** */
/*    styles
/* ******************************************** */

void styleFont() {
  font = createFont("Sans Serif", 40);
  textFont(font, 24);
  textLeading(24);
  textAlign(CENTER, CENTER);
}



void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } 
  else {
    img = loadImage(selection.getAbsolutePath());

    imgLoaded = true;
    source = selection.getAbsolutePath();
    
    String[] s = split(source,"/");
    String last = s[s.length-1];
    String[] e = split(last,".");
    e[e.length-1] = "csv";
    s[s.length-1] = join(e,".");
    
    sourceData = join(s, "/");
    filePath = join(shorten(s),"/") + "/";
    fileName = join(shorten(e),".");
    
    
    
    println(source);
    println(sourceData);
    println(filePath);
    println(fileName);
    
    createTable();
    size(img.width,img.height);
  }
}









