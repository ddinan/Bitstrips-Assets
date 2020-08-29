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
       
      
      private var seriesBox:ComboBox;
      
      private var titleData:Object;
      
      private var myComicBuilder:ComicBuilder;
      
      private var titleArea:Rectangle;
      
      private var titleFormat:TextFormat;
      
      private var seriesFormat:TextFormat;
      
      private var titleField:TextField;
      
      private var episodeField:TextField;
      
      public var authorField:TextField;
      
      private var newSeriesField:TextField;
      
      private var newSeries_btn:Sprite;
      
      private var lightText:Boolean;
      
      private var textTintFormat:TextFormat;
      
      private var sh:SpellingHighlighter;
      
      private const defaultTitle:String = "\'" + this._("Title of Strip") + "\'";
      
      public function TitleBar(param1:ComicBuilder)
      {
         var new_myComicBuilder:ComicBuilder = param1;
         super();
         if(debug)
         {
            trace("--TitleBar()--");
         }
         this.myComicBuilder = new_myComicBuilder;
         this.titleData = new Object();
         this.titleArea = new Rectangle(10,0,730,40);
         this.titleFormat = new TextFormat();
         this.titleFormat.font = BSConstants.VERDANA;
         this.titleFormat.size = 16;
         this.titleFormat.align = TextFormatAlign.LEFT;
         this.titleFormat.bold = true;
         this.seriesFormat = new TextFormat();
         this.seriesFormat.font = BSConstants.VERDANA;
         this.seriesFormat.size = 12;
         this.seriesFormat.align = TextFormatAlign.LEFT;
         this.seriesFormat.bold = true;
         this.textTintFormat = new TextFormat();
         this.textTintFormat.color = 0;
         this.seriesBox = new ComboBox();
         this.episodeField = new TextField();
         this.titleField = new TextField();
         this.authorField = new TextField();
         this.newSeriesField = new TextField();
         this.newSeries_btn = new Sprite();
         this.lightText = false;
         this.setTextTint();
         if(BSConstants.EDU == false)
         {
            addChild(this.seriesBox);
         }
         addChild(this.episodeField);
         addChild(this.titleField);
         addChild(this.authorField);
         this.sh = new SpellingHighlighter(this.titleField);
         addEventListener(Event.ADDED_TO_STAGE,function(param1:Event):void
         {
            sh.enableOnFocus = true;
         });
         this.setData({
            "authorName":"",
            "comicTitle":this.defaultTitle,
            "seriesList":[],
            "series":0,
            "episode":0
         });
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
            this.titleData[_loc2_] = param1[_loc2_];
            trace(_loc2_ + ": " + this.titleData[_loc2_]);
         }
         this.drawMe();
      }
      
      public function drawMe() : void
      {
         var seriesData:Object = null;
         if(debug)
         {
            trace("--TitleBar.drawMe()--");
         }
         this.seriesBox.removeAll();
         this.seriesBox.addItem({
            "label":this.titleData.authorName + "\'s Bitstrips",
            "data":0
         });
         var i:int = 0;
         while(i < this.titleData.seriesList.length)
         {
            seriesData = this.titleData.seriesList[i].getData();
            if(debug)
            {
               trace(i + " name: " + seriesData.name + " series_id: " + seriesData.series_id);
            }
            this.seriesBox.addItem({
               "label":seriesData.name,
               "data":seriesData.series_id
            });
            i++;
         }
         this.seriesBox.addItem({
            "label":"NEW SERIES",
            "data":-1
         });
         var currentIndex:uint = 0;
         if(debug)
         {
            trace("matching series id<");
         }
         i = 0;
         while(i < this.seriesBox.length)
         {
            if(this.seriesBox.getItemAt(i).data == this.titleData.series)
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
         this.seriesBox.selectedIndex = currentIndex;
         this.seriesBox.addEventListener(Event.CHANGE,this.updateSeries);
         this.seriesBox.x = this.titleArea.x;
         this.seriesBox.width = 200;
         if(this.titleData.authorName == null)
         {
            this.seriesBox.visible = false;
         }
         this.episodeField.defaultTextFormat = this.titleFormat;
         this.episodeField.type = TextFieldType.DYNAMIC;
         this.episodeField.selectable = false;
         this.episodeField.embedFonts = true;
         this.episodeField.multiline = false;
         this.episodeField.wordWrap = false;
         this.episodeField.autoSize = TextFieldAutoSize.LEFT;
         if(this.titleData.episode == 0)
         {
            this.episodeField.text = "";
         }
         else
         {
            this.episodeField.text = "#" + this.titleData.episode + ": ";
         }
         this.titleField.defaultTextFormat = this.titleFormat;
         this.titleField.type = TextFieldType.INPUT;
         this.titleField.selectable = true;
         this.titleField.embedFonts = true;
         this.titleField.multiline = false;
         this.titleField.wordWrap = false;
         this.titleField.autoSize = TextFieldAutoSize.LEFT;
         this.titleField.maxChars = 30;
         this.titleField.addEventListener(Event.CHANGE,this.updateTitle);
         this.titleField.addEventListener(MouseEvent.MOUSE_OVER,this.mOverTitle);
         this.titleField.addEventListener(MouseEvent.MOUSE_OUT,this.mOutTitle);
         this.titleField.addEventListener(FocusEvent.FOCUS_IN,function(param1:Event):void
         {
            stage.addEventListener(MouseEvent.CLICK,remove_focus);
         });
         if(this.titleData.comicTitle == "")
         {
            this.titleData.comicTitle = this.defaultTitle;
         }
         this.titleField.text = this.titleData.comicTitle;
         this.titleField.x = 100;
         this.authorField.defaultTextFormat = this.titleFormat;
         this.authorField.type = TextFieldType.DYNAMIC;
         this.authorField.selectable = false;
         this.authorField.embedFonts = true;
         this.authorField.multiline = false;
         this.authorField.wordWrap = false;
         if(this.titleData.authorName)
         {
            this.authorField.text = this._("by") + " " + this.titleData.authorName;
         }
         this.authorField.autoSize = TextFieldAutoSize.LEFT;
         this.authorField.x = this.titleArea.x + this.titleArea.width - this.authorField.width;
         this.adjustTitle();
         this.newSeriesField.defaultTextFormat = this.seriesFormat;
         this.newSeriesField.type = TextFieldType.INPUT;
         this.newSeriesField.selectable = true;
         this.newSeriesField.embedFonts = true;
         this.newSeriesField.multiline = false;
         this.newSeriesField.wordWrap = false;
         this.newSeriesField.autoSize = TextFieldAutoSize.NONE;
         this.newSeriesField.x = this.seriesBox.x;
         this.newSeriesField.y = this.seriesBox.y;
         this.newSeriesField.width = this.seriesBox.width - 50;
         this.newSeriesField.height = this.seriesBox.height;
         this.newSeriesField.border = true;
         this.newSeriesField.background = true;
         this.newSeries_btn.graphics.clear();
         this.newSeries_btn.graphics.beginFill(16777215,1);
         this.newSeries_btn.graphics.lineStyle(2,0);
         this.newSeries_btn.graphics.drawRect(0,0,40,this.newSeriesField.height - 2);
         this.newSeries_btn.x = this.newSeriesField.x + this.newSeriesField.width + 10;
         this.newSeries_btn.y = this.newSeriesField.y + 1;
         var btnField:TextField = new TextField();
         btnField.defaultTextFormat = this.titleFormat;
         btnField.selectable = false;
         btnField.embedFonts = true;
         btnField.mouseEnabled = false;
         btnField.autoSize = TextFieldAutoSize.LEFT;
         btnField.text = "OK";
         btnField.x = this.newSeries_btn.width / 2 - btnField.width / 2;
         if(debug)
         {
            trace("newSeries_btn.x: " + this.newSeries_btn.x);
         }
         if(debug)
         {
            trace("newSeries_btn.width: " + this.newSeries_btn.width);
         }
         if(debug)
         {
            trace("btnField.width: " + btnField.width);
         }
         if(debug)
         {
            trace("btnField.x: " + btnField.x);
         }
         this.newSeries_btn.addChild(btnField);
         this.setTextTint();
      }
      
      private function remove_focus(param1:Event) : void
      {
         if(param1.target == this.titleField || param1.target == this.authorField)
         {
            return;
         }
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.remove_focus);
         if(stage && (stage.focus == this.titleField || stage.focus == this.authorField))
         {
            stage.focus = null;
         }
      }
      
      public function updateSeries(param1:Event) : void
      {
         if(debug)
         {
            trace("--TitleBar.updateSeries(" + this.seriesBox.selectedItem.data + ")--");
         }
         if(this.seriesBox.selectedItem.data == 0)
         {
            this.episodeField.text = "";
         }
         else if(this.seriesBox.selectedItem.data == -1)
         {
            this.setNewSeries(true);
         }
         else
         {
            this.myComicBuilder.setComicSeries(this.seriesBox.selectedItem.data);
         }
         this.adjustTitle();
      }
      
      public function focusText(param1:MouseEvent) : void
      {
         TextField(param1.currentTarget).setSelection(0,this.newSeriesField.text.length);
      }
      
      public function setNewSeries(param1:Boolean) : void
      {
         if(param1)
         {
            removeChild(this.seriesBox);
            addChild(this.newSeriesField);
            addChild(this.newSeries_btn);
            stage.focus = this.newSeriesField;
            this.newSeriesField.text = "new series name";
            this.newSeriesField.setSelection(0,this.newSeriesField.text.length);
            this.newSeriesField.addEventListener(MouseEvent.MOUSE_DOWN,this.focusText);
            this.newSeries_btn.addEventListener(MouseEvent.CLICK,this.commitNewSeries);
         }
         else
         {
            addChild(this.seriesBox);
            removeChild(this.newSeriesField);
            removeChild(this.newSeries_btn);
            this.newSeriesField.removeEventListener(MouseEvent.MOUSE_DOWN,this.focusText);
         }
      }
      
      public function commitNewSeries(param1:MouseEvent) : void
      {
         this.setNewSeries(false);
         this.myComicBuilder.newSeries_request(this.newSeriesField.text);
      }
      
      public function updateTitle(param1:Event) : void
      {
         this.adjustTitle();
      }
      
      public function adjustTitle() : void
      {
         var _loc1_:Number = this.titleArea.x + this.titleArea.width / 2;
         var _loc2_:Number = this.episodeField.width + this.titleField.width;
         this.episodeField.x = _loc1_ - _loc2_ / 2;
         this.titleField.x = this.episodeField.x + this.episodeField.width;
      }
      
      public function mOverTitle(param1:MouseEvent) : void
      {
         this.titleField.border = true;
      }
      
      public function mOutTitle(param1:MouseEvent) : void
      {
         this.titleField.border = false;
      }
      
      public function getFullTitle() : String
      {
         return String(this.titleField.text);
      }
      
      public function getTitle() : String
      {
         if(debug)
         {
            trace("--TitleBar.getTitle(" + this.titleField.text + ")--");
         }
         return this.titleField.text;
      }
      
      public function setTitle(param1:String) : void
      {
         if(debug)
         {
            trace("--TitleBar.setTitle(" + param1 + ")--");
         }
         this.titleField.text = param1;
      }
      
      public function titleChanged() : Boolean
      {
         if(this.titleField.text == this.defaultTitle)
         {
            return false;
         }
         return true;
      }
      
      public function setBrightness(param1:Number) : void
      {
         if(debug)
         {
            trace("--TitleBar.setBrightness(" + param1 + ")--");
         }
         if(param1 > 60)
         {
            if(this.lightText)
            {
               this.lightText = false;
               this.setTextTint();
            }
         }
         else if(!this.lightText)
         {
            this.lightText = true;
            this.setTextTint();
         }
      }
      
      public function setTextTint() : void
      {
         if(debug)
         {
            trace("--TitleBar.setTextTint(" + this.lightText + ")--");
         }
         if(this.lightText)
         {
            this.textTintFormat.color = 16777215;
         }
         else
         {
            this.textTintFormat.color = 0;
         }
         this.episodeField.setTextFormat(this.textTintFormat);
         this.titleField.setTextFormat(this.textTintFormat);
         this.authorField.setTextFormat(this.textTintFormat);
         this.newSeriesField.setTextFormat(this.textTintFormat);
      }
      
      public function get_lightText() : Boolean
      {
         return this.lightText;
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
   }
}
