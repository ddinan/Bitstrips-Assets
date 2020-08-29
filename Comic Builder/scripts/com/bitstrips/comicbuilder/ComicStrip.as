package com.bitstrips.comicbuilder
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ComicStrip extends Sprite
   {
      
      private static var debug:Boolean = false;
       
      
      private var myComic:Comic;
      
      private var stripHeight:Number;
      
      private var panelList:Vector.<ComicPanel>;
      
      private var border:Sprite;
      
      private var followingSprite:ComicStrip;
      
      private var bordered:Boolean;
      
      private var borderOffset:Point;
      
      private var editable:Boolean = true;
      
      public function ComicStrip(param1:Comic, param2:Number, param3:Boolean)
      {
         super();
         if(debug)
         {
            trace("--ComicStrip(" + stage + ")--");
         }
         this.myComic = param1;
         this.stripHeight = param2;
         this.bordered = param3;
         this.panelList = new Vector.<ComicPanel>();
         this.border = new Sprite();
         addChild(this.border);
      }
      
      public function addPanel(param1:ComicPanel) : void
      {
         if(debug)
         {
            trace("--ComicStrip.addPanel()--");
         }
         this.panelList.push(param1);
         addChild(param1);
         this.drawMe();
      }
      
      public function addPanelAt(param1:ComicPanel, param2:int) : void
      {
         if(debug)
         {
            trace("--ComicStrip.addPanelAt(" + param2 + ")--");
         }
         this.panelList.splice(param2,0,param1);
         addChild(param1);
         this.drawMe();
      }
      
      public function spelling(param1:Boolean) : void
      {
         var _loc3_:ComicPanel = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.panelList.length)
         {
            _loc3_ = this.panelList[_loc2_];
            _loc3_.spelling(param1);
            _loc2_++;
         }
      }
      
      public function resized(param1:Number = 0) : void
      {
      }
      
      public function removePanel(param1:ComicPanel) : void
      {
         var _loc2_:int = this.panelList.indexOf(param1);
         this.panelList.splice(_loc2_,1);
         param1.clearPanel();
         param1.remove();
         removeChild(param1);
         this.drawMe();
      }
      
      public function drawMe() : void
      {
         var _loc1_:Number = 0;
         this.panelList[0].x = _loc1_;
         this.panelList[0].y = 0;
         var _loc2_:int = 1;
         while(_loc2_ < this.panelList.length)
         {
            _loc1_ = this.panelList[_loc2_ - 1].x + this.panelList[_loc2_ - 1].panel_width + Comic.BORDER_SIZE;
            this.panelList[_loc2_].x = _loc1_;
            trace("Panel: " + _loc2_ + ", X: " + this.panelList[_loc2_].x);
            this.panelList[_loc2_].y = 0;
            _loc2_++;
         }
         this.drawBorder(this.strip_width,Comic.BORDER_SIZE);
         this.border.y = 0 - Comic.BORDER_SIZE;
         if(this.bordered)
         {
            this.border.addEventListener(MouseEvent.MOUSE_DOWN,this.borderMoveStart);
            this.border.addEventListener(MouseEvent.MOUSE_OVER,this.border_over);
            this.border.addEventListener(MouseEvent.MOUSE_OUT,this.border_out);
         }
      }
      
      function drawBorder(param1:Number, param2:Number) : void
      {
         this.border.graphics.clear();
         this.border.graphics.beginFill(16776960,0);
         this.border.graphics.drawRect(0,0,param1,param2);
         this.border.graphics.endFill();
      }
      
      public function borderMoveStart(param1:MouseEvent) : void
      {
         this.myComic.stop_editing_asset();
         this.borderOffset = new Point(this.border.mouseX,this.border.mouseY);
         if(this.myComic.getEditable())
         {
            if(debug)
            {
               trace("--ComicStrip.borderMoveStart()--");
            }
            stage.addEventListener(MouseEvent.MOUSE_UP,this.borderMoveStop);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.borderMove);
            this.followingSprite = this.myComic.stripFollower(this);
         }
      }
      
      public function borderMoveStop(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--ComicStrip.borderMoveStop()--");
         }
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.borderMoveStop);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.borderMove);
         dispatchEvent(new CursorEvent("reset"));
      }
      
      public function borderMove(param1:MouseEvent) : void
      {
         this.myComic.borderResizeStrip(this,this.followingSprite,this,this.borderOffset);
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
      
      public function border_out(param1:MouseEvent) : void
      {
         if(param1.buttonDown)
         {
            return;
         }
         dispatchEvent(new CursorEvent("strip"));
      }
      
      public function getHeight() : Number
      {
         return this.stripHeight;
      }
      
      public function getPanelList() : Vector.<ComicPanel>
      {
         return this.panelList;
      }
      
      public function get panels() : Vector.<ComicPanel>
      {
         return this.panelList;
      }
      
      public function get strip_width() : int
      {
         var _loc1_:Number = Comic.BORDER_SIZE;
         var _loc2_:int = 0;
         while(_loc2_ < this.panelList.length)
         {
            _loc1_ = _loc1_ + (this.panelList[_loc2_].panel_width + Comic.BORDER_SIZE);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function set strip_width(param1:int) : void
      {
         var _loc5_:ComicPanel = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         var _loc2_:int = this.strip_width;
         if(param1 > Comic.WIDTH_MAX)
         {
            trace("Error: Trying to set a width larger than max");
            param1 = Comic.WIDTH_MAX;
         }
         else if(param1 < this.panelList.length * (Comic.PANEL_WIDTH_MIN + Comic.BORDER_SIZE) + Comic.BORDER_SIZE)
         {
            trace("Error: Trying to get a width smaller than minimum");
            param1 = this.panelList.length * (Comic.PANEL_WIDTH_MIN + Comic.BORDER_SIZE) + Comic.BORDER_SIZE;
         }
         if(_loc2_ == param1)
         {
            return;
         }
         var _loc3_:int = (param1 - _loc2_) / this.panelList.length;
         var _loc4_:int = this.panelList.length - 1;
         while(_loc4_ >= 0)
         {
            _loc5_ = this.panelList[_loc4_];
            _loc6_ = _loc5_.panel_width;
            _loc5_.panel_width = _loc6_ + _loc3_;
            _loc4_--;
         }
         if(this.strip_width != param1)
         {
            _loc7_ = false;
            _loc4_ = this.panelList.length - 1;
            while(_loc4_ >= 0)
            {
               _loc3_ = param1 - this.strip_width;
               _loc5_ = this.panelList[_loc4_];
               _loc5_.panel_width = _loc5_.panel_width + _loc3_;
               if(this.strip_width == param1)
               {
                  _loc7_ = true;
                  break;
               }
               _loc4_--;
            }
            if(_loc7_ == false)
            {
               trace("ERROR: New width not equal -- " + param1 + " Actual width: " + this.strip_width);
               _loc4_ = this.panelList.length - 1;
               while(_loc4_ >= 0)
               {
                  trace("Panel: " + _loc4_ + " Width: " + this.panelList[_loc4_].panel_width);
                  _loc4_--;
               }
               throw new Error("set strip_width: width not equal to new width");
            }
         }
         this.drawMe();
      }
      
      public function get strip_height() : Number
      {
         return this.stripHeight;
      }
      
      public function getSize() : Object
      {
         var _loc1_:Number = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.panelList.length)
         {
            _loc1_ = _loc1_ + (this.panelList[_loc2_].panel_width + Comic.BORDER_SIZE);
            _loc2_++;
         }
         _loc1_ = _loc1_ + Comic.BORDER_SIZE;
         if(debug)
         {
            trace("w: " + _loc1_);
         }
         var _loc3_:Object = {
            "width":_loc1_,
            "height":this.stripHeight
         };
         return _loc3_;
      }
      
      public function adjustSize(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(param1.height != null)
         {
            this.stripHeight = this.stripHeight + param1.height;
            _loc2_ = 0;
            while(_loc2_ < this.panelList.length)
            {
               this.panelList[_loc2_].panel_height = this.stripHeight;
               _loc2_++;
            }
         }
         this.drawMe();
      }
      
      public function save_state() : Object
      {
         if(debug)
         {
            trace("--ComicStrip.save_state()--");
         }
         var _loc1_:Object = new Object();
         _loc1_["height"] = this.stripHeight;
         _loc1_["panels"] = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.panelList.length)
         {
            _loc1_["panels"][_loc2_] = this.panelList[_loc2_].save_state();
            if(debug)
            {
               trace("state[\'panels\'][i][\'backdrop\']: " + _loc1_["panels"][_loc2_]["backdrop"]);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function clearStrip() : void
      {
         if(debug)
         {
            trace("--ComicStrip.clearStrip()--");
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.panelList.length)
         {
            this.panelList[_loc1_].clearPanel();
            removeChild(this.panelList[_loc1_]);
            _loc1_++;
         }
         this.panelList = new Vector.<ComicPanel>();
      }
      
      public function set_editable(param1:Boolean) : void
      {
         this.editable = param1;
      }
      
      public function get blank() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.panelList.length)
         {
            if(this.panelList[_loc1_].blank == false)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
   }
}
