package com.bitstrips.comicbuilder.library
{
   import com.bitstrips.BSConstants;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import gs.TweenLite;
   
   public class AssetStacker extends Sprite
   {
       
      
      private var container:Sprite;
      
      private var pager:Pager;
      
      private var _tween:Boolean = true;
      
      private var area:Rectangle;
      
      private const display_count:uint = 9;
      
      private const gap:Number = 10;
      
      private var _over_name:String = "";
      
      public var _row:int = 0;
      
      private var assets_list:Array;
      
      private var txt_lbl:TextField;
      
      public function AssetStacker()
      {
         area = new Rectangle(0,0,575,73);
         super();
         trace("AssetStacker");
         container = new Sprite();
         addChild(container);
         pager = new Pager();
         addChild(pager);
         pager.x = 575 - 40;
         pager.up_btn.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            trace("LEFT" + row);
            row = row - 1;
         });
         pager.down_btn.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            trace("RIGHT" + row);
            row = row + 1;
         });
         txt_lbl = new TextField();
         this.addChild(txt_lbl);
         var format:TextFormat = new TextFormat();
         format.font = BSConstants.VERDANA;
         format.bold = true;
         format.size = 10;
         format.color = 0;
         format.align = TextFormatAlign.CENTER;
         txt_lbl.defaultTextFormat = format;
         txt_lbl.selectable = false;
         txt_lbl.embedFonts = true;
         txt_lbl.autoSize = TextFieldAutoSize.CENTER;
         txt_lbl.multiline = false;
         txt_lbl.wordWrap = false;
         txt_lbl.mouseEnabled = false;
         txt_lbl.setTextFormat(format);
         txt_lbl.embedFonts = true;
         txt_lbl.y = 30;
         txt_lbl.x = pager.x;
         txt_lbl.width = 40;
         txt_lbl.height = 20;
      }
      
      private function asset_over(param1:MouseEvent) : void
      {
         if(param1.buttonDown)
         {
            return;
         }
         _over_name = param1.currentTarget.name;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function clear_container() : void
      {
         var _loc1_:int = container.numChildren - 1;
         while(_loc1_ >= 0)
         {
            container.removeChildAt(_loc1_);
            _loc1_--;
         }
         area.x = 0;
         area.y = 0;
      }
      
      public function arrange_asset(param1:DisplayObject, param2:uint) : void
      {
         var _loc3_:int = Math.floor(param2 / display_count) * 73;
         var _loc4_:Number = param2 % display_count * AssetItem.a_width + 4;
         param1.x = _loc4_;
         param1.y = _loc3_;
         container.addChild(param1);
         if(param1.hasEventListener(MouseEvent.ROLL_OVER) == false)
         {
            param1.addEventListener(MouseEvent.MOUSE_OVER,asset_over,false,0,true);
            param1.addEventListener(MouseEvent.MOUSE_OUT,asset_out,false,0,true);
         }
      }
      
      public function get over_name() : String
      {
         return _over_name;
      }
      
      public function get row() : int
      {
         return _row;
      }
      
      private function update_row(param1:Boolean = true) : void
      {
         var tween:Boolean = param1;
         var i:uint = this._row * 9;
         while(i < this._row * 9 + 9)
         {
            if(assets_list[i])
            {
               assets_list[i].visible = true;
               assets_list[i].loadMe();
            }
            i = i + 1;
         }
         if(tween)
         {
            TweenLite.to(area,0.5,{
               "y":_row * this.area.height,
               "onUpdate":function():void
               {
                  container.scrollRect = area;
               }
            });
         }
         else
         {
            area.y = _row * this.area.height;
            container.scrollRect = area;
         }
      }
      
      public function set row(param1:int) : void
      {
         var _loc2_:int = Math.ceil(assets_list.length / this.display_count) - 1;
         param1 = Math.max(0,Math.min(param1,_loc2_));
         _row = param1;
         update_row(_tween);
         if(_row < _loc2_)
         {
            pager.down_btn.visible = true;
         }
         else
         {
            pager.down_btn.visible = false;
         }
         if(_row > 0)
         {
            pager.up_btn.visible = true;
         }
         else
         {
            pager.up_btn.visible = false;
         }
         txt_lbl.text = _row + 1 + "/" + (_loc2_ + 1);
         if(assets_list.length == 0)
         {
            txt_lbl.text = "0/0";
         }
      }
      
      public function set_assets_list(param1:Array, param2:uint = 0) : uint
      {
         assets_list = param1;
         clear_container();
         var _loc3_:uint = 0;
         while(_loc3_ < assets_list.length)
         {
            arrange_asset(assets_list[_loc3_],_loc3_);
            assets_list[_loc3_].visible = false;
            _loc3_++;
         }
         var _loc4_:uint = this._row;
         _row = param2;
         _tween = false;
         this.row = param2;
         _tween = true;
         return _loc4_;
      }
      
      public function set_size(param1:Number, param2:Number) : void
      {
         area = new Rectangle(0,0,param1,param2);
         trace("--SlidePane.setSize(" + area + ")--");
         container.scrollRect = area;
      }
      
      private function asset_out(param1:MouseEvent = null) : void
      {
         _over_name = "";
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}
