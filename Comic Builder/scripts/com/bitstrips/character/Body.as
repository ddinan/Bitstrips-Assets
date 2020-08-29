package com.bitstrips.character
{
   import com.bitstrips.BSConstants;
   import com.bitstrips.core.ArtLoader;
   import com.bitstrips.core.ColourData;
   import com.bitstrips.core.Remote;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Body extends Sprite
   {
      
      private static const arm_pieces:Array = ["OV_fore_L","cuff_L","fore_L","OV_fore_R","shoulder_L","shoulder_R","cuff_R","fore_R","OV_arm_L","arm_L","OV_arm_R","arm_R","hand_L","hand_R"];
      
      private static const body_pieces:Array = ["OV_L","OV_R","OV_B","shirtfront","neck","breasts","foot_L","foot_R","leg_R","leg_L","torso","skirt","shirtskirt","necklace"];
      
      private static const gesture_count:uint = 10;
      
      private static const stance_count:uint = 10;
      
      private static const rotation_count:uint = 5;
      
      private static const h_count:uint = 5;
      
      private static const acg_levels:Object = {
         0:{
            0:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            1:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            2:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            3:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            4:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            5:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            6:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            7:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            8:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            9:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"]
         },
         1:{
            0:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            1:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            2:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            3:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            4:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            5:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            6:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L"],
            7:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            8:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            9:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"]
         },
         2:{
            0:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            1:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            2:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            3:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            4:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            5:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            6:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L"],
            7:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            8:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            9:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"]
         },
         3:{
            0:["arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            1:["arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            2:["arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            3:["arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            4:["arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            5:["arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            6:["arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            7:["arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            8:["arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            9:["arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"]
         },
         4:{
            0:["head","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            1:["head","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            2:["arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","head","BODY","hback"],
            3:["head","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            4:["head","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            5:["head","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            6:["head","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            7:["arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            8:["arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            9:["arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"]
         }
      };
      
      private static const g1_levels:Object = {
         0:{
            0:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            1:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            2:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            3:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            4:["hback","arm_R","shoulder_R","OV_arm_R","arm_L","shoulder_L","OV_arm_L","BODY","head","fore_R","hand_R","cuff_R","OV_fore_R","fore_L","hand_L","cuff_L","OV_fore_L"],
            5:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            6:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            7:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            8:["hback","arm_R","shoulder_R","OV_arm_R","arm_L","shoulder_L","OV_arm_L","BODY","head","hand_R","cuff_R","OV_fore_R","hand_L","cuff_L","OV_fore_L"],
            9:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"]
         },
         1:{
            0:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            1:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            2:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            3:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","OV_arm_L","head","fore_L","hand_L","cuff_L","OV_fore_L"],
            4:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","OV_arm_L","head","fore_L","hand_L","cuff_L","OV_fore_L"],
            5:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            6:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            7:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            8:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L"],
            9:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L"]
         },
         2:{
            0:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            1:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            2:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            3:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","OV_arm_L","head","fore_L","hand_L","cuff_L","OV_fore_L"],
            4:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","OV_arm_L","head","fore_L","hand_L","cuff_L","OV_fore_L"],
            5:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            6:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","OV_arm_L","head","fore_L","hand_L","cuff_L","OV_fore_L"],
            7:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L"],
            8:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L"],
            9:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L"]
         },
         3:{
            0:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            1:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            2:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            3:["head","arm_L","shoulder_L","OV_arm_L","fore_L","hand_L","cuff_L","OV_fore_L","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            4:["head","arm_L","OV_arm_L","fore_L","shoulder_L","hand_L","cuff_L","OV_fore_L","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            5:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            6:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            7:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R"],
            8:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            9:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"]
         },
         4:{
            0:["head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","hback"],
            1:["head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","hback"],
            2:["head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","hback"],
            3:["head","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","hback"],
            4:["shoulder_R","OV_arm_R","arm_L","shoulder_L","OV_arm_L","fore_R","hand_R","cuff_R","OV_fore_R","fore_L","hand_L","cuff_L","OV_fore_L","head","BODY","hback"],
            5:["head","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","hback"],
            6:["head","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","hback"],
            7:["head","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","hback"],
            8:["head","arm_R","shoulder_R","OV_arm_R","arm_L","shoulder_L","OV_arm_L","hand_R","cuff_R","OV_fore_R","hand_L","cuff_L","OV_fore_L","BODY","hback"],
            9:["head","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","hback"]
         }
      };
      
      private static const g2_levels:Object = {
         0:{
            0:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            1:["hback","arm_R","shoulder_R","OV_arm_R","arm_L","shoulder_L","OV_arm_L","BODY","fore_R","hand_R","cuff_R","OV_fore_R","fore_L","hand_L","cuff_L","OV_fore_L","head"],
            2:["hback","BODY","arm_R","shoulder_R","OV_arm_R","arm_L","shoulder_L","OV_arm_L","fore_L","hand_L","cuff_L","OV_fore_L","fore_R","hand_R","cuff_R","OV_fore_R","head"],
            3:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            4:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            5:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            6:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            7:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            8:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head"],
            9:["hback","arm_R","shoulder_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","head","fore_R","hand_R","cuff_R","OV_fore_R"]
         },
         1:{
            0:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            1:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            2:["hback","arm_R","shoulder_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","fore_R","hand_R","cuff_R","OV_fore_R","head"],
            3:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            4:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            5:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            6:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            7:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            8:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            9:["hback","arm_R","shoulder_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head","fore_R","hand_R","cuff_R","OV_fore_R"]
         },
         2:{
            0:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            1:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            2:["hback","arm_R","shoulder_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","fore_R","hand_R","cuff_R","OV_fore_R","head"],
            3:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            4:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            5:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            6:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            7:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            8:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"],
            9:["hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","BODY","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","head"]
         },
         3:{
            0:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            1:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            2:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","arm_R","shoulder_R","OV_arm_R","fore_R","hand_R","cuff_R","OV_fore_R","BODY","hback"],
            3:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            4:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            5:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            6:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            7:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","hback","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R"],
            8:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","hback"],
            9:["head","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","arm_R","shoulder_R","OV_arm_R","hback","fore_R","hand_R","cuff_R","OV_fore_R"]
         },
         4:{
            0:["head","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","hback"],
            1:["arm_R","shoulder_R","OV_arm_R","arm_L","shoulder_L","OV_arm_L","fore_R","hand_R","cuff_R","OV_fore_R","fore_L","hand_L","cuff_L","OV_fore_L","BODY","hback"],
            2:["arm_R","shoulder_R","OV_arm_R","arm_L","shoulder_L","OV_arm_L","fore_L","hand_L","cuff_L","OV_fore_L","fore_R","hand_R","cuff_R","OV_fore_R","BODY","hback"],
            3:["head","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","hback"],
            4:["head","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","hback"],
            5:["head","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","hback"],
            6:["head","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","hback"],
            7:["head","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","hback"],
            8:["head","arm_R","shoulder_R","hand_R","cuff_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","BODY","hback"],
            9:["arm_R","shoulder_R","OV_arm_R","arm_L","shoulder_L","hand_L","cuff_L","OV_arm_L","fore_R","hand_R","cuff_R","OV_fore_R","head","BODY","hback"]
         }
      };
      
      private static const standing_levels:Object = {
         0:["torso","leg_L","foot_L","leg_R","foot_R","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
         1:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
         2:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_L"],
         3:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
         4:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"]
      };
      
      private static const sitting_levels:Object = {
         0:["torso","leg_L","foot_L","leg_R","foot_R","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
         1:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
         2:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_L"],
         3:["breasts","leg_L","foot_L","torso","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
         4:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"]
      };
      
      private static const action_levels:Object = {
         0:{
            0:["torso","leg_L","foot_L","leg_R","foot_R","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            1:["torso","leg_L","foot_L","leg_R","foot_R","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            2:["torso","leg_L","foot_L","leg_R","foot_R","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            3:["torso","leg_L","foot_L","leg_R","foot_R","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            4:["torso","leg_L","foot_L","leg_R","foot_R","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            5:["torso","leg_L","foot_L","leg_R","foot_R","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            6:["torso","leg_L","foot_L","leg_R","foot_R","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            7:["torso","leg_L","foot_L","leg_R","foot_R","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            8:["torso","leg_L","foot_L","leg_R","foot_R","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            9:["torso","leg_L","foot_L","leg_R","foot_R","skirt","breasts","neck","shirtfront","OV_R","OV_L"]
         },
         1:{
            0:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            1:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            2:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            3:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            4:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            5:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            6:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            7:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            8:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            9:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"]
         },
         2:{
            0:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            1:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            2:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            3:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            4:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            5:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            6:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            7:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            8:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
            9:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"]
         },
         3:{
            0:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            1:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            2:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            3:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            4:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            5:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            6:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            7:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            8:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            9:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"]
         },
         4:{
            0:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            1:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            2:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            3:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            4:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            5:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            6:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            7:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            8:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
            9:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"]
         }
      };
      
      private static const body_levels:Object = {
         0:["torso","leg_L","leg_R","foot_R","foot_L","breasts","neck","shirtfront","OV_R","OV_L"],
         1:["torso","leg_R","foot_R","leg_L","foot_L","breasts","neck","shirtfront","OV_R","OV_L"],
         2:["torso","leg_R","foot_R","leg_L","foot_L","breasts","neck","shirtfront","OV_R","OV_L"],
         3:["breasts","torso","leg_L","foot_L","leg_R","foot_R","neck","shirtfront","OV_B"],
         4:["breasts","torso","leg_L","foot_L","leg_R","foot_R","neck","shirtfront","OV_B"]
      };
      
      private static const hand_frames:Object = {
         0:[["15","15","36","27","2","34","30","22","23","21","2","13","15","15","14","15","16","15","17","20","1"],["15","15","36","27","2","34","30","22","23","21","2","13","15","34","33","36","33","22","28","1","20"]],
         1:[["5","5","6","7","2","34","30","22","3","31","2","3","15","5","4","5","6","5","7","10","1"],["25","25","26","27","22","34","30","22","23","31","2","23","15","24","23","26","23","22","28","21","30"]],
         2:[["5","5","6","7","2","34","30","22","3","31","2","3","15","5","4","5","6","5","7","10","1"],["25","25","26","27","22","34","30","22","23","31","2","23","15","24","23","26","23","22","28","21","30"]]
      };
       
      
      public var remote:Remote;
      
      public var _body_type:Number = 0;
      
      public var _body_height:Number = 0;
      
      public var _breast_type:Number = 0;
      
      public var _sex:uint = 1;
      
      public var _gesture:Number = 0;
      
      public var _stance:Number = 1;
      
      public var _pose:Number = 0;
      
      public var body_rotation:Number = 0;
      
      public var head_angle:Number = 0;
      
      private var _hands:Array;
      
      private var brot:uint = 0;
      
      private var brot2:uint = 0;
      
      private var jacket:Boolean = false;
      
      private var pants:Boolean = false;
      
      public var _simple:Boolean = true;
      
      public var _cld:ColourData;
      
      public var art_loader:ArtLoader;
      
      public var flipped:Boolean = false;
      
      public var edit_mode:Boolean = false;
      
      public var _head:Head;
      
      public var head_clip:Sprite;
      
      private var arms:Object;
      
      private var body:Object;
      
      public var clothes:Array;
      
      private var pieces:Array;
      
      private var body_clip:Sprite;
      
      public var standing:Boolean = true;
      
      public var action:Boolean = false;
      
      public var sitting:Boolean = false;
      
      public var colour_click_call:Function;
      
      public var just_head_visible:Boolean = false;
      
      private var debug:Boolean = false;
      
      public var points:Object;
      
      private var clothing_debug:Boolean = false;
      
      public var clothing_selected:String;
      
      public var clothing_out:String;
      
      public var clothing_over:String;
      
      public function Body(param1:Head, param2:Object = undefined, param3:Boolean = true)
      {
         var i:String = null;
         var ht:Object = null;
         var part:String = null;
         var item:String = null;
         var the_head:Head = param1;
         var settings:Object = param2;
         var em:Boolean = param3;
         this._hands = [0,0];
         this.head_clip = new Sprite();
         this.arms = new Object();
         this.body = new Object();
         this.clothes = new Array();
         this.pieces = new Array();
         this.body_clip = new Sprite();
         super();
         if(this.debug)
         {
            trace("Initing body" + " EditMode: " + em);
         }
         if(BSConstants.EDU)
         {
            this._breast_type = 3;
         }
         this._head = the_head;
         this.art_loader = ArtLoader.getInstance();
         if(this._head)
         {
            this._cld = this._head.cld;
         }
         if(this._cld)
         {
            this._cld.addEventListener("NEW_COLOUR",function(param1:Event):void
            {
               update_colours();
            });
         }
         this.points = this.art_loader.points;
         this.edit_mode = em;
         var bitmap_head:Boolean = !this.edit_mode;
         if(BSConstants.NO_BM_HEAD)
         {
            bitmap_head = false;
         }
         for(i in body_pieces)
         {
            part = body_pieces[i];
            this.body[part] = new Sprite();
            this.body_clip.addChild(this.body[part]);
         }
         for(i in arm_pieces)
         {
            part = arm_pieces[i];
            this.arms[part] = new Sprite();
            addChild(this.arms[part]);
         }
         ht = this.art_loader.get_art("hand","hand_art1");
         this.arms["hand_L"].addChild(ht);
         ht.go_to_frame(2);
         this.pieces.push(ht);
         ht = this.art_loader.get_art("hand","hand_art1");
         this.arms["hand_R"].addChild(ht);
         ht.go_to_frame(2);
         ht.scaleX = -1;
         this.pieces.push(ht);
         if(this._head)
         {
            if(bitmap_head)
            {
               this._head.enable_bdats();
               this.head_clip.addChild(this._head.fg_head);
            }
            else
            {
               this.head_clip.addChild(this._head);
            }
         }
         this.arms["head"] = this.head_clip;
         this.arms["hback"] = new Sprite();
         if(this._head)
         {
            if(bitmap_head == false)
            {
               this.arms["hback"].addChild(this._head.head_back);
            }
            else
            {
               this.arms["hback"].addChild(this._head.bg_head);
            }
            this._head.used_back = true;
            this._head.set_backstyle(this._head.backstyle);
            this._head.get_piece("hair_back").visible = false;
         }
         this.arms["BODY"] = this.body_clip;
         addChild(this.head_clip);
         addChild(this.arms["hback"]);
         addChild(this.body_clip);
         if(this.edit_mode)
         {
            this._simple = true;
            this._gesture = 1;
            for(i in this.pieces)
            {
               this.setup_edit(this.pieces[i]);
            }
         }
         else
         {
            this._simple = false;
         }
         if(this._head)
         {
            this._head.addEventListener("HAIR_UPDATE",function(param1:Event):void
            {
               position_head();
            });
            this._head.addEventListener("ROTATION",function(param1:Event):void
            {
               update_levels();
            });
         }
         if(settings != null)
         {
            if(settings["body_type"])
            {
               this.body_type = settings["body_type"];
            }
            this.body_height = settings["body_height"];
            if(settings["breast_type"])
            {
               this.breast_type = settings["breast_type"];
            }
            if(settings["sex"])
            {
               this.sex = settings["sex"];
            }
            else if(this._body_type == 7 || this._body_type == 8 || this._body_type == 9 || this._body_type == 10)
            {
               this.sex = 2;
            }
            if(em == false)
            {
            }
         }
         this.add_clothing("bare",true);
         if(settings != null && settings["clothes"])
         {
            for each(item in settings["clothes"])
            {
               this.add_clothing(item,true);
            }
         }
         this.redo();
         this.update_colours();
      }
      
      public static function rotateAroundInternalPoint(param1:Matrix, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:Point = param1.transformPoint(new Point(param2,param3));
         rotateAroundExternalPoint(param1,_loc5_.x,_loc5_.y,param4);
      }
      
      public static function rotateAroundExternalPoint(param1:Matrix, param2:Number, param3:Number, param4:Number) : void
      {
         param1.translate(-param2,-param3);
         param1.rotate(param4 * (Math.PI / 180));
         param1.translate(param2,param3);
      }
      
      public function get cld() : ColourData
      {
         return this._cld;
      }
      
      public function set just_head(param1:Boolean) : void
      {
         var _loc2_:* = null;
         this.just_head_visible = param1;
         if(this.just_head_visible == false)
         {
            for(_loc2_ in this.arms)
            {
               this.arms[_loc2_].visible = true;
            }
            for(_loc2_ in this.body)
            {
               this.body[_loc2_].visible = true;
            }
         }
         this.update_levels();
      }
      
      public function load_all() : void
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         if(this.debug)
         {
            trace("LOAD ALL....");
         }
         var _loc1_:* = this._body_type + "_" + this._body_height + ".swf";
         var _loc2_:Array = [this.remote.assurl("body_art/split/base/base_" + _loc1_)];
         for(_loc3_ in this.clothes)
         {
            if(this.clothes[_loc3_] != "pearls" && this.clothes[_loc3_] != "naked" && this.clothes[_loc3_])
            {
               _loc2_.push(this.remote.assurl("body_art/split/" + this.clothes[_loc3_] + "/" + this.clothes[_loc3_] + "_" + _loc1_));
            }
         }
         _loc4_ = this.art_loader.load_swfs(_loc2_,this.art_loaded);
         if(this.debug)
         {
            trace("Load ID: " + _loc4_);
         }
      }
      
      private function art_loaded(param1:String) : void
      {
         var _loc2_:* = null;
         if(this.debug)
         {
            trace("ART LOADED: " + param1);
         }
         this._simple = false;
         this.remove_clothing("bare");
         this.remove_clothing("bare");
         this.remove_clothing("bare");
         this.add_clothing("bare");
         for(_loc2_ in this.clothes)
         {
            this.add_clothing(this.clothes[_loc2_]);
         }
         dispatchEvent(new Event("updated"));
      }
      
      public function bt_change() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in this.clothes)
         {
            this.remove_clothing(this.clothes[_loc1_]);
            this.add_clothing(this.clothes[_loc1_]);
         }
         this.load_all();
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["body_type"] = this._body_type;
         _loc1_["body_height"] = this._body_height;
         _loc1_["breast_type"] = this._breast_type;
         _loc1_["sex"] = this.sex;
         _loc1_["clothes"] = this.clothes;
         return _loc1_;
      }
      
      private function art_part(param1:String) : String
      {
         return param1.substr(param1.lastIndexOf("_") + 1);
      }
      
      public function remove_clothing(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc6_:* = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc5_:int = this.clothes.indexOf(param1);
         if(_loc5_ == -1)
         {
            trace("They\'re not wearing that! " + param1);
            this.clothes.splice(_loc5_,1);
         }
         for(_loc6_ in this.body)
         {
            _loc2_ = new Array();
            _loc3_ = 0;
            while(_loc3_ < this.body[_loc6_].numChildren)
            {
               _loc2_.push(this.body[_loc6_].getChildAt(_loc3_));
               _loc3_ = _loc3_ + 1;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = this.art_split(_loc2_[_loc3_].name)["type"];
               if(param1 == _loc4_)
               {
                  this.body[_loc6_].removeChild(_loc2_[_loc3_]);
               }
               _loc3_ = _loc3_ + 1;
            }
         }
         for(_loc6_ in this.arms)
         {
            if(!(_loc6_ == "hand_L" || _loc6_ == "hand_R"))
            {
               _loc2_ = new Array();
               _loc3_ = 0;
               while(_loc3_ < this.arms[_loc6_].numChildren)
               {
                  _loc2_.push(this.arms[_loc6_].getChildAt(_loc3_));
                  _loc3_ = _loc3_ + 1;
               }
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = this.art_split(_loc2_[_loc3_].name)["type"];
                  if(param1 == _loc4_)
                  {
                     this.arms[_loc6_].removeChild(_loc2_[_loc3_]);
                  }
                  _loc3_ = _loc3_ + 1;
               }
            }
         }
         if(param1 == "glove1")
         {
            _loc7_ = this.arms["hand_L"].getChildAt(0);
            _loc8_ = this.arms["hand_R"].getChildAt(0);
            _loc7_.base_colour = "ffcc99";
            _loc8_.base_colour = "ffcc99";
            if(this.cld.get_colour("ffcc99") == -1)
            {
               this.cld.set_colour("ffcc99",16764057);
            }
            this.cld.colour_clip(MovieClip(_loc7_));
            this.cld.colour_clip(MovieClip(_loc8_));
         }
         this.update_shoulder_state();
         this.update_pants_state();
      }
      
      public function set_action() : void
      {
         this.action = this.sitting = this.standing = false;
         this.action = true;
         this.update_body_visibility();
         this.redo();
      }
      
      public function set_standing() : void
      {
         this.action = false;
         this.sitting = false;
         this.standing = true;
         this.update_body_visibility();
         this.redo();
      }
      
      public function set_sitting() : void
      {
         this.action = this.sitting = this.standing = false;
         this.sitting = true;
         this.update_body_visibility();
         this.redo();
      }
      
      public function simple_add(param1:Object, param2:String, param3:Array) : void
      {
         var _loc5_:* = null;
         var _loc6_:Object = null;
         if(this.clothing_debug)
         {
            trace("Adding clothing: " + param2 + " - " + param3);
         }
         var _loc4_:Array = this.art_loader.sorted_index2(param2,param3);
         if(this.clothing_debug)
         {
            trace("\tArt list: " + _loc4_);
         }
         for(_loc5_ in _loc4_)
         {
            _loc6_ = this.art_loader.get_art(param2,_loc4_[_loc5_]);
            if(_loc6_.type == "")
            {
               _loc6_.type = param2;
            }
            if(!_loc6_.base_colour)
            {
               _loc6_.set_new_frame_func(this.cld.colour_clip);
            }
            if(param2 == "breasts")
            {
               _loc6_.type = "breasts";
            }
            else if(param2 == "necklace")
            {
               _loc6_.type = "necklace";
            }
            else
            {
               _loc6_.type = "simple";
            }
            if(this.clothing_debug)
            {
               trace("\t" + _loc4_[_loc5_] + " - " + _loc6_.body_part);
            }
            param1[_loc6_.body_part].addChild(_loc6_);
            this.adjust_part_order(param1[_loc6_.body_part]);
            if(this.edit_mode)
            {
               this.setup_edit(_loc6_);
            }
            this.pieces.push(_loc6_);
         }
      }
      
      private function setup_edit(param1:Object) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.piece_click);
         param1.addEventListener(MouseEvent.ROLL_OVER,this.cloth_over);
         param1.addEventListener(MouseEvent.ROLL_OUT,this.cloth_out);
         param1.buttonMode = true;
      }
      
      private function type_add(param1:Object, param2:String, param3:Array) : void
      {
         var _loc5_:* = null;
         var _loc6_:Object = null;
         if(this.clothing_debug)
         {
            trace("Adding clothing: " + param2 + " - " + param3);
         }
         var _loc4_:Array = this.art_loader.sorted_index2(param2,param3,this.body_type,this.body_height);
         if(this.clothing_debug)
         {
            trace("\tArt list: " + _loc4_);
         }
         for(_loc5_ in _loc4_)
         {
            _loc6_ = this.art_loader.get_art(param2,_loc4_[_loc5_],this.body_type,this.body_height);
            if(_loc4_[_loc5_].indexOf("skirt_shirt") <= 1)
            {
               if(_loc6_.type == "")
               {
                  _loc6_.type = param2;
               }
               if(!_loc6_.base_colour)
               {
                  _loc6_.set_new_frame_func(this.cld.colour_clip);
               }
               param1[_loc6_.body_part].addChild(_loc6_);
               if(this.edit_mode)
               {
                  this.setup_edit(_loc6_);
               }
               this.adjust_part_order(param1[_loc6_.body_part]);
               this.pieces.push(_loc6_);
            }
         }
      }
      
      private function adjust_part_order(param1:Sprite) : void
      {
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc2_.push(param1.getChildAt(_loc3_));
            _loc3_ = _loc3_ + 1;
         }
         _loc2_.sortOn("depth",Array.NUMERIC);
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            param1.setChildIndex(_loc2_[_loc3_],_loc3_);
            _loc3_ = _loc3_ + 1;
         }
      }
      
      private function art_split(param1:String) : Object
      {
         var _loc2_:int = param1.lastIndexOf("_");
         return {
            "part":param1.substr(0,_loc2_),
            "type":param1.substr(_loc2_ + 1)
         };
      }
      
      private function update_shoulder_state() : void
      {
         var _loc2_:* = null;
         var _loc1_:Array = ["suit1"];
         for(_loc2_ in this.clothes)
         {
            if(_loc1_.indexOf(this.clothes[_loc2_]) != -1)
            {
               this.jacket = true;
               this.arms["shoulder_L"].visible = false;
               this.arms["shoulder_R"].visible = false;
               return;
            }
         }
         this.jacket = false;
         this.arms["shoulder_R"].visible = this.arms["shoulder_L"].visible = true;
      }
      
      private function update_pants_state() : void
      {
         var _loc2_:* = null;
         var _loc1_:Array = ["shorts1","shorts2","pants1","pants2"];
         for(_loc2_ in this.clothes)
         {
            if(_loc1_.indexOf(this.clothes[_loc2_]) != -1)
            {
               this.pants = true;
               this.body["shirtskirt"].visible = false;
               return;
            }
         }
         this.pants = false;
         this.body["shirtskirt"].visible = true;
      }
      
      public function add_clothing(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         if(param1 != "bare")
         {
            if(this.clothes.indexOf(param1) != -1)
            {
               return;
            }
            this.clothes.push(param1);
         }
         if(this._simple)
         {
            this.simple_add(this.body,"simple_body",[param1]);
            this.simple_add(this.arms,"simple_arms",[param1]);
         }
         else
         {
            this.type_add(this.body,"body",[param1]);
            this.type_add(this.arms,"arms",[param1]);
         }
         this.simple_add(this.body,"breasts",[param1]);
         this.simple_add(this.body,"necklace",[param1]);
         if(param1 == "glove1")
         {
            _loc7_ = this.arms["hand_L"].getChildAt(0);
            _loc8_ = this.arms["hand_R"].getChildAt(0);
            _loc7_.base_colour = "494545";
            _loc8_.base_colour = "494545";
            if(this.cld.get_colour("494545") == -1)
            {
               this.cld.set_colour("494545",4801861);
            }
            this.cld.colour_clip(MovieClip(_loc7_));
            this.cld.colour_clip(MovieClip(_loc8_));
         }
         this.update_pants_state();
         this.update_shoulder_state();
         if(param2 == false)
         {
            this.set_rotation(this.body_rotation);
            this.update_colours();
            this.redo();
         }
      }
      
      public function update_colours() : void
      {
         var _loc1_:* = null;
         if(this.debug)
         {
            trace("UPDATE COLOURS ---------------------------------------------------- " + this.name + " " + this);
         }
         for(_loc1_ in this.pieces)
         {
            this.cld.colour_clip(this.pieces[_loc1_]);
         }
      }
      
      private function piece_click(param1:MouseEvent) : void
      {
         var _loc2_:Object = param1.currentTarget;
         var _loc3_:String = this.art_split(_loc2_.name)["type"];
         if(_loc2_.base_colour)
         {
            if(this.colour_click_call != null)
            {
               this.colour_click_call([_loc2_.base_colour]);
            }
         }
         else if(this.colour_click_call != null)
         {
            this.colour_click_call(ColourData.get_colours(MovieClip(_loc2_)));
         }
         this.clothing_out = this.clothing_over = "";
         if(this.clothing_selected == _loc3_)
         {
            return;
         }
         this.clothing_selected = _loc3_;
         if(_loc2_.name == "hand_art1")
         {
            this.clothing_selected = "glove1";
         }
         this.dispatchEvent(new Event("clothing_click"));
      }
      
      private function cloth_over(param1:MouseEvent) : void
      {
         var _loc2_:Object = param1.currentTarget;
         var _loc3_:String = this.art_split(_loc2_.name)["type"];
         this.clothing_out = "";
         if(this.clothing_over == _loc3_)
         {
            return;
         }
         this.clothing_over = _loc3_;
         if(_loc2_.name == "hand_art1")
         {
            this.clothing_over = "glove1";
         }
         this.dispatchEvent(new Event("clothing_over"));
      }
      
      private function cloth_out(param1:MouseEvent) : void
      {
         var _loc2_:Object = param1.currentTarget;
         var _loc3_:String = this.art_split(_loc2_.name)["type"];
         this.clothing_over = "";
         if(this.clothing_out == _loc3_)
         {
            return;
         }
         this.clothing_out = _loc3_;
         if(_loc2_.name == "hand_art1")
         {
            this.clothing_out = "glove1";
         }
         this.dispatchEvent(new Event("clothing_out"));
      }
      
      private function stance_frame() : uint
      {
         if(this._simple)
         {
            return 1 + this.brot2 + this.body_height * rotation_count + this.body_type * h_count * rotation_count;
         }
         if(this.sitting)
         {
            return 1 + this.brot2 * 10;
         }
         return 1 + this._stance + this.brot2 * 10;
      }
      
      private function pose_frame() : uint
      {
         if(this._simple)
         {
            return this.stance_frame();
         }
         return 1 + this._pose + this.brot2 * 10;
      }
      
      private function gesture_frame() : uint
      {
         if(this._simple)
         {
            return this.stance_frame();
         }
         var _loc1_:uint = 1 + this._gesture + this.brot2 * 10;
         if(this._gesture >= 10)
         {
            _loc1_ = _loc1_ - 10;
         }
         return _loc1_;
      }
      
      private function redo() : void
      {
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc1_:int = this.stance_frame();
         var _loc2_:int = this.gesture_frame();
         var _loc3_:int = this.pose_frame();
         for(_loc5_ in this.body)
         {
            if(!(_loc5_ == "breasts" || _loc5_ == "necklace"))
            {
               _loc4_ = 0;
               while(_loc4_ < this.body[_loc5_].numChildren)
               {
                  if(this.body[_loc5_].getChildAt(_loc4_).type == "ac")
                  {
                     this.body[_loc5_].getChildAt(_loc4_).go_to_frame(_loc3_);
                  }
                  else
                  {
                     this.body[_loc5_].getChildAt(_loc4_).go_to_frame(_loc1_);
                  }
                  _loc4_ = _loc4_ + 1;
               }
            }
         }
         for(_loc5_ in this.arms)
         {
            if(!(_loc5_ == "head" || _loc5_ == "hback" || _loc5_ == "BODY" || _loc5_ == "hand_L" || _loc5_ == "hand_R"))
            {
               if(this.action)
               {
                  _loc2_ = _loc3_;
               }
               _loc4_ = 0;
               while(_loc4_ < this.arms[_loc5_].numChildren)
               {
                  this.arms[_loc5_].getChildAt(_loc4_).go_to_frame(_loc2_);
                  _loc4_ = _loc4_ + 1;
               }
            }
         }
         this.position_head();
         this.breasts_draw();
         this.position_arms();
         this.position_hands();
         this.update_levels();
         this.update_body_visibility();
      }
      
      private function position_arms() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:* = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         if(this.sitting || this.standing)
         {
            _loc8_ = this.position_data("L");
            _loc9_ = this.position_data("R");
            _loc1_ = _loc8_.x;
            _loc2_ = _loc8_.y;
            _loc4_ = _loc9_.x;
            _loc5_ = _loc9_.y;
            _loc3_ = _loc8_.rot + 63 + 180;
            _loc6_ = _loc9_.rot - 63;
         }
         else if(this.action)
         {
            _loc1_ = 0;
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = 0;
            _loc6_ = 0;
         }
         else
         {
            trace("When am I here?");
         }
         for(_loc7_ in this.arms)
         {
            if(!(_loc7_ == "head" || _loc7_ == "hback" || _loc7_ == "BODY"))
            {
               _loc10_ = _loc7_.substr(_loc7_.length - 1);
               if(_loc10_ == "L")
               {
                  this.arms[_loc7_].x = _loc1_;
                  this.arms[_loc7_].y = _loc2_;
                  this.arms[_loc7_].rotation = _loc3_;
               }
               else if(_loc10_ == "R")
               {
                  this.arms[_loc7_].x = _loc4_;
                  this.arms[_loc7_].y = _loc5_;
                  this.arms[_loc7_].rotation = _loc6_;
               }
               if(this.flipped)
               {
                  this.arms[_loc7_].x = this.arms[_loc7_].x * -1;
                  this.arms[_loc7_].rotation = this.arms[_loc7_].rotation * -1;
               }
            }
         }
      }
      
      private function update_levels() : void
      {
         var _loc1_:Object = null;
         var _loc3_:* = null;
         var _loc4_:Object = null;
         var _loc5_:* = null;
         if(this.just_head_visible)
         {
            for(_loc5_ in this.arms)
            {
               this.arms[_loc5_].visible = false;
            }
            for(_loc5_ in this.body)
            {
               this.body[_loc5_].visible = false;
            }
            this.arms["head"].visible = this.arms["hback"].visible = true;
            return;
         }
         if(this.sitting)
         {
            _loc1_ = sitting_levels[this.brot2];
         }
         else if(this.standing)
         {
            _loc1_ = standing_levels[this.brot2];
         }
         else
         {
            _loc1_ = action_levels[this.brot2][this._pose];
         }
         this.body["shirtskirt"].visible = !this.pants;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            this.body_clip.setChildIndex(this.body[_loc1_[_loc2_]],_loc2_);
            _loc2_ = _loc2_ + 1;
         }
         for(_loc3_ in this.arms)
         {
            this.arms[_loc3_].visible = false;
         }
         if(this.action)
         {
            _loc4_ = acg_levels[this.brot2][this._pose];
         }
         else if(this._gesture <= 9)
         {
            _loc4_ = g1_levels[this.brot2][this._gesture];
         }
         else
         {
            _loc4_ = g2_levels[this.brot2][this._gesture - 10];
         }
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            this.arms[_loc4_[_loc2_]].visible = true;
            setChildIndex(this.arms[_loc4_[_loc2_]],_loc2_);
            _loc2_ = _loc2_ + 1;
         }
         this.arms["shoulder_L"].visible = this.arms["shoulder_R"].visible = !this.jacket;
         if(this._head)
         {
            this._head.get_piece("hair_back").visible = false;
            if(this._head.h_rot >= 3 && this._head.h_rot <= 5 && (this.body_rotation <= 2 || this.body_rotation >= 6))
            {
               swapChildren(this.arms["head"],this.arms["hback"]);
            }
            if(this.body_rotation >= 3 && this.body_rotation <= 5 && (this._head.h_rot >= 6 || this._head.h_rot <= 2))
            {
               swapChildren(this.arms["head"],this.arms["hback"]);
            }
         }
      }
      
      private function position_data(param1:String) : Object
      {
         var type:String = param1;
         var xt:Number = 0;
         var yt:Number = 0;
         var rot:Number = 0;
         if((type == "HL" || type == "HR") && (this.sitting || this.standing))
         {
            return {};
         }
         try
         {
            if(this.sitting)
            {
               rot = this.points["sitting_" + type]["angle"][this.body_type][this.body_height][this.brot2][this._stance];
               xt = this.points["sitting_" + type]["point"][this.body_type][this.body_height][this.brot2][this._stance * 2];
               yt = this.points["sitting_" + type]["point"][this.body_type][this.body_height][this.brot2][this._stance * 2 + 1];
            }
            else if(this.action)
            {
               rot = this.points["actions_" + type]["angle"][this.body_type][this.body_height][this.brot2][this._pose];
               xt = this.points["actions_" + type]["point"][this.body_type][this.body_height][this.brot2][this._pose * 2];
               yt = this.points["actions_" + type]["point"][this.body_type][this.body_height][this.brot2][this._pose * 2 + 1];
            }
            else
            {
               rot = this.points["standing_" + type]["angle"][this.body_type][this.body_height][this.brot2][this._stance];
               xt = this.points["standing_" + type]["point"][this.body_type][this.body_height][this.brot2][this._stance * 2];
               yt = this.points["standing_" + type]["point"][this.body_type][this.body_height][this.brot2][this._stance * 2 + 1];
            }
         }
         catch(e:Error)
         {
            trace("POSITION DATA ERROR ON: " + type + ", " + e);
         }
         return {
            "x":xt,
            "y":yt,
            "rot":rot
         };
      }
      
      private function breasts_draw() : void
      {
         var _loc1_:Object = {
            7:0,
            8:3,
            2:6,
            9:9,
            4:12,
            10:15,
            6:18
         };
         var _loc2_:Object = this.position_data("B");
         this.body["breasts"].x = _loc2_.x;
         this.body["breasts"].y = _loc2_.y;
         if(_loc2_.rot < 0)
         {
            this.body["breasts"].rotation = 78 - 90;
         }
         else
         {
            this.body["breasts"].rotation = _loc2_.rot - 90;
         }
         this.body["necklace"].x = this.body["breasts"].x;
         this.body["necklace"].y = this.body["breasts"].y;
         this.body["necklace"].rotation = this.body["breasts"].rotation;
         var _loc3_:uint = 0;
         while(_loc3_ < this.body["necklace"].numChildren)
         {
            this.body["necklace"].getChildAt(_loc3_).go_to_frame(this.brot2 + 1);
            _loc3_ = _loc3_ + 1;
         }
         if(_loc1_[this.body_type] == undefined || this.breast_type == 3 || this.sex == 1)
         {
            this.body["breasts"].visible = false;
            return;
         }
         this.body["breasts"].visible = true;
         var _loc4_:uint = 1 + this.breast_type + this.brot2 * 10 + this.body_height * rotation_count * 10 + this.body_type * h_count * rotation_count * 10;
         _loc3_ = 0;
         while(_loc3_ < this.body["breasts"].numChildren)
         {
            this.body["breasts"].getChildAt(_loc3_).go_to_frame(_loc4_);
            _loc3_ = _loc3_ + 1;
         }
      }
      
      private function position_hands() : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc1_:DisplayObject = this.arms["hand_L"].getChildAt(0);
         var _loc2_:DisplayObject = this.arms["hand_R"].getChildAt(0);
         var _loc3_:Object = this.position_data("HL");
         var _loc4_:Object = this.position_data("HR");
         var _loc5_:uint = this._gesture;
         if(this.standing || this.sitting)
         {
            if(this._gesture <= 9)
            {
               _loc6_ = "gestures1_HL";
               _loc7_ = "gestures1_HR";
            }
            else
            {
               _loc6_ = "gestures2_HL";
               _loc7_ = "gestures2_HR";
               _loc5_ = _loc5_ - 10;
            }
            _loc3_.rot = this.points[_loc6_]["angle"][this.body_type][this.body_height][this.brot2][_loc5_];
            _loc4_.rot = this.points[_loc7_]["angle"][this.body_type][this.body_height][this.brot2][_loc5_];
            _loc3_.x = this.points[_loc6_]["point"][this.body_type][this.body_height][this.brot2][_loc5_ * 2];
            _loc3_.y = this.points[_loc6_]["point"][this.body_type][this.body_height][this.brot2][_loc5_ * 2 + 1];
            _loc4_.x = this.points[_loc7_]["point"][this.body_type][this.body_height][this.brot2][_loc5_ * 2];
            _loc4_.y = this.points[_loc7_]["point"][this.body_type][this.body_height][this.brot2][_loc5_ * 2 + 1];
         }
         _loc1_.x = _loc3_.x;
         _loc1_.y = _loc3_.y;
         _loc1_.rotation = _loc3_.rot - 90;
         _loc2_.x = _loc4_.x;
         _loc2_.y = _loc4_.y;
         _loc2_.rotation = _loc4_.rot - 90;
      }
      
      public function position_head() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Object = this.position_data("H");
         _loc1_ = _loc4_.x;
         _loc2_ = _loc4_.y;
         _loc3_ = _loc4_.rot;
         if(_loc3_ == 0)
         {
            _loc3_ = 0;
         }
         else if(_loc3_ > 0)
         {
            _loc3_ = _loc3_ - 90;
         }
         else
         {
            _loc3_ = _loc3_ + 90;
         }
         var _loc5_:Matrix = new Matrix();
         if(this.flipped)
         {
            _loc1_ = _loc1_ * -1;
            _loc3_ = _loc3_ * -1;
         }
         _loc3_ = _loc3_ + this.head_angle;
         var _loc6_:Number = 1;
         var _loc7_:Number = 1;
         if(this._head)
         {
            _loc6_ = this._head.scaleX;
            _loc7_ = this._head.scaleY;
            _loc2_ = _loc2_ - this._head.scaleY * 30;
         }
         _loc5_.translate(_loc1_,_loc2_);
         if(_loc3_ == 0)
         {
            _loc3_ = 0.1;
         }
         rotateAroundInternalPoint(_loc5_,0,30,_loc3_);
         this.head_clip.transform.matrix = _loc5_;
         this.head_clip.scaleX = _loc6_;
         this.head_clip.scaleY = _loc7_;
         if(!this.flipped)
         {
         }
         this.arms["hback"].x = this.head_clip.x;
         this.arms["hback"].y = this.head_clip.y;
         this.arms["hback"].scaleY = this.head_clip.scaleY;
         this.arms["hback"].scaleX = this.head_clip.scaleX;
         if(this.debug)
         {
            trace(" ------------------------------------ " + this.head_clip.x + ", " + this.head_clip.y + " " + this.head_clip.scaleX + " " + this.head_clip.scaleY + " " + this.head_clip.rotation);
         }
         this.arms["hback"].rotation = this.head_clip.rotation;
      }
      
      public function stance_up() : void
      {
         if(this._stance >= 3)
         {
            this.set_stance(this._stance - 3);
         }
      }
      
      public function stance_down() : void
      {
         if(this._stance <= 5)
         {
            this.set_stance(this._stance + 3);
         }
      }
      
      public function stance_left() : void
      {
         if(this.flipped)
         {
            if(this._stance % 3 != 2)
            {
               this.set_stance(this._stance + 1);
            }
         }
         else if(this._stance % 3 != 0)
         {
            this.set_stance(this._stance - 1);
         }
      }
      
      public function stance_right() : void
      {
         if(this.flipped)
         {
            if(this._stance % 3 != 0)
            {
               this.set_stance(this._stance - 1);
            }
         }
         else if(this._stance % 3 != 2)
         {
            this.set_stance(this._stance + 1);
         }
      }
      
      public function set_stance(param1:uint) : uint
      {
         if(this._simple)
         {
            this._stance = 0;
         }
         this._stance = Math.min(8,Math.max(0,param1));
         this.redo();
         return this._stance;
      }
      
      public function set_pose(param1:uint) : uint
      {
         if(this._simple)
         {
            param1 = 0;
         }
         this._pose = Math.min(9,Math.max(0,param1));
         this.redo();
         return this._stance;
      }
      
      public function set_head_angle(param1:Number) : Number
      {
         this.head_angle = param1;
         this.position_head();
         return param1;
      }
      
      public function set_hand(param1:uint, param2:uint) : uint
      {
         if(param1 == 2)
         {
            this.arms["hand_L"].getChildAt(0).go_to_frame(param2);
            this.arms["hand_R"].getChildAt(0).go_to_frame(param2);
            this._hands[0] = this._hands[1] = param2;
         }
         else if(param1 == 0)
         {
            this.arms["hand_L"].getChildAt(0).go_to_frame(param2);
            this._hands[0] = param2;
         }
         else if(param1 == 1)
         {
            this.arms["hand_R"].getChildAt(0).go_to_frame(param2);
            this._hands[1] = param2;
         }
         return param1;
      }
      
      public function set_breast(param1:uint) : uint
      {
         this._breast_type = param1;
         this.redo();
         dispatchEvent(new Event("body_update"));
         return param1;
      }
      
      public function set_height(param1:uint) : uint
      {
         this._body_height = param1;
         this.bt_change();
         this.redo();
         dispatchEvent(new Event("body_update"));
         return param1;
      }
      
      public function set_gesture(param1:uint) : uint
      {
         if(this._simple)
         {
            this._gesture = 0;
         }
         this._gesture = param1;
         this.set_hand(0,hand_frames[this.brot][0][this._gesture]);
         this.set_hand(1,hand_frames[this.brot][1][this._gesture]);
         this.redo();
         return this._gesture;
      }
      
      public function update_body_visibility() : void
      {
         var _loc1_:* = null;
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         for(_loc1_ in this.body)
         {
            if(!(_loc1_ == "breasts" || _loc1_ == "necklace"))
            {
               _loc2_ = 0;
               while(_loc2_ < this.body[_loc1_].numChildren)
               {
                  _loc3_ = this.body[_loc1_].getChildAt(_loc2_);
                  if(this._simple && _loc3_.type == "simple")
                  {
                     _loc3_.visible = true;
                  }
                  else if(this.standing && _loc3_.type == "st")
                  {
                     _loc3_.visible = true;
                  }
                  else if(this.sitting && _loc3_.type == "si")
                  {
                     _loc3_.visible = true;
                  }
                  else if(this.action && _loc3_.type == "ac")
                  {
                     _loc3_.visible = true;
                  }
                  else
                  {
                     _loc3_.visible = false;
                  }
                  _loc2_ = _loc2_ + 1;
               }
               this.body["shirtskirt"].visible = !this.pants;
            }
         }
         for(_loc1_ in this.arms)
         {
            if(!(_loc1_ == "head" || _loc1_ == "BODY" || _loc1_ == "hback" || _loc1_ == "hand_L" || _loc1_ == "hand_R"))
            {
               _loc2_ = 0;
               while(_loc2_ < this.arms[_loc1_].numChildren)
               {
                  _loc3_ = this.arms[_loc1_].getChildAt(_loc2_);
                  if(this._simple)
                  {
                     if(_loc3_.type == "simple")
                     {
                        _loc3_.visible = true;
                     }
                     else
                     {
                        _loc3_.visible = false;
                     }
                  }
                  else if(this.action)
                  {
                     if(_loc3_.type == "ac")
                     {
                        _loc3_.visible = true;
                     }
                     else
                     {
                        _loc3_.visible = false;
                     }
                  }
                  else if(_loc3_.type == "g1" && this._gesture <= 9)
                  {
                     _loc3_.visible = true;
                  }
                  else if(_loc3_.type == "g2" && this._gesture >= 10)
                  {
                     _loc3_.visible = true;
                  }
                  else
                  {
                     _loc3_.visible = false;
                  }
                  _loc2_ = _loc2_ + 1;
               }
            }
         }
      }
      
      public function set_rotation(param1:uint) : uint
      {
         var _loc3_:* = null;
         var _loc2_:Number = 1;
         param1 = Math.min(7,Math.max(0,param1));
         this.body_rotation = param1;
         if(this.body_rotation <= 7 && this.body_rotation >= 5)
         {
            if(this.flipped == false)
            {
               if(this._stance % 3 == 0)
               {
                  this._stance = this._stance + 2;
               }
               else if(this._stance % 3 == 2)
               {
                  this._stance = this._stance - 2;
               }
            }
            this.flipped = true;
            _loc2_ = -1;
         }
         else
         {
            if(this.flipped)
            {
               if(this._stance % 3 == 2)
               {
                  this._stance = this._stance - 2;
               }
               else if(this._stance % 3 == 0)
               {
                  this._stance = this._stance + 2;
               }
            }
            this.flipped = false;
         }
         if(this.body_rotation >= 3 && this.body_rotation <= 5)
         {
            this.arms["hand_L"].getChildAt(0).scaleX = -1;
            this.arms["hand_R"].getChildAt(0).scaleX = 1;
         }
         else
         {
            this.arms["hand_L"].getChildAt(0).scaleX = 1;
            this.arms["hand_R"].getChildAt(0).scaleX = -1;
         }
         if(this.body_rotation == 7 || this.body_rotation == 5 || this.body_rotation == 3 || this.body_rotation == 1)
         {
            this.brot = 1;
         }
         else if(this.body_rotation == 6 || this.body_rotation == 2)
         {
            this.brot = 2;
         }
         else
         {
            this.brot = 0;
         }
         if(this.body_rotation <= 4)
         {
            this.brot2 = this.body_rotation;
         }
         else if(this.body_rotation == 5)
         {
            this.brot2 = 3;
         }
         else if(this.body_rotation == 6)
         {
            this.brot2 = 2;
         }
         else if(this.body_rotation == 7)
         {
            this.brot2 = 1;
         }
         for(_loc3_ in this.arms)
         {
            if(!(_loc3_ == "head" || _loc3_ == "hback"))
            {
               this.arms[_loc3_].scaleX = _loc2_;
            }
         }
         this.update_body_visibility();
         this.set_gesture(this._gesture);
         dispatchEvent(new Event("body_update"));
         return this.body_rotation;
      }
      
      public function set_body_type(param1:Number) : Number
      {
         this._body_type = param1;
         this.redo();
         dispatchEvent(new Event("body_update"));
         return param1;
      }
      
      public function set_sex(param1:Number) : void
      {
         var _loc2_:uint = this.body_type;
         if(param1 == 1)
         {
            if(_loc2_ == 7)
            {
               _loc2_ = 0;
            }
            if(_loc2_ == 8)
            {
               _loc2_ = 1;
            }
            if(_loc2_ == 9)
            {
               _loc2_ = 3;
            }
            if(_loc2_ == 10)
            {
               _loc2_ = 5;
            }
            this._sex = 1;
         }
         else
         {
            if(_loc2_ == 0)
            {
               _loc2_ = 7;
            }
            if(_loc2_ == 1)
            {
               _loc2_ = 8;
            }
            if(_loc2_ == 3)
            {
               _loc2_ = 9;
            }
            if(_loc2_ == 5)
            {
               _loc2_ = 10;
            }
            this._sex = 2;
         }
         this.set_body_type(_loc2_);
      }
      
      public function dodat() : BitmapData
      {
         var _loc1_:Rectangle = this.getBounds(this);
         var _loc2_:Matrix = new Matrix();
         var _loc3_:Number = 1;
         _loc2_.scale(_loc3_,_loc3_);
         _loc2_.translate(-_loc1_.x * _loc3_,-_loc1_.y * _loc3_);
         if(_loc1_.x < -500 || _loc1_.y < -500 || _loc1_.width > 1000 || _loc1_.height > 1000 || _loc1_.x > 500 || _loc1_.y > 500)
         {
            trace("Unreasonable bounds!");
            trace(_loc1_);
            _loc1_.x = _loc1_.y = 0;
            _loc1_.width = _loc1_.height = 100;
         }
         var _loc4_:BitmapData = new BitmapData(_loc1_.width * _loc3_,_loc1_.height * _loc3_,true,16777215);
         var _loc5_:DisplayObject = this.mask;
         this.mask = null;
         _loc4_.draw(this,_loc2_,null,null,null,true);
         this.mask = _loc5_;
         return _loc4_;
      }
      
      public function save_state() : Object
      {
         var _loc1_:Object = {
            "gesture":this._gesture,
            "stance":this._stance,
            "pose":this._pose,
            "body_rotation":this.body_rotation,
            "head_angle":this.head_angle,
            "hands":this._hands,
            "standing":this.standing,
            "action":this.action,
            "sitting":this.sitting
         };
         _loc1_["head"] = this._head.save_state();
         return _loc1_;
      }
      
      public function load_state(param1:Object) : void
      {
         if(this.debug)
         {
            trace("--Body.load_state(" + param1["gesture"] + ")--");
         }
         this.action = param1["action"];
         this.sitting = param1["sitting"];
         this.standing = param1["standing"];
         this._gesture = param1["gesture"];
         this._stance = param1["stance"];
         this._pose = param1["pose"];
         this.body_rotation = param1["body_rotation"];
         this.head_angle = param1["head_angle"];
         this._head.load_state(param1["head"]);
         this.set_rotation(this.body_rotation);
         this._hands = [param1["hands"][0],param1["hands"][1]];
         this.set_hand(0,this._hands[0]);
         this.set_hand(1,this._hands[1]);
         this.redo();
      }
      
      public function get head() : Head
      {
         return this._head;
      }
      
      public function get master_rotation() : uint
      {
         return this.body_rotation;
      }
      
      public function get is_action() : Boolean
      {
         return this.action;
      }
      
      public function get is_standing() : Boolean
      {
         return this.standing;
      }
      
      public function get is_sitting() : Boolean
      {
         return this.sitting;
      }
      
      public function get gesture_num() : uint
      {
         return this._gesture;
      }
      
      public function get hands() : Array
      {
         return [this._hands[0],this._hands[1]];
      }
      
      public function get simple() : Boolean
      {
         return this._simple;
      }
      
      public function get body_type() : uint
      {
         return this._body_type;
      }
      
      public function set body_type(param1:uint) : void
      {
         this.set_body_type(param1);
      }
      
      public function get body_height() : uint
      {
         return this._body_height;
      }
      
      public function set body_height(param1:uint) : void
      {
         this.set_height(param1);
      }
      
      public function get sex() : uint
      {
         return this._sex;
      }
      
      public function set sex(param1:uint) : void
      {
         this._sex = param1;
      }
      
      public function get breast_type() : uint
      {
         return this._breast_type;
      }
      
      public function set breast_type(param1:uint) : void
      {
         this.set_breast(param1);
      }
      
      public function toggle_control() : Boolean
      {
         return false;
      }
   }
}
