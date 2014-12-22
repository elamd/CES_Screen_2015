class SocialMediaContent implements MediaContent {
 
   boolean newContent = false;
   Panel parent;
   boolean switcher = false;
   long lastTime = System.currentTimeMillis();
   String post = "Retrieving posts...";
   String currentTweet, currentPostId;
   PImage facebookLogo, twitterLogo;
   int count = 1;
   LinkedList<String> tweets = new LinkedList<String>();
   Thread tweetThread    = new TweetThread( tweets );
   
   LinkedHashMap<String,Map> posts = new LinkedHashMap() {

     private static final int MAX_ENTRIES = 4;
     protected boolean removeEldestEntry( Map.Entry eldest ) {
         return size() > MAX_ENTRIES;
     } 
   };
   Thread facebookThread = new FacebookThread(posts);
   
   public SocialMediaContent( Panel p ) {
     this.parent = p;
     facebookLogo = loadImage("facebook_logo2.png");
     twitterLogo = loadImage("twitter_logo2.png");
     
     // Initialize Facebook posts.
     HashMap startPost = new HashMap<String,String>();
     startPost.put("id","0");
     startPost.put("message","Retrieving Facebook posts...");
     posts.put("0", startPost );
     currentPostId = "0";
     
     facebookThread.start();
     tweetThread.start();
   }
   
   public Object getContent() {
      
     long currentTime = System.currentTimeMillis();
     if( currentTime - lastTime > 30000 ) {
        println("Switch!");
        if( switcher ) {
           // Tweets
           parent.logo = twitterLogo;
           currentTweet = getTweet();
           post         = currentTweet;
        }
        else {
          // Facebook
          parent.logo = facebookLogo;
          currentPostId = getFacebook();
          try {
          post = (String)posts.get(currentPostId).get("message");
          }
          catch( Exception e ) {
             e.printStackTrace(); 
          }
        } 
        parent.createMastheadContent();
        lastTime = currentTime;
        parent.flipped = true;
        newContent = true;
        switcher = !switcher;
      }
      else
        newContent = false;
      return post;
   }
   
   String getTweet() {
    int index = tweets.indexOf( currentTweet );
       if( index >= tweets.size() -1 )
         index = 0;
       else
         index++;
       String tw = "Retrieving Tweets";
       try {
         tw = tweets.get(index);
       }
       catch( Exception e ) {
          e.printStackTrace(); 
       }
       return tw;
   }
  
   String getFacebook() {
        List l = new ArrayList();
        l.addAll(posts.keySet() );
        int i = l.indexOf( currentPostId );
        if( i == -1 || i >= 3 || l.size() == 1)
          i = 0;
        else
          i++;
        String fb = "";
        try {
          fb = (String)l.get(i);
        }
        catch( Exception e ) {
           e.printStackTrace(); 
        }
        return fb;
   } 
   
   public boolean isNewContent() {
     return newContent;  
   }
}

class TweetThread extends Thread {
   
   int waitTime = 60000;
   Twitter twitter = null;
   Paging paging = new Paging(1,5);
   boolean running = false;
   LinkedList<String> tweets;
   
   public TweetThread( LinkedList<String> tweets ) {
      
      this.tweets = tweets;
      ConfigurationBuilder cb = new ConfigurationBuilder();
      cb.setDebugEnabled(true)
        .setOAuthConsumerKey("W1XDgyxR3XR1fOT6NdffQ")
        .setOAuthConsumerSecret("9OYywO9gMIUaXPayTELEnRDG1ocJq7my9T1jQ9zUhY")
        .setOAuthAccessToken("22784167-WGDFuMYxXlrCSiVzQTkSfJ1UjYQ9lHvpwplcZAFYW")
        .setOAuthAccessTokenSecret("f6ggbIi9AeMWIAfdWAvj5zWDeley3BnGlEdbdE");
      TwitterFactory tf = new TwitterFactory(cb.build());
      twitter = tf.getInstance(); 
      
   }
     
   void start() { 

     running = true;
     super.start();  
   
   }
     
   void run() {
     
     while( running ) {
       println( "Retrieving tweets.." );
       
       try {
         List<Status> respList = twitter.getUserTimeline("DelphiAuto", paging);
         for( Status s : respList ) {
           if( !tweets.contains(s.getText()) )
             tweets.push( s.getText() );
         }
         if( tweets.size() > 5 )
             tweets.removeLast();
       }
       catch( Exception e ) {
         e.printStackTrace(); 
       }
       
       try {
         sleep((long)waitTime);
       }
       catch( Exception e ) {
         e.printStackTrace();
       }
      
     }
   }
}

class FacebookThread extends Thread {
  
  LinkedHashMap<String,Map> posts = null;
  
  String accessToken = null;
  int waitTime = 60000;
  boolean running = true;
  
  public FacebookThread(LinkedHashMap<String,Map> posts) {
      this.posts = posts;
      getAccessToken();
  }
  
  void getAccessToken() {
    try {
      java.net.URLConnection conn = new java.net.URL("https://graph.facebook.com/oauth/access_token?client_id=127538207404917&client_secret=f6e1ad2cc550746b8cd75ca1c11d761a&grant_type=client_credentials").openConnection();
      java.io.BufferedReader incoming = new java.io.BufferedReader( new java.io.InputStreamReader( conn.getInputStream() ) );
      StringBuffer buffer = new StringBuffer();
      String line = null;
      while( (line = incoming.readLine() ) != null ) {
        buffer.append(line);
      }
      accessToken = buffer.toString().split("=")[1];
    }
    catch( Exception e ) {
      e.printStackTrace();
    }
  }
  
  void start() {
    super.start();
  }
  
  void run() {
    while( running) {
      try {
        println("Retrieving facebook posts");
        String line;
        StringBuffer buff = new StringBuffer();
        if( accessToken == null )
          getAccessToken();
        java.net.URL request = new java.net.URL("https://graph.facebook.com/delphi?fields=posts.limit(4).fields(picture,message)&access_token=" + accessToken);
        java.net.URLConnection conn = request.openConnection();
        java.io.BufferedReader incoming = new java.io.BufferedReader( new java.io.InputStreamReader( conn.getInputStream() ) );
        while( (line = incoming.readLine()) != null )
          buff.append(line);
        incoming.close();
        processJson( buff );
      }
      catch( Exception e ) {
        e.printStackTrace();
      }
      
      try {
        sleep((long)waitTime);
      }
      catch( Exception e ) {
        e.printStackTrace();
      }
    }
  }
  
  void processJson( StringBuffer buff ) {
    ObjectMapper mapper = new ObjectMapper();
    try {
      Map<String,Map<String,List>> data = mapper.readValue( buff.toString(), Map.class); 
      List<Map<String,String>> postData = data.get("posts").get("data");
      
      for( Map<String,String> m : postData ) {
          if( !posts.containsValue(m.get("id")) ) {
              posts.put(m.get("id"), m );
          }
      }
    }
    catch( Exception e ) {
       e.printStackTrace(); 
    }
  }
}
