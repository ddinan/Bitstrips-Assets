package
{
   import flash.display.MovieClip;
   
   public dynamic class TextControlsUI extends MovieClip
   {
       
      
      public var bg_icon:MovieClip;
      
      public var bubbleMenu_area_mc:MovieClip;
      
      public var fg_colourBox:MovieClip;
      
      public var i_btn:MovieClip;
      
      public var u_btn:MovieClip;
      
      public var multi_tail:MovieClip;
      
      public var colourBox_area_mc:MovieClip;
      
      public var bold_btn:MovieClip;
      
      public var no_bubble:MovieClip;
      
      public function TextControlsUI()
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
