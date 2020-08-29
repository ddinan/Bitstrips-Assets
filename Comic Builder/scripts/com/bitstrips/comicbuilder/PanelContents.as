package com.bitstrips.comicbuilder
{
   import com.bitstrips.BSConstants;
   import com.bitstrips.Utils;
   import com.bitstrips.character.Body;
   import com.bitstrips.character.ComicPropAsset;
   import com.quasimondo.geom.ColorMatrix;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class PanelContents extends Sprite
   {
       
      
      private var backdrop:BackDrop;
      
      private var floor:Floor;
      
      private var contentClip:Sprite;
      
      private var panelData:Object;
      
      private var selectedAsset:ComicAsset;
      
      private var editable:Boolean = true;
      
      public var blank:Boolean = true;
      
      private var myComic:Comic;
      
      private var myPanel:ComicPanel;
      
      private var debug:Boolean = false;
      
      private var depth_restore_index:int;
      
      private var text_content:Boolean;
      
      private var _children_filter:Boolean = true;
      
      public function PanelContents(param1:Comic, param2:ComicPanel, param3:Boolean = false)
      {
         super();
         this.myComic = param1;
         this.myPanel = param2;
         this.text_content = param3;
         this.panelData = new Object();
         this.floor = new Floor();
         this.floor.setPanel(this);
         this.floor.mouseEnabled = this.floor.mouseChildren = false;
         this.backdrop = new BackDrop();
         this.backdrop.setPanel(this);
         this.backdrop.mouseEnabled = this.backdrop.mouseChildren = false;
         if(!this.text_content)
         {
            addChild(this.floor);
            addChild(this.backdrop);
         }
         this.contentClip = new Sprite();
         addChild(this.contentClip);
         if(BSConstants.TESTING)
         {
            this.contentClip.graphics.lineStyle(1);
            this.contentClip.graphics.drawRect(-10,-10,20,20);
            this.contentClip.graphics.moveTo(-650,0);
            this.contentClip.graphics.lineTo(650,0);
         }
         this.cacheAsBitmap = true;
      }
      
      public function load_state(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(this.debug)
         {
            trace("--ComicPanel.load_state(" + param1 + ")--");
            trace("state[\'contentList\'].length: " + param1["contentList"].length);
            trace("backdrop: " + param1["backdrop"]);
         }
         this.clearPanel();
         this.panelData = Utils.clone(param1);
         if(this.panelData["filters"] == undefined && this.panelData["floor"] && !this.text_content)
         {
            this.floor.reset_filters();
            this.panelData["filters"] = this.floor.get_filters();
         }
         if(this.panelData["floor"])
         {
            this.setFloor(this.panelData["floor"]);
         }
         if(this.panelData["backdrop"])
         {
            this.setBackdrop(this.panelData["backdrop"]);
         }
         if(param1.hasOwnProperty("backdrop_color"))
         {
            this.sky_colour = param1["backdrop_color"];
         }
         if(param1.hasOwnProperty("floor_color"))
         {
            this.ground_colour = param1["floor_color"];
         }
         if(this.panelData["children_filter"] != undefined)
         {
            this._children_filter = this.panelData["children_filter"];
         }
         if(this.panelData["contentList"])
         {
            _loc2_ = 0;
            while(_loc2_ < this.panelData["contentList"].length)
            {
               this.myComic.pasteAsset(this.panelData["contentList"][_loc2_],this.myPanel,false);
               _loc2_++;
            }
         }
         this.blank = false;
      }
      
      public function drawMe() : void
      {
         this.redrawAllCeilings();
      }
      
      public function clickAssetTest(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         var _loc3_:ComicAsset = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         if(this.editable)
         {
            if(this.debug)
            {
               trace("--ComicPanel.clickAssetTest()--");
            }
            _loc2_ = new Point(stage.mouseX,stage.mouseY);
            _loc4_ = false;
            this.myComic.selectAsset(null);
            if(!_loc4_)
            {
               _loc5_ = this.contentClip.numChildren - 1;
               while(_loc5_ >= 0)
               {
                  _loc3_ = ComicAsset(this.contentClip.getChildAt(_loc5_));
                  if(_loc3_.doHitTest(_loc2_))
                  {
                     if(this.debug)
                     {
                        trace("hitTestPoint TRUE");
                     }
                     _loc3_.doSelect(true);
                     this.myComic.selectAsset(_loc3_);
                     _loc4_ = true;
                     this.selectedAsset = _loc3_;
                     this.myComic.pre_undo();
                     _loc3_.begin_drag();
                     break;
                  }
                  _loc5_--;
               }
            }
            if(this.debug)
            {
               trace("selecting panel");
            }
            if(_loc3_)
            {
               if(_loc3_.getLock())
               {
                  _loc4_ = false;
                  stage.addEventListener(MouseEvent.MOUSE_MOVE,this.deselectLockedAsset,false,0,true);
                  stage.addEventListener(MouseEvent.MOUSE_UP,this.deselectLockedAsset_remove,false,0,true);
               }
            }
            if(!_loc4_ && this.editable)
            {
               this.selectedAsset = null;
               this.myComic.pre_undo();
            }
            this.myComic.selectPanel(this.myPanel);
         }
      }
      
      private function deselectLockedAsset(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.deselectLockedAsset);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.deselectLockedAsset_remove);
         this.myComic.selectAsset(null);
      }
      
      private function deselectLockedAsset_remove(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.deselectLockedAsset);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.deselectLockedAsset_remove);
      }
      
      private function stopDragging(param1:MouseEvent) : void
      {
         if(this.debug)
         {
            trace("--ComicPanel.stopDragging()--");
         }
      }
      
      public function displayCharacter(param1:Body) : void
      {
         if(this.debug)
         {
            trace("--ComicPanel.displayCharacter()--");
         }
         this.contentClip.addChild(param1);
         param1.x = 100;
         param1.y = 100;
      }
      
      public function selectOnRelease(param1:MouseEvent) : void
      {
         if(this.debug)
         {
            trace("--ComicPanel.selectOnRelease(" + param1.currentTarget + ")--");
         }
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.selectOnRelease);
         if(this.editable)
         {
            this.myComic.selectAsset(this.selectedAsset);
         }
      }
      
      public function addAsset(param1:ComicAsset, param2:Boolean, param3:Boolean = false) : void
      {
         if(this.debug)
         {
            trace("--ComicPanel.addAsset(" + param1 + ")--");
         }
         if(param3 && this.contentClip.numChildren != 0)
         {
            this.contentClip.addChildAt(param1,this.contentClip.numChildren - 1);
         }
         else
         {
            this.contentClip.addChild(param1);
         }
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.asset_down,false,0,true);
         param1.addEventListener(CursorEvent.CURSOR_EVENT,dispatchEvent,false,0,true);
         this.selectedAsset = param1;
         param1.resized();
         this.blank = false;
      }
      
      private function asset_down(param1:MouseEvent) : void
      {
         var _loc2_:ComicAsset = param1.currentTarget as ComicAsset;
         this.myPanel.selected = true;
         this.myComic.selectAsset(_loc2_);
         if(_loc2_.locked == false)
         {
            if(!_loc2_.editing)
            {
               this.myComic.pre_undo();
               _loc2_.begin_drag();
               param1.stopPropagation();
            }
         }
      }
      
      public function addText(param1:TextBubble, param2:Boolean) : void
      {
         if(this.debug)
         {
            trace("--ComicPanel.addText()--");
         }
         this.contentClip.addChild(param1);
         param1.setPanel(this.myPanel);
         this.selectedAsset = param1;
         this.blank = false;
      }
      
      public function spelling(param1:Boolean) : void
      {
         var _loc3_:TextBubble = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.contentClip.numChildren)
         {
            _loc3_ = this.contentClip.getChildAt(_loc2_) as TextBubble;
            if(_loc3_)
            {
               _loc3_.spelling = param1;
               _loc3_.myField.setSelection(0,0);
            }
            _loc2_++;
         }
      }
      
      public function removeAsset(param1:ComicAsset) : void
      {
         if(this.debug)
         {
            trace("--ComicPanel.removeAsset(" + param1.name + ")--");
         }
         param1.doSelect(false);
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
         param1.remove();
         param1 = null;
      }
      
      public function save_state() : Object
      {
         if(this.debug)
         {
            trace("--ComicPanel.save_state()--");
         }
         var _loc1_:Object = Utils.clone(this.panelData);
         _loc1_["children_filter"] = this._children_filter;
         if(!this.text_content)
         {
            _loc1_["floor"] = this.floor.name;
            _loc1_["floor_color"] = this.backdrop.ground_colour;
            _loc1_["backdrop"] = this.backdrop.name;
            _loc1_["backdrop_color"] = this.backdrop.sky_colour;
         }
         _loc1_["contentList"] = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this.contentClip.numChildren)
         {
            _loc1_["contentList"][_loc2_] = ComicAsset(this.contentClip.getChildAt(_loc2_)).save_state();
            _loc2_++;
         }
         if(this.debug)
         {
            trace("SAVING");
            trace("backdrop: " + _loc1_["backdrop"]);
            trace("ground: " + _loc1_["ground"]);
            trace("--------");
         }
         return _loc1_;
      }
      
      public function get panel_width() : Number
      {
         return this.panelData.width;
      }
      
      public function set panel_width(param1:Number) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.contentClip.numChildren)
         {
            _loc3_ = this.contentClip.getChildAt(_loc2_);
            if(_loc3_ is TextBubble)
            {
               TextBubble(_loc3_).max_width = param1 / TextBubble(_loc3_).scale;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
      
      public function clearPanel() : void
      {
         var _loc1_:ComicAsset = null;
         var _loc2_:int = this.contentClip.numChildren - 1;
         while(_loc2_ >= 0)
         {
            _loc1_ = this.contentClip.getChildAt(_loc2_) as ComicAsset;
            this.removeAsset(_loc1_);
            _loc2_--;
         }
         this.setFloor("");
         this.setBackdrop("");
      }
      
      public function set_editable(param1:Boolean) : void
      {
         if(this.debug)
         {
            trace("--ComicPanel.set_editable(" + param1 + ")--");
         }
         this.editable = param1;
      }
      
      public function getAssetByName(param1:String) : ComicAsset
      {
         var _loc3_:int = 0;
         if(this.debug)
         {
            trace("--ComicPanel.getAssetByName(" + param1 + ")--");
         }
         var _loc2_:ComicAsset = null;
         _loc3_ = this.contentClip.numChildren - 1;
         while(_loc3_ >= 0)
         {
            _loc2_ = ComicAsset(this.contentClip.getChildAt(_loc3_));
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
            _loc3_--;
         }
         return null;
      }
      
      public function absorbScene(param1:Object) : void
      {
         if(this.debug)
         {
            trace("--ComicPanel.absorbScene()--");
         }
         this.load_state(DataDump.panelAbsorbScene(this.save_state(),param1));
      }
      
      public function redrawAllCeilings() : void
      {
         var _loc2_:ComicAsset = null;
         var _loc1_:int = this.contentClip.numChildren - 1;
         while(_loc1_ >= 0)
         {
            _loc2_ = ComicAsset(this.contentClip.getChildAt(_loc1_));
            if(_loc2_.getType() == "walls")
            {
               ComicPropAsset(_loc2_).drawCeiling();
            }
            _loc1_--;
         }
      }
      
      public function setBackdrop(param1:String) : void
      {
         if(this.text_content)
         {
            return;
         }
         if(!param1 || param1 == "")
         {
            param1 = "backdrop1";
         }
         if(this.debug)
         {
            trace("--ComicPanel.setBackdrop(" + param1 + ")--");
         }
         this.backdrop.setBackdrop(param1);
         this.ground_colour = this.backdrop.ground_colour;
      }
      
      public function setFloor(param1:String, param2:int = -1) : void
      {
         if(this.text_content)
         {
            return;
         }
         if(!param1 || param1 == "")
         {
            param1 = "floor1";
         }
         if(this.debug)
         {
            trace("--ComicPanel.setFloor(" + param1 + ")--");
         }
         this.floor.setFloor(param1);
         if(param2 == -1)
         {
            this.backdrop.ground_colour = this.floor.getColor();
         }
         else
         {
            this.backdrop.ground_colour = param2;
         }
      }
      
      public function set sky_colour(param1:uint) : void
      {
         param1 = Math.min(Math.max(param1,0),16777215);
         this.backdrop.sky_colour = param1;
         this.panelData["backdrop_color"] = param1;
      }
      
      public function set ground_colour(param1:uint) : void
      {
         if(this.debug)
         {
            trace("--ComicPanel.setFloorColour(" + param1 + ")--");
         }
         param1 = Math.min(Math.max(param1,0),16777215);
         this.floor.setColor(param1);
         this.backdrop.ground_colour = param1;
         this.panelData["floor_color"] = param1;
      }
      
      public function getBackdropColour() : Number
      {
         if(this.panelData["backdrop_color"] == undefined)
         {
            return 16777215;
         }
         return this.panelData["backdrop_color"];
      }
      
      public function getFloorColour() : Number
      {
         return this.panelData["floor_color"];
      }
      
      public function get_filters() : Object
      {
         return this.panelData["filters"];
      }
      
      public function update_filters() : void
      {
      }
      
      public function reset_filters() : void
      {
         this.floor.reset_filters();
         this.set_filters(this.floor.get_filters());
      }
      
      public function set_filters(param1:Object) : void
      {
         var _loc2_:ColorMatrix = null;
         var _loc3_:ComicAsset = null;
      }
      
      private function get_matrix() : ColorMatrix
      {
         return this.floor.get_matrix();
      }
      
      public function set children_filter(param1:Boolean) : void
      {
         if(param1 != this._children_filter)
         {
            this._children_filter = param1;
            this.set_filters(this.get_filters());
         }
      }
      
      public function get children_filter() : Boolean
      {
         return this._children_filter;
      }
      
      public function pop_out(param1:ComicAsset) : ComicAsset
      {
         if(this.contentClip.contains(param1))
         {
            this.depth_restore_index = this.contentClip.getChildIndex(param1);
            return param1;
         }
         return null;
      }
      
      public function pop_back(param1:ComicAsset) : void
      {
         if(this.depth_restore_index > -1)
         {
            this.contentClip.addChildAt(param1,this.depth_restore_index);
            this.depth_restore_index = -1;
            param1.editing = false;
            param1.mouseChildren = false;
         }
      }
   }
}
