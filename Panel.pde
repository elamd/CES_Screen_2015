class Panel {
  
  PGraphics pg;
  int pwidth, pheight, tempWidth;
  int startX, startY;
  int time;
  PShape shape, box, masthead;
  int strokeColor;
  String title;
  int pcolor, logo_width, logo_height;
  PImage logo, contentImage;
  MediaContent mc = null;
  boolean flipped = false;
  float flipTime = 0.0;
  int x0, x1, x2, x3, x4, x5, x6, x7, y0, y1, y2, y3, y4, y5, y6, y7;
  PFont univ;
  
  public Panel(int pwidth, int pheight, int startX, int startY, int pcolor, String logo_file, int logo_width, int logo_height ) {
    
    univ = createFont("Univers LT 55",32);
    // Content box
    x0 = -pwidth/2;
    y0 = -pheight/2;
    
    x1 = pwidth/2;
    y1 = -pheight/2;
    
    x2 = pwidth/2;
    y2 = pheight/2;
    
    x3 = -pwidth/2;
    y3 = pheight/2;
    
    // Title
    x4 = -pwidth/2+10;
    y4 = -pheight/2+10;
    
    x5 = pwidth/2  - 10;
    y5 = -pheight/2 + 10;
    
    x6 = pwidth/2 - 10;
    y6 = -pheight/3 + 10;
    
    x7 = -pwidth/2 + 10;
    y7 = -pheight/3 + 10;
    
    this.pwidth  = pwidth;
    this.pheight = pheight;
    this.startX = startX;
    this.startY = startY;
    this.pcolor = pcolor;
    
    pg = createGraphics( pwidth-15, pheight-35);

    if( logo_file != null ) {
      this.logo = loadImage( logo_file );
      this.logo_width = logo_width;
      this.logo_height = logo_height;
    }
    contentImage = loadImage("test.png");
    createBox();
  }

  void createBox() {

    createBoxContent();
    if( this.logo != null)
      createMastheadContent();
  }
  
  void createMastheadContent() {
     masthead = createShape();
     masthead.beginShape();
       masthead.texture(logo);
       masthead.noStroke();
       masthead.strokeWeight(5);
       masthead.vertex(x4, y4, 0, 0, 0);
       masthead.vertex(x5, y5, 0, logo.width,0);
       masthead.vertex(x6, y6, 0, logo.width, logo.height);
       masthead.vertex(x7, y7, 0, 0, logo.height);
     masthead.endShape(CLOSE);
  }
  
  private void  createBoxContent() {
      box =  createShape();
      box.beginShape();
      
        box.stroke( strokeColor );
        box.strokeWeight(5);
        box.texture(contentImage);
        box.vertex(x0, y0,0, 0,0);
        box.vertex(x1, y1,0, pwidth,0);
        box.vertex(x2, y2,0, pwidth,pheight);
        box.vertex(x3, y3,0, 0,pheight);
      box.endShape(CLOSE);
  }
  
  void draw() {
    
    pushMatrix();
      translate(startX+pwidth/2, startY+pheight/2);
      if( flipped ) {
        float rad = radians(sq(flipTime+=.9));
        rotateY(rad);
        if( rad >= 4*PI ) {
          flipped = !flipped;
          flipTime = 0;
          rotate(0);
        }
      } 
      shape(box);
      if( masthead != null )
        shape(masthead);
    popMatrix();
    if ( mc != null )
      drawMediaContent();
  }

  public void setTitle( String title ) {
    this.title = title;
  }
  
  void setStrokeColor( int strokeColor ) {
    this.strokeColor = strokeColor;  
  }
  
  public void setMediaContent( MediaContent mc ) {
    this.mc = mc;
  }

  public void drawMediaContent() {
    if ( mc instanceof SocialMediaContent ) 
      drawStringMediaContent();
    else if ( mc instanceof MovieMediaContent )
      drawVideoMediaContent( );
    else if( mc instanceof MessageMediaContent )
      drawMessageMediaContent();
  }
  
    
  private void drawStringMediaContent() {
    if( mc.getContent() != null && mc.isNewContent() ) {
      try {
        pg = createGraphics( pwidth-10, pheight-35);
        pg.beginDraw();
        pg.background(0,200);
        pg.stroke(255);
        pg.textFont(univ);
        pg.textSize(18);
        pg.fill(255);
        pg.smooth();
        pg.text( (String)this.mc.getContent(), 15, 60,400,400 );
        pg.endDraw();
        contentImage = (PImage)pg;
        createBoxContent();
      }
      catch( Exception e ) {
        e.printStackTrace();
      } 
    }
  }


  private void drawVideoMediaContent() {
    MovieMediaContent mmc = (MovieMediaContent)this.mc;
    Movie m = (Movie)mmc.getContent();
    m.read();
    image( m, startX+3, startY+3, pwidth-5, pheight-5 );
  } 

 private void drawMessageMediaContent() {
     
     mc.getContent();
     
     if( mc.isNewContent() ) {
       createNewPartnerContent(); 
     }
   
 }
 
 void createNewPartnerContent() {
   println("creating new partner content" );
   try{
      contentImage = (PImage)mc.getContent();
      createBoxContent();
    }
    catch( Exception e ) {
        e.printStackTrace();
    }
 }
 
}

