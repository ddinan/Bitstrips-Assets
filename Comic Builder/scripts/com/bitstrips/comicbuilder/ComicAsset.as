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
       
      
      protected var myPanel:ComicPanel;
      
      protected var assetData:Object;
      
      protected var container:Sprite;
      
      public var artwork:Sprite;
      
      protected var containerClip:DisplayObjectContainer;
      
      var originPoint:Point;
      
      public var asset_type:String = "";
      
      protected var controller;
      
      protected var turn_factor:int;
      
      protected var originalWidth:Number;
      
      protected var hilightable:Boolean;
      
      public var debug:Boolean = false;
      
      public var key_locked:Boolean = false;
      
      protected var _selected:Boolean = false;
      
      protected var _editing:Boolean = false;
      
      protected var _editing_override:Boolean = false;
      
      private var _rotate_offset:Number;
      
      public function ComicAsset()
      {
         super();
         if(this.debug)
         {
            trace("--ComicAsset()--");
         }
         mouseChildren = false;
         doubleClickEnabled = true;
         this.container = new Sprite();
         this.artwork = new Sprite();
         addChild(this.container);
         this.container.addChild(this.artwork);
         this.selected = false;
         this.hilightable = true;
         var _loc1_:Array = new Array();
         this.container.filters = _loc1_;
         this.artwork.tabChildren = this.artwork.tabEnabled = false;
         this.cacheAsBitmap = true;
      }
      
      public function remove() : void
      {
         Utils.remove_children(this);
         Utils.remove_children(this.container);
         Utils.remove_children(this.artwork);
         this.container = null;
         this.artwork = null;
         this.assetData = null;
         this.removeEventListener(MouseEvent.DOUBLE_CLICK,this.doubleClick);
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.mouse_over);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.mouse_out);
      }
      
      public function set_filters(param1:Object) : void
      {
      }
      
      public function set_panelMatrix(param1:ColorMatrix) : void
      {
      }
      
      public function get_filters() : Object
      {
         return this.assetData["filters"];
      }
      
      private function mouse_over(param1:MouseEvent) : void
      {
         if(param1.buttonDown == false && this._selected == false && this.assetData && this.assetData["locked"] == false)
         {
            this.container.filters = [Utils.over_filter];
         }
         if(this.myPanel)
         {
            if(this.assetData["locked"] == false)
            {
               dispatchEvent(new CursorEvent("asset_" + this.move_mode,param1.buttonDown));
            }
            else
            {
               dispatchEvent(new CursorEvent("camera_" + this.move_mode,param1.buttonDown));
            }
         }
         param1.stopPropagation();
      }
      
      public function get locked() : Boolean
      {
         return this.assetData["locked"];
      }
      
      private function mouse_out(param1:MouseEvent) : void
      {
         if(this._selected == false)
         {
            this.container.filters = [];
         }
         if(param1.buttonDown)
         {
            return;
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
            this.myPanel.promote_text(this as TextBubble);
            this.assetData.type = "promoted text";
            this.container.filters = [Utils.textbubble_filter];
         }
         return false;
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
            this.myPanel.demote_text(this as TextBubble);
            this.assetData.type = "text bubble";
            this.container.filters = [Utils.selected_filter];
         }
         return false;
      }
      
      public function setPanel(param1:ComicPanel) : void
      {
         if(this.debug)
         {
            trace("--ComicAsset.setPanel(" + param1 + ")--");
         }
         this.myPanel = param1;
         if(this.myPanel != null)
         {
            this.containerClip = this.parent;
         }
      }
      
      public function doubleClick(param1:MouseEvent) : void
      {
         if(this.debug)
         {
            trace("--ComicAsset.doubleClick()--");
         }
      }
      
      function asset_move(param1:MouseEvent) : void
      {
         if(!this.assetData["locked"])
         {
            switch(this.move_mode)
            {
               case 0:
                  this.move2D(param1);
                  break;
               case 1:
                  this.move3D();
                  break;
               case 2:
                  this.rotate(param1);
            }
         }
      }
      
      private function get move_mode() : uint
      {
         if(this.myPanel)
         {
            return this.myPanel.move_mode;
         }
         return 0;
      }
      
      public function update_cursor() : Boolean
      {
         if(this._selected == false || this.assetData["locked"])
         {
            return false;
         }
         dispatchEvent(new CursorEvent("asset_" + this.move_mode));
         return true;
      }
      
      private function rotate(param1:MouseEvent) : void
      {
         var _loc2_:Point = new Point(param1.stageX,param1.stageY);
         _loc2_ = this.globalToLocal(_loc2_);
         this.turn = Utils.get_degrees_from_points(new Point(0,0),_loc2_) + 90 - this._rotate_offset;
      }
      
      protected function move2D(param1:MouseEvent) : void
      {
         var _loc2_:Point = new Point(stage.mouseX,stage.mouseY);
         _loc2_ = parent.globalToLocal(_loc2_);
         this.x = _loc2_.x - this.assetData["dragOffset"].x;
         this.y = _loc2_.y - this.assetData["dragOffset"].y;
         this.resized();
      }
      
      function move3D() : void
      {
         if(this.myPanel == null)
         {
            return;
         }
         this.x = parent.mouseX - this.assetData["dragOffset"].x * this.scaleX;
         var _loc1_:Number = this.originPoint.y - stage.mouseY;
         this.scale = this.scale - _loc1_ / 50;
         this.originPoint = new Point(stage.mouseX,stage.mouseY);
         this.resized();
      }
      
      public function set scale(param1:Number) : void
      {
         if(param1 > 0 && param1 < 5)
         {
            this.assetData["scale"] = param1;
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
      
      public function get scale() : Number
      {
         return this.assetData["scale"];
      }
      
      function releaseMe(param1:MouseEvent) : void
      {
         var _loc2_:ComicBuilder = null;
         var _loc3_:ComicControl = null;
         if(this.debug)
         {
            trace("--ComicAsset.releaseMe()--");
         }
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.releaseMe);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.asset_move);
            if(this.myPanel)
            {
               _loc2_ = this.myPanel.myComic.getComicBuilder();
               _loc3_ = _loc2_.getComic_controls();
               _loc3_.update_stacking();
            }
         }
         dispatchEvent(new CursorEvent("reset"));
      }
      
      protected function nudgeMe(param1:KeyboardEvent) : void
      {
         if(this.key_locked || stage.focus is TextField && TextField(stage.focus).type == TextFieldType.INPUT)
         {
            return;
         }
         if(param1.charCode == 108 && this.move_mode != 3)
         {
            this.setLock(!this.assetData["locked"]);
            return;
         }
         if(this.assetData["locked"])
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
               this.turn = this.turn + -2;
               break;
            case 190:
               this.turn = this.turn + 2;
               break;
            case Keyboard.LEFT:
               this.x = this.x - _loc2_;
               break;
            case Keyboard.RIGHT:
               this.x = this.x + _loc2_;
               break;
            case 187:
               this.scale = this.assetData["scale"] + _loc2_ / 20;
               break;
            case 189:
               this.scale = this.assetData["scale"] - _loc2_ / 20;
         }
         this.resized();
      }
      
      public function getData() : Object
      {
         return this.assetData;
      }
      
      public function getPanel() : Object
      {
         return this.myPanel;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
      }
      
      public function update_move_points() : void
      {
         if(this.assetData == null)
         {
            return;
         }
         if(parent && parent.stage)
         {
            this.originPoint = new Point(parent.stage.mouseX,parent.stage.mouseY);
         }
         else
         {
            this.originPoint = new Point(0,0);
         }
         var _loc1_:Point = this.globalToLocal(this.originPoint);
         this._rotate_offset = Utils.get_degrees_from_points(_loc1_,new Point(0,0)) - 90 - this.turn;
         _loc1_ = parent.globalToLocal(this.originPoint);
         _loc1_.x = _loc1_.x - this.x;
         _loc1_.y = _loc1_.y - this.y;
         this.assetData["dragOffset"] = _loc1_;
      }
      
      public function doSelect(param1:Boolean) : Boolean
      {
         var _loc2_:Array = null;
         if(this.debug)
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
         if(param1 == false && this._editing == true)
         {
            this.editing = false;
         }
         this.update_move_points();
         if(this._selected == param1)
         {
            return false;
         }
         this.selected = param1;
         if(this._selected && this.hilightable)
         {
            _loc2_ = this.apply_filter();
            if(stage)
            {
               stage.addEventListener(MouseEvent.MOUSE_UP,this.releaseMe,false,0,true);
               stage.addEventListener(KeyboardEvent.KEY_DOWN,this.nudgeMe,false,0,true);
            }
         }
         else
         {
            _loc2_ = new Array();
            if(stage)
            {
               stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.nudgeMe);
            }
         }
         this.container.filters = _loc2_;
         if(this.assetData)
         {
            return !this.assetData["locked"];
         }
         return false;
      }
      
      public function begin_drag() : void
      {
         if(this.debug)
         {
            trace("--ComicAsset.begin_drag()--");
         }
         if(this._selected)
         {
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.asset_move,false,0,true);
            stage.addEventListener(MouseEvent.MOUSE_UP,this.releaseMe,false,0,true);
            this.update_move_points();
         }
      }
      
      public function save_state() : Object
      {
         if(this.debug)
         {
            trace("--ComicAsset.save_state()--");
         }
         var _loc1_:Object = Utils.clone(this.assetData);
         _loc1_["position"] = {
            "x":this.x,
            "y":this.y
         };
         return _loc1_;
      }
      
      public function loaded() : void
      {
         this.addEventListener(MouseEvent.DOUBLE_CLICK,this.doubleClick,false,0,true);
         addEventListener(MouseEvent.MOUSE_OVER,this.mouse_over,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.mouse_out,false,0,true);
      }
      
      public function load_state(param1:Object) : void
      {
         if(this.debug)
         {
            trace("--ComicAsset.load_state()--");
         }
         this.assetData = Utils.clone(param1);
         this.name = this.assetData.name;
         this.asset_type = this.assetData["type"];
         if(this.debug)
         {
            trace("sceneBit: " + this.assetData["sceneBit"]);
         }
         if(this.assetData["locked"] == undefined)
         {
            if(this.debug)
            {
               trace("ASSIGNING DEFAULT LOCKED TO FALSE");
            }
            this.assetData["locked"] = false;
         }
         this.setLock(this.assetData["locked"]);
         if(!this.assetData["dragOffset"])
         {
            if(this.debug)
            {
               trace("I HAVE NO DRAG OFFSET!");
            }
            this.assetData["dragOffset"] = {
               "x":0,
               "y":0
            };
         }
         else if(this.debug)
         {
            trace("dragOffset.x: " + this.assetData["dragOffset"].x + " dragOffset.y: " + this.assetData["dragOffset"].y);
         }
         if(!this.assetData["scale"])
         {
            this.assetData["scale"] = 1;
         }
         if(!this.assetData["turn"])
         {
            this.assetData["turn"] = 0;
         }
         if(!this.assetData["position"])
         {
            this.assetData["position"] = {
               "x":0,
               "y":0
            };
         }
         this.originPoint = new Point(0,0);
         if(this.debug)
         {
            trace("Position: " + this.assetData["position"]["x"] + ", " + this.assetData["position"]["y"]);
         }
         this.x = this.assetData["position"]["x"];
         this.y = this.assetData["position"]["y"];
         this.turn = this.assetData.turn;
         this.scale = this.assetData["scale"];
         if(this.assetData["blendMode"])
         {
            this.artwork.blendMode = this.assetData["blendMode"];
         }
      }
      
      public function centerInPanel() : void
      {
         if(this.debug)
         {
            trace("--ComicAsset.centerInPanel()--");
         }
         var _loc1_:Number = 15;
      }
      
      public function get turn() : Number
      {
         return this.assetData.turn;
      }
      
      public function set turn(param1:Number) : void
      {
         this.assetData.turn = param1;
         this.artwork.rotation = this.assetData.turn;
      }
      
      public function resized(param1:Number = 0) : void
      {
      }
      
      public function set locked(param1:Boolean) : void
      {
         this.setLock(param1);
      }
      
      public function setLock(param1:Boolean) : void
      {
         var _loc2_:Array = null;
         if(!param1)
         {
            this.assetData["sceneBit"] = false;
         }
         this.assetData["locked"] = param1;
         this.apply_filter();
         if(this._selected)
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
         this.container.filters = _loc2_;
      }
      
      public function getLock() : Boolean
      {
         return this.assetData["locked"];
      }
      
      public function setController(param1:*) : void
      {
         this.controller = param1;
      }
      
      public function getContentClip() : DisplayObjectContainer
      {
         return this.containerClip;
      }
      
      public function setColour(param1:Number) : void
      {
      }
      
      public function doHitTest(param1:Point) : Boolean
      {
         if(this.assetData["type"] == "text bubble")
         {
            return this.artwork.hitTestPoint(param1.x,param1.y,true);
         }
         return this.artwork.hitTestPoint(param1.x,param1.y,true);
      }
      
      public function getType() : String
      {
         return this.assetData["type"];
      }
      
      public function get bmode() : String
      {
         if(this.artwork)
         {
            return this.artwork.blendMode;
         }
         return "normal";
      }
      
      public function set bmode(param1:String) : void
      {
         this.artwork.blendMode = param1;
         this.assetData["blendMode"] = param1;
      }
      
      public function check_key_down(param1:KeyboardEvent) : void
      {
         param1.stopPropagation();
         if(this.myPanel == null)
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
      
      public function check_key_up(param1:KeyboardEvent) : void
      {
         if(param1.charCode == 0)
         {
         }
      }
      
      public function get editing() : Boolean
      {
         return this._editing && !this._editing_override;
      }
      
      public function set editing(param1:Boolean) : void
      {
         this._editing = param1;
      }
      
      protected function apply_filter() : Array
      {
         var _loc1_:GlowFilter = null;
         if(this.assetData && this.assetData["locked"])
         {
            return [Utils.locked_filter];
         }
         if(this._editing)
         {
            return [Utils.editing_filter];
         }
         if(this._selected)
         {
            if(this.assetData && this.assetData["type"] == "promoted text")
            {
               return [Utils.textbubble_filter];
            }
            return [Utils.selected_filter];
         }
         return [];
      }
   }
}
