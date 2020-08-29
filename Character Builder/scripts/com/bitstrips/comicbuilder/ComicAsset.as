package com.bitstrips.comicbuilder
{
   import com.bitstrips.Utils;
   import com.bitstrips.controls.ComicControl;
   import com.bitstrips.core.PropShape;
   import com.quasimondo.geom.ColorMatrix;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   import ws.tink.display.HitTest;
   
   public class ComicAsset extends Sprite
   {
       
      
      protected var container:Sprite;
      
      var originPoint:Point;
      
      protected var hilightable:Boolean;
      
      protected var controller;
      
      public var asset_type:String = "";
      
      protected var myPanel:ComicPanel;
      
      protected var assetData:Object;
      
      protected var turn_factor:int;
      
      public var debug:Boolean = false;
      
      protected var _editing:Boolean = false;
      
      public var key_locked:Boolean = false;
      
      protected var containerClip:DisplayObjectContainer;
      
      protected var _editing_override:Boolean = false;
      
      protected var originalWidth:Number;
      
      private var _rotate_offset:Number;
      
      protected var _selected:Boolean = false;
      
      public var artwork:Sprite;
      
      public function ComicAsset()
      {
         super();
         if(debug)
         {
            trace("--ComicAsset()--");
         }
         mouseChildren = false;
         doubleClickEnabled = true;
         container = new Sprite();
         artwork = new Sprite();
         addChild(container);
         container.addChild(artwork);
         selected = false;
         hilightable = true;
         var _loc1_:Array = new Array();
         container.filters = _loc1_;
         artwork.tabChildren = artwork.tabEnabled = false;
         this.cacheAsBitmap = true;
      }
      
      public function remove() : void
      {
         Utils.remove_children(this);
         Utils.remove_children(container);
         Utils.remove_children(artwork);
         container = null;
         artwork = null;
         assetData = null;
         this.removeEventListener(MouseEvent.DOUBLE_CLICK,doubleClick);
         this.removeEventListener(MouseEvent.MOUSE_OVER,mouse_over);
         this.removeEventListener(MouseEvent.MOUSE_OUT,mouse_out);
      }
      
      public function loaded() : void
      {
         this.addEventListener(MouseEvent.DOUBLE_CLICK,doubleClick,false,0,true);
         addEventListener(MouseEvent.MOUSE_OVER,mouse_over,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,mouse_out,false,0,true);
      }
      
      public function load_state(param1:Object) : void
      {
         if(debug)
         {
            trace("--ComicAsset.load_state()--");
         }
         assetData = Utils.clone(param1);
         this.name = assetData.name;
         this.asset_type = assetData["type"];
         if(debug)
         {
            trace("sceneBit: " + assetData["sceneBit"]);
         }
         if(assetData["locked"] == undefined)
         {
            if(debug)
            {
               trace("ASSIGNING DEFAULT LOCKED TO FALSE");
            }
            assetData["locked"] = false;
         }
         setLock(assetData["locked"]);
         if(!assetData["dragOffset"])
         {
            if(debug)
            {
               trace("I HAVE NO DRAG OFFSET!");
            }
            assetData["dragOffset"] = {
               "x":0,
               "y":0
            };
         }
         else if(debug)
         {
            trace("dragOffset.x: " + assetData["dragOffset"].x + " dragOffset.y: " + assetData["dragOffset"].y);
         }
         if(!assetData["scale"])
         {
            assetData["scale"] = 1;
         }
         if(!assetData["turn"])
         {
            assetData["turn"] = 0;
         }
         if(!assetData["position"])
         {
            assetData["position"] = {
               "x":0,
               "y":0
            };
         }
         originPoint = new Point(0,0);
         if(debug)
         {
            trace("Position: " + assetData["position"]["x"] + ", " + assetData["position"]["y"]);
         }
         this.x = assetData["position"]["x"];
         this.y = assetData["position"]["y"];
         turn = assetData.turn;
         scale = assetData["scale"];
         if(assetData["blendMode"])
         {
            artwork.blendMode = assetData["blendMode"];
         }
      }
      
      public function set_panelMatrix(param1:ColorMatrix) : void
      {
      }
      
      function move3D() : void
      {
         if(myPanel == null)
         {
            return;
         }
         this.x = parent.mouseX - assetData["dragOffset"].x * this.scaleX;
         var _loc1_:Number = originPoint.y - stage.mouseY;
         this.scale = this.scale - _loc1_ / 50;
         originPoint = new Point(stage.mouseX,stage.mouseY);
         resized();
      }
      
      protected function apply_filter() : Array
      {
         var _loc1_:GlowFilter = null;
         if(assetData && assetData["locked"])
         {
            return [Utils.locked_filter];
         }
         if(_editing)
         {
            return [Utils.editing_filter];
         }
         if(_selected)
         {
            if(assetData && assetData["type"] == "promoted text")
            {
               return [Utils.textbubble_filter];
            }
            return [Utils.selected_filter];
         }
         return [];
      }
      
      public function update_cursor() : Boolean
      {
         if(_selected == false || assetData["locked"])
         {
            return false;
         }
         dispatchEvent(new CursorEvent("asset_" + move_mode));
         return true;
      }
      
      public function get locked() : Boolean
      {
         return assetData["locked"];
      }
      
      public function get_filters() : Object
      {
         return assetData["filters"];
      }
      
      protected function nudgeMe(param1:KeyboardEvent) : void
      {
         if(key_locked || stage.focus is TextField && TextField(stage.focus).type == TextFieldType.INPUT)
         {
            return;
         }
         if(param1.charCode == 108 && move_mode != 3)
         {
            this.setLock(!assetData["locked"]);
            return;
         }
         if(assetData["locked"])
         {
            return;
         }
         var _loc2_:Number = 2;
         if(param1.ctrlKey)
         {
            _loc2_ = 0.5;
         }
         switch(param1.keyCode)
         {
            case Keyboard.DOWN:
               this.y = this.y + _loc2_;
               break;
            case Keyboard.UP:
               this.y = this.y - _loc2_;
               break;
            case 188:
               turn = turn + -2;
               break;
            case 190:
               turn = turn + 2;
               break;
            case Keyboard.LEFT:
               this.x = this.x - _loc2_;
               break;
            case Keyboard.RIGHT:
               this.x = this.x + _loc2_;
               break;
            case 187:
               scale = assetData["scale"] + _loc2_ / 20;
               break;
            case 189:
               scale = assetData["scale"] - _loc2_ / 20;
         }
         resized();
      }
      
      public function get editing() : Boolean
      {
         return _editing && !_editing_override;
      }
      
      public function begin_drag() : void
      {
         if(debug)
         {
            trace("--ComicAsset.begin_drag()--");
         }
         if(_selected)
         {
            stage.addEventListener(MouseEvent.MOUSE_MOVE,asset_move,false,0,true);
            stage.addEventListener(MouseEvent.MOUSE_UP,releaseMe,false,0,true);
            this.update_move_points();
         }
      }
      
      public function set scale(param1:Number) : void
      {
         if(param1 > 0 && param1 < 5)
         {
            assetData["scale"] = param1;
            if(this.artwork is PropShape)
            {
               PropShape(this.artwork).scale = param1;
            }
            else
            {
               this.artwork.scaleX = this.artwork.scaleY = param1;
            }
         }
      }
      
      public function get bmode() : String
      {
         if(artwork)
         {
            return artwork.blendMode;
         }
         return "normal";
      }
      
      public function getData() : Object
      {
         return assetData;
      }
      
      public function getLock() : Boolean
      {
         return assetData["locked"];
      }
      
      public function set locked(param1:Boolean) : void
      {
         setLock(param1);
      }
      
      public function set_filters(param1:Object) : void
      {
      }
      
      public function set turn(param1:Number) : void
      {
         assetData.turn = param1;
         artwork.rotation = assetData.turn;
      }
      
      public function get selected() : Boolean
      {
         return _selected;
      }
      
      public function set bmode(param1:String) : void
      {
         artwork.blendMode = param1;
         assetData["blendMode"] = param1;
      }
      
      public function setLock(param1:Boolean) : void
      {
         var _loc2_:Array = null;
         if(!param1)
         {
            assetData["sceneBit"] = false;
         }
         assetData["locked"] = param1;
         apply_filter();
         if(_selected)
         {
            _loc2_ = this.apply_filter();
            if(stage && this.hitTestPoint(stage.mouseX,stage.mouseY))
            {
               dispatchEvent(new CursorEvent("lock"));
            }
         }
         else
         {
            _loc2_ = [];
         }
         container.filters = _loc2_;
      }
      
      private function mouse_over(param1:MouseEvent) : void
      {
         if(param1.buttonDown == false && _selected == false && assetData && assetData["locked"] == false)
         {
            container.filters = [Utils.over_filter];
         }
         if(myPanel)
         {
            if(assetData["locked"] == false)
            {
               dispatchEvent(new CursorEvent("asset_" + move_mode,param1.buttonDown));
            }
            else
            {
               dispatchEvent(new CursorEvent("camera_" + move_mode,param1.buttonDown));
            }
         }
         param1.stopPropagation();
      }
      
      public function resized(param1:Number = 0) : void
      {
      }
      
      private function mouse_out(param1:MouseEvent) : void
      {
         if(_selected == false)
         {
            container.filters = [];
         }
         if(param1.buttonDown)
         {
            return;
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         _selected = param1;
      }
      
      public function doubleClick(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--ComicAsset.doubleClick()--");
         }
      }
      
      public function update_move_points() : void
      {
         if(assetData == null)
         {
            return;
         }
         if(parent && parent.stage)
         {
            originPoint = new Point(parent.stage.mouseX,parent.stage.mouseY);
         }
         else
         {
            originPoint = new Point(0,0);
         }
         var _loc1_:Point = this.globalToLocal(originPoint);
         _rotate_offset = Utils.get_degrees_from_points(_loc1_,new Point(0,0)) - 90 - turn;
         _loc1_ = parent.globalToLocal(originPoint);
         _loc1_.x = _loc1_.x - this.x;
         _loc1_.y = _loc1_.y - this.y;
         assetData["dragOffset"] = _loc1_;
      }
      
      function asset_move(param1:MouseEvent) : void
      {
         if(!assetData["locked"])
         {
            switch(move_mode)
            {
               case 0:
                  move2D(param1);
                  break;
               case 1:
                  move3D();
                  break;
               case 2:
                  rotate(param1);
            }
         }
      }
      
      public function doHitTest(param1:Point) : Boolean
      {
         if(assetData["type"] == "text bubble")
         {
            return artwork.hitTestPoint(param1.x,param1.y,true);
         }
         return artwork.hitTestPoint(param1.x,param1.y,true);
      }
      
      public function setPanel(param1:ComicPanel) : void
      {
         if(debug)
         {
            trace("--ComicAsset.setPanel(" + param1 + ")--");
         }
         myPanel = param1;
         if(myPanel != null)
         {
            containerClip = this.parent;
         }
      }
      
      public function get_touches() : Array
      {
         var _loc6_:DisplayObject = null;
         var _loc1_:Array = [];
         var _loc2_:Array = [];
         var _loc3_:DisplayObjectContainer = this.parent;
         var _loc4_:int = _loc3_.getChildIndex(this);
         var _loc5_:int = _loc4_ - 1;
         while(_loc5_ >= 0)
         {
            _loc6_ = _loc3_.getChildAt(_loc5_);
            if(HitTest.complexHitTestObject(this,_loc6_))
            {
               _loc1_.push(_loc6_);
               break;
            }
            _loc5_--;
         }
         _loc5_ = _loc4_ + 1;
         while(_loc5_ < _loc3_.numChildren)
         {
            _loc6_ = _loc3_.getChildAt(_loc5_);
            if(HitTest.complexHitTestObject(this,_loc6_))
            {
               _loc2_.push(_loc6_);
               break;
            }
            _loc5_++;
         }
         return [_loc1_,_loc2_];
      }
      
      public function getType() : String
      {
         return assetData["type"];
      }
      
      public function move_up() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:Array = this.get_touches();
         if(_loc1_[0].length)
         {
            _loc2_ = this.parent.getChildIndex(this);
            _loc3_ = this.parent.getChildIndex(_loc1_[0][0]);
            trace("Index: " + _loc2_ + ", " + _loc3_);
            this.parent.setChildIndex(this,_loc3_);
         }
         else if(this is TextBubble)
         {
            myPanel.demote_text(this as TextBubble);
            assetData.type = "text bubble";
            container.filters = [Utils.selected_filter];
         }
         return false;
      }
      
      public function get scale() : Number
      {
         return assetData["scale"];
      }
      
      public function setController(param1:*) : void
      {
         controller = param1;
      }
      
      public function getPanel() : Object
      {
         return myPanel;
      }
      
      public function save_state() : Object
      {
         if(debug)
         {
            trace("--ComicAsset.save_state()--");
         }
         var _loc1_:Object = Utils.clone(assetData);
         _loc1_["position"] = {
            "x":this.x,
            "y":this.y
         };
         return _loc1_;
      }
      
      public function move_down() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:Array = this.get_touches();
         if(_loc1_[1].length)
         {
            _loc2_ = this.parent.getChildIndex(this);
            _loc3_ = this.parent.getChildIndex(_loc1_[1][0]);
            trace("Index: " + _loc2_ + ", " + _loc3_);
            this.parent.setChildIndex(this,_loc3_);
         }
         else if(this is TextBubble)
         {
            myPanel.promote_text(this as TextBubble);
            assetData.type = "promoted text";
            container.filters = [Utils.textbubble_filter];
         }
         return false;
      }
      
      public function getContentClip() : DisplayObjectContainer
      {
         return containerClip;
      }
      
      private function get move_mode() : uint
      {
         if(myPanel)
         {
            return myPanel.move_mode;
         }
         return 0;
      }
      
      private function rotate(param1:MouseEvent) : void
      {
         var _loc2_:Point = new Point(param1.stageX,param1.stageY);
         _loc2_ = this.globalToLocal(_loc2_);
         turn = Utils.get_degrees_from_points(new Point(0,0),_loc2_) + 90 - _rotate_offset;
      }
      
      public function setColour(param1:Number) : void
      {
      }
      
      public function check_key_down(param1:KeyboardEvent) : void
      {
         param1.stopPropagation();
         if(myPanel == null)
         {
            return;
         }
         if(this.hitTestPoint(stage.mouseX,stage.mouseY,true))
         {
            if(param1.charCode == 0)
            {
               if(!param1.shiftKey)
               {
               }
            }
         }
         else
         {
            trace("NO HIT");
         }
      }
      
      protected function move2D(param1:MouseEvent) : void
      {
         var _loc2_:Point = new Point(stage.mouseX,stage.mouseY);
         _loc2_ = parent.globalToLocal(_loc2_);
         this.x = _loc2_.x - assetData["dragOffset"].x;
         this.y = _loc2_.y - assetData["dragOffset"].y;
         resized();
      }
      
      public function check_key_up(param1:KeyboardEvent) : void
      {
         if(param1.charCode == 0)
         {
         }
      }
      
      public function doSelect(param1:Boolean) : Boolean
      {
         var _loc2_:Array = null;
         if(debug)
         {
            trace("--ComicAsset.doSelect(" + param1 + ")--");
         }
         if(parent == null)
         {
            if(param1 == true)
            {
               trace("------------------- ERROR ----------------------");
            }
            return param1;
         }
         if(param1 == false && _editing == true)
         {
            editing = false;
         }
         update_move_points();
         if(_selected == param1)
         {
            return false;
         }
         selected = param1;
         if(_selected && hilightable)
         {
            _loc2_ = apply_filter();
            if(stage)
            {
               stage.addEventListener(MouseEvent.MOUSE_UP,releaseMe,false,0,true);
               stage.addEventListener(KeyboardEvent.KEY_DOWN,nudgeMe,false,0,true);
            }
         }
         else
         {
            _loc2_ = new Array();
            if(stage)
            {
               stage.removeEventListener(KeyboardEvent.KEY_DOWN,nudgeMe);
            }
         }
         container.filters = _loc2_;
         if(assetData)
         {
            return !assetData["locked"];
         }
         return false;
      }
      
      public function set editing(param1:Boolean) : void
      {
         _editing = param1;
      }
      
      public function centerInPanel() : void
      {
         if(debug)
         {
            trace("--ComicAsset.centerInPanel()--");
         }
         var _loc1_:Number = 15;
      }
      
      public function get turn() : Number
      {
         return assetData.turn;
      }
      
      function releaseMe(param1:MouseEvent) : void
      {
         var _loc2_:ComicBuilder = null;
         var _loc3_:ComicControl = null;
         if(debug)
         {
            trace("--ComicAsset.releaseMe()--");
         }
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,releaseMe);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,asset_move);
            if(this.myPanel)
            {
               _loc2_ = this.myPanel.myComic.getComicBuilder();
               _loc3_ = _loc2_.getComic_controls();
               _loc3_.update_stacking();
            }
         }
         dispatchEvent(new CursorEvent("reset"));
      }
   }
}
