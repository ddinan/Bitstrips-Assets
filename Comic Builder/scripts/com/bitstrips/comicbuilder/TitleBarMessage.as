package com.bitstrips.comicbuilder
{
   import com.bitstrips.BSConstants;
   import fl.controls.ComboBox;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class TitleBarMessage extends Sprite
   {
       
      
      public var recipientBox:ComboBox;
      
      public var titleData:Object;
      
      public var myComicBuilder:ComicBuilder;
      
      public var titleArea:Rectangle;
      
      public var titleFormat:TextFormat;
      
      public var seriesFormat:TextFormat;
      
      public var subjectField:TextField;
      
      public var labelField:TextField;
      
      public const defaultTitle:String = "";
      
      public function TitleBarMessage(param1:ComicBuilder)
      {
         super();
         trace("--TitleBarMessage()--");
         this.myComicBuilder = param1;
         this.titleData = new Object();
         this.titleArea = new Rectangle(10,0,730,40);
         this.titleFormat = new TextFormat();
         this.titleFormat.font = BSConstants.VERDANA;
         this.titleFormat.size = 14;
         this.titleFormat.align = TextFormatAlign.LEFT;
         this.titleFormat.bold = true;
         this.titleFormat.color = 0;
         this.seriesFormat = new TextFormat();
         this.seriesFormat.font = BSConstants.VERDANA;
         this.seriesFormat.size = 12;
         this.seriesFormat.align = TextFormatAlign.LEFT;
         this.seriesFormat.bold = true;
         this.seriesFormat.color = 0;
         this.recipientBox = new ComboBox();
         this.labelField = new TextField();
         this.subjectField = new TextField();
         addChild(this.labelField);
         addChild(this.subjectField);
         this.setData({
            "authorName":"ANONYMOUS",
            "comicTitle":this.defaultTitle,
            "seriesList":[],
            "series":0,
            "episode":0
         });
      }
      
      public function setData(param1:Object) : void
      {
         var _loc2_:* = null;
         trace("--TitleBarMessage.setData(" + param1.comicTitle + ")--");
         for(_loc2_ in param1)
         {
            this.titleData[_loc2_] = param1[_loc2_];
            trace(_loc2_ + ": " + this.titleData[_loc2_]);
         }
         this.drawMe();
      }
      
      public function drawMe() : void
      {
         var _loc1_:int = 0;
         trace("--TitleBarMessage.drawMe()--");
         this.recipientBox.removeAll();
         this.recipientBox.addItem({
            "label":"Select Recipient",
            "data":0
         });
         var _loc2_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.recipientBox.length)
         {
            if(this.recipientBox.getItemAt(_loc1_).data == this.titleData.series)
            {
               _loc2_ = _loc1_;
               break;
            }
            _loc1_++;
         }
         this.recipientBox.selectedIndex = _loc2_;
         this.recipientBox.addEventListener(Event.CHANGE,this.updateRecipient);
         this.recipientBox.x = this.titleArea.x + this.titleArea.width - this.recipientBox.width;
         this.recipientBox.width = 140;
         this.labelField.defaultTextFormat = this.titleFormat;
         this.labelField.type = TextFieldType.DYNAMIC;
         this.labelField.selectable = false;
         this.labelField.embedFonts = true;
         this.labelField.multiline = false;
         this.labelField.wordWrap = false;
         this.labelField.autoSize = TextFieldAutoSize.LEFT;
         this.labelField.text = "Subject: ";
         this.labelField.height = this.recipientBox.height;
         this.subjectField.width = 450;
         this.subjectField.height = this.recipientBox.height;
         this.subjectField.defaultTextFormat = this.titleFormat;
         this.subjectField.type = TextFieldType.INPUT;
         this.subjectField.selectable = true;
         this.subjectField.embedFonts = true;
         this.subjectField.multiline = false;
         this.subjectField.wordWrap = false;
         this.subjectField.autoSize = TextFieldAutoSize.NONE;
         this.subjectField.maxChars = 80;
         this.subjectField.border = true;
         this.subjectField.borderColor = 0;
         this.subjectField.background = true;
         this.subjectField.backgroundColor = 16777215;
         this.subjectField.restrict = "A-Z a-z 0-9 \\- .,!@&()\\\'?:";
         this.subjectField.addEventListener(Event.CHANGE,this.updateTitle);
         this.subjectField.addEventListener(MouseEvent.MOUSE_OVER,this.mOverTitle);
         this.subjectField.addEventListener(MouseEvent.MOUSE_OUT,this.mOutTitle);
         if(this.titleData.comicTitle == "")
         {
            this.titleData.comicTitle = this.defaultTitle;
         }
         this.subjectField.text = this.titleData.comicTitle;
         this.subjectField.x = 100;
         this.adjustTitle();
      }
      
      public function updateTitle(param1:Event) : void
      {
         this.adjustTitle();
      }
      
      public function adjustTitle() : void
      {
         this.labelField.x = 6;
         this.subjectField.x = this.labelField.x + this.labelField.width;
      }
      
      public function mOverTitle(param1:MouseEvent) : void
      {
      }
      
      public function mOutTitle(param1:MouseEvent) : void
      {
      }
      
      public function getFullTitle() : String
      {
         return String(this.subjectField.text);
      }
      
      public function getTitle() : String
      {
         trace("--TitleBarMessage.getTitle(" + this.subjectField.text + ")--");
         return this.subjectField.text;
      }
      
      public function setTitle(param1:String) : void
      {
         trace("--TitleBarMessage.setTitle(" + param1 + ")--");
         this.subjectField.text = param1;
      }
      
      public function titleChanged() : Boolean
      {
         if(this.subjectField.text == this.defaultTitle)
         {
            return false;
         }
         return true;
      }
      
      public function updateRecipient(param1:Event) : void
      {
         trace("--TitleBarMessage.setTitle()--");
      }
   }
}
