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
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   
   public class CollectionItem extends Sprite
   {
      
      public static const FLICKR_SEARCH:String = "FLICKR_SEARCH";
      
      public static const myTextFormat_normal:TextFormat = new TextFormat(BSConstants.VERDANA,10,0,false,false,false);
      
      public static const myTextFormat_selected:TextFormat = new TextFormat(BSConstants.VERDANA,10,0,false,false,true);
       
      
      private var field:TextField;
      
      private var timer:Timer;
      
      private var debug:Boolean = false;
      
      private var libraryID:String;
      
      private var flickr_search:TextField;
      
      private var flickr_btn:Button;
      
      private var _selected:Boolean = false;
      
      public function CollectionItem(param1:String, param2:String)
      {
         var new_libraryID:String = param1;
         var new_name:String = param2;
         super();
         if(debug)
         {
            trace("--LibraryItem(" + new_name + ")--");
         }
         this.libraryID = new_libraryID;
         field = new TextField();
         field.defaultTextFormat = CollectionItem.myTextFormat_normal;
         field.embedFonts = true;
         field.autoSize = TextFieldAutoSize.LEFT;
         field.selectable = false;
         field.backgroundColor = 16777156;
         field.background = false;
         field.text = new_name;
         this.name = new_name;
         this.addEventListener(MouseEvent.CLICK,handleCLICK);
         field.selectable = false;
         field.mouseEnabled = false;
         this.buttonMode = true;
         addChild(field);
         if(libraryID == "Flickr")
         {
            if(debug)
            {
               trace("Flickr");
            }
            flickr_search = new TextField();
            flickr_search.embedFonts = true;
            flickr_search.defaultTextFormat = CollectionItem.myTextFormat_normal;
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
            flickr_search.visible = flickr_btn.visible = false;
            flickr_search.addEventListener(KeyboardEvent.KEY_UP,text_input);
            flickr_search.addEventListener(FocusEvent.FOCUS_IN,function(param1:Event):void
            {
               stage.addEventListener(MouseEvent.CLICK,remove_focus);
            });
         }
         if(this.libraryID == "loading")
         {
            this.animating = true;
         }
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(flickr_search)
         {
            if(param1)
            {
               Utils.enable_shade(flickr_btn);
               Utils.enable_shade(flickr_search);
            }
            else
            {
               Utils.disable_shade(flickr_btn);
               Utils.disable_shade(flickr_search);
            }
         }
      }
      
      private function handleCLICK(param1:MouseEvent) : void
      {
         selected = true;
      }
      
      private function flickr_click(param1:MouseEvent = null) : void
      {
         dispatchEvent(new TextEvent(CollectionItem.FLICKR_SEARCH,false,false,flickr_search.text));
         enabled = false;
      }
      
      public function get selected() : Boolean
      {
         return _selected;
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
      
      public function get animating() : Boolean
      {
         if(timer)
         {
            return timer.running;
         }
         return false;
      }
      
      private function animate(param1:TimerEvent) : void
      {
         var _loc2_:* = "";
         var _loc3_:int = 0;
         while(_loc3_ < timer.currentCount % 4)
         {
            _loc2_ = _loc2_ + ".";
            _loc3_++;
         }
         field.text = name + _loc2_;
      }
      
      public function getLibraryID() : String
      {
         return libraryID;
      }
      
      public function get search_terms() : String
      {
         return flickr_search.text;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(_selected == param1)
         {
            return;
         }
         _selected = param1;
         if(_selected)
         {
            field.setTextFormat(CollectionItem.myTextFormat_selected);
            field.background = true;
            this.buttonMode = false;
            if(flickr_search && stage)
            {
               stage.focus = flickr_search;
            }
            if(debug)
            {
               trace("CollectionItem Activate: " + this.libraryID);
            }
            dispatchEvent(new Event(Event.SELECT));
         }
         else
         {
            field.setTextFormat(CollectionItem.myTextFormat_normal);
            field.background = false;
            this.buttonMode = true;
         }
         if(libraryID == "Flickr")
         {
            flickr_search.visible = flickr_btn.visible = param1;
         }
      }
      
      private function text_input(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            flickr_click();
         }
      }
      
      public function set animating(param1:Boolean) : void
      {
         if(param1)
         {
            if(timer == null)
            {
               timer = new Timer(500);
               timer.addEventListener(TimerEvent.TIMER,animate,false,0,true);
            }
            timer.start();
            this.mouseChildren = false;
            this.mouseEnabled = false;
            this.buttonMode = false;
         }
         else
         {
            timer.stop();
         }
      }
   }
}
