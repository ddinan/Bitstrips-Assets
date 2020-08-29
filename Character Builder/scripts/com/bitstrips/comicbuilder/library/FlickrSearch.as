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
      
      public static const FLICKR_SEARCH:String = "FLICKR_SEARCH";
      
      public static const myTextFormat_normal:TextFormat = new TextFormat(BSConstants.VERDANA,10,0,false,false,false);
       
      
      private var flickr_search:TextField;
      
      private var flickr_btn:Button;
      
      private var debug:Boolean = false;
      
      public function FlickrSearch()
      {
         super();
         flickr_search = new TextField();
         flickr_search.embedFonts = true;
         flickr_search.defaultTextFormat = FlickrSearch.myTextFormat_normal;
         flickr_search.selectable = true;
         flickr_search.border = true;
         flickr_search.multiline = false;
         flickr_search.type = TextFieldType.INPUT;
         flickr_search.width = 115;
         flickr_search.y = 16;
         flickr_search.x = 5;
         flickr_search.height = 16;
         addChild(flickr_search);
         flickr_btn = new Button();
         flickr_btn.label = "Search";
         addChild(flickr_btn);
         flickr_btn.y = 34;
         flickr_btn.x = 16;
         flickr_btn.scaleX = flickr_btn.scaleY = 0.8;
         flickr_btn.addEventListener(MouseEvent.CLICK,flickr_click);
         flickr_search.addEventListener(KeyboardEvent.KEY_UP,text_input);
         flickr_search.addEventListener(FocusEvent.FOCUS_IN,function(param1:Event):void
         {
            stage.addEventListener(MouseEvent.CLICK,remove_focus);
         });
      }
      
      public function set enabled(param1:Boolean) : void
      {
         flickr_btn.enabled = flickr_search.mouseEnabled = param1;
         if(param1)
         {
            Utils.enable_shade(flickr_btn);
            Utils.enable_shade(flickr_search);
            flickr_search.type = TextFieldType.INPUT;
         }
         else
         {
            flickr_search.type = TextFieldType.DYNAMIC;
            Utils.disable_shade(flickr_btn);
            Utils.disable_shade(flickr_search);
         }
      }
      
      private function flickr_click(param1:MouseEvent = null) : void
      {
         dispatchEvent(new TextEvent(CollectionItem.FLICKR_SEARCH,false,false,flickr_search.text));
         enabled = false;
      }
      
      public function get search_terms() : String
      {
         return flickr_search.text;
      }
      
      private function text_input(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            flickr_click();
         }
      }
      
      private function remove_focus(param1:Event) : void
      {
         if(param1.target == this.flickr_search)
         {
            return;
         }
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,remove_focus);
            if(stage.focus == this.flickr_search)
            {
               stage.focus = null;
            }
         }
      }
   }
}
