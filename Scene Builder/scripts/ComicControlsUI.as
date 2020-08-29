package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.text.TextField;
   
   public dynamic class ComicControlsUI extends MovieClip
   {
       
      
      public var skyground_controls:MovieClip;
      
      public var lock_mc:MovieClip;
      
      public var lock_btn:SimpleButton;
      
      public var panel_controls:MovieClip;
      
      public var mode_1:MovieClip;
      
      public var copy_btn:SimpleButton;
      
      public var save_btn:SimpleButton;
      
      public var mode_2:MovieClip;
      
      public var mode_0:MovieClip;
      
      public var paste_btn:SimpleButton;
      
      public var redo_btn:SimpleButton;
      
      public var save_txt:TextField;
      
      public var pan_btn:MovieClip;
      
      public var undo_btn:SimpleButton;
      
      public var delete_btn:SimpleButton;
      
      public var move_up_btn:SimpleButton;
      
      public var move_down_btn:SimpleButton;
      
      public var depth_btn:MovieClip;
      
      public var angle_btn:MovieClip;
      
      public function ComicControlsUI()
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
