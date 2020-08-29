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
   
   public class TitleBarScene extends Sprite
   {
       
      
      var titleField:TextField;
      
      var newSeriesField:TextField;
      
      var titleArea:Rectangle;
      
      var myComicBuilder:ComicBuilder;
      
      var seriesFormat:TextFormat;
      
      var seriesBox:ComboBox;
      
      const defaultTitle:String = "\'Title of Scene\'";
      
      var newSeries_btn:Sprite;
      
      var titleData:Object;
      
      var titleFormat:TextFormat;
      
      var authorField:TextField;
      
      var episodeField:TextField;
      
      public function TitleBarScene(param1:ComicBuilder)
      {
         super();
         trace("--TitleBarScene()--");
         myComicBuilder = param1;
         titleData = new Object();
         titleArea = new Rectangle(10,0,730,40);
         titleFormat = new TextFormat();
         titleFormat.font = BSConstants.VERDANA;
         titleFormat.size = 16;
         titleFormat.align = TextFormatAlign.LEFT;
         titleFormat.bold = true;
         titleFormat.color = 16777215;
         seriesFormat = new TextFormat();
         seriesFormat.font = BSConstants.VERDANA;
         seriesFormat.size = 12;
         seriesFormat.align = TextFormatAlign.LEFT;
         seriesFormat.bold = true;
         seriesFormat.color = 16777215;
         seriesBox = new ComboBox();
         episodeField = new TextField();
         titleField = new TextField();
         authorField = new TextField();
         newSeriesField = new TextField();
         newSeries_btn = new Sprite();
         addChild(episodeField);
         addChild(titleField);
         addChild(authorField);
         setData({
            "authorName":"ANONYMOUS",
            "comicTitle":defaultTitle,
            "seriesList":[],
            "series":0,
            "episode":0
         });
      }
      
      public function commitNewSeries(param1:MouseEvent) : void
      {
         setNewSeries(false);
         myComicBuilder.newSeries_request(newSeriesField.text);
      }
      
      public function adjustTitle() : void
      {
         var _loc1_:Number = titleArea.x + titleArea.width / 2;
         var _loc2_:Number = episodeField.width + titleField.width;
         episodeField.x = _loc1_ - _loc2_ / 2;
         titleField.x = episodeField.x + episodeField.width;
      }
      
      public function updateTitle(param1:Event) : void
      {
         adjustTitle();
      }
      
      public function titleChanged() : Boolean
      {
         if(titleField.text == defaultTitle)
         {
            return false;
         }
         return true;
      }
      
      public function getFullTitle() : String
      {
         return String(titleField.text);
      }
      
      public function setTitle(param1:String) : void
      {
         trace("--TitleBarScene.setTitle(" + param1 + ")--");
         titleField.text = param1;
      }
      
      public function mOverTitle(param1:MouseEvent) : void
      {
         titleField.border = true;
      }
      
      public function updateSeries(param1:Event) : void
      {
         trace("--TitleBarScene.updateSeries(" + seriesBox.selectedItem.data + ")--");
         if(seriesBox.selectedItem.data == 0)
         {
            episodeField.text = "";
         }
         else if(seriesBox.selectedItem.data == -1)
         {
            setNewSeries(true);
         }
         else
         {
            myComicBuilder.setComicSeries(seriesBox.selectedItem.data);
         }
         adjustTitle();
      }
      
      public function mOutTitle(param1:MouseEvent) : void
      {
         titleField.border = false;
      }
      
      public function getTitle() : String
      {
         trace("--TitleBarScene.getTitle(" + titleField.text + ")--");
         return titleField.text;
      }
      
      public function setData(param1:Object) : void
      {
         var _loc2_:* = null;
         trace("--TitleBarScene.setData(" + param1.comicTitle + ")--");
         for(_loc2_ in param1)
         {
            titleData[_loc2_] = param1[_loc2_];
            trace(_loc2_ + ": " + titleData[_loc2_]);
         }
         drawMe();
      }
      
      public function focusText(param1:MouseEvent) : void
      {
         TextField(param1.currentTarget).setSelection(0,newSeriesField.text.length);
      }
      
      public function setNewSeries(param1:Boolean) : void
      {
         if(param1)
         {
            removeChild(seriesBox);
            addChild(newSeriesField);
            addChild(newSeries_btn);
            stage.focus = newSeriesField;
            newSeriesField.text = "new series name";
            newSeriesField.setSelection(0,newSeriesField.text.length);
            newSeriesField.addEventListener(MouseEvent.MOUSE_DOWN,focusText);
            newSeries_btn.addEventListener(MouseEvent.CLICK,commitNewSeries);
         }
         else
         {
            addChild(seriesBox);
            removeChild(newSeriesField);
            removeChild(newSeries_btn);
            newSeriesField.removeEventListener(MouseEvent.MOUSE_DOWN,focusText);
         }
      }
      
      public function drawMe() : void
      {
         var _loc1_:Object = null;
         trace("--TitleBarScene.drawMe()--");
         seriesBox.removeAll();
         seriesBox.addItem({
            "label":titleData.authorName + "\'s Bitstrips",
            "data":0
         });
         var _loc2_:int = 0;
         while(_loc2_ < titleData.seriesList.length)
         {
            _loc1_ = titleData.seriesList[_loc2_].getData();
            trace(_loc2_ + " name: " + _loc1_.name + " series_id: " + _loc1_.series_id);
            seriesBox.addItem({
               "label":_loc1_.name,
               "data":_loc1_.series_id
            });
            _loc2_++;
         }
         seriesBox.addItem({
            "label":"NEW SERIES",
            "data":-1
         });
         var _loc3_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < seriesBox.length)
         {
            if(seriesBox.getItemAt(_loc2_).data == titleData.series)
            {
               _loc3_ = _loc2_;
               break;
            }
            _loc2_++;
         }
         seriesBox.selectedIndex = _loc3_;
         seriesBox.addEventListener(Event.CHANGE,updateSeries);
         seriesBox.x = titleArea.x;
         seriesBox.width = 200;
         episodeField.defaultTextFormat = titleFormat;
         episodeField.type = TextFieldType.DYNAMIC;
         episodeField.selectable = false;
         episodeField.embedFonts = true;
         episodeField.multiline = false;
         episodeField.wordWrap = false;
         episodeField.autoSize = TextFieldAutoSize.LEFT;
         if(titleData.episode == 0)
         {
            episodeField.text = "";
         }
         else
         {
            episodeField.text = "#" + titleData.episode + ": ";
         }
         titleField.defaultTextFormat = titleFormat;
         titleField.type = TextFieldType.INPUT;
         titleField.selectable = true;
         titleField.embedFonts = true;
         titleField.multiline = false;
         titleField.wordWrap = false;
         titleField.autoSize = TextFieldAutoSize.LEFT;
         titleField.maxChars = 30;
         titleField.restrict = "A-Z a-z 0-9 \\- .,!@&()\\\'?:";
         titleField.addEventListener(Event.CHANGE,updateTitle);
         titleField.addEventListener(MouseEvent.MOUSE_OVER,mOverTitle);
         titleField.addEventListener(MouseEvent.MOUSE_OUT,mOutTitle);
         if(titleData.comicTitle == "")
         {
            titleData.comicTitle = defaultTitle;
         }
         titleField.text = titleData.comicTitle;
         titleField.x = 100;
         authorField.defaultTextFormat = titleFormat;
         authorField.type = TextFieldType.DYNAMIC;
         authorField.selectable = false;
         authorField.embedFonts = true;
         authorField.multiline = false;
         authorField.wordWrap = false;
         authorField.autoSize = TextFieldAutoSize.LEFT;
         if(titleData.authorName)
         {
            authorField.text = "by " + titleData.authorName;
         }
         else
         {
            authorField.text = "";
         }
         authorField.x = titleArea.x + titleArea.width - authorField.width;
         adjustTitle();
         newSeriesField.defaultTextFormat = seriesFormat;
         newSeriesField.type = TextFieldType.INPUT;
         newSeriesField.selectable = true;
         newSeriesField.embedFonts = true;
         newSeriesField.multiline = false;
         newSeriesField.wordWrap = false;
         newSeriesField.autoSize = TextFieldAutoSize.NONE;
         newSeriesField.x = seriesBox.x;
         newSeriesField.y = seriesBox.y;
         newSeriesField.width = seriesBox.width - 50;
         newSeriesField.height = seriesBox.height;
         newSeriesField.border = true;
         newSeriesField.background = true;
         newSeries_btn.graphics.clear();
         newSeries_btn.graphics.beginFill(16777215,1);
         newSeries_btn.graphics.lineStyle(2,0);
         newSeries_btn.graphics.drawRect(0,0,40,newSeriesField.height - 2);
         newSeries_btn.x = newSeriesField.x + newSeriesField.width + 10;
         newSeries_btn.y = newSeriesField.y + 1;
         var _loc4_:TextField = new TextField();
         _loc4_.defaultTextFormat = titleFormat;
         _loc4_.selectable = false;
         _loc4_.embedFonts = true;
         _loc4_.mouseEnabled = false;
         _loc4_.autoSize = TextFieldAutoSize.LEFT;
         _loc4_.text = "OK";
         _loc4_.x = newSeries_btn.width / 2 - _loc4_.width / 2;
         trace("newSeries_btn.x: " + newSeries_btn.x);
         trace("newSeries_btn.width: " + newSeries_btn.width);
         trace("btnField.width: " + _loc4_.width);
         trace("btnField.x: " + _loc4_.x);
         newSeries_btn.addChild(_loc4_);
      }
   }
}
