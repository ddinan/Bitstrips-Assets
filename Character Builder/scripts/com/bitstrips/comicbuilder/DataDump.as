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
         return {
            "locked":false,
            "version":2,
            "turn":0,
            "lockedGround":false,
            "textData":{
               "bold":false,
               "italic":false,
               "textColor":0,
               "cornerRound":100,
               "style":"normal",
               "size":13,
               "htmlContent":"<P ALIGN=\"CENTER\"><FONT FACE=\"_CreativeBlock BB\" SIZE=\"13\" COLOR=\"#000000\">Type Your Message Here</FONT></P>",
               "bkgrColor":16777215,
               "content":"Regular\rSpeech",
               "lines":2,
               "maxWidth":703,
               "lightText":false
            },
            "pointer":{
               "centerY":0,
               "rotation":-31.0973128858,
               "controlX":38,
               "style":"normal",
               "curve":-31.0973128858,
               "controlY":63,
               "bkgrColor":16777215,
               "centerX":0
            },
            "scale":1,
            "stage_x":467,
            "dragOffset":{
               "y":30,
               "x":-105
            },
            "pointers":[],
            "id":"xx",
            "y":-139,
            "position":{
               "x":82,
               "y":-139
            },
            "type":"promoted text",
            "sceneBit":false,
            "bmpURL":"givemetextbubble",
            "name":"b_bubble",
            "stage_y":197,
            "lockedEditing":false
         };
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
         var _loc3_:Object = {
            "comicAuthorName":"",
            "version":3,
            "comicID":"0",
            "rescale":0.45,
            "episode":0,
            "bkgrColor":16777215,
            "comicTitle":"New Message",
            "editable":true,
            "series":0,
            "strips":[{
               "panels":[{
                  "editable":false,
                  "height":360,
                  "content_rotation":0,
                  "content_y":271.5,
                  "content_scale":1.99,
                  "children_filter":true,
                  "text_contents":{
                     "contentList":[],
                     "children_filter":true
                  },
                  "contents":{
                     "floor":"floor1",
                     "floor_color":16777215,
                     "contentList":[{
                        "asset_type":"characters",
                        "turn":0,
                        "lockedGround":true,
                        "type":"characters",
                        "position":{
                           "x":-78.65,
                           "y":31.3
                        },
                        "body":{
                           "mode":0,
                           "master_rotation":1,
                           "action":0,
                           "gesture":1,
                           "head":{
                              "h_rot":1,
                              "mouth_expression":2,
                              "expression":3,
                              "lipsync":2,
                              "lids":[1,1],
                              "pupils":[{
                                 "x":0.325,
                                 "width":0.18125,
                                 "y":0
                              },{
                                 "x":0.325,
                                 "width":0.18125,
                                 "y":0
                              }]
                           },
                           "head_angle":0,
                           "hand_info":[{
                              "frame":5,
                              "rot":0
                           },{
                              "frame":5,
                              "rot":2
                           }],
                           "stance":1
                        },
                        "name":"a_avatar",
                        "bmpURL":"",
                        "thumb":"",
                        "dragOffset":{
                           "y":-145.65,
                           "x":70.1
                        },
                        "id":param1,
                        "guid":"char" + param1,
                        "char_id":param1,
                        "order":1000,
                        "tags":["MyFriends01"],
                        "sceneBit":false,
                        "version":0,
                        "scale":1,
                        "locked":false,
                        "stage_y":478.75,
                        "lockedEditing":false,
                        "stage_x":113.65
                     },{
                        "asset_type":"characters",
                        "id":param2,
                        "stage_y":478.75,
                        "scale":1,
                        "type":"characters",
                        "order":1000,
                        "body":{
                           "mode":0,
                           "master_rotation":7,
                           "action":0,
                           "gesture":1,
                           "head":{
                              "h_rot":7,
                              "mouth_expression":2,
                              "expression":3,
                              "lipsync":2,
                              "lids":[1,1],
                              "pupils":[{
                                 "x":-0.3,
                                 "width":0.18125,
                                 "y":0
                              },{
                                 "x":-0.3,
                                 "width":0.18125,
                                 "y":0
                              }]
                           },
                           "head_angle":0,
                           "hand_info":[{
                              "frame":5,
                              "rot":0
                           },{
                              "frame":5,
                              "rot":2
                           }],
                           "stance":1
                        },
                        "char_id":param2,
                        "version":0,
                        "thumb":"",
                        "turn":0,
                        "lockedGround":true,
                        "guid":"char" + param2,
                        "position":{
                           "x":181.75,
                           "y":31.3
                        },
                        "tags":["MyFriends01"],
                        "sceneBit":false,
                        "bmpURL":"",
                        "name":"b_avatar",
                        "locked":false,
                        "dragOffset":{
                           "y":-74.3,
                           "x":-278.25
                        },
                        "lockedEditing":false,
                        "stage_x":113.65
                     }],
                     "children_filter":true,
                     "backdrop":"backdrop1",
                     "backdrop_color":16777215
                  },
                  "width":708,
                  "content_x":254
               }],
               "height":360
            }]
         };
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
         return {
            "locked":false,
            "version":2,
            "turn":0,
            "lockedGround":false,
            "textData":{
               "bold":false,
               "italic":false,
               "textColor":0,
               "cornerRound":100,
               "style":"normal",
               "size":13,
               "htmlContent":"<P ALIGN=\"CENTER\"><FONT FACE=\"_CreativeBlock BB\" SIZE=\"13\" COLOR=\"#000000\">Type Your Message Here</FONT></P>",
               "bkgrColor":16777215,
               "content":"Regular\rSpeech",
               "lines":2,
               "maxWidth":703,
               "lightText":false
            },
            "pointer":{
               "centerY":0,
               "rotation":30.8276622999,
               "controlX":-37,
               "style":"normal",
               "curve":30.8276622999,
               "controlY":62,
               "bkgrColor":16777215,
               "centerX":0
            },
            "scale":1,
            "stage_x":258,
            "dragOffset":{
               "y":-3,
               "x":209
            },
            "pointers":[],
            "id":"xx",
            "y":-136,
            "position":{
               "x":-57,
               "y":-136
            },
            "type":"promoted text",
            "sceneBit":false,
            "bmpURL":"givemetextbubble",
            "name":"a_bubble",
            "stage_y":200,
            "lockedEditing":false
         };
      }
   }
}
