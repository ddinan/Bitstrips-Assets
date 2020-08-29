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
      
      private static const body_pieces:Array = ["OV_L","OV_R","OV_B","shirtfront","neck","breasts","foot_L","foot_R","leg_R","leg_L","torso","skirt","shirtskirt","necklace"];
      
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
      
      private static const stance_count:uint = 10;
      
      private static const arm_pieces:Array = ["OV_fore_L","cuff_L","fore_L","OV_fore_R","shoulder_L","shoulder_R","cuff_R","fore_R","OV_arm_L","arm_L","OV_arm_R","arm_R","hand_L","hand_R"];
      
      private static const standing_levels:Object = {
         0:["torso","leg_L","foot_L","leg_R","foot_R","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
         1:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_R","OV_L"],
         2:["torso","leg_R","foot_R","leg_L","foot_L","skirt","breasts","neck","shirtfront","OV_L"],
         3:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"],
         4:["breasts","torso","leg_L","foot_L","leg_R","foot_R","skirt","neck","shirtfront","OV_B"]
      };
      
      private static const rotation_count:uint = 5;
      
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
      
      private static const gesture_count:uint = 10;
      
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
      
      private static const h_count:uint = 5;
       
      
      public var colour_click_call:Function;
      
      public var _gesture:Number = 0;
      
      public var clothing_out:String;
      
      public var clothing_over:String;
      
      public var _breast_type:Number = 0;
      
      private var brot:uint = 0;
      
      public var action:Boolean = false;
      
      public var _body_type:Number = 0;
      
      private var pieces:Array;
      
      public var remote:Remote;
      
      public var clothes:Array;
      
      public var standing:Boolean = true;
      
      public var _stance:Number = 1;
      
      private var debug:Boolean = false;
      
      public var head_clip:Sprite;
      
      public var _cld:ColourData;
      
      public var clothing_selected:String;
      
      public var art_loader:ArtLoader;
      
      public var body_rotation:Number = 0;
      
      public var _pose:Number = 0;
      
      public var flipped:Boolean = false;
      
      public var just_head_visible:Boolean = false;
      
      private var arms:Object;
      
      private var brot2:uint = 0;
      
      public var _sex:uint = 1;
      
      private var body:Object;
      
      public var _body_height:Number = 0;
      
      public var head_angle:Number = 0;
      
      public var edit_mode:Boolean = false;
      
      public var _head:Head;
      
      public var sitting:Boolean = false;
      
      private var body_clip:Sprite;
      
      private var jacket:Boolean = false;
      
      public var _simple:Boolean = true;
      
      private var pants:Boolean = false;
      
      private var _hands:Array;
      
      public var points:Object;
      
      private var clothing_debug:Boolean = false;
      
      public function Body(param1:Head, param2:Object = undefined, param3:Boolean = true)
      {
         var i:String = null;
         var ht:Object = null;
         var part:String = null;
         var item:String = null;
         var the_head:Head = param1;
         var settings:Object = param2;
         var em:Boolean = param3;
         _hands = [0,0];
         head_clip = new Sprite();
         arms = new Object();
         body = new Object();
         clothes = new Array();
         pieces = new Array();
         body_clip = new Sprite();
         super();
         if(debug)
         {
            trace("Initing body" + " EditMode: " + em);
         }
         if(BSConstants.EDU)
         {
            this._breast_type = 3;
         }
         _head = the_head;
         art_loader = ArtLoader.getInstance();
         if(_head)
         {
            _cld = _head.cld;
         }
         if(_cld)
         {
            _cld.addEventListener("NEW_COLOUR",function(param1:Event):void
            {
               update_colours();
            });
         }
         points = art_loader.points;
         this.edit_mode = em;
         var bitmap_head:Boolean = !edit_mode;
         if(BSConstants.NO_BM_HEAD)
         {
            bitmap_head = false;
         }
         for(i in body_pieces)
         {
            part = body_pieces[i];
            body[part] = new Sprite();
            body_clip.addChild(body[part]);
         }
         for(i in arm_pieces)
         {
            part = arm_pieces[i];
            arms[part] = new Sprite();
            addChild(arms[part]);
         }
         ht = art_loader.get_art("hand","hand_art1");
         arms["hand_L"].addChild(ht);
         ht.go_to_frame(2);
         pieces.push(ht);
         ht = art_loader.get_art("hand","hand_art1");
         arms["hand_R"].addChild(ht);
         ht.go_to_frame(2);
         ht.scaleX = -1;
         pieces.push(ht);
         if(_head)
         {
            if(bitmap_head)
            {
               _head.enable_bdats();
               head_clip.addChild(_head.fg_head);
            }
            else
            {
               head_clip.addChild(_head);
            }
         }
         arms["head"] = head_clip;
         arms["hback"] = new Sprite();
         if(_head)
         {
            if(bitmap_head == false)
            {
               arms["hback"].addChild(_head.head_back);
            }
            else
            {
               arms["hback"].addChild(_head.bg_head);
            }
            _head.used_back = true;
            _head.set_backstyle(_head.backstyle);
            _head.get_piece("hair_back").visible = false;
         }
         arms["BODY"] = body_clip;
         addChild(head_clip);
         addChild(arms["hback"]);
         addChild(body_clip);
         if(edit_mode)
         {
            _simple = true;
            _gesture = 1;
            for(i in pieces)
            {
               setup_edit(pieces[i]);
            }
         }
         else
         {
            _simple = false;
         }
         if(_head)
         {
            _head.addEventListener("HAIR_UPDATE",function(param1:Event):void
            {
               position_head();
            });
            _head.addEventListener("ROTATION",function(param1:Event):void
            {
               update_levels();
            });
         }
         if(settings != null)
         {
            if(settings["body_type"])
            {
               body_type = settings["body_type"];
            }
            body_height = settings["body_height"];
            if(settings["breast_type"])
            {
               breast_type = settings["breast_type"];
            }
            if(settings["sex"])
            {
               sex = settings["sex"];
            }
            else if(_body_type == 7 || _body_type == 8 || _body_type == 9 || _body_type == 10)
            {
               sex = 2;
            }
            if(em == false)
            {
            }
         }
         add_clothing("bare",true);
         if(settings != null && settings["clothes"])
         {
            for each(item in settings["clothes"])
            {
               add_clothing(item,true);
            }
         }
         redo();
         update_colours();
      }
      
      public static function rotateAroundExternalPoint(param1:Matrix, param2:Number, param3:Number, param4:Number) : void
      {
         param1.translate(-param2,-param3);
         param1.rotate(param4 * (Math.PI / 180));
         param1.translate(param2,param3);
      }
      
      public static function rotateAroundInternalPoint(param1:Matrix, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:Point = param1.transformPoint(new Point(param2,param3));
         rotateAroundExternalPoint(param1,_loc5_.x,_loc5_.y,param4);
      }
      
      private function position_data(param1:String) : Object
      {
         var type:String = param1;
         var xt:Number = 0;
         var yt:Number = 0;
         var rot:Number = 0;
         if((type == "HL" || type == "HR") && (sitting || standing))
         {
            return {};
         }
         try
         {
            if(sitting)
            {
               rot = points["sitting_" + type]["angle"][body_type][body_height][brot2][_stance];
               xt = points["sitting_" + type]["point"][body_type][body_height][brot2][_stance * 2];
               yt = points["sitting_" + type]["point"][body_type][body_height][brot2][_stance * 2 + 1];
            }
            else if(action)
            {
               rot = points["actions_" + type]["angle"][body_type][body_height][brot2][_pose];
               xt = points["actions_" + type]["point"][body_type][body_height][brot2][_pose * 2];
               yt = points["actions_" + type]["point"][body_type][body_height][brot2][_pose * 2 + 1];
            }
            else
            {
               rot = points["standing_" + type]["angle"][body_type][body_height][brot2][_stance];
               xt = points["standing_" + type]["point"][body_type][body_height][brot2][_stance * 2];
               yt = points["standing_" + type]["point"][body_type][body_height][brot2][_stance * 2 + 1];
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
      
      private function redo() : void
      {
         var _loc4_:int = 0;
         var _loc5_:* = null;
         var _loc1_:int = stance_frame();
         var _loc2_:int = gesture_frame();
         var _loc3_:int = pose_frame();
         for(_loc5_ in body)
         {
            if(!(_loc5_ == "breasts" || _loc5_ == "necklace"))
            {
               _loc4_ = 0;
               while(_loc4_ < body[_loc5_].numChildren)
               {
                  if(body[_loc5_].getChildAt(_loc4_).type == "ac")
                  {
                     body[_loc5_].getChildAt(_loc4_).go_to_frame(_loc3_);
                  }
                  else
                  {
                     body[_loc5_].getChildAt(_loc4_).go_to_frame(_loc1_);
                  }
                  _loc4_ = _loc4_ + 1;
               }
            }
         }
         for(_loc5_ in arms)
         {
            if(!(_loc5_ == "head" || _loc5_ == "hback" || _loc5_ == "BODY" || _loc5_ == "hand_L" || _loc5_ == "hand_R"))
            {
               if(action)
               {
                  _loc2_ = _loc3_;
               }
               _loc4_ = 0;
               while(_loc4_ < arms[_loc5_].numChildren)
               {
                  arms[_loc5_].getChildAt(_loc4_).go_to_frame(_loc2_);
                  _loc4_ = _loc4_ + 1;
               }
            }
         }
         position_head();
         breasts_draw();
         position_arms();
         position_hands();
         update_levels();
         update_body_visibility();
      }
      
      public function set_sex(param1:Number) : void
      {
         var _loc2_:uint = body_type;
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
            _sex = 1;
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
            _sex = 2;
         }
         set_body_type(_loc2_);
      }
      
      public function stance_up() : void
      {
         if(_stance >= 3)
         {
            set_stance(_stance - 3);
         }
      }
      
      public function set_body_type(param1:Number) : Number
      {
         _body_type = param1;
         redo();
         dispatchEvent(new Event("body_update"));
         return param1;
      }
      
      public function get cld() : ColourData
      {
         return _cld;
      }
      
      private function type_add(param1:Object, param2:String, param3:Array) : void
      {
         var _loc5_:* = null;
         var _loc6_:Object = null;
         if(clothing_debug)
         {
            trace("Adding clothing: " + param2 + " - " + param3);
         }
         var _loc4_:Array = art_loader.sorted_index2(param2,param3,body_type,body_height);
         if(clothing_debug)
         {
            trace("\tArt list: " + _loc4_);
         }
         for(_loc5_ in _loc4_)
         {
            _loc6_ = art_loader.get_art(param2,_loc4_[_loc5_],body_type,body_height);
            if(_loc4_[_loc5_].indexOf("skirt_shirt") <= 1)
            {
               if(_loc6_.type == "")
               {
                  _loc6_.type = param2;
               }
               if(!_loc6_.base_colour)
               {
                  _loc6_.set_new_frame_func(cld.colour_clip);
               }
               param1[_loc6_.body_part].addChild(_loc6_);
               if(edit_mode)
               {
                  setup_edit(_loc6_);
               }
               adjust_part_order(param1[_loc6_.body_part]);
               pieces.push(_loc6_);
            }
         }
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
         var _loc2_:Object = position_data("B");
         body["breasts"].x = _loc2_.x;
         body["breasts"].y = _loc2_.y;
         if(_loc2_.rot < 0)
         {
            body["breasts"].rotation = 78 - 90;
         }
         else
         {
            body["breasts"].rotation = _loc2_.rot - 90;
         }
         body["necklace"].x = body["breasts"].x;
         body["necklace"].y = body["breasts"].y;
         body["necklace"].rotation = body["breasts"].rotation;
         var _loc3_:uint = 0;
         while(_loc3_ < body["necklace"].numChildren)
         {
            body["necklace"].getChildAt(_loc3_).go_to_frame(brot2 + 1);
            _loc3_ = _loc3_ + 1;
         }
         if(_loc1_[body_type] == undefined || breast_type == 3 || sex == 1)
         {
            body["breasts"].visible = false;
            return;
         }
         body["breasts"].visible = true;
         var _loc4_:uint = 1 + breast_type + brot2 * 10 + body_height * rotation_count * 10 + body_type * h_count * rotation_count * 10;
         _loc3_ = 0;
         while(_loc3_ < body["breasts"].numChildren)
         {
            body["breasts"].getChildAt(_loc3_).go_to_frame(_loc4_);
            _loc3_ = _loc3_ + 1;
         }
      }
      
      public function set_hand(param1:uint, param2:uint) : uint
      {
         if(param1 == 2)
         {
            arms["hand_L"].getChildAt(0).go_to_frame(param2);
            arms["hand_R"].getChildAt(0).go_to_frame(param2);
            _hands[0] = _hands[1] = param2;
         }
         else if(param1 == 0)
         {
            arms["hand_L"].getChildAt(0).go_to_frame(param2);
            _hands[0] = param2;
         }
         else if(param1 == 1)
         {
            arms["hand_R"].getChildAt(0).go_to_frame(param2);
            _hands[1] = param2;
         }
         return param1;
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
      
      public function bt_change() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in clothes)
         {
            remove_clothing(clothes[_loc1_]);
            add_clothing(clothes[_loc1_]);
         }
         load_all();
      }
      
      private function art_split(param1:String) : Object
      {
         var _loc2_:int = param1.lastIndexOf("_");
         return {
            "part":param1.substr(0,_loc2_),
            "type":param1.substr(_loc2_ + 1)
         };
      }
      
      private function pose_frame() : uint
      {
         if(_simple)
         {
            return stance_frame();
         }
         return 1 + _pose + brot2 * 10;
      }
      
      public function stance_right() : void
      {
         if(flipped)
         {
            if(_stance % 3 != 0)
            {
               set_stance(_stance - 1);
            }
         }
         else if(_stance % 3 != 2)
         {
            set_stance(_stance + 1);
         }
      }
      
      public function stance_down() : void
      {
         if(_stance <= 5)
         {
            set_stance(_stance + 3);
         }
      }
      
      private function position_hands() : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc1_:DisplayObject = arms["hand_L"].getChildAt(0);
         var _loc2_:DisplayObject = arms["hand_R"].getChildAt(0);
         var _loc3_:Object = position_data("HL");
         var _loc4_:Object = position_data("HR");
         var _loc5_:uint = _gesture;
         if(standing || sitting)
         {
            if(_gesture <= 9)
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
            _loc3_.rot = points[_loc6_]["angle"][body_type][body_height][brot2][_loc5_];
            _loc4_.rot = points[_loc7_]["angle"][body_type][body_height][brot2][_loc5_];
            _loc3_.x = points[_loc6_]["point"][body_type][body_height][brot2][_loc5_ * 2];
            _loc3_.y = points[_loc6_]["point"][body_type][body_height][brot2][_loc5_ * 2 + 1];
            _loc4_.x = points[_loc7_]["point"][body_type][body_height][brot2][_loc5_ * 2];
            _loc4_.y = points[_loc7_]["point"][body_type][body_height][brot2][_loc5_ * 2 + 1];
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
         var _loc4_:Object = position_data("H");
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
         if(flipped)
         {
            _loc1_ = _loc1_ * -1;
            _loc3_ = _loc3_ * -1;
         }
         _loc3_ = _loc3_ + head_angle;
         var _loc6_:Number = 1;
         var _loc7_:Number = 1;
         if(_head)
         {
            _loc6_ = _head.scaleX;
            _loc7_ = _head.scaleY;
            _loc2_ = _loc2_ - _head.scaleY * 30;
         }
         _loc5_.translate(_loc1_,_loc2_);
         if(_loc3_ == 0)
         {
            _loc3_ = 0.1;
         }
         rotateAroundInternalPoint(_loc5_,0,30,_loc3_);
         head_clip.transform.matrix = _loc5_;
         head_clip.scaleX = _loc6_;
         head_clip.scaleY = _loc7_;
         if(!flipped)
         {
         }
         arms["hback"].x = head_clip.x;
         arms["hback"].y = head_clip.y;
         arms["hback"].scaleY = head_clip.scaleY;
         arms["hback"].scaleX = head_clip.scaleX;
         if(debug)
         {
            trace(" ------------------------------------ " + head_clip.x + ", " + head_clip.y + " " + head_clip.scaleX + " " + head_clip.scaleY + " " + head_clip.rotation);
         }
         arms["hback"].rotation = head_clip.rotation;
      }
      
      public function update_body_visibility() : void
      {
         var _loc1_:* = null;
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         for(_loc1_ in body)
         {
            if(!(_loc1_ == "breasts" || _loc1_ == "necklace"))
            {
               _loc2_ = 0;
               while(_loc2_ < body[_loc1_].numChildren)
               {
                  _loc3_ = body[_loc1_].getChildAt(_loc2_);
                  if(_simple && _loc3_.type == "simple")
                  {
                     _loc3_.visible = true;
                  }
                  else if(standing && _loc3_.type == "st")
                  {
                     _loc3_.visible = true;
                  }
                  else if(sitting && _loc3_.type == "si")
                  {
                     _loc3_.visible = true;
                  }
                  else if(action && _loc3_.type == "ac")
                  {
                     _loc3_.visible = true;
                  }
                  else
                  {
                     _loc3_.visible = false;
                  }
                  _loc2_ = _loc2_ + 1;
               }
               body["shirtskirt"].visible = !pants;
            }
         }
         for(_loc1_ in arms)
         {
            if(!(_loc1_ == "head" || _loc1_ == "BODY" || _loc1_ == "hback" || _loc1_ == "hand_L" || _loc1_ == "hand_R"))
            {
               _loc2_ = 0;
               while(_loc2_ < arms[_loc1_].numChildren)
               {
                  _loc3_ = arms[_loc1_].getChildAt(_loc2_);
                  if(_simple)
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
                  else if(action)
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
                  else if(_loc3_.type == "g1" && _gesture <= 9)
                  {
                     _loc3_.visible = true;
                  }
                  else if(_loc3_.type == "g2" && _gesture >= 10)
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
      
      private function art_part(param1:String) : String
      {
         return param1.substr(param1.lastIndexOf("_") + 1);
      }
      
      private function art_loaded(param1:String) : void
      {
         var _loc2_:* = null;
         if(debug)
         {
            trace("ART LOADED: " + param1);
         }
         _simple = false;
         remove_clothing("bare");
         remove_clothing("bare");
         remove_clothing("bare");
         add_clothing("bare");
         for(_loc2_ in clothes)
         {
            add_clothing(clothes[_loc2_]);
         }
         dispatchEvent(new Event("updated"));
      }
      
      public function get body_height() : uint
      {
         return _body_height;
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
            if(clothes.indexOf(param1) != -1)
            {
               return;
            }
            clothes.push(param1);
         }
         if(_simple)
         {
            simple_add(body,"simple_body",[param1]);
            simple_add(arms,"simple_arms",[param1]);
         }
         else
         {
            type_add(body,"body",[param1]);
            type_add(arms,"arms",[param1]);
         }
         simple_add(body,"breasts",[param1]);
         simple_add(body,"necklace",[param1]);
         if(param1 == "glove1")
         {
            _loc7_ = arms["hand_L"].getChildAt(0);
            _loc8_ = arms["hand_R"].getChildAt(0);
            _loc7_.base_colour = "494545";
            _loc8_.base_colour = "494545";
            if(cld.get_colour("494545") == -1)
            {
               cld.set_colour("494545",4801861);
            }
            cld.colour_clip(MovieClip(_loc7_));
            cld.colour_clip(MovieClip(_loc8_));
         }
         update_pants_state();
         update_shoulder_state();
         if(param2 == false)
         {
            set_rotation(body_rotation);
            update_colours();
            redo();
         }
      }
      
      public function save_state() : Object
      {
         var _loc1_:Object = {
            "gesture":_gesture,
            "stance":_stance,
            "pose":_pose,
            "body_rotation":body_rotation,
            "head_angle":head_angle,
            "hands":_hands,
            "standing":standing,
            "action":action,
            "sitting":sitting
         };
         _loc1_["head"] = _head.save_state();
         return _loc1_;
      }
      
      private function update_shoulder_state() : void
      {
         var _loc2_:* = null;
         var _loc1_:Array = ["suit1"];
         for(_loc2_ in clothes)
         {
            if(_loc1_.indexOf(clothes[_loc2_]) != -1)
            {
               jacket = true;
               arms["shoulder_L"].visible = false;
               arms["shoulder_R"].visible = false;
               return;
            }
         }
         jacket = false;
         arms["shoulder_R"].visible = arms["shoulder_L"].visible = true;
      }
      
      public function get sex() : uint
      {
         return _sex;
      }
      
      public function set body_type(param1:uint) : void
      {
         this.set_body_type(param1);
      }
      
      public function set_gesture(param1:uint) : uint
      {
         if(_simple)
         {
            _gesture = 0;
         }
         this._gesture = param1;
         set_hand(0,hand_frames[brot][0][_gesture]);
         set_hand(1,hand_frames[brot][1][_gesture]);
         redo();
         return _gesture;
      }
      
      public function toggle_control() : Boolean
      {
         return false;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["body_type"] = _body_type;
         _loc1_["body_height"] = _body_height;
         _loc1_["breast_type"] = _breast_type;
         _loc1_["sex"] = sex;
         _loc1_["clothes"] = clothes;
         return _loc1_;
      }
      
      public function set_pose(param1:uint) : uint
      {
         if(_simple)
         {
            param1 = 0;
         }
         this._pose = Math.min(9,Math.max(0,param1));
         redo();
         return _stance;
      }
      
      public function set_standing() : void
      {
         action = false;
         sitting = false;
         standing = true;
         update_body_visibility();
         redo();
      }
      
      private function setup_edit(param1:Object) : void
      {
         param1.addEventListener(MouseEvent.CLICK,piece_click);
         param1.addEventListener(MouseEvent.ROLL_OVER,cloth_over);
         param1.addEventListener(MouseEvent.ROLL_OUT,cloth_out);
         param1.buttonMode = true;
      }
      
      public function simple_add(param1:Object, param2:String, param3:Array) : void
      {
         var _loc5_:* = null;
         var _loc6_:Object = null;
         if(clothing_debug)
         {
            trace("Adding clothing: " + param2 + " - " + param3);
         }
         var _loc4_:Array = art_loader.sorted_index2(param2,param3);
         if(clothing_debug)
         {
            trace("\tArt list: " + _loc4_);
         }
         for(_loc5_ in _loc4_)
         {
            _loc6_ = art_loader.get_art(param2,_loc4_[_loc5_]);
            if(_loc6_.type == "")
            {
               _loc6_.type = param2;
            }
            if(!_loc6_.base_colour)
            {
               _loc6_.set_new_frame_func(cld.colour_clip);
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
            if(clothing_debug)
            {
               trace("\t" + _loc4_[_loc5_] + " - " + _loc6_.body_part);
            }
            param1[_loc6_.body_part].addChild(_loc6_);
            adjust_part_order(param1[_loc6_.body_part]);
            if(edit_mode)
            {
               setup_edit(_loc6_);
            }
            pieces.push(_loc6_);
         }
      }
      
      public function set_height(param1:uint) : uint
      {
         _body_height = param1;
         bt_change();
         redo();
         dispatchEvent(new Event("body_update"));
         return param1;
      }
      
      public function set just_head(param1:Boolean) : void
      {
         var _loc2_:* = null;
         just_head_visible = param1;
         if(just_head_visible == false)
         {
            for(_loc2_ in arms)
            {
               arms[_loc2_].visible = true;
            }
            for(_loc2_ in body)
            {
               body[_loc2_].visible = true;
            }
         }
         update_levels();
      }
      
      public function get gesture_num() : uint
      {
         return _gesture;
      }
      
      private function cloth_out(param1:MouseEvent) : void
      {
         var _loc2_:Object = param1.currentTarget;
         var _loc3_:String = art_split(_loc2_.name)["type"];
         clothing_over = "";
         if(clothing_out == _loc3_)
         {
            return;
         }
         clothing_out = _loc3_;
         if(_loc2_.name == "hand_art1")
         {
            clothing_out = "glove1";
         }
         this.dispatchEvent(new Event("clothing_out"));
      }
      
      public function update_colours() : void
      {
         var _loc1_:* = null;
         if(debug)
         {
            trace("UPDATE COLOURS ---------------------------------------------------- " + this.name + " " + this);
         }
         for(_loc1_ in pieces)
         {
            cld.colour_clip(pieces[_loc1_]);
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
      
      public function set_action() : void
      {
         action = sitting = standing = false;
         action = true;
         update_body_visibility();
         redo();
      }
      
      private function stance_frame() : uint
      {
         if(_simple)
         {
            return 1 + brot2 + body_height * rotation_count + body_type * h_count * rotation_count;
         }
         if(sitting)
         {
            return 1 + brot2 * 10;
         }
         return 1 + _stance + brot2 * 10;
      }
      
      public function get is_sitting() : Boolean
      {
         return sitting;
      }
      
      public function get simple() : Boolean
      {
         return _simple;
      }
      
      public function set_rotation(param1:uint) : uint
      {
         var _loc3_:* = null;
         var _loc2_:Number = 1;
         param1 = Math.min(7,Math.max(0,param1));
         body_rotation = param1;
         if(body_rotation <= 7 && body_rotation >= 5)
         {
            if(flipped == false)
            {
               if(_stance % 3 == 0)
               {
                  _stance = _stance + 2;
               }
               else if(_stance % 3 == 2)
               {
                  _stance = _stance - 2;
               }
            }
            flipped = true;
            _loc2_ = -1;
         }
         else
         {
            if(flipped)
            {
               if(_stance % 3 == 2)
               {
                  _stance = _stance - 2;
               }
               else if(_stance % 3 == 0)
               {
                  _stance = _stance + 2;
               }
            }
            flipped = false;
         }
         if(body_rotation >= 3 && body_rotation <= 5)
         {
            arms["hand_L"].getChildAt(0).scaleX = -1;
            arms["hand_R"].getChildAt(0).scaleX = 1;
         }
         else
         {
            arms["hand_L"].getChildAt(0).scaleX = 1;
            arms["hand_R"].getChildAt(0).scaleX = -1;
         }
         if(body_rotation == 7 || body_rotation == 5 || body_rotation == 3 || body_rotation == 1)
         {
            brot = 1;
         }
         else if(body_rotation == 6 || body_rotation == 2)
         {
            brot = 2;
         }
         else
         {
            brot = 0;
         }
         if(body_rotation <= 4)
         {
            brot2 = body_rotation;
         }
         else if(body_rotation == 5)
         {
            brot2 = 3;
         }
         else if(body_rotation == 6)
         {
            brot2 = 2;
         }
         else if(body_rotation == 7)
         {
            brot2 = 1;
         }
         for(_loc3_ in arms)
         {
            if(!(_loc3_ == "head" || _loc3_ == "hback"))
            {
               arms[_loc3_].scaleX = _loc2_;
            }
         }
         update_body_visibility();
         set_gesture(_gesture);
         dispatchEvent(new Event("body_update"));
         return body_rotation;
      }
      
      public function set_stance(param1:uint) : uint
      {
         if(_simple)
         {
            _stance = 0;
         }
         this._stance = Math.min(8,Math.max(0,param1));
         redo();
         return _stance;
      }
      
      private function update_levels() : void
      {
         var _loc1_:Object = null;
         var _loc3_:* = null;
         var _loc4_:Object = null;
         var _loc5_:* = null;
         if(just_head_visible)
         {
            for(_loc5_ in arms)
            {
               arms[_loc5_].visible = false;
            }
            for(_loc5_ in body)
            {
               body[_loc5_].visible = false;
            }
            arms["head"].visible = arms["hback"].visible = true;
            return;
         }
         if(sitting)
         {
            _loc1_ = sitting_levels[brot2];
         }
         else if(standing)
         {
            _loc1_ = standing_levels[brot2];
         }
         else
         {
            _loc1_ = action_levels[brot2][_pose];
         }
         body["shirtskirt"].visible = !pants;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            body_clip.setChildIndex(body[_loc1_[_loc2_]],_loc2_);
            _loc2_ = _loc2_ + 1;
         }
         for(_loc3_ in arms)
         {
            arms[_loc3_].visible = false;
         }
         if(action)
         {
            _loc4_ = acg_levels[brot2][_pose];
         }
         else if(_gesture <= 9)
         {
            _loc4_ = g1_levels[brot2][_gesture];
         }
         else
         {
            _loc4_ = g2_levels[brot2][_gesture - 10];
         }
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            arms[_loc4_[_loc2_]].visible = true;
            setChildIndex(arms[_loc4_[_loc2_]],_loc2_);
            _loc2_ = _loc2_ + 1;
         }
         arms["shoulder_L"].visible = arms["shoulder_R"].visible = !jacket;
         if(_head)
         {
            _head.get_piece("hair_back").visible = false;
            if(_head.h_rot >= 3 && _head.h_rot <= 5 && (body_rotation <= 2 || body_rotation >= 6))
            {
               swapChildren(arms["head"],arms["hback"]);
            }
            if(body_rotation >= 3 && body_rotation <= 5 && (_head.h_rot >= 6 || _head.h_rot <= 2))
            {
               swapChildren(arms["head"],arms["hback"]);
            }
         }
      }
      
      public function get body_type() : uint
      {
         return _body_type;
      }
      
      public function set_head_angle(param1:Number) : Number
      {
         head_angle = param1;
         position_head();
         return param1;
      }
      
      public function get is_standing() : Boolean
      {
         return standing;
      }
      
      public function get master_rotation() : uint
      {
         return body_rotation;
      }
      
      public function stance_left() : void
      {
         if(flipped)
         {
            if(_stance % 3 != 2)
            {
               set_stance(_stance + 1);
            }
         }
         else if(_stance % 3 != 0)
         {
            set_stance(_stance - 1);
         }
      }
      
      public function load_all() : void
      {
         var _loc3_:* = null;
         var _loc4_:int = 0;
         if(debug)
         {
            trace("LOAD ALL....");
         }
         var _loc1_:* = _body_type + "_" + _body_height + ".swf";
         var _loc2_:Array = [remote.assurl("body_art/split/base/base_" + _loc1_)];
         for(_loc3_ in clothes)
         {
            if(clothes[_loc3_] != "pearls" && clothes[_loc3_] != "naked" && clothes[_loc3_])
            {
               _loc2_.push(remote.assurl("body_art/split/" + clothes[_loc3_] + "/" + clothes[_loc3_] + "_" + _loc1_));
            }
         }
         _loc4_ = art_loader.load_swfs(_loc2_,art_loaded);
         if(debug)
         {
            trace("Load ID: " + _loc4_);
         }
      }
      
      public function set body_height(param1:uint) : void
      {
         this.set_height(param1);
      }
      
      public function set sex(param1:uint) : void
      {
         _sex = param1;
      }
      
      public function set breast_type(param1:uint) : void
      {
         this.set_breast(param1);
      }
      
      private function cloth_over(param1:MouseEvent) : void
      {
         var _loc2_:Object = param1.currentTarget;
         var _loc3_:String = art_split(_loc2_.name)["type"];
         clothing_out = "";
         if(clothing_over == _loc3_)
         {
            return;
         }
         clothing_over = _loc3_;
         if(_loc2_.name == "hand_art1")
         {
            clothing_over = "glove1";
         }
         this.dispatchEvent(new Event("clothing_over"));
      }
      
      public function set_breast(param1:uint) : uint
      {
         _breast_type = param1;
         redo();
         dispatchEvent(new Event("body_update"));
         return param1;
      }
      
      public function remove_clothing(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc6_:* = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc5_:int = clothes.indexOf(param1);
         if(_loc5_ == -1)
         {
            trace("They\'re not wearing that! " + param1);
            clothes.splice(_loc5_,1);
         }
         for(_loc6_ in body)
         {
            _loc2_ = new Array();
            _loc3_ = 0;
            while(_loc3_ < body[_loc6_].numChildren)
            {
               _loc2_.push(body[_loc6_].getChildAt(_loc3_));
               _loc3_ = _loc3_ + 1;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = art_split(_loc2_[_loc3_].name)["type"];
               if(param1 == _loc4_)
               {
                  body[_loc6_].removeChild(_loc2_[_loc3_]);
               }
               _loc3_ = _loc3_ + 1;
            }
         }
         for(_loc6_ in arms)
         {
            if(!(_loc6_ == "hand_L" || _loc6_ == "hand_R"))
            {
               _loc2_ = new Array();
               _loc3_ = 0;
               while(_loc3_ < arms[_loc6_].numChildren)
               {
                  _loc2_.push(arms[_loc6_].getChildAt(_loc3_));
                  _loc3_ = _loc3_ + 1;
               }
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc4_ = art_split(_loc2_[_loc3_].name)["type"];
                  if(param1 == _loc4_)
                  {
                     arms[_loc6_].removeChild(_loc2_[_loc3_]);
                  }
                  _loc3_ = _loc3_ + 1;
               }
            }
         }
         if(param1 == "glove1")
         {
            _loc7_ = arms["hand_L"].getChildAt(0);
            _loc8_ = arms["hand_R"].getChildAt(0);
            _loc7_.base_colour = "ffcc99";
            _loc8_.base_colour = "ffcc99";
            if(cld.get_colour("ffcc99") == -1)
            {
               cld.set_colour("ffcc99",16764057);
            }
            cld.colour_clip(MovieClip(_loc7_));
            cld.colour_clip(MovieClip(_loc8_));
         }
         update_shoulder_state();
         update_pants_state();
      }
      
      public function get head() : Head
      {
         return _head;
      }
      
      public function get breast_type() : uint
      {
         return _breast_type;
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
         if(sitting || standing)
         {
            _loc8_ = position_data("L");
            _loc9_ = position_data("R");
            _loc1_ = _loc8_.x;
            _loc2_ = _loc8_.y;
            _loc4_ = _loc9_.x;
            _loc5_ = _loc9_.y;
            _loc3_ = _loc8_.rot + 63 + 180;
            _loc6_ = _loc9_.rot - 63;
         }
         else if(action)
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
         for(_loc7_ in arms)
         {
            if(!(_loc7_ == "head" || _loc7_ == "hback" || _loc7_ == "BODY"))
            {
               _loc10_ = _loc7_.substr(_loc7_.length - 1);
               if(_loc10_ == "L")
               {
                  arms[_loc7_].x = _loc1_;
                  arms[_loc7_].y = _loc2_;
                  arms[_loc7_].rotation = _loc3_;
               }
               else if(_loc10_ == "R")
               {
                  arms[_loc7_].x = _loc4_;
                  arms[_loc7_].y = _loc5_;
                  arms[_loc7_].rotation = _loc6_;
               }
               if(flipped)
               {
                  arms[_loc7_].x = arms[_loc7_].x * -1;
                  arms[_loc7_].rotation = arms[_loc7_].rotation * -1;
               }
            }
         }
      }
      
      public function set_sitting() : void
      {
         action = sitting = standing = false;
         sitting = true;
         update_body_visibility();
         redo();
      }
      
      public function get is_action() : Boolean
      {
         return action;
      }
      
      public function get hands() : Array
      {
         return [_hands[0],_hands[1]];
      }
      
      private function piece_click(param1:MouseEvent) : void
      {
         var _loc2_:Object = param1.currentTarget;
         var _loc3_:String = art_split(_loc2_.name)["type"];
         if(_loc2_.base_colour)
         {
            if(colour_click_call != null)
            {
               colour_click_call([_loc2_.base_colour]);
            }
         }
         else if(colour_click_call != null)
         {
            colour_click_call(ColourData.get_colours(MovieClip(_loc2_)));
         }
         clothing_out = clothing_over = "";
         if(clothing_selected == _loc3_)
         {
            return;
         }
         clothing_selected = _loc3_;
         if(_loc2_.name == "hand_art1")
         {
            clothing_selected = "glove1";
         }
         this.dispatchEvent(new Event("clothing_click"));
      }
      
      private function update_pants_state() : void
      {
         var _loc2_:* = null;
         var _loc1_:Array = ["shorts1","shorts2","pants1","pants2"];
         for(_loc2_ in clothes)
         {
            if(_loc1_.indexOf(clothes[_loc2_]) != -1)
            {
               pants = true;
               body["shirtskirt"].visible = false;
               return;
            }
         }
         pants = false;
         body["shirtskirt"].visible = true;
      }
      
      private function gesture_frame() : uint
      {
         if(_simple)
         {
            return stance_frame();
         }
         var _loc1_:uint = 1 + _gesture + brot2 * 10;
         if(_gesture >= 10)
         {
            _loc1_ = _loc1_ - 10;
         }
         return _loc1_;
      }
      
      public function load_state(param1:Object) : void
      {
         if(debug)
         {
            trace("--Body.load_state(" + param1["gesture"] + ")--");
         }
         action = param1["action"];
         sitting = param1["sitting"];
         standing = param1["standing"];
         _gesture = param1["gesture"];
         _stance = param1["stance"];
         _pose = param1["pose"];
         body_rotation = param1["body_rotation"];
         head_angle = param1["head_angle"];
         _head.load_state(param1["head"]);
         set_rotation(body_rotation);
         _hands = [param1["hands"][0],param1["hands"][1]];
         set_hand(0,_hands[0]);
         set_hand(1,_hands[1]);
         redo();
      }
   }
}
