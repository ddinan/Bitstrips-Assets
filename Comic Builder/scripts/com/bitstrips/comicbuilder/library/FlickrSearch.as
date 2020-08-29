package com.bitstrips.comicbuilder.library
{
   import com.bitstrips.BSConstants;
   import com.bitstrips.Utils;
   import fl.controls.Button;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class FlickrSearch extends Sprite
   {
      
      public static const myTextFormat_normal:TextFormat = new TextFormat(BSConstants.VERDANA,10,0,false,false,false);
      
      public static const FLICKR_SEARCH:String = "FLICKR_SEARCH";
       
      
      private var debug:Boolean = false;
      
      private var flickr_search:TextField;
      
      private var flickr_btn:Button;
      
      public function FlickrSearch()
      {
         super();
         this.flickr_search = new TextField();
         this.flickr_search.embedFonts = true;
         this.flickr_search.defaultTextFormat = FlickrSearch.myTextFormat_normal;
         this.flickr_search.selectable = true;
         this.flickr_search.border = true;
         this.flickr_search.multiline = false;
         this.flickr_search.type = TextFieldType.INPUT;
         this.flickr_search.width = 115;
         this.flickr_search.y = 16;
         this.flickr_search.x = 5;
         this.flickr_search.height = 16;
         addChild(this.flickr_search);
         this.flickr_btn = new Button();
         this.flickr_btn.label = "Search";
         addChild(this.flickr_btn);
         this.flickr_btn.y = 34;
         this.flickr_btn.x = 16;
         this.flickr_btn.scaleX = this.flickr_btn.scaleY = 0.8;
         this.flickr_btn.addEventListener(MouseEvent.CLICK,this.flickr_click);
         this.flickr_search.addEventListener(KeyboardEvent.KEY_UP,this.text_input);
         this.flickr_search.addEventListener(FocusEvent.FOCUS_IN,function(param1:Event):void
         {
            stage.addEventListener(MouseEvent.CLICK,remove_focus);
         });
      }
      
      private function remove_focus(param1:Event) : void
      {
         if(param1.target == this.flickr_search)
         {
            return;
         }
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.remove_focus);
            if(stage.focus == this.flickr_search)
            {
               stage.focus = null;
            }
         }
      }
      
      private function text_input(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            this.flickr_click();
         }
      }
      
      private function flickr_click(param1:MouseEvent = null) : void
      {
         dispatchEvent(new TextEvent(CollectionItem.FLICKR_SEARCH,false,false,this.flickr_search.text));
         this.enabled = false;
      }
      
      public function get search_terms() : String
      {
         return this.flickr_search.text;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this.flickr_btn.enabled = this.flickr_search.mouseEnabled = param1;
         if(param1)
         {
            Utils.enable_shade(this.flickr_btn);
            Utils.enable_shade(this.flickr_search);
            this.flickr_search.type = TextFieldType.INPUT;
         }
         else
         {
            this.flickr_search.type = TextFieldType.DYNAMIC;
            Utils.disable_shade(this.flickr_btn);
            Utils.disable_shade(this.flickr_search);
         }
      }
   }
}
