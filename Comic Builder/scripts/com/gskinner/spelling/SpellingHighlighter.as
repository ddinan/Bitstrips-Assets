package com.gskinner.spelling
{
   import com.gskinner.text.CharacterSet;
   import com.gskinner.text.TextHighlighter;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.IBitmapDrawable;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.Dictionary;
   
   public class SpellingHighlighter extends TextHighlighter
   {
      
      public static var defaultUnderlinePattern:BitmapData;
      
      public static var str_spelling_is_correct:String = "Spelling is correct";
      
      public static var str_add_to_dictionary:String = "Add to my dictionary";
      
      public static var defaultSpellingDictionary:SpellingDictionary;
      
      public static var str_remove_from_dictionary:String = "Remove from my dictionary";
      
      public static var str_no_suggestions:String = "No suggestions for: %WORD%";
       
      
      protected var _spellingDictionary:SpellingDictionary;
      
      protected var _contextMenuEnabled:Boolean = true;
      
      public var customDictionaryEditsEnabled:Boolean = true;
      
      protected var menuItems:Dictionary;
      
      protected var underlineBmpd:BitmapData;
      
      protected var contextData:Object;
      
      public function SpellingHighlighter(param1:Object = null, param2:SpellingDictionary = null)
      {
         var _loc3_:BitmapData = null;
         _spellingDictionary = !!param2?param2:!!defaultSpellingDictionary?defaultSpellingDictionary:SpellingDictionary.getInstance();
         if(!_spellingDictionary.active)
         {
            _spellingDictionary.addEventListener(SpellingDictionaryEvent.ACTIVE,handleDictionaryActive);
         }
         if(defaultUnderlinePattern == null)
         {
            _loc3_ = new BitmapData(4,2,true,0);
            _loc3_.setPixel32(0,0,2583625728);
            _loc3_.setPixel32(0,1,973012992);
            _loc3_.setPixel32(1,0,3439263744);
            _loc3_.setPixel32(1,1,2583625728);
            _loc3_.setPixel32(2,0,2583625728);
            _loc3_.setPixel32(2,1,973012992);
            _loc3_.setPixel32(3,0,1241448448);
            defaultUnderlinePattern = _loc3_;
         }
         super(param1);
         _ignoreCase = false;
         _color = 16711680;
      }
      
      override protected function checkWord(param1:String) : Boolean
      {
         return !_spellingDictionary.checkWord(param1);
      }
      
      override protected function draw() : void
      {
         var _loc1_:Boolean = _enabled;
         _enabled = _enabled && _spellingDictionary.active;
         super.draw();
         _enabled = _loc1_;
      }
      
      override public function set color(param1:uint) : void
      {
         var _loc2_:Number = param1 >> 24 & 255;
         if(_loc2_ == 0)
         {
            _loc2_ = 255;
         }
         canvas.transform.colorTransform = new ColorTransform(0,0,0,_loc2_ / 255,param1 >> 16 & 255,param1 >> 8 & 255,param1 & 255,0);
         super.color = param1;
      }
      
      public function set underlinePattern(param1:IBitmapDrawable) : void
      {
         if(underlineBmpd)
         {
            underlineBmpd.dispose();
         }
         if(param1 is BitmapData)
         {
            underlineBmpd = (param1 as BitmapData).clone();
         }
         else
         {
            underlineBmpd = new BitmapData((param1 as DisplayObject).width,(param1 as DisplayObject).height,true,0);
            underlineBmpd.draw(param1);
         }
         invalidate();
      }
      
      override protected function setupListeners(param1:Boolean = false) : void
      {
         setContextMenuListeners(param1);
         super.setupListeners(param1);
      }
      
      public function get contextMenuEnabled() : Boolean
      {
         return _contextMenuEnabled;
      }
      
      protected function handleRemoveFromDictionary(param1:ContextMenuEvent) : void
      {
         _spellingDictionary.removeCustomWord(contextData.word);
         draw();
      }
      
      override public function set wordList(param1:Array) : void
      {
      }
      
      protected function handleDictionaryActive(param1:SpellingDictionaryEvent) : void
      {
         invalidate();
      }
      
      override protected function drawRect(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:uint = 3) : void
      {
         var _loc8_:BitmapData = !!underlineBmpd?underlineBmpd:defaultUnderlinePattern;
         var _loc9_:Number = param2 + param4 - param6 + 2 + 1;
         canvas.graphics.beginBitmapFill(_loc8_,new Matrix(1,0,0,1,param1,_loc9_));
         canvas.graphics.drawRect(param1,_loc9_,param3,_loc8_.height);
      }
      
      protected function buildContextMenu(param1:ContextMenuEvent) : void
      {
         var _loc7_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:ContextMenuItem = null;
         var _loc19_:Array = null;
         var _loc20_:String = null;
         var _loc21_:ContextMenuItem = null;
         var _loc22_:ContextMenuItem = null;
         var _loc23_:ContextMenuItem = null;
         clearContextMenu();
         var _loc2_:ContextMenu = _textField.contextMenu as ContextMenu;
         var _loc3_:Array = _loc2_.customItems;
         var _loc4_:Array = CharacterSet.wordCharSet;
         var _loc5_:Array = CharacterSet.innerWordCharSet;
         var _loc6_:Array = CharacterSet.invalidWordCharSet;
         var _loc8_:Object = _spellingDictionary.getWordHash(SpellingDictionary.COMBINED_LIST);
         var _loc9_:Array = [];
         var _loc10_:String = _textField.text;
         var _loc11_:int = _textField.getCharIndexAtPoint(_textField.mouseX + _textField.scrollH,_textField.mouseY);
         if(_loc11_ == -1 || !(_loc4_[_loc10_.charCodeAt(_loc11_)] || _loc5_[_loc10_.charCodeAt(_loc11_)] || _loc6_[_loc10_.charCodeAt(_loc11_)]))
         {
            return;
         }
         _loc7_ = _loc11_;
         var _loc12_:uint = _loc10_.length;
         var _loc13_:int = -1;
         var _loc14_:Boolean = false;
         while(_loc7_ < _loc12_)
         {
            _loc17_ = _loc10_.charCodeAt(_loc7_);
            if(_loc5_[_loc17_])
            {
               if(!_loc4_[_loc10_.charCodeAt(_loc7_ + 1)])
               {
                  _loc13_ = _loc7_;
                  break;
               }
            }
            else if(_loc6_[_loc17_])
            {
               _loc14_ = true;
            }
            else if(!_loc4_[_loc17_])
            {
               _loc13_ = _loc7_;
               break;
            }
            _loc7_++;
            if(_loc7_ == _loc12_)
            {
               _loc13_ = _loc12_;
            }
         }
         _loc7_ = _loc11_;
         var _loc15_:int = -1;
         while(_loc7_ > 0)
         {
            _loc17_ = _loc10_.charCodeAt(_loc7_);
            if(_loc5_[_loc17_])
            {
               if(!_loc4_[_loc10_.charCodeAt(_loc7_ - 1)])
               {
                  _loc15_ = _loc7_ + 1;
                  break;
               }
            }
            else if(_loc6_[_loc17_])
            {
               _loc14_ = true;
            }
            else if(!_loc4_[_loc17_])
            {
               _loc15_ = _loc7_ + 1;
               break;
            }
            _loc7_--;
            if(_loc7_ == 0)
            {
               _loc15_ = 0;
            }
         }
         var _loc16_:String = _loc10_.substring(_loc15_,_loc13_);
         contextData = {
            "beginIndex":_loc15_,
            "endIndex":_loc13_,
            "word":_loc16_
         };
         if(_loc14_)
         {
            _loc9_ = [new ContextMenuItem(str_no_suggestions.split("%WORD%").join(_loc16_),false,false)];
         }
         else if(_spellingDictionary.checkWord(_loc16_))
         {
            if(_spellingDictionary.getWordHash(SpellingDictionary.CUSTOM_LIST)[_loc16_.toLowerCase()])
            {
               _loc9_ = [new ContextMenuItem(str_spelling_is_correct.split("%WORD%").join(_loc16_) + "*",false,false)];
               if(customDictionaryEditsEnabled)
               {
                  _loc18_ = new ContextMenuItem(str_remove_from_dictionary.split("%WORD%").join(_loc16_),true);
                  _loc18_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,handleRemoveFromDictionary,false,0,true);
                  _loc9_.push(_loc18_);
               }
            }
            else
            {
               _loc9_ = [new ContextMenuItem(str_spelling_is_correct.split("%WORD%").join(_loc16_),false,false)];
            }
         }
         else
         {
            _loc19_ = _spellingDictionary.getSpellingSuggestions(_loc16_,5,0.6);
            if(_loc19_.length == 0)
            {
               _loc9_ = [new ContextMenuItem(str_no_suggestions.split("%WORD%").join(_loc16_),false,false)];
            }
            else
            {
               _loc9_ = [];
               _loc7_ = 0;
               while(_loc7_ < _loc19_.length)
               {
                  _loc20_ = _loc19_[_loc7_];
                  _loc21_ = new ContextMenuItem(_loc20_);
                  _loc21_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,handleSuggestionSelect,false,0,true);
                  _loc9_.push(_loc21_);
                  _loc7_++;
               }
            }
            if(customDictionaryEditsEnabled)
            {
               _loc22_ = new ContextMenuItem(str_add_to_dictionary.split("%WORD%").join(_loc16_),true);
               _loc22_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,handleAddToDictionary,false,0,true);
               _loc9_.push(_loc22_);
            }
         }
         menuItems = new Dictionary(true);
         _loc7_ = 0;
         while(_loc7_ < _loc9_.length)
         {
            _loc23_ = _loc9_[_loc7_] as ContextMenuItem;
            if(_loc7_ == 0 && _loc3_.length > 0)
            {
               _loc23_.separatorBefore = true;
            }
            _loc3_.push(_loc23_);
            menuItems[_loc23_] = true;
            _loc7_++;
         }
      }
      
      public function set contextMenuEnabled(param1:Boolean) : void
      {
         clearContextMenu();
         _contextMenuEnabled = param1;
         setContextMenuListeners();
      }
      
      protected function clearContextMenu() : void
      {
         if(menuItems == null)
         {
            return;
         }
         var _loc1_:ContextMenu = _textField.contextMenu as ContextMenu;
         if(_loc1_ == null)
         {
            throw new Error("The SPL engine requires that the target TextField\'s contextMenu be of type ContextMenu");
         }
         var _loc2_:Array = _loc1_.customItems;
         var _loc3_:uint = _loc2_.length;
         while(_loc3_ > 0)
         {
            if(menuItems[_loc2_[_loc3_ - 1]])
            {
               _loc2_.splice(_loc3_ - 1,1);
            }
            _loc3_--;
         }
         _loc1_.customItems = _loc2_;
         _textField.contextMenu = _loc1_;
         menuItems = null;
      }
      
      protected function handleAddToDictionary(param1:ContextMenuEvent) : void
      {
         _spellingDictionary.addCustomWord(contextData.word);
         draw();
      }
      
      protected function handleSuggestionSelect(param1:ContextMenuEvent) : void
      {
         var _loc2_:String = _textField.text;
         _textField.replaceText(contextData.beginIndex,contextData.endIndex,param1.target.caption);
         _textField.setSelection(contextData.beginIndex,contextData.beginIndex + param1.target.caption.length);
         _textField.dispatchEvent(new Event(Event.CHANGE,true,false));
      }
      
      protected function setContextMenuListeners(param1:Boolean = false) : void
      {
         var _loc2_:ContextMenu = null;
         if(_textField == null)
         {
            return;
         }
         if(_textField.contextMenu as ContextMenu == null)
         {
            _loc2_ = new ContextMenu();
            _textField.contextMenu = _loc2_;
         }
         if(param1 || !_enabled || !_contextMenuEnabled)
         {
            _textField.contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT,buildContextMenu,false);
         }
         else
         {
            _textField.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,buildContextMenu,false,-1,true);
         }
      }
      
      public function get underlinePattern() : IBitmapDrawable
      {
         return underlineBmpd;
      }
   }
}
