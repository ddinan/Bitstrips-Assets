package com.gskinner.text
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextLineMetrics;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class TextHighlighter extends EventDispatcher
   {
       
      
      protected var _enabled:Boolean = true;
      
      protected var _updateOnValueCommit:Boolean = false;
      
      protected var _wordList:Array;
      
      protected var _target:Object;
      
      protected var _enableOnFocus:Boolean = false;
      
      protected var _ignoreCase:Boolean = true;
      
      protected var _textField:TextField;
      
      protected var validateTimer:Timer;
      
      protected var _ignoreSelectedWord:Boolean = true;
      
      protected var canvas:Sprite;
      
      protected var _entireWords:Boolean = true;
      
      protected var _color:uint = 1728052992;
      
      protected var _autoUpdate:Boolean = true;
      
      protected var valid:Boolean = false;
      
      public function TextHighlighter(param1:Object = null, param2:Array = null)
      {
         super();
         validateTimer = new Timer(5,1);
         validateTimer.addEventListener(TimerEvent.TIMER,validate,false,0,true);
         canvas = new Sprite();
         this.target = param1;
         this.wordList = param2;
      }
      
      protected function drawRectInXBounds(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:uint = 3) : void
      {
         var _loc10_:Number = Math.max(2,param1 - param5);
         var _loc11_:Number = Math.min(param6 - _loc10_,param3 - param5 - _loc10_);
         if(_loc11_ > 0)
         {
            drawRect(_loc10_,param2,_loc11_,param4,param7,param8,param9);
         }
      }
      
      protected function handleSelectionMouseDown(param1:MouseEvent) : void
      {
         _textField.stage.addEventListener(MouseEvent.MOUSE_UP,handleSelectionMouseUp,false,0,true);
         handleInvalidationEvent(param1);
      }
      
      public function set wordList(param1:Array) : void
      {
         _wordList = param1;
         invalidate();
      }
      
      public function get target() : Object
      {
         return _target;
      }
      
      protected function handleInvalidationEvent(param1:Event) : void
      {
         if(_autoUpdate)
         {
            invalidate();
         }
      }
      
      protected function validate(param1:TimerEvent) : void
      {
         validateTimer.reset();
         if(!valid)
         {
            draw();
         }
         valid = true;
      }
      
      public function set textField(param1:TextField) : void
      {
         setupListeners(true);
         if(canvas.parent)
         {
            canvas.parent.removeChild(canvas);
         }
         _textField = param1;
         _target = param1;
         setupListeners();
         invalidate();
      }
      
      public function set target(param1:Object) : void
      {
         var _loc2_:TextField = null;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:DisplayObject = null;
         setupListeners(true);
         if(param1 == null)
         {
            _textField = null;
         }
         else if(param1 is TextField)
         {
            _textField = param1 as TextField;
         }
         else if("textField" in param1 && param1["textField"] is TextField)
         {
            _textField = param1["textField"];
         }
         else if(param1 is DisplayObjectContainer)
         {
            _loc2_ = null;
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < param1.numChildren)
            {
               _loc5_ = param1.getChildAt(_loc4_) as TextField;
               if(_loc5_)
               {
                  if(_loc5_.width + _loc5_.height > _loc3_)
                  {
                     _loc2_ = _loc5_ as TextField;
                     _loc3_ = _loc5_.width + _loc5_.height;
                  }
               }
               _loc4_++;
            }
            _textField = _loc2_;
         }
         else
         {
            _textField = null;
         }
         _target = param1;
         setupListeners();
         invalidate();
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(_enabled == param1)
         {
            return;
         }
         _enabled = param1;
         setupListeners();
         invalidate();
      }
      
      public function set autoUpdate(param1:Boolean) : void
      {
         _autoUpdate = param1;
         setupListeners();
      }
      
      public function get enableOnFocus() : Boolean
      {
         return _enableOnFocus;
      }
      
      protected function checkWord(param1:String) : Boolean
      {
         return !!_wordList?_wordList.indexOf(param1) != -1:false;
      }
      
      protected function invalidate() : void
      {
         validateTimer.start();
         valid = false;
      }
      
      protected function handleSelectionMouseUp(param1:MouseEvent) : void
      {
         param1.target.removeEventListener(MouseEvent.MOUSE_UP,handleSelectionMouseUp);
         handleInvalidationEvent(param1);
      }
      
      public function set updateOnValueCommit(param1:Boolean) : void
      {
         _updateOnValueCommit = param1;
         setupListeners();
      }
      
      protected function draw() : void
      {
         var _loc19_:uint = 0;
         var _loc21_:uint = 0;
         var _loc22_:uint = 0;
         var _loc1_:uint = getTimer();
         clear();
         if(canvas.parent != null)
         {
            canvas.parent.removeChild(canvas);
         }
         var _loc2_:TextField = _textField;
         if(!_enabled || _loc2_ == null || _loc2_.parent == null)
         {
            return;
         }
         var _loc3_:uint = _loc2_.getLineOffset(_loc2_.scrollV - 1);
         var _loc4_:uint = _loc2_.getLineOffset(_loc2_.bottomScrollV - 1) + _loc2_.getLineLength(_loc2_.bottomScrollV - 1);
         var _loc5_:uint = _loc2_.selectionBeginIndex;
         var _loc6_:uint = _loc2_.selectionEndIndex;
         var _loc7_:Boolean = _ignoreSelectedWord && _loc2_.stage && _loc2_.stage.focus == _loc2_;
         _loc2_.parent.addChildAt(canvas,_loc2_.parent.getChildIndex(_loc2_));
         canvas.x = _loc2_.x;
         canvas.y = _loc2_.y;
         var _loc8_:Rectangle = _loc2_.getCharBoundaries(_loc3_);
         var _loc9_:int = 0;
         var _loc10_:uint = _loc2_.getLineIndexOfChar(_loc3_);
         while(_loc8_ == null)
         {
            if(++_loc19_ + _loc3_ >= _loc4_)
            {
               return;
            }
            _loc8_ = _loc2_.getCharBoundaries(_loc3_ + _loc19_);
            _loc21_ = _loc2_.getLineIndexOfChar(_loc3_ + _loc19_);
            if(_loc21_ > _loc10_)
            {
               _loc9_ = _loc9_ + _loc2_.getLineMetrics(_loc10_).height;
               _loc10_ = _loc21_;
            }
         }
         _loc9_ = _loc9_ - _loc8_.y;
         var _loc11_:uint = Math.max(0,_loc3_ - 40);
         var _loc12_:uint = Math.min(_loc2_.text.length,_loc4_ + 40);
         var _loc13_:String = _loc2_.text.substring(_loc11_,_loc12_);
         var _loc14_:Array = CharacterSet.wordCharSet;
         var _loc15_:Array = CharacterSet.innerWordCharSet;
         var _loc16_:Array = CharacterSet.invalidWordCharSet;
         var _loc17_:uint = _loc13_.length;
         var _loc18_:uint = 0;
         _loc19_ = 0;
         var _loc20_:uint = 0;
         while(_loc19_ < _loc17_)
         {
            _loc22_ = _loc13_.charCodeAt(_loc19_);
            if(_loc20_ == 0 && (_loc14_[_loc22_] || _loc16_[_loc22_]))
            {
               _loc18_ = _loc19_;
               _loc20_ = !!_loc14_[_loc22_]?uint(1):uint(2);
            }
            else if(_loc20_ > 0 && !_loc14_[_loc22_])
            {
               if(_loc15_[_loc22_])
               {
                  if(!_loc14_[_loc13_.charCodeAt(_loc19_ + 1)])
                  {
                     _loc20_ = _loc20_ == 1?uint(3):uint(0);
                  }
               }
               else
               {
                  _loc20_ = !!_loc16_[_loc22_]?uint(2):_loc20_ == 1?uint(3):uint(0);
               }
            }
            if(_loc20_ == 3)
            {
               if(checkWord(_loc13_.substring(_loc18_,_loc19_)) && (!_loc7_ || _loc18_ + _loc11_ > _loc6_ || _loc19_ + _loc11_ < _loc5_))
               {
                  drawHighlight(Math.max(_loc3_,_loc18_ + _loc11_),Math.min(_loc4_ - 1,_loc19_ + _loc11_ - 1),_loc9_);
               }
               _loc20_ = 0;
            }
            _loc19_++;
         }
         if(_loc20_ == 1)
         {
            if(checkWord(_loc13_.substring(_loc18_,_loc19_)) && (!_loc7_ || _loc18_ + _loc11_ > _loc6_ || _loc19_ + _loc11_ < _loc5_))
            {
               drawHighlight(Math.max(_loc3_,_loc18_ + _loc11_),Math.min(_loc4_ - 1,_loc19_ + _loc11_ - 1),_loc9_);
            }
         }
      }
      
      public function set color(param1:uint) : void
      {
         _color = param1;
         if(_color >> 24 == 0)
         {
            _color = 255 << 24 | _color;
         }
         invalidate();
      }
      
      public function update() : void
      {
         invalidate();
      }
      
      public function get textField() : TextField
      {
         return _textField;
      }
      
      public function drawHighlight(param1:int, param2:int, param3:Number = 0) : void
      {
         var _loc11_:Rectangle = null;
         var _loc12_:uint = 0;
         canvas.x = textField.x;
         canvas.y = textField.y;
         if(param2 < param1)
         {
            return;
         }
         var _loc4_:Rectangle = textField.getCharBoundaries(param1);
         while(_loc4_ == null && param1 < param2)
         {
            _loc4_ = textField.getCharBoundaries(++param1);
         }
         var _loc5_:Rectangle = textField.getCharBoundaries(param2);
         while(_loc5_ == null && param1 < param2)
         {
            _loc5_ = textField.getCharBoundaries(--param2);
         }
         var _loc6_:int = textField.getLineIndexOfChar(param1);
         var _loc7_:int = textField.getLineIndexOfChar(param2);
         if(_loc4_ == null || _loc5_ == null)
         {
            trace("Error: Could not find boundaries for \'" + textField.text.substring(param1,param2) + "\' beginIndex=" + param1 + " endIndex=" + param2);
            return;
         }
         var _loc8_:TextLineMetrics = textField.getLineMetrics(_loc6_);
         var _loc9_:Number = textField.scrollH;
         var _loc10_:Number = textField.width - 2;
         if(_loc6_ == _loc7_)
         {
            drawRectInXBounds(_loc4_.x,_loc4_.y + param3,_loc5_.x + _loc5_.width,_loc4_.height,_loc9_,_loc10_,_loc8_.ascent,_loc8_.descent,3);
         }
         else
         {
            _loc11_ = textField.getCharBoundaries(textField.getLineOffset(_loc6_) + textField.getLineLength(_loc6_) - 1);
            if(_loc11_ == null)
            {
               _loc11_ = textField.getCharBoundaries(textField.getLineOffset(_loc6_) + textField.getLineLength(_loc6_) - 2);
            }
            if(_loc11_)
            {
               drawRectInXBounds(_loc4_.x,_loc4_.y + param3,_loc11_.x + _loc11_.width,_loc4_.height,_loc9_,_loc10_,_loc8_.ascent,_loc8_.descent,1);
            }
            _loc11_ = textField.getCharBoundaries(textField.getLineOffset(_loc7_));
            _loc8_ = textField.getLineMetrics(_loc7_);
            if(_loc11_)
            {
               drawRectInXBounds(_loc11_.x,_loc11_.y + param3,_loc5_.x + _loc5_.width,_loc11_.height,_loc9_,_loc10_,_loc8_.ascent,_loc8_.descent,2);
            }
            _loc12_ = _loc6_;
            while(++_loc12_ < _loc7_)
            {
               _loc8_ = textField.getLineMetrics(_loc12_);
               if(_loc8_ != null)
               {
                  _loc4_ = textField.getCharBoundaries(textField.getLineOffset(_loc12_));
                  if(_loc4_ != null)
                  {
                     _loc5_ = textField.getCharBoundaries(textField.getLineOffset(_loc12_) + textField.getLineLength(_loc12_) - 1);
                     if(_loc5_ == null)
                     {
                        _loc5_ = textField.getCharBoundaries(textField.getLineOffset(_loc12_) + textField.getLineLength(_loc12_) - 2);
                     }
                     drawRectInXBounds(_loc4_.x,_loc4_.y + param3,_loc5_.x + _loc5_.width,_loc4_.height,_loc9_,_loc10_,_loc8_.ascent,_loc8_.descent,0);
                  }
               }
            }
         }
      }
      
      protected function setupListeners(param1:Boolean = false) : void
      {
         var _loc2_:EventDispatcher = _target as EventDispatcher;
         if(_loc2_)
         {
            if(param1 || !_enabled || !_autoUpdate)
            {
               _loc2_.removeEventListener(Event.RESIZE,handleInvalidationEvent);
            }
            else
            {
               _loc2_.addEventListener(Event.RESIZE,handleInvalidationEvent,false,1,true);
            }
            if(param1 || !_enabled || !_updateOnValueCommit)
            {
               _loc2_.removeEventListener("valueCommit",handleInvalidationEvent);
            }
            else
            {
               _loc2_.addEventListener("valueCommit",handleInvalidationEvent,false,1,true);
            }
         }
         if(_textField)
         {
            if(param1 || !_enableOnFocus)
            {
               _textField.removeEventListener(FocusEvent.FOCUS_IN,handleFocusEvent);
               _textField.removeEventListener(FocusEvent.FOCUS_OUT,handleFocusEvent);
            }
            else
            {
               _textField.addEventListener(FocusEvent.FOCUS_IN,handleFocusEvent,false,1,true);
               _textField.addEventListener(FocusEvent.FOCUS_OUT,handleFocusEvent,false,1,true);
            }
            if(param1 || !_enabled || !_autoUpdate)
            {
               _textField.removeEventListener(Event.SCROLL,handleInvalidationEvent);
               _textField.removeEventListener(Event.CHANGE,handleInvalidationEvent);
            }
            else
            {
               _textField.addEventListener(Event.SCROLL,handleInvalidationEvent,false,1,true);
               _textField.addEventListener(Event.CHANGE,handleInvalidationEvent,false,1,true);
            }
            if(param1 || !_ignoreSelectedWord)
            {
               _textField.removeEventListener(MouseEvent.MOUSE_DOWN,handleSelectionMouseDown);
               _textField.removeEventListener(KeyboardEvent.KEY_DOWN,handleInvalidationEvent);
               _textField.removeEventListener(FocusEvent.FOCUS_OUT,handleInvalidationEvent);
            }
            else
            {
               _textField.addEventListener(MouseEvent.MOUSE_DOWN,handleSelectionMouseDown,false,1,true);
               _textField.addEventListener(KeyboardEvent.KEY_DOWN,handleInvalidationEvent,false,1,true);
               _textField.addEventListener(FocusEvent.FOCUS_OUT,handleInvalidationEvent,false,1,true);
            }
         }
      }
      
      public function updateNow() : void
      {
         draw();
      }
      
      public function get wordList() : Array
      {
         return _wordList;
      }
      
      public function clear() : void
      {
         canvas.graphics.clear();
      }
      
      public function get autoUpdate() : Boolean
      {
         return _autoUpdate;
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      public function get updateOnValueCommit() : Boolean
      {
         return _updateOnValueCommit;
      }
      
      protected function drawRect(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:uint = 3) : void
      {
         canvas.graphics.beginFill(_color,(_color >>> 24) / 255);
         canvas.graphics.drawRoundRect(param1,param2 + param4 - param5,param3,param5 + param6,6);
      }
      
      public function set enableOnFocus(param1:Boolean) : void
      {
         _enableOnFocus = param1;
         setupListeners();
         if(_textField)
         {
            enabled = _textField.stage.focus == _textField;
         }
      }
      
      public function set ignoreSelectedWord(param1:Boolean) : void
      {
         _ignoreSelectedWord = param1;
         setupListeners();
      }
      
      public function get ignoreSelectedWord() : Boolean
      {
         return _ignoreSelectedWord;
      }
      
      protected function handleFocusEvent(param1:FocusEvent) : void
      {
         enabled = param1.type == FocusEvent.FOCUS_IN;
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
   }
}
