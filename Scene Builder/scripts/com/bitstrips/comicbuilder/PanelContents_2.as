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
       
      
      private var floor:Floor;
      
      private var myComic:Comic;
      
      private var selectedAsset:ComicAsset;
      
      private var myPanel:ComicPanel;
      
      private var panelData:Object;
      
      private var debug:Boolean = false;
      
      public var blank:Boolean = true;
      
      private var backdrop:BackDrop;
      
      private var editable:Boolean = true;
      
      private var depth_restore_index:int;
      
      private var text_content:Boolean;
      
      private var contentClip:Sprite;
      
      private var _children_filter:Boolean = true;
      
      public function PanelContents(param1:Comic, param2:ComicPanel, param3:Boolean = false)
      {
         super();
         myComic = param1;
         myPanel = param2;
         text_content = param3;
         panelData = new Object();
         floor = new Floor();
         floor.setPanel(this);
         floor.mouseEnabled = floor.mouseChildren = false;
         backdrop = new BackDrop();
         backdrop.setPanel(this);
         backdrop.mouseEnabled = backdrop.mouseChildren = false;
         if(!text_content)
         {
            addChild(floor);
            addChild(backdrop);
         }
         contentClip = new Sprite();
         addChild(contentClip);
         if(BSConstants.TESTING)
         {
            contentClip.graphics.lineStyle(1);
            contentClip.graphics.drawRect(-10,-10,20,20);
            contentClip.graphics.moveTo(-650,0);
            contentClip.graphics.lineTo(650,0);
         }
         this.cacheAsBitmap = true;
      }
      
      public function clickAssetTest(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         var _loc3_:ComicAsset = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         if(editable)
         {
            if(debug)
            {
               trace("--ComicPanel.clickAssetTest()--");
            }
            _loc2_ = new Point(stage.mouseX,stage.mouseY);
            _loc4_ = false;
            myComic.selectAsset(null);
            if(!_loc4_)
            {
               _loc5_ = contentClip.numChildren - 1;
               while(_loc5_ >= 0)
               {
                  _loc3_ = ComicAsset(contentClip.getChildAt(_loc5_));
                  if(_loc3_.doHitTest(_loc2_))
                  {
                     if(debug)
                     {
                        trace("hitTestPoint TRUE");
                     }
                     _loc3_.doSelect(true);
                     myComic.selectAsset(_loc3_);
                     _loc4_ = true;
                     selectedAsset = _loc3_;
                     myComic.pre_undo();
                     _loc3_.begin_drag();
                     break;
                  }
                  _loc5_--;
               }
            }
            if(debug)
            {
               trace("selecting panel");
            }
            if(_loc3_)
            {
               if(_loc3_.getLock())
               {
                  _loc4_ = false;
                  stage.addEventListener(MouseEvent.MOUSE_MOVE,deselectLockedAsset);
                  stage.addEventListener(MouseEvent.MOUSE_UP,deselectLockedAsset_remove);
               }
            }
            if(!_loc4_ && editable)
            {
               selectedAsset = null;
               myComic.pre_undo();
            }
            myComic.selectPanel(this.myPanel);
         }
      }
      
      public function update_filters() : void
      {
         var _loc2_:ComicAsset = null;
         var _loc3_:int = 0;
         var _loc1_:ColorMatrix = floor.get_matrix();
         if(_loc1_)
         {
            _loc3_ = 0;
            while(_loc3_ < contentClip.numChildren)
            {
               _loc2_ = contentClip.getChildAt(_loc3_) as ComicAsset;
               _loc2_.fc.set_panelMatrix(_loc1_);
               _loc3_++;
            }
         }
      }
      
      public function displayCharacter(param1:Body) : void
      {
         if(debug)
         {
            trace("--ComicPanel.displayCharacter()--");
         }
         contentClip.addChild(param1);
         param1.x = 100;
         param1.y = 100;
      }
      
      public function set ground_colour(param1:uint) : void
      {
         if(debug)
         {
            trace("--ComicPanel.setFloorColour(" + param1 + ")--");
         }
         param1 = Math.min(Math.max(param1,0),16777215);
         floor.setColor(param1);
         backdrop.ground_colour = param1;
         panelData["floor_color"] = param1;
      }
      
      private function deselectLockedAsset(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,deselectLockedAsset);
         stage.removeEventListener(MouseEvent.MOUSE_UP,deselectLockedAsset_remove);
         myComic.selectAsset(null);
      }
      
      public function reset_filters() : void
      {
         floor.reset_filters();
         set_filters(floor.get_filters());
      }
      
      private function asset_down(param1:MouseEvent) : void
      {
         var _loc2_:ComicAsset = param1.currentTarget as ComicAsset;
         myPanel.selected = true;
         myComic.selectAsset(_loc2_);
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
      
      public function get_filters() : Object
      {
         return panelData["filters"];
      }
      
      public function selectOnRelease(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--ComicPanel.selectOnRelease(" + param1.currentTarget + ")--");
         }
         stage.removeEventListener(MouseEvent.MOUSE_UP,selectOnRelease);
         if(editable)
         {
            myComic.selectAsset(selectedAsset);
         }
      }
      
      public function set panel_width(param1:Number) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.contentClip.numChildren)
         {
            _loc3_ = contentClip.getChildAt(_loc2_);
            if(_loc3_ is TextBubble)
            {
               TextBubble(_loc3_).max_width = param1;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
      
      public function redrawAllCeilings() : void
      {
         var _loc2_:ComicAsset = null;
         var _loc1_:int = contentClip.numChildren - 1;
         while(_loc1_ >= 0)
         {
            _loc2_ = ComicAsset(contentClip.getChildAt(_loc1_));
            if(_loc2_.getType() == "walls")
            {
               ComicPropAsset(_loc2_).drawCeiling();
            }
            _loc1_--;
         }
      }
      
      public function set_editable(param1:Boolean) : void
      {
         if(debug)
         {
            trace("--ComicPanel.set_editable(" + param1 + ")--");
         }
         editable = param1;
      }
      
      public function pop_back(param1:ComicAsset) : void
      {
         if(depth_restore_index > -1)
         {
            contentClip.addChildAt(param1,depth_restore_index);
            depth_restore_index = -1;
            param1.editing = false;
            param1.mouseChildren = false;
         }
      }
      
      public function set_filters(param1:Object) : void
      {
         var _loc2_:ColorMatrix = null;
         var _loc3_:ComicAsset = null;
         floor.set_filters(param1);
         backdrop.set_filters(param1);
         panelData["filters"] = floor.get_filters();
         if(_children_filter)
         {
            _loc2_ = floor.get_matrix();
         }
         var _loc4_:int = 0;
         while(_loc4_ < contentClip.numChildren)
         {
            _loc3_ = contentClip.getChildAt(_loc4_) as ComicAsset;
            _loc3_.set_panelMatrix(_loc2_);
            _loc4_++;
         }
      }
      
      public function clearPanel() : void
      {
         var _loc1_:ComicAsset = null;
         var _loc2_:int = contentClip.numChildren - 1;
         while(_loc2_ >= 0)
         {
            _loc1_ = contentClip.getChildAt(_loc2_) as ComicAsset;
            removeAsset(_loc1_);
            _loc2_--;
         }
         setFloor("");
         setBackdrop("");
      }
      
      public function getBackdropColour() : Number
      {
         if(panelData["backdrop_color"] == undefined)
         {
            return 16777215;
         }
         return panelData["backdrop_color"];
      }
      
      public function spelling(param1:Boolean) : void
      {
         var _loc3_:TextBubble = null;
         var _loc2_:uint = 0;
         while(_loc2_ < contentClip.numChildren)
         {
            _loc3_ = contentClip.getChildAt(_loc2_) as TextBubble;
            if(_loc3_)
            {
               _loc3_.spelling = param1;
               _loc3_.myField.setSelection(0,0);
            }
            _loc2_++;
         }
      }
      
      public function getFloorColour() : Number
      {
         return panelData["floor_color"];
      }
      
      public function get children_filter() : Boolean
      {
         return _children_filter;
      }
      
      public function get panel_width() : Number
      {
         return panelData.width;
      }
      
      public function removeAsset(param1:ComicAsset) : void
      {
         if(debug)
         {
            trace("--ComicPanel.removeAsset(" + param1.name + ")--");
         }
         param1.doSelect(false);
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      public function addAsset(param1:ComicAsset, param2:Boolean, param3:Boolean = false) : void
      {
         if(debug)
         {
            trace("--ComicPanel.addAsset(" + param1 + ")--");
         }
         if(param3 && contentClip.numChildren != 0)
         {
            contentClip.addChildAt(param1,contentClip.numChildren - 1);
         }
         else
         {
            contentClip.addChild(param1);
         }
         param1.addEventListener(MouseEvent.MOUSE_DOWN,asset_down,false,0,true);
         param1.addEventListener(CursorEvent.CURSOR_EVENT,dispatchEvent,false,0,true);
         selectedAsset = param1;
         if(_children_filter)
         {
            param1.fc.set_panelMatrix(this.get_matrix());
         }
         param1.resized();
         this.blank = false;
      }
      
      public function setFloor(param1:String, param2:int = -1) : void
      {
         if(text_content)
         {
            return;
         }
         if(!param1 || param1 == "")
         {
            param1 = "floor1";
         }
         if(debug)
         {
            trace("--ComicPanel.setFloor(" + param1 + ")--");
         }
         floor.setFloor(param1);
         if(param2 == -1)
         {
            backdrop.ground_colour = floor.getColor();
         }
         else
         {
            backdrop.ground_colour = param2;
         }
      }
      
      public function setBackdrop(param1:String) : void
      {
         if(text_content)
         {
            return;
         }
         if(!param1 || param1 == "")
         {
            param1 = "backdrop1";
         }
         if(debug)
         {
            trace("--ComicPanel.setBackdrop(" + param1 + ")--");
         }
         backdrop.setBackdrop(param1);
         this.ground_colour = backdrop.ground_colour;
      }
      
      private function get_matrix() : ColorMatrix
      {
         return floor.get_matrix();
      }
      
      public function set sky_colour(param1:uint) : void
      {
         param1 = Math.min(Math.max(param1,0),16777215);
         backdrop.sky_colour = param1;
         panelData["backdrop_color"] = param1;
      }
      
      public function getAssetByName(param1:String) : ComicAsset
      {
         var _loc3_:int = 0;
         if(debug)
         {
            trace("--ComicPanel.getAssetByName(" + param1 + ")--");
         }
         var _loc2_:ComicAsset = null;
         _loc3_ = contentClip.numChildren - 1;
         while(_loc3_ >= 0)
         {
            _loc2_ = ComicAsset(contentClip.getChildAt(_loc3_));
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
            _loc3_--;
         }
         return null;
      }
      
      public function save_state() : Object
      {
         if(debug)
         {
            trace("--ComicPanel.save_state()--");
         }
         var _loc1_:Object = panelData;
         _loc1_["children_filter"] = _children_filter;
         if(!text_content)
         {
            _loc1_["floor"] = floor.name;
            _loc1_["floor_color"] = backdrop.ground_colour;
            _loc1_["backdrop"] = backdrop.name;
            _loc1_["backdrop_color"] = backdrop.sky_colour;
         }
         _loc1_["contentList"] = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < contentClip.numChildren)
         {
            _loc1_["contentList"][_loc2_] = ComicAsset(contentClip.getChildAt(_loc2_)).save_state();
            _loc2_++;
         }
         if(debug)
         {
            trace("SAVING");
            trace("backdrop: " + _loc1_["backdrop"]);
            trace("ground: " + _loc1_["ground"]);
            trace("--------");
         }
         return _loc1_;
      }
      
      public function absorbScene(param1:Object) : void
      {
         if(debug)
         {
            trace("--ComicPanel.absorbScene()--");
         }
         load_state(DataDump.panelAbsorbScene(save_state(),param1));
      }
      
      public function pop_out(param1:ComicAsset) : ComicAsset
      {
         if(contentClip.contains(param1))
         {
            depth_restore_index = contentClip.getChildIndex(param1);
            return param1;
         }
         return null;
      }
      
      public function addText(param1:TextBubble, param2:Boolean) : void
      {
         if(debug)
         {
            trace("--ComicPanel.addText()--");
         }
         contentClip.addChild(param1);
         param1.setPanel(this.myPanel);
         selectedAsset = param1;
         if(_children_filter)
         {
            param1.fc.set_panelMatrix(this.get_matrix());
         }
         this.blank = false;
      }
      
      private function stopDragging(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--ComicPanel.stopDragging()--");
         }
      }
      
      public function set children_filter(param1:Boolean) : void
      {
         if(param1 != _children_filter)
         {
            _children_filter = param1;
            set_filters(get_filters());
         }
      }
      
      public function load_state(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(debug)
         {
            trace("--ComicPanel.load_state(" + param1 + ")--");
            trace("state[\'contentList\'].length: " + param1["contentList"].length);
            trace("backdrop: " + param1["backdrop"]);
         }
         clearPanel();
         panelData = Utils.clone(param1);
         if(panelData["filters"] == undefined && panelData["floor"] && !text_content)
         {
            floor.reset_filters();
            panelData["filters"] = floor.get_filters();
         }
         if(panelData["floor"])
         {
            setFloor(panelData["floor"]);
         }
         if(panelData["backdrop"])
         {
            setBackdrop(panelData["backdrop"]);
         }
         if(param1.hasOwnProperty("backdrop_color"))
         {
            this.sky_colour = param1["backdrop_color"];
         }
         if(param1.hasOwnProperty("floor_color"))
         {
            this.ground_colour = param1["floor_color"];
         }
         if(panelData["children_filter"] != undefined)
         {
            _children_filter = panelData["children_filter"];
         }
         if(panelData["contentList"])
         {
            _loc2_ = 0;
            while(_loc2_ < panelData["contentList"].length)
            {
               myComic.pasteAsset(panelData["contentList"][_loc2_],this.myPanel,false);
               _loc2_++;
            }
         }
         this.blank = false;
      }
      
      private function deselectLockedAsset_remove(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,deselectLockedAsset);
         stage.removeEventListener(MouseEvent.MOUSE_UP,deselectLockedAsset_remove);
      }
      
      public function drawMe() : void
      {
         redrawAllCeilings();
      }
   }
}
