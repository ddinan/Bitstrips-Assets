package com.bitstrips.comicbuilder
{
   public class ComicAuthor
   {
      
      private static const debug:Boolean = false;
       
      
      private var myComicBuilder:ComicBuilder;
      
      private var user_id:int;
      
      private var seriesList:Array;
      
      private var authorName:String;
      
      public function ComicAuthor(param1:ComicBuilder)
      {
         super();
         if(debug)
         {
            trace("--ComicAuthor()--");
         }
         myComicBuilder = param1;
      }
      
      function setData(param1:Object) : void
      {
         var _loc2_:ComicSeries = null;
         if(debug)
         {
            trace("--ComicAuthor.setData()--");
         }
         user_id = param1.user_id;
         authorName = param1.userName;
         if(debug)
         {
            trace("setting series data: " + param1.series.length);
         }
         seriesList = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.series.length)
         {
            _loc2_ = new ComicSeries();
            _loc2_.setData(param1.series[_loc3_]);
            seriesList.push(_loc2_);
            _loc3_++;
         }
      }
      
      function get_seriesList() : Array
      {
         return seriesList;
      }
      
      function getSeries(param1:Number) : ComicSeries
      {
         var _loc2_:int = 0;
         while(_loc2_ < seriesList.length)
         {
            if(seriesList[_loc2_].getData().series_id == param1)
            {
               return seriesList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function addSeries(param1:Object) : ComicSeries
      {
         if(debug)
         {
            trace("--ComicAuthor.addSeries()--");
         }
         var _loc2_:ComicSeries = new ComicSeries();
         _loc2_.setData(param1);
         seriesList.push(_loc2_);
         return _loc2_;
      }
      
      function getAuthorName() : String
      {
         return authorName;
      }
   }
}
