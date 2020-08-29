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
       
      
      public var locked:Boolean = false;
      
      public var myComic:Comic;
      
      private var toggling_camera:Boolean = false;
      
      private const hilightColor_secondary:Number = 10035967;
      
      private var border:Sprite;
      
      private var outline:Shape;
      
      private var stage_down:Point;
      
      private var panel_mask:Shape;
      
      private var myComicStrip:ComicStrip;
      
      public const standardPanelHeight:Number = 178;
      
      private var debug:Boolean = false;
      
      public var blank:Boolean = true;
      
      private var editable:Boolean = true;
      
      public var text_content:PanelContents;
      
      private var popped_mask:Sprite;
      
      private const hilightColor_primary:Number = 52479;
      
      public var content:PanelContents;
      
      private var _content_down:Point;
      
      private var _children_filter:Boolean = true;
      
      private var hilightable:Boolean;
      
      private var _ctrl_down:Boolean = false;
      
      private var hilightColor:Number;
      
      private var hilight:Shape;
      
      private var followingSprite:ComicPanel;
      
      public const standardPanelWidth:Number = 176;
      
      private var text_mask:Shape;
      
      private var old_mode:int = 0;
      
      private var bordered:Boolean;
      
      private var popped_asset_container:Sprite;
      
      private var panelData:Object;
      
      private var popped_blocker:Sprite;
      
      private var _shift_down:Boolean = false;
      
      private var borderOffset:Point;
      
      private var local_down:Point;
      
      private var _rotate_offset:Number;
      
      private var _selected:Boolean = false;
      
      public function ComicPanel(param1:Comic, param2:ComicStrip, param3:Object, param4:Boolean)
      {
         super();
         if(debug)
         {
            trace("--ComicPanel()--");
         }
         myComic = param1;
         myComicStrip = param2;
         bordered = param4;
         hilightable = true;
         text_content = new PanelContents(myComic,this,true);
         content = new PanelContents(myComic,this);
         outline = new Shape();
         border = new Sprite();
         panel_mask = new Shape();
         text_mask = new Shape();
         addChild(panel_mask);
         addChild(content);
         addChild(text_mask);
         addChild(text_content);
         addChild(outline);
         addChild(border);
         hilight = new Shape();
         if(bordered)
         {
            border.addEventListener(MouseEvent.MOUSE_DOWN,borderMoveStart,false,0,true);
            border.addEventListener(MouseEvent.MOUSE_OVER,border_over,false,0,true);
            border.addEventListener(MouseEvent.MOUSE_OUT,border_out,false,0,true);
         }
         content.addEventListener(Event.SELECT,select_panel,false,0,true);
         content.addEventListener(MouseEvent.MOUSE_DOWN,content_down,false,-1,true);
         popped_blocker = new Sprite();
         popped_blocker.doubleClickEnabled = true;
         popped_blocker.addEventListener(MouseEvent.DOUBLE_CLICK,pop_back_handler,false,0,true);
         popped_asset_container = new Sprite();
         popped_mask = new Sprite();
         this.load_state(param3);
      }
      
      private function select_panel(param1:Event) : void
      {
         if(_selected)
         {
            return;
         }
         this.selected = true;
         myComic.popped_asset = null;
      }
      
      public function getArea() : Sprite
      {
         return content;
      }
      
      public function border_over(param1:MouseEvent) : void
      {
         dispatchEvent(new CursorEvent("border_h",param1.buttonDown));
      }
      
      private function deselectLockedAsset(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,deselectLockedAsset);
         stage.removeEventListener(MouseEvent.MOUSE_UP,deselectLockedAsset_remove);
         myComic.selectAsset(null);
      }
      
      public function demote_text(param1:TextBubble) : void
      {
         trace("demote_text " + content.scaleX);
         if(content.contains(param1))
         {
            return;
         }
         translate_contents(param1,text_content,content);
         content.addAsset(param1,true);
         param1.asset_type = "text bubble";
      }
      
      public function pop_back() : void
      {
         if(myComic.popped_asset)
         {
            content.pop_back(myComic.popped_asset);
            if(this.contains(popped_blocker))
            {
               this.removeChild(popped_blocker);
            }
            if(this.contains(popped_asset_container))
            {
               this.removeChild(popped_asset_container);
            }
            myComic.popped_asset = null;
            dispatchEvent(new CursorEvent("visible",true));
         }
      }
      
      public function get strip() : ComicStrip
      {
         return this.myComicStrip;
      }
      
      public function borderMove(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("Border Move");
         }
         myComic.borderResizePanel(this,followingSprite,this,borderOffset);
         check_contents();
      }
      
      public function pop_back_handler(param1:MouseEvent) : void
      {
         pop_back();
      }
      
      private function content_up(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,content_move);
         stage.removeEventListener(MouseEvent.MOUSE_UP,content_up);
         dispatchEvent(new CursorEvent("reset"));
         drawBorder();
      }
      
      public function addTextAsset(param1:ComicAsset, param2:Boolean) : void
      {
         this.text_content.addAsset(param1,param2);
      }
      
      private function panel_over(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("panel over");
         }
         if(editable)
         {
            dispatchEvent(new CursorEvent("camera_" + move_mode,param1.buttonDown));
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         var _loc2_:ComicAsset = null;
         if(param1 == _selected)
         {
            return;
         }
         _selected = param1;
         if(_selected)
         {
            myComic.selectPanel(this);
            hilightColor = hilightColor_primary;
            if(myComic.getSelectedAsset())
            {
               _loc2_ = myComic.getSelectedAsset();
               if(content.contains(_loc2_))
               {
                  hilightColor = hilightColor_secondary;
               }
               else
               {
                  myComic.selectAsset(null);
               }
            }
            hilight.graphics.clear();
            hilight.graphics.lineStyle(8,hilightColor,1,false,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
            drawToSize(hilight);
            addChildAt(hilight,0);
            if(stage)
            {
               stage.addEventListener(KeyboardEvent.KEY_DOWN,check_key_down,false,0,true);
               stage.addEventListener(KeyboardEvent.KEY_UP,check_key_up,false,0,true);
            }
         }
         else
         {
            if(this.contains(hilight))
            {
               removeChild(hilight);
            }
            if(stage)
            {
               stage.removeEventListener(KeyboardEvent.KEY_DOWN,check_key_down);
               stage.removeEventListener(KeyboardEvent.KEY_UP,check_key_up);
            }
         }
      }
      
      public function pop_to_top(param1:ComicAsset) : void
      {
         if(myComic.popped_asset)
         {
            myComic.popped_asset = null;
         }
         param1 = content.pop_out(param1);
         if(param1)
         {
            myComic.popped_asset = param1;
            popped_blocker.graphics.clear();
            popped_blocker.graphics.beginFill(16777215,0.4);
            popped_blocker.graphics.drawRect(panel_mask.x,panel_mask.y,panel_mask.width,panel_mask.height);
            popped_mask.graphics.clear();
            popped_mask.graphics.beginFill(16777215,0.4);
            popped_mask.graphics.drawRect(panel_mask.x,panel_mask.y,panel_mask.width,panel_mask.height);
            popped_asset_container.x = content.x;
            popped_asset_container.y = content.y;
            popped_asset_container.scaleX = content.scaleX;
            popped_asset_container.scaleY = content.scaleY;
            popped_asset_container.rotation = content.rotation;
            popped_asset_container.mask = popped_mask;
            this.addChild(popped_blocker);
            this.addChild(popped_mask);
            popped_asset_container.addChild(myComic.popped_asset);
            this.addChild(popped_asset_container);
            popped_asset_container.mask = popped_mask;
            dispatchEvent(new CursorEvent("visible",false));
         }
      }
      
      public function borderMoveStart(param1:MouseEvent) : void
      {
         myComic.stop_editing_asset();
         borderOffset = new Point(border.mouseX,border.mouseY);
         if(myComic.getEditable())
         {
            myComic.pre_undo();
            if(debug)
            {
               trace("--ComicPanel.borderMoveStart()--");
            }
            stage.addEventListener(MouseEvent.MOUSE_UP,borderMoveStop,false,0,true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,borderMove,false,0,true);
            followingSprite = myComic.panelFollower(this);
         }
      }
      
      public function get scale() : Number
      {
         return content.scaleX;
      }
      
      public function promote_text(param1:TextBubble) : void
      {
         trace("promote_text");
         if(text_content.contains(param1))
         {
            return;
         }
         translate_contents(param1,content,text_content);
         text_content.addAsset(param1,true,true);
         param1.asset_type = "promoted text";
      }
      
      public function save_state() : Object
      {
         if(debug)
         {
            trace("--ComicPanel.save_state()--");
         }
         var _loc1_:Object = Utils.clone(panelData);
         _loc1_["contents"] = content.save_state();
         _loc1_["text_contents"] = text_content.save_state();
         _loc1_["content_x"] = this.content.x;
         _loc1_["content_y"] = this.content.y;
         _loc1_["content_scale"] = this.content.scaleX;
         _loc1_["content_rotation"] = this.content.rotation;
         _loc1_["children_filter"] = _children_filter;
         if(debug)
         {
            trace("SAVING");
            trace("backdrop: " + _loc1_["backdrop"]);
            trace("ground: " + _loc1_["ground"]);
            trace("--------");
         }
         return _loc1_;
      }
      
      public function get move_mode() : uint
      {
         return myComic.move_mode;
      }
      
      public function panelBitmap(param1:Number = 3, param2:Boolean = true) : BitmapData
      {
         spelling(false);
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
         spelling(true);
         this.border.visible = true;
         return _loc5_;
      }
      
      public function absorbScene(param1:Object) : void
      {
         if(debug)
         {
            trace("--ComicPanel.absorbScene()--");
         }
         load_state(DataDump.panelAbsorbScene(save_state(),param1));
      }
      
      public function getStrip() : ComicStrip
      {
         return myComicStrip;
      }
      
      public function getAssetByName(param1:String) : ComicAsset
      {
         var _loc2_:ComicAsset = content.getAssetByName(param1);
         if(_loc2_ == null)
         {
            _loc2_ = text_content.getAssetByName(param1);
         }
         return _loc2_;
      }
      
      public function pop_control() : void
      {
         if(myComic.popped_asset)
         {
            dispatchEvent(new CursorEvent("visible",!myComic.popped_asset.editing));
         }
      }
      
      public function set children_filter(param1:Boolean) : void
      {
         if(param1 != _children_filter)
         {
            _children_filter = param1;
            content.set_filters(content.get_filters());
         }
      }
      
      private function check_contents() : void
      {
         var _loc1_:Number = content.scaleX;
         var _loc2_:Number = _loc1_;
         if(debug)
         {
            trace("Current Width & Height: " + panel_mask.width + ", " + panel_mask.height + " Current Scale: " + _loc1_);
         }
         if(panel_mask.width > 1300 * _loc1_)
         {
            this.scale = panel_mask.width / 1300;
            if(debug)
            {
               trace("Panel too wide to fit!");
            }
            _loc1_ = content.scaleX;
         }
         if(panel_mask.height > 1300 * _loc1_)
         {
            this.scale = panel_mask.height / 1300;
            _loc1_ = content.scaleX;
            if(debug)
            {
               trace("Panel too tall to fit!");
            }
         }
         if(debug)
         {
            trace("Content: " + content.x + "," + content.y);
         }
         content.x = Math.min(650 * _loc1_,content.x);
         content.y = Math.min(650 * _loc1_,content.y);
         if(debug)
         {
            trace("Max X: " + (-650 * _loc1_ + panel_mask.width));
         }
         content.x = Math.max(-650 * _loc1_ + panel_mask.width,content.x);
         content.y = Math.max(-650 * _loc1_ + panel_mask.height,content.y);
      }
      
      public function killHilight() : void
      {
         hilightable = false;
      }
      
      private function deselectLockedAsset_remove(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,deselectLockedAsset);
         stage.removeEventListener(MouseEvent.MOUSE_UP,deselectLockedAsset_remove);
      }
      
      function drawToSize(param1:Shape) : void
      {
         if(panelData.width && panelData.height)
         {
            param1.graphics.drawRect(0,0,panelData.width,panelData.height);
         }
      }
      
      private function update_content_width() : void
      {
         this.content.panel_width = panel_width / content.scaleX;
         this.text_content.panel_width = panel_width / text_content.scaleX - 5;
      }
      
      public function set panel_height(param1:Number) : void
      {
         param1 = Math.max(Math.min(param1,Comic.PANEL_HEIGHT_MAX),Comic.PANEL_HEIGHT_MIN);
         var _loc2_:Number = param1 - panelData.height;
         trace("Set panel height: " + param1);
         if(_loc2_)
         {
            panelData.height = param1;
            content.y = content.y + _loc2_ / 2;
            drawMe();
         }
         text_content.y = this.panel_height / 2;
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
         border.graphics.clear();
         border.graphics.beginFill(65535,0);
         border.graphics.drawRect(0,0,ComicPanel.borderSize,panelData.height);
         border.graphics.endFill();
         if(param1)
         {
            _loc2_ = panel_mask.width / (this.scale * 1300);
            _loc3_ = content.x - (-650 * content.scaleX + panel_mask.width);
            _loc4_ = 650 * content.scaleX - (-650 * content.scaleX + panel_mask.width);
            _loc5_ = 1 - _loc3_ / _loc4_;
            if(_loc4_ == 0)
            {
               _loc5_ = 1;
            }
            _loc6_ = panelData.width * _loc2_;
            _loc7_ = _loc5_ * (panelData.width - _loc6_);
            border.graphics.lineStyle(5,0,0.8);
            border.graphics.moveTo(ComicPanel.borderSize + 10 + _loc7_,panelData.height - 8);
            border.graphics.lineTo(_loc6_ + ComicPanel.borderSize - 10 + _loc7_,panelData.height - 8);
            _loc2_ = panel_mask.height / (this.scale * 1300);
            _loc3_ = content.y - (-650 * content.scaleX + panel_mask.height);
            _loc4_ = 650 * content.scaleX - (-650 * content.scaleX + panel_mask.height);
            _loc5_ = 1 - _loc3_ / _loc4_;
            if(_loc4_ == 0)
            {
               _loc5_ = 1;
            }
            _loc8_ = panelData.height * _loc2_;
            _loc9_ = _loc5_ * (panelData.height - _loc8_);
            border.graphics.moveTo(panelData.width - 0,ComicPanel.borderSize + _loc9_);
            border.graphics.lineTo(panelData.width - 0,_loc8_ + ComicPanel.borderSize - 15 + _loc9_);
         }
      }
      
      private function panel_out(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("panel out");
         }
         if(editable)
         {
            dispatchEvent(new CursorEvent("strip",param1.buttonDown));
         }
      }
      
      public function set scale(param1:Number) : void
      {
         content.scaleX = content.scaleY = param1;
      }
      
      private function update_move_points() : void
      {
         if(stage == null)
         {
            trace("When am I null?");
            return;
         }
         stage_down = new Point(stage.mouseX,stage.mouseY);
         local_down = this.globalToLocal(stage_down);
         _rotate_offset = Utils.get_degrees_from_points(local_down,new Point(content.x,content.y)) - 90 - content.rotation;
         _content_down = this.globalToLocal(new Point(stage.mouseX,stage.mouseY));
         _content_down.x = _content_down.x - content.x;
         _content_down.y = _content_down.y - content.y;
         if(myComic && myComic.selectedAsset)
         {
            myComic.selectedAsset.update_move_points();
         }
      }
      
      public function set panel_width(param1:int) : void
      {
         param1 = Math.max(Math.min(param1,Comic.WIDTH_MAX),Comic.PANEL_WIDTH_MIN);
         var _loc2_:int = param1 - panelData.width;
         if(_loc2_)
         {
            panelData.width = param1;
            content.x = content.x + _loc2_ / 2;
            drawMe();
            this.update_content_width();
         }
         text_content.x = param1 / 2;
      }
      
      public function set_editable(param1:Boolean) : void
      {
         if(debug)
         {
            trace("--ComicPanel.set_editable(" + param1 + ")--");
         }
         editable = param1;
      }
      
      public function getComic() : Comic
      {
         return myComic;
      }
      
      public function get selected() : Boolean
      {
         return _selected;
      }
      
      private function content_down(param1:MouseEvent) : void
      {
         if(param1.eventPhase == 2)
         {
            myComic.selectAsset(null);
         }
         if(locked == true)
         {
            return;
         }
         if(myComic.selectedAsset && myComic.selectedAsset.editing)
         {
            return;
         }
         this.myComic.pre_undo();
         update_move_points();
         stage.addEventListener(MouseEvent.MOUSE_MOVE,content_move,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,content_up,false,0,true);
         if(_selected)
         {
            return;
         }
         this.selected = true;
         myComic.popped_asset = null;
      }
      
      public function remove() : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,borderMoveStop);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,borderMove);
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,check_key_down);
         stage.removeEventListener(KeyboardEvent.KEY_UP,check_key_up);
         border.removeEventListener(MouseEvent.MOUSE_DOWN,borderMoveStart);
         border.removeEventListener(MouseEvent.MOUSE_OVER,border_over);
         border.removeEventListener(MouseEvent.MOUSE_OUT,border_out);
         content.removeEventListener(Event.SELECT,select_panel);
         content.removeEventListener(MouseEvent.MOUSE_DOWN,content_down);
         popped_blocker.removeEventListener(MouseEvent.DOUBLE_CLICK,pop_back_handler);
      }
      
      public function check_key_up(param1:KeyboardEvent) : void
      {
         if(param1.charCode == 0 && toggling_camera)
         {
            if(param1.shiftKey != _shift_down || param1.ctrlKey != _ctrl_down)
            {
               _shift_down = param1.shiftKey;
               _ctrl_down = param1.ctrlKey;
               update_move_points();
               toggling_camera = false;
               untoggleCamera();
               if(stage && myComic.selectedAsset && myComic.selectedAsset.hitTestPoint(stage.mouseX,stage.mouseY))
               {
                  myComic.selectedAsset.update_cursor();
               }
            }
         }
      }
      
      public function clearPanel() : void
      {
         content.clearPanel();
         text_content.clearPanel();
      }
      
      public function get children_filter() : Boolean
      {
         return _children_filter;
      }
      
      private function untoggleCamera() : void
      {
         if(stage && this.panel_mask.hitTestPoint(stage.mouseX,stage.mouseY))
         {
            dispatchEvent(new CursorEvent("camera_" + old_mode));
         }
         var _loc1_:ComicControl = myComic.getComicBuilder().getComic_controls();
         if(_loc1_ == null)
         {
            return;
         }
         _loc1_.move_mode = old_mode;
      }
      
      public function spelling(param1:Boolean) : void
      {
         content.spelling(param1);
         text_content.spelling(param1);
      }
      
      public function border_out(param1:MouseEvent) : void
      {
         dispatchEvent(new CursorEvent("strip",param1.buttonDown));
      }
      
      public function get panel_height() : Number
      {
         return panelData.height;
      }
      
      public function borderMoveStop(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("--ComicPanel.borderMoveStop()--");
         }
         stage.removeEventListener(MouseEvent.MOUSE_UP,borderMoveStop);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,borderMove);
         if(border.hitTestPoint(param1.stageX,param1.stageY) == false)
         {
            dispatchEvent(new CursorEvent("reset"));
         }
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
         param1.remove();
         param1 = null;
      }
      
      public function addAsset(param1:ComicAsset, param2:Boolean) : void
      {
         this.content.addAsset(param1,param2);
      }
      
      public function get panel_width() : int
      {
         return panelData.width;
      }
      
      private function toggleDepth() : void
      {
         var _loc1_:ComicControl = myComic.getComicBuilder().getComic_controls();
         if(_loc1_ == null)
         {
            return;
         }
         if(debug)
         {
            trace("toggleDepth");
         }
         old_mode = move_mode;
         if(move_mode == 1)
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
      
      private function content_move(param1:MouseEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Point = new Point(stage.mouseX,stage.mouseY);
         if(move_mode == 0)
         {
            _loc2_ = this.globalToLocal(_loc2_);
            content.x = _loc2_.x - _content_down.x;
            content.y = _loc2_.y - _content_down.y;
         }
         else if(move_mode == 1)
         {
            _loc3_ = content.scaleX;
            _loc3_ = _loc3_ - (stage_down.y - stage.mouseY) / 100;
            _loc3_ = Math.min(Math.max(_loc3_,0.25),10);
            content.scaleX = content.scaleY = _loc3_;
            stage_down = new Point(stage.mouseX,stage.mouseY);
         }
         else if(move_mode == 2)
         {
            _loc2_ = this.globalToLocal(_loc2_);
            content.rotation = Utils.get_degrees_from_points(new Point(content.x,content.y),_loc2_) + 90 - _rotate_offset;
         }
         check_contents();
         drawBorder(true);
      }
      
      public function check_key_down(param1:KeyboardEvent) : void
      {
         if(param1.charCode == 0 && !toggling_camera && (param1.shiftKey || param1.ctrlKey))
         {
            update_move_points();
            toggling_camera = true;
            if(param1.shiftKey)
            {
               toggleDepth();
               _shift_down = true;
            }
            else if(param1.ctrlKey)
            {
               toggleAngle();
               _ctrl_down = true;
            }
            if(stage && myComic.selectedAsset && myComic.selectedAsset.hitTestPoint(stage.mouseX,stage.mouseY))
            {
               myComic.selectedAsset.update_cursor();
            }
         }
      }
      
      private function toggleAngle() : void
      {
         if(debug)
         {
            trace("toggleAngle");
         }
         var _loc1_:ComicControl = myComic.getComicBuilder().getComic_controls();
         if(_loc1_ == null)
         {
            return;
         }
         old_mode = move_mode;
         if(move_mode == 2)
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
      
      public function get panel_contents() : PanelContents
      {
         return content;
      }
      
      public function drawMe() : void
      {
         check_contents();
         outline.graphics.clear();
         outline.graphics.lineStyle(2,0,1,false,"normal",CapsStyle.SQUARE);
         drawToSize(outline);
         hilight.graphics.clear();
         hilight.graphics.lineStyle(8,hilightColor,1,false,LineScaleMode.NONE,CapsStyle.SQUARE,JointStyle.MITER);
         drawToSize(hilight);
         border.x = -ComicPanel.borderSize;
         drawBorder();
         panel_mask.graphics.clear();
         panel_mask.graphics.beginFill(16711884,0.5);
         panel_mask.graphics.drawRect(0,0,panelData.width,panelData.height);
         text_mask.graphics.clear();
         text_mask.graphics.beginFill(16711884,0.5);
         text_mask.graphics.drawRect(0,0,panelData.width,panelData.height);
         content.mask = panel_mask;
         text_content.mask = text_mask;
      }
      
      public function load_state(param1:Object) : void
      {
         if(debug)
         {
            trace("--ComicPanel.load_state(" + param1 + ")--");
            trace("state[\'contentList\'].length: " + param1["contentList"].length);
            trace("backdrop: " + param1["backdrop"]);
         }
         clearPanel();
         content.clearPanel();
         text_content.clearPanel();
         if(param1["width"] == null)
         {
            param1["width"] = panelData["width"];
         }
         panelData = Utils.clone(param1);
         if(this.myComicStrip)
         {
            panelData["height"] = myComicStrip.strip_height;
         }
         if(panelData.hasOwnProperty("height") == false || panelData["height"] == null || panelData["height"] == 0)
         {
            trace("Uh-oh, no height!");
         }
         if(panelData["content_x"])
         {
            content.x = panelData["content_x"];
            content.y = panelData["content_y"];
            content.rotation = panelData["content_rotation"];
         }
         else
         {
            content.x = this.panel_width / 2;
            content.y = this.panel_height / 2;
         }
         text_content.x = this.panel_width / 2;
         text_content.y = this.panel_height / 2;
         if(panelData["content_scale"])
         {
            content.scaleX = content.scaleY = panelData["content_scale"];
         }
         if(panelData["contents"])
         {
            content.load_state(panelData["contents"]);
         }
         if(panelData["text_contents"])
         {
            text_content.load_state(panelData["text_contents"]);
         }
         this.update_content_width();
         drawMe();
         content.addEventListener(MouseEvent.MOUSE_OVER,panel_over,false,0,true);
         content.addEventListener(MouseEvent.ROLL_OUT,panel_out,false,0,true);
         this.blank = false;
      }
   }
}
