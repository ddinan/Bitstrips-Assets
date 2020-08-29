package com.bitstrips.character
{
   import com.bitstrips.BSConstants;
   
   public class PPData
   {
       
      
      public var beardstyle:uint = 0;
      
      private var mod:Object;
      
      public var hairstyle:uint = 1;
      
      private var rmod:Object;
      
      private var piece_data:Object;
      
      public var backstyle:uint = 1;
      
      public function PPData(param1:Object = undefined)
      {
         mod = new Object();
         rmod = new Object();
         piece_data = new Object();
         super();
         piece_data["hat"] = {
            "type":"hat",
            "id":"_blank"
         };
         piece_data["glasses"] = {
            "type":"glasses",
            "id":"_blank"
         };
         piece_data["hair_front"] = {
            "type":"hair_front",
            "id":"_blank"
         };
         piece_data["brow_L"] = {
            "type":"brow",
            "id":"brow_art1"
         };
         piece_data["brow_R"] = {
            "type":"brow",
            "id":"brow_art1"
         };
         piece_data["nose"] = {
            "type":"nose",
            "id":"nose_art1"
         };
         piece_data["eyelash_L"] = {
            "type":"eyelash",
            "id":"_blank"
         };
         piece_data["eye_L"] = {
            "type":"eye",
            "id":"eye_art1"
         };
         piece_data["eyelid_L"] = {
            "type":"eyelid",
            "id":"eyelid_art1"
         };
         piece_data["pupil_L"] = {
            "type":"pupil",
            "id":"pupil_art1"
         };
         piece_data["eyelash_R"] = {
            "type":"eyelash",
            "id":"_blank"
         };
         piece_data["eye_R"] = {
            "type":"eye",
            "id":"eye_art1"
         };
         piece_data["eyelid_R"] = {
            "type":"eyelid",
            "id":"eyelid_art1"
         };
         piece_data["pupil_R"] = {
            "type":"pupil",
            "id":"pupil_art1"
         };
         piece_data["moustache"] = {
            "type":"moustache",
            "id":"_blank"
         };
         piece_data["mouth"] = {
            "type":"mouth",
            "id":"mouth_art1"
         };
         piece_data["detail_L"] = {
            "type":"detail_L",
            "id":"_blank"
         };
         piece_data["detail_R"] = {
            "type":"detail_L",
            "id":"_blank"
         };
         piece_data["detail_T"] = {
            "type":"detail_T",
            "id":"_blank"
         };
         piece_data["chin"] = {
            "type":"chin",
            "id":"_blank"
         };
         piece_data["cheek_L"] = {
            "type":"cheek",
            "id":"_blank"
         };
         piece_data["cheek_R"] = {
            "type":"cheek",
            "id":"_blank"
         };
         piece_data["forehead"] = {
            "type":"forehead",
            "id":"forehead_art1"
         };
         piece_data["cranium"] = {
            "type":"cranium",
            "id":"cranium_art1"
         };
         piece_data["earring_L"] = {
            "type":"earring",
            "id":"_blank"
         };
         piece_data["ear_L"] = {
            "type":"ear",
            "id":"ear_art1"
         };
         piece_data["earring_R"] = {
            "type":"earring",
            "id":"_blank"
         };
         piece_data["ear_R"] = {
            "type":"ear",
            "id":"ear_art1"
         };
         piece_data["goatee"] = {
            "type":"goatee",
            "id":"_blank"
         };
         piece_data["beard"] = {
            "type":"beard",
            "id":"beard_art1"
         };
         piece_data["jaw"] = {
            "type":"jaw",
            "id":"jaw_art1"
         };
         piece_data["hair_back"] = {
            "type":"hair_back",
            "id":"hair_back_art1"
         };
         piece_data["detail_E_L"] = {
            "type":"detail_E",
            "id":"_blank"
         };
         piece_data["detail_E_R"] = {
            "type":"detail_E",
            "id":"_blank"
         };
         if(BSConstants.KID_MODE)
         {
            piece_data["hair_front"]["id"] = "hair_front_art12";
            piece_data["forehead"]["id"] = "forehead_art5";
            piece_data["brow_L"]["id"] = "brow_art3";
            piece_data["brow_R"]["id"] = "brow_art3";
            piece_data["nose"]["id"] = "nose_art4";
            this.hairstyle = 11;
         }
         if(param1)
         {
            load_data(param1);
         }
      }
      
      public function get_art_id(param1:String) : String
      {
         return piece_data[param1]["id"];
      }
      
      public function get_frame(param1:String, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint) : uint
      {
         if(param2 > 4)
         {
            param2 = 4 - (param2 - 4);
         }
         var _loc7_:uint = PieceData.fvl[param1][param2]["f"];
         if(param1 == "eyelash_L" || param1 == "eyelash_R")
         {
            _loc7_ = 1;
            if(param3 > 2)
            {
               _loc7_ = param3 - 1;
            }
            if(param3 == 8)
            {
               _loc7_ = 4;
            }
            if(param6 == 2)
            {
               _loc7_ = 5;
            }
            else if(param6 == 4)
            {
               _loc7_ = 6;
            }
            else if(param6 == 5)
            {
               _loc7_ = 7;
            }
         }
         else if(param1 == "mouth")
         {
            _loc7_ = (param4 - 1) * 4 + param5;
         }
         else if(param1 == "eye_L" || param1 == "eye_R" || param1 == "brow_L" || param1 == "brow_R")
         {
            _loc7_ = param3;
         }
         else if(param1 == "eyelid_L" || param1 == "eyelid_R")
         {
            _loc7_ = param6;
         }
         return _loc7_;
      }
      
      public function reset_mod(param1:String) : void
      {
         mod[param1] = new Array();
         rmod[param1] = new Array();
      }
      
      public function get_rmod(param1:String, param2:Number, param3:Number) : Object
      {
         var _loc5_:Object = null;
         var _loc4_:Object = get_mod(param1,param2);
         if(param3 > 1)
         {
            if(rmod[param1])
            {
               if(rmod[param1][param2])
               {
                  if(rmod[param1][param2][param3])
                  {
                     _loc5_ = rmod[param1][param2][param3];
                     _loc4_.x = _loc5_.x;
                     _loc4_.y = _loc5_.y;
                     _loc4_.xs = _loc5_.xs;
                     _loc4_.ys = _loc5_.ys;
                  }
               }
            }
         }
         return _loc4_;
      }
      
      public function get_base(param1:String, param2:Number, param3:Number) : Object
      {
         var _loc4_:Object = {
            "x":0,
            "y":0,
            "xs":1,
            "ys":1,
            "f":1
         };
         var _loc5_:Number = 1;
         if(PieceData.ps[param1] != undefined)
         {
            _loc4_.x = PieceData.ps[param1][param2].x;
            _loc4_.y = PieceData.ps[param1][param2].y;
            _loc4_.xs = PieceData.ps[param1][param2].xs;
            _loc4_.ys = PieceData.ps[param1][param2].ys;
            _loc4_.f = PieceData.ps[param1][param2].f;
         }
         else if(param1.substr(-1) == "R")
         {
            _loc4_.f = -1;
         }
         if(param1 == "jaw" || param1 == "beard")
         {
            if(param3 == 3)
            {
               _loc4_.ys = _loc4_.ys * 1.065;
            }
            if(param3 == 4)
            {
               _loc4_.ys = _loc4_.ys * 1.125;
            }
         }
         if(param1 == "chin" || param1 == "goatee")
         {
            if(param3 == 3)
            {
               _loc4_.y = _loc4_.y + 1.5;
            }
            if(param3 == 4)
            {
               _loc4_.y = _loc4_.y + 4;
            }
         }
         if(_loc4_.f == -1)
         {
            _loc4_.f = 1;
         }
         else
         {
            _loc4_.f = 0;
         }
         return _loc4_;
      }
      
      public function removeable(param1:String) : Boolean
      {
         return PieceData.rdata[param1]["remove"];
      }
      
      public function get_art_type(param1:String) : String
      {
         return piece_data[param1]["type"];
      }
      
      public function load_data(param1:Object) : Boolean
      {
         var _loc2_:* = null;
         var _loc3_:Object = null;
         for(_loc2_ in param1["piece_data"])
         {
            _loc3_ = param1["piece_data"][_loc2_];
            set_art_id(_loc3_[0],_loc3_[2]);
         }
         for(_loc2_ in param1["mod"])
         {
            mod[_loc2_] = param1["mod"][_loc2_];
         }
         hairstyle = param1["hairstyle"];
         beardstyle = param1["beardstyle"];
         if(param1["backstyle"] != undefined)
         {
            backstyle = param1["backstyle"];
         }
         return true;
      }
      
      public function scaleable(param1:String) : Boolean
      {
         return PieceData.rdata[param1]["scale"];
      }
      
      public function get_mod(param1:String, param2:Number) : Object
      {
         var _loc4_:Object = null;
         var _loc3_:Object = {
            "x":0,
            "y":0,
            "xs":1,
            "ys":1
         };
         if(mod[param1])
         {
            if(mod[param1][param2])
            {
               _loc4_ = mod[param1][param2];
               _loc3_.x = _loc4_.x;
               _loc3_.y = _loc4_.y;
               _loc3_.xs = _loc4_.xs;
               _loc3_.ys = _loc4_.ys;
            }
         }
         return _loc3_;
      }
      
      public function moveable(param1:String) : Boolean
      {
         return PieceData.rdata[param1]["position"];
      }
      
      public function save_data() : Object
      {
         var _loc2_:* = null;
         var _loc1_:Object = new Object();
         _loc1_["piece_data"] = new Object();
         for(_loc2_ in piece_data)
         {
            _loc1_["piece_data"][_loc2_] = [_loc2_,piece_data[_loc2_]["type"],piece_data[_loc2_]["id"]];
         }
         _loc1_["mod"] = new Object();
         for(_loc2_ in mod)
         {
            _loc1_["mod"][_loc2_] = mod[_loc2_];
         }
         _loc1_["hairstyle"] = hairstyle;
         _loc1_["beardstyle"] = beardstyle;
         _loc1_["backstyle"] = backstyle;
         return _loc1_;
      }
      
      public function swapable(param1:String) : Boolean
      {
         return true;
      }
      
      public function set_art_id(param1:String, param2:String) : void
      {
         if(param1 == "ear_ring_L")
         {
            param1 = "earring_L";
         }
         else if(param1 == "ear_ring_R")
         {
            param1 = "earring_R";
         }
         piece_data[param1]["id"] = param2;
      }
      
      public function get_data(param1:String, param2:Number, param3:Number, param4:Number) : Object
      {
         var _loc5_:Object = get_base(param1,param2,param4);
         var _loc6_:Object = get_rmod(param1,param2,param3);
         _loc5_.x = _loc5_.x + _loc6_.x;
         _loc5_.y = _loc5_.y + _loc6_.y;
         _loc5_.xs = _loc5_.xs * _loc6_.xs;
         _loc5_.ys = _loc5_.ys * _loc6_.ys;
         _loc5_.visible = PieceData.fvl[param1][param2]["v"];
         _loc5_.level = PieceData.fvl["depths"][param1][param2];
         return _loc5_;
      }
      
      public function set_mod(param1:String, param2:Object, param3:uint, param4:uint, param5:uint) : void
      {
         var _loc8_:int = 0;
         var _loc6_:Object = get_base(param1,param3,param5);
         var _loc7_:Object = {
            "x":param2.x - _loc6_.x,
            "y":param2.y - _loc6_.y,
            "xs":param2.xs / _loc6_.xs,
            "ys":param2.ys / _loc6_.ys
         };
         if(mod[param1] == undefined)
         {
            mod[param1] = new Array();
            _loc8_ = 0;
            while(_loc8_ < 8)
            {
               mod[param1][_loc8_] = {
                  "x":_loc7_.x,
                  "y":_loc7_.y,
                  "xs":_loc7_.xs,
                  "ys":_loc7_.ys
               };
               _loc8_ = _loc8_ + 1;
            }
         }
         if(param4 > 1)
         {
            if(rmod[param1] == undefined)
            {
               rmod[param1] = new Array();
            }
            if(rmod[param1][param3] == undefined)
            {
               rmod[param1][param3] = new Array();
            }
            rmod[param1][param3][param4] = _loc7_;
         }
         else
         {
            mod[param1][param3] = {
               "x":_loc7_.x,
               "y":_loc7_.y,
               "xs":_loc7_.xs,
               "ys":_loc7_.ys
            };
            if(param3 == 0)
            {
               _loc8_ = 0;
               while(_loc8_ < 8)
               {
                  mod[param1][_loc8_] = _loc7_;
                  _loc8_ = _loc8_ + 1;
               }
            }
            _loc8_ = 0;
            while(_loc8_ < 8)
            {
               if(mod[param1][_loc8_] == undefined)
               {
                  mod[param1][_loc8_] = new Object();
               }
               mod[param1][_loc8_].xs = _loc7_.xs;
               mod[param1][_loc8_].y = _loc7_.y;
               mod[param1][_loc8_].ys = _loc7_.ys;
               _loc8_ = _loc8_ + 1;
            }
         }
      }
   }
}
