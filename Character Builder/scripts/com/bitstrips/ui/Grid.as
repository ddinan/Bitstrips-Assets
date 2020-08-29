package com.bitstrips.ui
{
   import com.bitstrips.Utils;
   import com.bitstrips.core.ColourData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class Grid extends Sprite
   {
       
      
      private var enabled_cover:Sprite;
      
      private var _buttons:Array;
      
      private var _scale_up:Boolean = false;
      
      private var debug:Boolean = false;
      
      private var ui:GridPagerUI;
      
      private var _button_height:Number;
      
      private var _button_width:Number;
      
      private var _padding_width:Number;
      
      private var _columns:uint = 3;
      
      private var _page:uint = 0;
      
      private var _padding_height:Number;
      
      private var _pager_visible:Boolean = false;
      
      private var _rows:uint = 5;
      
      private var _contents:Array;
      
      private var _selected:int = -1;
      
      private var _page_count:uint = 0;
      
      public function Grid(param1:uint = 300, param2:uint = 300, param3:uint = 3, param4:uint = 4, param5:uint = 10, param6:uint = 10)
      {
         var grid_width:uint = param1;
         var grid_height:uint = param2;
         var rows:uint = param3;
         var cols:uint = param4;
         var w_padding:uint = param5;
         var h_padding:uint = param6;
         _buttons = [];
         _contents = [];
         super();
         ui = new GridPagerUI();
         ui.type_lbl.text = "";
         ui.page_lbl.text = "";
         ui.page_left.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            page_change(-1);
         });
         ui.page_right.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            page_change(1);
         });
         _padding_width = w_padding;
         _padding_height = h_padding;
         _rows = rows;
         _columns = cols;
         set_size(grid_width,grid_height,_rows,_columns);
         addChild(ui);
         draw_box();
      }
      
      public function set_size(param1:uint, param2:uint, param3:uint, param4:uint) : void
      {
         _rows = param3;
         _columns = param4;
         _button_width = (param1 - (_columns + 1) * _padding_width) / _columns;
         _button_height = (param2 - (_rows + 1) * _padding_height - ui.height) / _rows;
         position_buttons();
         draw_box();
         ui.y = _rows * (_button_height + _padding_height) + _padding_height;
         ui.x = 5;
      }
      
      public function set pager(param1:Boolean) : void
      {
         ui.visible = param1;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(param1 == false)
         {
            enabled_cover = new Sprite();
            _loc2_ = _padding_width + _columns * (_button_width + _padding_width);
            _loc3_ = _padding_height + _rows * (_button_height + _padding_height) + ui.height;
            enabled_cover.graphics.lineStyle(2);
            enabled_cover.graphics.beginFill(15658734,0.5);
            enabled_cover.graphics.drawRect(0,0,_loc2_,_loc3_);
            addChild(enabled_cover);
         }
         else if(enabled_cover)
         {
            removeChild(enabled_cover);
            enabled_cover = null;
         }
      }
      
      private function button_click(param1:MouseEvent) : void
      {
         var _loc2_:uint = parseInt(param1.currentTarget.name);
         var _loc3_:uint = 0;
         while(_loc3_ < _buttons.length)
         {
            _buttons[_loc3_].selected = false;
            _buttons[_loc3_].filters = [];
            _loc3_++;
         }
         _buttons[_loc2_].selected = true;
         _buttons[_loc2_].filters = [Utils.selected_filter];
         _selected = _loc2_;
         dispatchEvent(new Event(Event.SELECT));
      }
      
      public function colour_buttons(param1:ColourData) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < _buttons.length)
         {
            _loc3_ = 0;
            while(_loc3_ < _buttons[_loc2_].numChildren)
            {
               param1.colour_clip(_buttons[_loc2_].getChildAt(_loc3_));
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      private function draw_box() : void
      {
         this.graphics.clear();
         var _loc1_:uint = _padding_width + _columns * (_button_width + _padding_width);
         var _loc2_:uint = _padding_height + _rows * (_button_height + _padding_height) + ui.height;
         this.graphics.lineStyle(2);
         this.graphics.beginFill(16777215);
         this.graphics.drawRect(0,0,_loc1_,_loc2_);
      }
      
      public function get selected() : int
      {
         if(_selected == -1)
         {
            return _selected;
         }
         return _selected + _page * (_columns * _rows);
      }
      
      private function page_change(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc4_:DisplayObject = null;
         _page = Math.max(0,Math.min(_page_count,_page + param1));
         Utils.enable_shade_btn(ui.page_left);
         Utils.enable_shade_btn(ui.page_right);
         if(_page == 0)
         {
            Utils.disable_shade_btn(ui.page_left);
         }
         if(_page + 1 >= _page_count)
         {
            Utils.disable_shade_btn(ui.page_right);
         }
         ui.page_lbl.text = _page + 1 + "/" + _page_count;
         _loc2_ = 0;
         while(_loc2_ < _buttons.length)
         {
            _buttons[_loc2_].visible = false;
            while(_buttons[_loc2_].numChildren != 0)
            {
               _buttons[_loc2_].removeChildAt(0);
            }
            _buttons[_loc2_].visible = false;
            _buttons[_loc2_].selected = false;
            _buttons[_loc2_].filters = [];
            _loc2_++;
         }
         var _loc3_:int = _columns * _rows * _page;
         _loc2_ = 0;
         while(_loc2_ < _buttons.length)
         {
            if(!(_loc2_ >= _buttons.length || _loc3_ + _loc2_ >= _contents.length))
            {
               _loc4_ = _contents[_loc3_ + _loc2_];
               _buttons[_loc2_].addChild(_loc4_);
               Utils.scale_me(_loc4_,_button_width,_button_height);
               if(_scale_up == false && (_loc4_.scaleX > 1 || _loc4_.scaleY > 1))
               {
                  _loc4_.scaleX = _loc4_.scaleY = 1;
               }
               Utils.center_piece(_loc4_,_buttons[_loc2_],_button_width / 2,_button_height / 2);
               _buttons[_loc2_].visible = true;
            }
            _loc2_++;
         }
      }
      
      private function make_button() : void
      {
         var _loc1_:uint = _buttons.length;
         var _loc2_:Sprite = new MovieClip();
         _loc2_.name = _loc1_.toString();
         _buttons.push(_loc2_);
         _loc2_.addEventListener(MouseEvent.CLICK,button_click);
         addChild(_loc2_);
         Utils.over_out(_loc2_);
         _loc2_.buttonMode = true;
         _loc2_.mouseChildren = false;
      }
      
      public function add_buttons(param1:Array, param2:String = "") : void
      {
         ui.type_lbl.text = param2;
         var _loc3_:uint = 0;
         _selected = -1;
         _page = 0;
         _contents = param1;
         _page_count = Math.ceil(_contents.length / (_columns * _rows));
         if(_page_count <= 1)
         {
            ui.page_lbl.visible = ui.page_left.visible = ui.page_right.visible = false;
         }
         else
         {
            ui.page_lbl.visible = ui.page_left.visible = ui.page_right.visible = true;
         }
         this.page_change(0);
      }
      
      private function position_buttons() : void
      {
         var _loc3_:MovieClip = null;
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc4_:uint = 0;
         while(_loc4_ < _buttons.length)
         {
            _loc3_ = _buttons[_loc4_];
            _loc3_.visible = false;
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _rows * _columns)
         {
            if(_loc4_ >= _buttons.length)
            {
               make_button();
            }
            _loc3_ = _buttons[_loc4_];
            _loc3_.graphics.clear();
            _loc3_.graphics.beginFill(16711935,0);
            if(debug)
            {
               _loc3_.graphics.beginFill(16711935,0.5);
            }
            _loc3_.graphics.drawRect(0,0,_button_width,_button_height);
            _loc3_.x = _loc2_ * (_button_width + _padding_width) + _padding_width;
            _loc3_.y = _loc1_ * (_button_height + _padding_height) + _padding_height;
            _loc2_++;
            if(_loc2_ >= _columns)
            {
               _loc2_ = 0;
               _loc1_++;
            }
            _loc4_++;
         }
         page_change(0);
      }
   }
}
