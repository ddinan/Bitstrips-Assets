package com.gskinner.text
{
   public class StringPosition
   {
       
      
      public var subString:String;
      
      public var endIndex:uint;
      
      public var beginIndex:uint;
      
      public function StringPosition(param1:uint, param2:uint, param3:String = null)
      {
         super();
         this.beginIndex = param1;
         this.endIndex = param2;
         this.subString = param3;
      }
   }
}
