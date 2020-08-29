package com.gskinner.text
{
   public class CharacterSet
   {
      
      private static var _wordCharSet:Array;
      
      private static const DEFAULT_INVALID_WORD_CHARS:String = "0123456789";
      
      private static const DEFAULT_INNER_WORD_CHARS:String = "\'’";
      
      private static var _invalidWordChars:String = DEFAULT_INVALID_WORD_CHARS;
      
      private static var _innerWordChars:String = DEFAULT_INNER_WORD_CHARS;
      
      public static const DEFAULT_WORD_CHARS:String = "abcdefghijklmnopqrstuvwxyzàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿß";
      
      private static var _invalidWordCharSet:Array;
      
      private static var _innerWordCharSet:Array;
      
      private static var _wordChars:String = DEFAULT_WORD_CHARS;
       
      
      public function CharacterSet()
      {
         super();
         throw new Error("CharacterSet cannot be instantiated");
      }
      
      public static function get wordCharSet() : Array
      {
         if(_wordCharSet == null)
         {
            _wordCharSet = prepCharCodeArray(_wordChars);
         }
         return _wordCharSet;
      }
      
      private static function prepCharCodeArray(param1:String) : Array
      {
         var _loc2_:uint = param1.length;
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_[param1.charCodeAt(_loc4_)] = true;
            _loc3_[param1.charAt(_loc4_).toUpperCase().charCodeAt(0)] = true;
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function get invalidWordCharSet() : Array
      {
         if(_invalidWordCharSet == null)
         {
            _invalidWordCharSet = prepCharCodeArray(_invalidWordChars);
         }
         return _invalidWordCharSet;
      }
      
      public static function get innerWordCharSet() : Array
      {
         if(_innerWordCharSet == null)
         {
            _innerWordCharSet = prepCharCodeArray(_innerWordChars);
         }
         return _innerWordCharSet;
      }
      
      public static function set wordChars(param1:String) : void
      {
         _wordCharSet = null;
         _wordChars = param1;
      }
      
      public static function get wordChars() : String
      {
         return _wordChars;
      }
      
      public static function set innerWordChars(param1:String) : void
      {
         _innerWordCharSet = null;
         _innerWordChars = param1;
      }
      
      public static function get invalidWordChars() : String
      {
         return _invalidWordChars;
      }
      
      public static function get innerWordChars() : String
      {
         return _innerWordChars;
      }
      
      public static function set invalidWordChars(param1:String) : void
      {
         _invalidWordCharSet = null;
         _invalidWordChars = param1;
      }
   }
}
