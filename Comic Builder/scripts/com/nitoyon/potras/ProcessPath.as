package com.nitoyon.potras
{
   import flash.geom.Point;
   
   public class ProcessPath
   {
      
      private static const INFTY:int = 10000000;
      
      public static const POTRACE_CURVETO:int = 1;
      
      public static const POTRACE_CORNER:int = 2;
       
      
      public function ProcessPath()
      {
         super();
      }
      
      public static function processPath(param1:Array) : ClosedPathList
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:ClosedPath = null;
         var _loc2_:ClosedPathList = new ClosedPathList();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = ProcessPath.calcSums(param1[_loc3_].priv as Array) as Array;
            _loc5_ = ProcessPath.calcLon(param1[_loc3_].priv as Array);
            _loc6_ = ProcessPath.bestPolygon(param1[_loc3_].priv as Array,_loc5_,_loc4_);
            _loc7_ = ProcessPath.adjustVertices(param1[_loc3_].priv as Array,_loc4_,_loc6_);
            _loc8_ = ProcessPath.smooth(_loc7_,param1[_loc3_].sign,0.9);
            _loc2_.$a.push(_loc8_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function calcSums(param1:Array) : Array
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:int = param1.length;
         var _loc3_:Array = new Array(_loc2_ + 1);
         var _loc4_:int = param1[0].x;
         var _loc5_:int = param1[0].y;
         _loc3_[0] = new Sums();
         _loc3_[0].x2 = _loc3_[0].xy = _loc3_[0].y2 = _loc3_[0].x = _loc3_[0].y = 0;
         var _loc6_:int = 0;
         while(_loc6_ < _loc2_)
         {
            _loc7_ = param1[_loc6_].x - _loc4_;
            _loc8_ = param1[_loc6_].y - _loc5_;
            _loc3_[_loc6_ + 1] = new Sums();
            _loc3_[_loc6_ + 1].x = _loc3_[_loc6_].x + _loc7_;
            _loc3_[_loc6_ + 1].y = _loc3_[_loc6_].y + _loc8_;
            _loc3_[_loc6_ + 1].x2 = _loc3_[_loc6_].x2 + _loc7_ * _loc7_;
            _loc3_[_loc6_ + 1].xy = _loc3_[_loc6_].xy + _loc7_ * _loc8_;
            _loc3_[_loc6_ + 1].y2 = _loc3_[_loc6_].y2 + _loc8_ * _loc8_;
            _loc6_++;
         }
         return _loc3_;
      }
      
      public static function calcLon(param1:Array) : Array
      {
         var _loc4_:Number = NaN;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc17_:Boolean = false;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:int = param1.length;
         var _loc5_:Array = [];
         var _loc6_:int = 0;
         var _loc7_:int = _loc3_ - 1;
         while(_loc7_ >= 0)
         {
            if(param1[_loc7_].x != param1[_loc6_].x && param1[_loc7_].y != param1[_loc6_].y)
            {
               _loc6_ = _loc7_ + 1;
            }
            _loc5_[_loc7_] = _loc6_;
            _loc7_--;
         }
         var _loc8_:Array = [];
         var _loc12_:Point = new Point();
         var _loc13_:Point = new Point();
         var _loc14_:Point = new Point();
         var _loc15_:Point = new Point();
         var _loc16_:Point = new Point();
         _loc7_ = _loc3_ - 1;
         while(_loc7_ >= 0)
         {
            _loc9_ = [0,0,0,0];
            _loc10_ = (3 + 3 * (param1[mod(_loc7_ + 1,_loc3_)].x - param1[_loc7_].x) + (param1[mod(_loc7_ + 1,_loc3_)].y - param1[_loc7_].y)) / 2;
            _loc9_[_loc10_]++;
            _loc12_.x = _loc12_.y = _loc13_.x = _loc13_.y = 0;
            _loc6_ = _loc5_[_loc7_];
            _loc11_ = _loc7_;
            _loc17_ = false;
            do
            {
               _loc10_ = (3 + 3 * sign(param1[_loc6_].x - param1[_loc11_].x) + sign(param1[_loc6_].y - param1[_loc11_].y)) / 2;
               _loc9_[_loc10_]++;
               if(_loc9_[0] && _loc9_[1] && _loc9_[2] && _loc9_[3])
               {
                  _loc8_[_loc7_] = _loc11_;
                  _loc17_ = true;
                  break;
               }
               _loc14_.x = param1[_loc6_].x - param1[_loc7_].x;
               _loc14_.y = param1[_loc6_].y - param1[_loc7_].y;
               if(xprod(_loc12_,_loc14_) > 0 || xprod(_loc13_,_loc14_) < 0)
               {
                  break;
               }
               if(!(Math.abs(_loc14_.x) <= 1 && Math.abs(_loc14_.y) <= 1))
               {
                  _loc15_.x = _loc14_.x + (-_loc14_.y >= 0 && (-_loc14_.y > 0 || _loc14_.x < 0)?1:-1);
                  _loc15_.y = _loc14_.y + (-_loc14_.x <= 0 && (-_loc14_.x < 0 || _loc14_.y < 0)?1:-1);
                  if(xprod(_loc12_,_loc15_) <= 0)
                  {
                     _loc12_.x = _loc15_.x;
                     _loc12_.y = _loc15_.y;
                  }
                  _loc15_.x = _loc14_.x + (-_loc14_.y <= 0 && (-_loc14_.y < 0 || _loc14_.x < 0)?1:-1);
                  _loc15_.y = _loc14_.y + (-_loc14_.x >= 0 && (-_loc14_.x > 0 || _loc14_.y < 0)?1:-1);
                  if(xprod(_loc13_,_loc15_) >= 0)
                  {
                     _loc13_.x = _loc15_.x;
                     _loc13_.y = _loc15_.y;
                  }
               }
               _loc11_ = _loc6_;
               _loc6_ = _loc5_[_loc11_];
            }
            while(cyclic(_loc6_,_loc7_,_loc11_));
            
            if(!_loc17_)
            {
               _loc16_.x = sign(param1[_loc6_].x - param1[_loc11_].x);
               _loc16_.y = sign(param1[_loc6_].y - param1[_loc11_].y);
               _loc14_.x = param1[_loc11_].x - param1[_loc7_].x;
               _loc14_.y = param1[_loc11_].y - param1[_loc7_].y;
               _loc18_ = xprod(_loc12_,_loc14_);
               _loc19_ = xprod(_loc12_,_loc16_);
               _loc20_ = xprod(_loc13_,_loc14_);
               _loc21_ = xprod(_loc13_,_loc16_);
               _loc4_ = INFTY;
               if(_loc19_ > 0)
               {
                  _loc4_ = floordiv(-_loc18_,_loc19_);
               }
               if(_loc21_ < 0)
               {
                  _loc4_ = Math.min(_loc4_,floordiv(_loc20_,-_loc21_));
               }
               _loc8_[_loc7_] = mod(_loc11_ + _loc4_,_loc3_);
            }
            _loc7_--;
         }
         _loc4_ = _loc8_[_loc3_ - 1];
         _loc2_[_loc3_ - 1] = _loc4_;
         _loc7_ = _loc3_ - 2;
         while(_loc7_ >= 0)
         {
            if(cyclic(_loc7_ + 1,_loc8_[_loc7_],_loc4_))
            {
               _loc4_ = _loc8_[_loc7_];
            }
            _loc2_[_loc7_] = _loc4_;
            _loc7_--;
         }
         _loc7_ = _loc3_ - 1;
         while(cyclic(mod(_loc7_ + 1,_loc3_),_loc4_,_loc2_[_loc7_]))
         {
            _loc2_[_loc7_] = _loc4_;
            _loc7_--;
         }
         return _loc2_;
      }
      
      public static function bestPolygon(param1:Array, param2:Array, param3:Array) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc15_:Number = NaN;
         var _loc17_:int = 0;
         var _loc18_:Number = NaN;
         var _loc7_:int = param1.length;
         var _loc8_:Array = new Array(_loc7_);
         var _loc9_:Array = new Array(_loc7_ + 1);
         _loc4_ = 0;
         while(_loc4_ < _loc7_)
         {
            _loc17_ = mod(param2[mod(_loc4_ - 1,_loc7_)] - 1,_loc7_);
            if(_loc17_ == _loc4_)
            {
               _loc17_ = mod(_loc4_ + 1,_loc7_);
            }
            if(_loc17_ < _loc4_)
            {
               _loc8_[_loc4_] = _loc7_;
            }
            else
            {
               _loc8_[_loc4_] = _loc17_;
            }
            _loc4_++;
         }
         _loc5_ = 1;
         _loc4_ = 0;
         while(_loc4_ < _loc7_)
         {
            while(_loc5_ <= _loc8_[_loc4_])
            {
               _loc9_[_loc5_] = _loc4_;
               _loc5_++;
            }
            _loc4_++;
         }
         var _loc10_:Array = new Array(_loc7_ + 1);
         var _loc11_:Array = new Array(_loc7_ + 1);
         _loc4_ = 0;
         _loc5_ = 0;
         while(_loc4_ < _loc7_)
         {
            _loc10_[_loc5_] = _loc4_;
            _loc4_ = _loc8_[_loc4_];
            _loc5_++;
         }
         _loc10_[_loc5_] = _loc7_;
         var _loc12_:int = _loc5_;
         _loc4_ = _loc7_;
         _loc5_ = _loc12_;
         while(_loc5_ > 0)
         {
            _loc11_[_loc5_] = _loc4_;
            _loc4_ = _loc9_[_loc4_];
            _loc5_--;
         }
         _loc11_[0] = 0;
         var _loc13_:Array = new Array(_loc7_ + 1);
         var _loc14_:Array = new Array(_loc7_ + 1);
         _loc13_[0] = 0;
         _loc5_ = 1;
         while(_loc5_ <= _loc12_)
         {
            _loc4_ = _loc11_[_loc5_];
            while(_loc4_ <= _loc10_[_loc5_])
            {
               _loc18_ = -1;
               _loc6_ = _loc10_[_loc5_ - 1];
               while(_loc6_ >= _loc9_[_loc4_])
               {
                  _loc15_ = penalty3(param1,_loc6_,_loc4_,param3) + _loc13_[_loc6_];
                  if(_loc18_ < 0 || _loc15_ < _loc18_)
                  {
                     _loc14_[_loc4_] = _loc6_;
                     _loc18_ = _loc15_;
                  }
                  _loc6_--;
               }
               _loc13_[_loc4_] = _loc18_;
               _loc4_++;
            }
            _loc5_++;
         }
         var _loc16_:Array = new Array(_loc12_);
         _loc4_ = _loc7_;
         _loc5_ = _loc12_ - 1;
         while(_loc4_ > 0)
         {
            _loc16_[_loc5_] = _loc4_ = _loc14_[_loc4_];
            _loc5_--;
         }
         return _loc16_;
      }
      
      private static function penalty3(param1:Array, param2:int, param3:int, param4:Array) : Number
      {
         var _loc5_:int = param1.length;
         var _loc6_:int = 0;
         if(param3 >= _loc5_)
         {
            param3 = param3 - _loc5_;
            _loc6_ = _loc6_ + 1;
         }
         var _loc7_:Number = param4[param3 + 1].x - param4[param2].x + _loc6_ * param4[_loc5_].x;
         var _loc8_:Number = param4[param3 + 1].y - param4[param2].y + _loc6_ * param4[_loc5_].y;
         var _loc9_:Number = param4[param3 + 1].x2 - param4[param2].x2 + _loc6_ * param4[_loc5_].x2;
         var _loc10_:Number = param4[param3 + 1].xy - param4[param2].xy + _loc6_ * param4[_loc5_].xy;
         var _loc11_:Number = param4[param3 + 1].y2 - param4[param2].y2 + _loc6_ * param4[_loc5_].y2;
         var _loc12_:Number = param3 + 1 - param2 + _loc6_ * _loc5_;
         var _loc13_:Number = (param1[param2].x + param1[param3].x) / 2 - param1[0].x;
         var _loc14_:Number = (param1[param2].y + param1[param3].y) / 2 - param1[0].y;
         var _loc15_:Number = param1[param3].x - param1[param2].x;
         var _loc16_:Number = -(param1[param3].y - param1[param2].y);
         var _loc17_:Number = (_loc9_ - 2 * _loc7_ * _loc13_) / _loc12_ + _loc13_ * _loc13_;
         var _loc18_:Number = (_loc10_ - _loc7_ * _loc14_ - _loc8_ * _loc13_) / _loc12_ + _loc13_ * _loc14_;
         var _loc19_:Number = (_loc11_ - 2 * _loc8_ * _loc14_) / _loc12_ + _loc14_ * _loc14_;
         var _loc20_:Number = _loc16_ * _loc16_ * _loc17_ + 2 * _loc16_ * _loc15_ * _loc18_ + _loc15_ * _loc15_ * _loc19_;
         return Math.sqrt(_loc20_);
      }
      
      public static function adjustVertices(param1:Array, param2:Array, param3:Array) : Array
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc20_:Number = NaN;
         var _loc21_:int = 0;
         var _loc22_:QuadraticForm = null;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc4_:int = param3.length;
         var _loc5_:int = param1.length;
         var _loc10_:Array = [];
         var _loc11_:Point3D = new Point3D();
         var _loc12_:Point = new Point();
         var _loc13_:Point = new Point();
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = param3[(_loc6_ + 1) % _loc4_];
            _loc7_ = mod(_loc7_ - param3[_loc6_],_loc5_) + param3[_loc6_];
            _loc12_.x = _loc12_.y = _loc13_.x = _loc13_.y = 0;
            pointslope(param1,param2,param3[_loc6_],_loc7_,_loc12_,_loc13_);
            _loc10_[_loc6_] = new QuadraticForm();
            _loc20_ = _loc13_.x * _loc13_.x + _loc13_.y * _loc13_.y;
            if(_loc20_ != 0)
            {
               _loc11_[0] = _loc13_.y;
               _loc11_[1] = -_loc13_.x;
               _loc11_[2] = -_loc11_[1] * _loc12_.y - _loc11_[0] * _loc12_.x;
               _loc10_[_loc6_].fromVectorMultiply(_loc11_).scalar(1 / _loc20_);
            }
            _loc6_++;
         }
         var _loc14_:Array = [];
         var _loc15_:Point = param1[0].clone();
         var _loc16_:Point = new Point();
         var _loc17_:Point = new Point();
         var _loc18_:QuadraticForm = new QuadraticForm();
         var _loc19_:Point = new Point();
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc14_[_loc6_] = new Point();
            _loc16_.x = param1[param3[_loc6_]].x - _loc15_.x;
            _loc16_.y = param1[param3[_loc6_]].y - _loc15_.y;
            _loc7_ = mod(_loc6_ - 1,_loc4_);
            _loc22_ = _loc10_[_loc7_].clone().add(_loc10_[_loc6_]);
            while(1)
            {
               _loc27_ = _loc22_[0][0] * _loc22_[1][1] - _loc22_[0][1] * _loc22_[1][0];
               if(_loc27_ != 0)
               {
                  _loc17_.x = (-_loc22_[0][2] * _loc22_[1][1] + _loc22_[1][2] * _loc22_[0][1]) / _loc27_;
                  _loc17_.y = (_loc22_[0][2] * _loc22_[1][0] - _loc22_[1][2] * _loc22_[0][0]) / _loc27_;
                  break;
               }
               if(_loc22_[0][0] > _loc22_[1][1])
               {
                  _loc11_[0] = -_loc22_[0][1];
                  _loc11_[1] = _loc22_[0][0];
               }
               else if(_loc22_[1][1])
               {
                  _loc11_[0] = -_loc22_[1][1];
                  _loc11_[1] = _loc22_[1][0];
               }
               else
               {
                  _loc11_[0] = 1;
                  _loc11_[1] = 0;
               }
               _loc28_ = _loc11_[0] * _loc11_[0] + _loc11_[1] * _loc11_[1];
               _loc11_[2] = -_loc11_[1] * _loc16_.y - _loc11_[0] * _loc16_.x;
               _loc22_.add(_loc18_.fromVectorMultiply(_loc11_)).scalar(1 / _loc28_);
            }
            _loc23_ = Math.abs(_loc17_.x - _loc16_.x);
            _loc24_ = Math.abs(_loc17_.y - _loc16_.y);
            if(_loc23_ <= 0.5 && _loc24_ <= 0.5)
            {
               _loc14_[_loc6_].x = _loc17_.x + _loc15_.x;
               _loc14_[_loc6_].y = _loc17_.y + _loc15_.y;
            }
            else
            {
               _loc19_.x = _loc16_.x;
               _loc19_.y = _loc16_.y;
               _loc25_ = _loc22_.apply(_loc16_);
               if(_loc22_[0][0] != 0)
               {
                  _loc21_ = 0;
                  while(_loc21_ < 2)
                  {
                     _loc17_.y = _loc16_.y - 0.5 + _loc21_;
                     _loc17_.x = -(_loc22_[0][1] * _loc17_.y + _loc22_[0][2]) / _loc22_[0][0];
                     _loc23_ = _loc17_.x - _loc16_.x > 0?Number(_loc17_.x - _loc16_.x):Number(_loc16_.x - _loc17_.x);
                     _loc26_ = _loc22_.apply(_loc17_);
                     if(_loc23_ <= 0.5 && _loc26_ < _loc25_)
                     {
                        _loc25_ = _loc26_;
                        _loc19_.x = _loc17_.x;
                        _loc19_.y = _loc17_.y;
                     }
                     _loc21_++;
                  }
               }
               if(_loc22_[1][1] != 0)
               {
                  _loc21_ = 0;
                  while(_loc21_ < 2)
                  {
                     _loc17_.x = _loc16_.x - 0.5 + _loc21_;
                     _loc17_.y = -(_loc22_[1][0] * _loc17_.x + _loc22_[1][2]) / _loc22_[1][1];
                     _loc24_ = _loc17_.y - _loc16_.y > 0?Number(_loc17_.y - _loc16_.y):Number(_loc16_.y - _loc17_.y);
                     _loc26_ = _loc22_.apply(_loc17_);
                     if(_loc24_ <= 0.5 && _loc26_ < _loc25_)
                     {
                        _loc25_ = _loc26_;
                        _loc19_.x = _loc17_.x;
                        _loc19_.y = _loc17_.y;
                     }
                     _loc21_++;
                  }
               }
               _loc9_ = 0;
               while(_loc9_ < 2)
               {
                  _loc8_ = 0;
                  while(_loc8_ < 2)
                  {
                     _loc17_.x = _loc16_.x - 0.5 + _loc9_;
                     _loc17_.y = _loc16_.y - 0.5 + _loc8_;
                     _loc26_ = _loc22_.apply(_loc17_);
                     if(_loc26_ < _loc25_)
                     {
                        _loc25_ = _loc26_;
                        _loc19_.x = _loc17_.x;
                        _loc19_.y = _loc17_.y;
                     }
                     _loc8_++;
                  }
                  _loc9_++;
               }
               _loc14_[_loc6_].x = _loc19_.x + _loc15_.x;
               _loc14_[_loc6_].y = _loc19_.y + _loc15_.y;
            }
            _loc6_++;
         }
         return _loc14_;
      }
      
      public static function smooth(param1:Array, param2:String, param3:Number = 1.0) : ClosedPath
      {
         var _loc6_:int = 0;
         var _loc10_:Point = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Curve = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc4_:int = param1.length;
         var _loc5_:ClosedPath = new ClosedPath();
         if(param2 == "-")
         {
            _loc6_ = 0;
            _loc11_ = _loc4_ - 1;
            while(_loc6_ < _loc11_)
            {
               _loc10_ = param1[_loc6_];
               param1[_loc6_] = param1[_loc11_];
               param1[_loc11_] = _loc10_;
               _loc6_++;
               _loc11_--;
            }
         }
         var _loc7_:Point = new Point();
         var _loc8_:Point = new Point();
         var _loc9_:Point = new Point();
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc11_ = (_loc6_ + 1) % _loc4_;
            _loc12_ = (_loc6_ + 2) % _loc4_;
            interval(1 / 2,param1[_loc12_],param1[_loc11_],_loc9_);
            _loc13_ = new Curve();
            _loc13_.vertex.x = param1[_loc11_].x;
            _loc13_.vertex.y = param1[_loc11_].y;
            _loc14_ = ddenom(param1[_loc6_],param1[_loc12_]);
            if(_loc14_ != 0)
            {
               _loc16_ = dpara(param1[_loc6_],param1[_loc11_],param1[_loc12_]) / _loc14_;
               _loc16_ = _loc16_ < 0?Number(-_loc16_):Number(_loc16_);
               _loc15_ = _loc16_ > 1?Number((1 - 1 / _loc16_) / 0.75):Number(0);
            }
            else
            {
               _loc15_ = 4 / 3;
            }
            _loc13_.alpha0 = _loc15_;
            if(_loc15_ > param3)
            {
               _loc13_.tag = POTRACE_CORNER;
               _loc13_.c[0].x = 0;
               _loc13_.c[0].y = 0;
               _loc13_.c[1].x = param1[_loc11_].x;
               _loc13_.c[1].y = param1[_loc11_].y;
               _loc13_.c[2].x = _loc9_.x;
               _loc13_.c[2].y = _loc9_.y;
            }
            else
            {
               if(_loc15_ < 0.55)
               {
                  _loc15_ = 0.55;
               }
               else if(_loc15_ > 1)
               {
                  _loc15_ = 1;
               }
               interval(0.5 + 0.5 * _loc15_,param1[_loc6_],param1[_loc11_],_loc7_);
               interval(0.5 + 0.5 * _loc15_,param1[_loc12_],param1[_loc11_],_loc8_);
               _loc13_.tag = POTRACE_CURVETO;
               _loc13_.c[0].x = _loc7_.x;
               _loc13_.c[0].y = _loc7_.y;
               _loc13_.c[1].x = _loc8_.x;
               _loc13_.c[1].y = _loc8_.y;
               _loc13_.c[2].x = _loc9_.x;
               _loc13_.c[2].y = _loc9_.y;
            }
            _loc13_.alpha = _loc15_;
            _loc13_.beta = 0.5;
            _loc5_.$a[_loc11_] = _loc13_;
            _loc6_++;
         }
         return _loc5_;
      }
      
      public static function pointslope(param1:Array, param2:Array, param3:int, param4:int, param5:Point, param6:Point) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc7_:int = param1.length;
         var _loc19_:int = 0;
         while(param4 >= _loc7_)
         {
            param4 = param4 - _loc7_;
            _loc19_ = _loc19_ + 1;
         }
         while(param3 >= _loc7_)
         {
            param3 = param3 - _loc7_;
            _loc19_--;
         }
         while(param4 < 0)
         {
            param4 = param4 + _loc7_;
            _loc19_--;
         }
         while(param3 < 0)
         {
            param3 = param3 + _loc7_;
            _loc19_ = _loc19_ + 1;
         }
         _loc8_ = param2[param4 + 1].x - param2[param3].x + _loc19_ * param2[_loc7_].x;
         _loc9_ = param2[param4 + 1].y - param2[param3].y + _loc19_ * param2[_loc7_].y;
         _loc10_ = param2[param4 + 1].x2 - param2[param3].x2 + _loc19_ * param2[_loc7_].x2;
         _loc11_ = param2[param4 + 1].xy - param2[param3].xy + _loc19_ * param2[_loc7_].xy;
         _loc12_ = param2[param4 + 1].y2 - param2[param3].y2 + _loc19_ * param2[_loc7_].y2;
         _loc13_ = param4 + 1 - param3 + _loc19_ * _loc7_;
         param5.x = _loc8_ / _loc13_;
         param5.y = _loc9_ / _loc13_;
         _loc14_ = (_loc10_ - _loc8_ * _loc8_ / _loc13_) / _loc13_;
         _loc15_ = (_loc11_ - _loc8_ * _loc9_ / _loc13_) / _loc13_;
         _loc16_ = (_loc12_ - _loc9_ * _loc9_ / _loc13_) / _loc13_;
         _loc17_ = (_loc14_ + _loc16_ + Math.sqrt((_loc14_ - _loc16_) * (_loc14_ - _loc16_) + 4 * _loc15_ * _loc15_)) / 2;
         _loc14_ = _loc14_ - _loc17_;
         _loc16_ = _loc16_ - _loc17_;
         if(Math.abs(_loc14_) >= Math.abs(_loc16_))
         {
            _loc18_ = Math.sqrt(_loc14_ * _loc14_ + _loc15_ * _loc15_);
            if(_loc18_ != 0)
            {
               param6.x = -_loc15_ / _loc18_;
               param6.y = _loc14_ / _loc18_;
            }
         }
         else
         {
            _loc18_ = Math.sqrt(_loc16_ * _loc16_ + _loc15_ * _loc15_);
            if(_loc18_ != 0)
            {
               param6.x = -_loc16_ / _loc18_;
               param6.y = _loc15_ / _loc18_;
            }
         }
         if(_loc18_ == 0)
         {
            param6.x = param6.y = 0;
         }
      }
      
      public static function interval(param1:Number, param2:Point, param3:Point, param4:Point) : void
      {
         param4.x = param2.x + param1 * (param3.x - param2.x);
         param4.y = param2.y + param1 * (param3.y - param2.y);
      }
      
      private static function mod(param1:int, param2:int) : int
      {
         return param1 >= param2?int(param1 % param2):param1 >= 0?int(param1):int(param2 - 1 - (-1 - param1) % param2);
      }
      
      private static function floordiv(param1:int, param2:int) : int
      {
         return param1 >= 0?int(param1 / param2):int(-1 - (-1 - param1) / param2);
      }
      
      private static function xprod(param1:Point, param2:Point) : int
      {
         return param1.x * param2.y - param1.y * param2.x;
      }
      
      private static function sign(param1:Number) : int
      {
         return param1 > 0?1:param1 < 0?-1:0;
      }
      
      public static function dorth_infty(param1:Point, param2:Point) : Point
      {
         return new Point(sign(param2.x - param1.x),-sign(param2.y - param1.y));
      }
      
      public static function dpara(param1:Point, param2:Point, param3:Point) : Number
      {
         var _loc4_:Number = param2.x - param1.x;
         var _loc5_:Number = param2.y - param1.y;
         var _loc6_:Number = param3.x - param1.x;
         var _loc7_:Number = param3.y - param1.y;
         return _loc4_ * _loc7_ - _loc6_ * _loc5_;
      }
      
      public static function ddenom(param1:Point, param2:Point) : Number
      {
         var _loc3_:Point = dorth_infty(param1,param2);
         return _loc3_.y * (param2.x - param1.x) - _loc3_.x * (param2.y - param1.y);
      }
      
      private static function cyclic(param1:int, param2:int, param3:int) : Boolean
      {
         if(param1 <= param3)
         {
            return param1 <= param2 && param2 < param3;
         }
         return param1 <= param2 || param2 < param3;
      }
   }
}

