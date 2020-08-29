package
{
   import fl.controls.Button;
   import fl.controls.CheckBox;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class Signup_UI extends MovieClip
   {
       
      
      public var popup_pen:MovieClip;
      
      public var cancel_btn:Button;
      
      public var username_error:TextField;
      
      public var password_error:TextField;
      
      public var email_error:TextField;
      
      public var password:TextField;
      
      public var agree:CheckBox;
      
      public var email:TextField;
      
      public var terms_txt:TextField;
      
      public var pen_name_mc:MovieClip;
      
      public var username:TextField;
      
      public var join_btn:Button;
      
      public function Signup_UI()
      {
         super();
         addFrameScript(0,frame1);
         __setProp_join_btn_signup_inputfields_1();
         __setProp_agree_signup_inputfields_1();
         __setProp_cancel_btn_signup_inputfields_1();
      }
      
      function __setProp_cancel_btn_signup_inputfields_1() : *
      {
         try
         {
            cancel_btn["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         cancel_btn.emphasized = false;
         cancel_btn.enabled = true;
         cancel_btn.label = "Cancel";
         cancel_btn.labelPlacement = "right";
         cancel_btn.selected = false;
         cancel_btn.toggle = false;
         cancel_btn.visible = true;
         try
         {
            cancel_btn["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      function __setProp_agree_signup_inputfields_1() : *
      {
         try
         {
            agree["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         agree.enabled = true;
         agree.label = "";
         agree.labelPlacement = "right";
         agree.selected = false;
         agree.visible = true;
         try
         {
            agree["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      function frame1() : *
      {
         join_btn.tabIndex = 6;
         cancel_btn.tabIndex = 7;
         agree.tabIndex = 5;
      }
      
      function __setProp_join_btn_signup_inputfields_1() : *
      {
         try
         {
            join_btn["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         join_btn.emphasized = false;
         join_btn.enabled = true;
         join_btn.label = "Sign Up Now";
         join_btn.labelPlacement = "right";
         join_btn.selected = false;
         join_btn.toggle = false;
         join_btn.visible = true;
         try
         {
            join_btn["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
   }
}
