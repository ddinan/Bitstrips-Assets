package
{
   import fl.controls.Button;
   import fl.controls.CheckBox;
   import fl.controls.TextInput;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class Signup_UI extends MovieClip
   {
       
      
      public var popup_pen:MovieClip;
      
      public var cancel_btn:Button;
      
      public var username_error:TextField;
      
      public var popup_real:MovieClip;
      
      public var password_error:TextField;
      
      public var email_error:TextField;
      
      public var rnl:MovieClip;
      
      public var password:TextInput;
      
      public var real_name:TextInput;
      
      public var agree:CheckBox;
      
      public var email:TextInput;
      
      public var confirm_error:TextField;
      
      public var confirm:TextInput;
      
      public var terms_txt:TextField;
      
      public var pen_name_mc:MovieClip;
      
      public var optional_mc:MovieClip;
      
      public var username:TextInput;
      
      public var join_btn:Button;
      
      public function Signup_UI()
      {
         super();
         addFrameScript(0,frame1);
         __setProp_real_name_signup_box_text_1();
         __setProp_join_btn_signup_Layer1_1();
         __setProp_email_signup_box_text_1();
         __setProp_confirm_signup_box_text_1();
         __setProp_agree_signup_Layer1_1();
         __setProp_username_signup_box_text_1();
         __setProp_cancel_btn_signup_Layer1_1();
         __setProp_password_signup_box_text_1();
      }
      
      function frame1() : *
      {
         username.tabIndex = 1;
         email.tabIndex = 4;
         password.tabIndex = 2;
         confirm.tabIndex = 3;
         real_name.tabIndex = 4;
         join_btn.tabIndex = 6;
         cancel_btn.tabIndex = 7;
         agree.tabIndex = 5;
      }
      
      function __setProp_username_signup_box_text_1() : *
      {
         try
         {
            username["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         username.displayAsPassword = false;
         username.editable = true;
         username.enabled = true;
         username.maxChars = 13;
         username.restrict = "";
         username.text = "";
         username.visible = true;
         try
         {
            username["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      function __setProp_cancel_btn_signup_Layer1_1() : *
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
      
      function __setProp_confirm_signup_box_text_1() : *
      {
         try
         {
            confirm["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         confirm.displayAsPassword = true;
         confirm.editable = true;
         confirm.enabled = true;
         confirm.maxChars = 20;
         confirm.restrict = "";
         confirm.text = "";
         confirm.visible = true;
         try
         {
            confirm["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      function __setProp_join_btn_signup_Layer1_1() : *
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
      
      function __setProp_agree_signup_Layer1_1() : *
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
      
      function __setProp_real_name_signup_box_text_1() : *
      {
         try
         {
            real_name["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         real_name.displayAsPassword = false;
         real_name.editable = true;
         real_name.enabled = true;
         real_name.maxChars = 80;
         real_name.restrict = "";
         real_name.text = "";
         real_name.visible = true;
         try
         {
            real_name["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      function __setProp_email_signup_box_text_1() : *
      {
         try
         {
            email["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         email.displayAsPassword = false;
         email.editable = true;
         email.enabled = true;
         email.maxChars = 80;
         email.restrict = "";
         email.text = "";
         email.visible = true;
         try
         {
            email["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      function __setProp_password_signup_box_text_1() : *
      {
         try
         {
            password["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         password.displayAsPassword = true;
         password.editable = true;
         password.enabled = true;
         password.maxChars = 20;
         password.restrict = "";
         password.text = "";
         password.visible = true;
         try
         {
            password["componentInspectorSetting"] = false;
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
   }
}
