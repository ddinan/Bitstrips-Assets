package com.bitstrips.builder
{
   import com.adobe.utils.StringUtil;
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import com.bitstrips.character.BodyBuilder;
   import com.bitstrips.character.Container;
   import com.bitstrips.character.Head;
   import com.bitstrips.character.skeleton.SkeletonBuddy;
   import com.bitstrips.core.ArtLoader;
   import com.bitstrips.ui.AlertBox;
   import com.bitstrips.ui.ArtLibrary;
   import com.bitstrips.ui.ColourBoxes;
   import com.bitstrips.ui.ErrorBlocker;
   import com.bitstrips.ui.ProgressBlocker;
   import com.bitstrips.ui.Signup;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public final class BodyBuilderWizard extends Sprite
   {
       
      
      public var switch_function:Function;
      
      private var clothing:Array;
      
      private var wizs:Array;
      
      private var glow:GlowFilter;
      
      public var user_signup:Signup;
      
      private var ui:wizardUI;
      
      private var body:SkeletonBuddy;
      
      private var avatar_labels:Array;
      
      private var head_lib:ArtLibrary;
      
      private var colours:Array;
      
      private var wizard_stage:uint = 0;
      
      private var body_container:Sprite;
      
      private var clothes_c:MovieClip;
      
      private var endclips:end_clips;
      
      private var heights:Array;
      
      private var save_button:SimpleButton;
      
      private var bod:BodyBuilder;
      
      private var friend_labels:Array;
      
      private var builds:Object;
      
      private var hair_c:MovieClip;
      
      public var update_prefix:Function;
      
      private var do_friend:Boolean = false;
      
      private var normal_labels:Array;
      
      public var char_name:TextField;
      
      private var head:Head;
      
      public var c:Container;
      
      private var art_loader:ArtLoader;
      
      public var pb:ProgressBlocker;
      
      private var blocker:Sprite;
      
      private var labels:Array;
      
      public function BodyBuilderWizard()
      {
         var t:TextField = null;
         normal_labels = [_("GENDER"),_("SKIN TONE"),_("BUILD"),_("HEIGHT"),_("HEAD"),_("HAIR"),_("NOSE"),_("EYES"),_("EYEBROWS"),_("MOUTH"),_("CLOTHING"),_("YOUR CHARACTER IS READY!")];
         avatar_labels = [_("ARE YOU:"),_("WHAT\'S YOUR SKIN TONE?"),_("WHAT\'S YOUR BUILD?"),_("HOW TALL ARE YOU?"),_("WHAT SHAPE IS YOUR HEAD?"),_("WHAT\'S YOUR HAIRSTYLE?"),_("WHAT KIND OF NOSE DO YOU HAVE?"),_("WHAT KIND OF EYES DO YOU HAVE?"),_("WHAT KIND OF EYEBROWS DO YOU HAVE?"),_("WHAT KIND OF MOUTH DO YOU HAVE?"),_("WHAT ARE YOU WEARING?"),_("YOUR AVATAR IS READY!")];
         friend_labels = [_("IS YOUR FRIEND:"),_("WHAT\'S THEIR SKIN TONE?"),_("WHAT\'S THEIR BUILD?"),_("HOW TALL ARE THEY?"),_("WHAT SHAPE IS THEIR HEAD?"),_("WHAT\'S THEIR HAIRSTYLE?"),_("WHAT KIND OF NOSE DO THEY HAVE?"),_("WHAT KIND OF EYES DO THEY HAVE?"),_("WHAT KIND OF EYEBROWS DO THEY HAVE?"),_("WHAT KIND OF MOUTH DO THEY HAVE?"),_("WHAT DO THEY WEAR?"),_("YOUR FRIEND IS READY!")];
         blocker = new Sprite();
         body_container = new Sprite();
         ui = new wizardUI();
         glow = new GlowFilter(65280,8,8,5);
         heights = [4,3,0,1,2];
         colours = [15983070,16764057,14467743,13407847,9001789];
         builds = {
            1:[3,0,1,5],
            2:[9,7,8,10]
         };
         clothing = [["shirt02","pants05"],["shirt02","pants06","sock02","shoe02"],["shirt01","pants02","sock02","shoe02"],["shirt03","pants03","sock02","shoe01","tie01"],["shirt03","pants03","sock02","shoe01","tie01","jacket01"]];
         super();
         art_loader = ArtLoader.getInstance();
         addChild(ui);
         labels = normal_labels;
         wizs = [ui.wiz_01,ui.wiz_02,ui.wiz_03,ui.wiz_04,ui.wiz_05,ui.wiz_06,ui.wiz_07,ui.wiz_08,ui.wiz_09,ui.wiz_10,ui.wiz_11,ui.wiz_12];
         for each(t in [ui.stage_lbl,ui.smileys.lbl_txt,ui.advanced_txt,ui.fine_tune])
         {
            BSConstants.tf_fix(t);
         }
         ui.smileys.lbl_txt.text = _("TRY OUT THEIR EMOTIONS:");
         endclips = new end_clips();
         char_name = endclips.char_name;
         char_name.text = _("Name");
         save_button = endclips.save_button;
         addChild(endclips);
         endclips.addEventListener("switch",function(param1:Event):void
         {
            switch_function(char_name.text);
         });
         endclips.addEventListener("start_over",function(param1:Event):void
         {
            start_over();
         });
         endclips.addEventListener("make_bs",function(param1:Event):void
         {
            bod.bs_save = true;
            save_it();
         });
         endclips.addEventListener("do_friend",function(param1:Event):void
         {
            do_friend = true;
            start_over();
         });
         save_button.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            save_it();
         });
         BSConstants.tf_fix(endclips.edit_txt);
         BSConstants.tf_fix(endclips.save_txt);
         endclips.edit_txt.mouseEnabled = endclips.save_txt.mouseEnabled = false;
         endclips.edit_txt.text = _("edit your design in more detail");
         endclips.save_txt.text = _("save");
         if(endclips.save_txt.text.length > 5)
         {
            endclips.save_txt.setTextFormat(new TextFormat(null,11));
         }
         if(BSConstants.EDU)
         {
            endclips.do_friend.visible = false;
            endclips.make_bs.visible = false;
            endclips.start_over.visible = false;
         }
         endclips.visible = ui.smileys.visible = false;
         c = new Container(wizs);
         c.over_updates = false;
         c.fx = false;
         c.click_function = function(param1:*):void
         {
            var _loc2_:int = 0;
            trace(param1);
            if(param1 is String)
            {
               _loc2_ = Number(param1.split("_")[1]) - 1;
            }
            else
            {
               _loc2_ = param1;
            }
            c.select(_loc2_);
            var _loc3_:uint = 0;
            while(_loc3_ < wizs.length)
            {
               wizs[_loc3_].alpha = 1;
               wizs[_loc3_].filters = [];
               _loc3_ = _loc3_ + 1;
            }
            _loc3_ = _loc2_ + 1;
            while(_loc3_ < wizs.length)
            {
               wizs[_loc3_].alpha = 0.55;
               _loc3_ = _loc3_ + 1;
            }
            trace("CLICK FUNCTION - STEP: " + _loc2_);
            var _loc4_:GlowFilter = new GlowFilter(52479);
            wizs[_loc2_].filters = [_loc4_];
            ui.stage_lbl.text = labels[_loc2_];
            wizard_stage = _loc2_;
            set_stage(wizard_stage);
         };
         addChild(body_container);
         body_container.y = 430;
         ui.advanced_txt.text = _("ADVANCED BUILDER");
         ui.advanced_txt.mouseEnabled = false;
         ui.fine_tune.text = _("FINE-TUNE YOUR\nDESIGN WITH MORE\nARTWORK AND OPTIONS");
         ui.switch_mode.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            switch_function(char_name.text);
         });
      }
      
      private function hair_colour_setup(param1:DisplayObjectContainer) : void
      {
         var _loc2_:ColourBoxes = new ColourBoxes(new GradientBox(),1,true);
         param1.addChild(_loc2_);
         _loc2_.update_func = update_hair;
         _loc2_.y = 14;
         _loc2_.x = 132;
         _loc2_.set_base_colour("926715");
         var _loc3_:uint = int("0x" + "926715");
      }
      
      private function update_shirt(param1:int) : void
      {
         var _loc2_:* = null;
         for(_loc2_ in bod.brothers)
         {
            bod.brothers[_loc2_].cld.set_colour("fffffe",param1);
         }
         bod.head.cld.set_colour("fffffe",param1);
      }
      
      private function start_over() : void
      {
         var btnData:Array = null;
         var msg:String = "";
         if(do_friend == false)
         {
            btnData = [{
               "txt":_("Start Over"),
               "f":function(param1:Event):void
               {
                  if(do_friend)
                  {
                     bod.friend = true;
                  }
                  restart();
               }
            },{
               "txt":_("Cancel"),
               "f":function(param1:Event):void
               {
                  trace("Cancel");
               }
            }];
            msg = _("Starting over\n\nAre you sure you want to restart? You will lose any changes you\'ve made");
         }
         else
         {
            btnData = [{
               "txt":"Design Friend",
               "f":function(param1:Event):void
               {
                  if(do_friend)
                  {
                     bod.friend = true;
                  }
                  restart();
               }
            },{
               "txt":"Save Changes",
               "f":function(param1:Event):void
               {
                  if(do_friend)
                  {
                     bod.friend = true;
                  }
                  save_it(restart);
               }
            },{
               "txt":"Cancel",
               "f":function(param1:Event):void
               {
                  trace("Cancel");
               }
            }];
            msg = _("You are about to design a friend\n\nSave your current character?");
         }
         blocker.visible = true;
         var alertBox:AlertBox = new AlertBox(msg,btnData,this);
         alertBox.set_closeFunc(function():void
         {
            blocker.visible = false;
         });
         alertBox.x = (750 - alertBox.width) / 2;
         alertBox.y = 300;
      }
      
      private function restart(param1:* = null) : void
      {
         pb.status = "Restarting";
         if(bod.friend)
         {
            navigateToURL(new URLRequest(bod.remote.base_url + "create/friend/"),"_self");
            pb.visible = true;
            bod.name = "Name";
            char_name.text = "Name";
            char_name.type = "input";
            labels = friend_labels;
         }
         else if(bod.avatar)
         {
            labels = avatar_labels;
         }
         else
         {
            labels = normal_labels;
         }
         pb.visible = true;
         ExternalInterface.call("location.reload");
         trace("Yeah! I\'m restarting!");
         bod.restart();
         c.click_function(0);
         update_prefix();
      }
      
      private function update_hair(param1:int) : void
      {
         bod.head.cld.set_colour("926715",param1);
         head_lib.head_event("new_colour");
         head_lib.type_click("wiz" + wizard_stage);
      }
      
      private function smile(param1:Event) : void
      {
         var _loc2_:* = null;
         if(wizard_stage == 12)
         {
            return;
         }
         param1.currentTarget.head.set_expression(2);
         for(_loc2_ in bod.brothers)
         {
            if(bod.brothers[_loc2_] != param1.currentTarget)
            {
               bod.brothers[_loc2_].head.set_expression(1);
            }
         }
      }
      
      private function save_it(param1:Function = null) : void
      {
         var saving:Boolean = false;
         var callback:Function = param1;
         char_name.text = StringUtil.trim(char_name.text);
         if(char_name.text == "" || char_name.text == "Name")
         {
            endclips.name_box.gotoAndPlay(2);
            return;
         }
         if(BSConstants.EDU == false && bod.user_id <= 0)
         {
            user_signup.username.text = char_name.text;
            user_signup.set_id = function(param1:Number):void
            {
               bod.user_id = param1;
               user_signup.visible = false;
               save_it();
            };
            user_signup.visible = true;
            return;
         }
         save_button.enabled = false;
         bod.name = char_name.text;
         saving = bod.save(char_name.text,callback,onSaveError);
         if(saving)
         {
            pb.show("Saving");
         }
      }
      
      private function brother_setup(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:SkeletonBuddy = null;
         trace("Hello from brother setup: " + param1 + " " + bod + " - " + bod.brothers);
         for(_loc2_ in bod.brothers)
         {
            trace("\t" + _loc2_ + " " + bod.brothers[_loc2_] + " - " + body_container);
            _loc3_ = bod.brothers[_loc2_];
            _loc3_.name = _loc2_;
            body_container.addChild(_loc3_);
            _loc3_.x = 750 / 5 * Number(_loc2_);
            _loc3_.addEventListener(MouseEvent.CLICK,brother_click);
            _loc3_.addEventListener(MouseEvent.ROLL_OVER,brother_over);
            _loc3_.addEventListener(MouseEvent.ROLL_OUT,brother_out);
            _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,close_eyes);
            _loc3_.addEventListener(MouseEvent.MOUSE_UP,open_eyes);
         }
         trace("Done brother setup");
         blocker.graphics.clear();
         blocker.graphics.beginFill(0,0.2);
         blocker.graphics.drawRect(-100,-100,1000,1000);
         addChild(blocker);
         blocker.visible = false;
         set_stage(wizard_stage);
      }
      
      private function close_eyes(param1:Event) : void
      {
         if(wizard_stage == 11)
         {
            param1.currentTarget.head.set_lids([5,5]);
         }
      }
      
      private function brother_out(param1:Event) : void
      {
         param1.currentTarget.filters = [];
      }
      
      private function open_eyes(param1:Event) : void
      {
         if(wizard_stage == 11)
         {
            param1.currentTarget.head.set_lids([1,1]);
         }
      }
      
      public function set_bod(param1:BodyBuilder) : void
      {
         var new_bod:BodyBuilder = param1;
         bod = new_bod;
         body = bod.body;
         head_lib = bod.wiz_head_lib;
         addChild(head_lib);
         head_lib.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            wizard_stage = wizard_stage + 1;
            c.click_function(wizard_stage);
         });
         head_lib.visible = false;
         hair_c = new hair_colour();
         BSConstants.tf_fix(hair_c.hair_txt);
         hair_c.hair_txt.text = _("HAIR COLOR");
         addChild(hair_c);
         hair_c.x = 250;
         hair_c.y = 485;
         hair_colour_setup(hair_c);
         clothes_c = new clothes_colour();
         addChild(clothes_c);
         clothes_colour_setup(clothes_c);
         clothes_c.x = 70;
         clothes_c.y = 475;
         BSConstants.tf_fix(clothes_c.shirt_txt);
         BSConstants.tf_fix(clothes_c.pants_txt);
         clothes_c.shirt_txt.text = _("SHIRT");
         clothes_c.pants_txt.text = _("PANTS");
         bod.addEventListener("brothers_loaded",brother_setup);
         bod.load_brothers();
         if(bod.avatar)
         {
            endclips.make_bs_them.visible = false;
            labels = avatar_labels;
            if(bod.user_id)
            {
               if(bod.bb_type != 3)
               {
                  char_name.type = "dynamic";
               }
            }
         }
         else if(bod.friend)
         {
            labels = friend_labels;
         }
         c.click_function(0);
         if(bod.bb_type == 4)
         {
            endclips.make_bs.visible = false;
            endclips.do_friend.visible = false;
            endclips.make_bs_them.visible = false;
            endclips.start_over.visible = false;
         }
      }
      
      private function clothes_colour_setup(param1:DisplayObjectContainer) : void
      {
         var _loc2_:ColourBoxes = new ColourBoxes(new GradientBox(),1,false);
         var _loc3_:ColourBoxes = new ColourBoxes(new GradientBox(),1,false);
         var _loc4_:int = 16777215;
         var _loc5_:int = 16777215;
         param1.addChild(_loc2_);
         param1.addChild(_loc3_);
         _loc2_.x = 65;
         _loc2_.y = 12;
         _loc3_.x = 355;
         _loc3_.y = _loc2_.y;
         _loc3_.set_base_colour("f5f5f5");
         _loc2_.set_base_colour("fffffe");
         _loc2_.update_func = update_shirt;
         _loc3_.update_func = update_pants;
      }
      
      private function update_pants(param1:int) : void
      {
         var _loc2_:* = null;
         for(_loc2_ in bod.brothers)
         {
            bod.brothers[_loc2_].cld.set_colour("f5f5f5",param1);
         }
         bod.brothers[4].cld.set_colour("D4D4D4",param1);
         bod.head.cld.set_colour("f5f5f5",param1);
         bod.head.cld.set_colour("D4D4D4",param1);
      }
      
      private function normal(param1:Event) : void
      {
         param1.currentTarget.head.set_lids(1);
      }
      
      private function brother_click(param1:Event) : void
      {
         var _loc3_:* = null;
         trace("Brother clicked!" + param1.currentTarget.name);
         var _loc2_:Number = param1.currentTarget.name;
         if(wizard_stage == 11)
         {
            return;
         }
         if(wizard_stage == 0)
         {
            bod.set_sex(_loc2_ + 1);
         }
         else if(wizard_stage == 1)
         {
            bod.body.cld.set_colour("ffcc99",colours[_loc2_]);
         }
         else if(wizard_stage == 2)
         {
            bod.body.body_type = builds[body.sex][_loc2_];
         }
         else if(wizard_stage == 3)
         {
            bod.body.body_height = heights[_loc2_];
         }
         else if(wizard_stage == 10)
         {
            bod.naked(bod.body);
            for(_loc3_ in clothing[_loc2_])
            {
               bod.body.add_clothing(clothing[_loc2_][_loc3_]);
            }
         }
         wizard_stage = wizard_stage + 1;
         c.click_function(wizard_stage);
      }
      
      private function onSaveError(param1:Object) : void
      {
         var _loc3_:String = null;
         trace("There was an error saving..." + _loc3_);
         pb.visible = false;
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
      
      private function set_stage(param1:uint) : void
      {
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         trace("Set stage: " + wizard_stage);
         if(bod == null || bod.brothers.length == 0)
         {
            return;
         }
         trace("OK");
         bod.equalize();
         body_container.visible = true;
         clothes_c.visible = hair_c.visible = endclips.visible = ui.smileys.visible = head_lib.visible = false;
         if(wizard_stage == 0)
         {
            bod.sex_options();
            body_align(2);
         }
         else if(wizard_stage == 1)
         {
            body_align(5);
            for(_loc2_ in colours)
            {
               trace("Setting the colours for : -------------------------------------------------------- " + _loc2_);
               bod.brothers[_loc2_].cld.set_colour("ffcc99",colours[_loc2_]);
               bod.brothers[_loc2_].update_colours();
               bod.brothers[_loc2_].head.update_colours();
            }
         }
         else if(wizard_stage == 2)
         {
            body_align(4);
            trace("Setting body types:  ------------ " + bod.body.sex);
            for(_loc3_ in builds[bod.body.sex])
            {
               bod.brothers[_loc3_].body_type = builds[bod.body.sex][_loc3_];
               trace("\t\t\t\t\tBUILD: " + _loc3_ + " " + body.sex + ", " + builds[bod.body.sex][_loc3_]);
            }
         }
         else if(wizard_stage == 3)
         {
            body_align(5);
            bod.brothers[0].body_height = 4;
            bod.brothers[1].body_height = 3;
            bod.brothers[2].body_height = 0;
            bod.brothers[3].body_height = 1;
            bod.brothers[4].body_height = 2;
         }
         else if(wizard_stage >= 4 && wizard_stage <= 9)
         {
            body_container.visible = false;
            head_lib.visible = true;
            head_lib.type_click("wiz" + wizard_stage);
            if(wizard_stage == 5)
            {
               hair_c.visible = true;
            }
            if(wizard_stage == 4)
            {
               art_loader.clothing_queue("shirt03");
               art_loader.clothing_queue("pants03");
            }
            else if(wizard_stage == 5)
            {
               art_loader.clothing_queue("shirt01");
               art_loader.clothing_queue("pants02");
            }
            else if(wizard_stage == 6)
            {
               art_loader.clothing_queue("pants06");
            }
         }
         else if(wizard_stage == 10)
         {
            body_align(5);
            for(_loc2_ in clothing)
            {
               bod.naked(bod.brothers[_loc2_]);
               for(_loc4_ in clothing[_loc2_])
               {
                  trace("----------------------------- Adding: " + _loc2_ + ", " + clothing[_loc2_][_loc4_]);
                  bod.brothers[_loc2_].add_clothing(clothing[_loc2_][_loc4_]);
               }
               trace("--------- FInal clothes: " + bod.brothers[_loc2_].clothes);
            }
            clothes_c.visible = true;
         }
         else if(wizard_stage == 11)
         {
            body_align(1);
            endclips.visible = ui.smileys.visible = true;
            ui.smileys.head = bod.brothers[0].head;
            ui.smileys.head2 = bod.head;
            bod.brothers[0].head.set_expression(2);
            bod.head.set_expression(2);
         }
      }
      
      private function brother_over(param1:Event) : void
      {
         if(wizard_stage != 11)
         {
            param1.currentTarget.filters = [glow];
         }
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      private function body_align(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < bod.brothers.length)
         {
            if(_loc2_ < param1)
            {
               body_container.addChild(bod.brothers[_loc2_]);
            }
            else if(bod.brothers[_loc2_].parent)
            {
               body_container.removeChild(bod.brothers[_loc2_]);
            }
            bod.brothers[_loc2_].x = 750 / 5 * _loc2_;
            _loc2_++;
         }
         if(param1 == 2)
         {
            bod.brothers[1].x = bod.brothers[1].x + 100;
         }
         var _loc3_:Rectangle = body_container.getBounds(body_container);
         body_container.x = 750 / 2 - (_loc3_.x + _loc3_.width / 2);
         trace(_loc3_ + " " + body_container.x);
      }
   }
}
