import processing.video.*;
import java.text.DecimalFormat;
import twitter4j.*;
import twitter4j.conf.ConfigurationBuilder;
import java.util.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.annotation.JsonAutoDetect;

float x,y,z;
float maxX, minX, maxY, minY, maxZ, minZ;
DecimalFormat format = new DecimalFormat("#.##");
int totalPanels = 2;
Panel[] panels = new Panel[ totalPanels ];
Movie movie;
PImage backgrnd;
PImage delphiLogo;

void setup() {
  size(1920, 1080, P3D);
  ortho(0, width, 0, height);
  backgrnd = loadImage("background.jpg");
  delphiLogo = loadImage("delphi_logo.png");
  textFont( createFont("UniversLT",12) );
  setupPanels();
  movie = new Movie(this,"blue_silk.mp4");
  movie.loop();
}

void draw() {

    image(movie,0,0,1920,1080);
    movie.read();
    image(delphiLogo,1500,1000,306,33);
    drawPanels();
}

void drawPanels() {
    for( Panel p : panels ) {
        p.draw();
    }
}

public void setupPanels() {
   
    /*
    Panel p = new Panel( 200, 300, 40,150, 0, "twitter_logo.png",152,32);
    p.setTitle("Twitter");
    p.setStrokeColor( color(0,172,232) );
    panels[0] = p;
    MediaContent mediaContent = new TwitterMediaContent(p);
    p.setMediaContent( mediaContent );
    
    p = new Panel( 200,300,275,150,0, "facebook_logo.png",170,32);
    p.setStrokeColor( color(50,160,50) );
    p.setTitle("Facebook");
    panels[1] = p;
    mediaContent = new FacebookMediaContent(p);
    p.setMediaContent( mediaContent );
    
    
    Panel p = new Panel(435, 355,40,150,0,"twitter_logo2.png",152,32);
    //Panel p = new Panel(435, 355,90,150,0,"twitter_logo2.png",152,32);
    p.setStrokeColor( color( 0,172,232) );
    panels[0] = p;
    MediaContent mediaContent = new SocialMediaContent(p);
    p.setMediaContent( mediaContent );
    */
    
    Panel p = new Panel(435,355,40,521,0, "collaborators.png", 152, 32);
    //p = new Panel(435,355,90,521,0, "collaborators.png", 152, 32);    
    p.setStrokeColor( color(210,90,6) );
    panels[0] = p;
    MediaContent mediaContent = new MessageMediaContent(p);
    p.setMediaContent( mediaContent );
    
        
    p = new Panel( 1296, 729,530,150, 0,  "logo.png",152,32);
    //p = new Panel( 1246, 729,580,150,0, "logo.png",152,32);
    p.setStrokeColor( color(240,171,0) );
    panels[1] = p;
    mediaContent = new MovieMediaContent(this,p);
    p.setMediaContent( mediaContent );
}

