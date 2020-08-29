package com.bitstrips.comicbuilder
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ComicStrip extends Sprite
   {
      
      private static var debug:Boolean = false;
       
      
      private var panelList:Array;
      
      private var bordered:Boolean;
      
      private var myComic:Comic;
      
      private var borderOffset:Point;
      
      private var editable:Boolean = true;
      
      private var stripHeight:Number;
      
      private var border:Sprite;
      
      private var followingSprite:ComicStrip;
      
      public function ComicStrip(param1:Comic, param2:Number, param3:Boolean)
      {
         super();
         if(debug)
         {
            trace("--ComicStrip(" + stage + ")--");
         }
         myComic = param1;
         stripHeight = param2;
         bordered = param3;
         panelList = new Array();
         border = new Sprite();
         addChild(border);
      }
      
      public function borderMoveStart(param1:MouseEvent) : void
      {
         myComic.stop_editing_asset();
         borderOffset = new Point(border.mouseX,border.mouseY);
         if(myComic.getEditable())
         {
            if(debug)
            {
               trace("--ComicStrip.borderMoveStart()--");
            }
            stage.addEventListener(MouseEvent.MOUSE_UP,borderMoveStop);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,borderMove);
            followingSprite = myComic.stripFollower(this);
         }
      }
      
      public function get strip_height() : Number
      {
         return this.stripHeight;
      }
      
      public function border_over(param1:MouseEvent) : void
      {
         if(param1.buttonDown)
         {
            return;
         }
         param1.stopPropagation();
         dispatchEvent(new CursorEvent("border_v"));
      }
      
      public function getPanelList() : Array
      {
         return panelList;
      }
      
      function drawBorder(param1:Number, param2:Number) : void
      {
         border.graphics.clear();
         border.graphics.beginFill(16776960,0);
         border.graphics.drawRect(0,0,param1,param2);
         border.graphics.endFill();
      }
      
      public function adjustSize(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(param1.height != null)
         {
            stripHeight = stripHeight + param1.height;
            _loc2_ = 0;
            while(_loc2_ < panelList.length)
            {
               panelList[_loc2_].panel_height = stripHeight;
               _loc2_++;
            }
         }
         drawMe();
      }
      
      public function get blank() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < panelList.length)
         {
            if(panelList[_loc1_].blank == false)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function clearStrip() : void
      {
         if(debug)
         {
            trace("--ComicStrip.clearStrip()--");
         }
         var _loc1_:int = 0;
         while(_loc1_ < panelList.length)
         {
            panelList[_loc1_].clearPanel();
            removeChild(panelList[_loc1_]);
            _loc1_++;
         }
         panelList = new Array();
      }
      
      public function borderMove(param1:MouseEvent) : void
      {
         myComic.borderResizeStrip(this,followingSprite,this,borderOffset);
      }
      
      public function removePanel(param1:ComicPanel) : void
      {
         var _loc2_:int = panelList.indexOf(param1);
         panelList.splice(_loc2_,1);
         param1.clearPanel();
         param1.remove();
         removeChild(param1);
         drawMe();
      }
      
      public function set_editable(param1:Boolean) : void
      {
         editable = param1;
      }
      
      public function addPanel(param1:ComicPanel) : void
      {
         if(debug)
         {
            trace("--ComicStrip.addPanel()--");
         }
         panelList.push(param1);
         addChild(param1);
         drawMe();
      }
      
      public function save_state() : Object
      {
         if(debug)
         {
            trace("--ComicStrip.save_state()--");
         }
         var _loc1_:Object = new Object();
         _loc1_["height"] = stripHeight;
         _loc1_["panels"] = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < panelList.length)
         {
            _loc1_["panels"][_loc2_] = panelList[_loc2_].save_state();
            if(debug)
            {
               trace("state[\'panels\'][i][\'backdrop\']: " + _loc1_["panels"][_loc2_]["backdrop"]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function set strip_width(param1:int) : void
      {
         var _loc5_:ComicPanel = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc2_:int = strip_width;
         if(param1 > Comic.WIDTH_MAX)
         {
            trace("Error: Trying to set a width larger than max");
            param1 = Comic.WIDTH_MAX;
         }
         else if(param1 < panelList.length * (Comic.PANEL_WIDTH_MIN + Comic.BORDER_SIZE) + Comic.BORDER_SIZE)
         {
            trace("Error: Trying to get a width smaller than minimum");
            param1 = panelList.length * (Comic.PANEL_WIDTH_MIN + Comic.BORDER_SIZE) + Comic.BORDER_SIZE;
         }
         if(_loc2_ == param1)
         {
            return;
         }
         var _loc3_:int = (param1 - _loc2_) / panelList.length;
         var _loc4_:int = panelList.length - 1;
         while(_loc4_ >= 0)
         {
            _loc5_ = panelList[_loc4_];
            _loc6_ = _loc5_.panel_width;
            _loc5_.panel_width = _loc6_ + _loc3_;
            _loc4_--;
         }
         if(strip_width != param1)
         {
            _loc7_ = false;
            _loc4_ = panelList.length - 1;
            while(_loc4_ >= 0)
            {
               _loc3_ = param1 - strip_width;
               _loc5_ = panelList[_loc4_];
               _loc5_.panel_width = _loc5_.panel_width + _loc3_;
               if(strip_width == param1)
               {
                  _loc7_ = true;
                  break;
               }
               _loc4_--;
            }
            if(_loc7_ == false)
            {
               trace("ERROR: New width not equal -- " + param1 + " Actual width: " + strip_width);
               _loc4_ = panelList.length - 1;
               while(_loc4_ >= 0)
               {
                  trace("Panel: " + _loc4_ + " Width: " + panelList[_loc4_].panel_width);
                  _loc4_--;
               }
               throw new Error("set strip_width: width not equal to new width");
            }
         }
         this.drawMe();
      }
      
      public function get strip_width() : int
      {
         var _loc1_:Number = Comic.BORDER_SIZE;
         var _loc2_:int = 0;
         while(_loc2_ < panelList.length)
         {
            _loc1_ = _loc1_ + (panelList[_loc2_].panel_width + Comic.BORDER_SIZE);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get panels() : Array
      {
         return panelList;
      }
      
      public function resized(param1:Number = 0) : void
      {
      }
      
      public function getHeight() : Number
      {
         return stripHeight;
      }
      
      public function addPanelAt(param1:ComicPanel, param2:int) : void
      {
         if(debug)
         {
            trace("--ComicStrip.addPanelAt(" + param2 + ")--");
         }
         panelList.splice(param2,0,param1);
         addChild(param1);
         drawMe();
      }
      
      public function getSize() : Object
      {
         var _loc1_:Number = 0;
         var _loc2_:int = 0;
         while(_loc2_ < panelList.length)
         {
            _loc1_ = _loc1_ + (panelList[_loc2_].panel_width + Comic.BORDER_SIZE);
            _loc2_++;
         }
         _loc1_ = _loc1_ + Comic.BORDER_SIZE;
         if(debug)
         {
            trace("w: " + _loc1_);
         }
         var _loc3_:Object = {
            "width":_loc1_,
            "height":stripHeight
         };
         return _loc3_;
      }
      
      public function spelling(param1:Boolean) : void
      {
         var _loc3_:ComicPanel = null;
         var _loc2_:uint = 0;
         while(_loc2_ < panelList.length)
         {
            _loc3_ = panelList[_loc2_];
            _loc3_.spelling(param1);
            _loc2_++;
         }
      }
      
      public function border_out(param1:MouseEvent) : void
      {
         if(param1.buttonDown)
         {
            return;
         }
         dispatchEvent(new CursorEvent("strip"));
      }
      
      public function drawMe() : void
      {
         var _loc1_:Number = 0;
         panelList[0].x = _loc1_;
         panelList[0].y = 0;
         var _loc2_:int = 1;
         while(_loc2_ < panelList.length)
         {
            _loc1_ = panelList[_loc2_ - 1].x + panelList[_loc2_ - 1].panel_width + Comic.BORDER_SIZE;
            panelList[_loc2_].x = _loc1_;
            trace("Panel: " + _loc2_ + ", X: " + panelList[_loc2_].x);
            panelList[_loc2_].y = 0;
            _loc2_++;
         }
         drawBorder(this.strip_width,Comic.BORDER_SIZE);
         border.y = 0 - Comic.BORDER_SIZE;
         if(bordered)
         {
            border.addEventListener(MouseEvent.MOUSE_DOWN,borderMoveStart);
            border.addEventListener(MouseEvent.MOUSE_OVER,border_over);
            border.addEventListener(MouseEvent.MOUSE_OUT,border_out);
         }
      }
      
      public function borderMoveStop(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--ComicStrip.borderMoveStop()--");
         }
         stage.removeEventListener(MouseEvent.MOUSE_UP,borderMoveStop);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,borderMove);
         dispatchEvent(new CursorEvent("reset"));
      }
   }
}