class Sums
{
    
   
   public var x:Number;
   
   public var y:Number;
   
   public var x2:Number;
   
   public var xy:Number;
   
   public var y2:Number;
   
   function Sums()
   {
      super();
   }
}

import flash.errors.IllegalOperationError;
import flash.utils.Proxy;
import flash.utils.flash_proxy;

class Point3D extends Proxy
{
    
   
   private var $v:Array;
   
   function Point3D(param1:Number = 0.0, param2:Number = 0.0, param3:Number = 0.0)
   {
      super();
      this.$v = [param1,param2,param3];
   }
   
   override flash_proxy function getProperty(param1:*) : *
   {
      if(param1 == 0 || param1 == "x")
      {
         return this.$v[0];
      }
      if(param1 == 1 || param1 == "y")
      {
         return this.$v[1];
      }
      if(param1 == 2 || param1 == "z")
      {
         return this.$v[2];
      }
      return undefined;
   }
   
   override flash_proxy function hasProperty(param1:*) : Boolean
   {
      return flash_proxy.getProperty(param1) != undefined;
   }
   
   override flash_proxy function setProperty(param1:*, param2:*) : void
   {
      if(param1 == 0 || param1 == "x")
      {
         this.$v[0] = Number(param2);
         return;
      }
      if(param1 == 1 || param1 == "y")
      {
         this.$v[1] = Number(param2);
         return;
      }
      if(param1 == 2 || param1 == "z")
      {
         this.$v[2] = Number(param2);
         return;
      }
      throw new IllegalOperationError();
   }
   
