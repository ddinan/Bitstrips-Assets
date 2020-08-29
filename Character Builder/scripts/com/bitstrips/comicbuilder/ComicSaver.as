package com.bitstrips.comicbuilder
{
   import com.adobe.images.PNGEnc;
   import com.adobe.images.PNGEncoder;
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import com.bitstrips.BitStrips;
   import com.bitstrips.ui.ProgressBlocker;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   
   public class ComicSaver
   {
       
      
      private var saveComic_response:Function;
      
      private var save_timer:Timer;
      
      private var myComic:Comic;
      
      private var _saving:Boolean = false;
      
      private var retry_count:int = 0;
      
      private var interval:int;
      
      private var _message:String = "";
      
      private var bs:BitStrips;
      
      private var debug:Boolean = false;
      
      private var total_count:int;
      
      private var thumb:Object;
      
      private var myAuthor:ComicAuthor;
      
      private var myTitleBar:TitleBar;
      
      private var onSaveError:Function;
      
      private var retry_timer:Timer;
      
      private var pb:ProgressBlocker;
      
      private var comic_id:int = 0;
      
      public function ComicSaver()
      {
         super();
         interval = 1;
         total_count = 5 * 60 / interval;
         save_timer = new Timer(interval * 1000,total_count);
         save_timer.addEventListener(TimerEvent.TIMER,save_timer_update);
         save_timer.addEventListener(TimerEvent.TIMER_COMPLETE,save_timer_complete);
      }
      
      public function generateFinalBA(param1:Bitmap, param2:Object, param3:Boolean, param4:Comic = null) : ByteArray
      {
         var _loc5_:ByteArray = null;
         var _loc6_:BitmapData = generateFinalBitmap(param1,param2,param3,param4);
         thumb["comic_width"] = _loc6_.width;
         thumb["comic_height"] = _loc6_.height;
         _loc5_ = PNGEncoder.encode(_loc6_);
         return _loc5_;
      }
      
      private function save_timer_update(param1:TimerEvent) : void
      {
         if(save_timer.currentCount > 20)
         {
            pb.message = _message + "\n" + save_timer.currentCount * interval + " " + _("of") + " " + total_count;
         }
      }
      
      private function message(param1:String) : void
      {
         _message = param1;
         pb.message = _message;
      }
      
      private function header() : Object
      {
         var _loc1_:Object = {
            "authorName":"BY " + myAuthor.getAuthorName(),
            "comicTitle":myTitleBar.getFullTitle()
         };
         if(BSConstants.EDU)
         {
            _loc1_["authorName"] = myTitleBar.authorField.text;
         }
         return _loc1_;
      }
      
      public function generateFinalBitmap(param1:Bitmap, param2:Object, param3:Boolean, param4:Comic = null) : BitmapData
      {
         var _loc8_:Number = NaN;
         var _loc20_:uint = 0;
         var _loc21_:Object = null;
         trace("Don\'t use me anymore!");
         if(!param4)
         {
            param4 = myComic;
         }
         var _loc5_:Sprite = new Sprite();
         var _loc6_:Number = 3;
         var _loc7_:Number = 8;
         if(param3)
         {
            _loc8_ = 16777215;
         }
         else
         {
            _loc8_ = 0;
         }
         if(debug)
         {
            trace("comicBMP.width: " + param1.width);
         }
         var _loc9_:TextFormat = new TextFormat();
         _loc9_.font = BSConstants.CREATIVEBLOCK;
         _loc9_.size = 16;
         _loc9_.color = _loc8_;
         _loc9_.bold = true;
         var _loc10_:TextFormat = new TextFormat();
         _loc10_.font = BSConstants.CREATIVEBLOCK;
         _loc10_.size = 12;
         _loc10_.color = _loc8_;
         _loc10_.bold = false;
         var _loc11_:TextField = new TextField();
         _loc11_.autoSize = TextFieldAutoSize.LEFT;
         _loc11_.wordWrap = false;
         _loc11_.defaultTextFormat = _loc9_;
         _loc11_.embedFonts = true;
         _loc11_.text = param2.comicTitle;
         var _loc12_:TextField = new TextField();
         _loc12_.autoSize = TextFieldAutoSize.LEFT;
         _loc12_.wordWrap = false;
         _loc12_.defaultTextFormat = _loc9_;
         _loc12_.embedFonts = true;
         if(param2.authorName)
         {
            _loc12_.text = param2.authorName;
         }
         var _loc13_:TextField = new TextField();
         _loc13_.autoSize = TextFieldAutoSize.LEFT;
         _loc13_.wordWrap = false;
         _loc13_.defaultTextFormat = _loc10_;
         _loc13_.embedFonts = true;
         _loc13_.text = BSConstants.URL;
         _loc5_.addChild(_loc12_);
         _loc5_.addChild(_loc11_);
         _loc5_.addChild(param1);
         _loc5_.addChild(_loc13_);
         var _loc14_:Number = Comic.BORDER_SIZE;
         _loc11_.x = _loc14_;
         _loc11_.y = _loc6_;
         _loc12_.x = param1.width - _loc12_.width - 7;
         var _loc15_:Number = Math.max(_loc12_.x,_loc11_.x + _loc11_.width + 50);
         if(_loc15_ > _loc12_.x)
         {
            _loc12_.x = _loc15_;
            _loc7_ = -8;
         }
         _loc12_.x = Math.max(_loc12_.x,_loc11_.x + _loc11_.width + 50);
         _loc12_.y = _loc6_;
         param1.x = _loc5_.width / 2 - param1.width / 2;
         param1.y = _loc12_.height;
         _loc13_.x = param1.x + param1.width - _loc13_.width - 7;
         _loc13_.y = param1.y + param1.height - 8;
         thumb = new Object();
         thumb.panels = new Array();
         var _loc16_:Number = 0;
         var _loc17_:uint = 0;
         while(_loc17_ < param4.get_stripList().length)
         {
            if(_loc17_ > 0)
            {
               _loc16_ = _loc16_ + (param4.get_stripList()[_loc17_ - 1].getSize().height + _loc14_);
            }
            _loc20_ = 0;
            while(_loc20_ < param4.get_stripList()[_loc17_].getPanelList().length)
            {
               if(debug)
               {
                  trace("PANEL<<<<<");
               }
               _loc21_ = new Object();
               _loc21_.width = param4.get_stripList()[_loc17_].getPanelList()[_loc20_].panel_width - 2;
               _loc21_.height = param4.get_stripList()[_loc17_].getPanelList()[_loc20_].panel_height - 2;
               _loc21_.x = Math.ceil(param1.x) + param4.get_stripList()[_loc17_].getPanelList()[_loc20_].x + 7;
               _loc21_.y = Math.ceil(param1.y) + 3 + _loc16_;
               thumb.panels.push(_loc21_);
               if(debug)
               {
                  trace("width: " + _loc21_.width);
               }
               if(debug)
               {
                  trace("height: " + _loc21_.height);
               }
               if(debug)
               {
                  trace("x: " + _loc21_.x);
               }
               if(debug)
               {
                  trace("y: " + _loc21_.y);
               }
               if(debug)
               {
                  trace(">>>>>>>>>");
               }
               _loc20_++;
            }
            _loc17_++;
         }
         var _loc18_:Object = thumb.panels[0];
         thumb.x = _loc18_.x;
         thumb.y = _loc18_.y;
         thumb.width = _loc18_.width;
         thumb.height = _loc18_.height;
         _loc11_.x = _loc11_.x - 4;
         _loc12_.x = _loc12_.x - 4;
         param1.x = param1.x - 4;
         _loc13_.x = _loc13_.x - 4;
         thumb.x = thumb.x - 4;
         var _loc19_:BitmapData = new BitmapData(_loc5_.width - _loc7_,_loc5_.height + _loc6_ * 2,false,myComic.bkgrColor);
         if(BSConstants.TRANSPARENT)
         {
            _loc19_ = new BitmapData(_loc5_.width - _loc7_,_loc5_.height + _loc6_ * 2,true,16777215);
         }
         _loc19_.draw(_loc5_);
         return _loc19_;
      }
      
      private function spriteBMP(param1:Sprite) : BitmapData
      {
         var _loc2_:Rectangle = param1.getBounds(param1);
         var _loc3_:Matrix = new Matrix();
         _loc3_.translate(-_loc2_.x,-_loc2_.y);
         var _loc4_:BitmapData = new BitmapData(_loc2_.width,_loc2_.height,false,0);
         _loc4_.draw(param1,_loc3_,null,null,null,true);
         return _loc4_;
      }
      
      private function retry_save(param1:Object = null) : void
      {
         retry_count = retry_count + 1;
         if(param1 != null && param1.hasOwnProperty("faultString"))
         {
            message(param1["faultString"] + _(" will try to re-save - ") + " " + _("attempt #") + retry_count);
         }
         else
         {
            pb.message = this._message + _(" will try to re-save - ") + " " + _("attempt #") + retry_count;
         }
         if(retry_count > 10)
         {
            onSaveError(_("Error - too many failed save attempts. Please try again"));
            return;
         }
         retry_timer = new Timer(5000,1);
         retry_timer.addEventListener(TimerEvent.TIMER_COMPLETE,do_retry);
         retry_timer.start();
      }
      
      private function save_data_error(param1:Object) : void
      {
         save_timer.stop();
         trace("Error saving comic data: " + param1);
         message(_("Error saving data"));
         retry_save();
      }
      
      private function save_data() : void
      {
         pb.show(_("Saving"));
         message(_("Saving Comic Data"));
         var _loc1_:Object = myComic.save_state();
         _loc1_["comicTitle"] = myTitleBar.getFullTitle();
         _loc1_["bkgrColor"] = myComic.bkgrColor;
         _loc1_["comicAuthorName"] = bs.user_name;
         _loc1_["version"] = 3;
         if(BSConstants.EDU && bs.assign_id)
         {
            _loc1_["assign_id"] = bs.assign_id;
         }
         message(_("Uploading Comic Data"));
         bs.remote.save_comic_data(bs.user_id,myTitleBar.getFullTitle(),_loc1_,bs.comic_id,myComic.series_id,save_data_response,save_data_error);
      }
      
      private function save_small_edu() : void
      {
         pb.show(_("Saving"));
         message(_("Generating Bitmap"));
         var _loc1_:Object = myComic.save_state();
         _loc1_["comicTitle"] = myTitleBar.getFullTitle();
         _loc1_["comicAuthorName"] = myAuthor.getAuthorName();
         _loc1_["bkgrColor"] = myComic.bkgrColor;
         var _loc2_:Object = {
            "authorName":"BY " + myAuthor.getAuthorName(),
            "comicTitle":myTitleBar.getFullTitle()
         };
         _loc2_["authorName"] = myTitleBar.authorField.text;
         _loc1_["comicAuthorName"] = bs.user_name;
         if(bs.assign_id)
         {
            _loc1_["assign_id"] = bs.assign_id;
         }
         var _loc3_:Bitmap = myComic.getBitmap();
         var _loc4_:ByteArray = PNGEncoder.encode(this.square_thumb(myComic.strips[0].panels[0],120));
         var _loc5_:ByteArray = PNGEncoder.encode(this.square_thumb(myComic.strips[0].panels[0],50));
         var _loc6_:ByteArray = generateFinalBA(_loc3_,_loc2_,myTitleBar.get_lightText());
         thumb["rgb"] = ("000000" + myComic.bkgrColor.toString(16)).substr(-6);
         message(_("Uploading Comic Data"));
         bs.remote.save_comic(bs.user_id,bs.assign_id,myTitleBar.getFullTitle(),_loc1_,thumb,_loc6_,_loc4_,_loc5_,bs.comic_id,saveComic_response,retry_save);
      }
      
      function square_thumb(param1:ComicPanel, param2:int) : BitmapData
      {
         var _loc3_:Number = (param2 + 6) / Math.min(param1.panel_width - 2,param1.panel_height - 2);
         var _loc4_:BitmapData = param1.panelBitmap(_loc3_,false);
         var _loc5_:BitmapData = new BitmapData(param2,param2,false);
         var _loc6_:Rectangle = new Rectangle(0,0,param2,param2);
         _loc6_.x = (_loc4_.width - param2) / 2;
         _loc6_.y = (_loc4_.height - param2) / 2;
         _loc5_.copyPixels(_loc4_,_loc6_,new Point(0,0));
         return _loc5_;
      }
      
      private function save_small(param1:int) : void
      {
         pb.show(_("Saving"));
         message(_("Generating Bitmap"));
         var _loc2_:Object = header();
         var _loc3_:Bitmap = myComic.getBitmap();
         var _loc4_:ByteArray = PNGEncoder.encode(this.square_thumb(myComic.strips[0].panels[0],120));
         var _loc5_:ByteArray = PNGEncoder.encode(this.square_thumb(myComic.strips[0].panels[0],50));
         var _loc6_:ByteArray = generateFinalBA(_loc3_,_loc2_,myTitleBar.get_lightText());
         thumb["rgb"] = ("000000" + myComic.bkgrColor.toString(16)).substr(-6);
         message(_("Uploading Comic Data"));
      }
      
      private function save_full_panels(param1:int) : void
      {
         var _loc7_:uint = 0;
         save_timer.reset();
         save_timer.start();
         if(debug)
         {
            trace("--ComicBuilder.saveComic_request()--");
         }
         message(_("Generating Bitmap"));
         var _loc2_:Object = header();
         var _loc3_:Array = this.BitmapBits(_loc2_,myTitleBar.get_lightText());
         thumb = new Object();
         thumb["rows"] = myComic.get_stripList().length;
         thumb["rgb"] = ("000000" + myComic.bkgrColor.toString(16)).substr(-6);
         message(_("Generating Bitmap Panels"));
         var _loc4_:Array = myComic.getBitmapPanels();
         var _loc5_:Array = new Array();
         var _loc6_:uint = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc4_[_loc6_].length)
            {
               _loc4_[_loc6_][_loc7_] = PNGEnc.encode(_loc4_[_loc6_][_loc7_]);
               _loc7_ = _loc7_ + 1;
            }
            _loc6_ = _loc6_ + 1;
         }
         message(_("Uploading Bitmap"));
         if(!BSConstants.EDU)
         {
            bs.remote.save_comic_panels_v2(bs.user_id,param1,thumb,_loc4_,_loc3_,saveComic_response,retry_save);
         }
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      private function do_retry(param1:TimerEvent) : void
      {
         if(BSConstants.EDU)
         {
            this.save_small_edu();
         }
         else if(comic_id)
         {
            save_data_response(comic_id);
         }
         else
         {
            save_data();
         }
      }
      
      public function BitmapBits(param1:Object, param2:Boolean, param3:Comic = null) : Array
      {
         var _loc4_:Sprite = new Sprite();
         var _loc5_:uint = 0;
         if(param2)
         {
            _loc5_ = 16777215;
         }
         var _loc6_:TextFormat = new TextFormat();
         _loc6_.font = BSConstants.CREATIVEBLOCK;
         _loc6_.size = 16;
         _loc6_.color = _loc5_;
         _loc6_.bold = true;
         var _loc7_:TextField = new TextField();
         _loc7_.autoSize = TextFieldAutoSize.LEFT;
         _loc7_.wordWrap = false;
         _loc7_.defaultTextFormat = _loc6_;
         _loc7_.embedFonts = true;
         _loc7_.text = param1.comicTitle;
         _loc7_.background = true;
         _loc7_.backgroundColor = myComic.bkgrColor;
         _loc4_.addChild(_loc7_);
         var _loc8_:BitmapData = spriteBMP(_loc4_);
         _loc7_.text = "";
         if(param1.authorName)
         {
            _loc7_.text = param1.authorName;
         }
         var _loc9_:BitmapData = spriteBMP(_loc4_);
         _loc6_.size = 12;
         _loc6_.bold = false;
         _loc7_.text = BSConstants.URL;
         _loc7_.setTextFormat(_loc6_);
         var _loc10_:BitmapData = spriteBMP(_loc4_);
         return [PNGEnc.encode(_loc8_),PNGEnc.encode(_loc9_),PNGEnc.encode(_loc10_)];
      }
      
      private function save_data_response(param1:int) : void
      {
         comic_id = param1;
         save_timer.stop();
         if(param1)
         {
            if(BSConstants.EDU)
            {
               save_small(comic_id);
            }
            else
            {
               save_full_panels(comic_id);
            }
         }
         else
         {
            message(_("Failed to get a id on save_data"));
            retry_save();
         }
      }
      
      private function save_timer_complete(param1:TimerEvent) : void
      {
         message(_("Timeout Error - will attempt to save again"));
         retry_save();
      }
      
      public function save(param1:BitStrips, param2:Comic, param3:ComicAuthor, param4:TitleBar, param5:ProgressBlocker, param6:Function, param7:Function) : Boolean
      {
         if(_saving == true)
         {
            return false;
         }
         _saving = true;
         this.bs = param1;
         this.myComic = param2;
         this.myAuthor = param3;
         this.myTitleBar = param4;
         this.pb = param5;
         this.saveComic_response = param6;
         this.onSaveError = param7;
         save_timer.reset();
         save_timer.start();
         if(BSConstants.EDU)
         {
            this.save_small_edu();
         }
         else
         {
            save_data();
         }
         return true;
      }
   }
}
