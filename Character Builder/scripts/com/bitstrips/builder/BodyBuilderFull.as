package com.bitstrips.builder
{
   import com.adobe.utils.StringUtil;
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import com.bitstrips.Utils;
   import com.bitstrips.character.BodyBuilder;
   import com.bitstrips.character.Container;
   import com.bitstrips.character.Head;
   import com.bitstrips.character.skeleton.SkeletonBuddy;
   import com.bitstrips.controls.BodyBuild;
   import com.bitstrips.controls.CharControls;
   import com.bitstrips.core.ArtEvent;
   import com.bitstrips.ui.ArtLibrary;
   import com.bitstrips.ui.BodyArtLibrary;
   import com.bitstrips.ui.ColourBoxes;
   import com.bitstrips.ui.ErrorBlocker;
   import com.bitstrips.ui.ProgressBlocker;
   import com.bitstrips.ui.Signup;
   import com.bitstrips.ui.TabDisplay;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class BodyBuilderFull extends Sprite
   {
       
      
      public var switch_function:Function;
      
      private var lib:ArtLibrary;
      
      private var head_edit:Boolean = false;
      
      public var user_signup:Signup;
      
      private var male:Bitmap;
      
      private var ui:builderUI;
      
      private var tabs:TabDisplay;
      
      private var body_stuff:Sprite;
      
      private var fully_loaded:Boolean = true;
      
      private var body:SkeletonBuddy;
      
      private var bodylib:BodyArtLibrary;
      
      private var body_container:Sprite;
      
      public var head_buttons:Container;
      
      private var bod:BodyBuilder;
      
      private var edit_mode:Container;
      
      private var female:Bitmap;
      
      public var char_name:TextField;
      
      private var cb:Array;
      
      private var head:Head;
      
      private var body_buttons:Container;
      
      public var pb:ProgressBlocker;
      
      private var build:BodyBuild;
      
      private var clot2cat:Object;
      
      private var saving:Boolean = false;
      
      private var char_controls:CharControls;
      
      public function BodyBuilderFull()
      {
         var t:TextField = null;
         var tf:TextFormat = null;
         male = new Bitmap();
         female = new Bitmap();
         ui = new builderUI();
         cb = new Array();
         clot2cat = {
            "bare":1,
            "shirts":2,
            "sweaters":3,
            "jackets":4,
            "pants":5,
            "skirts":6,
            "socks":7,
            "shoes":7,
            "gloves":8,
            "hats":9,
            "jewels":10,
            "ties":10,
            "backthings":11,
            "beltthings":11
         };
         super();
         addChild(ui);
         tabs = init_tabs();
         addChild(tabs);
         char_name = ui.char_name;
         char_name.addEventListener(FocusEvent.FOCUS_IN,function(param1:Event):void
         {
            if(char_name.text == "Name")
            {
               char_name.text = "";
            }
         });
         body_stuff = new Sprite();
         ui.addChild(body_stuff);
         body_stuff.x = 440;
         body_stuff.y = 175;
         build = new BodyBuild();
         body_stuff.addChild(build);
         ui.switch_mode.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            switch_function();
         });
         body_container = new Sprite();
         addChild(body_container);
         body_container.x = body_container.x + 282;
         body_container.y = body_container.y + 536;
         head_buttons = new Container([ui.hb_0,ui.hb_1,ui.hb_2,ui.hb_3,ui.hb_4,ui.hb_5,ui.hb_6,ui.hb_7,ui.hb_8,ui.hb_9,ui.hb_10,ui.hb_11]);
         head_buttons.fx = false;
         head_buttons.over_updates = false;
         head_buttons.click_function = head_button_click;
         ui.lib_big.visible = ui.lib_small_bottom.visible = ui.lib_small_top.visible = false;
         body_buttons = new Container([ui.bd_0,ui.bd_1,ui.bd_2,ui.bd_3,ui.bd_4,ui.bd_5,ui.bd_6,ui.bd_7,ui.bd_8,ui.bd_9,ui.bd_10,ui.bd_11]);
         body_buttons.fx = false;
         body_buttons.over_updates = false;
         body_buttons.select(0);
         body_buttons.click_function = body_click_function;
         var cb_sprite:Sprite = new Sprite();
         addChild(cb_sprite);
         var i:uint = 0;
         while(i < 3)
         {
            cb.push(new ColourBoxes(new GradientBox(),1));
            cb_sprite.addChild(cb[cb.length - 1]);
            i = i + 1;
         }
         cb_sprite.x = ui.cb_container.x;
         cb_sprite.y = ui.cb_container.y;
         colour_click_call([]);
         male.smoothing = true;
         female.smoothing = true;
         for each(t in [ui.easy_txt,ui.edit_face.face_txt,ui.edit_body.body_txt,ui.save_txt])
         {
            BSConstants.tf_fix(t);
            t.mouseEnabled = false;
         }
         ui.easy_txt.text = _("EASY");
         if(ui.easy_txt.text.length > 5)
         {
            ui.easy_txt.y = ui.easy_txt.y + 2;
            ui.easy_txt.setTextFormat(new TextFormat(null,10));
         }
         ui.edit_face.face_txt.text = _("FACE");
         ui.edit_body.body_txt.text = _("BODY");
         ui.save_txt.text = _("SAVE");
      }
      
      private function colour_click_call(param1:Array) : void
      {
         trace("Colour Click Call: " + param1);
         cb[0].visible = cb[1].visible = cb[2].visible = false;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            if(_loc2_ >= 3)
            {
               trace("NOT ENOUGH COLOUR BOXES!");
            }
            else
            {
               cb[_loc2_].set_base_colour(param1[_loc2_]);
               cb[_loc2_].visible = true;
            }
            _loc2_ = _loc2_ + 1;
         }
         BSConstants.tf_fix(ui.cb_container.colours);
         ui.cb_container.colours.text = _("Colours:");
         ui.cb_container.gotoAndStop(param1.length);
         trace("Colours Length: " + param1.length);
         var _loc3_:Number = -20 * param1.length;
         cb[0].x = 12;
         cb[0].y = 8 + _loc3_;
         cb[1].x = cb[0].x;
         cb[1].y = cb[0].y + 20;
         cb[2].x = cb[0].x;
         cb[2].y = cb[1].y + 20;
      }
      
      private function do_edit_body() : void
      {
         if(head_edit == false)
         {
            return;
         }
         edit_mode.select(1);
         head_edit = false;
         body.edit = true;
         body.scaleX = body.scaleY = 1;
         body.y = -5;
         head.edit = false;
         head.buttonMode = true;
         body_buttons.show();
         head_buttons.hide();
         body_stuff.visible = true;
         ui.lib_big.visible = lib.visible = false;
      }
      
      private function save_it(param1:Event) : void
      {
         var event:Event = param1;
         char_name.text = StringUtil.trim(char_name.text);
         if(char_name.text == "" || char_name.text == "Name" || saving == true)
         {
            ui.name_flash.gotoAndPlay(2);
            return;
         }
         if(bod.user_id <= 0 && BSConstants.EDU == false)
         {
            user_signup.set_id = function(param1:Number):void
            {
               bod.user_id = param1;
               user_signup.visible = false;
               save_it(new Event("chicken"));
            };
            user_signup.username.text = char_name.text;
            user_signup.visible = true;
            Utils.on_top(user_signup);
            return;
         }
         ui.save_button.enabled = false;
         bod.name = char_name.text;
         saving = bod.save(char_name.text,null,onSaveError);
         if(saving)
         {
            pb.show("Saving");
         }
      }
      
      private function head_button_click(param1:String) : void
      {
         var _loc3_:* = null;
         var _loc2_:Number = Number(param1.split("_")[1]);
         for(_loc3_ in lib.hb_tags)
         {
            if(lib.hb_tags[_loc3_] == _loc2_)
            {
               trace("\t CLicking on: " + _loc3_);
               lib.type_click(_loc3_);
               break;
            }
         }
         lib.type_click(lib.hb_tags[_loc2_]);
      }
      
      public function do_edit_face() : void
      {
         edit_mode.select(0);
         head_edit = true;
         body.scaleX = body.scaleY = 2;
         var _loc1_:Number = body.get_bone("head").y;
         body.y = -_loc1_ * 2 - 120;
         head.edit = true;
         head.buttonMode = false;
         body.edit = false;
         body_buttons.hide();
         head_buttons.show();
         lib.visible = true;
         body_stuff.visible = false;
         ui.lib_big.visible = lib.visible = true;
      }
      
      private function sex_bmps() : void
      {
         bod.sex_options();
         male.bitmapData = bod.brothers[0].dodat();
         female.bitmapData = bod.brothers[1].dodat();
         male.smoothing = true;
         female.smoothing = true;
      }
      
      public function init_tabs() : TabDisplay
      {
         var _loc1_:TabDisplay = new TabDisplay(!BSConstants.EDU);
         char_controls = new CharControls();
         char_controls.x = 10;
         char_controls.y = 30;
         char_controls.visible = true;
         _loc1_.setData({"tabDataList":[{
            "name":"instance",
            "label":_("CONTROLS"),
            "colour":16750899,
            "clip":char_controls
         }]});
         _loc1_.focusTab("instance");
         return _loc1_;
      }
      
      private function body_art_click(param1:ArtEvent) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc2_:Object = Utils.art_split(param1.art_type);
         var _loc3_:String = _loc2_["type"];
         if(_loc3_ != "bare")
         {
            _loc4_ = bodylib.type_to_category(_loc3_);
            if(_loc4_)
            {
               body_buttons.select(clot2cat[_loc4_]);
               body_buttons.click_function("bd_" + clot2cat[_loc4_]);
            }
         }
         else
         {
            _loc5_ = _loc2_["part"];
            _loc6_ = 0;
            if(_loc5_ == "foot")
            {
               _loc6_ = clot2cat["shoes"];
            }
            else if(_loc5_ == "hand")
            {
               _loc6_ = clot2cat["gloves"];
            }
            else if(_loc5_ == "shin" || _loc5_ == "thigh" || _loc5_ == "pelvis")
            {
               _loc6_ = clot2cat["pants"];
            }
            else if(_loc5_ == "fore" || _loc5_ == "bicep" || _loc5_ == "pelvis" || _loc5_ == "breasts" || _loc5_ == "torso_nude")
            {
               _loc6_ = clot2cat["shirts"];
            }
            if(_loc6_)
            {
               body_buttons.select(_loc6_);
               body_buttons.click_function("bd_" + _loc6_);
            }
            trace(_loc5_);
         }
         colour_click_call(param1.colours);
      }
      
      private function set_name(param1:String) : void
      {
         char_name.text = param1;
      }
      
      public function set_bod(param1:BodyBuilder) : void
      {
         var new_bod:BodyBuilder = param1;
         bod = new_bod;
         ui.save_button.addEventListener(MouseEvent.CLICK,save_it);
         if(bod.avatar && bod.user_id)
         {
            if(bod.bb_type != 3)
            {
               char_name.type = "dynamic";
               char_name.selectable = false;
            }
         }
         lib = bod.head_lib;
         addChild(lib);
         lib.x = 440;
         lib.y = 175;
         bodylib = bod.body_lib;
         body_stuff.addChild(bodylib);
         bodylib.visible = false;
         bodylib.addEventListener("LOADING",function(param1:Event):void
         {
            body_buttons.enabled = false;
         });
         bodylib.addEventListener("DONE_LOADING",function(param1:Event):void
         {
            body_buttons.enabled = true;
         });
         bodylib.body = bod.body;
         body = bod.body;
         head = body.head as Head;
         body_container.addChild(body);
         body.mask = ui.body_mask;
         stage.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            if(param1.eventPhase == 2 && param1.shiftKey == false)
            {
               head.trans.deselect();
            }
         });
         body.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            do_edit_body();
            param1.stopPropagation();
         },false,1000);
         head.colour_click_call = colour_click_call;
         head.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            do_edit_face();
            param1.stopPropagation();
         },false,100);
         head.head_back.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            do_edit_face();
            param1.stopPropagation();
         },false,100);
         cb[0].cld = cb[1].cld = cb[2].cld = body.cld;
         build.body = body;
         body_buttons.select("bd_0");
         body_buttons.click_function("bd_0");
         lib.head_buttons = head_buttons;
         lib.set_junk(ui.lib_big,ui.lib_small_top,ui.lib_small_bottom);
         char_controls.register(body);
         edit_mode = new Container([ui.edit_face,ui.edit_body]);
         edit_mode.select(1);
         edit_mode.over_updates = false;
         edit_mode.click_function = function(param1:String):void
         {
            if(param1 == "edit_face")
            {
               do_edit_face();
            }
            else
            {
               do_edit_body();
            }
         };
         body.addEventListener(ArtEvent.CLICK,body_art_click);
      }
      
      private function get_name() : String
      {
         return char_name.text;
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      private function body_click_function(param1:String) : void
      {
         body_stuff.visible = true;
         build.visible = bodylib.visible = false;
         var _loc2_:Number = Number(param1.split("_")[1]);
         if(_loc2_ == 0)
         {
            bod.equalize();
            sex_bmps();
            bodylib.category = "sex";
            bodylib.visible = true;
         }
         else if(_loc2_ == 1)
         {
            build.sex(body.sex);
            build.visible = true;
         }
         else
         {
            bodylib.visible = true;
            bodylib.section = _loc2_;
         }
      }
      
      private function onSaveError(param1:Object) : void
      {
         var _loc3_:String = null;
         trace("There was an error saving..." + _loc3_);
         pb.visible = false;
         saving = false;
         ui.save_button.enabled = true;
         trace("Error saving: " + param1);
         var _loc2_:ErrorBlocker = new ErrorBlocker(stage.stageWidth,stage.stageHeight,_("An error has occured"),true);
         this.addChild(_loc2_);
         _loc2_.show(_("An error has occured"));
         _loc2_.on_top();
         _loc3_ = _("Sorry, an error occured while saving. You will need to click \'Save\' again.");
         _loc3_ = _loc3_ + ("\n\n" + _("If the problem persists, please email us at support@bitstripsforschools.com"));
         _loc3_ = _loc3_ + ("\n\n" + _("Error: "));
         if(param1.hasOwnProperty("faultString"))
         {
            _loc3_ = _loc3_ + param1.faultString;
         }
         else
         {
            _loc3_ = _loc3_ + param1.toString();
         }
         _loc2_.message = _loc3_;
      }
   }
}
