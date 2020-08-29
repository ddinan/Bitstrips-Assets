package
{
   import flash.display.MovieClip;
   
   public dynamic class crossmark extends MovieClip
   {
       
      
      public function crossmark()
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
