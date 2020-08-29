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
       
      
      private var remote:Remote;
      
      public var set_id:Function;
      
      public var cancel_call:Function;
      
      private var checked_names:Object;
      
      private var checked_emails:Object;
      
      private var fields:Array;
      
      private var error_labels:Object;
      
      public var username:TextField;
      
      private var email:TextField;
      
      private var password:TextField;
      
      private var agree:CheckBox;
      
      private var ui:Signup_UI;
      
      public function Signup(param1:Remote)
      {
         var f:String = null;
         var remote:Remote = param1;
         this.checked_names = new Object();
         this.checked_emails = new Object();
         this.ui = new Signup_UI();
         super();
         this.remote = remote;
         addChild(this.ui);
         this.username = this.ui.username;
         this.username.restrict = "A-z_0-9";
         this.email = this.ui.email;
         this.password = this.ui.password;
         this.password.displayAsPassword = true;
         this.agree = this.ui.agree;
         this.fields = [this.username,this.email,this.password];
         this.error_labels = {
            "username":this.ui.username_error,
            "email":this.ui.email_error,
            "password":this.ui.password_error
         };
         this.ui.username_error.visible = false;
         this.ui.email_error.visible = false;
         this.ui.password_error.visible = false;
         this.ui.popup_pen.visible = false;
         this.ui.pen_name_mc.addEventListener(MouseEvent.ROLL_OVER,this.show_popup_pen);
         this.ui.pen_name_mc.addEventListener(MouseEvent.ROLL_OUT,this.hide_popup_pen);
         this.ui.pen_name_mc.buttonMode = true;
         BSConstants.tf_fix(this.ui.terms_txt);
         for(f in this.fields)
         {
            this.fields[f].addEventListener(FocusEvent.FOCUS_OUT,this.focus_out);
         }
         this.ui.join_btn.addEventListener(MouseEvent.CLICK,this.join);
         this.ui.cancel_btn.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            trace("Cancel call: " + cancel_call);
            cancel_call();
         });
         BSConstants.tf_fix(this.ui.privacy_txt);
      }
      
      private function show_popup_pen(param1:MouseEvent) : void
      {
         this.ui.popup_pen.visible = true;
      }
      
      private function hide_popup_pen(param1:MouseEvent) : void
      {
         this.ui.popup_pen.visible = false;
      }
      
      private function show_popup_real(param1:MouseEvent) : void
      {
         this.ui.popup_real.visible = true;
      }
      
      private function hide_popup_real(param1:MouseEvent) : void
      {
         this.ui.popup_real.visible = false;
      }
      
      private function join(param1:Event) : void
      {
         var _loc2_:Object = this.validate(true);
         if(_loc2_["failed"] || this.agree.selected == false)
         {
            trace("Nope, not going to do it...");
         }
         else
         {
            trace("Doing it!");
            this.remote.new_user(this.ui.username.text,this.ui.email.text,this.ui.password.text,this.joined);
            this.set_all(false);
         }
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
            this.remote.code = param1[1];
            _loc2_ = ExternalInterface.call("set_auth_cookie",param1[1]);
            trace("set_auth val: " + _loc2_);
            this.set_id(param1[0]);
         }
         else
         {
            trace("Error...");
            this.ui.pen_name_mc.visible = false;
            this.ui.username_error.text = "an error occured, please try again";
            this.ui.username_error.visible = true;
            this.set_all(true);
         }
      }
      
      private function checked(param1:Object) : void
      {
         trace("Username return: " + param1["username"] + ", " + param1["used"]);
         if(param1["used"] == 1)
         {
            this.checked_names[param1["username"]] = 1;
         }
         else
         {
            this.checked_names[param1["username"]] = 2;
         }
         this.validate();
      }
      
      private function checked_email(param1:Object) : void
      {
         trace("Email return: " + param1["email"] + ", " + param1["used"]);
         if(param1["used"] >= 1)
         {
            this.checked_emails[param1["email"]] = 1;
         }
         else
         {
            this.checked_emails[param1["email"]] = 2;
         }
         this.validate();
      }
      
      private function validate(param1:Boolean = false) : Object
      {
         var _loc3_:* = null;
         var _loc4_:RegExp = null;
         var _loc5_:* = null;
         var _loc6_:String = null;
         var _loc2_:Object = [];
         for(_loc3_ in this.fields)
         {
            this.fields[_loc3_].text = StringUtil.trim(this.fields[_loc3_].text);
         }
         _loc4_ = /^[a-z][\w.+-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
         if(this.username.text.length < 3)
         {
            this.ui.pen_name_mc.visible = false;
            _loc2_["username"] = "too short";
         }
         else if(this.checked_names[this.username.text])
         {
            if(this.checked_names[this.username.text] == 1)
            {
               this.ui.pen_name_mc.visible = false;
               _loc2_["username"] = "already used";
            }
            trace("Checked names: " + this.checked_names[this.username.text]);
         }
         else
         {
            this.remote.username_check(this.username.text,this.checked);
         }
         if(_loc4_.test(this.email.text) == false)
         {
            _loc2_["email"] = "not an email address";
         }
         else if(this.checked_emails[this.email.text])
         {
            if(this.checked_emails[this.email.text] == 1)
            {
               _loc2_["email"] = "already used";
            }
         }
         else
         {
            this.remote.email_check(this.email.text,this.checked_email);
         }
         if(this.password.text.length < 2)
         {
            _loc2_["password"] = "pasword too short";
         }
         for(_loc5_ in _loc2_)
         {
            this.error_labels[_loc5_].text = _loc2_[_loc5_];
         }
         trace("Final check");
         for(_loc3_ in this.fields)
         {
            _loc6_ = this.fields[_loc3_].name;
            trace("\t checking: " + _loc3_ + " " + this.fields[_loc3_] + " " + _loc6_);
            if(this.fields[_loc3_].text == "")
            {
               _loc2_["failed"] = 1;
               if(param1)
               {
                  this.error_labels[_loc6_].visible = true;
               }
            }
            else if(_loc2_[_loc6_])
            {
               _loc2_["failed"] = 1;
               this.error_labels[_loc6_].visible = true;
            }
            else
            {
               this.error_labels[_loc6_].visible = false;
               trace("No error yet...");
            }
         }
         return _loc2_;
      }
      
      private function focus_out(param1:Event) : void
      {
         var _loc2_:String = param1.currentTarget.name;
         var _loc3_:String = param1.currentTarget.text;
         trace(param1.type + " : " + _loc2_ + " " + param1.currentTarget.text);
         this.validate();
      }
   }
}
