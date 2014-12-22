public class MessageMediaContent implements MediaContent {
    
    boolean newContent = false;
    Panel parent = null;
    List<PImage> images = new ArrayList<PImage>();
    float currentTime = 0.0;
    int currentIndex = 0;
    
    public MessageMediaContent(Panel p) {
      
      this.parent = p;
      try {
         String[] lines = loadStrings("partners.txt");
         for( String l : lines ) {
            images.add(loadImage(l));
         }     
      }
      catch( Exception e ) {
         e.printStackTrace();
      }
    }
    
    boolean isNewContent() {
      return newContent;  
    }
    
    public Object getContent() {
      
      if( (millis() - currentTime)  > 7000 ) {
        
        if( currentIndex == images.size()-1 ) 
          currentIndex = 0;
        else
          currentIndex++;
        currentTime = millis();
        newContent = true;
        parent.flipped = true;
      }
      else
        newContent = false;
      
      return images.get(currentIndex);
    
  }
    
}
