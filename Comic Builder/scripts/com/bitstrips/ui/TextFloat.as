package com.bitstrips.ui
{
   import com.bitstrips.BSConstants;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class TextFloat extends Sprite
   {
       
      
      private var bkgr:Sprite;
      
      private var field:TextField;
      
      private var format:TextFormat;
      
      public function TextFloat()
      {
         super();
         this.mouseEnabled = this.mouseChildren = false;
         this.bkgr = new Sprite();
         this.bkgr.mouseEnabled = false;
         this.format = new TextFormat();
         if(BSConstants.EDU)
         {
            this.format.font = BSConstants.VERDANA;
            this.format.size = 10;
         }
         else
         {
            this.format.font = BSConstants.CREATIVEBLOCK;
            this.format.size = 12;
         }
         this.format.color = 0;
         this.format.align = TextFormatAlign.CENTER;
         this.field = new TextField();
         this.field.defaultTextFormat = this.format;
         this.field.selectable = false;
         this.field.embedFonts = true;
         this.field.autoSize = TextFieldAutoSize.CENTER;
         this.field.multiline = false;
         this.field.wordWrap = false;
         this.field.mouseEnabled = false;
         addChild(this.bkgr);
         addChild(this.field);
         this.setText("default text");
      }
      
      public function set text(param1:String) : void
      {
         this.setText(param1);
      }
      
      public function setText(param1:String) : void
      {
         this.field.text = param1;
         this.field.x = 0 - this.field.width / 2;
         this.field.y = 0 - this.field.height / 2;
         this.bkgr.graphics.clear();
         this.bkgr.graphics.lineStyle(2,0);
         this.bkgr.graphics.beginFill(16777215,1);
         this.bkgr.graphics.drawRect(0 - this.field.width / 2,0 - this.field.height / 2,this.field.width,this.field.height);
      }
   }
}
