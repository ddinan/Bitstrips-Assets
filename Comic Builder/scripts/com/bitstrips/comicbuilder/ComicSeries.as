package com.bitstrips.comicbuilder
{
   public class ComicSeries
   {
       
      
      private var seriesData:Object;
      
      public function ComicSeries()
      {
         super();
         trace("--ComicSeries()--");
         this.seriesData = new Object();
      }
      
      public function setData(param1:Object) : void
      {
         var _loc2_:* = null;
         trace("--ComicSeries.setData()--");
         for(_loc2_ in param1)
         {
            this.seriesData[_loc2_] = param1[_loc2_];
            trace(_loc2_ + ": " + this.seriesData[_loc2_]);
         }
         trace("seriesData.name: " + this.seriesData.name);
      }
      
      public function getData() : Object
      {
         return this.seriesData;
      }
      
      public function addCount() : Number
      {
         return Number(this.seriesData["count"]) + 1;
      }
   }
}
