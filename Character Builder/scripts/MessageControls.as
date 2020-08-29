package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   
   public dynamic class MessageControls extends MovieClip
   {
       
      
      public var cancel_btn:SimpleButton;
      
      public var send_btn:SimpleButton;
      
      public var myComicBuilder:Object;
      
      public function MessageControls()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function getButtonPackage() : Object
      {
         var _loc1_:Object = null;
         _loc1_ = new Object();
         _loc1_["send_btn"] = this.send_btn;
         _loc1_["cancel_btn"] = this.cancel_btn;
         _loc1_["edit_avatar_btn"] = this.edit_avatar_btn;
         return _loc1_;
      }
      
      function frame1() : *
      {
      }
      
      public function setComicBuilder(param1:Object) : *
      {
         trace("--comic_controls.setComicBuilder()--");
         myComicBuilder = param1;
      }
   }
}
