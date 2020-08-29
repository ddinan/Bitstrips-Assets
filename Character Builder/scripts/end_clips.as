package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public dynamic class end_clips extends MovieClip
   {
       
      
      public var do_friend:SimpleButton;
      
      public var char_name:TextField;
      
      public var make_bs:SimpleButton;
      
      public var go_builder:SimpleButton;
      
      public var start_over:SimpleButton;
      
      public var save_button:SimpleButton;
      
      public var save_txt:TextField;
      
      public var name_box:MovieClip;
      
      public var make_bs_them:SimpleButton;
      
      public var edit_txt:TextField;
      
      public function end_clips()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      function frame1() : *
      {
         this.go_builder.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:*):*
         {
            dispatchEvent(new Event("switch"));
         });
         this.start_over.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:*):*
         {
            dispatchEvent(new Event("start_over"));
         });
         this.make_bs.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:*):*
         {
            dispatchEvent(new Event("make_bs"));
         });
         this.make_bs_them.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:*):*
         {
            dispatchEvent(new Event("make_bs"));
         });
         this.do_friend.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:*):*
         {
            dispatchEvent(new Event("do_friend"));
         });
         this.char_name.addEventListener(FocusEvent.FOCUS_IN,function(param1:*):*
         {
            if(char_name.text == "Name" || char_name.text == "Nom")
            {
               char_name.text = "";
            }
         });
      }
   }
}
