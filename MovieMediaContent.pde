class MovieMediaContent implements MediaContent {
  
  List<Movie> movies = new ArrayList<Movie>();
  Movie movie = null;
  int currentIndex = 0;
  int timeLimit = 20000;
  float currentTime;
  boolean fullScreen = false;
  boolean newContent = false;
  Panel parent = null;
  
   public MovieMediaContent(PApplet applet, Panel p) {
     this.parent = p;
     String[] lines = loadStrings("movies.txt");
     for( String l : lines ) {
        movie = new Movie(applet,l);
        movies.add(movie);
     } 
     movie = movies.get(currentIndex);
     movie.loop();
     timeLimit = (int)((movie.duration() * 1000)+500);
     println("duration is : " + timeLimit);
     currentTime = millis();
   }
    
   boolean isNewContent() {
    return newContent;
  }
  
   public Object getContent() {
     
     if(millis() - currentTime >= timeLimit ) {
       
       currentTime = millis();

       println("Retrieving new movie....");
       if( ++currentIndex >= movies.size() )
         currentIndex = 0;
       Movie temp = movies.get(currentIndex);
       temp.loop();
       movie.stop();
       movie = temp;
       timeLimit = (int)((movie.duration() * 1000)+500);
        
    }
     
     return movie;
   }
}
