package com.bitstrips.comicbuilder
{
   import flash.display.Sprite;
   
   public class TitleInterface extends Sprite
   {
       
      
      private var myComic:Comic;
      
      public function TitleInterface(param1:Comic)
      {
         super();
         trace("--ComicInterface()--");
         myComic = param1;
      }
   }
}
