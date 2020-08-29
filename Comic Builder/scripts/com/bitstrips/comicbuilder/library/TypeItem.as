package com.bitstrips.comicbuilder.library
{
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class TypeItem extends Sprite
   {
      
      private static var debug:Boolean = false;
       
      
      private var myTypeInterface:TypeInterface;
      
      private var active:Boolean;
      
      private var field:TextField;
      
      private var typeName:String;
      
      private var myTextFormat_selected:TextFormat;
      
      private var myTextFormat_enabled:TextFormat;
      
      private var myTextFormat_disabled:TextFormat;
      
      private var myColor:Number = 14540253;
      
      public function TypeItem(param1:TypeInterface, param2:String)
      {
         super();
         if(debug)
         {
            trace("--TypeItem(" + param2 + ")--");
         }
         this.typeName = param2;
         this.myTypeInterface = param1;
         this.active = false;
         this.myTextFormat_enabled = new TextFormat();
         this.myTextFormat_enabled.font = BSConstants.VERDANA;
         this.myTextFormat_enabled.bold = false;
         this.myTextFormat_enabled.size = 9;
         this.myTextFormat_enabled.color = 0;
         this.myTextFormat_enabled.underline = false;
         this.myTextFormat_disabled = new TextFormat();
         this.myTextFormat_disabled.color = 12303291;
         this.myTextFormat_disabled.bold = false;
         this.myTextFormat_disabled.underline = false;
         this.myTextFormat_selected = new TextFormat();
         this.myTextFormat_selected.color = 10027008;
         this.myTextFormat_selected.bold = false;
         this.myTextFormat_selected.underline = false;
         this.field = new TextField();
         this.field.defaultTextFormat = this.myTextFormat_enabled;
         this.field.autoSize = TextFieldAutoSize.LEFT;
         var _loc3_:String = this.typeName;
         var _loc4_:Object = {
            "characters":"Characters",
            "scenes":"Scenes",
            "props":"Props",
            "furniture":"Furniture",
            "wall stuff":"Wall Items",
            "effects":"Effects",
            "shapes":"Shapes",
            "image":"Images",
            "backdrops":"Backdrops",
            "walls":"Walls",
            "floors":"Floors"
         };
         if(_loc4_.hasOwnProperty(this.typeName))
         {
            _loc3_ = this._(_loc4_[this.typeName]);
         }
         else
         {
            _loc3_ = this.typeName;
         }
         this.field.text = _loc3_;
         this.field.embedFonts = true;
         this.field.selectable = false;
         this.field.mouseEnabled = false;
         this.field.x = 5;
         this.drawShape();
         this.addEventListener(MouseEvent.CLICK,this.handleCLICK);
         addChild(this.field);
      }
      
      private function drawShape() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.active)
         {
            _loc1_ = 16777215;
            _loc2_ = 16777215;
         }
         else
         {
            _loc1_ = 13421772;
            _loc2_ = 0;
         }
         var _loc3_:Number = 4;
         this.graphics.clear();
         this.graphics.beginFill(_loc1_,1);
         this.graphics.lineStyle(2,_loc2_,1);
         this.graphics.moveTo(this.field.width + 10,this.field.height);
         this.graphics.lineTo(0,this.field.height);
         this.graphics.lineStyle(2,0,1);
         this.graphics.lineTo(0,0 + _loc3_);
         this.graphics.curveTo(0,0,_loc3_,0);
         this.graphics.lineTo(this.field.width + 10 - _loc3_,0);
         this.graphics.curveTo(this.field.width + 10,0,this.field.width + 10,0 + _loc3_);
         this.graphics.lineTo(this.field.width + 10,this.field.height);
         this.y = 0;
      }
      
      private function handleCLICK(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("Mouse CLICK on " + param1.target);
         }
         if(!this.active)
         {
            this.myTypeInterface.handleItemCLICK(this);
         }
      }
      
      public function doSelect(param1:Boolean) : void
      {
         this.active = param1;
         if(this.active)
         {
            this.myColor = 16777215;
            this.drawShape();
            this.buttonMode = false;
         }
         else
         {
            this.myColor = 14540253;
            this.drawShape();
            this.buttonMode = true;
         }
      }
      
      public function getName() : String
      {
         return this.typeName;
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
   }
}
