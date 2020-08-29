package com.bitstrips.comicbuilder
{
   public class ComicAuthor
   {
      
      private static const debug:Boolean = false;
       
      
      private var user_id:int;
      
      private var authorName:String;
      
      private var myComicBuilder:ComicBuilder;
      
      private var seriesList:Array;
      
      public function ComicAuthor(param1:ComicBuilder)
      {
         super();
         if(debug)
         {
            trace("--ComicAuthor()--");
         }
         this.myComicBuilder = param1;
      }
      
      function setData(param1:Object) : void
      {
         var _loc2_:ComicSeries = null;
         if(debug)
         {
            trace("--ComicAuthor.setData()--");
         }
         this.user_id = param1.user_id;
         this.authorName = param1.userName;
         if(debug)
         {
            trace("setting series data: " + param1.series.length);
         }
         this.seriesList = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < param1.series.length)
         {
            _loc2_ = new ComicSeries();
            _loc2_.setData(param1.series[_loc3_]);
            this.seriesList.push(_loc2_);
            _loc3_++;
         }
      }
      
      public function addSeries(param1:Object) : ComicSeries
      {
         if(debug)
         {
            trace("--ComicAuthor.addSeries()--");
         }
         var _loc2_:ComicSeries = new ComicSeries();
         _loc2_.setData(param1);
         this.seriesList.push(_loc2_);
         return _loc2_;
      }
      
      function getAuthorName() : String
      {
         return this.authorName;
      }
      
      function get_seriesList() : Array
      {
         return this.seriesList;
      }
      
      function getSeries(param1:Number) : ComicSeries
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.seriesList.length)
         {
            if(this.seriesList[_loc2_].getData().series_id == param1)
            {
               return this.seriesList[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
   }
}
