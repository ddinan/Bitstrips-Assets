package com.bitstrips.core
{
   import flash.events.Event;
   
   public final class ArtEvent extends Event
   {
      
      public static const CLICK:String = "ART_CLICK";
       
      
      public var art_type:String;
      
      public var colours:Array;
      
      public function ArtEvent(param1:String, param2:String, param3:Array)
      {
         super(param1,false,false);
         this.art_type = param2;
         this.colours = param3.concat();
      }
      
      override public function clone() : Event
      {
         return new ArtEvent(type,this.art_type,this.colours.concat());
      }
   }
}
