package
{
   import flash.display.MovieClip;
   
   public dynamic class hand extends MovieClip
   {
       
      
      public function hand()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      function frame1() : *
      {
         stop();
      }
   }
}
