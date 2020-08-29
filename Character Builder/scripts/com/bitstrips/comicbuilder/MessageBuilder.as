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
       
      
      var invite_msg_field:TextField;
      
      public var invite:Sprite;
      
      var invite_cancel_btn:Button;
      
      public var msg_content_invite:String;
      
      var cancel_btn:SimpleButton;
      
      var invite_subj_field:TextField;
      
      public var myTitleBarMessage:TitleBarMessage;
      
      var invite_send_btn:Button;
      
      var send_btn:SimpleButton;
      
      var invite_to_field:TextField;
      
      var invite_preview_btn:Button;
      
      var invite_from_field:TextField;
      
      public var controlBubble:TextBubble;
      
      public var messageData:Object;
      
      public var controlChar:ComicAsset;
      
      var invite_cb:CheckBox;
      
      public var msg_content_char:String;
      
      private var message_controls:MessageControls;
      
      public function MessageBuilder()
      {
         if(debug)
         {
            trace("--MessageBuilder()--");
         }
         super();
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
               _loc6_ = heightScore(_loc2_.body.body_height);
               _loc7_ = heightScore(_loc3_.body.body_height);
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
               if(messageData["message_type"] == "a")
               {
                  _loc4_ = TextBubble(myComic.getAssetByName("a_bubble")).getPointer();
                  _loc5_ = _loc4_.save_state();
                  _loc5_["controlY"] = _loc5_["controlY"] + (6 - _loc6_) * 15;
                  _loc4_.load_state(_loc5_);
                  _loc4_.drawMe();
               }
               else if(messageData["message_type"] == "b")
               {
                  _loc4_ = TextBubble(myComic.getAssetByName("b_bubble")).getPointer();
                  _loc5_ = _loc4_.save_state();
                  _loc5_["controlY"] = _loc5_["controlY"] + (6 - _loc7_) * 15;
                  _loc4_.load_state(_loc5_);
                  _loc4_.drawMe();
               }
               else if(messageData["message_type"] == "c")
               {
                  _loc4_ = TextBubble(myComic.getAssetByName("a_bubble")).getPointer();
                  _loc5_ = _loc4_.save_state();
                  _loc5_["controlY"] = _loc5_["controlY"] + (6 - _loc7_) * 15;
                  _loc4_.load_state(_loc5_);
                  _loc4_.drawMe();
               }
            }
         }
      }
      
      public function cancel_click(param1:MouseEvent) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("tb_close");
         }
         trace("Cancel clicked");
      }
      
      public function sendComic_request() : void
      {
         if(send_btn.enabled == false)
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
         _loc1_["comicTitle"] = myTitleBarMessage.getFullTitle();
         _loc1_["comicAuthorName"] = myAuthor.getAuthorName();
         _loc1_["bkgrColor"] = bkgrColor;
         if(debug)
         {
            trace("so far so good");
         }
         var _loc2_:BitmapData = Utils.alpha_trim(myComic.getBitmapData(false));
         var _loc3_:ByteArray = PNGEncoder.encode(_loc2_);
         cancel_btn.enabled = false;
         remote.send_message(messageData["sender_id"],messageData["receiver_id"],myTitleBarMessage.getFullTitle(),_loc1_,_loc3_,messageData["thread_id"],sendComic_response);
      }
      
      public function setMessageData() : void
      {
         var _loc2_:String = null;
         messageData = new Object();
         messageData = {"sender_id":bs.user_id};
         var _loc1_:Array = ["sender_char_id","receiver_id","receiver_char_id","message_type","reply_id","thread_id"];
         if(BSConstants.TESTING == false)
         {
            for each(_loc2_ in _loc1_)
            {
               if(loaderInfo.parameters.hasOwnProperty(_loc2_) == false)
               {
                  throw new Error("Missing paramater: " + _loc2_);
               }
               messageData[_loc2_] = loaderInfo.parameters[_loc2_];
            }
         }
         else
         {
            messageData = {
               "sender_id":31,
               "sender_char_id":345,
               "receiver_id":2,
               "receiver_char_id":1109,
               "message_type":"a",
               "reply_id":219214,
               "thread_id":60638
            };
         }
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
         setMessageData();
         common_init();
         myTabDisplay = init_tabs();
         myTitleBarMessage = new TitleBarMessage(this);
         invite = new Sprite();
         send_btn = new SimpleButton();
         cancel_btn = new SimpleButton();
         myComic.killBorders();
         myComic.set_editable(false);
         initLoadConditions = {
            "author":false,
            "comic":false,
            "CharLoader":false
         };
         addChild(myDisplay);
         myDisplay.addChild(myTitleBarMessage);
         myDisplay.addChild(myOutline);
         myDisplay.addChild(myTabDisplay);
         addChild(init_title_field());
         message_controls = new MessageControls();
         myDisplay.addChild(message_controls);
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
            "comic_id":messageData["reply_id"]
         });
      }
      
      public function send_click(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         if(myTitleBarMessage.titleChanged())
         {
            sendComic_request();
         }
         else
         {
            doAlert("Your message doesn\'t have a subject. Click Cancel to go back and give it a subject.",[{
               "txt":"Send Anyway",
               "f":send_confirm
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
      
      private function translate_message(param1:Object) : void
      {
         if(param1.hasOwnProperty("version") == false)
         {
            if(messageData["message_type"] == "a")
            {
               param1 = DataDump.get_MessageTemplate(messageData["sender_char_id"],messageData["receiver_char_id"]);
            }
            else
            {
               param1 = DataDump.get_MessageTemplate(messageData["receiver_char_id"],messageData["sender_char_id"]);
            }
         }
         loadComic_response(param1);
      }
      
      public function send_confirm(param1:MouseEvent) : void
      {
         myTitleBarMessage.setTitle("");
         sendComic_request();
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
      
      private function send_invite_click(param1:MouseEvent) : void
      {
         var _loc6_:TextBubble = null;
         trace("--MessageBuilder.send_invite()--");
         stage.removeEventListener(KeyboardEvent.KEY_UP,checkInvite);
         if(myDisplay.contains(invite))
         {
            adjust_captions();
            _loc6_ = TextBubble(myComic.getAssetByName("a_bubble"));
            _loc6_.setContent(invite_msg_field.text);
            _loc6_.y = 41 + _loc6_.getSize().height / 2;
            myTitleBarMessage.setTitle(invite_subj_field.text);
            myTitleBarMessage.adjustTitle();
         }
         addBlocker();
         var _loc2_:Bitmap = myComic.getBitmap();
         var _loc3_:ByteArray = new ByteArray();
         send_btn.enabled = false;
         cancel_btn.enabled = false;
         var _loc4_:TextBubble = TextBubble(myComic.getAssetByName("a_bubble"));
         var _loc5_:String = _loc4_.getContent();
         remote.send_char(messageData["sender_id"],invite_from_field.text,invite_to_field.text,myTitleBarMessage.getFullTitle(),_loc5_,messageData["receiver_char_id"],1,_loc3_,sendComic_response);
      }
      
      private function checkInvite(param1:Event) : void
      {
         trace("--MessageBuilder.checkInvite()--");
         var _loc2_:Boolean = true;
         if(invite_to_field.text == "")
         {
            _loc2_ = false;
         }
         if(invite_from_field.text == "")
         {
            _loc2_ = false;
         }
         if(invite_subj_field.text == "")
         {
            _loc2_ = false;
         }
         if(invite_msg_field.text == "")
         {
            _loc2_ = false;
         }
         var _loc3_:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
         if(!_loc3_.test(invite_to_field.text))
         {
            _loc2_ = false;
         }
         if(!_loc3_.test(invite_from_field.text))
         {
            _loc2_ = false;
         }
         invite_send_btn.enabled = _loc2_;
         invite_preview_btn.enabled = _loc2_;
      }
      
      public function edit_avatar_click(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("http://www.bitstrips.com/create/avatar/"),"_self");
      }
      
      private function firstClick(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--MessageBuilder.firstClick()--");
         }
         stage.removeEventListener(MouseEvent.MOUSE_DOWN,firstClick);
      }
      
      private function panel_click(param1:MouseEvent) : void
      {
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
      
      private function toggle_invite(param1:Event) : void
      {
         trace("--MessageBuilder.toggle_invite()--");
         invite_preview_btn.visible = invite_cb.selected;
         if(invite_cb.selected)
         {
            if(invite_msg_field.text == msg_content_char)
            {
               invite_msg_field.text = msg_content_invite;
            }
            invite_send_btn.addEventListener(MouseEvent.CLICK,send_invite_click);
         }
         else
         {
            if(invite_msg_field.text == msg_content_invite)
            {
               invite_msg_field.text = msg_content_char;
            }
            invite_send_btn.addEventListener(MouseEvent.CLICK,send_char_click);
         }
      }
      
      private function preview_invite(param1:MouseEvent) : void
      {
         trace("--MessageBuilder.preview_invite()--");
         stage.removeEventListener(KeyboardEvent.KEY_UP,checkInvite);
         adjust_captions();
         var _loc2_:TextBubble = TextBubble(myComic.getAssetByName("a_bubble"));
         _loc2_.setContent(invite_msg_field.text);
         _loc2_.y = 41 + _loc2_.getSize().height / 2;
         myTitleBarMessage.setTitle(invite_subj_field.text);
         myTitleBarMessage.adjustTitle();
         myDisplay.removeChild(invite);
         myDisplay.addChildAt(comicDisplay,myDisplay.numChildren - 2);
         send_btn.removeEventListener(MouseEvent.CLICK,send_click);
         send_btn.addEventListener(MouseEvent.CLICK,send_invite_click);
      }
      
      public function updateTitleBarMessage() : void
      {
         myTitleBarMessage.setData({"comicTitle":myComic.get_comicData().comicTitle});
         myTitleBarMessage.drawMe();
      }
      
      override function loadComic_request(param1:String) : void
      {
         var _loc2_:Object = null;
         if(debug)
         {
            trace("--MessageBuilder.loadComic_request(" + param1 + ")--");
         }
         if(messageData["reply_id"] == "0")
         {
            _loc2_ = DataDump.get_MessageTemplate(messageData["sender_char_id"],messageData["receiver_char_id"]);
            loadComic_response(_loc2_);
         }
         else
         {
            remote.load_message_data(bs.user_id,messageData["reply_id"],translate_message);
         }
      }
      
      private function bodyLoaded_a(param1:Event) : void
      {
         if(debug)
         {
            trace("--MessageBuilder.bodyLoaded_a()--");
         }
         var _loc2_:ComicCharAsset = param1.currentTarget as ComicCharAsset;
         if(messageData["message_type"] == "a")
         {
            char_controls.register(_loc2_.body);
            _loc2_.body.head.set_lipsync(3);
         }
         else if(messageData["message_type"] == "b")
         {
            _loc2_.body.head.set_lipsync(1);
         }
         else if(messageData["message_type"] == "c")
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
         if(messageData["message_type"] == "a")
         {
            _loc2_.body.head.set_lipsync(1);
         }
         else if(messageData["message_type"] == "b")
         {
            char_controls.register(_loc2_.body);
            _loc2_.body.head.set_lipsync(3);
         }
         else if(messageData["message_type"] == "c")
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
      
      function drawInvite() : void
      {
         var _loc14_:TextField = null;
         stage.addEventListener(KeyboardEvent.KEY_UP,checkInvite);
         msg_content_invite = "Here\'s a portrait of you I designed on Bitstrips.com!\r\rWho knows, you might even start appearing in my comics...\r\rCome visit me on Bitstrips.com to see what happens next!";
         msg_content_char = "Check out this character I made on Bitstrips.com!";
         var _loc1_:Number = 750;
         var _loc2_:Number = 542;
         var _loc3_:Number = 588;
         var _loc4_:Number = 370;
         var _loc5_:Number = _loc1_ / 2 - _loc3_ / 2;
         var _loc6_:Number = _loc2_ / 2 - _loc4_ / 2;
         invite.graphics.clear();
         invite.graphics.beginFill(16777215,1);
         invite.graphics.drawRect(0,0,_loc1_,_loc2_);
         invite.graphics.beginFill(16777215,1);
         invite.graphics.drawRect(_loc5_,_loc6_,_loc3_,_loc4_);
         var _loc7_:TextFormat = new TextFormat();
         _loc7_.color = 0;
         _loc7_.font = BSConstants.VERDANA;
         _loc7_.size = 14;
         _loc7_.bold = false;
         var _loc8_:ComicAsset = cl.get_char_asset(messageData["receiver_char_id"],new Sprite());
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
         invite_to_field = new TextField();
         invite_to_field.defaultTextFormat = _loc7_;
         invite_to_field.autoSize = TextFieldAutoSize.NONE;
         invite_to_field.selectable = true;
         invite_to_field.type = TextFieldType.INPUT;
         invite_to_field.border = true;
         invite_to_field.text = "";
         invite_to_field.width = 200;
         invite_to_field.height = _loc9_.height;
         invite_to_field.addEventListener(Event.CHANGE,checkInvite);
         invite_from_field = new TextField();
         invite_from_field.defaultTextFormat = _loc7_;
         invite_from_field.autoSize = TextFieldAutoSize.NONE;
         invite_from_field.selectable = true;
         invite_from_field.type = TextFieldType.INPUT;
         invite_from_field.border = true;
         invite_from_field.text = messageData["sender_email"];
         invite_from_field.width = 200;
         invite_from_field.height = _loc10_.height;
         invite_from_field.addEventListener(Event.CHANGE,checkInvite);
         invite_subj_field = new TextField();
         invite_subj_field.defaultTextFormat = _loc7_;
         invite_subj_field.autoSize = TextFieldAutoSize.NONE;
         invite_subj_field.selectable = true;
         invite_subj_field.type = TextFieldType.INPUT;
         invite_subj_field.border = true;
         invite_subj_field.text = "Check out this Bitstrips character";
         invite_subj_field.width = 265;
         invite_subj_field.height = _loc11_.height;
         invite_msg_field = new TextField();
         invite_msg_field.defaultTextFormat = _loc7_;
         invite_msg_field.autoSize = TextFieldAutoSize.NONE;
         invite_msg_field.selectable = true;
         invite_msg_field.type = TextFieldType.INPUT;
         invite_msg_field.border = true;
         invite_msg_field.wordWrap = true;
         invite_msg_field.multiline = true;
         invite_msg_field.text = msg_content_invite;
         invite_msg_field.width = 265;
         invite_msg_field.height = 140;
         invite_cb = new CheckBox();
         invite_cb.label = "Send an Invitiation";
         invite_cb.width = 200;
         invite_cb.selected = messageData["send_friend"];
         invite_cb.addEventListener(Event.CHANGE,toggle_invite);
         invite_cb.buttonMode = true;
         if(messageData["send_friend"])
         {
            invite_cb.visible = false;
         }
         invite_send_btn = new Button();
         invite_send_btn.label = "Send";
         invite_send_btn.enabled = false;
         if(invite_cb.selected)
         {
            invite_send_btn.addEventListener(MouseEvent.CLICK,send_invite_click);
         }
         else
         {
            invite_send_btn.addEventListener(MouseEvent.CLICK,send_char_click);
         }
         invite_preview_btn = new Button();
         invite_preview_btn.label = "Preview";
         invite_preview_btn.enabled = false;
         invite_preview_btn.addEventListener(MouseEvent.CLICK,preview_invite);
         invite_cancel_btn = new Button();
         invite_cancel_btn.label = "Cancel";
         invite_cancel_btn.addEventListener(MouseEvent.CLICK,cancel_click);
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
         invite_to_field.x = _loc5_ + 20 + _loc15_ + 20;
         invite_from_field.x = _loc5_ + 20 + _loc15_ + 20;
         invite_subj_field.x = _loc5_ + 20 + _loc15_ + 20;
         invite_msg_field.x = _loc5_ + 20 + _loc15_ + 20;
         invite_to_field.y = _loc9_.y;
         invite_from_field.y = _loc10_.y;
         invite_subj_field.y = _loc11_.y;
         invite_msg_field.y = _loc12_.y;
         invite_cb.x = _loc5_ + 20 + _loc15_ + 20;
         invite_cb.y = invite_msg_field.y + invite_msg_field.height + 10;
         invite_cancel_btn.width = invite_send_btn.width = invite_preview_btn.width = 80;
         invite_preview_btn.x = invite_cb.x;
         invite_preview_btn.y = invite_cb.y + 35;
         invite_send_btn.x = invite_preview_btn.x + invite_preview_btn.width + 10;
         invite_send_btn.y = invite_cb.y + 35;
         invite_cancel_btn.x = invite_send_btn.x + invite_send_btn.width + 10;
         invite_cancel_btn.y = invite_cb.y + 35;
         _loc8_.scaleX = _loc8_.scaleY = 2;
         _loc8_.x = _loc5_ + _loc3_ - 100;
         _loc8_.y = _loc6_ + _loc4_ - 30;
         invite.addChild(_loc9_);
         invite.addChild(_loc10_);
         invite.addChild(_loc11_);
         invite.addChild(_loc12_);
         invite.addChild(invite_to_field);
         invite.addChild(invite_from_field);
         invite.addChild(invite_subj_field);
         invite.addChild(invite_msg_field);
         invite.addChild(invite_cb);
         invite.addChild(invite_send_btn);
         invite.addChild(invite_preview_btn);
         invite.addChild(invite_cancel_btn);
         invite.addChild(_loc8_);
         toggle_invite(new Event("junk"));
      }
      
      override function cursor_event(param1:CursorEvent) : void
      {
      }
      
      private function send_char_click(param1:MouseEvent) : void
      {
         trace("--MessageBuilder.send_char_click()--");
         stage.removeEventListener(KeyboardEvent.KEY_UP,checkInvite);
         var _loc2_:TextBubble = TextBubble(myComic.getAssetByName("a_bubble"));
         var _loc3_:String = invite_msg_field.text;
         var _loc4_:ByteArray = new ByteArray();
         remote.send_char(messageData["sender_id"],invite_from_field.text,invite_to_field.text,invite_subj_field.text,_loc3_,messageData["receiver_char_id"],0,_loc4_,sendComic_response);
      }
      
      override public function drawMe() : void
      {
         var _loc1_:ComicAsset = null;
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
         updateTitleBarMessage();
         _loc1_ = myComic.getAssetByName("a_avatar");
         var _loc2_:TextBubble = myComic.getAssetByName("a_bubble") as TextBubble;
         _loc3_ = myComic.getAssetByName("b_avatar");
         var _loc4_:TextBubble = myComic.getAssetByName("b_bubble") as TextBubble;
         _loc1_.buttonMode = true;
         _loc3_.buttonMode = true;
         _loc1_.key_locked = _loc3_.key_locked = true;
         var _loc6_:ComicPanel = myComic.get_stripList()[0].getPanelList()[0];
         _loc6_.set_editable(false);
         _loc6_.killHilight();
         _loc6_.addEventListener(MouseEvent.CLICK,panel_click);
         myComic.selectAsset(null);
         if(messageData["message_type"] == "a")
         {
            myDisplay.addChildAt(comicDisplay,myDisplay.numChildren - 2);
            if(_loc2_)
            {
               _loc6_.removeAsset(_loc2_);
            }
            _loc9_ = DataDump.getMessageBubble_a();
            _loc2_ = myComic.addAssetToPanel(_loc9_,_loc6_,false) as TextBubble;
            controlChar = _loc1_;
            controlBubble = _loc2_;
            controlBubble.key_locked = true;
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
         else if(messageData["message_type"] == "b")
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
            controlChar = _loc3_;
            controlBubble = _loc4_;
            controlBubble.key_locked = true;
         }
         else if(messageData["message_type"] == "c")
         {
            myDisplay.addChild(invite);
            drawInvite();
            if(_loc2_)
            {
               _loc6_.removeAsset(_loc2_);
            }
            if(_loc4_)
            {
               _loc6_.removeAsset(_loc4_);
            }
            controlChar = _loc1_;
            controlBubble = _loc2_;
            controlBubble.key_locked = true;
         }
         ComicCharAsset(_loc1_).addEventListener("BodyLoaded",bodyLoaded_a);
         ComicCharAsset(_loc3_).addEventListener("BodyLoaded",bodyLoaded_b);
         var _loc7_:Object = message_controls.getButtonPackage();
         send_btn = _loc7_.send_btn;
         send_btn.addEventListener(MouseEvent.CLICK,send_click);
         cancel_btn = _loc7_.cancel_btn;
         cancel_btn.addEventListener(MouseEvent.CLICK,cancel_click);
         var _loc8_:Number = 153 - 120 + comicData.comicHeight;
         myOutline.graphics.clear();
         myOutline.graphics.lineStyle(2,0,1);
         myOutline.graphics.moveTo(0,0);
         myOutline.graphics.lineTo(comicData.comicWidth - 2,0);
         myOutline.graphics.lineTo(comicData.comicWidth - 2,_loc8_);
         myOutline.graphics.lineTo(0,_loc8_);
         myOutline.graphics.lineTo(0,0);
         myTitleBarMessage.x = 12;
         myTitleBarMessage.y = 126;
         myDisplay.y = 3;
         myOutline.x = 1;
         myOutline.y = 120;
         message_controls.y = myTitleBarMessage.y;
         message_controls.x = 278;
         myTabDisplay.focusTab("instance");
         char_controls.register((controlChar as ComicCharAsset).body);
         comicDisplay.y = 145;
         stage.focus = null;
         bs.spellcheck();
      }
      
      private function adjust_captions() : void
      {
         var _loc1_:ComicAsset = myComic.getAssetByName("a_caption");
         var _loc2_:ComicAsset = myComic.getAssetByName("b_caption");
         if(messageData["message_type"] == "c")
         {
            TextBubble(_loc1_).setContent(invite_from_field.text);
            TextBubble(_loc2_).setContent(invite_to_field.text);
         }
         var _loc3_:Number = _loc1_.getPanel().getSize().width / 2;
         _loc3_ = _loc2_.getPanel().getSize().width / 2;
      }
   }
}