   public function toString() : String
   {
      return "(" + this.$v[0] + "," + this.$v[1] + "," + this.$v[2] + ")";
   }
}

import flash.errors.IllegalOperationError;
import flash.geom.Point;
import flash.utils.Proxy;
import flash.utils.flash_proxy;

class QuadraticForm extends Proxy
{
    
   
   private var $m:Array;
   
   function QuadraticForm()
   {
      super();
      this.$m = [];
      this.$m[0] = new Point3D();
      this.$m[1] = new Point3D();
      this.$m[2] = new Point3D();
   }
   
   override flash_proxy function getProperty(param1:*) : *
   {
      if(param1 == 0)
      {
         return this.$m[0];
      }
      if(param1 == 1)
      {
         return this.$m[1];
      }
      if(param1 == 2)
      {
         return this.$m[2];
      }
      return undefined;
   }
   
   override flash_proxy function hasProperty(param1:*) : Boolean
   {
      return flash_proxy.getProperty(param1) != undefined;
   }
   
   override flash_proxy function setProperty(param1:*, param2:*) : void
   {
      throw new IllegalOperationError();
   }
   
   public function apply(param1:Point) : Number
   {
      var _loc5_:int = 0;
      var _loc2_:Array = [param1.x,param1.y,1];
      var _loc3_:Number = 0;
      var _loc4_:int = 0;
      while(_loc4_ < 3)
      {
         _loc5_ = 0;
         while(_loc5_ < 3)
         {
            _loc3_ = _loc3_ + _loc2_[_loc4_] * this.$m[_loc4_][_loc5_] * _loc2_[_loc5_];
            _loc5_++;
         }
         _loc4_++;
      }
      return _loc3_;
   }
   
