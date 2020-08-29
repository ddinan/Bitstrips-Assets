package com.gskinner.spelling
{
   import flash.events.Event;
   
   public class SpellingDictionaryEvent extends Event
   {
      
      public static const ADDED_CUSTOM_WORD:String = "addedCustomWord";
      
      public static const ACTIVE:String = "active";
      
      public static const CHANGED_CUSTOM_WORD_LIST:String = "changedCustomWordList";
      
      public static const CHANGED_MASTER_WORD_LIST:String = "changedMasterWordList";
      
      public static const REMOVED_CUSTOM_WORD:String = "removedCustomWord";
       
      
      protected var _index:int;
      
      protected var _word:String;
      
      public function SpellingDictionaryEvent(param1:String, param2:String = null, param3:int = -1)
      {
         super(param1,false,false);
         _word = param2;
         _index = param3;
      }
      
      public function get index() : int
      {
         return _index;
      }
      
      public function get word() : String
      {
         return _word;
      }
      
      override public function toString() : String
      {
         return super.toString();
      }
      
      override public function clone() : Event
      {
         return new SpellingDictionaryEvent(type,_word,_index);
      }
   }
}
