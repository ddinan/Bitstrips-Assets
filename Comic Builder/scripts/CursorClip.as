package
{
   import flash.display.MovieClip;
   
   public dynamic class CursorClip extends MovieClip
   {
       
      
      public function CursorClip()
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
