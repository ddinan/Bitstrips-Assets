package com.bitstrips.core
{
   import com.bitstrips.BSConstants;
   import com.bitstrips.utils.Arc;
   
   public class PropShape extends Prop
   {
      
      public static const shapes:Array = ["square","rectangle1","rectangle2","rectangle3","parallelogram1","parallelogram2","trapezoid","triangle1","triangle2","triangle3","quarter-oval","semi-oval","semi-ring","quarter-ring","ring","circle","oval","quarter-circle","semi-circle","square-hole","square-hole2"];
      
      private static const lines:Object = {
         "square":[[-37,-37],[-37,37],[37,37],[37,-37],[-37,-37]],
         "rectangle1":[[-37,-27],[-37,27],[37,27],[37,-27],[-37,-27]],
         "rectangle2":[[-37,-18],[-37,18],[37,18],[37,-18],[-37,-18]],
         "rectangle3":[[-37,-5],[-37,5],[37,5],[37,-5],[-37,-5]],
         "parallelogram1":[[-27,-37],[-47,37],[27,37],[47,-37],[-27,-37]],
         "parallelogram2":[[-32,-18],[-42,18],[32,18],[42,-18],[-32,-18]],
         "trapezoid":[[-27,-19],[-37,19],[37,19],[27,-19],[-27,-19]],
         "triangle1":[[0,-33],[-37,33],[37,33]],
         "triangle2":[[-37,-37],[-37,37],[37,37]],
         "triangle3":[[-18,-37],[-18,37],[18,37]]
      };
      
      private static const curves:Object = {
         "quarter-oval":{
            "start":[-37,0],
            "curves":[[-37,-9.2,-26.2,-15.7],[-15.35,-22.2,0,-22.2],[0,-11.1,0,0]]
         },
         "semi-oval":{
            "start":[-37,0],
            "curves":[[-37,-9.2,-26.2,-15.7],[-15.35,-22.2,0,-22.2],[15.35,-22.2,26.15,-15.7],[37,-9.2,37,0]]
         },
         "semi-ring":{
            "start":[-37,0],
            "curves":[[-37,-15.35,-26.2,-26.2],[-15.35,-37,0,-37],[15.35,-37,26.15,-26.2],[37,-15.35,37,0],[17.3,0,17.3,0],[17.3,-7.2,12.25,-12.25],[7.2,-17.3,0,-17.3],[-7.2,-17.3,-12.25,-12.25],[-17.3,-7.2,-17.3,0]]
         },
         "quarter-ring":{
            "start":[-37,0],
            "curves":[[-37,-15.35,-26.2,-26.2],[-15.35,-37,0,-37],[0,-27.15,0,-17.3],[-7.2,-17.3,-12.25,-12.25],[-17.3,-7.2,-17.3,0]]
         }
      };
       
      
      private var _scale:Number;
      
      public function PropShape(param1:String)
      {
         this._scale = BSConstants.RESCALE;
         super();
         if(param1 == "parallelogram3")
         {
            param1 = "parallelogram1";
            this.prop_rotation = 1;
         }
         else if(param1 == "parallelogram4")
         {
            param1 = "parallelogram2";
            this.prop_rotation = 1;
         }
         name = param1;
         this.set_base_colour("cccccc");
         type = "shapes";
         states = 6;
         rotations = 1;
         this.draw();
      }
      
      public function get scale() : Number
      {
         return this._scale / BSConstants.RESCALE;
      }
      
      public function set scale(param1:Number) : void
      {
         this._scale = param1 * BSConstants.RESCALE;
         this.draw();
      }
      
      private function draw() : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         this.graphics.clear();
         var _loc1_:Number = this._scale;
         var _loc2_:Number = 2;
         if(_state >= 4)
         {
            _loc2_ = 1;
         }
         if(_state == 0 || _state == 4)
         {
            this.graphics.lineStyle(_loc2_,0,1,false);
         }
         else if(_state == 1 || _state == 5)
         {
            this.graphics.lineStyle(_loc2_,10066329,1,false);
         }
         else if(_state == 3 || _state == 6)
         {
            this.graphics.lineStyle(_loc2_,16777215,1,false);
         }
         if(_state != 3 && _state != 6)
         {
            this.graphics.beginFill(16777215);
         }
         if(PropShape.lines.hasOwnProperty(name))
         {
            _loc3_ = PropShape.lines[name];
            this.graphics.moveTo(_loc3_[0][0] * _loc1_,_loc3_[0][1] * _loc1_);
            _loc4_ = 1;
            while(_loc4_ < _loc3_.length)
            {
               this.graphics.lineTo(_loc3_[_loc4_][0] * _loc1_,_loc3_[_loc4_][1] * _loc1_);
               _loc4_++;
            }
            this.graphics.lineTo(_loc3_[0][0] * _loc1_,_loc3_[0][1] * _loc1_);
         }
         else if(PropShape.curves.hasOwnProperty(name))
         {
            this.graphics.moveTo(PropShape.curves[name]["start"][0] * _loc1_,PropShape.curves[name]["start"][1] * _loc1_);
            for each(_loc5_ in PropShape.curves[name]["curves"])
            {
               this.graphics.curveTo(_loc5_[0] * _loc1_,_loc5_[1] * _loc1_,_loc5_[2] * _loc1_,_loc5_[3] * _loc1_);
            }
            this.graphics.lineTo(PropShape.curves[name]["start"][0] * _loc1_,PropShape.curves[name]["start"][1] * _loc1_);
         }
         else if(name == "circle")
         {
            this.graphics.drawCircle(0,0,37 * _loc1_);
         }
         else if(name == "semi-circle")
         {
            Arc.draw(this,-37 * _loc1_,0,37 * _loc1_,180,180);
            this.graphics.lineTo(-37 * _loc1_,0);
         }
         else if(name == "quarter-circle")
         {
            Arc.draw(this,-37 * _loc1_,0,37 * _loc1_,90,180);
            this.graphics.lineTo(0,0);
            this.graphics.lineTo(-37 * _loc1_,0);
         }
         else if(name == "oval")
         {
            this.graphics.drawEllipse(-37 * _loc1_,-22 * _loc1_,74 * _loc1_,44 * _loc1_);
         }
         else if(name == "ring")
         {
            this.graphics.drawCircle(0,0,37 * _loc1_);
            this.graphics.drawCircle(0,0,17 * _loc1_);
         }
         else if(name == "square-hole")
         {
            this.graphics.drawRect(-40 * _loc1_,-40 * _loc1_,80 * _loc1_,80 * _loc1_);
            this.graphics.drawCircle(0,0,20 * _loc1_);
         }
         else if(name == "square-hole2")
         {
            this.graphics.drawRect(-40 * _loc1_,-40 * _loc1_,80 * _loc1_,80 * _loc1_);
            this.graphics.drawEllipse(-30 * _loc1_,-20 * _loc1_,60 * _loc1_,40 * _loc1_);
         }
         this.graphics.endFill();
      }
      
      override public function set state(param1:uint) : void
      {
         super.state = param1;
         this.draw();
      }
      
      override public function set_rotation(param1:uint) : void
      {
         var _loc2_:uint = Math.max(0,Math.min(rotations,param1));
         prop_rotation = _loc2_;
         if(prop_rotation == 1)
         {
            scaleX = -1;
         }
         else
         {
            scaleX = 1;
         }
      }
      
      override public function pass_colour(param1:Number) : void
      {
      }
   }
}
