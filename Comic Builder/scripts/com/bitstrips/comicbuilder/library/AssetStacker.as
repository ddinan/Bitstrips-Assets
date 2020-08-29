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
       
      
      private var area:Rectangle;
      
      private var container:Sprite;
      
      private const gap:Number = 10;
      
      private var assets_list:Array;
      
      private const display_count:uint = 9;
      
      public var _row:int = 0;
      
      private var pager:Pager;
      
      private var txt_lbl:TextField;
      
      private var _tween:Boolean = true;
      
      private var _over_name:String = "";
      
      public function AssetStacker()
      {
         this.area = new Rectangle(0,0,575,73);
         super();
         trace("AssetStacker");
         this.container = new Sprite();
         addChild(this.container);
         this.pager = new Pager();
         addChild(this.pager);
         this.pager.x = 575 - 40;
         this.pager.up_btn.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            trace("LEFT" + row);
            row = row - 1;
         });
         this.pager.down_btn.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            trace("RIGHT" + row);
            row = row + 1;
         });
         this.txt_lbl = new TextField();
         this.addChild(this.txt_lbl);
         var format:TextFormat = new TextFormat();
         format.font = BSConstants.VERDANA;
         format.bold = true;
         format.size = 10;
         format.color = 0;
         format.align = TextFormatAlign.CENTER;
         this.txt_lbl.defaultTextFormat = format;
         this.txt_lbl.selectable = false;
         this.txt_lbl.embedFonts = true;
         this.txt_lbl.autoSize = TextFieldAutoSize.CENTER;
         this.txt_lbl.multiline = false;
         this.txt_lbl.wordWrap = false;
         this.txt_lbl.mouseEnabled = false;
         this.txt_lbl.setTextFormat(format);
         this.txt_lbl.embedFonts = true;
         this.txt_lbl.y = 30;
         this.txt_lbl.x = this.pager.x;
         this.txt_lbl.width = 40;
         this.txt_lbl.height = 20;
      }
      
      public function get row() : int
      {
         return this._row;
      }
      
      public function set row(param1:int) : void
      {
         var _loc2_:int = Math.ceil(this.assets_list.length / this.display_count) - 1;
         param1 = Math.max(0,Math.min(param1,_loc2_));
         this._row = param1;
         this.update_row(this._tween);
         if(this._row < _loc2_)
         {
            this.pager.down_btn.visible = true;
         }
         else
         {
            this.pager.down_btn.visible = false;
         }
         if(this._row > 0)
         {
            this.pager.up_btn.visible = true;
         }
         else
         {
            this.pager.up_btn.visible = false;
         }
         this.txt_lbl.text = this._row + 1 + "/" + (_loc2_ + 1);
         if(this.assets_list.length == 0)
         {
            this.txt_lbl.text = "0/0";
         }
      }
      
      private function update_row(param1:Boolean = true) : void
      {
         var tween:Boolean = param1;
         var i:uint = this._row * 9;
         while(i < this._row * 9 + 9)
         {
            if(this.assets_list[i])
            {
               this.assets_list[i].visible = true;
               this.assets_list[i].loadMe();
            }
            i = i + 1;
         }
         if(tween)
         {
            TweenLite.to(this.area,0.5,{
               "y":this._row * this.area.height,
               "onUpdate":function():void
               {
                  container.scrollRect = area;
               }
            });
         }
         else
         {
            this.area.y = this._row * this.area.height;
            this.container.scrollRect = this.area;
         }
      }
      
      public function set_size(param1:Number, param2:Number) : void
      {
         this.area = new Rectangle(0,0,param1,param2);
         trace("--SlidePane.setSize(" + this.area + ")--");
         this.container.scrollRect = this.area;
      }
      
      public function set_assets_list(param1:Array, param2:uint = 0) : uint
      {
         this.assets_list = param1;
         this.clear_container();
         var _loc3_:uint = 0;
         while(_loc3_ < this.assets_list.length)
         {
            this.arrange_asset(this.assets_list[_loc3_],_loc3_);
            this.assets_list[_loc3_].visible = false;
            _loc3_++;
         }
         var _loc4_:uint = this._row;
         this._row = param2;
         this._tween = false;
         this.row = param2;
         this._tween = true;
         return _loc4_;
      }
      
      public function clear_container() : void
      {
         var _loc1_:int = this.container.numChildren - 1;
         while(_loc1_ >= 0)
         {
            this.container.removeChildAt(_loc1_);
            _loc1_--;
         }
         this.area.x = 0;
         this.area.y = 0;
      }
      
      public function arrange_asset(param1:DisplayObject, param2:uint) : void
      {
         var _loc3_:int = Math.floor(param2 / this.display_count) * 73;
         var _loc4_:Number = param2 % this.display_count * AssetItem.a_width + 4;
         param1.x = _loc4_;
         param1.y = _loc3_;
         this.container.addChild(param1);
         if(param1.hasEventListener(MouseEvent.ROLL_OVER) == false)
         {
            param1.addEventListener(MouseEvent.MOUSE_OVER,this.asset_over,false,0,true);
            param1.addEventListener(MouseEvent.MOUSE_OUT,this.asset_out,false,0,true);
         }
      }
      
      private function asset_over(param1:MouseEvent) : void
      {
         if(param1.buttonDown)
         {
            return;
         }
         this._over_name = param1.currentTarget.name;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function asset_out(param1:MouseEvent = null) : void
      {
         this._over_name = "";
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get over_name() : String
      {
         return this._over_name;
      }
   }
}
