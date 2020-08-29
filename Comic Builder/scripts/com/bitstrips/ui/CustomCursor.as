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
       
      
      private var myLoader:Loader;
      
      private var cursorClip;
      
      private var cursorList:Array;
      
      private var cursorLocked:Boolean;
      
      private var _enabled:Boolean = true;
      
      private var debug:Boolean = true;
      
      private var _cursor:String;
      
      public var last_cursor:String;
      
      public function CustomCursor()
      {
         super();
         this.cursorList = new Array();
         this.cursorClip = new MovieClip();
         visible = false;
         this.cursorLocked = false;
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
         return this._enabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this.debug)
         {
            trace("CustomCursor: enabled: " + param1);
         }
         this._enabled = param1;
         if(param1 == false)
         {
            Mouse.show();
            this.visible = false;
         }
         else
         {
            this.visible = true;
            this.displayCursor();
         }
      }
      
      private function followMouse(param1:MouseEvent) : void
      {
         this.cursorClip.x = this.stage.mouseX;
         this.cursorClip.y = this.stage.mouseY;
      }
      
      private function loadCursorClip(param1:String) : void
      {
         this.myLoader = new Loader();
         this.myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadCursorClip_complete);
         this.myLoader.load(new URLRequest(param1));
      }
      
      private function loadCursorClip_complete(param1:Event) : void
      {
         this.setCursorClip(this.myLoader.content);
      }
      
      public function setCursorClip(param1:*) : void
      {
         this.cursorClip = param1;
         addChild(this.cursorClip);
         this.mouseEnabled = this.mouseChildren = false;
      }
      
      private function add_stage_listeners() : void
      {
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.followMouse);
      }
      
      private function remove_stage_listeners() : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.followMouse);
      }
      
      public function setCursor(param1:String) : void
      {
         if(this.debug)
         {
            trace("setCursor: " + param1);
         }
         if(param1 == "reset")
         {
            if(this.last_cursor)
            {
               this._cursor = this.last_cursor;
               this.last_cursor = "";
            }
            else
            {
               return;
            }
         }
         else
         {
            this._cursor = param1;
            this.last_cursor = "";
         }
         this.displayCursor();
      }
      
      public function removeCursor(param1:String) : void
      {
         this._cursor = "";
         this.displayCursor();
      }
      
      public function displayCursor() : void
      {
         if(this.debug)
         {
            trace("CustomCursor: displayCursor: " + this._cursor);
         }
         if(this._cursor && this._cursor != "strip" && this._enabled)
         {
            Mouse.hide();
            this.visible = true;
            this.cursorClip.gotoAndStop(this._cursor);
         }
         else
         {
            this.visible = false;
            Mouse.show();
         }
      }
      
      public function strip() : void
      {
         this._cursor = "";
         this.displayCursor();
      }
   }
}
