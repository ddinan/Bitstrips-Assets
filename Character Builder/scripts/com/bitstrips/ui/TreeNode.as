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
       
      
      private var bkgr:Sprite;
      
      private var _exploded:Boolean = false;
      
      public var shown:Boolean = false;
      
      private var selection:Sprite;
      
      private var loading_timer:Timer;
      
      private var label_txt:TextField;
      
      private var checked:Boolean = false;
      
      public var indent:Number;
      
      private var icon_holder:Sprite;
      
      private var hilight:Sprite;
      
      public var _id:String;
      
      public var _branch:Array;
      
      public var display:Sprite;
      
      public var depth:uint = 0;
      
      private var _height:Number = 17;
      
      private var _width:Number;
      
      public var _parent:TreeNode;
      
      public var checkbox:Boolean = false;
      
      public var _label:String = "empty";
      
      private var _extraDisplay:DisplayObject;
      
      private var icon:MovieClip;
      
      private var _selected:Boolean = false;
      
      public function TreeNode(param1:Number, param2:Number)
      {
         _branch = new Array();
         _extraDisplay = new Sprite();
         _width = param1;
         indent = param2;
         super();
         label_txt = new TextField();
         label_txt.width = _width;
         label_txt.height = height;
         label_txt.multiline = false;
         label_txt.selectable = false;
         label_txt.mouseEnabled = false;
         label_txt.autoSize = TextFieldAutoSize.LEFT;
         BSConstants.tf_fix(label_txt,10);
         bkgr = new Sprite();
         bkgr.graphics.beginFill(16777215,0);
         bkgr.graphics.drawRect(0,0,width,height);
         hilight = new Sprite();
         hilight.graphics.beginFill(14346492,1);
         hilight.graphics.drawRect(0,0,width,height);
         hilight.visible = false;
         selection = new Sprite();
         selection.graphics.beginFill(11652338,1);
         selection.graphics.drawRect(0,0,width,height);
         selection.visible = false;
         icon_holder = new Sprite();
         display = new Sprite();
         display.addChild(bkgr);
         display.addChild(hilight);
         display.addChild(selection);
         display.addChild(icon_holder);
         display.addChild(label_txt);
         display.addEventListener(MouseEvent.MOUSE_OVER,mouse_over);
         display.addEventListener(MouseEvent.MOUSE_OUT,mouse_out);
         display.addEventListener(MouseEvent.CLICK,click,false,1,true);
         display.addEventListener(Event.ADDED_TO_STAGE,display_added);
         icon_holder.addEventListener(MouseEvent.CLICK,icon_click);
         display.buttonMode = true;
      }
      
      private function click(param1:MouseEvent) : void
      {
         if(checkbox)
         {
            check(!checked);
         }
         else
         {
            selected = true;
         }
      }
      
      public function check(param1:Boolean) : void
      {
         checked = param1;
         if(checked)
         {
            dispatchEvent(new Event("checked"));
            icon.gotoAndStop(2);
         }
         else
         {
            dispatchEvent(new Event("unchecked"));
            icon.gotoAndStop(1);
         }
      }
      
      public function set width(param1:Number) : void
      {
         _width = param1;
         redraw();
      }
      
      public function get exploded() : Boolean
      {
         return _exploded;
      }
      
      public function set extraDisplay(param1:DisplayObject) : void
      {
         if(display.contains(_extraDisplay))
         {
            display.removeChild(_extraDisplay);
         }
         if(param1.parent != null)
         {
            param1.parent.removeChild(param1);
         }
         _extraDisplay = param1;
         var _loc2_:Rectangle = param1.getBounds(display);
         _extraDisplay.y = _extraDisplay.y - _loc2_.y;
         _extraDisplay.y = _extraDisplay.y + _height;
         display.addChild(_extraDisplay);
         _extraDisplay.visible = _selected;
      }
      
      public function get branch() : Array
      {
         return _branch;
      }
      
      public function get selected() : Boolean
      {
         return _selected;
      }
      
      private function mouse_over(param1:MouseEvent) : void
      {
         hilight.visible = true;
      }
      
      private function mouse_out(param1:MouseEvent) : void
      {
         hilight.visible = false;
      }
      
      public function get height() : Number
      {
         var _loc1_:Number = _height;
         if(_selected)
         {
            _loc1_ = _loc1_ + _extraDisplay.height;
         }
         return _loc1_;
      }
      
      private function dbl_click(param1:MouseEvent) : void
      {
         if(branch.length > 0)
         {
            if(exploded)
            {
               close();
            }
            else
            {
               open();
            }
         }
         else
         {
            click(param1);
         }
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(_selected == param1)
         {
            return;
         }
         _selected = param1;
         selection.visible = _selected;
         _extraDisplay.visible = _selected;
         dispatchEvent(new Event("redraw"));
         if(_selected)
         {
            dispatchEvent(new Event("selected"));
         }
         else
         {
            dispatchEvent(new Event("deselected"));
         }
      }
      
      private function l_time(param1:TimerEvent) : void
      {
         switch(label_txt.text)
         {
            case "Loading libraries":
               label_txt.text = "Loading libraries.";
               break;
            case "Loading libraries.":
               label_txt.text = "Loading libraries..";
               break;
            case "Loading libraries..":
               label_txt.text = "Loading libraries...";
               break;
            case "Loading libraries...":
               label_txt.text = "Loading libraries";
         }
      }
      
      public function set branch(param1:Array) : void
      {
         _branch = param1;
         if(icon)
         {
            if(icon_holder.contains(icon))
            {
               icon_holder.removeChild(icon);
            }
         }
         if(checkbox)
         {
            icon = new icon_checkbox();
            if(checked)
            {
               icon.gotoAndStop(2);
            }
            else
            {
               icon.gotoAndStop(1);
            }
         }
         else if(branch.length > 0)
         {
            icon = new icon_branch();
            if(exploded)
            {
               icon.gotoAndStop(2);
            }
            else
            {
               icon.gotoAndStop(1);
            }
         }
         else
         {
            icon = new icon_leaf();
         }
         icon_holder.addChild(icon);
      }
      
      public function set id(param1:String) : void
      {
         _id = param1;
         if(id == "loading")
         {
            label_txt.text = "Loading libraries";
            loading_timer = new Timer(500,0);
            loading_timer.addEventListener(TimerEvent.TIMER,l_time);
            loading_timer.start();
         }
      }
      
      public function get id() : String
      {
         return _id;
      }
      
      public function set exploded(param1:Boolean) : void
      {
         _exploded = param1;
         if(!checkbox)
         {
            if(exploded)
            {
               icon.gotoAndStop(2);
            }
            else
            {
               icon.gotoAndStop(1);
            }
         }
      }
      
      private function icon_click(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         dbl_click(param1);
      }
      
      public function set parent(param1:TreeNode) : void
      {
         _parent = param1;
         depth = _parent.depth + 1;
         icon_holder.x = (depth - 1) * indent;
         label_txt.x = 15 + (depth - 1) * indent;
      }
      
      public function get width() : Number
      {
         return _width;
      }
      
      public function open() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < branch.length)
         {
            (branch[_loc1_] as TreeNode).shown = true;
            _loc1_++;
         }
         exploded = true;
         dispatchEvent(new Event("redraw"));
      }
      
      private function display_added(param1:Event) : void
      {
         Utils.doubleclickable(display);
         display.doubleClickEnabled = true;
         display.addEventListener(MouseEvent.DOUBLE_CLICK,dbl_click,false,2,true);
      }
      
      public function set height(param1:Number) : void
      {
         _height = param1;
         redraw();
      }
      
      public function set label(param1:String) : void
      {
         _label = param1;
         if(id != "loading")
         {
            label_txt.text = _label;
         }
      }
      
      private function redraw() : void
      {
         hilight.graphics.clear();
         hilight.graphics.beginFill(14346492,1);
         hilight.graphics.drawRect(0,0,width,height);
         selection.graphics.clear();
         selection.graphics.beginFill(11652338,1);
         selection.graphics.drawRect(0,0,width,height);
         bkgr.graphics.clear();
         bkgr.graphics.beginFill(16777215,0);
         bkgr.graphics.drawRect(0,0,width,height);
         label_txt.width = width;
         label_txt.height = height;
      }
      
      public function select(param1:Boolean) : void
      {
         selected = param1;
      }
      
      public function close() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < branch.length)
         {
            (branch[_loc1_] as TreeNode).shown = false;
            _loc1_++;
         }
         exploded = false;
         dispatchEvent(new Event("redraw"));
      }
   }
}
