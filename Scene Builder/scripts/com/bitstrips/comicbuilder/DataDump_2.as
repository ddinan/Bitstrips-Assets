package com.bitstrips.comicbuilder
{
   import com.bitstrips.BSConstants;
   import com.bitstrips.core.Depth;
   
   public class DataDump
   {
       
      
      public function DataDump()
      {
         super();
         trace("--DataDump()--");
      }
      
      public static function getMessageBubble_b() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["name"] = "b_bubble";
         _loc1_["id"] = "xx";
         _loc1_["type"] = "text bubble";
         _loc1_["bmpURL"] = "../assets/dummy/testbits0032.png";
         _loc1_["lockedGround"] = false;
         _loc1_["locked"] = false;
         _loc1_["lockedEditing"] = false;
         _loc1_["turn"] = 0;
         _loc1_["dragOffset"] = new Object();
         _loc1_["dragOffset"]["x"] = 0;
         _loc1_["dragOffset"]["y"] = 0;
         _loc1_["position"] = new Object();
         _loc1_["position"]["x"] = 120;
         _loc1_["position"]["y"] = 70;
         _loc1_["position"]["deviation"] = 120;
         _loc1_["position"]["z"] = 0;
         _loc1_["position"]["float"] = 104;
         _loc1_["textData"] = new Object();
         _loc1_["textData"]["style"] = "message";
         _loc1_["textData"]["size"] = 15;
         _loc1_["textData"]["italic"] = false;
         _loc1_["textData"]["bold"] = false;
         _loc1_["textData"]["bkgrColor"] = 16777215;
         _loc1_["textData"]["lightText"] = false;
         _loc1_["textData"]["cornerRound"] = 100;
         _loc1_["textData"]["content"] = "placeholder for eventual replies";
         _loc1_["pointer"] = new Object();
         _loc1_["pointer"]["style"] = "message";
         _loc1_["pointer"]["bkgrColor"] = 16777215;
         _loc1_["pointer"]["centerX"] = 0;
         _loc1_["pointer"]["centerY"] = 0;
         _loc1_["pointer"]["controlY"] = 100;
         _loc1_["pointer"]["controlX"] = 125;
         _loc1_["pointer"]["rotation"] = -55;
         _loc1_["pointer"]["width"] = 20;
         _loc1_["pointer"]["curve"] = -50;
         return _loc1_;
      }
      
      public static function getDefaultComic_complex() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.editable = true;
         _loc1_["rescale"] = 0.45;
         _loc1_.comicID = "0";
         _loc1_.comicTitle = "";
         _loc1_.comicAuthorName = "";
         _loc1_.series = 0;
         _loc1_.episode = 0;
         _loc1_.panel_default = 3;
         _loc1_.panel_max = 6;
         _loc1_.panel_min = 1;
         _loc1_.strip_max = 2;
         _loc1_.strip_min = 1;
         _loc1_.comicWidth = 750;
         _loc1_.comicHeight = 380;
         _loc1_.height_min = 100;
         _loc1_.height_max = 380;
         _loc1_.width_min = 100;
         _loc1_.width_max = 750;
         _loc1_.bkgrColor = 16777215;
         _loc1_.strips = getComicLayout(3).strips;
         return _loc1_;
      }
      
      public static function panel_data_update(param1:Object) : Object
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc2_:Object = {};
         if(param1.hasOwnProperty("backdrop") || param1.hasOwnProperty("content_x") == false)
         {
            _loc2_["content_x"] = param1["pan_x"];
            _loc2_["content_y"] = param1["pan_y"];
            _loc2_["content_scale"] = param1["cameraScale"];
            _loc2_["width"] = param1["width"];
            _loc2_["height"] = param1["height"];
            _loc2_["contents"] = {};
            _loc2_["contents"]["backdrop"] = param1["backdrop"];
            _loc2_["contents"]["backdrop_color"] = param1["backdrop_color"];
            _loc2_["contents"]["floor"] = param1["floor"];
            _loc2_["contents"]["floor_color"] = param1["floor_color"];
            _loc2_["contents"]["contentList"] = [];
            _loc2_["text_contents"] = {"contentList":[]};
            _loc3_ = 0;
            while(_loc3_ < param1["contentList"].length)
            {
               _loc4_ = param1["contentList"][_loc3_];
               if(_loc4_["type"] == "text bubble")
               {
                  _loc4_["type"] = "promoted text";
                  _loc2_["text_contents"]["contentList"].push(_loc4_);
                  _loc4_["position"].y = _loc4_["position"].y - 89;
               }
               else
               {
                  param1["height"] = 0;
                  _loc5_ = Depth.depth_translate(_loc4_.position,param1["angle_y"],param1["angle_x"],178);
                  _loc4_.position.x = _loc5_.x;
                  _loc4_.position.y = _loc4_.position.y - 125;
                  if(_loc4_.scale)
                  {
                     _loc4_.scale = _loc5_.scale * _loc4_.scale;
                  }
                  else
                  {
                     _loc4_.scale = _loc5_.scale;
                  }
                  _loc2_["contents"]["contentList"].push(_loc4_);
               }
               _loc3_++;
            }
            return _loc2_;
         }
         return param1;
      }
      
      public static function update_comic_data(param1:Object) : Object
      {
         var _loc3_:int = 0;
         trace("Yeah!");
         var _loc2_:int = 0;
         while(_loc2_ < param1.strips.length)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.strips[_loc2_].panels.length)
            {
               param1.strips[_loc2_].panels[_loc3_] = DataDump.panel_data_update(param1.strips[_loc2_].panels[_loc3_]);
               _loc3_++;
            }
            _loc2_++;
         }
         return param1;
      }
      
      public static function getDefaultComic_char(param1:String) : Object
      {
         var _loc2_:* = BSConstants.CHARS_URL + "thumb" + param1 + ".png";
         return {
            "panel_default":3,
            "rescale":0.45,
            "version":3,
            "series":0,
            "height_min":100,
            "comicAuthorName":null,
            "width_max":750,
            "strips":[{
               "panels":[{
                  "height":275,
                  "bkgrColor":16777215,
                  "contentList":[],
                  "editable":false,
                  "content_rotation":0,
                  "content_y":180,
                  "contents":{
                     "filters":{
                        "alpha":1,
                        "saturation":1,
                        "brightness":0,
                        "contrast":0,
                        "threshold":0,
                        "hue":0
                     },
                     "children_filter":true,
                     "backdrop_color":16777215,
                     "backdrop":"backdrop1",
                     "contentList":[{
                        "bmpURL":_loc2_,
                        "id":param1,
                        "dragOffset":{
                           "y":-161,
                           "x":225
                        },
                        "asset_type":"characters",
                        "char_id":param1,
                        "lockedGround":true,
                        "name":"1",
                        "turn":0,
                        "filters":{
                           "alpha":1,
                           "saturation":1,
                           "brightness":0,
                           "contrast":0,
                           "threshold":0,
                           "hue":0
                        },
                        "type":"characters",
                        "lockedEditing":false,
                        "order":1000,
                        "stage_y":383.15,
                        "body":{
                           "body_rotation":0,
                           "gesture":1,
                           "stance":1,
                           "hands":[15,15],
                           "sitting":false,
                           "head_angle":0,
                           "action":false,
                           "head":{
                              "pupils":[{
                                 "x":0,
                                 "width":0.25,
                                 "y":0
                              },{
                                 "x":0,
                                 "width":0.25,
                                 "y":0
                              }],
                              "lipsync":1,
                              "expression":1,
                              "mouth_expression":1,
                              "lids":[1,1],
                              "h_rot":0
                           },
                           "standing":true,
                           "pose":0
                        },
                        "position":{
                           "x":0,
                           "y":70
                        },
                        "sceneBit":false,
                        "version":"-1",
                        "scale":1,
                        "locked":false,
                        "stage_x":123.9,
                        "thumb":_loc2_
                     }],
                     "floor_color":16777215,
                     "floor":"floor1"
                  },
                  "cameraScale":1,
                  "angle_x":0,
                  "children_filter":true,
                  "content_scale":1.6,
                  "width":230,
                  "content_x":0
               },{
                  "height":275,
                  "bkgrColor":16777215,
                  "contentList":[],
                  "editable":false,
                  "content_rotation":0,
                  "content_y":180,
                  "contents":{
                     "filters":{
                        "alpha":1,
                        "saturation":1,
                        "brightness":0,
                        "contrast":0,
                        "threshold":0,
                        "hue":0
                     },
                     "children_filter":true,
                     "backdrop_color":16777215,
                     "backdrop":"backdrop1",
                     "contentList":[{
                        "bmpURL":_loc2_,
                        "stage_y":383.15,
                        "scale":1,
                        "asset_type":"characters",
                        "order":1000,
                        "thumb":_loc2_,
                        "name":"1",
                        "turn":0,
                        "version":"-1",
                        "type":"characters",
                        "stage_x":123.9,
                        "position":{
                           "x":0,
                           "y":70
                        },
                        "id":param1,
                        "body":{
                           "body_rotation":1,
                           "gesture":2,
                           "stance":4,
                           "hands":[6,26],
                           "sitting":false,
                           "head_angle":-5.09288878472,
                           "action":false,
                           "head":{
                              "pupils":[{
                                 "x":-0.05,
                                 "width":0.25,
                                 "y":-0.025
                              },{
                                 "x":-0.05,
                                 "width":0.25,
                                 "y":-0.025
                              }],
                              "lipsync":2,
                              "expression":2,
                              "mouth_expression":2,
                              "lids":[1,1],
                              "h_rot":1
                           },
                           "standing":true,
                           "pose":0
                        },
                        "char_id":param1,
                        "sceneBit":false,
                        "filters":{
                           "alpha":1,
                           "saturation":1,
                           "brightness":0,
                           "contrast":0,
                           "threshold":0,
                           "hue":0
                        },
                        "dragOffset":{
                           "y":-180,
                           "x":182
                        },
                        "locked":false,
                        "lockedEditing":false,
                        "lockedGround":true
                     }],
                     "floor_color":16777215,
                     "floor":"floor1"
                  },
                  "cameraScale":1,
                  "angle_x":0,
                  "children_filter":true,
                  "content_scale":1.6,
                  "width":230,
                  "content_x":0
               },{
                  "height":275,
                  "bkgrColor":16777215,
                  "contentList":[],
                  "editable":false,
                  "content_rotation":0,
                  "content_y":180,
                  "contents":{
                     "filters":{
                        "alpha":1,
                        "saturation":1,
                        "brightness":0,
                        "contrast":0,
                        "threshold":0,
                        "hue":0
                     },
                     "children_filter":true,
                     "backdrop_color":16777215,
                     "backdrop":"backdrop1",
                     "contentList":[{
                        "bmpURL":_loc2_,
                        "id":param1,
                        "dragOffset":{
                           "y":-212,
                           "x":-83
                        },
                        "asset_type":"characters",
                        "position":{
                           "x":0,
                           "y":70
                        },
                        "lockedGround":true,
                        "name":"1",
                        "turn":0,
                        "filters":{
                           "alpha":1,
                           "saturation":1,
                           "brightness":0,
                           "contrast":0,
                           "threshold":0,
                           "hue":0
                        },
                        "type":"characters",
                        "lockedEditing":false,
                        "char_id":param1,
                        "stage_y":383.15,
                        "body":{
                           "body_rotation":1,
                           "gesture":2,
                           "stance":4,
                           "hands":[6,26],
                           "sitting":false,
                           "head_angle":-18.071540849,
                           "action":true,
                           "head":{
                              "pupils":[{
                                 "x":0.2,
                                 "width":0.25,
                                 "y":-0.075
                              },{
                                 "x":0.2,
                                 "width":0.25,
                                 "y":-0.075
                              }],
                              "lipsync":3,
                              "expression":2,
                              "mouth_expression":2,
                              "lids":[3,3],
                              "h_rot":1
                           },
                           "standing":false,
                           "pose":int(Math.random() * 10)
                        },
                        "order":1000,
                        "sceneBit":false,
                        "version":"-1",
                        "scale":1,
                        "locked":false,
                        "stage_x":123.9,
                        "thumb":_loc2_
                     }],
                     "floor_color":16777215,
                     "floor":"floor1"
                  },
                  "cameraScale":1,
                  "angle_x":0,
                  "children_filter":true,
                  "content_scale":1.6,
                  "width":230,
                  "content_x":0
               }],
               "height":275
            }],
            "editable":true,
            "panel_min":1,
            "panel_max":6,
            "episode":0,
            "comicTitle":"",
            "height_max":380,
            "bkgrColor":16777215,
            "comicWidth":750,
            "comicID":"0",
            "comicHeight":380,
            "strip_min":1,
            "strip_max":2,
            "width_min":100
         };
      }
      
      public static function defaultPanel() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_ = {
            "content_x":0,
            "content_y":0
         };
         _loc1_.width = 734;
         _loc1_.content_scale = 1.6;
         _loc1_.bkgrColor = 16777215;
         _loc1_.contentList = new Array();
         _loc1_.editable = false;
         return _loc1_;
      }
      
      public static function getComicLayout(param1:uint) : Object
      {
         var _loc2_:Object = new Object();
         switch(param1)
         {
            case 1:
               _loc2_.strips = new Array(1);
               _loc2_.strips[0] = new Object();
               _loc2_.strips[0].height = 330;
               _loc2_.strips[0].panels = new Array(1);
               _loc2_.strips[0].panels[0] = defaultPanel();
               _loc2_.strips[0].panels[0].width = 276;
               break;
            case 2:
               _loc2_.strips = new Array(1);
               _loc2_.strips[0] = new Object();
               _loc2_.strips[0].height = 330;
               _loc2_.strips[0].panels = new Array(2);
               _loc2_.strips[0].panels[0] = defaultPanel();
               _loc2_.strips[0].panels[0].width = 276;
               _loc2_.strips[0].panels[1] = defaultPanel();
               _loc2_.strips[0].panels[1].width = 276;
               break;
            case 3:
               _loc2_.strips = new Array(1);
               _loc2_.strips[0] = new Object();
               _loc2_.strips[0].height = 275;
               _loc2_.strips[0].panels = new Array(3);
               _loc2_.strips[0].panels[0] = defaultPanel();
               _loc2_.strips[0].panels[0].width = 230;
               _loc2_.strips[0].panels[1] = defaultPanel();
               _loc2_.strips[0].panels[1].width = 230;
               _loc2_.strips[0].panels[2] = defaultPanel();
               _loc2_.strips[0].panels[2].width = 230;
               break;
            case 4:
               _loc2_.strips = new Array(1);
               _loc2_.strips[0] = new Object();
               _loc2_.strips[0].height = 208;
               _loc2_.strips[0].panels = new Array(4);
               _loc2_.strips[0].panels[0] = defaultPanel();
               _loc2_.strips[0].panels[0].width = 174;
               _loc2_.strips[0].panels[1] = defaultPanel();
               _loc2_.strips[0].panels[1].width = 174;
               _loc2_.strips[0].panels[2] = defaultPanel();
               _loc2_.strips[0].panels[2].width = 174;
               _loc2_.strips[0].panels[3] = defaultPanel();
               _loc2_.strips[0].panels[3].width = 174;
               break;
            case 5:
               _loc2_.strips = new Array(2);
               _loc2_.strips[0] = new Object();
               _loc2_.strips[0].height = 175;
               _loc2_.strips[0].panels = new Array(3);
               _loc2_.strips[0].panels[0] = defaultPanel();
               _loc2_.strips[0].panels[0].width = 226;
               _loc2_.strips[0].panels[1] = defaultPanel();
               _loc2_.strips[0].panels[1].width = 226;
               _loc2_.strips[0].panels[2] = defaultPanel();
               _loc2_.strips[0].panels[2].width = 226;
               _loc2_.strips[1] = new Object();
               _loc2_.strips[1].height = 175;
               _loc2_.strips[1].panels = new Array(2);
               _loc2_.strips[1].panels[0] = defaultPanel();
               _loc2_.strips[1].panels[0].width = 343;
               _loc2_.strips[1].panels[1] = defaultPanel();
               _loc2_.strips[1].panels[1].width = 343;
               break;
            case 6:
               _loc2_.strips = new Array(2);
               _loc2_.strips[0] = new Object();
               _loc2_.strips[0].height = 175;
               _loc2_.strips[0].panels = new Array(3);
               _loc2_.strips[0].panels[0] = defaultPanel();
               _loc2_.strips[0].panels[0].width = 226;
               _loc2_.strips[0].panels[1] = defaultPanel();
               _loc2_.strips[0].panels[1].width = 226;
               _loc2_.strips[0].panels[2] = defaultPanel();
               _loc2_.strips[0].panels[2].width = 226;
               _loc2_.strips[1] = new Object();
               _loc2_.strips[1].height = 175;
               _loc2_.strips[1].panels = new Array(3);
               _loc2_.strips[1].panels[0] = defaultPanel();
               _loc2_.strips[1].panels[0].width = 226;
               _loc2_.strips[1].panels[1] = defaultPanel();
               _loc2_.strips[1].panels[1].width = 226;
               _loc2_.strips[1].panels[2] = defaultPanel();
               _loc2_.strips[1].panels[2].width = 226;
               break;
            case 7:
               _loc2_.strips = new Array(2);
               _loc2_.strips[0] = new Object();
               _loc2_.strips[0].height = 175;
               _loc2_.strips[0].panels = new Array(3);
               _loc2_.strips[0].panels[0] = defaultPanel();
               _loc2_.strips[0].panels[0].width = 228;
               _loc2_.strips[0].panels[1] = defaultPanel();
               _loc2_.strips[0].panels[1].width = 228;
               _loc2_.strips[0].panels[2] = defaultPanel();
               _loc2_.strips[0].panels[2].width = 228;
               _loc2_.strips[1] = new Object();
               _loc2_.strips[1].height = 175;
               _loc2_.strips[1].panels = new Array(4);
               _loc2_.strips[1].panels[0] = defaultPanel();
               _loc2_.strips[1].panels[0].width = 169;
               _loc2_.strips[1].panels[1] = defaultPanel();
               _loc2_.strips[1].panels[1].width = 169;
               _loc2_.strips[1].panels[2] = defaultPanel();
               _loc2_.strips[1].panels[2].width = 169;
               _loc2_.strips[1].panels[3] = defaultPanel();
               _loc2_.strips[1].panels[3].width = 169;
               break;
            case 8:
               _loc2_.strips = new Array(2);
               _loc2_.strips[0] = new Object();
               _loc2_.strips[0].height = 175;
               _loc2_.strips[0].panels = new Array(4);
               _loc2_.strips[0].panels[0] = defaultPanel();
               _loc2_.strips[0].panels[0].width = 169;
               _loc2_.strips[0].panels[1] = defaultPanel();
               _loc2_.strips[0].panels[1].width = 169;
               _loc2_.strips[0].panels[2] = defaultPanel();
               _loc2_.strips[0].panels[2].width = 169;
               _loc2_.strips[0].panels[3] = defaultPanel();
               _loc2_.strips[0].panels[3].width = 169;
               _loc2_.strips[1] = new Object();
               _loc2_.strips[1].height = 175;
               _loc2_.strips[1].panels = new Array(4);
               _loc2_.strips[1].panels[0] = defaultPanel();
               _loc2_.strips[1].panels[0].width = 169;
               _loc2_.strips[1].panels[1] = defaultPanel();
               _loc2_.strips[1].panels[1].width = 169;
               _loc2_.strips[1].panels[2] = defaultPanel();
               _loc2_.strips[1].panels[2].width = 169;
               _loc2_.strips[1].panels[3] = defaultPanel();
               _loc2_.strips[1].panels[3].width = 169;
         }
         return _loc2_;
      }
      
      public static function getEmptyScene(param1:Object = null) : Object
      {
         trace("--DataDump.getEmptyScene()--");
         var _loc2_:Object = DataDump.getComicLayout(1);
         _loc2_["comicTitle"] = "";
         _loc2_["comicWidth"] = 750;
         _loc2_["comicHeight"] = 380;
         _loc2_["bkgrColor"] = 16777215;
         _loc2_.strips[0].height = 360;
         _loc2_.strips[0].panels[0].width = 724;
         return _loc2_;
      }
      
      public static function defaultBackdrop() : Object
      {
         return {
            "dragOffset":{
               "x":0,
               "y":0
            },
            "lockedGround":"1",
            "id":"backdrop1",
            "lockedEditing":true,
            "type":"backdrops",
            "bmpURL":null,
            "turn":0,
            "locked":true,
            "position":{
               "deviation":0,
               "z":0.81,
               "float":0
            },
            "name":"backdrop",
            "prop":{
               "state":0,
               "prop_rotation":0
            }
         };
      }
      
      public static function get_MessageTemplate(param1:String, param2:String) : Object
      {
         var _loc3_:Object = new Object();
         _loc3_.editable = true;
         _loc3_.comicID = "0";
         _loc3_.comicTitle = "";
         _loc3_.comicAuthorName = "";
         _loc3_.series = 0;
         _loc3_.episode = 0;
         _loc3_.panel_default = 1;
         _loc3_.panel_max = 6;
         _loc3_.panel_min = 1;
         _loc3_.strip_max = 2;
         _loc3_.strip_min = 1;
         _loc3_.comicWidth = 750;
         _loc3_.comicHeight = 380;
         _loc3_.height_min = 100;
         _loc3_.height_max = 380;
         _loc3_.width_min = 100;
         _loc3_.width_max = 750;
         _loc3_.bkgrColor = 16777215;
         _loc3_.strips = new Array();
         _loc3_.strips[0] = new Object();
         _loc3_.strips[0]["height"] = 364;
         _loc3_.strips[0].panels = new Array();
         _loc3_.strips[0].panels[0] = new Object();
         _loc3_.strips[0].panels[0]["bkgrColor"] = 16777215;
         _loc3_.strips[0].panels[0]["width"] = 734;
         _loc3_.strips[0].panels[0]["height"] = 364;
         _loc3_.strips[0].panels[0]["floor"] = "floor1";
         _loc3_.strips[0].panels[0]["floor_color"] = 16777215;
         _loc3_.strips[0].panels[0]["backdrop"] = "backdrop1";
         _loc3_.strips[0].panels[0]["backdrop_color"] = 16777215;
         _loc3_.strips[0].panels[0]["pan_x"] = 0;
         _loc3_.strips[0].panels[0]["pan_y"] = 0;
         _loc3_.strips[0].panels[0]["angle_x"] = 0;
         _loc3_.strips[0].panels[0]["angle_y"] = 0.8;
         _loc3_.strips[0].panels[0]["cameraScale"] = 1;
         _loc3_.strips[0].panels[0]["editable"] = false;
         _loc3_.strips[0].panels[0]["contentList"] = new Array();
         var _loc4_:Object = new Object();
         _loc4_["name"] = "a_avatar";
         _loc4_["id"] = param1;
         _loc4_["type"] = "characters";
         _loc4_["bmpURL"] = BSConstants.CHARS_URL + "thumb" + param1 + ".png";
         _loc4_["lockedGround"] = true;
         _loc4_["locked"] = true;
         _loc4_["turn"] = 0;
         _loc4_["lockedEditing"] = true;
         _loc4_["dragOffset"] = new Object();
         _loc4_["dragOffset"]["x"] = 0;
         _loc4_["dragOffset"]["y"] = 0;
         _loc4_["position"] = new Object();
         _loc4_["position"]["x"] = 0;
         _loc4_["position"]["deviation"] = -165;
         _loc4_["position"]["z"] = 0.14;
         _loc4_["position"]["float"] = 0;
         _loc4_["body"] = new Object();
         _loc4_["body"]["head_angle"] = 0;
         _loc4_["body"]["gesture"] = 0;
         _loc4_["body"]["action"] = null;
         _loc4_["body"]["pose"] = 0;
         _loc4_["body"]["sitting"] = null;
         _loc4_["body"]["standing"] = 1;
         _loc4_["body"]["body_rotation"] = 1;
         _loc4_["body"]["stance"] = 1;
         _loc4_["body"]["hands"] = new Array();
         _loc4_["body"]["hands"][0] = 5;
         _loc4_["body"]["hands"][1] = 15;
         _loc4_["body"]["head"] = new Object();
         _loc4_["body"]["head"]["lidsynch"] = 1;
         _loc4_["body"]["head"]["lipsync"] = 3;
         _loc4_["body"]["head"]["mouth_expression"] = 1;
         _loc4_["body"]["head"]["expression"] = 1;
         _loc4_["body"]["head"]["h_rot"] = 1;
         _loc4_["body"]["head"]["pupils"] = new Array();
         _loc4_["body"]["head"]["pupils"][0] = new Object();
         _loc4_["body"]["head"]["pupils"][0]["x"] = 0.3;
         _loc4_["body"]["head"]["pupils"][0]["y"] = 0;
         _loc4_["body"]["head"]["pupils"][0]["width"] = 0.25;
         _loc4_["body"]["head"]["pupils"][1] = new Object();
         _loc4_["body"]["head"]["pupils"][1]["x"] = 0.3;
         _loc4_["body"]["head"]["pupils"][1]["y"] = 0;
         _loc4_["body"]["head"]["pupils"][1]["width"] = 0.25;
         _loc3_.strips[0].panels[0]["contentList"][0] = _loc4_;
         var _loc5_:Object = new Object();
         _loc5_["name"] = "b_avatar";
         _loc5_["id"] = param2;
         _loc5_["type"] = "characters";
         _loc5_["bmpURL"] = BSConstants.CHARS_URL + "thumb" + param2 + ".png";
         _loc5_["lockedGround"] = true;
         _loc5_["locked"] = true;
         _loc5_["turn"] = 0;
         _loc5_["lockedEditing"] = true;
         _loc5_["dragOffset"] = new Object();
         _loc5_["dragOffset"]["x"] = 0;
         _loc5_["dragOffset"]["y"] = 0;
         _loc5_["position"] = new Object();
         _loc5_["position"]["x"] = 0;
         _loc5_["position"]["deviation"] = 165;
         _loc5_["position"]["z"] = 0.14;
         _loc5_["position"]["float"] = 0;
         _loc5_["body"] = new Object();
         _loc5_["body"]["head_angle"] = 0;
         _loc5_["body"]["gesture"] = 0;
         _loc5_["body"]["action"] = null;
         _loc5_["body"]["pose"] = 0;
         _loc5_["body"]["sitting"] = null;
         _loc5_["body"]["standing"] = 1;
         _loc5_["body"]["body_rotation"] = 7;
         _loc5_["body"]["stance"] = 1;
         _loc5_["body"]["hands"] = new Array();
         _loc5_["body"]["hands"][0] = 5;
         _loc5_["body"]["hands"][1] = 15;
         _loc5_["body"]["head"] = new Object();
         _loc5_["body"]["head"]["lidsynch"] = 1;
         _loc5_["body"]["head"]["lipsync"] = 1;
         _loc5_["body"]["head"]["mouth_expression"] = 1;
         _loc5_["body"]["head"]["expression"] = 1;
         _loc5_["body"]["head"]["h_rot"] = 7;
         _loc5_["body"]["head"]["pupils"] = new Array();
         _loc5_["body"]["head"]["pupils"][0] = new Object();
         _loc5_["body"]["head"]["pupils"][0]["x"] = -0.3;
         _loc5_["body"]["head"]["pupils"][0]["y"] = 0;
         _loc5_["body"]["head"]["pupils"][0]["width"] = 0.25;
         _loc5_["body"]["head"]["pupils"][1] = new Object();
         _loc5_["body"]["head"]["pupils"][1]["x"] = -0.3;
         _loc5_["body"]["head"]["pupils"][1]["y"] = 0;
         _loc5_["body"]["head"]["pupils"][1]["width"] = 0.25;
         _loc3_.strips[0].panels[0]["contentList"][1] = _loc5_;
         var _loc6_:Object = new Object();
         _loc6_["name"] = "a_bubble";
         _loc6_["id"] = "xx";
         _loc6_["type"] = "text bubble";
         _loc6_["bmpURL"] = "../assets/dummy/testbits0032.png";
         _loc6_["lockedGround"] = true;
         _loc6_["locked"] = true;
         _loc6_["lockedEditing"] = true;
         _loc6_["turn"] = 0;
         _loc6_["dragOffset"] = new Object();
         _loc6_["dragOffset"]["x"] = 0;
         _loc6_["dragOffset"]["y"] = 0;
         _loc6_["position"] = new Object();
         _loc6_["position"]["x"] = -120;
         _loc6_["position"]["y"] = 70;
         _loc6_["position"]["deviation"] = -120;
         _loc6_["position"]["z"] = 0;
         _loc6_["position"]["float"] = 104;
         _loc6_["textData"] = new Object();
         _loc6_["textData"]["style"] = "message";
         _loc6_["textData"]["size"] = 15;
         _loc6_["textData"]["italic"] = null;
         _loc6_["textData"]["bold"] = null;
         _loc6_["textData"]["bkgrColor"] = 16777215;
         _loc6_["textData"]["lightText"] = null;
         _loc6_["textData"]["cornerRound"] = 100;
         _loc6_["textData"]["content"] = "";
         _loc6_["pointer"] = new Object();
         _loc6_["pointer"]["style"] = "message";
         _loc6_["pointer"]["bkgrColor"] = 16777215;
         _loc6_["pointer"]["centerX"] = 0;
         _loc6_["pointer"]["centerY"] = 0;
         _loc6_["pointer"]["controlY"] = 93;
         _loc6_["pointer"]["controlX"] = -152;
         _loc6_["pointer"]["rotation"] = 58;
         _loc6_["pointer"]["width"] = 64.25;
         _loc6_["pointer"]["curve"] = 50;
         _loc3_.strips[0].panels[0]["contentList"][2] = _loc6_;
         var _loc7_:Object = new Object();
         _loc7_["name"] = "b_bubble";
         _loc7_["id"] = "xx";
         _loc7_["type"] = "text bubble";
         _loc7_["bmpURL"] = "../assets/dummy/testbits0032.png";
         _loc7_["lockedGround"] = false;
         _loc7_["locked"] = false;
         _loc7_["lockedEditing"] = false;
         _loc7_["turn"] = 0;
         _loc7_["dragOffset"] = new Object();
         _loc7_["dragOffset"]["x"] = 0;
         _loc7_["dragOffset"]["y"] = 0;
         _loc7_["position"] = new Object();
         _loc7_["position"]["x"] = 120;
         _loc7_["position"]["y"] = 70;
         _loc7_["position"]["deviation"] = 120;
         _loc7_["position"]["z"] = 0;
         _loc7_["position"]["float"] = 104;
         _loc7_["textData"] = new Object();
         _loc7_["textData"]["style"] = "message";
         _loc7_["textData"]["size"] = 15;
         _loc7_["textData"]["italic"] = null;
         _loc7_["textData"]["bold"] = null;
         _loc7_["textData"]["bkgrColor"] = 16777215;
         _loc7_["textData"]["lightText"] = null;
         _loc7_["textData"]["cornerRound"] = 100;
         _loc7_["textData"]["content"] = "placeholder for eventual replies";
         _loc7_["pointer"] = new Object();
         _loc7_["pointer"]["style"] = "message";
         _loc7_["pointer"]["bkgrColor"] = 16777215;
         _loc7_["pointer"]["centerX"] = 0;
         _loc7_["pointer"]["centerY"] = 0;
         _loc7_["pointer"]["controlY"] = 106;
         _loc7_["pointer"]["controlX"] = 146;
         _loc7_["pointer"]["rotation"] = -54;
         _loc7_["pointer"]["width"] = 20;
         _loc7_["pointer"]["curve"] = -50;
         _loc3_.strips[0].panels[0]["contentList"][3] = _loc7_;
         var _loc8_:Object = new Object();
         _loc8_["name"] = "a_caption";
         _loc8_["id"] = "xx";
         _loc8_["type"] = "text bubble";
         _loc8_["bmpURL"] = "../assets/dummy/testbits0032.png";
         _loc8_["lockedGround"] = false;
         _loc8_["locked"] = true;
         _loc8_["lockedEditing"] = false;
         _loc8_["turn"] = 0;
         _loc8_["dragOffset"] = new Object();
         _loc8_["dragOffset"]["x"] = 0;
         _loc8_["dragOffset"]["y"] = 0;
         _loc8_["position"] = new Object();
         _loc8_["position"]["x"] = 526;
         _loc8_["position"]["y"] = 20;
         _loc8_["position"]["deviation"] = 0;
         _loc8_["position"]["z"] = 0;
         _loc8_["position"]["float"] = 155;
         _loc8_["textData"] = new Object();
         _loc8_["textData"]["style"] = "caption";
         _loc8_["textData"]["size"] = 15;
         _loc8_["textData"]["italic"] = false;
         _loc8_["textData"]["bold"] = true;
         _loc8_["textData"]["bkgrColor"] = 16776960;
         _loc8_["textData"]["lightText"] = false;
         _loc8_["textData"]["cornerRound"] = 100;
         _loc8_["textData"]["content"] = "";
         _loc8_["pointer"] = new Object();
         _loc8_["pointer"]["style"] = "caption";
         _loc8_["pointer"]["bkgrColor"] = 16777215;
         _loc8_["pointer"]["centerX"] = 0;
         _loc8_["pointer"]["centerY"] = 0;
         _loc8_["pointer"]["controlY"] = 40;
         _loc8_["pointer"]["controlX"] = -152;
         _loc8_["pointer"]["rotation"] = 0;
         _loc8_["pointer"]["width"] = 20;
         _loc8_["pointer"]["curve"] = 0;
         _loc3_.strips[0].panels[0]["contentList"][4] = _loc8_;
         var _loc9_:Object = new Object();
         _loc9_["name"] = "b_caption";
         _loc9_["id"] = "xx";
         _loc9_["type"] = "text bubble";
         _loc9_["bmpURL"] = "../assets/dummy/testbits0032.png";
         _loc9_["lockedGround"] = false;
         _loc9_["locked"] = true;
         _loc9_["lockedEditing"] = false;
         _loc9_["turn"] = 0;
         _loc9_["dragOffset"] = new Object();
         _loc9_["dragOffset"]["x"] = 0;
         _loc9_["dragOffset"]["y"] = 0;
         _loc9_["position"] = new Object();
         _loc9_["position"]["x"] = -119;
         _loc9_["position"]["y"] = 20;
         _loc9_["position"]["deviation"] = 250;
         _loc9_["position"]["z"] = 0;
         _loc9_["position"]["float"] = 155;
         _loc9_["textData"] = new Object();
         _loc9_["textData"]["style"] = "caption";
         _loc9_["textData"]["size"] = 15;
         _loc9_["textData"]["italic"] = false;
         _loc9_["textData"]["bold"] = true;
         _loc9_["textData"]["bkgrColor"] = 16776960;
         _loc9_["textData"]["lightText"] = false;
         _loc9_["textData"]["cornerRound"] = 100;
         _loc9_["textData"]["content"] = "";
         _loc9_["pointer"] = new Object();
         _loc9_["pointer"]["style"] = "caption";
         _loc9_["pointer"]["bkgrColor"] = 16777215;
         _loc9_["pointer"]["centerX"] = 0;
         _loc9_["pointer"]["centerY"] = 0;
         _loc9_["pointer"]["controlY"] = 40;
         _loc9_["pointer"]["controlX"] = -152;
         _loc9_["pointer"]["rotation"] = 0;
         _loc9_["pointer"]["width"] = 20;
         _loc9_["pointer"]["curve"] = 0;
         _loc3_.strips[0].panels[0]["contentList"][5] = _loc9_;
         return _loc3_;
      }
      
      public static function panelAbsorbScene(param1:Object, param2:Object, param3:Boolean = true) : Object
      {
         var _loc5_:String = null;
         trace("--DataDump.panelAbsorbScene()--");
         var _loc4_:Object = new Object();
         for each(_loc5_ in ["width","content_x","content_y","content_scale","content_rotation"])
         {
            _loc4_[_loc5_] = param1[_loc5_];
         }
         _loc4_.editable = param1.editable;
         if(param2.hasOwnProperty("version") == false)
         {
            param2 = panel_data_update(param2);
         }
         _loc4_["contents"] = {};
         _loc4_["contents"]["backdrop"] = param2["contents"]["backdrop"];
         _loc4_["contents"]["backdrop_color"] = param2["contents"]["backdrop_color"];
         _loc4_["contents"]["floor"] = param2["contents"]["floor"];
         _loc4_["contents"]["floor_color"] = param2["contents"]["floor_color"];
         _loc4_["text_contents"] = {};
         var _loc6_:uint = 0;
         while(_loc6_ < param1["contents"].contentList.length)
         {
            if(param1["contents"].contentList[_loc6_]["sceneBit"])
            {
               trace("yanking scene bit " + param1["contents"].contentList[_loc6_]["sceneBit"]);
               param1["contents"].contentList.splice(_loc6_,1);
               _loc6_--;
            }
            _loc6_++;
         }
         var _loc7_:int = param2["contents"].contentList.length;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            param2["contents"].contentList[_loc8_]["sceneBit"] = true;
            if(param3)
            {
               param2["contents"].contentList[_loc8_]["locked"] = true;
            }
            _loc8_++;
         }
         if(param2.hasOwnProperty("text_contents"))
         {
            _loc7_ = param2["text_contents"].contentList.length;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               param2["text_contents"].contentList[_loc8_]["sceneBit"] = true;
               if(param3)
               {
                  param2["text_contents"].contentList[_loc8_]["locked"] = true;
               }
               _loc8_++;
            }
            _loc4_["text_contents"].contentList = param2["text_contents"].contentList.concat(param1["text_contents"].contentList);
         }
         else
         {
            _loc4_["text_contents"].contentList = param1["text_contents"].contentList;
         }
         _loc4_["contents"].contentList = param2["contents"].contentList.concat(param1["contents"].contentList);
         return _loc4_;
      }
      
      public static function getMessageBubble_a() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["name"] = "a_bubble";
         _loc1_["id"] = "xx";
         _loc1_["type"] = "text bubble";
         _loc1_["bmpURL"] = "../assets/dummy/testbits0032.png";
         _loc1_["lockedGround"] = false;
         _loc1_["locked"] = false;
         _loc1_["lockedEditing"] = false;
         _loc1_["turn"] = 0;
         _loc1_["dragOffset"] = new Object();
         _loc1_["dragOffset"]["x"] = 0;
         _loc1_["dragOffset"]["y"] = 0;
         _loc1_["position"] = new Object();
         _loc1_["position"]["x"] = -120;
         _loc1_["position"]["y"] = 70;
         _loc1_["position"]["deviation"] = -120;
         _loc1_["position"]["z"] = 0;
         _loc1_["position"]["float"] = 104;
         _loc1_["textData"] = new Object();
         _loc1_["textData"]["style"] = "message";
         _loc1_["textData"]["size"] = 15;
         _loc1_["textData"]["italic"] = null;
         _loc1_["textData"]["bold"] = null;
         _loc1_["textData"]["bkgrColor"] = 16777215;
         _loc1_["textData"]["lightText"] = null;
         _loc1_["textData"]["cornerRound"] = 100;
         _loc1_["textData"]["content"] = "";
         _loc1_["pointer"] = new Object();
         _loc1_["pointer"]["style"] = "message";
         _loc1_["pointer"]["bkgrColor"] = 16777215;
         _loc1_["pointer"]["centerX"] = 0;
         _loc1_["pointer"]["centerY"] = 0;
         _loc1_["pointer"]["controlY"] = 100;
         _loc1_["pointer"]["controlX"] = -125;
         _loc1_["pointer"]["rotation"] = 55;
         _loc1_["pointer"]["width"] = 64.25;
         _loc1_["pointer"]["curve"] = 50;
         return _loc1_;
      }
   }
}
