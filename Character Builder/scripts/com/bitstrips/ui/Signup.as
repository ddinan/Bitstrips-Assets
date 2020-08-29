package com.bitstrips.ui
{
   import com.adobe.utils.StringUtil;
   import com.bitstrips.BSConstants;
   import com.bitstrips.core.Remote;
   import fl.controls.CheckBox;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.text.TextField;
   
   public final class Signup extends Sprite
   {
       
      
      public var cancel_call:Function;
      
      private var remote:Remote;
      
      private var ui:Signup_UI;
      
      private var error_labels:Object;
      
      private var password:TextField;
      
      private var email:TextField;
      
      public var username:TextField;
      
      public var set_id:Function;
      
      private var agree:CheckBox;
      
      private var checked_emails:Object;
      
      private var checked_names:Object;
      
      private var fields:Array;
      
      public function Signup(param1:Remote)
      {
         var f:String = null;
         var remote:Remote = param1;
         checked_names = new Object();
         checked_emails = new Object();
         ui = new Signup_UI();
         super();
         this.remote = remote;
         addChild(ui);
         username = ui.username;
         username.restrict = "A-z_0-9";
         email = ui.email;
         password = ui.password;
         password.displayAsPassword = true;
         agree = ui.agree;
         fields = [username,email,password];
         error_labels = {
            "username":ui.username_error,
            "email":ui.email_error,
            "password":ui.password_error
         };
         ui.username_error.visible = false;
         ui.email_error.visible = false;
         ui.password_error.visible = false;
         ui.popup_pen.visible = false;
         ui.pen_name_mc.addEventListener(MouseEvent.ROLL_OVER,show_popup_pen);
         ui.pen_name_mc.addEventListener(MouseEvent.ROLL_OUT,hide_popup_pen);
         ui.pen_name_mc.buttonMode = true;
         BSConstants.tf_fix(ui.terms_txt);
         for(f in fields)
         {
            fields[f].addEventListener(FocusEvent.FOCUS_OUT,focus_out);
         }
         ui.join_btn.addEventListener(MouseEvent.CLICK,join);
         ui.cancel_btn.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            trace("Cancel call: " + cancel_call);
            cancel_call();
         });
         BSConstants.tf_fix(ui.privacy_txt);
      }
      
      private function show_popup_pen(param1:MouseEvent) : void
      {
         ui.popup_pen.visible = true;
      }
      
      private function hide_popup_pen(param1:MouseEvent) : void
      {
         ui.popup_pen.visible = false;
      }
      
      private function set_all(param1:Boolean) : void
      {
         var _loc2_:TextField = null;
      }
      
      private function joined(param1:Object) : void
      {
         var _loc2_:* = undefined;
         if(param1 != 0)
         {
            trace("They joined!" + param1[0] + " " + param1[1]);
            remote.code = param1[1];
            _loc2_ = ExternalInterface.call("set_auth_cookie",param1[1]);
            trace("set_auth val: " + _loc2_);
            set_id(param1[0]);
         }
         else
         {
            trace("Error...");
            ui.pen_name_mc.visible = false;
            ui.username_error.text = "an error occured, please try again";
            ui.username_error.visible = true;
            set_all(true);
         }
      }
      
      private function show_popup_real(param1:MouseEvent) : void
      {
         ui.popup_real.visible = true;
      }
      
      private function validate(param1:Boolean = false) : Object
      {
         var _loc3_:* = null;
         var _loc4_:RegExp = null;
         var _loc5_:* = null;
         var _loc6_:String = null;
         var _loc2_:Object = [];
         for(_loc3_ in fields)
         {
            fields[_loc3_].text = StringUtil.trim(fields[_loc3_].text);
         }
         _loc4_ = /^[a-z][\w.+-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
         if(username.text.length < 3)
         {
            ui.pen_name_mc.visible = false;
            _loc2_["username"] = "too short";
         }
         else if(checked_names[username.text])
         {
            if(checked_names[username.text] == 1)
            {
               ui.pen_name_mc.visible = false;
               _loc2_["username"] = "already used";
            }
            trace("Checked names: " + checked_names[username.text]);
         }
         else
         {
            remote.username_check(username.text,checked);
         }
         if(_loc4_.test(email.text) == false)
         {
            _loc2_["email"] = "not an email address";
         }
         else if(checked_emails[email.text])
         {
            if(checked_emails[email.text] == 1)
            {
               _loc2_["email"] = "already used";
            }
         }
         else
         {
            remote.email_check(email.text,checked_email);
         }
         if(password.text.length < 2)
         {
            _loc2_["password"] = "pasword too short";
         }
         for(_loc5_ in _loc2_)
         {
            error_labels[_loc5_].text = _loc2_[_loc5_];
         }
         trace("Final check");
         for(_loc3_ in fields)
         {
            _loc6_ = fields[_loc3_].name;
            trace("\t checking: " + _loc3_ + " " + fields[_loc3_] + " " + _loc6_);
            if(fields[_loc3_].text == "")
            {
               _loc2_["failed"] = 1;
               if(param1)
               {
                  error_labels[_loc6_].visible = true;
               }
            }
            else if(_loc2_[_loc6_])
            {
               _loc2_["failed"] = 1;
               error_labels[_loc6_].visible = true;
            }
            else
            {
               error_labels[_loc6_].visible = false;
               trace("No error yet...");
            }
         }
         return _loc2_;
      }
      
      private function checked_email(param1:Object) : void
      {
         trace("Email return: " + param1["email"] + ", " + param1["used"]);
         if(param1["used"] >= 1)
         {
            checked_emails[param1["email"]] = 1;
         }
         else
         {
            checked_emails[param1["email"]] = 2;
         }
         validate();
      }
      
      private function checked(param1:Object) : void
      {
         trace("Username return: " + param1["username"] + ", " + param1["used"]);
         if(param1["used"] == 1)
         {
            checked_names[param1["username"]] = 1;
         }
         else
         {
            checked_names[param1["username"]] = 2;
         }
         validate();
      }
      
      private function join(param1:Event) : void
      {
         var _loc2_:Object = validate(true);
         if(_loc2_["failed"] || agree.selected == false)
         {
            trace("Nope, not going to do it...");
         }
         else
         {
            trace("Doing it!");
            remote.new_user(ui.username.text,ui.email.text,ui.password.text,joined);
            set_all(false);
         }
      }
      
      private function hide_popup_real(param1:MouseEvent) : void
      {
         ui.popup_real.visible = false;
      }
      
      private function focus_out(param1:Event) : void
      {
         var _loc2_:String = param1.currentTarget.name;
         var _loc3_:String = param1.currentTarget.text;
         trace(param1.type + " : " + _loc2_ + " " + param1.currentTarget.text);
         validate();
      }
   }
}
