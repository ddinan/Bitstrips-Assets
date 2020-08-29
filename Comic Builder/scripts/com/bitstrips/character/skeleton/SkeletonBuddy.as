package com.bitstrips.character.skeleton
{
   import com.bitstrips.character.Features;
   import com.bitstrips.character.HeadBase;
   import com.bitstrips.character.skeleton.data.LengthDataBuddy;
   import com.bitstrips.character.skeleton.data.PointDataBuddy;
   import com.bitstrips.core.ArtLoader;
   
   public class SkeletonBuddy extends SkeletonBiped
   {
       
      
      public function SkeletonBuddy(param1:HeadBase, param2:ArtLoader, param3:Object = undefined, param4:Boolean = true)
      {
         super(param1,param2,param3,param4);
         _point_data_source = PointDataBuddy;
         _length_data_source = LengthDataBuddy;
         species = "buddy";
      }
      
      override public function get features() : Array
      {
         return [Features.BODY_ROTATION,Features.HEAD_TILT,Features.STANCE,Features.POSE_TYPE,Features.POSE_LIBRARY,Features.HAND_POSES,Features.BODY_TYPE,Features.HEIGHT,Features.BREAST_TYPE,Features.POSE_MANAGEMENT,Features.STACKING,Features.CLOTHING,Features.FLOAT,Features.BEND_ADJUSTMENT];
      }
   }
}
