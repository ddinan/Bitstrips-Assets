package com.bitstrips.ui
{
   import com.bitstrips.BSConstants;
   import com.bitstrips.Utils;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   
   public class TreeNode extends EventDispatcher
   {
       
      
      public var _id:String;
      
      public var _label:String = "empty";
      
      private var label_txt:TextField;
      
      public var depth:uint = 0;
      
      public var _branch:Array;
      
      public var shown:Boolean = false;
      
      public var _parent:TreeNode;
      
      public var indent:Number;
      
      private var _width:Number;
      
      private var _height:Number = 17;
      
      public var display:Sprite;
      
      private var bkgr:Sprite;
      
      private var hilight:Sprite;
      
      private var selection:Sprite;
      
      private var _exploded:Boolean = false;
      
      private var icon:MovieClip;
      
      private var icon_holder:Sprite;
      
      public var checkbox:Boolean = false;
      
      private var checked:Boolean = false;
      
      private var _selected:Boolean = false;
      
      private var loading_timer:Timer;
      
      private var _extraDisplay:DisplayObject;
      
      public function TreeNode(param1:Number, param2:Number)
      {
         this._branch = new Array();
         this._extraDisplay = new Sprite();
         this._width = param1;
         this.indent = param2;
         super();
         this.label_txt = new TextField();
         this.label_txt.width = this._width;
         this.label_txt.height = this.height;
         this.label_txt.multiline = false;
         this.label_txt.selectable = false;
         this.label_txt.mouseEnabled = false;
         this.label_txt.autoSize = TextFieldAutoSize.LEFT;
         BSConstants.tf_fix(this.label_txt,10);
         this.bkgr = new Sprite();
         this.bkgr.graphics.beginFill(16777215,0);
         this.bkgr.graphics.drawRect(0,0,this.width,this.height);
         this.hilight = new Sprite();
         this.hilight.graphics.beginFill(14346492,1);
         this.hilight.graphics.drawRect(0,0,this.width,this.height);
         this.hilight.visible = false;
         this.selection = new Sprite();
         this.selection.graphics.beginFill(11652338,1);
         this.selection.graphics.drawRect(0,0,this.width,this.height);
         this.selection.visible = false;
         this.icon_holder = new Sprite();
         this.display = new Sprite();
         this.display.addChild(this.bkgr);
         this.display.addChild(this.hilight);
         this.display.addChild(this.selection);
         this.display.addChild(this.icon_holder);
         this.display.addChild(this.label_txt);
         this.display.addEventListener(MouseEvent.MOUSE_OVER,this.mouse_over);
         this.display.addEventListener(MouseEvent.MOUSE_OUT,this.mouse_out);
         this.display.addEventListener(MouseEvent.CLICK,this.click,false,1,true);
         this.display.addEventListener(Event.ADDED_TO_STAGE,this.display_added);
         this.icon_holder.addEventListener(MouseEvent.CLICK,this.icon_click);
         this.display.buttonMode = true;
      }
      
      private function display_added(param1:Event) : void
      {
         Utils.doubleclickable(this.display);
         this.display.doubleClickEnabled = true;
         this.display.addEventListener(MouseEvent.DOUBLE_CLICK,this.dbl_click,false,2,true);
      }
      
      private function redraw() : void
      {
         this.hilight.graphics.clear();
         this.hilight.graphics.beginFill(14346492,1);
         this.hilight.graphics.drawRect(0,0,this.width,this.height);
         this.selection.graphics.clear();
         this.selection.graphics.beginFill(11652338,1);
         this.selection.graphics.drawRect(0,0,this.width,this.height);
         this.bkgr.graphics.clear();
         this.bkgr.graphics.beginFill(16777215,0);
         this.bkgr.graphics.drawRect(0,0,this.width,this.height);
         this.label_txt.width = this.width;
         this.label_txt.height = this.height;
      }
      
      private function mouse_over(param1:MouseEvent) : void
      {
         this.hilight.visible = true;
      }
      
      private function mouse_out(param1:MouseEvent) : void
      {
         this.hilight.visible = false;
      }
      
      private function click(param1:MouseEvent) : void
      {
         if(this.checkbox)
         {
            this.check(!this.checked);
         }
         else
         {
            this.selected = true;
         }
      }
      
      private function dbl_click(param1:MouseEvent) : void
      {
         if(this.branch.length > 0)
         {
            if(this.exploded)
            {
               this.close();
            }
            else
            {
               this.open();
            }
         }
         else
         {
            this.click(param1);
         }
      }
      
      private function icon_click(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         this.dbl_click(param1);
      }
      
      public function select(param1:Boolean) : void
      {
         this.selected = param1;
      }
      
      public function check(param1:Boolean) : void
      {
         this.checked = param1;
         if(this.checked)
         {
            dispatchEvent(new Event("checked"));
            this.icon.gotoAndStop(2);
         }
         else
         {
            dispatchEvent(new Event("unchecked"));
            this.icon.gotoAndStop(1);
         }
      }
      
      public function open() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.branch.length)
         {
            (this.branch[_loc1_] as TreeNode).shown = true;
            _loc1_++;
         }
         this.exploded = true;
         dispatchEvent(new Event("redraw"));
      }
      
      public function close() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.branch.length)
         {
            (this.branch[_loc1_] as TreeNode).shown = false;
            _loc1_++;
         }
         this.exploded = false;
         dispatchEvent(new Event("redraw"));
      }
      
      public function set parent(param1:TreeNode) : void
      {
         this._parent = param1;
         this.depth = this._parent.depth + 1;
         this.icon_holder.x = (this.depth - 1) * this.indent;
         this.label_txt.x = 15 + (this.depth - 1) * this.indent;
      }
      
      public function set branch(param1:Array) : void
      {
         this._branch = param1;
         if(this.icon)
         {
            if(this.icon_holder.contains(this.icon))
            {
               this.icon_holder.removeChild(this.icon);
            }
         }
         if(this.checkbox)
         {
            this.icon = new icon_checkbox();
            if(this.checked)
            {
               this.icon.gotoAndStop(2);
            }
            else
            {
               this.icon.gotoAndStop(1);
            }
         }
         else if(this.branch.length > 0)
         {
            this.icon = new icon_branch();
            if(this.exploded)
            {
               this.icon.gotoAndStop(2);
            }
            else
            {
               this.icon.gotoAndStop(1);
            }
         }
         else
         {
            this.icon = new icon_leaf();
         }
         this.icon_holder.addChild(this.icon);
      }
      
      public function get branch() : Array
      {
         return this._branch;
      }
      
      public function set exploded(param1:Boolean) : void
      {
         this._exploded = param1;
         if(!this.checkbox)
         {
            if(this.exploded)
            {
               this.icon.gotoAndStop(2);
            }
            else
            {
               this.icon.gotoAndStop(1);
            }
         }
      }
      
      public function get exploded() : Boolean
      {
         return this._exploded;
      }
      
      public function set width(param1:Number) : void
      {
         this._width = param1;
         this.redraw();
      }
      
      public function get width() : Number
      {
         return this._width;
      }
      
      public function set height(param1:Number) : void
      {
         this._height = param1;
         this.redraw();
      }
      
      public function get height() : Number
      {
         var _loc1_:Number = this._height;
         if(this._selected)
         {
            _loc1_ = _loc1_ + this._extraDisplay.height;
         }
         return _loc1_;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         this.selection.visible = this._selected;
         this._extraDisplay.visible = this._selected;
         dispatchEvent(new Event("redraw"));
         if(this._selected)
         {
            dispatchEvent(new Event("selected"));
         }
         else
         {
            dispatchEvent(new Event("deselected"));
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set label(param1:String) : void
      {
         this._label = param1;
         if(this.id != "loading")
         {
            this.label_txt.text = this._label;
         }
      }
      
      public function set id(param1:String) : void
      {
         this._id = param1;
         if(this.id == "loading")
         {
            this.label_txt.text = "Loading libraries";
            this.loading_timer = new Timer(500,0);
            this.loading_timer.addEventListener(TimerEvent.TIMER,this.l_time);
            this.loading_timer.start();
         }
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function set extraDisplay(param1:DisplayObject) : void
      {
         if(this.display.contains(this._extraDisplay))
         {
            this.display.removeChild(this._extraDisplay);
         }
         if(param1.parent != null)
         {
            param1.parent.removeChild(param1);
         }
         this._extraDisplay = param1;
         var _loc2_:Rectangle = param1.getBounds(this.display);
         this._extraDisplay.y = this._extraDisplay.y - _loc2_.y;
         this._extraDisplay.y = this._extraDisplay.y + this._height;
         this.display.addChild(this._extraDisplay);
         this._extraDisplay.visible = this._selected;
      }
      
      private function l_time(param1:TimerEvent) : void
      {
         switch(this.label_txt.text)
         {
            case "Loading libraries":
               this.label_txt.text = "Loading libraries.";
               break;
            case "Loading libraries.":
               this.label_txt.text = "Loading libraries..";
               break;
            case "Loading libraries..":
               this.label_txt.text = "Loading libraries...";
               break;
            case "Loading libraries...":
               this.label_txt.text = "Loading libraries";
         }
      }
   }
}
