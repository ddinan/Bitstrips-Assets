package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   public dynamic class ObjectControlsUI extends MovieClip
   {
       
      
      public var prop_inc:SimpleButton;
      
      public var prop_dec:SimpleButton;
      
      public var ceiling_mc:MovieClip;
      
      public var colourBox_area_mc:MovieClip;
      
      public var colour:TextField;
      
      public var rotate_prop:MovieClip;
      
      public var state_buttons:MovieClip;
      
      public function ObjectControlsUI()
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
