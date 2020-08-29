package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   public dynamic class EyeMouthUI extends MovieClip
   {
       
      
      public var mouth3:MovieClip;
      
      public var mouth0:MovieClip;
      
      public var mouth2:MovieClip;
      
      public var mouth1:MovieClip;
      
      public var p_broken:SimpleButton;
      
      public var lid1:MovieClip;
      
      public var lid5:MovieClip;
      
      public var p_slider:MovieClip;
      
      public var lid2:MovieClip;
      
      public var lid4:MovieClip;
      
      public var lid3:MovieClip;
      
      public var p_linked:SimpleButton;
      
      public function EyeMouthUI()
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