   public function clone() : QuadraticForm
   {
      var _loc3_:int = 0;
      var _loc1_:QuadraticForm = new QuadraticForm();
      var _loc2_:int = 0;
      while(_loc2_ < 3)
      {
         _loc3_ = 0;
         while(_loc3_ < 3)
         {
            _loc1_[_loc2_][_loc3_] = this.$m[_loc2_][_loc3_];
            _loc3_++;
         }
         _loc2_++;
      }
      return _loc1_;
   }
   
   public function add(param1:QuadraticForm) : QuadraticForm
   {
      var _loc3_:int = 0;
      var _loc2_:int = 0;
      while(_loc2_ < 3)
      {
         _loc3_ = 0;
         while(_loc3_ < 3)
         {
            this.$m[_loc2_][_loc3_] = this.$m[_loc2_][_loc3_] + param1[_loc2_][_loc3_];
            _loc3_++;
         }
         _loc2_++;
      }
      return this;
   }
   
   public function scalar(param1:Number) : QuadraticForm
   {
      var _loc3_:int = 0;
      var _loc2_:int = 0;
      while(_loc2_ < 3)
      {
         _loc3_ = 0;
         while(_loc3_ < 3)
         {
            this.$m[_loc2_][_loc3_] = this.$m[_loc2_][_loc3_] * param1;
            _loc3_++;
         }
         _loc2_++;
      }
      return this;
   }
   
   public function fromVectorMultiply(param1:Point3D) : QuadraticForm
   {
      var _loc3_:int = 0;
      var _loc2_:int = 0;
      while(_loc2_ < 3)
      {
         _loc3_ = 0;
         while(_loc3_ < 3)
         {
            this.$m[_loc2_][_loc3_] = param1[_loc2_] * param1[_loc3_];
            _loc3_++;
         }
         _loc2_++;
      }
      return this;
   }
   
   public function toString() : String
   {
      return "[" + this.$m[0][0] + "," + this.$m[0][1] + "," + this.$m[0][2] + "," + this.$m[1][0] + "," + this.$m[1][1] + "," + this.$m[1][2] + "," + this.$m[2][0] + "," + this.$m[2][1] + "," + this.$m[2][2] + "]";
   }
}
