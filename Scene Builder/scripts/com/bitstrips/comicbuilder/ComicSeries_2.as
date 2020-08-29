package com.bitstrips.comicbuilder
{
   public class ComicSeries
   {
       
      
      private var seriesData:Object;
      
      public function ComicSeries()
      {
         super();
         trace("--ComicSeries()--");
         seriesData = new Object();
      }
      
      public function getData() : Object
      {
         return seriesData;
      }
      
      public function setData(param1:Object) : void
      {
         var _loc2_:* = null;
         trace("--ComicSeries.setData()--");
         for(_loc2_ in param1)
         {
            seriesData[_loc2_] = param1[_loc2_];
            trace(_loc2_ + ": " + seriesData[_loc2_]);
         }
         trace("seriesData.name: " + seriesData.name);
      }
      
      public function addCount() : Number
      {
         return Number(seriesData["count"]) + 1;
      }
   }
}
