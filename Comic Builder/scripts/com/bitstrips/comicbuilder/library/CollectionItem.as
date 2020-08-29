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
      
      public static const myTextFormat_normal:TextFormat = new TextFormat(BSConstants.VERDANA,10,0,false,false,false);
      
      public static const myTextFormat_selected:TextFormat = new TextFormat(BSConstants.VERDANA,10,0,false,false,true);
      
      public static const FLICKR_SEARCH:String = "FLICKR_SEARCH";
       
      
      private var field:TextField;
      
      private var libraryID:String;
      
      private var timer:Timer;
      
      private var debug:Boolean = false;
      
      private var flickr_search:TextField;
      
      private var flickr_btn:Button;
      
      private var _selected:Boolean = false;
      
      public function CollectionItem(param1:String, param2:String)
      {
         var new_libraryID:String = param1;
         var new_name:String = param2;
         super();
         if(this.debug)
         {
            trace("--LibraryItem(" + new_name + ")--");
         }
         this.libraryID = new_libraryID;
         this.field = new TextField();
         this.field.defaultTextFormat = CollectionItem.myTextFormat_normal;
         this.field.embedFonts = true;
         this.field.autoSize = TextFieldAutoSize.LEFT;
         this.field.selectable = false;
         this.field.backgroundColor = 16777156;
         this.field.background = false;
         this.field.text = new_name;
         this.name = new_name;
         this.addEventListener(MouseEvent.CLICK,this.handleCLICK);
         this.field.selectable = false;
         this.field.mouseEnabled = false;
         this.buttonMode = true;
         addChild(this.field);
         if(this.libraryID == "Flickr")
         {
            if(this.debug)
            {
               trace("Flickr");
            }
            this.flickr_search = new TextField();
            this.flickr_search.embedFonts = true;
            this.flickr_search.defaultTextFormat = CollectionItem.myTextFormat_normal;
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
            this.flickr_search.visible = this.flickr_btn.visible = false;
            this.flickr_search.addEventListener(KeyboardEvent.KEY_UP,this.text_input);
            this.flickr_search.addEventListener(FocusEvent.FOCUS_IN,function(param1:Event):void
            {
               stage.addEventListener(MouseEvent.CLICK,remove_focus);
            });
         }
         if(this.libraryID == "loading")
         {
            this.animating = true;
         }
      }
      
      public function get animating() : Boolean
      {
         if(this.timer)
         {
            return this.timer.running;
         }
         return false;
      }
      
      public function set animating(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.timer == null)
            {
               this.timer = new Timer(500);
               this.timer.addEventListener(TimerEvent.TIMER,this.animate,false,0,true);
            }
            this.timer.start();
            this.mouseChildren = false;
            this.mouseEnabled = false;
            this.buttonMode = false;
         }
         else
         {
            this.timer.stop();
         }
      }
      
      private function animate(param1:TimerEvent) : void
      {
         var _loc2_:* = "";
         var _loc3_:int = 0;
         while(_loc3_ < this.timer.currentCount % 4)
         {
            _loc2_ = _loc2_ + ".";
            _loc3_++;
         }
         this.field.text = name + _loc2_;
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
      
      private function handleCLICK(param1:MouseEvent) : void
      {
         this.selected = true;
      }
      
      public function getLibraryID() : String
      {
         return this.libraryID;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         if(this._selected)
         {
            this.field.setTextFormat(CollectionItem.myTextFormat_selected);
            this.field.background = true;
            this.buttonMode = false;
            if(this.flickr_search && stage)
            {
               stage.focus = this.flickr_search;
            }
            if(this.debug)
            {
               trace("CollectionItem Activate: " + this.libraryID);
            }
            dispatchEvent(new Event(Event.SELECT));
         }
         else
         {
            this.field.setTextFormat(CollectionItem.myTextFormat_normal);
            this.field.background = false;
            this.buttonMode = true;
         }
         if(this.libraryID == "Flickr")
         {
            this.flickr_search.visible = this.flickr_btn.visible = param1;
         }
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this.flickr_search)
         {
            if(param1)
            {
               Utils.enable_shade(this.flickr_btn);
               Utils.enable_shade(this.flickr_search);
            }
            else
            {
               Utils.disable_shade(this.flickr_btn);
               Utils.disable_shade(this.flickr_search);
            }
         }
      }
   }
}
