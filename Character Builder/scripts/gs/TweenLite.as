package gs
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class TweenLite
   {
      
      private static var _timer:Timer = new Timer(2000);
      
      private static var _classInitted:Boolean;
      
      public static var defaultEase:Function = TweenLite.easeOut;
      
      public static var version:Number = 8.16;
      
      protected static var _all:Dictionary = new Dictionary();
      
      private static var _sprite:Sprite = new Sprite();
      
      protected static var _curTime:uint;
      
      public static var overwriteManager:Object;
      
      public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
      
      private static var _listening:Boolean;
       
      
      public var delay:Number;
      
      protected var _hasUpdate:Boolean;
      
      protected var _subTweens:Array;
      
      protected var _initted:Boolean;
      
      public var startTime:int;
      
      public var target:Object;
      
      public var duration:Number;
      
      protected var _hst:Boolean;
      
      protected var _isDisplayObject:Boolean;
      
      protected var _active:Boolean;
      
      public var tweens:Array;
      
      public var vars:Object;
      
      public var initTime:int;
      
      protected var _timeScale:Number;
      
      public function TweenLite(param1:Object, param2:Number, param3:Object)
      {
         var _loc5_:* = undefined;
         super();
         if(param1 == null)
         {
            return;
         }
         if(!_classInitted)
         {
            _curTime = getTimer();
            _sprite.addEventListener(Event.ENTER_FRAME,executeAll);
            if(overwriteManager == null)
            {
               overwriteManager = {
                  "mode":1,
                  "enabled":false
               };
            }
            _classInitted = true;
         }
         this.vars = param3;
         this.duration = Number(param2) || Number(0.001);
         this.delay = Number(param3.delay) || Number(0);
         _timeScale = Number(param3.timeScale) || Number(1);
         _active = param2 == 0 && this.delay == 0;
         this.target = param1;
         _isDisplayObject = param1 is DisplayObject;
         if(!(this.vars.ease is Function))
         {
            this.vars.ease = defaultEase;
         }
         if(this.vars.easeParams != null)
         {
            this.vars.proxiedEase = this.vars.ease;
            this.vars.ease = easeProxy;
         }
         if(!isNaN(Number(this.vars.autoAlpha)))
         {
            this.vars.alpha = Number(this.vars.autoAlpha);
            this.vars.visible = this.vars.alpha > 0;
         }
         this.tweens = [];
         _subTweens = [];
         _hst = _initted = false;
         this.initTime = _curTime;
         this.startTime = this.initTime + this.delay * 1000;
         var _loc4_:int = param3.overwrite == undefined || !overwriteManager.enabled && param3.overwrite > 1?int(overwriteManager.mode):int(int(param3.overwrite));
         if(_all[param1] == undefined || param1 != null && _loc4_ == 1)
         {
            delete _all[param1];
            _all[param1] = new Dictionary(true);
         }
         else if(_loc4_ > 1 && this.delay == 0)
         {
            overwriteManager.manageOverwrites(this,_all[param1]);
         }
         _all[param1][this] = this;
         if(this.vars.runBackwards == true && this.vars.renderOnStart != true || _active)
         {
            initTweenVals();
            if(_active)
            {
               render(this.startTime + 1);
            }
            else
            {
               render(this.startTime);
            }
            _loc5_ = this.vars.visible;
            if(this.vars.isTV == true)
            {
               _loc5_ = this.vars.exposedProps.visible;
            }
            if(_loc5_ != null && this.vars.runBackwards == true && _isDisplayObject)
            {
               this.target.visible = Boolean(_loc5_);
            }
         }
         if(!_listening && !_active)
         {
            _timer.addEventListener("timer",killGarbage);
            _timer.start();
            _listening = true;
         }
      }
      
      public static function easeOut(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return -param3 * (param1 = param1 / param4) * (param1 - 2) + param2;
      }
      
      public static function frameProxy(param1:Object) : void
      {
         param1.info.target.gotoAndStop(Math.round(param1.target.frame));
      }
      
      public static function removeTween(param1:TweenLite = null) : void
      {
         if(param1 != null && _all[param1.target] != undefined)
         {
            _all[param1.target][param1] = null;
            delete _all[param1.target][param1];
         }
      }
      
      public static function killTweensOf(param1:Object = null, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         if(param1 != null && _all[param1] != undefined)
         {
            if(param2)
            {
               _loc3_ = _all[param1];
               for(_loc4_ in _loc3_)
               {
                  _loc3_[_loc4_].complete(false);
               }
            }
            delete _all[param1];
         }
      }
      
      public static function delayedCall(param1:Number, param2:Function, param3:Array = null) : TweenLite
      {
         return new TweenLite(param2,0,{
            "delay":param1,
            "onComplete":param2,
            "onCompleteParams":param3,
            "overwrite":0
         });
      }
      
      public static function from(param1:Object, param2:Number, param3:Object) : TweenLite
      {
         param3.runBackwards = true;
         return new TweenLite(param1,param2,param3);
      }
      
      public static function executeAll(param1:Event = null) : void
      {
         var _loc3_:Dictionary = null;
         var _loc4_:Object = null;
         var _loc5_:* = null;
         var _loc2_:uint = _curTime = getTimer();
         if(_listening)
         {
            _loc3_ = _all;
            for each(_loc4_ in _loc3_)
            {
               for(_loc5_ in _loc4_)
               {
                  if(_loc4_[_loc5_] != undefined && _loc4_[_loc5_].active)
                  {
                     _loc4_[_loc5_].render(_loc2_);
                  }
               }
            }
         }
      }
      
      public static function volumeProxy(param1:Object) : void
      {
         param1.info.target.soundTransform = param1.target;
      }
      
      public static function killGarbage(param1:TimerEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:Object = null;
         var _loc2_:uint = 0;
         for(_loc4_ in _all)
         {
            _loc3_ = false;
            for(_loc5_ in _all[_loc4_])
            {
               _loc3_ = true;
            }
            if(!_loc3_)
            {
               delete _all[_loc4_];
            }
            else
            {
               _loc2_++;
            }
         }
         if(_loc2_ == 0)
         {
            _timer.removeEventListener("timer",killGarbage);
            _timer.stop();
            _listening = false;
         }
      }
      
      public static function tintProxy(param1:Object) : void
      {
         var _loc2_:Number = param1.target.progress;
         var _loc3_:Number = 1 - _loc2_;
         var _loc4_:Object = param1.info.color;
         var _loc5_:Object = param1.info.endColor;
         param1.info.target.transform.colorTransform = new ColorTransform(_loc4_.redMultiplier * _loc3_ + _loc5_.redMultiplier * _loc2_,_loc4_.greenMultiplier * _loc3_ + _loc5_.greenMultiplier * _loc2_,_loc4_.blueMultiplier * _loc3_ + _loc5_.blueMultiplier * _loc2_,_loc4_.alphaMultiplier * _loc3_ + _loc5_.alphaMultiplier * _loc2_,_loc4_.redOffset * _loc3_ + _loc5_.redOffset * _loc2_,_loc4_.greenOffset * _loc3_ + _loc5_.greenOffset * _loc2_,_loc4_.blueOffset * _loc3_ + _loc5_.blueOffset * _loc2_,_loc4_.alphaOffset * _loc3_ + _loc5_.alphaOffset * _loc2_);
      }
      
      public static function to(param1:Object, param2:Number, param3:Object) : TweenLite
      {
         return new TweenLite(param1,param2,param3);
      }
      
      protected function addSubTween(param1:String, param2:Function, param3:Object, param4:Object, param5:Object = null) : void
      {
         var _loc7_:* = null;
         var _loc6_:Object = {
            "name":param1,
            "proxy":param2,
            "target":param3,
            "info":param5
         };
         _subTweens[_subTweens.length] = _loc6_;
         for(_loc7_ in param4)
         {
            if(typeof param4[_loc7_] == "number")
            {
               this.tweens[this.tweens.length] = {
                  "o":param3,
                  "p":_loc7_,
                  "s":param3[_loc7_],
                  "c":param4[_loc7_] - param3[_loc7_],
                  "sub":_loc6_,
                  "name":param1
               };
            }
            else
            {
               this.tweens[this.tweens.length] = {
                  "o":param3,
                  "p":_loc7_,
                  "s":param3[_loc7_],
                  "c":Number(param4[_loc7_]),
                  "sub":_loc6_,
                  "name":param1
               };
            }
         }
         _hst = true;
      }
      
      public function initTweenVals(param1:Boolean = false, param2:String = "") : void
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:ColorTransform = null;
         var _loc8_:ColorTransform = null;
         var _loc9_:Object = null;
         var _loc5_:Object = this.vars;
         if(_loc5_.isTV == true)
         {
            _loc5_ = _loc5_.exposedProps;
         }
         if(!param1 && this.delay != 0 && overwriteManager.enabled)
         {
            overwriteManager.manageOverwrites(this,_all[this.target]);
         }
         if(this.target is Array)
         {
            _loc6_ = this.vars.endArray || [];
            _loc4_ = 0;
            while(_loc4_ < _loc6_.length)
            {
               if(this.target[_loc4_] != _loc6_[_loc4_] && this.target[_loc4_] != undefined)
               {
                  this.tweens[this.tweens.length] = {
                     "o":this.target,
                     "p":_loc4_.toString(),
                     "s":this.target[_loc4_],
                     "c":_loc6_[_loc4_] - this.target[_loc4_],
                     "name":_loc4_.toString()
                  };
               }
               _loc4_++;
            }
         }
         else
         {
            if((typeof _loc5_.tint != "undefined" || this.vars.removeTint == true) && _isDisplayObject)
            {
               _loc7_ = this.target.transform.colorTransform;
               _loc8_ = new ColorTransform();
               if(_loc5_.alpha != undefined)
               {
                  _loc8_.alphaMultiplier = _loc5_.alpha;
                  delete _loc5_.alpha;
               }
               else
               {
                  _loc8_.alphaMultiplier = this.target.alpha;
               }
               if(this.vars.removeTint != true && (_loc5_.tint != null && _loc5_.tint != "" || _loc5_.tint == 0))
               {
                  _loc8_.color = _loc5_.tint;
               }
               addSubTween("tint",tintProxy,{"progress":0},{"progress":1},{
                  "target":this.target,
                  "color":_loc7_,
                  "endColor":_loc8_
               });
            }
            if(_loc5_.frame != null && _isDisplayObject)
            {
               addSubTween("frame",frameProxy,{"frame":this.target.currentFrame},{"frame":_loc5_.frame},{"target":this.target});
            }
            if(!isNaN(this.vars.volume) && this.target.hasOwnProperty("soundTransform"))
            {
               addSubTween("volume",volumeProxy,this.target.soundTransform,{"volume":this.vars.volume},{"target":this.target});
            }
            for(_loc3_ in _loc5_)
            {
               if(!(_loc3_ == "ease" || _loc3_ == "delay" || _loc3_ == "overwrite" || _loc3_ == "onComplete" || _loc3_ == "onCompleteParams" || _loc3_ == "runBackwards" || _loc3_ == "visible" || _loc3_ == "autoOverwrite" || _loc3_ == "persist" || _loc3_ == "onUpdate" || _loc3_ == "onUpdateParams" || _loc3_ == "autoAlpha" || _loc3_ == "timeScale" && !(this.target is TweenLite) || _loc3_ == "onStart" || _loc3_ == "onStartParams" || _loc3_ == "renderOnStart" || _loc3_ == "proxiedEase" || _loc3_ == "easeParams" || param1 && param2.indexOf(" " + _loc3_ + " ") != -1))
               {
                  if(!(_isDisplayObject && (_loc3_ == "tint" || _loc3_ == "removeTint" || _loc3_ == "frame")) && !(_loc3_ == "volume" && this.target.hasOwnProperty("soundTransform")))
                  {
                     if(typeof _loc5_[_loc3_] == "number")
                     {
                        this.tweens[this.tweens.length] = {
                           "o":this.target,
                           "p":_loc3_,
                           "s":this.target[_loc3_],
                           "c":_loc5_[_loc3_] - this.target[_loc3_],
                           "name":_loc3_
                        };
                     }
                     else
                     {
                        this.tweens[this.tweens.length] = {
                           "o":this.target,
                           "p":_loc3_,
                           "s":this.target[_loc3_],
                           "c":Number(_loc5_[_loc3_]),
                           "name":_loc3_
                        };
                     }
                  }
               }
            }
         }
         if(this.vars.runBackwards == true)
         {
            _loc4_ = this.tweens.length - 1;
            while(_loc4_ > -1)
            {
               _loc9_ = this.tweens[_loc4_];
               _loc9_.s = _loc9_.s + _loc9_.c;
               _loc9_.c = _loc9_.c * -1;
               _loc4_--;
            }
         }
         if(_loc5_.visible == true && _isDisplayObject)
         {
            this.target.visible = true;
         }
         if(this.vars.onUpdate != null)
         {
            _hasUpdate = true;
         }
         _initted = true;
      }
      
      public function get active() : Boolean
      {
         if(_active)
         {
            return true;
         }
         if(_curTime >= this.startTime)
         {
            _active = true;
            if(!_initted)
            {
               initTweenVals();
            }
            else if(this.vars.visible != undefined && _isDisplayObject)
            {
               this.target.visible = true;
            }
            if(this.vars.onStart != null)
            {
               this.vars.onStart.apply(null,this.vars.onStartParams);
            }
            if(this.duration == 0.001)
            {
               this.startTime = this.startTime - 1;
            }
            return true;
         }
         return false;
      }
      
      public function render(param1:uint) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc2_:Number = (param1 - this.startTime) / 1000;
         if(_loc2_ >= this.duration)
         {
            _loc2_ = this.duration;
            _loc3_ = 1;
         }
         else
         {
            _loc3_ = this.vars.ease(_loc2_,0,1,this.duration);
         }
         _loc5_ = this.tweens.length - 1;
         while(_loc5_ > -1)
         {
            _loc4_ = this.tweens[_loc5_];
            _loc4_.o[_loc4_.p] = _loc4_.s + _loc3_ * _loc4_.c;
            _loc5_--;
         }
         if(_hst)
         {
            _loc5_ = _subTweens.length - 1;
            while(_loc5_ > -1)
            {
               _subTweens[_loc5_].proxy(_subTweens[_loc5_]);
               _loc5_--;
            }
         }
         if(_hasUpdate)
         {
            this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         if(_loc2_ == this.duration)
         {
            complete(true);
         }
      }
      
      protected function easeProxy(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return this.vars.proxiedEase.apply(null,arguments.concat(this.vars.easeParams));
      }
      
      public function killVars(param1:Object) : void
      {
         if(overwriteManager.enabled)
         {
            overwriteManager.killVars(param1,this.vars,this.tweens,_subTweens,[]);
         }
      }
      
      public function complete(param1:Boolean = false) : void
      {
         if(!param1)
         {
            if(!_initted)
            {
               initTweenVals();
            }
            this.startTime = _curTime - this.duration * 1000 / _timeScale;
            render(_curTime);
            return;
         }
         if(this.vars.visible != undefined && _isDisplayObject)
         {
            if(!isNaN(this.vars.autoAlpha) && this.target.alpha == 0)
            {
               this.target.visible = false;
            }
            else if(this.vars.runBackwards != true)
            {
               this.target.visible = this.vars.visible;
            }
         }
         if(this.vars.persist != true)
         {
            removeTween(this);
         }
         if(this.vars.onComplete != null)
         {
            this.vars.onComplete.apply(null,this.vars.onCompleteParams);
         }
      }
   }
}
