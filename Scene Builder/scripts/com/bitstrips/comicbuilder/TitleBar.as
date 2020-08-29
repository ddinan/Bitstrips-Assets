package com.bitstrips.comicbuilder
{
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.BSConstants;
   import com.gskinner.spelling.SpellingHighlighter;
   import fl.controls.ComboBox;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class TitleBar extends Sprite
   {
      
      private static var debug:Boolean = false;
       
      
      private var titleField:TextField;
      
      private var newSeriesField:TextField;
      
      private var titleArea:Rectangle;
      
      private var myComicBuilder:ComicBuilder;
      
      private var seriesFormat:TextFormat;
      
      private var seriesBox:ComboBox;
      
      private var sh:SpellingHighlighter;
      
      private const defaultTitle:String = "\'" + _("Title of Strip") + "\'";
      
      private var newSeries_btn:Sprite;
      
      private var textTintFormat:TextFormat;
      
      private var titleData:Object;
      
      private var lightText:Boolean;
      
      private var titleFormat:TextFormat;
      
      public var authorField:TextField;
      
      private var episodeField:TextField;
      
      public function TitleBar(param1:ComicBuilder)
      {
         var new_myComicBuilder:ComicBuilder = param1;
         super();
         if(debug)
         {
            trace("--TitleBar()--");
         }
         myComicBuilder = new_myComicBuilder;
         titleData = new Object();
         titleArea = new Rectangle(10,0,730,40);
         titleFormat = new TextFormat();
         titleFormat.font = BSConstants.VERDANA;
         titleFormat.size = 16;
         titleFormat.align = TextFormatAlign.LEFT;
         titleFormat.bold = true;
         seriesFormat = new TextFormat();
         seriesFormat.font = BSConstants.VERDANA;
         seriesFormat.size = 12;
         seriesFormat.align = TextFormatAlign.LEFT;
         seriesFormat.bold = true;
         textTintFormat = new TextFormat();
         textTintFormat.color = 0;
         seriesBox = new ComboBox();
         episodeField = new TextField();
         titleField = new TextField();
         authorField = new TextField();
         newSeriesField = new TextField();
         newSeries_btn = new Sprite();
         lightText = false;
         setTextTint();
         if(BSConstants.EDU == false)
         {
            addChild(seriesBox);
         }
         addChild(episodeField);
         addChild(titleField);
         addChild(authorField);
         sh = new SpellingHighlighter(titleField);
         addEventListener(Event.ADDED_TO_STAGE,function(param1:Event):void
         {
            sh.enableOnFocus = true;
         });
         setData({
            "authorName":"",
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
      
      public function setTextTint() : void
      {
         if(debug)
         {
            trace("--TitleBar.setTextTint(" + lightText + ")--");
         }
         if(lightText)
         {
            textTintFormat.color = 16777215;
         }
         else
         {
            textTintFormat.color = 0;
         }
         episodeField.setTextFormat(textTintFormat);
         titleField.setTextFormat(textTintFormat);
         authorField.setTextFormat(textTintFormat);
         newSeriesField.setTextFormat(textTintFormat);
      }
      
      public function getFullTitle() : String
      {
         return String(titleField.text);
      }
      
      public function mOverTitle(param1:MouseEvent) : void
      {
         titleField.border = true;
      }
      
      public function setBrightness(param1:Number) : void
      {
         if(debug)
         {
            trace("--TitleBar.setBrightness(" + param1 + ")--");
         }
         if(param1 > 60)
         {
            if(lightText)
            {
               lightText = false;
               setTextTint();
            }
         }
         else if(!lightText)
         {
            lightText = true;
            setTextTint();
         }
      }
      
      private function remove_focus(param1:Event) : void
      {
         if(param1.target == this.titleField || param1.target == this.authorField)
         {
            return;
         }
         stage.removeEventListener(MouseEvent.MOUSE_UP,remove_focus);
         if(stage && (stage.focus == this.titleField || stage.focus == this.authorField))
         {
            stage.focus = null;
         }
      }
      
      public function updateSeries(param1:Event) : void
      {
         if(debug)
         {
            trace("--TitleBar.updateSeries(" + seriesBox.selectedItem.data + ")--");
         }
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
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      public function getTitle() : String
      {
         if(debug)
         {
            trace("--TitleBar.getTitle(" + titleField.text + ")--");
         }
         return titleField.text;
      }
      
      public function setData(param1:Object) : void
      {
         var _loc2_:* = null;
         if(debug)
         {
            trace("--TitleBar.setData(" + param1.comicTitle + ")--");
         }
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
      
      public function setTitle(param1:String) : void
      {
         if(debug)
         {
            trace("--TitleBar.setTitle(" + param1 + ")--");
         }
         titleField.text = param1;
      }
      
      public function get_lightText() : Boolean
      {
         return lightText;
      }
      
      public function drawMe() : void
      {
         var seriesData:Object = null;
         if(debug)
         {
            trace("--TitleBar.drawMe()--");
         }
         seriesBox.removeAll();
         seriesBox.addItem({
            "label":titleData.authorName + "\'s Bitstrips",
            "data":0
         });
         var i:int = 0;
         while(i < titleData.seriesList.length)
         {
            seriesData = titleData.seriesList[i].getData();
            if(debug)
            {
               trace(i + " name: " + seriesData.name + " series_id: " + seriesData.series_id);
            }
            seriesBox.addItem({
               "label":seriesData.name,
               "data":seriesData.series_id
            });
            i++;
         }
         seriesBox.addItem({
            "label":"NEW SERIES",
            "data":-1
         });
         var currentIndex:uint = 0;
         if(debug)
         {
            trace("matching series id<");
         }
         i = 0;
         while(i < seriesBox.length)
         {
            if(seriesBox.getItemAt(i).data == titleData.series)
            {
               currentIndex = i;
               break;
            }
            i++;
         }
         if(debug)
         {
            trace(">");
         }
         seriesBox.selectedIndex = currentIndex;
         seriesBox.addEventListener(Event.CHANGE,updateSeries);
         seriesBox.x = titleArea.x;
         seriesBox.width = 200;
         if(titleData.authorName == null)
         {
            seriesBox.visible = false;
         }
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
         titleField.addEventListener(Event.CHANGE,updateTitle);
         titleField.addEventListener(MouseEvent.MOUSE_OVER,mOverTitle);
         titleField.addEventListener(MouseEvent.MOUSE_OUT,mOutTitle);
         titleField.addEventListener(FocusEvent.FOCUS_IN,function(param1:Event):void
         {
            stage.addEventListener(MouseEvent.CLICK,remove_focus);
         });
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
         if(titleData.authorName)
         {
            authorField.text = _("by") + " " + titleData.authorName;
         }
         authorField.autoSize = TextFieldAutoSize.LEFT;
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
         var btnField:TextField = new TextField();
         btnField.defaultTextFormat = titleFormat;
         btnField.selectable = false;
         btnField.embedFonts = true;
         btnField.mouseEnabled = false;
         btnField.autoSize = TextFieldAutoSize.LEFT;
         btnField.text = "OK";
         btnField.x = newSeries_btn.width / 2 - btnField.width / 2;
         if(debug)
         {
            trace("newSeries_btn.x: " + newSeries_btn.x);
         }
         if(debug)
         {
            trace("newSeries_btn.width: " + newSeries_btn.width);
         }
         if(debug)
         {
            trace("btnField.width: " + btnField.width);
         }
         if(debug)
         {
            trace("btnField.x: " + btnField.x);
         }
         newSeries_btn.addChild(btnField);
         setTextTint();
      }
   }
}
