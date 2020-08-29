package com.bitstrips.builder
{
   import br.com.stimuli.loading.BulkProgressEvent;
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import com.bitstrips.BitStrips;
   import com.bitstrips.character.Body;
   import com.bitstrips.character.BodyBuilder;
   import com.bitstrips.character.Head;
   import com.bitstrips.ui.ErrorBlocker;
   import com.bitstrips.ui.ProgressBlocker;
   import com.bitstrips.ui.Signup;
   import flash.display.Sprite;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.system.Security;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   
   public class BodyBuilderUI extends Sprite
   {
       
      
      private var display:String = "wiz";
      
      private var wiz_set:Boolean = false;
      
      private var user_signup:Signup;
      
      private var build_set:Boolean = false;
      
      private var prefix:String = "CHARACTER";
      
      private var builder_type:TextField;
      
      private var head:Head;
      
      private var body:Body;
      
      private var btype:int = 0;
      
      private var back:Sprite;
      
      private var wiz:BodyBuilderWizard;
      
      private var pb:ProgressBlocker;
      
      private var bs:BitStrips;
      
      private var build:BodyBuilderFull;
      
      public var bod:BodyBuilder;
      
      public function BodyBuilderUI(param1:BitStrips = null)
      {
         var new_bs:BitStrips = param1;
         Security.allowDomain("*");
         super();
         pb = new ProgressBlocker(750,560,_("Loading"));
         addChild(pb);
         pb.show(_("Loading"),true);
         if(new_bs != null)
         {
            bs = new_bs;
            btype = 4;
         }
         else
         {
            bs = new BitStrips();
            bs.addEventListener(BitStrips.ERROR,bs_error);
            if(BSConstants.TESTING)
            {
               bs.init("file://",BSConstants.params);
               if(BSConstants.params.hasOwnProperty("btype"))
               {
                  btype = BSConstants.params["btype"];
               }
            }
            else
            {
               bs.init(loaderInfo.url,loaderInfo.parameters);
               btype = loaderInfo.parameters.btype;
            }
         }
         if(BSConstants.EDU && bs.user_id <= 0)
         {
            trace("Error - please log in");
            pb.show("Error");
            pb.message = "Log in to use this tool";
            return;
         }
         this.contextMenu = bs.contextMenu;
         bod = new BodyBuilder(bs,btype);
         user_signup = new Signup(bs.remote);
         addChild(user_signup);
         user_signup.x = 120;
         user_signup.y = 150;
         user_signup.visible = false;
         if(bod.user_id <= 0)
         {
            user_signup.set_id = function(param1:int):void
            {
               bod.user_id = param1;
               user_signup.visible = false;
            };
            user_signup.cancel_call = function():void
            {
               trace("Doing the cancel call, yeah!: ");
               user_signup.visible = false;
            };
         }
         if(bod.done == false)
         {
            bod.addEventListener("loaded",loaded);
            bod.char_loader.addEventListener(BulkProgressEvent.PROGRESS,function(param1:BulkProgressEvent):void
            {
               pb.progress = param1.weightPercent;
               pb.message = _("Loading Artwork:") + " " + param1.itemsLoaded + " " + _("of") + " " + param1.itemsTotal;
            });
            pb.message = _("Loading Character Art");
         }
         else
         {
            loaded(null);
         }
         bod.addEventListener("CLOSE_BUILDER",dispatchEvent);
         var tmp:Array = [_("Gender"),_("Skin Tone"),_("Build"),_("Height"),_("Head")];
      }
      
      private function loaded(param1:Event) : void
      {
         var tf:TextField = null;
         var e:Event = param1;
         pb.hide();
         trace("Body loaded - showing wizard");
         build = new BodyBuilderFull();
         wiz = new BodyBuilderWizard();
         trace("SETTING EVERYONE\'S NAME");
         wiz.char_name.text = build.char_name.text = bod.name;
         if(bs.user_id && this.btype == 3)
         {
            wiz.char_name.type = build.char_name.type = TextFieldType.DYNAMIC;
            wiz.char_name.selectable = build.char_name.selectable = false;
         }
         if(bod.avatar)
         {
            prefix = _("AVATAR");
         }
         else if(bod.friend)
         {
            prefix = _("FRIEND");
         }
         if(display == "wiz")
         {
            load_wiz();
         }
         else
         {
            trace("Doing load build: ");
            load_build();
            trace("Done load build");
         }
         bod.removeEventListener("loaded",loaded);
         if(bod.bb_type == 4)
         {
            back = new Sprite();
            tf = new TextField();
            BSConstants.tf_fix(tf);
            tf.text = _("Back to Comic");
            addChild(tf);
            tf.x = 12;
            tf.y = -2;
            tf.width = 200;
            tf.selectable = false;
            tf.mouseEnabled = false;
            back.graphics.lineStyle(2);
            back.graphics.drawRect(2,2,10,10);
            back.graphics.moveTo(2,2);
            back.graphics.lineTo(12,12);
            back.graphics.moveTo(2,12);
            back.graphics.lineTo(12,2);
            back.graphics.lineStyle(0,0,0);
            back.graphics.beginFill(0,0);
            back.graphics.drawRect(0,0,150,15);
            addChild(back);
            back.buttonMode = true;
            back.addEventListener(MouseEvent.CLICK,function(param1:Event):void
            {
               dispatchEvent(new Event("CLOSE_BUILDER"));
            });
         }
         else
         {
            builder_type = new TextField();
            BSConstants.tf_fix(builder_type);
            builder_type.text = _("CHARACTER BUILDER");
            addChild(builder_type);
            builder_type.x = -1;
            builder_type.y = -2;
            builder_type.width = 300;
            builder_type.selectable = false;
            builder_type.mouseEnabled = false;
            addChild(builder_type);
            ExternalInterface.call("leave_block");
         }
      }
      
      private function update_prefix() : void
      {
         if(bod.friend)
         {
            prefix = _("FRIEND");
         }
         else if(bod.avatar)
         {
            prefix = _("AVATAR");
         }
         else
         {
            prefix = _("CHARACTER");
         }
         if(builder_type == null)
         {
            return;
         }
         if(display == "wiz")
         {
            builder_type.text = prefix + " " + _("WIZARD");
         }
         else
         {
            builder_type.text = prefix + " " + _("BUILDER");
         }
      }
      
      private function load_wiz() : void
      {
         wiz.visible = true;
         if(wiz_set)
         {
            wiz.c.click_function(0);
            return;
         }
         addChild(wiz);
         wiz.pb = pb;
         wiz.user_signup = user_signup;
         wiz.switch_function = switch_it;
         wiz.set_bod(bod);
         wiz_set = true;
         wiz.update_prefix = update_prefix;
         pb.on_top();
         setChildIndex(user_signup,numChildren - 1);
      }
      
      private function load_build() : void
      {
         build.visible = true;
         if(build_set)
         {
            return;
         }
         addChild(build);
         build.pb = pb;
         build.user_signup = user_signup;
         build.switch_function = switch_it;
         build.set_bod(bod);
         build_set = true;
         if(builder_type)
         {
            setChildIndex(builder_type,numChildren - 1);
         }
         pb.on_top();
         update_prefix();
         setChildIndex(user_signup,numChildren - 1);
      }
      
      private function bs_error(param1:ErrorEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:ErrorBlocker = new ErrorBlocker(stage.stageWidth,stage.stageHeight,_("An error has occured"),true);
         this.addChild(_loc2_);
         _loc2_.show(_("An error has occured"));
         _loc2_.on_top();
         _loc3_ = param1.text;
         var _loc4_:String = param1.text;
         if(_loc4_.search("Error #2036: Load Never Completed. URL: ") >= 0)
         {
            _loc3_ = _loc3_ + ("\n" + _("Can\'t Load: ") + _loc4_.substr(40));
         }
         _loc2_.message = _loc3_;
      }
      
      private function switch_it(param1:String = "blah") : void
      {
         trace("Switching...");
         bod.equalize();
         if(display == "wiz")
         {
            trace("Switching to build");
            build.char_name.text = wiz.char_name.text;
            display = "build";
            load_build();
            build.do_edit_face();
            build.head_buttons.select("hb_0");
            build.head_buttons.click_function("hb_0");
            wiz.visible = false;
         }
         else
         {
            wiz.char_name.text = build.char_name.text;
            display = "wiz";
            load_wiz();
            wiz.c.click_function(0);
            build.visible = false;
         }
         pb.on_top();
         setChildIndex(pb,numChildren - 1);
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
   }
}
