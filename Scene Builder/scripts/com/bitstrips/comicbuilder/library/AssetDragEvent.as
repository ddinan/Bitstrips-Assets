package com.bitstrips.comicbuilder.library
{
   import flash.events.Event;
   
   public final class AssetDragEvent extends Event
   {
      
      public static const ASSET_DRAG:String = "assetDrag";
       
      
      public var assetData:Object;
      
      public function AssetDragEvent(param1:String, param2:Object)
      {
         super(param1,false,false);
         assetData = param2;
      }
      
      override public function clone() : Event
      {
         return new AssetDragEvent(type,assetData);
      }
   }
}
