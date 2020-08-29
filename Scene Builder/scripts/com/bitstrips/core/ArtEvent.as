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
         art_type = param2;
         colours = param3.concat();
      }
      
      override public function clone() : Event
      {
         return new ArtEvent(type,art_type,colours.concat());
      }
   }
}
