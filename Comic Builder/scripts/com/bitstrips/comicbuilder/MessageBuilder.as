package com.bitstrips.comicbuilder
{
   import com.adobe.images.PNGEncoder;
   import com.bitstrips.BSConstants;
   import com.bitstrips.Utils;
   import com.bitstrips.character.ComicCharAsset;
   import com.bitstrips.comicbuilder.library.AssetDragEvent;
   import com.bitstrips.comicbuilder.library.LibraryManager;
   import com.bitstrips.controls.CharControls;
   import com.bitstrips.controls.ComicControls;
   import com.bitstrips.controls.ObjectControls;
   import com.bitstrips.core.ColorTools;
   import com.bitstrips.ui.TabDisplay;
   import fl.controls.Button;
   import fl.controls.CheckBox;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   
   public class MessageBuilder extends ComicBuilder
   {
       
      
      public var messageData:Object;
      
      public var controlChar:ComicAsset;
      
      public var controlBubble:TextBubble;
      
      public var myTitleBarMessage:TitleBarMessage;
      
      public var invite:Sprite;
      
      var send_btn:SimpleButton;
      
      var cancel_btn:SimpleButton;
      
      var invite_send_btn:Button;
      
      var invite_preview_btn:Button;
      
      var invite_cancel_btn:Button;
      
      var invite_cb:CheckBox;
      
      var invite_to_field:TextField;
      
      var invite_from_field:TextField;
      
      var invite_subj_field:TextField;
      
      var invite_msg_field:TextField;
      
      public var msg_content_char:String;
      
      public var msg_content_invite:String;
      
      private var message_controls:MessageControls;
      
      public function MessageBuilder()
      {
         if(debug)
         {
            trace("--MessageBuilder()--");
         }
         super();
      }
      
      override public function init() : void
      {
         if(debug)
         {
            trace("--MessageBuilder.init()--");
         }
         builder_name = "MESSAGE BUILDER";
         if(bs.user_id == 0)
         {
            throw new Error("Error - you must be logged in");
         }
         this.setMessageData();
         common_init();
         myTabDisplay = this.init_tabs();
         this.myTitleBarMessage = new TitleBarMessage(this);
         this.invite = new Sprite();
         this.send_btn = new SimpleButton();
         this.cancel_btn = new SimpleButton();
         myComic.killBorders();
         myComic.set_editable(false);
         initLoadConditions = {
            "author":false,
            "comic":false,
            "CharLoader":false
         };
         addChild(myDisplay);
         myDisplay.addChild(this.myTitleBarMessage);
         myDisplay.addChild(myOutline);
         myDisplay.addChild(myTabDisplay);
         addChild(init_title_field());
         this.message_controls = new MessageControls();
         myDisplay.addChild(this.message_controls);
         comic_controls = new ComicControls(myComic);
         comic_controls.tabChildren = comic_controls.tabEnabled = false;
         myComic.controls = comic_controls;
         myComic.move_mode = 3;
         initDraw();
         if(debug)
         {
            trace("Doing loadData");
         }
         loadData({
            "user_id":bs.user_id,
            "comic_id":this.messageData["reply_id"]
         });
      }
      
      override function init_tabs() : TabDisplay
      {
         var _loc1_:TabDisplay = new TabDisplay(false);
         instance_controls = new Sprite();
         char_controls = new CharControls();
         char_controls.x = 10;
         char_controls.y = 30;
         instance_controls.addChild(char_controls);
         char_controls.visible = true;
         prop_controls = new ObjectControls(this.myComic);
         instance_controls.addChild(prop_controls);
         prop_controls.visible = false;
         myLibraryManager = new LibraryManager(bs,["scenes"]);
         myLibraryManager.addEventListener(AssetDragEvent.ASSET_DRAG,dragAsset);
         myLibraryManager.basics = true;
         var _loc2_:Sprite = myLibraryManager.getDisplay();
         _loc1_.setData({"tabDataList":[{
            "name":"instance",
            "label":"CONTROLS",
            "colour":16750899,
            "clip":instance_controls
         },{
            "name":"library",
            "label":"ART LIBRARY",
            "colour":16711680,
            "clip":_loc2_
         }]});
         _loc1_.focusTab("instance");
         return _loc1_;
      }
      
      public function setMessageData() : void
      {
         var _loc3_:String = null;
         this.messageData = new Object();
         this.messageData = {"sender_id":bs.user_id};
         var _loc1_:Array = ["sender_char_id","receiver_id","receiver_char_id","message_type","reply_id","thread_id"];
         var _loc2_:Object = loaderInfo.parameters;
         if(BSConstants.TESTING)
         {
            _loc2_ = BSConstants.params;
         }
         for each(_loc3_ in _loc1_)
         {
            if(_loc2_.hasOwnProperty(_loc3_) == false)
            {
               throw new Error("Missing paramater: " + _loc3_);
            }
            this.messageData[_loc3_] = _loc2_[_loc3_];
         }
      }
      
      override function cursor_event(param1:CursorEvent) : void
      {
      }
      
      override public function drawMe() : void
      {
         var _loc3_:ComicAsset = null;
         var _loc5_:Number = NaN;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         cursor.enabled = false;
         pb.hide();
         if(debug)
         {
            trace("--MessageBuilder.drawMe()--");
         }
         myDisplay.visible = true;
         myAuthor.setData(authorData);
         myLibraryManager.drawMe();
         myComic.setData(comicData);
         myComic.drawMe();
         this.updateTitleBarMessage();
         var _loc1_:ComicAsset = myComic.getAssetByName("a_avatar");
         var _loc2_:TextBubble = myComic.getAssetByName("a_bubble") as TextBubble;
         _loc3_ = myComic.getAssetByName("b_avatar");
         var _loc4_:TextBubble = myComic.getAssetByName("b_bubble") as TextBubble;
         if(_loc1_ == null)
         {
         }
         if(_loc3_ == null)
         {
         }
         _loc1_.buttonMode = true;
         _loc3_.buttonMode = true;
         _loc1_.key_locked = _loc3_.key_locked = true;
         var _loc6_:ComicPanel = myComic.get_stripList()[0].getPanelList()[0];
         _loc6_.set_editable(false);
         _loc6_.killHilight();
         _loc6_.addEventListener(MouseEvent.CLICK,this.panel_click);
         myComic.selectAsset(null);
         if(this.messageData["message_type"] == "a")
         {
            myDisplay.addChildAt(comicDisplay,myDisplay.numChildren - 2);
            if(_loc2_)
            {
               _loc6_.removeAsset(_loc2_);
            }
            _loc9_ = DataDump.getMessageBubble_a();
            _loc2_ = myComic.addAssetToPanel(_loc9_,_loc6_,false) as TextBubble;
            this.controlChar = _loc1_;
            this.controlBubble = _loc2_;
            this.controlBubble.key_locked = true;
            _loc2_.max_width = 200;
            _loc2_.locked = false;
            if(_loc4_)
            {
               _loc4_.max_width = 200;
               _loc4_.locked = true;
            }
            _loc3_.locked = true;
            _loc1_.locked = false;
         }
         else if(this.messageData["message_type"] == "b")
         {
            myDisplay.addChildAt(comicDisplay,myDisplay.numChildren - 2);
            if(_loc4_)
            {
               _loc6_.removeAsset(_loc4_);
            }
            _loc10_ = DataDump.getMessageBubble_b();
            _loc4_ = myComic.addAssetToPanel(_loc10_,_loc6_,false) as TextBubble;
            _loc4_.max_width = 200;
            _loc4_.locked = false;
            if(_loc2_)
            {
               _loc2_.max_width = 200;
               _loc2_.locked = true;
            }
            _loc1_.locked = true;
            _loc3_.locked = false;
            this.controlChar = _loc3_;
            this.controlBubble = _loc4_;
            this.controlBubble.key_locked = true;
         }
         else if(this.messageData["message_type"] == "c")
         {
            myDisplay.addChild(this.invite);
            this.drawInvite();
            if(_loc2_)
            {
               _loc6_.removeAsset(_loc2_);
            }
            if(_loc4_)
            {
               _loc6_.removeAsset(_loc4_);
            }
            this.controlChar = _loc1_;
            this.controlBubble = _loc2_;
            this.controlBubble.key_locked = true;
         }
         ComicCharAsset(_loc1_).addEventListener("BodyLoaded",this.bodyLoaded_a);
         ComicCharAsset(_loc3_).addEventListener("BodyLoaded",this.bodyLoaded_b);
         var _loc7_:Object = this.message_controls.getButtonPackage();
         this.send_btn = _loc7_.send_btn;
         this.send_btn.addEventListener(MouseEvent.CLICK,this.send_click);
         this.cancel_btn = _loc7_.cancel_btn;
         this.cancel_btn.addEventListener(MouseEvent.CLICK,this.cancel_click);
         var _loc8_:Number = 153 - 120 + comicData.comicHeight;
         myOutline.graphics.clear();
         myOutline.graphics.lineStyle(2,0,1);
         myOutline.graphics.moveTo(0,0);
         myOutline.graphics.lineTo(comicData.comicWidth - 2,0);
         myOutline.graphics.lineTo(comicData.comicWidth - 2,_loc8_);
         myOutline.graphics.lineTo(0,_loc8_);
         myOutline.graphics.lineTo(0,0);
         this.myTitleBarMessage.x = 12;
         this.myTitleBarMessage.y = 126;
         myDisplay.y = 3;
         myOutline.x = 1;
         myOutline.y = 120;
         this.message_controls.y = this.myTitleBarMessage.y;
         this.message_controls.x = 278;
         myTabDisplay.focusTab("instance");
         char_controls.register((this.controlChar as ComicCharAsset).body);
         comicDisplay.y = 145;
         stage.focus = null;
         bs.spellcheck();
      }
      
      function drawInvite() : void
      {
         var _loc14_:TextField = null;
         stage.addEventListener(KeyboardEvent.KEY_UP,this.checkInvite);
         this.msg_content_invite = "Here\'s a portrait of you I designed on Bitstrips.com!\r\rWho knows, you might even start appearing in my comics...\r\rCome visit me on Bitstrips.com to see what happens next!";
         this.msg_content_char = "Check out this character I made on Bitstrips.com!";
         var _loc1_:Number = 750;
         var _loc2_:Number = 542;
         var _loc3_:Number = 588;
         var _loc4_:Number = 370;
         var _loc5_:Number = _loc1_ / 2 - _loc3_ / 2;
         var _loc6_:Number = _loc2_ / 2 - _loc4_ / 2;
         this.invite.graphics.clear();
         this.invite.graphics.beginFill(16777215,1);
         this.invite.graphics.drawRect(0,0,_loc1_,_loc2_);
         this.invite.graphics.beginFill(16777215,1);
         this.invite.graphics.drawRect(_loc5_,_loc6_,_loc3_,_loc4_);
         var _loc7_:TextFormat = new TextFormat();
         _loc7_.color = 0;
         _loc7_.font = BSConstants.VERDANA;
         _loc7_.size = 14;
         _loc7_.bold = false;
         var _loc8_:ComicAsset = cl.get_char_asset(this.messageData["receiver_char_id"],new Sprite());
         var _loc9_:TextField = new TextField();
         _loc9_.defaultTextFormat = _loc7_;
         _loc9_.autoSize = TextFieldAutoSize.LEFT;
         _loc9_.embedFonts = true;
         _loc9_.selectable = false;
         _loc9_.type = TextFieldType.DYNAMIC;
         _loc9_.text = "TO:";
         var _loc10_:TextField = new TextField();
         _loc10_.defaultTextFormat = _loc7_;
         _loc10_.autoSize = TextFieldAutoSize.LEFT;
         _loc10_.embedFonts = true;
         _loc10_.selectable = false;
         _loc10_.type = TextFieldType.DYNAMIC;
         _loc10_.text = "FROM:";
         var _loc11_:TextField = new TextField();
         _loc11_.defaultTextFormat = _loc7_;
         _loc11_.autoSize = TextFieldAutoSize.LEFT;
         _loc11_.embedFonts = true;
         _loc11_.selectable = false;
         _loc11_.type = TextFieldType.DYNAMIC;
         _loc11_.text = "SUBJECT:";
         var _loc12_:TextField = new TextField();
         _loc12_.defaultTextFormat = _loc7_;
         _loc12_.autoSize = TextFieldAutoSize.LEFT;
         _loc12_.embedFonts = true;
         _loc12_.selectable = false;
         _loc12_.type = TextFieldType.DYNAMIC;
         _loc12_.text = "MESSAGE:";
         _loc7_.size = 12;
         this.invite_to_field = new TextField();
         this.invite_to_field.defaultTextFormat = _loc7_;
         this.invite_to_field.autoSize = TextFieldAutoSize.NONE;
         this.invite_to_field.selectable = true;
         this.invite_to_field.type = TextFieldType.INPUT;
         this.invite_to_field.border = true;
         this.invite_to_field.text = "";
         this.invite_to_field.width = 200;
         this.invite_to_field.height = _loc9_.height;
         this.invite_to_field.addEventListener(Event.CHANGE,this.checkInvite);
         this.invite_from_field = new TextField();
         this.invite_from_field.defaultTextFormat = _loc7_;
         this.invite_from_field.autoSize = TextFieldAutoSize.NONE;
         this.invite_from_field.selectable = true;
         this.invite_from_field.type = TextFieldType.INPUT;
         this.invite_from_field.border = true;
         this.invite_from_field.text = this.messageData["sender_email"];
         this.invite_from_field.width = 200;
         this.invite_from_field.height = _loc10_.height;
         this.invite_from_field.addEventListener(Event.CHANGE,this.checkInvite);
         this.invite_subj_field = new TextField();
         this.invite_subj_field.defaultTextFormat = _loc7_;
         this.invite_subj_field.autoSize = TextFieldAutoSize.NONE;
         this.invite_subj_field.selectable = true;
         this.invite_subj_field.type = TextFieldType.INPUT;
         this.invite_subj_field.border = true;
         this.invite_subj_field.text = "Check out this Bitstrips character";
         this.invite_subj_field.width = 265;
         this.invite_subj_field.height = _loc11_.height;
         this.invite_msg_field = new TextField();
         this.invite_msg_field.defaultTextFormat = _loc7_;
         this.invite_msg_field.autoSize = TextFieldAutoSize.NONE;
         this.invite_msg_field.selectable = true;
         this.invite_msg_field.type = TextFieldType.INPUT;
         this.invite_msg_field.border = true;
         this.invite_msg_field.wordWrap = true;
         this.invite_msg_field.multiline = true;
         this.invite_msg_field.text = this.msg_content_invite;
         this.invite_msg_field.width = 265;
         this.invite_msg_field.height = 140;
         this.invite_cb = new CheckBox();
         this.invite_cb.label = "Send an Invitiation";
         this.invite_cb.width = 200;
         this.invite_cb.selected = this.messageData["send_friend"];
         this.invite_cb.addEventListener(Event.CHANGE,this.toggle_invite);
         this.invite_cb.buttonMode = true;
         if(this.messageData["send_friend"])
         {
            this.invite_cb.visible = false;
         }
         this.invite_send_btn = new Button();
         this.invite_send_btn.label = "Send";
         this.invite_send_btn.enabled = false;
         if(this.invite_cb.selected)
         {
            this.invite_send_btn.addEventListener(MouseEvent.CLICK,this.send_invite_click);
         }
         else
         {
            this.invite_send_btn.addEventListener(MouseEvent.CLICK,this.send_char_click);
         }
         this.invite_preview_btn = new Button();
         this.invite_preview_btn.label = "Preview";
         this.invite_preview_btn.enabled = false;
         this.invite_preview_btn.addEventListener(MouseEvent.CLICK,this.preview_invite);
         this.invite_cancel_btn = new Button();
         this.invite_cancel_btn.label = "Cancel";
         this.invite_cancel_btn.addEventListener(MouseEvent.CLICK,this.cancel_click);
         var _loc13_:Array = [_loc9_,_loc10_,_loc11_,_loc12_];
         var _loc15_:Number = 0;
         var _loc16_:uint = 0;
         while(_loc16_ < _loc13_.length)
         {
            if(_loc13_[_loc16_].width > _loc15_)
            {
               _loc15_ = _loc13_[_loc16_].width;
            }
            _loc16_++;
         }
         _loc9_.x = _loc5_ + 20 + _loc15_ - _loc9_.width;
         _loc10_.x = _loc5_ + 20 + _loc15_ - _loc10_.width;
         _loc11_.x = _loc5_ + 20 + _loc15_ - _loc11_.width;
         _loc12_.x = _loc5_ + 20 + _loc15_ - _loc12_.width;
         _loc9_.y = _loc6_ + 30;
         _loc10_.y = _loc9_.y + _loc9_.height + 10;
         _loc11_.y = _loc10_.y + _loc10_.height + 10;
         _loc12_.y = _loc11_.y + _loc11_.height + 10;
         this.invite_to_field.x = _loc5_ + 20 + _loc15_ + 20;
         this.invite_from_field.x = _loc5_ + 20 + _loc15_ + 20;
         this.invite_subj_field.x = _loc5_ + 20 + _loc15_ + 20;
         this.invite_msg_field.x = _loc5_ + 20 + _loc15_ + 20;
         this.invite_to_field.y = _loc9_.y;
         this.invite_from_field.y = _loc10_.y;
         this.invite_subj_field.y = _loc11_.y;
         this.invite_msg_field.y = _loc12_.y;
         this.invite_cb.x = _loc5_ + 20 + _loc15_ + 20;
         this.invite_cb.y = this.invite_msg_field.y + this.invite_msg_field.height + 10;
         this.invite_cancel_btn.width = this.invite_send_btn.width = this.invite_preview_btn.width = 80;
         this.invite_preview_btn.x = this.invite_cb.x;
         this.invite_preview_btn.y = this.invite_cb.y + 35;
         this.invite_send_btn.x = this.invite_preview_btn.x + this.invite_preview_btn.width + 10;
         this.invite_send_btn.y = this.invite_cb.y + 35;
         this.invite_cancel_btn.x = this.invite_send_btn.x + this.invite_send_btn.width + 10;
         this.invite_cancel_btn.y = this.invite_cb.y + 35;
         _loc8_.scaleX = _loc8_.scaleY = 2;
         _loc8_.x = _loc5_ + _loc3_ - 100;
         _loc8_.y = _loc6_ + _loc4_ - 30;
         this.invite.addChild(_loc9_);
         this.invite.addChild(_loc10_);
         this.invite.addChild(_loc11_);
         this.invite.addChild(_loc12_);
         this.invite.addChild(this.invite_to_field);
         this.invite.addChild(this.invite_from_field);
         this.invite.addChild(this.invite_subj_field);
         this.invite.addChild(this.invite_msg_field);
         this.invite.addChild(this.invite_cb);
         this.invite.addChild(this.invite_send_btn);
         this.invite.addChild(this.invite_preview_btn);
         this.invite.addChild(this.invite_cancel_btn);
         this.invite.addChild(_loc8_);
         this.toggle_invite(new Event("junk"));
      }
      
      override function loadComic_request(param1:String) : void
      {
         var _loc2_:Object = null;
         if(debug)
         {
            trace("--MessageBuilder.loadComic_request(" + param1 + ")--");
         }
         if(this.messageData["reply_id"] == "0")
         {
            _loc2_ = DataDump.get_MessageTemplate(this.messageData["sender_char_id"],this.messageData["receiver_char_id"]);
            loadComic_response(_loc2_);
         }
         else
         {
            remote.load_message_data(bs.user_id,this.messageData["reply_id"],this.translate_message);
         }
      }
      
      private function translate_message(param1:Object) : void
      {
         if(param1.hasOwnProperty("version") == false)
         {
            if(this.messageData["message_type"] == "a")
            {
               param1 = DataDump.get_MessageTemplate(this.messageData["sender_char_id"],this.messageData["receiver_char_id"]);
            }
            else
            {
               param1 = DataDump.get_MessageTemplate(this.messageData["receiver_char_id"],this.messageData["sender_char_id"]);
            }
         }
         loadComic_response(param1);
      }
      
      private function firstClick(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--MessageBuilder.firstClick()--");
         }
         stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.firstClick);
      }
      
      public function cancel_click(param1:MouseEvent) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("tb_close");
         }
         trace("Cancel clicked");
      }
      
      public function edit_avatar_click(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("http://www.bitstrips.com/create/avatar/"),"_self");
      }
      
      public function send_click(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(this.myTitleBarMessage.titleChanged())
         {
            this.sendComic_request();
         }
         else
         {
            doAlert("Your message doesn\'t have a subject. Click Cancel to go back and give it a subject.",[{
               "txt":"Send Anyway",
               "f":this.send_confirm
            },{
               "txt":"Cancel",
               "f":function(param1:Event):void
               {
                  if(debug)
                  {
                     trace("Cancel");
                  }
               }
            }]);
         }
      }
      
      public function send_confirm(param1:MouseEvent) : void
      {
         this.myTitleBarMessage.setTitle("");
         this.sendComic_request();
      }
      
      public function updateTitleBarMessage() : void
      {
         this.myTitleBarMessage.setData({"comicTitle":myComic.get_comicData().comicTitle});
         this.myTitleBarMessage.drawMe();
      }
      
      public function sendComic_request() : void
      {
         if(this.send_btn.enabled == false)
         {
            trace("Save already in progress...");
            return;
         }
         if(debug)
         {
            trace("--MessageBuilder.sendComic_request()--");
         }
         addBlocker();
         var _loc1_:Object = myComic.save_state();
         _loc1_["comicTitle"] = this.myTitleBarMessage.getFullTitle();
         _loc1_["comicAuthorName"] = myAuthor.getAuthorName();
         _loc1_["bkgrColor"] = bkgrColor;
         if(debug)
         {
            trace("so far so good");
         }
         var _loc2_:BitmapData = Utils.alpha_trim(myComic.getBitmapData(false));
         var _loc3_:ByteArray = PNGEncoder.encode(_loc2_);
         this.cancel_btn.enabled = false;
         remote.send_message(this.messageData["sender_id"],this.messageData["receiver_id"],this.myTitleBarMessage.getFullTitle(),_loc1_,_loc3_,this.messageData["thread_id"],this.sendComic_response);
      }
      
      public function sendComic_response(param1:*) : void
      {
         if(debug)
         {
            trace("--MessageBuilder.sendComic_response(" + param1 + ")--");
         }
         removeBlocker();
         if(ExternalInterface.available)
         {
            ExternalInterface.call("tb_close");
         }
      }
      
      private function generateDateStamp() : String
      {
         var _loc1_:Date = new Date();
         var _loc2_:* = "";
         var _loc3_:Array = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
         var _loc4_:Array = ["am","pm"];
         var _loc5_:Number = _loc1_.hours;
         var _loc6_:Number = Math.floor(_loc5_ / 12);
         _loc5_ = _loc5_ - 12 * _loc6_;
         if(_loc5_ == 0)
         {
            _loc5_ = 12;
         }
         var _loc7_:String = _loc5_.toString() + ":" + _loc1_.minutes.toString() + _loc4_[_loc6_];
         _loc2_ = _loc2_ + _loc3_[_loc1_.month];
         _loc2_ = _loc2_ + " ";
         _loc2_ = _loc2_ + _loc1_.date;
         _loc2_ = _loc2_ + ", ";
         _loc2_ = _loc2_ + _loc1_.fullYear;
         _loc2_ = _loc2_ + "  ";
         _loc2_ = _loc2_ + _loc7_;
         return _loc2_;
      }
      
      private function bodyLoaded_a(param1:Event) : void
      {
         if(debug)
         {
            trace("--MessageBuilder.bodyLoaded_a()--");
         }
         var _loc2_:ComicCharAsset = param1.currentTarget as ComicCharAsset;
         if(this.messageData["message_type"] == "a")
         {
            char_controls.register(_loc2_.body);
            _loc2_.body.head.set_lipsync(3);
         }
         else if(this.messageData["message_type"] == "b")
         {
            _loc2_.body.head.set_lipsync(1);
         }
         else if(this.messageData["message_type"] == "c")
         {
            char_controls.register(_loc2_.body);
            _loc2_.body.gesture = 8;
            _loc2_.body.head.set_expression(2);
            _loc2_.body.head.set_lipsync(3);
            _loc2_.body.head.update_pupils({
               "x":0,
               "y":0
            });
         }
         _loc2_.resized();
      }
      
      private function bodyLoaded_b(param1:Event) : void
      {
         if(debug)
         {
            trace("--MessageBuilder.bodyLoaded_b()--");
         }
         var _loc2_:ComicCharAsset = param1.currentTarget as ComicCharAsset;
         if(this.messageData["message_type"] == "a")
         {
            _loc2_.body.head.set_lipsync(1);
         }
         else if(this.messageData["message_type"] == "b")
         {
            char_controls.register(_loc2_.body);
            _loc2_.body.head.set_lipsync(3);
         }
         else if(this.messageData["message_type"] == "c")
         {
            _loc2_.body.head.set_lipsync(1);
            _loc2_.body.set_rotation(0);
            _loc2_.body.head.set_rotation(0);
            _loc2_.body.head.update_pupils({
               "x":0,
               "y":0
            });
            _loc2_.x = _loc2_.x - 55;
         }
         _loc2_.resized();
      }
      
      override public function setBackgroundColour(param1:Number) : void
      {
         if(debug)
         {
            trace("--MessageBuilder.setBackgroundColour(" + param1 + ")--");
         }
         bkgrColor = param1;
         myOutline.graphics.clear();
         myOutline.graphics.beginFill(param1,1);
         myOutline.graphics.lineStyle(2,0,1);
         myOutline.graphics.moveTo(0,0);
         myOutline.graphics.lineTo(comicData.comicWidth - 2,0);
         myOutline.graphics.lineTo(comicData.comicWidth - 2,145 - 120 + comicData.comicHeight);
         myOutline.graphics.lineTo(0,145 - 120 + comicData.comicHeight);
         myOutline.graphics.lineTo(0,0);
         var _loc2_:Object = ColorTools.RGBtoHSB(param1);
         if(debug)
         {
            trace("b: " + _loc2_.b);
         }
      }
      
      public function tweakEyesForHeight(param1:*) : void
      {
         var _loc4_:BubblePointer = null;
         var _loc5_:Object = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         trace("--MessageBuilder.tweakEyesForHeight()--");
         var _loc2_:ComicCharAsset = ComicCharAsset(myComic.getAssetByName("a_avatar"));
         var _loc3_:ComicCharAsset = ComicCharAsset(myComic.getAssetByName("b_avatar"));
         if(_loc2_ && _loc3_)
         {
            if(_loc2_.body && _loc3_.body)
            {
               _loc6_ = this.heightScore(_loc2_.body.body_height);
               _loc7_ = this.heightScore(_loc3_.body.body_height);
               trace("hA: " + _loc6_);
               trace("hB: " + _loc7_);
               _loc8_ = (_loc6_ - _loc7_) / 50;
               _loc9_ = (_loc7_ - _loc6_) / 50;
               _loc10_ = _loc2_.body.head.get_pupils();
               if(_loc10_[0]["width"] == null)
               {
                  _loc10_[0]["width"] = 0.25;
               }
               _loc2_.body.head.update_pupils({
                  "x":_loc10_[0].x,
                  "y":_loc8_,
                  "width":_loc10_[0]["width"]
               });
               _loc11_ = _loc3_.body.head.get_pupils();
               if(_loc11_[0]["width"] == null)
               {
                  _loc11_[0]["width"] = 0.25;
               }
               _loc3_.body.head.update_pupils({
                  "x":_loc11_[0].x,
                  "y":_loc9_,
                  "width":_loc11_[0]["width"]
               });
            }
         }
      }
      
      private function heightScore(param1:Number) : Number
      {
         switch(param1)
         {
            case 0:
               param1 = 3;
               break;
            case 1:
               param1 = 4;
               break;
            case 2:
               param1 = 5;
               break;
            case 3:
               param1 = 2;
               break;
            case 4:
               param1 = 1;
         }
         return param1;
      }
      
      private function panel_click(param1:MouseEvent) : void
      {
      }
      
      private function adjust_captions() : void
      {
         var _loc1_:ComicAsset = myComic.getAssetByName("a_caption");
         var _loc2_:ComicAsset = myComic.getAssetByName("b_caption");
         if(this.messageData["message_type"] == "c")
         {
            TextBubble(_loc1_).setContent(this.invite_from_field.text);
            TextBubble(_loc2_).setContent(this.invite_to_field.text);
         }
         var _loc3_:Number = _loc1_.getPanel().getSize().width / 2;
         _loc3_ = _loc2_.getPanel().getSize().width / 2;
      }
      
      private function send_invite_click(param1:MouseEvent) : void
      {
         var _loc6_:TextBubble = null;
         trace("--MessageBuilder.send_invite()--");
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.checkInvite);
         if(myDisplay.contains(this.invite))
         {
            this.adjust_captions();
            _loc6_ = TextBubble(myComic.getAssetByName("a_bubble"));
            _loc6_.setContent(this.invite_msg_field.text);
            _loc6_.y = 41 + _loc6_.getSize().height / 2;
            this.myTitleBarMessage.setTitle(this.invite_subj_field.text);
            this.myTitleBarMessage.adjustTitle();
         }
         addBlocker();
         var _loc2_:Bitmap = myComic.getBitmap();
         var _loc3_:ByteArray = new ByteArray();
         this.send_btn.enabled = false;
         this.cancel_btn.enabled = false;
         var _loc4_:TextBubble = TextBubble(myComic.getAssetByName("a_bubble"));
         var _loc5_:String = _loc4_.getContent();
         remote.send_char(this.messageData["sender_id"],this.invite_from_field.text,this.invite_to_field.text,this.myTitleBarMessage.getFullTitle(),_loc5_,this.messageData["receiver_char_id"],1,_loc3_,this.sendComic_response);
      }
      
      private function send_char_click(param1:MouseEvent) : void
      {
         trace("--MessageBuilder.send_char_click()--");
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.checkInvite);
         var _loc2_:TextBubble = TextBubble(myComic.getAssetByName("a_bubble"));
         var _loc3_:String = this.invite_msg_field.text;
         var _loc4_:ByteArray = new ByteArray();
         remote.send_char(this.messageData["sender_id"],this.invite_from_field.text,this.invite_to_field.text,this.invite_subj_field.text,_loc3_,this.messageData["receiver_char_id"],0,_loc4_,this.sendComic_response);
      }
      
      private function preview_invite(param1:MouseEvent) : void
      {
         trace("--MessageBuilder.preview_invite()--");
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.checkInvite);
         this.adjust_captions();
         var _loc2_:TextBubble = TextBubble(myComic.getAssetByName("a_bubble"));
         _loc2_.setContent(this.invite_msg_field.text);
         _loc2_.y = 41 + _loc2_.getSize().height / 2;
         this.myTitleBarMessage.setTitle(this.invite_subj_field.text);
         this.myTitleBarMessage.adjustTitle();
         myDisplay.removeChild(this.invite);
         myDisplay.addChildAt(comicDisplay,myDisplay.numChildren - 2);
         this.send_btn.removeEventListener(MouseEvent.CLICK,this.send_click);
         this.send_btn.addEventListener(MouseEvent.CLICK,this.send_invite_click);
      }
      
      private function checkInvite(param1:Event) : void
      {
         trace("--MessageBuilder.checkInvite()--");
         var _loc2_:Boolean = true;
         if(this.invite_to_field.text == "")
         {
            _loc2_ = false;
         }
         if(this.invite_from_field.text == "")
         {
            _loc2_ = false;
         }
         if(this.invite_subj_field.text == "")
         {
            _loc2_ = false;
         }
         if(this.invite_msg_field.text == "")
         {
            _loc2_ = false;
         }
         var _loc3_:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
         if(!_loc3_.test(this.invite_to_field.text))
         {
            _loc2_ = false;
         }
         if(!_loc3_.test(this.invite_from_field.text))
         {
            _loc2_ = false;
         }
         this.invite_send_btn.enabled = _loc2_;
         this.invite_preview_btn.enabled = _loc2_;
      }
      
      private function toggle_invite(param1:Event) : void
      {
         trace("--MessageBuilder.toggle_invite()--");
         this.invite_preview_btn.visible = this.invite_cb.selected;
         if(this.invite_cb.selected)
         {
            if(this.invite_msg_field.text == this.msg_content_char)
            {
               this.invite_msg_field.text = this.msg_content_invite;
            }
            this.invite_send_btn.addEventListener(MouseEvent.CLICK,this.send_invite_click);
         }
         else
         {
            if(this.invite_msg_field.text == this.msg_content_invite)
            {
               this.invite_msg_field.text = this.msg_content_char;
            }
            this.invite_send_btn.addEventListener(MouseEvent.CLICK,this.send_char_click);
         }
      }
   }
}
