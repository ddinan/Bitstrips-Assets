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
       
      
      private var typeName:String;
      
      private var active:Boolean;
      
      private var myTextFormat_disabled:TextFormat;
      
      private var myTextFormat_selected:TextFormat;
      
      private var myTextFormat_enabled:TextFormat;
      
      private var myTypeInterface:TypeInterface;
      
      private var myColor:Number = 14540253;
      
      private var field:TextField;
      
      public function TypeItem(param1:TypeInterface, param2:String)
      {
         super();
         if(debug)
         {
            trace("--TypeItem(" + param2 + ")--");
         }
         typeName = param2;
         myTypeInterface = param1;
         active = false;
         myTextFormat_enabled = new TextFormat();
         myTextFormat_enabled.font = BSConstants.VERDANA;
         myTextFormat_enabled.bold = false;
         myTextFormat_enabled.size = 9;
         myTextFormat_enabled.color = 0;
         myTextFormat_enabled.underline = false;
         myTextFormat_disabled = new TextFormat();
         myTextFormat_disabled.color = 12303291;
         myTextFormat_disabled.bold = false;
         myTextFormat_disabled.underline = false;
         myTextFormat_selected = new TextFormat();
         myTextFormat_selected.color = 10027008;
         myTextFormat_selected.bold = false;
         myTextFormat_selected.underline = false;
         field = new TextField();
         field.defaultTextFormat = myTextFormat_enabled;
         field.autoSize = TextFieldAutoSize.LEFT;
         var _loc3_:String = typeName;
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
         if(_loc4_.hasOwnProperty(typeName))
         {
            _loc3_ = _(_loc4_[typeName]);
         }
         else
         {
            _loc3_ = typeName;
         }
         field.text = _loc3_;
         field.embedFonts = true;
         field.selectable = false;
         field.mouseEnabled = false;
         field.x = 5;
         drawShape();
         this.addEventListener(MouseEvent.CLICK,handleCLICK);
         addChild(field);
      }
      
      private function handleCLICK(param1:MouseEvent) : void
      {
         if(debug)
         {
            trace("Mouse CLICK on " + param1.target);
         }
         if(!active)
         {
            myTypeInterface.handleItemCLICK(this);
         }
      }
      
      public function getName() : String
      {
         return typeName;
      }
      
      public function doSelect(param1:Boolean) : void
      {
         active = param1;
         if(active)
         {
            myColor = 16777215;
            drawShape();
            this.buttonMode = false;
         }
         else
         {
            myColor = 14540253;
            drawShape();
            this.buttonMode = true;
         }
      }
      
      private function drawShape() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(active)
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
         this.graphics.moveTo(field.width + 10,field.height);
         this.graphics.lineTo(0,field.height);
         this.graphics.lineStyle(2,0,1);
         this.graphics.lineTo(0,0 + _loc3_);
         this.graphics.curveTo(0,0,_loc3_,0);
         this.graphics.lineTo(field.width + 10 - _loc3_,0);
         this.graphics.curveTo(field.width + 10,0,field.width + 10,0 + _loc3_);
         this.graphics.lineTo(field.width + 10,field.height);
         this.y = 0;
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
   }
}
