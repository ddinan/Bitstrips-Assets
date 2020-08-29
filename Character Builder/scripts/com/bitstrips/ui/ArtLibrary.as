package com.bitstrips.ui
{
   import com.adobe.webapis.gettext.GetText;
   import com.bitstrips.Utils;
   import com.bitstrips.character.Container;
   import com.bitstrips.character.Head;
   import com.bitstrips.character.skeleton.SkeletonBuddy;
   import com.bitstrips.core.ArtLoader;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public final class ArtLibrary extends Sprite
   {
      
      public static const art_order:Object = {
         "moustache":{"1":["_blank","moustache_art6","moustache_art5","moustache_art3","moustache_art1","moustache_art2","moustache_art4","moustache_art7","moustache_art8","moustache_art9","moustache_art10","moustache_art11"]},
         "beard":{"1":["_blank","1","2","6","3","4","5"]},
         "eyelashes":{
            "1":["_blank","eyelash_art1","eyelash_art3","eyelash_art2"],
            "2":["eyelash_art2","eyelash_art3","eyelash_art1","_blank"]
         },
         "pupils":{"1":["pupil_art1","pupil_art2","pupil_art3","pupil_art4","pupil_art5","pupil_art6","pupil_art7"]},
         "detail_T":{"1":["detail_T_art1","detail_T_art2","detail_T_art3","detail_T_art4","_blank"]},
         "jaw":{"1":["jaw_art1","jaw_art4","jaw_art3","jaw_art2","jaw_art7","jaw_art6","jaw_art10","jaw_art5","jaw_art8","jaw_art9"]},
         "brow":{
            "1":["brow_art3","brow_art1","brow_art2","brow_art4","brow_art14","brow_art5","brow_art6","brow_art11","brow_art15","brow_art7","brow_art16","brow_art9","brow_art12","brow_art13","brow_art8","brow_art10","_blank"],
            "2":["brow_art3","brow_art1","brow_art2","brow_art4","brow_art14","brow_art12","brow_art13","brow_art8","brow_art10","brow_art5","brow_art6","brow_art11","brow_art15","brow_art7","brow_art16","brow_art9","_blank"]
         },
         "glasses":{"1":["_blank","glasses_art2","glasses_art1","glasses_art3","glasses_art5","glasses_art4","glasses_art6","glasses_art7"]},
         "eyes":{
            "1":["eye_art1","eye_art2","eye_art3","eye_art9","eye_art6","eye_art5","eye_art4","eye_art7","eye_art8","_blank"],
            "2":["eye_art1","eye_art3","eye_art2","eye_art9","eye_art6","eye_art5","eye_art4","eye_art7","eye_art8","_blank"]
         },
         "cranium":{"1":["cranium_art1","cranium_art4","cranium_art3","cranium_art6","cranium_art2","cranium_art7","cranium_art10","cranium_art5","cranium_art9","cranium_art8"]},
         "mouth":{
            "1":["mouth_art1","mouth_art5","mouth_art6","mouth_art4","mouth_art2","mouth_art3","_blank"],
            "2":["mouth_art3","mouth_art2","mouth_art6","mouth_art5","mouth_art6","mouth_art4","_blank"]
         },
         "nose":{
            "1":["nose_art1","nose_art4","nose_art2","nose_art3","nose_art20","nose_art5","nose_art10","nose_art6","nose_art8","nose_art13","nose_art7","nose_art9","nose_art11","nose_art19","nose_art12","nose_art17","nose_art16","nose_art15","nose_art18","nose_art14","nose_art21","nose_art22","_blank"],
            "2":["nose_art4","nose_art15","nose_art19","nose_art16","nose_art11","nose_art1","nose_art2","nose_art3","nose_art20","nose_art5","nose_art10","nose_art6","nose_art8","nose_art13","nose_art7","nose_art9","nose_art12","nose_art17","nose_art18","nose_art14","nose_art21","nose_art22","_blank"]
         },
         "detail_E":{"1":["detail_E_art1","detail_E_art2","detail_E_art3","_blank"]},
         "earrings":{
            "1":["_blank","earring_art1","earring_art2","earring_art3","earring_art4","earring_art5"],
            "2":["earring_art1","earring_art2","earring_art3","earring_art4","earring_art5","_blank"]
         },
         "ear":{"1":["ear_art1","ear_art3","ear_art2","ear_art5","ear_art4","ear_art6","ear_art7","ear_art8","ear_art9","_blank"]},
         "hat":{
            "1":["_blank","hat_art1","hat_art2","hat_turban","hat_art6","hat_art4","hat_hijab","hat_art5","hat_art3","hat_art7","hat_art8","hat_art9","hat_art10","hat_art11","hat_art12","hat_art13","hat_art14","hat_art15","hat_art16"],
            "1":["_blank","hat_hijab","hat_art1","hat_art2","hat_art6","hat_art4","hat_art5","hat_turban","hat_art3","hat_art7","hat_art8","hat_art9","hat_art10","hat_art11","hat_art12","hat_art13","hat_art14","hat_art15","hat_art16"]
         },
         "detail_L":{"1":["detail_L_art2","detail_L_art3","detail_L_art1","detail_L_art4","detail_L_art5","_blank"]},
         "cheeks":{
            "1":["_blank","cheek_art1","cheek_art2","cheek_art4","cheek_art6","cheek_art3"],
            "2":["_blank","cheek_art4","cheek_art2","cheek_art1","cheek_art6","cheek_art3"]
         }
      };
       
      
      const cuts:Object = {
         "cut_18":["1","16"],
         "cut_29":["19","21"],
         "cut_28":["18","20"],
         "cut_23":["13","12"],
         "cut_22":["12","19"],
         "cut_21":["11","1"],
         "cut_20":["0","0"],
         "cut_27":["17","19"],
         "cut_26":["16","12"],
         "cut_25":["15","18"],
         "cut_24":["14","17"],
         "cut_19":["1","15"],
         "cut_8":["7","13"],
         "cut_9":["4","6"],
         "cut_1":["1","1"],
         "cut_2":["8","6"],
         "cut_3":["10","1"],
         "cut_4":["2","12"],
         "cut_5":["3","11"],
         "cut_6":["5","6"],
         "cut_7":["6","11"],
         "cut_12":["5","15"],
         "cut_13":["5","14"],
         "cut_10":["9","5"],
         "cut_11":["9","16"],
         "cut_38":["1","29"],
         "cut_17":["1","8"],
         "cut_14":["6","15"],
         "cut_15":["6","14"],
         "cut_34":["24","26"],
         "cut_35":["25","27"],
         "cut_36":["26","1"],
         "cut_37":["1","28"],
         "cut_30":["20","22"],
         "cut_31":["21","23"],
         "cut_32":["22","24"],
         "cut_33":["23","25"],
         "cut_16":["1","5"]
      };
      
      private var buttons:Array;
      
      const cut_maps:Object = {
         "24":{"27":"cut_34"},
         "25":{"28":"cut_35"},
         "26":{"1":"cut_36"},
         "20":{"23":"cut_30"},
         "21":{"24":"cut_31"},
         "22":{"25":"cut_32"},
         "23":{"26":"cut_33"},
         "1":{
            "15":"cut_19",
            "16":"cut_18",
            "30":"cut_38",
            "29":"cut_37",
            "1":"cut_1",
            "5":"cut_16",
            "8":"cut_17"
         },
         "0":{"0":"cut_20"},
         "3":{"11":"cut_5"},
         "2":{"12":"cut_4"},
         "5":{
            "15":"cut_12",
            "14":"cut_13",
            "6":"cut_6"
         },
         "4":{"6":"cut_9"},
         "7":{"13":"cut_8"},
         "6":{
            "11":"cut_7",
            "15":"cut_14",
            "14":"cut_15"
         },
         "9":{
            "5":"cut_10",
            "16":"cut_11"
         },
         "8":{"6":"cut_2"},
         "11":{"1":"cut_21"},
         "10":{"1":"cut_3"},
         "13":{"12":"cut_23"},
         "12":{"19":"cut_22"},
         "15":{"19":"cut_25"},
         "14":{"18":"cut_24"},
         "17":{"20":"cut_27"},
         "16":{"12":"cut_26"},
         "19":{"22":"cut_29"},
         "18":{"21":"cut_28"}
      };
      
      const cut_styles:Object = {
         "cut_18":["style_1","style_4","style_5","style_6","style_7","style_10","style_8","style_9","style_15"],
         "cut_29":["style_24"],
         "cut_28":["style_35"],
         "cut_23":["style_19"],
         "cut_22":["style_18","style_17"],
         "cut_21":["style_17","style_18"],
         "cut_20":["style_1"],
         "cut_27":["style_23"],
         "cut_26":["style_22"],
         "cut_25":["style_21"],
         "cut_24":["style_20"],
         "cut_19":["style_1","style_4","style_5","style_6","style_7","style_10","style_8","style_9","style_15"],
         "cut_8":["style_1","style_2","style_5","style_4","style_3"],
         "cut_9":["style_8","style_7","style_15","style_4","style_1","style_2","style_5","style_3"],
         "cut_1":["style_1","style_2","style_5","style_4","style_3","style_6","style_8","style_7","style_10","style_16","style_15","style_9"],
         "cut_2":["style_5","style_2","style_3","style_6","style_14","style_10","style_7"],
         "cut_3":["style_14","style_6","style_5","style_2","style_1","style_3"],
         "cut_4":["style_5","style_2","style_1","style_3","style_6","style_8","style_14"],
         "cut_5":["style_1","style_2","style_5","style_4","style_3","style_6","style_8","style_7","style_10","style_15","style_9"],
         "cut_6":["style_6","style_8","style_7","style_10","style_15","style_1","style_2","style_5","style_4","style_3","style_9"],
         "cut_7":["style_7","style_10","style_6","style_8","style_9","style_15","style_5","style_4","style_2","style_1","style_3"],
         "cut_12":["style_1","style_4","style_5","style_6","style_7","style_10","style_8","style_15"],
         "cut_13":["style_1","style_4","style_5","style_6","style_7","style_10","style_8","style_15"],
         "cut_10":["style_4","style_6","style_14","style_11","style_12"],
         "cut_11":["style_4","style_6","style_14","style_15","style_13"],
         "cut_38":["style_1"],
         "cut_17":["style_1","style_4","style_5","style_6","style_7","style_10","style_8","style_9","style_15"],
         "cut_14":["style_1","style_4","style_5","style_6","style_7","style_10","style_8","style_9","style_15","style_14"],
         "cut_15":["style_1","style_4","style_5","style_6","style_7","style_10","style_8","style_9","style_15","style_14"],
         "cut_34":["style_31"],
         "cut_35":["style_32","style_31"],
         "cut_36":["style_25"],
         "cut_37":["style_1"],
         "cut_30":["style_27"],
         "cut_31":["style_28"],
         "cut_32":["style_29"],
         "cut_33":["style_30"],
         "cut_16":["style_1","style_4","style_5","style_6","style_7","style_10","style_8","style_9","style_15"]
      };
      
      private var glow_selected:GlowFilter;
      
      private var page:uint = 0;
      
      const cut_list:Object = {
         "1":["cut_1","cut_21","cut_22","cut_6","cut_24","cut_25","cut_26","cut_2","cut_3","cut_23","cut_4","cut_5","cut_7","cut_27","cut_8","cut_9","cut_28","cut_29","cut_30","cut_31","cut_32","cut_34","cut_35","cut_36","cut_37","cut_38","cut_10","cut_11","cut_12","cut_13","cut_14","cut_15","cut_16","cut_17","cut_18","cut_19","cut_20"],
         "2":["cut_29","cut_30","cut_31","cut_32","cut_34","cut_35","cut_36","cut_37","cut_38","cut_12","cut_13","cut_14","cut_15","cut_10","cut_11","cut_16","cut_17","cut_18","cut_19","cut_6","cut_7","cut_4","cut_2","cut_3","cut_5","cut_8","cut_9","cut_28","cut_1","cut_21","cut_22","cut_23","cut_25","cut_26","cut_27","cut_24","cut_20"]
      };
      
      private var glow_high:GlowFilter;
      
      private var bottom_page:uint = 0;
      
      private var top_count:uint = 12;
      
      public var head_buttons:Container;
      
      private var body:SkeletonBuddy;
      
      private var bottom_list:Array = null;
      
      private var page_left:SimpleButton;
      
      private var top_page:uint = 0;
      
      public var hb_tags:Array;
      
      private var top_list:Array = null;
      
      private var lib_big:MovieClip;
      
      private var original:Array;
      
      private var debug:Boolean = false;
      
      private var pages:uint = 0;
      
      private var lib_small_bottom:MovieClip;
      
      public var selected_type:String;
      
      const styles:Object = {
         "style_9":["hair_front_art4","forehead_art3"],
         "style_8":["hair_front_art3","forehead_art5"],
         "style_1":["_blank","forehead_art1"],
         "style_3":["_blank","forehead_art3"],
         "style_2":["_blank","forehead_art2"],
         "style_5":["_blank","forehead_art5"],
         "style_4":["_blank","forehead_art4"],
         "style_7":["hair_front_art2","forehead_art5"],
         "style_6":["hair_front_art1","forehead_art5"],
         "style_28":["hair_front_art23","forehead_art5"],
         "style_29":["hair_front_art24","forehead_art5"],
         "style_24":["hair_front_art19","forehead_art5"],
         "style_25":["hair_front_art20","forehead_art5"],
         "style_26":["hair_front_art21","forehead_art5"],
         "style_27":["hair_front_art22","forehead_art5"],
         "style_20":["hair_front_art15","forehead_art5"],
         "style_21":["hair_front_art16","forehead_art5"],
         "style_22":["hair_front_art17","forehead_art3"],
         "style_23":["hair_front_art18","forehead_art5"],
         "style_33":["hair_front_art28","forehead_art1"],
         "style_32":["hair_front_art27","forehead_art5"],
         "style_15":["hair_front_art10","forehead_art5"],
         "style_14":["hair_front_art9","forehead_art5"],
         "style_17":["hair_front_art12","forehead_art5"],
         "style_16":["hair_front_art11","forehead_art5"],
         "style_11":["hair_front_art6","forehead_art3"],
         "style_10":["hair_front_art5","forehead_art5"],
         "style_13":["hair_front_art8","forehead_art3"],
         "style_12":["hair_front_art7","forehead_art3"],
         "style_35":["hair_front_art30","forehead_art5"],
         "style_34":["hair_front_art29","forehead_art1"],
         "style_19":["hair_front_art14","forehead_art3"],
         "style_18":["hair_front_art13","forehead_art5"],
         "style_31":["hair_front_art26","forehead_art5"],
         "style_30":["hair_front_art25","forehead_art5"]
      };
      
      private var lib_small_top:MovieClip;
      
      public var h:Head;
      
      private var junk_set:Boolean = false;
      
      private var page_right:SimpleButton;
      
      private var artwork:ArtLoader;
      
      private var cats:Array;
      
      public var ignore_top:Boolean = false;
      
      public var ph:Head;
      
      private var swap_options:Object;
      
      private var tcl:Object;
      
      public function ArtLibrary(param1:ArtLoader)
      {
         glow_high = new GlowFilter(65280,8,8,5);
         glow_selected = new GlowFilter(52479,1,8,8,5);
         hb_tags = new Array();
         swap_options = new Object();
         tcl = {};
         super();
         artwork = param1;
         tcl["hat"] = ["hat","glasses"];
         tcl["glasses"] = ["hat","glasses"];
         tcl["forehead"] = ["cranium","jaw"];
         tcl["jaw"] = ["cranium","jaw"];
         tcl["hairstyles"] = ["hairstyles","hair_front"];
         tcl["cranium"] = tcl["hairstyles"];
         tcl["hair_front"] = tcl["hairstyles"];
         tcl["brow"] = ["brow"];
         tcl["eye"] = ["eye","pupil"];
         tcl["pupil"] = tcl["eye"];
         tcl["eyelid"] = tcl["eye"];
         tcl["eyelash"] = ["eyelash","detail_E"];
         tcl["detail_E"] = tcl["eyelash"];
         tcl["nose"] = ["nose"];
         tcl["mouth"] = ["mouth"];
         tcl["ear"] = ["ear","earring"];
         tcl["earring"] = ["ear","earring"];
         tcl["cheek"] = ["cheek","chin"];
         tcl["chin"] = tcl["cheek"];
         tcl["beard"] = ["beardstyle","moustache"];
         tcl["goatee"] = ["beardstyle","moustache"];
         tcl["moustache"] = ["beardstyle","moustache"];
         tcl["beardstyle"] = ["beardstyle","moustache"];
         tcl["detail_L"] = ["detail_L","detail_T"];
         tcl["detail_T"] = ["detail_L","detail_T"];
         var _loc2_:int = 4;
         while(_loc2_ <= 9)
         {
            tcl["wiz" + _loc2_] = ["wiz" + _loc2_];
            _loc2_ = _loc2_ + 1;
         }
         hb_tags[0] = "forehead";
         hb_tags["forehead"] = 0;
         hb_tags["cranium"] = 0;
         hb_tags["hairstyles"] = 1;
         hb_tags["brow"] = 2;
         hb_tags["eye"] = 3;
         hb_tags["eyelash"] = 4;
         hb_tags["nose"] = 5;
         hb_tags["mouth"] = 6;
         hb_tags["ear"] = 7;
         hb_tags["cheek"] = 8;
         hb_tags["beard"] = 9;
         hb_tags["beardstyle"] = 9;
         hb_tags["goatee"] = 9;
         hb_tags["detail_L"] = 10;
         hb_tags["hat"] = 11;
         cats = ["hairstyles","hairstyles2","hat","glasses","hair_front","brow","nose","eyelash","eye","pupil","moustache","mouth","detail_L","detail_T","chin","cheek","forehead","hair_top","cranium","earring","ear","goatee","beard","jaw","hair_back"];
      }
      
      private function go_page_bottom(param1:int) : void
      {
         if(debug)
         {
            trace("Page: " + param1);
         }
         bottom_page = Math.max(0,bottom_page + param1);
         bottom_page = Math.min(bottom_page,int(bottom_list.length / 6));
         if(debug)
         {
            trace("Page: " + bottom_page);
         }
         draw_list_bottom();
      }
      
      public function set_junk(param1:MovieClip, param2:MovieClip, param3:MovieClip) : void
      {
         var l_big:MovieClip = param1;
         var l_st:MovieClip = param2;
         var lsb:MovieClip = param3;
         junk_set = true;
         lib_small_top = l_st;
         lib_small_bottom = lsb;
         lib_big = l_big;
         lib_small_top.page_left.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            go_page_top(-1);
         });
         lib_small_top.page_right.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            go_page_top(1);
         });
         lib_big.page_left.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            go_page_top(-1);
         });
         lib_big.page_right.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            go_page_top(1);
         });
         lib_small_bottom.page_left.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            go_page_bottom(-1);
         });
         lib_small_bottom.page_right.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            go_page_bottom(1);
         });
      }
      
      private function string2art_id(param1:String) : Number
      {
         var _loc2_:Array = param1.split("_");
         if(_loc2_.length == 3)
         {
            return _loc2_[1].split("art")[1];
         }
         return param1.split("art")[1];
      }
      
      private function center_piece(param1:Sprite, param2:Number, param3:Number) : void
      {
         var _loc4_:Point = center_point(param1);
         param1.x = param2 - _loc4_.x;
         param1.y = param3 - _loc4_.y;
      }
      
      public function do_swaps(param1:Array) : void
      {
         var _loc2_:* = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         for(_loc2_ in param1)
         {
            _loc3_ = param1[_loc2_][0];
            _loc4_ = param1[_loc2_][1];
            if(_loc3_ == "hairstyles")
            {
               h.set_hairstyle(int(_loc4_));
               if(ignore_top == false)
               {
                  ph.set_hairstyle(int(_loc4_));
               }
               if(debug)
               {
                  trace("Set hairstyle: ph" + _loc4_);
               }
            }
            else if(_loc3_ == "beardstyle")
            {
               h.set_beardstyle(int(_loc4_));
               if(ignore_top == false)
               {
                  ph.set_beardstyle(int(_loc4_));
               }
               if(debug)
               {
                  trace("Set set_beardstyle: ph" + _loc4_);
               }
            }
            else if(_loc3_ == "backstyle")
            {
               h.set_backstyle(int(_loc4_));
               if(ignore_top == false)
               {
                  ph.set_backstyle(int(_loc4_));
               }
               if(debug)
               {
                  trace("Set set_backstyle: ph" + _loc4_);
               }
            }
            else
            {
               swap_art(h,_loc3_,_loc4_);
               if(_loc4_ == "_blank")
               {
                  h.trans.deselect();
               }
               if(ignore_top == false)
               {
                  swap_art(ph,_loc3_,_loc4_);
               }
            }
         }
      }
      
      public function _(param1:String) : String
      {
         return GetText.translate(param1);
      }
      
      private function go_page_top(param1:int) : void
      {
         if(debug)
         {
            trace("Page: " + param1);
         }
         top_page = Math.max(0,top_page + param1);
         top_page = Math.min(top_page,int(top_list.length / top_count));
         if(debug)
         {
            trace("Page: " + top_page);
         }
         draw_list_top();
      }
      
      public function set_head(param1:Head) : void
      {
         var _loc2_:int = 0;
         if(debug)
         {
            trace("Set head in art library");
         }
         h = param1;
         if(debug)
         {
            trace("Head ppd: " + h.ppd);
         }
         ph = new Head(h.ppd,h.cld);
         ph.enable_bdats();
         if(buttons == null)
         {
            buttons = new Array();
            _loc2_ = 0;
            while(_loc2_ < 12)
            {
               buttons[_loc2_] = new MovieClip();
               addChild(buttons[_loc2_]);
               buttons[_loc2_].addChild(new Bitmap());
               buttons[_loc2_].visible = false;
               buttons[_loc2_].selected = false;
               buttons[_loc2_].addEventListener(MouseEvent.CLICK,swap_stuff);
               buttons[_loc2_].addEventListener(MouseEvent.MOUSE_OVER,high);
               buttons[_loc2_].addEventListener(MouseEvent.MOUSE_OUT,off);
               buttons[_loc2_].name = _loc2_;
               buttons[_loc2_].buttonMode = true;
               _loc2_ = _loc2_ + 1;
            }
            if(debug)
            {
               trace("Heads are set");
            }
         }
      }
      
      private function equalize() : void
      {
         var _loc1_:* = null;
         if(h.hairstyle != ph.hairstyle)
         {
            ph.set_hairstyle(h.hairstyle);
         }
         if(h.beardstyle != ph.beardstyle)
         {
            ph.set_beardstyle(h.beardstyle);
         }
         if(h.backstyle != ph.backstyle)
         {
            ph.set_backstyle(h.backstyle);
         }
         for(_loc1_ in h.pieces)
         {
            if(h.pieces[_loc1_]["art_id"] != ph.pieces[_loc1_]["art_id"])
            {
               swap_art(ph,h.pieces[_loc1_]["art_type"],h.pieces[_loc1_]["art_id"]);
            }
         }
      }
      
      public function get_swap_list(param1:String) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:* = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Number = NaN;
         var _loc13_:String = null;
         var _loc14_:* = undefined;
         var _loc15_:Array = null;
         var _loc2_:Array = new Array();
         if(param1.substr(0,3) == "wiz")
         {
            _loc6_ = {
               "eyebrows":{
                  "1":[[["brow","brow_art12"]],[["brow","brow_art14"]],[["brow","brow_art3"]],[["brow","brow_art1"]],[["brow","brow_art2"]],[["brow","brow_art11"]],[["brow","brow_art9"]]],
                  "2":[[["brow","brow_art12"]],[["brow","brow_art13"]],[["brow","brow_art8"]],[["brow","brow_art3"]],[["brow","brow_art10"]],[["brow","brow_art11"]],[["brow","brow_art5"]]]
               },
               "head":{"1":[[["cranium","cranium_art4"],["jaw","jaw_art3"]],[["cranium","cranium_art2"],["jaw","jaw_art2"]],[["cranium","cranium_art1"],["jaw","jaw_art1"]],[["cranium","cranium_art6"],["jaw","jaw_art10"]],[["cranium","cranium_art9"],["jaw","jaw_art5"]]]},
               "eyes":{
                  "1":[[["eye","eye_art3"]],[["eye","eye_art2"]],[["eye","eye_art1"]],[["eye","eye_art9"]],[["eye","eye_art8"]]],
                  "2":[[["eye","eye_art3"],["eyelash","eyelash_art3"]],[["eye","eye_art2"],["eyelash","eyelash_art1"]],[["eye","eye_art1"],["eyelash","eyelash_art2"]],[["eye","eye_art9"],["eyelash","eyelash_art3"]],[["eye","eye_art8"],["eyelash","eyelash_art1"]]]
               },
               "mouth":{
                  "1":[[["mouth","mouth_art5"]],[["mouth","mouth_art6"]],[["mouth","mouth_art1"]],[["mouth","mouth_art2"]],[["mouth","mouth_art3"]]],
                  "2":[[["mouth","mouth_art2"]],[["mouth","mouth_art1"]],[["mouth","mouth_art3"]],[["mouth","mouth_art5"]],[["mouth","mouth_art6"]]]
               },
               "nose":{
                  "1":[[["nose","nose_art4"]],[["nose","nose_art15"]],[["nose","nose_art3"]],[["nose","nose_art1"]],[["nose","nose_art6"]],[["nose","nose_art16"]],[["nose","nose_art19"]]],
                  "2":[[["nose","nose_art16"]],[["nose","nose_art19"]],[["nose","nose_art7"]],[["nose","nose_art4"]],[["nose","nose_art5"]],[["nose","nose_art18"]],[["nose","nose_art15"]]]
               },
               "hairstyle":{
                  "1":[[["hairstyle","cut_3"],["style","style_14"]],[["hairstyle","cut_5"],["style","style_4"]],[["hairstyle","cut_4"],["style","style_5"]],[["hairstyle","cut_1"],["style","style_1"]],[["hairstyle","cut_6"],["style","style_6"]],[["hairstyle","cut_24"],["style","style_20"]],[["hairstyle","cut_3"],["style","style_14"]]],
                  "2":[[["hairstyle","cut_13"],["style","style_6"]],[["hairstyle","cut_29"],["style","style_24"]],[["hairstyle","cut_10"],["style","style_11"]],[["hairstyle","cut_18"],["style","style_1"]],[["hairstyle","cut_11"],["style","style_13"]],[["hairstyle","cut_31"],["style","style_28"]],[["hairstyle","cut_34"],["style","style_31"]]]
               }
            };
            _loc7_ = {
               "wiz4":"head",
               "wiz5":"hairstyle",
               "wiz6":"nose",
               "wiz7":"eyes",
               "wiz8":"eyebrows",
               "wiz9":"mouth"
            };
            if(_loc6_[_loc7_[param1]][body.sex])
            {
               _loc2_ = _loc6_[_loc7_[param1]][body.sex];
               if(debug)
               {
                  trace("Sex Swaps: " + body.sex + _loc2_ + " " + param1);
               }
            }
            else
            {
               _loc2_ = _loc6_[_loc7_[param1]]["1"];
               if(debug)
               {
                  trace("Defautling to male: " + param1);
               }
            }
            if(param1 == "wiz5")
            {
               _loc8_ = new Array();
               for(_loc9_ in _loc2_)
               {
                  _loc10_ = cuts[_loc2_[_loc9_][0][1]];
                  _loc11_ = styles[_loc2_[_loc9_][1][1]];
                  _loc8_.push([["hairstyles",_loc10_[0]],["backstyle",_loc10_[1]],["forehead",_loc11_[1]],["hair_front",_loc11_[0]]]);
               }
               return _loc8_;
            }
            return _loc2_;
         }
         if(param1 != "hairstyles")
         {
            if(param1 == "beardstyle")
            {
               _loc3_ = [0,1,2,6,3,4,5];
            }
            else
            {
               if(debug)
               {
                  trace("Getting filters" + param1);
               }
               _loc12_ = 0;
               if(param1 == "eyelash")
               {
                  _loc12_ = h.get_art_id("eye_L").split("art")[1];
                  if(debug)
                  {
                     trace("EYELASH FILTER: " + _loc12_);
                  }
               }
               if(debug)
               {
                  trace("Art order: " + art_order[param1] + " " + body);
               }
               if(art_order[param1])
               {
                  if(art_order[param1][body.sex])
                  {
                     _loc3_ = art_order[param1][body.sex];
                  }
                  else
                  {
                     _loc3_ = art_order[param1]["1"];
                  }
                  if(debug)
                  {
                     trace("Temp order: " + _loc3_);
                  }
               }
               else
               {
                  _loc3_ = artwork.sorted_index(param1,_loc12_);
               }
            }
         }
         if(param1 == "forehead" || param1 == "hair_front")
         {
            _loc13_ = "cut_1";
            if(cut_maps[h.hairstyle] && cut_maps[h.hairstyle][h.backstyle])
            {
               _loc13_ = cut_maps[h.hairstyle][h.backstyle];
            }
            for(_loc14_ in cut_styles[_loc13_])
            {
               _loc15_ = styles[cut_styles[_loc13_][_loc14_]];
               _loc2_.push([["hair_front",_loc15_[0]],["forehead",_loc15_[1]]]);
            }
         }
         else if(param1 == "hairstyles")
         {
            for(_loc14_ in cut_list[body.sex])
            {
               _loc13_ = cut_list[body.sex][_loc14_];
               _loc15_ = styles[cut_styles[_loc13_][0]];
               _loc2_.push([["hairstyles",cuts[_loc13_][0]],["backstyle",cuts[_loc13_][1]],["hair_front",_loc15_[0]],["forehead",_loc15_[1]]]);
            }
         }
         else
         {
            for(_loc14_ in _loc3_)
            {
               _loc2_.push([[param1,_loc3_[_loc14_]]]);
            }
            if(param1 == "hairstyles")
            {
               _loc14_ = 0;
               while(_loc14_ < 17)
               {
                  _loc2_.push([["backstyle",_loc14_]]);
                  _loc14_ = _loc14_ + 1;
               }
            }
            if(param1 == "beardstyle")
            {
               _loc14_ = 0;
               while(_loc14_ < _loc2_.length)
               {
                  _loc2_[_loc14_].push(["goatee","_blank"]);
                  _loc14_ = _loc14_ + 1;
               }
               _loc2_.push([["beardstyle","0"],["goatee","goatee_art1"]]);
               _loc2_.push([["beardstyle","0"],["goatee","goatee_art2"]]);
               _loc2_.push([["beardstyle","0"],["goatee","goatee_art3"]]);
               _loc2_.push([["beardstyle","0"],["goatee","goatee_art4"]]);
            }
         }
         return _loc2_;
      }
      
      public function set_buttons(param1:SimpleButton, param2:SimpleButton) : void
      {
         var p_left:SimpleButton = param1;
         var p_right:SimpleButton = param2;
         page_left = p_left;
         page_right = p_right;
         page_left.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            go_page_top(-1);
         });
         page_right.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            go_page_top(1);
         });
         page_left.visible = false;
         page_right.visible = false;
      }
      
      private function center_point(param1:Sprite) : Point
      {
         var _loc2_:Rectangle = param1.getBounds(this);
         return new Point(_loc2_.x + _loc2_.width / 2,_loc2_.y + _loc2_.height / 2);
      }
      
      private function update_selected_states() : void
      {
         var _loc1_:* = null;
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:* = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:* = null;
         for(_loc1_ in swap_options)
         {
            _loc2_ = swap_options[_loc1_];
            _loc3_ = true;
            buttons[_loc1_].selected = false;
            buttons[_loc1_].filters = [];
            if(junk_set != false)
            {
               for(_loc4_ in _loc2_)
               {
                  _loc5_ = _loc2_[_loc4_][0];
                  _loc6_ = _loc2_[_loc4_][1];
                  if(_loc5_ == "hairstyles")
                  {
                     if(h.hairstyle != int(_loc6_))
                     {
                        _loc3_ = false;
                     }
                  }
                  else if(_loc5_ == "beardstyle")
                  {
                     if(h.beardstyle != int(_loc6_))
                     {
                        _loc3_ = false;
                     }
                  }
                  else if(_loc5_ == "backstyle")
                  {
                     if(h.backstyle != int(_loc6_))
                     {
                        _loc3_ = false;
                     }
                  }
                  else
                  {
                     for(_loc7_ in h.pieces)
                     {
                        if(h.pieces[_loc7_]["art_type"] == _loc5_ && h.pieces[_loc7_]["art_id"] != _loc6_)
                        {
                           _loc3_ = false;
                           break;
                        }
                     }
                  }
                  if(_loc3_ == false)
                  {
                     break;
                  }
               }
               if(_loc3_)
               {
                  buttons[_loc1_].selected = true;
                  buttons[_loc1_].filters = [glow_selected];
               }
            }
         }
      }
      
      private function scale_me(param1:Sprite, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         param1.x = 0;
         param1.y = 0;
         var _loc3_:Rectangle = param1.getBounds(param1);
         if(_loc3_.width > _loc3_.height)
         {
            _loc4_ = param2 / _loc3_.width;
         }
         else
         {
            _loc4_ = param2 / _loc3_.height;
         }
         param1.scaleX = _loc4_;
         param1.scaleY = _loc4_;
      }
      
      public function type_click(param1:String) : void
      {
         if(param1 == null)
         {
            return;
         }
         selected_type = param1;
         if(ignore_top == true)
         {
            return;
         }
         ph.set_rotation(0);
         if(debug)
         {
            trace("They clicked on type: " + param1);
         }
         if(debug)
         {
            trace("TCL: " + tcl[param1]);
         }
         top_list = get_swap_list(tcl[param1][0]);
         if(junk_set)
         {
            lib_big.type_lbl.text = lib_small_top.type_lbl.text = get_label(tcl[param1][0]);
            if(tcl[param1].length > 1)
            {
               bottom_list = get_swap_list(tcl[param1][1]);
               top_count = 6;
               lib_big.visible = false;
               lib_big.alpha = 0;
               lib_small_top.visible = true;
               lib_small_bottom.visible = true;
               lib_small_bottom.type_lbl.text = get_label(tcl[param1][1]);
            }
            else
            {
               lib_small_top.visible = false;
               lib_small_bottom.visible = false;
               lib_big.visible = true;
               lib_big.alpha = 1;
               top_count = 12;
               bottom_list = null;
            }
         }
         else
         {
            top_count = 12;
            bottom_list = null;
         }
         top_page = 0;
         bottom_page = 0;
         if(junk_set)
         {
            head_buttons.select(type2int(tcl[param1][0]));
         }
         draw_list_top();
         if(bottom_list)
         {
            draw_list_bottom();
         }
      }
      
      private function type2int(param1:String) : uint
      {
         if(debug)
         {
            trace("Type2Int: " + param1);
         }
         return hb_tags[param1];
      }
      
      private function get_label(param1:String) : String
      {
         var _loc2_:Object = new Object();
         _loc2_["hat"] = _("Headwear");
         _loc2_["glasses"] = _("Glasses");
         _loc2_["cranium"] = _("Craniums");
         _loc2_["jaw"] = _("Jaws");
         _loc2_["hairstyles"] = _("Hairstyles");
         _loc2_["hair_front"] = _("Foreheads and Bangs");
         _loc2_["brow"] = _("Eyebrows");
         _loc2_["eye"] = _("Eyes");
         _loc2_["eyelash"] = _("Eyelashes");
         _loc2_["pupil"] = _("Pupils");
         _loc2_["nose"] = _("Noses");
         _loc2_["mouth"] = _("Mouths");
         _loc2_["ear"] = _("Ears");
         _loc2_["earring"] = _("Earrings");
         _loc2_["cheek"] = _("Cheeks");
         _loc2_["chin"] = _("Chins");
         _loc2_["beardstyle"] = _("Beards and Goatees");
         _loc2_["moustache"] = _("Moustaches");
         _loc2_["detail_L"] = _("Cheek Details");
         _loc2_["detail_T"] = _("Forehead Details");
         _loc2_["detail_E"] = _("Eye Details");
         if(_loc2_[param1] == undefined)
         {
            return "FIX GET_LABEL - " + param1;
         }
         return _loc2_[param1];
      }
      
      private function blank() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 12)
         {
            head_buttons.de_light(_loc1_);
            _loc1_ = _loc1_ + 1;
         }
      }
      
      private function swap_art(param1:Head, param2:String, param3:String) : void
      {
         var _loc4_:* = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:uint = 0;
         var _loc11_:String = null;
         if(param2 == "colour")
         {
            _loc5_ = int(param3);
            param1.cld.set_colour("926715",_loc5_);
            return;
         }
         if(param2 == "jaw")
         {
            if(param1.get_art_id("beard") != "_blank")
            {
               _loc6_ = string2art_id(param3);
               swap_art(param1,"beard","beard_art" + _loc6_);
            }
         }
         if(param2 == "eyelash" && param3 != "_blank" && param3 != null)
         {
            if(param1.get_art_id("eye_L") != "_blank")
            {
               _loc7_ = string2art_id(param1.get_art_id("eye_L"));
               _loc8_ = string2art_id(param3);
               param3 = "eyelash_art" + _loc8_ + "_" + _loc7_;
            }
         }
         if(param2 == "hairstyles")
         {
            param1.set_hairstyle(int(param3));
            return;
         }
         if(param2 == "beardstyle")
         {
            if(debug)
            {
               trace("BEARD " + param3);
            }
            param1.set_beardstyle(int(param3));
            return;
         }
         if(param2 == "backstyle")
         {
            if(debug)
            {
               trace("BACKSTYLE " + param3);
            }
            param1.set_backstyle(int(param3));
            return;
         }
         for(_loc4_ in param1.pieces)
         {
            if(param1.pieces[_loc4_]["art_type"] == param2)
            {
               param1.pieces[_loc4_].set_art(artwork.get_art(param2,param3,0),param3);
            }
         }
         if(param2 == "cranium")
         {
            param1.set_hairstyle(param1.hairstyle);
         }
         if(param2 == "beard")
         {
            param1.set_beardstyle(param1.beardstyle);
         }
         if(param2 == "eye")
         {
            if(debug)
            {
               trace("SWAPPING EYE: ");
            }
            if(param1.get_art_id("eyelash_L") != "_blank")
            {
               _loc9_ = string2art_id(param1.get_art_id("eyelash_L"));
               _loc10_ = 1;
               if(param3 != "_blank" && param3 != null)
               {
                  _loc10_ = param3.split("art")[1];
                  _loc11_ = "eyelash_art" + _loc9_ + "_" + _loc10_;
                  if(debug)
                  {
                     trace("\tSWAPPING EYELASH: " + _loc11_);
                  }
                  swap_art(param1,"eyelash",_loc11_);
               }
               else if(debug)
               {
                  trace("\tSwapping eye to blank, leaving eyelash alone");
               }
            }
         }
         if(param2 == "eyelash")
         {
            param1.get_piece("eye_L").update_locks();
            param1.get_piece("eye_R").update_locks();
         }
         if(param2 == "hair_back")
         {
            param1.hair_back.set_art(artwork.get_art(param2,param3,0),param3);
         }
      }
      
      private function high(param1:MouseEvent) : void
      {
         var _loc2_:Object = param1.currentTarget;
         if(_loc2_.selected)
         {
            return;
         }
         _loc2_.filters = [glow_high];
      }
      
      public function set_body(param1:SkeletonBuddy) : void
      {
         body = param1;
      }
      
      private function swap_stuff(param1:MouseEvent) : void
      {
         var _loc2_:Object = param1.currentTarget;
         if(debug)
         {
            trace("They want to swap: " + _loc2_.name + " " + swap_options[_loc2_.name]);
         }
         trace("They want to swap: " + _loc2_.name + " " + swap_options[_loc2_.name]);
         do_swaps(swap_options[_loc2_.name]);
         if(bottom_list != null)
         {
            if(_loc2_.name < 6)
            {
               bottom_list = get_swap_list(tcl[selected_type][1]);
               go_page_bottom(-10);
            }
            else
            {
               draw_list_top();
            }
         }
         update_selected_states();
      }
      
      private function hairstyles(param1:Event) : void
      {
         if(debug)
         {
            trace("They want to display some hairstyles...");
         }
      }
      
      private function draw_list_top() : void
      {
         var _loc6_:Array = null;
         var _loc7_:* = null;
         var _loc8_:Bitmap = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Array = null;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         if(ignore_top)
         {
            return;
         }
         trace("Equalizing:");
         equalize();
         var _loc1_:Array = top_list.slice(top_page * top_count,(top_page + 1) * top_count);
         var _loc2_:int = top_list.length / top_count;
         if(top_list.length % top_count != 0)
         {
            _loc2_ = _loc2_ + 1;
         }
         if(junk_set)
         {
            lib_small_top.page_left.visible = lib_small_top.page_right.visible = lib_big.page_left.visible = lib_big.page_right.visible = false;
            lib_small_top.page_lbl.text = lib_big.page_lbl.text = top_page + 1 + "/" + _loc2_;
            if(top_page > 0)
            {
               lib_big.page_left.visible = lib_small_top.page_left.visible = true;
            }
            if(top_list.length > (top_page + 1) * top_count)
            {
               lib_big.page_right.visible = lib_small_top.page_right.visible = true;
            }
            if(top_count == 6)
            {
               if(debug)
               {
                  trace("HIDE MOFO LIB_BIG");
               }
               lib_big.visible = false;
               if(debug)
               {
                  trace("LIB BIG" + lib_big);
               }
            }
         }
         var _loc3_:int = 0;
         while(_loc3_ < top_count)
         {
            buttons[_loc3_].visible = false;
            _loc3_ = _loc3_ + 1;
         }
         var _loc4_:Number = 1;
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc6_ = _loc1_[_loc3_];
            if(debug)
            {
               trace("Swaps: " + _loc6_);
            }
            for(_loc7_ in _loc6_)
            {
               swap_art(ph,_loc6_[_loc7_][0],_loc6_[_loc7_][1]);
            }
            swap_options[_loc3_] = _loc6_;
            _loc8_ = buttons[_loc3_].getChildAt(0);
            ph.bdat_update();
            _loc8_.bitmapData = Utils.alphaBitmapData(ph.bdat);
            _loc8_.smoothing = true;
            scale_me(buttons[_loc3_],150);
            scale_me(buttons[_loc3_],80);
            _loc4_ = Math.min(buttons[_loc3_].scaleX,_loc4_);
            _loc3_ = _loc3_ + 1;
         }
         var _loc5_:int = 3;
         if(top_count == 6)
         {
            _loc5_ = 1;
         }
         if(junk_set == false)
         {
            _loc4_ = 1;
            trace("BUTTON 0 WIDTH: " + buttons[0].getBounds(buttons[0]) + " " + selected_type);
            _loc9_ = 560 / 2;
            _loc10_ = 560 / 3;
            _loc11_ = 750 / 2;
            _loc12_ = 750 / 3;
            _loc13_ = 130;
            _loc14_ = 280;
            _loc15_ = 430;
            _loc16_ = 100;
            _loc17_ = 175;
            _loc18_ = [[_loc11_ - _loc16_,_loc13_],[_loc11_ + _loc16_,_loc13_],[_loc11_ - _loc17_,_loc14_],[_loc11_,_loc14_],[_loc11_ + _loc17_,_loc14_],[_loc11_ - _loc16_,_loc15_],[_loc11_ + _loc16_,_loc15_]];
            if(top_list.length == 5)
            {
               _loc16_ = 125;
               _loc18_ = [[_loc11_ - _loc16_,_loc13_],[_loc11_ + _loc16_,_loc13_],[_loc11_,_loc14_],[_loc11_ - _loc16_,_loc15_],[_loc11_ + _loc16_,_loc15_]];
            }
            if(selected_type == "wiz5")
            {
               _loc18_[5][1] = _loc18_[5][1] - 20;
               _loc18_[6][1] = _loc18_[6][1] - 20;
            }
         }
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            buttons[_loc3_].scaleX = buttons[_loc3_].scaleY = _loc4_;
            _loc19_ = 80 / 2 + 5;
            _loc20_ = 80 / 2 + _loc5_;
            if(junk_set == false)
            {
               _loc19_ = _loc18_[_loc3_][0];
               _loc20_ = _loc18_[_loc3_][1];
               center_piece(buttons[_loc3_],_loc19_,_loc20_);
            }
            else
            {
               center_piece(buttons[_loc3_],_loc19_ + 2 * _loc19_ * (_loc3_ % 3) + 10,_loc20_ + int(_loc3_ / 3) * (_loc20_ * 2) + _loc5_ * 2);
            }
            buttons[_loc3_].visible = true;
            _loc3_ = _loc3_ + 1;
         }
         if(debug && junk_set)
         {
            trace("Done Top!" + lib_big.visible);
         }
         update_selected_states();
      }
      
      private function draw_list_bottom() : void
      {
         var _loc6_:Array = null;
         var _loc7_:* = null;
         var _loc8_:Bitmap = null;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         equalize();
         var _loc1_:uint = 6;
         var _loc2_:Array = bottom_list.slice(bottom_page * 6,(bottom_page + 1) * 6);
         lib_small_bottom.page_left.visible = lib_small_bottom.page_right.visible = false;
         if(bottom_page > 0)
         {
            lib_small_bottom.page_left.visible = true;
         }
         if(bottom_list.length > (bottom_page + 1) * _loc1_)
         {
            lib_small_bottom.page_right.visible = true;
         }
         lib_big.visible = false;
         var _loc3_:int = bottom_list.length / 6;
         if(bottom_list.length % 6 != 0)
         {
            _loc3_ = _loc3_ + 1;
         }
         lib_small_bottom.page_lbl.text = bottom_page + 1 + "/" + _loc3_;
         var _loc4_:int = 6;
         while(_loc4_ < 12)
         {
            buttons[_loc4_].visible = false;
            _loc4_ = _loc4_ + 1;
         }
         var _loc5_:Number = 1;
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc6_ = _loc2_[_loc4_];
            if(debug)
            {
               trace("Swaps: " + _loc6_);
            }
            for(_loc7_ in _loc6_)
            {
               swap_art(ph,_loc6_[_loc7_][0],_loc6_[_loc7_][1]);
            }
            swap_options[_loc4_ + 6] = _loc6_;
            _loc8_ = buttons[_loc4_ + 6].getChildAt(0);
            ph.bdat_update();
            _loc8_.bitmapData = Utils.alphaBitmapData(ph.bdat);
            _loc8_.smoothing = true;
            scale_me(buttons[_loc4_ + 6],80);
            _loc5_ = Math.min(buttons[_loc4_ + 6].scaleX,_loc5_);
            _loc4_ = _loc4_ + 1;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc9_ = _loc4_ + 6;
            buttons[_loc9_].scaleX = buttons[_loc9_].scaleY = _loc5_;
            _loc10_ = 80 / 2 + 5;
            _loc11_ = 80 / 2 + 1;
            center_piece(buttons[_loc4_ + 6],_loc10_ + 2 * _loc10_ * (_loc4_ % 3) + 10,_loc11_ + int(_loc9_ / 3) * (_loc11_ * 2) + 2 + 28);
            buttons[_loc9_].visible = true;
            _loc4_ = _loc4_ + 1;
         }
         if(debug)
         {
            trace("Done BOttom! " + lib_big.visible + " " + lib_big);
         }
         update_selected_states();
      }
      
      private function off(param1:MouseEvent) : void
      {
         var _loc2_:Object = param1.currentTarget;
         if(_loc2_.selected)
         {
            return;
         }
         _loc2_.filters = [];
      }
      
      public function head_event(param1:String, param2:String = undefined) : void
      {
         var _loc3_:int = 0;
         trace("Event: ---------------------------------------" + param1 + " - " + param2);
         if(param2 == "hair_back")
         {
            param2 = "cranium";
         }
         if(param1 == "new_colour")
         {
            ph.update_colours();
         }
         else if(param1 == "piece_down")
         {
            type_click(param2);
         }
         else if(param1 == "piece_over")
         {
            if(head_buttons)
            {
               head_buttons.highlight(type2int(tcl[param2][0]));
            }
         }
         else if(param1 == "piece_out")
         {
            if(head_buttons)
            {
               head_buttons.de_light(type2int(tcl[param2][0]));
            }
         }
         else if(param1 != "updated")
         {
            if(param1 == "exp_update")
            {
               return;
            }
            if(param1 == "blank")
            {
               swap_art(ph,param2,"_blank");
            }
            else if(debug)
            {
               trace("Unknown event: " + param1);
            }
         }
      }
   }
}
