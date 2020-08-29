package com.bitstrips.comicbuilder
{
   import com.bitstrips.Utils;
   import com.bitstrips.controls.ComicControl;
   import flash.display.BitmapData;
   import flash.display.CapsStyle;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ComicPanel extends Sprite
   {
      
      public static const borderSize:Number = 8;
       
      
      public var myComic:Comic;
      
      private var myComicStrip:ComicStrip;
      
      private var text_mask:Shape;
      
      public var text_content:PanelContents;
      
      private var panel_mask:Shape;
      
      public var content:PanelContents;
      
      private var outline:Shape;
      
      private var border:Sprite;
      
      private var hilight:Shape;
      
      private var panelData:Object;
      
      private var followingSprite:ComicPanel;
      
      private var bordered:Boolean;
      
      private var editable:Boolean = true;
      
      private var borderOffset:Point;
      
      private var toggling_camera:Boolean = false;
      
      private var hilightColor:Number;
      
      private var hilightable:Boolean;
      
      private const hilightColor_primary:Number = 52479;
      
      private const hilightColor_secondary:Number = 10035967;
      
      public const standardPanelWidth:Number = 176;
      
      public const standardPanelHeight:Number = 178;
      
      private var debug:Boolean = false;
      
      public var blank:Boolean = true;
      
      private var _selected:Boolean = false;
      
      private var popped_asset_container:Sprite;
      
      private var popped_blocker:Sprite;
      
      private var popped_mask:Sprite;
      
      public var locked:Boolean = false;
      
      private var local_down:Point;
      
      private var _rotate_offset:Number;
      
      private var stage_down:Point;
      
      private var _content_down:Point;
      
      private var _shift_down:Boolean = false;
      
      private var _ctrl_down:Boolean = false;
      
      private var old_mode:int = 0;
      
      private var _children_filter:Boolean = true;
      
      public function ComicPanel(param1:Comic, param2:ComicStrip, param3:Object, param4:Boolean)
      {
         super();
         if(this.debug)
         {
            trace("--ComicPanel()--");
         }
         this.myComic = param1;
         this.myComicStrip = param2;
         this.bordered = param4;
         this.hilightable = true;
         this.text_content = new PanelContents(this.myComic,this,true);
         this.content = new PanelContents(this.myComic,this);
         this.outline = new Shape();
         this.border = new Sprite();
         this.panel_mask = new Shape();
         this.text_mask = new Shape();
         addChild(this.panel_mask);
         addChild(this.content);
         addChild(this.text_mask);
         addChild(this.text_content);
         addChild(this.outline);
         addChild(this.border);
         this.hilight = new Shape();
         if(this.bordered)
         {
            this.border.addEventListener(MouseEvent.MOUSE_DOWN,this.borderMoveStart,false,0,true);
            this.border.addEventListener(MouseEvent.MOUSE_OVER,this.border_over,false,0,true);
            this.border.addEventListener(MouseEvent.MOUSE_OUT,this.border_out,false,0,true);
         }
         this.content.addEventListener(Event.SELECT,this.select_panel,false,0,true);
         this.content.addEventListener(MouseEvent.MOUSE_DOWN,this.content_down,false,-1,true);
         this.popped_blocker = new Sprite();
         this.popped_blocker.doubleClickEnabled = true;
         this.popped_blocker.addEventListener(MouseEvent.DOUBLE_CLICK,this.pop_back_handler,false,0,true);
         this.popped_asset_container = new Sprite();
         this.popped_mask = new Sprite();
         this.load_state(param3);
      }
      
      public function get move_mode() : uint
      {
         return this.myComic.move_mode;
      }
      
      private function update_move_points() : void
      {
         if(stage == null)
         {
            trace("When am I null?");
            return;
         }
         this.stage_down = new Point(stage.mouseX,stage.mouseY);
         this.local_down = this.globalToLocal(this.stage_down);
         this._rotate_offset = Utils.get_degrees_from_points(this.local_down,new Point(this.content.x,this.content.y)) - 90 - this.content.rotation;
         this._content_down = this.globalToLocal(new Point(stage.mouseX,stage.mouseY));
         this._content_down.x = this._content_down.x - this.content.x;
         this._content_down.y = this._content_down.y - this.content.y;
         if(this.myComic && this.myComic.selectedAsset)
         {
            this.myComic.selectedAsset.update_move_points();
         }
      }
      
      private function content_down(param1:MouseEvent) : void
      {
         if(param1.eventPhase == 2)
         {
            this.myComic.selectAsset(null);
         }
         if(this.locked == true)
         {
            return;
         }
         if(this.myComic.selectedAsset && this.myComic.selectedAsset.editing)
         {
            return;
         }
         this.myComic.pre_undo();
         this.update_move_points();
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.content_move,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.content_up,false,0,true);
         if(this._selected)
         {
            return;
         }
         this.selected = true;
         this.myComic.popped_asset = null;
      }
      
      private function content_move(param1:MouseEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Point = new Point(stage.mouseX,stage.mouseY);
         if(this.move_mode == 0)
         {
            _loc2_ = this.globalToLocal(_loc2_);
            this.content.x = _loc2_.x - this._content_down.x;
            this.content.y = _loc2_.y - this._content_down.y;
         }
         else if(this.move_mode == 1)
         {
            _loc3_ = this.content.scaleX;
            _loc3_ = _loc3_ - (this.stage_down.y - stage.mouseY) / 100;
            _loc3_ = Math.min(Math.max(_loc3_,0.25),10);
            this.content.scaleX = this.content.scaleY = _loc3_;
            this.stage_down = new Point(stage.mouseX,stage.mouseY);
         }
         else if(this.move_mode == 2)
         {
            _loc2_ = this.globalToLocal(_loc2_);
            this.content.rotation = Utils.get_degrees_from_points(new Point(this.content.x,this.content.y),_loc2_) + 90 - this._rotate_offset;
         }
         this.check_contents();
         this.drawBorder(true);
      }
      
      private function content_up(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.content_move);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.content_up);
         dispatchEvent(new CursorEvent("reset"));
         this.drawBorder();
      }
      
      private function check_contents() : void
      {
         var _loc1_:Number = this.content.scaleX;
         var _loc2_:Number = _loc1_;
         if(this.debug)
         {
            trace("Current Width & Height: " + this.panel_mask.width + ", " + this.panel_mask.height + " Current Scale: " + _loc1_);
         }
         if(this.panel_mask.width > 1300 * _loc1_)
         {
            this.scale = this.panel_mask.width / 1300;
            if(this.debug)
            {
               trace("Panel too wide to fit!");
            }
            _loc1_ = this.content.scaleX;
         }
         if(this.panel_mask.height > 1300 * _loc1_)
         {
            this.scale = this.panel_mask.height / 1300;
            _loc1_ = this.content.scaleX;
            if(this.debug)
            {
               trace("Panel too tall to fit!");
            }
         }
         if(this.debug)
         {
            trace("Content: " + this.content.x + "," + this.content.y);
         }
         this.content.x = Math.min(650 * _loc1_,this.content.x);
         this.content.y = Math.min(650 * _loc1_,this.content.y);
         if(this.debug)
         {
            trace("Max X: " + (-650 * _loc1_ + this.panel_mask.width));
         }
         this.content.x = Math.max(-650 * _loc1_ + this.panel_mask.width,this.content.x);
         this.content.y = Math.max(-650 * _loc1_ + this.panel_mask.height,this.content.y);
      }
      
      private function select_panel(param1:Event) : void
      {
         if(this._selected)
         {
            return;
         }
         this.selected = true;
         this.myComic.popped_asset = null;
      }
      
      public function panelBitmap(param1:Number = 3, param2:Boolean = true) : BitmapData
      {
         this.spelling(false);
         var _loc3_:Matrix = new Matrix();
         this.border.visible = param2;
         var _loc4_:Rectangle = this.panel_mask.getBounds(this);
         if(param2)
         {
            _loc4_.x = _loc4_.x - 1;
            _loc4_.width = _loc4_.width + 2;
            _loc4_.y = _loc4_.y - 1;
            _loc4_.height = _loc4_.height + 2;
         }
         else
         {
            _loc4_.x = _loc4_.x + 1;
            _loc4_.y = _loc4_.y + 1;
            _loc4_.width = _loc4_.width - 2;
            _loc4_.height = _loc4_.height - 2;
         }
         this.scaleX = this.scaleY = param1;
         _loc3_.scale(param1,param1);
         _loc3_.translate(-_loc4_.x * param1,-_loc4_.y * param1);
         var _loc5_:BitmapData = new BitmapData(_loc4_.width * param1,_loc4_.height * param1,false,0);
         _loc5_.draw(this,_loc3_,null,null,null,true);
         this.scaleX = this.scaleY = 1;
         this.spelling(true);
         this.border.visible = true;
         return _loc5_;
      }
      
      public function spelling(param1:Boolean) : void
      {
         this.content.spelling(param1);
         this.text_content.spelling(param1);
      }
      
      public function border_over(param1:MouseEvent) : void
      {
         dispatchEvent(new CursorEvent("border_h",param1.buttonDown));
      }
      
      public function border_out(param1:MouseEvent) : void
      {
         dispatchEvent(new CursorEvent("strip",param1.buttonDown));
      }
      
      public function load_state(param1:Object) : void
      {
         if(this.debug)
         {
            trace("--ComicPanel.load_state(" + param1 + ")--");
            trace("state[\'contentList\'].length: " + param1["contentList"].length);
            trace("backdrop: " + param1["backdrop"]);
         }
         this.clearPanel();
         this.content.clearPanel();
         this.text_content.clearPanel();
         if(param1["width"] == null)
         {
            param1["width"] = this.panelData["width"];
         }
         this.panelData = Utils.clone(param1);
         if(this.myComicStrip)
         {
            this.panelData["height"] = this.myComicStrip.strip_height;
         }
         if(this.panelData.hasOwnProperty("height") == false || this.panelData["height"] == null || this.panelData["height"] == 0)
         {
            trace("Uh-oh, no height!");
         }
         if(this.panelData["content_x"])
         {
            this.content.x = this.panelData["content_x"];
            this.content.y = this.panelData["content_y"];
            this.content.rotation = this.panelData["content_rotation"];
         }
         else
         {
            this.content.x = this.panel_width / 2;
            this.content.y = this.panel_height / 2;
         }
         this.text_content.x = this.panel_width / 2;
         this.text_content.y = this.panel_height / 2;
         if(this.panelData["content_scale"])
         {
            this.content.scaleX = this.content.scaleY = this.panelData["content_scale"];
         }
         if(this.panelData["contents"])
         {
            this.content.load_state(this.panelData["contents"]);
         }
         if(this.panelData["text_contents"])
         {
            this.text_content.load_state(this.panelData["text_contents"]);
         }
         this.update_content_width();
         this.drawMe();
         this.content.addEventListener(MouseEvent.MOUSE_OVER,this.panel_over,false,0,true);
         this.content.addEventListener(MouseEvent.ROLL_OUT,this.panel_out,false,0,true);
         this.blank = false;
      }
      
      public function drawMe() : void
      {
         this.check_contents();
         this.outline.graphics.clear();
         this.outline.graphics.lineStyle(2,0,1,false,"normal",CapsStyle.SQUARE);
         this.drawToSize(this.outline);
         this.hilight.graphics.clear();
         this.hilight.graphics.lineStyle(8,this.hilightColor,1,false,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
         this.drawToSize(this.hilight);
         this.border.x = -ComicPanel.borderSize;
         this.drawBorder();
         this.panel_mask.graphics.clear();
         this.panel_mask.graphics.beginFill(16711884,0.5);
         this.panel_mask.graphics.drawRect(0,0,this.panelData.width,this.panelData.height);
         this.text_mask.graphics.clear();
         this.text_mask.graphics.beginFill(16711884,0.5);
         this.text_mask.graphics.drawRect(0,0,this.panelData.width,this.panelData.height);
         this.content.mask = this.panel_mask;
         this.text_content.mask = this.text_mask;
      }
      
      function drawToSize(param1:Shape) : void
      {
         if(this.panelData.width && this.panelData.height)
         {
            param1.graphics.drawRect(0,0,this.panelData.width,this.panelData.height);
         }
      }
      
      function drawBorder(param1:Boolean = false) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         this.border.graphics.clear();
         this.border.graphics.beginFill(65535,0);
         this.border.graphics.drawRect(0,0,ComicPanel.borderSize,this.panelData.height);
         this.border.graphics.endFill();
         if(param1)
         {
            _loc2_ = this.panel_mask.width / (this.scale * 1300);
            _loc3_ = this.content.x - (-650 * this.content.scaleX + this.panel_mask.width);
            _loc4_ = 650 * this.content.scaleX - (-650 * this.content.scaleX + this.panel_mask.width);
            _loc5_ = 1 - _loc3_ / _loc4_;
            if(_loc4_ == 0)
            {
               _loc5_ = 1;
            }
            _loc6_ = this.panelData.width * _loc2_;
            _loc7_ = _loc5_ * (this.panelData.width - _loc6_);
            this.border.graphics.lineStyle(5,0,0.8);
            this.border.graphics.moveTo(ComicPanel.borderSize + 10 + _loc7_,this.panelData.height - 8);
            this.border.graphics.lineTo(_loc6_ + ComicPanel.borderSize - 10 + _loc7_,this.panelData.height - 8);
            _loc2_ = this.panel_mask.height / (this.scale * 1300);
            _loc3_ = this.content.y - (-650 * this.content.scaleX + this.panel_mask.height);
            _loc4_ = 650 * this.content.scaleX - (-650 * this.content.scaleX + this.panel_mask.height);
            _loc5_ = 1 - _loc3_ / _loc4_;
            if(_loc4_ == 0)
            {
               _loc5_ = 1;
            }
            _loc8_ = this.panelData.height * _loc2_;
            _loc9_ = _loc5_ * (this.panelData.height - _loc8_);
            this.border.graphics.moveTo(this.panelData.width - 0,ComicPanel.borderSize + _loc9_);
            this.border.graphics.lineTo(this.panelData.width - 0,_loc8_ + ComicPanel.borderSize - 15 + _loc9_);
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         var _loc2_:ComicAsset = null;
         if(param1 == this._selected)
         {
            return;
         }
         this._selected = param1;
         if(this._selected)
         {
            this.myComic.selectPanel(this);
            this.hilightColor = this.hilightColor_primary;
            if(this.myComic.getSelectedAsset())
            {
               _loc2_ = this.myComic.getSelectedAsset();
               if(this.content.contains(_loc2_))
               {
                  this.hilightColor = this.hilightColor_secondary;
               }
               else
               {
                  this.myComic.selectAsset(null);
               }
            }
            this.hilight.graphics.clear();
            this.hilight.graphics.lineStyle(8,this.hilightColor,1,false,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
            this.drawToSize(this.hilight);
            addChildAt(this.hilight,0);
            if(stage)
            {
               stage.addEventListener(KeyboardEvent.KEY_DOWN,this.check_key_down,false,0,true);
               stage.addEventListener(KeyboardEvent.KEY_UP,this.check_key_up,false,0,true);
            }
         }
         else
         {
            if(this.contains(this.hilight))
            {
               removeChild(this.hilight);
            }
            if(stage)
            {
               stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.check_key_down);
               stage.removeEventListener(KeyboardEvent.KEY_UP,this.check_key_up);
            }
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
      
      public function addAsset(param1:ComicAsset, param2:Boolean) : void
      {
         this.content.addAsset(param1,param2);
      }
      
      public function addTextAsset(param1:ComicAsset, param2:Boolean) : void
      {
         this.text_content.addAsset(param1,param2);
      }
      
      public function get panel_contents() : PanelContents
      {
         return this.content;
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
      
      public function get scale() : Number
      {
         return this.content.scaleX;
      }
      
      public function set scale(param1:Number) : void
      {
         this.content.scaleX = this.content.scaleY = param1;
      }
      
      public function save_state() : Object
      {
         if(this.debug)
         {
            trace("--ComicPanel.save_state()--");
         }
         var _loc1_:Object = Utils.clone(this.panelData);
         _loc1_["contents"] = this.content.save_state();
         _loc1_["text_contents"] = this.text_content.save_state();
         _loc1_["content_x"] = this.content.x;
         _loc1_["content_y"] = this.content.y;
         _loc1_["content_scale"] = this.content.scaleX;
         _loc1_["content_rotation"] = this.content.rotation;
         _loc1_["children_filter"] = this._children_filter;
         if(this.debug)
         {
            trace("SAVING");
            trace("backdrop: " + _loc1_["backdrop"]);
            trace("ground: " + _loc1_["ground"]);
            trace("--------");
         }
         return _loc1_;
      }
      
      public function borderMoveStart(param1:MouseEvent) : void
      {
         this.myComic.stop_editing_asset();
         this.borderOffset = new Point(this.border.mouseX,this.border.mouseY);
         if(this.myComic.getEditable())
         {
            this.myComic.pre_undo();
            if(this.debug)
            {
               trace("--ComicPanel.borderMoveStart()--");
            }
            stage.addEventListener(MouseEvent.MOUSE_UP,this.borderMoveStop,false,0,true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.borderMove,false,0,true);
            this.followingSprite = this.myComic.panelFollower(this);
         }
      }
      
      public function borderMoveStop(param1:MouseEvent) : void
      {
         if(this.debug)
         {
            trace("--ComicPanel.borderMoveStop()--");
         }
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.borderMoveStop);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.borderMove);
         if(this.border.hitTestPoint(param1.stageX,param1.stageY) == false)
         {
            dispatchEvent(new CursorEvent("reset"));
         }
      }
      
      public function borderMove(param1:MouseEvent) : void
      {
         if(this.debug)
         {
            trace("Border Move");
         }
         this.myComic.borderResizePanel(this,this.followingSprite,this,this.borderOffset);
         this.check_contents();
      }
      
      public function get panel_width() : int
      {
         return this.panelData.width;
      }
      
      private function update_content_width() : void
      {
         this.content.panel_width = this.panel_width / this.content.scaleX;
         this.text_content.panel_width = this.panel_width / this.text_content.scaleX - 5;
      }
      
      public function set panel_width(param1:int) : void
      {
         param1 = Math.max(Math.min(param1,Comic.WIDTH_MAX),Comic.PANEL_WIDTH_MIN);
         var _loc2_:int = param1 - this.panelData.width;
         if(_loc2_)
         {
            this.panelData.width = param1;
            this.content.x = this.content.x + _loc2_ / 2;
            this.drawMe();
            this.update_content_width();
         }
         this.text_content.x = param1 / 2;
      }
      
      public function set panel_height(param1:Number) : void
      {
         param1 = Math.max(Math.min(param1,Comic.PANEL_HEIGHT_MAX),Comic.PANEL_HEIGHT_MIN);
         var _loc2_:Number = param1 - this.panelData.height;
         trace("Set panel height: " + param1);
         if(_loc2_)
         {
            this.panelData.height = param1;
            this.content.y = this.content.y + _loc2_ / 2;
            this.drawMe();
         }
         this.text_content.y = this.panel_height / 2;
      }
      
      public function get panel_height() : Number
      {
         return this.panelData.height;
      }
      
      public function getStrip() : ComicStrip
      {
         return this.myComicStrip;
      }
      
      public function getArea() : Sprite
      {
         return this.content;
      }
      
      public function getComic() : Comic
      {
         return this.myComic;
      }
      
      public function clearPanel() : void
      {
         this.content.clearPanel();
         this.text_content.clearPanel();
      }
      
      private function panel_over(param1:MouseEvent) : void
      {
         if(this.debug)
         {
            trace("panel over");
         }
         if(this.editable)
         {
            dispatchEvent(new CursorEvent("camera_" + this.move_mode,param1.buttonDown));
         }
      }
      
      private function panel_out(param1:MouseEvent) : void
      {
         if(this.debug)
         {
            trace("panel out");
         }
         if(this.editable)
         {
            dispatchEvent(new CursorEvent("strip",param1.buttonDown));
         }
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
         var _loc2_:ComicAsset = this.content.getAssetByName(param1);
         if(_loc2_ == null)
         {
            _loc2_ = this.text_content.getAssetByName(param1);
         }
         return _loc2_;
      }
      
      public function absorbScene(param1:Object) : void
      {
         if(this.debug)
         {
            trace("--ComicPanel.absorbScene()--");
         }
         this.load_state(DataDump.panelAbsorbScene(this.save_state(),param1));
      }
      
      public function killHilight() : void
      {
         this.hilightable = false;
      }
      
      public function check_key_down(param1:KeyboardEvent) : void
      {
         if(param1.charCode == 0 && !this.toggling_camera && (param1.shiftKey || param1.ctrlKey))
         {
            this.update_move_points();
            this.toggling_camera = true;
            if(param1.shiftKey)
            {
               this.toggleDepth();
               this._shift_down = true;
            }
            else if(param1.ctrlKey)
            {
               this.toggleAngle();
               this._ctrl_down = true;
            }
            if(stage && this.myComic.selectedAsset && this.myComic.selectedAsset.hitTestPoint(stage.mouseX,stage.mouseY))
            {
               this.myComic.selectedAsset.update_cursor();
            }
         }
      }
      
      public function check_key_up(param1:KeyboardEvent) : void
      {
         if(param1.charCode == 0 && this.toggling_camera)
         {
            if(param1.shiftKey != this._shift_down || param1.ctrlKey != this._ctrl_down)
            {
               this._shift_down = param1.shiftKey;
               this._ctrl_down = param1.ctrlKey;
               this.update_move_points();
               this.toggling_camera = false;
               this.untoggleCamera();
               if(stage && this.myComic.selectedAsset && this.myComic.selectedAsset.hitTestPoint(stage.mouseX,stage.mouseY))
               {
                  this.myComic.selectedAsset.update_cursor();
               }
            }
         }
      }
      
      private function toggleDepth() : void
      {
         var _loc1_:ComicControl = this.myComic.getComicBuilder().getComic_controls();
         if(_loc1_ == null)
         {
            return;
         }
         if(this.debug)
         {
            trace("toggleDepth");
         }
         this.old_mode = this.move_mode;
         if(this.move_mode == 1)
         {
            _loc1_.move_mode = 0;
         }
         else
         {
            _loc1_.move_mode = 1;
         }
         if(stage && this.panel_mask.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            dispatchEvent(new CursorEvent("camera_" + _loc1_.move_mode));
         }
      }
      
      private function toggleAngle() : void
      {
         if(this.debug)
         {
            trace("toggleAngle");
         }
         var _loc1_:ComicControl = this.myComic.getComicBuilder().getComic_controls();
         if(_loc1_ == null)
         {
            return;
         }
         this.old_mode = this.move_mode;
         if(this.move_mode == 2)
         {
            _loc1_.move_mode = 0;
         }
         else
         {
            _loc1_.move_mode = 2;
         }
         if(stage && this.panel_mask.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            dispatchEvent(new CursorEvent("camera_" + _loc1_.move_mode));
         }
      }
      
      private function untoggleCamera() : void
      {
         if(stage && this.panel_mask.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            dispatchEvent(new CursorEvent("camera_" + this.old_mode));
         }
         var _loc1_:ComicControl = this.myComic.getComicBuilder().getComic_controls();
         if(_loc1_ == null)
         {
            return;
         }
         _loc1_.move_mode = this.old_mode;
      }
      
      public function set children_filter(param1:Boolean) : void
      {
         if(param1 != this._children_filter)
         {
            this._children_filter = param1;
            this.content.set_filters(this.content.get_filters());
         }
      }
      
      public function get children_filter() : Boolean
      {
         return this._children_filter;
      }
      
      public function get strip() : ComicStrip
      {
         return this.myComicStrip;
      }
      
      public function pop_to_top(param1:ComicAsset) : void
      {
         if(this.myComic.popped_asset)
         {
            this.myComic.popped_asset = null;
         }
         param1 = this.content.pop_out(param1);
         if(param1)
         {
            this.myComic.popped_asset = param1;
            this.popped_blocker.graphics.clear();
            this.popped_blocker.graphics.beginFill(16777215,0.4);
            this.popped_blocker.graphics.drawRect(this.panel_mask.x,this.panel_mask.y,this.panel_mask.width,this.panel_mask.height);
            this.popped_mask.graphics.clear();
            this.popped_mask.graphics.beginFill(16777215,0.4);
            this.popped_mask.graphics.drawRect(this.panel_mask.x,this.panel_mask.y,this.panel_mask.width,this.panel_mask.height);
            this.popped_asset_container.x = this.content.x;
            this.popped_asset_container.y = this.content.y;
            this.popped_asset_container.scaleX = this.content.scaleX;
            this.popped_asset_container.scaleY = this.content.scaleY;
            this.popped_asset_container.rotation = this.content.rotation;
            this.popped_asset_container.mask = this.popped_mask;
            this.addChild(this.popped_blocker);
            this.addChild(this.popped_mask);
            this.popped_asset_container.addChild(this.myComic.popped_asset);
            this.addChild(this.popped_asset_container);
            this.popped_asset_container.mask = this.popped_mask;
            dispatchEvent(new CursorEvent("visible",false));
         }
      }
      
      public function pop_back_handler(param1:MouseEvent) : void
      {
         this.pop_back();
      }
      
      public function pop_back() : void
      {
         if(this.myComic.popped_asset)
         {
            this.content.pop_back(this.myComic.popped_asset);
            if(this.contains(this.popped_blocker))
            {
               this.removeChild(this.popped_blocker);
            }
            if(this.contains(this.popped_asset_container))
            {
               this.removeChild(this.popped_asset_container);
            }
            this.myComic.popped_asset = null;
            dispatchEvent(new CursorEvent("visible",true));
         }
      }
      
      public function pop_control() : void
      {
         if(this.myComic.popped_asset)
         {
            dispatchEvent(new CursorEvent("visible",!this.myComic.popped_asset.editing));
         }
      }
      
      public function promote_text(param1:TextBubble) : void
      {
         trace("promote_text");
         if(this.text_content.contains(param1))
         {
            return;
         }
         this.translate_contents(param1,this.content,this.text_content);
         this.text_content.addAsset(param1,true,true);
         param1.asset_type = "promoted text";
      }
      
      public function demote_text(param1:TextBubble) : void
      {
         trace("demote_text " + this.content.scaleX);
         if(this.content.contains(param1))
         {
            return;
         }
         this.translate_contents(param1,this.text_content,this.content);
         this.content.addAsset(param1,true);
         param1.asset_type = "text bubble";
      }
      
      private function translate_contents(param1:DisplayObject, param2:DisplayObjectContainer, param3:DisplayObjectContainer) : void
      {
         var _loc4_:Point = new Point(param1.x,param1.y);
         _loc4_ = param2.localToGlobal(_loc4_);
         _loc4_ = param3.globalToLocal(_loc4_);
         param1.x = _loc4_.x;
         param1.y = _loc4_.y;
         (param1 as ComicAsset).scale = (param1 as ComicAsset).scale * param2.scaleX * (1 / param3.scaleX);
         param1.rotation = param1.rotation + param2.rotation - param3.rotation;
      }
      
      public function remove() : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.borderMoveStop);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.borderMove);
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.check_key_down);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.check_key_up);
         this.border.removeEventListener(MouseEvent.MOUSE_DOWN,this.borderMoveStart);
         this.border.removeEventListener(MouseEvent.MOUSE_OVER,this.border_over);
         this.border.removeEventListener(MouseEvent.MOUSE_OUT,this.border_out);
         this.content.removeEventListener(Event.SELECT,this.select_panel);
         this.content.removeEventListener(MouseEvent.MOUSE_DOWN,this.content_down);
         this.popped_blocker.removeEventListener(MouseEvent.DOUBLE_CLICK,this.pop_back_handler);
      }
   }
}
