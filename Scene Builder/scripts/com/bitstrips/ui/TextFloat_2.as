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
       
      
      private var format:TextFormat;
      
      private var field:TextField;
      
      private var bkgr:Sprite;
      
      public function TextFloat()
      {
         super();
         this.mouseEnabled = this.mouseChildren = false;
         bkgr = new Sprite();
         bkgr.mouseEnabled = false;
         format = new TextFormat();
         if(BSConstants.EDU)
         {
            format.font = BSConstants.VERDANA;
            format.size = 10;
         }
         else
         {
            format.font = BSConstants.CREATIVEBLOCK;
            format.size = 12;
         }
         format.color = 0;
         format.align = TextFormatAlign.CENTER;
         field = new TextField();
         field.defaultTextFormat = format;
         field.selectable = false;
         field.embedFonts = true;
         field.autoSize = TextFieldAutoSize.CENTER;
         field.multiline = false;
         field.wordWrap = false;
         field.mouseEnabled = false;
         addChild(bkgr);
         addChild(field);
         setText("default text");
      }
      
      public function set text(param1:String) : void
      {
         setText(param1);
      }
      
      public function setText(param1:String) : void
      {
         field.text = param1;
         field.x = 0 - field.width / 2;
         field.y = 0 - field.height / 2;
         bkgr.graphics.clear();
         bkgr.graphics.lineStyle(2,0);
         bkgr.graphics.beginFill(16777215,1);
         bkgr.graphics.drawRect(0 - field.width / 2,0 - field.height / 2,field.width,field.height);
      }
   }
}
