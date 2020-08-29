package com.bitstrips.ui
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.ui.Mouse;
   
   public class CustomCursor extends Sprite
   {
       
      
      private var cursorLocked:Boolean;
      
      private var _enabled:Boolean = true;
      
      private var cursorClip;
      
      private var cursorList:Array;
      
      private var debug:Boolean = false;
      
      public var last_cursor:String;
      
      private var myLoader:Loader;
      
      private var _cursor:String;
      
      public function CustomCursor()
      {
         super();
         cursorList = new Array();
         cursorClip = new MovieClip();
         visible = false;
         cursorLocked = false;
         addEventListener(Event.ADDED_TO_STAGE,function(param1:Event):void
         {
            add_stage_listeners();
         });
         addEventListener(Event.REMOVED_FROM_STAGE,function(param1:Event):void
         {
            remove_stage_listeners();
         });
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      private function remove_stage_listeners() : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,followMouse);
      }
      
      public function setCursorClip(param1:*) : void
      {
         cursorClip = param1;
         addChild(cursorClip);
         this.mouseEnabled = this.mouseChildren = false;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(debug)
         {
            trace("CustomCursor: enabled: " + param1);
         }
         _enabled = param1;
         if(param1 == false)
         {
            Mouse.show();
            this.visible = false;
         }
         else
         {
            this.visible = true;
            displayCursor();
         }
      }
      
      public function removeCursor(param1:String) : void
      {
         _cursor = "";
         displayCursor();
      }
      
      private function loadCursorClip(param1:String) : void
      {
         myLoader = new Loader();
         myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCursorClip_complete);
         myLoader.load(new URLRequest(param1));
      }
      
      public function setCursor(param1:String) : void
      {
         if(debug)
         {
            trace("setCursor: " + param1);
         }
         if(param1 == "reset")
         {
            if(last_cursor)
            {
               _cursor = last_cursor;
               last_cursor = "";
            }
            else
            {
               return;
            }
         }
         else
         {
            _cursor = param1;
            last_cursor = "";
         }
         displayCursor();
      }
      
      private function loadCursorClip_complete(param1:Event) : void
      {
         setCursorClip(myLoader.content);
      }
      
      private function add_stage_listeners() : void
      {
         stage.addEventListener(MouseEvent.MOUSE_MOVE,followMouse);
      }
      
      public function strip() : void
      {
         _cursor = "";
         displayCursor();
      }
      
      private function followMouse(param1:MouseEvent) : void
      {
         cursorClip.x = this.stage.mouseX;
         cursorClip.y = this.stage.mouseY;
      }
      
      public function displayCursor() : void
      {
         if(debug)
         {
            trace("CustomCursor: displayCursor: " + _cursor);
         }
         if(_cursor && _cursor != "strip" && _enabled)
         {
            Mouse.hide();
            this.visible = true;
            cursorClip.gotoAndStop(_cursor);
         }
         else
         {
            this.visible = false;
            Mouse.show();
         }
      }
   }
}
