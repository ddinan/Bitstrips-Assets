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
       
      
      public var titleArea:Rectangle;
      
      public var myComicBuilder:ComicBuilder;
      
      public var seriesFormat:TextFormat;
      
      public const defaultTitle:String = "";
      
      public var titleData:Object;
      
      public var labelField:TextField;
      
      public var subjectField:TextField;
      
      public var titleFormat:TextFormat;
      
      public var recipientBox:ComboBox;
      
      public function TitleBarMessage(param1:ComicBuilder)
      {
         super();
         trace("--TitleBarMessage()--");
         myComicBuilder = param1;
         titleData = new Object();
         titleArea = new Rectangle(10,0,730,40);
         titleFormat = new TextFormat();
         titleFormat.font = BSConstants.VERDANA;
         titleFormat.size = 14;
         titleFormat.align = TextFormatAlign.LEFT;
         titleFormat.bold = true;
         titleFormat.color = 0;
         seriesFormat = new TextFormat();
         seriesFormat.font = BSConstants.VERDANA;
         seriesFormat.size = 12;
         seriesFormat.align = TextFormatAlign.LEFT;
         seriesFormat.bold = true;
         seriesFormat.color = 0;
         recipientBox = new ComboBox();
         labelField = new TextField();
         subjectField = new TextField();
         addChild(labelField);
         addChild(subjectField);
         setData({
            "authorName":"ANONYMOUS",
            "comicTitle":defaultTitle,
            "seriesList":[],
            "series":0,
            "episode":0
         });
      }
      
      public function titleChanged() : Boolean
      {
         if(subjectField.text == defaultTitle)
         {
            return false;
         }
         return true;
      }
      
      public function adjustTitle() : void
      {
         labelField.x = 6;
         subjectField.x = labelField.x + labelField.width;
      }
      
      public function updateTitle(param1:Event) : void
      {
         adjustTitle();
      }
      
      public function updateRecipient(param1:Event) : void
      {
         trace("--TitleBarMessage.setTitle()--");
      }
      
      public function setTitle(param1:String) : void
      {
         trace("--TitleBarMessage.setTitle(" + param1 + ")--");
         subjectField.text = param1;
      }
      
      public function getFullTitle() : String
      {
         return String(subjectField.text);
      }
      
      public function getTitle() : String
      {
         trace("--TitleBarMessage.getTitle(" + subjectField.text + ")--");
         return subjectField.text;
      }
      
      public function setData(param1:Object) : void
      {
         var _loc2_:* = null;
         trace("--TitleBarMessage.setData(" + param1.comicTitle + ")--");
         for(_loc2_ in param1)
         {
            titleData[_loc2_] = param1[_loc2_];
            trace(_loc2_ + ": " + titleData[_loc2_]);
         }
         drawMe();
      }
      
      public function mOutTitle(param1:MouseEvent) : void
      {
      }
      
      public function drawMe() : void
      {
         var _loc1_:int = 0;
         trace("--TitleBarMessage.drawMe()--");
         recipientBox.removeAll();
         recipientBox.addItem({
            "label":"Select Recipient",
            "data":0
         });
         var _loc2_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < recipientBox.length)
         {
            if(recipientBox.getItemAt(_loc1_).data == titleData.series)
            {
               _loc2_ = _loc1_;
               break;
            }
            _loc1_++;
         }
         recipientBox.selectedIndex = _loc2_;
         recipientBox.addEventListener(Event.CHANGE,updateRecipient);
         recipientBox.x = titleArea.x + titleArea.width - recipientBox.width;
         recipientBox.width = 140;
         labelField.defaultTextFormat = titleFormat;
         labelField.type = TextFieldType.DYNAMIC;
         labelField.selectable = false;
         labelField.embedFonts = true;
         labelField.multiline = false;
         labelField.wordWrap = false;
         labelField.autoSize = TextFieldAutoSize.LEFT;
         labelField.text = "Subject: ";
         labelField.height = recipientBox.height;
         subjectField.width = 450;
         subjectField.height = recipientBox.height;
         subjectField.defaultTextFormat = titleFormat;
         subjectField.type = TextFieldType.INPUT;
         subjectField.selectable = true;
         subjectField.embedFonts = true;
         subjectField.multiline = false;
         subjectField.wordWrap = false;
         subjectField.autoSize = TextFieldAutoSize.NONE;
         subjectField.maxChars = 80;
         subjectField.border = true;
         subjectField.borderColor = 0;
         subjectField.background = true;
         subjectField.backgroundColor = 16777215;
         subjectField.restrict = "A-Z a-z 0-9 \\- .,!@&()\\\'?:";
         subjectField.addEventListener(Event.CHANGE,updateTitle);
         subjectField.addEventListener(MouseEvent.MOUSE_OVER,mOverTitle);
         subjectField.addEventListener(MouseEvent.MOUSE_OUT,mOutTitle);
         if(titleData.comicTitle == "")
         {
            titleData.comicTitle = defaultTitle;
         }
         subjectField.text = titleData.comicTitle;
         subjectField.x = 100;
         adjustTitle();
      }
      
      public function mOverTitle(param1:MouseEvent) : void
      {
      }
   }
}
