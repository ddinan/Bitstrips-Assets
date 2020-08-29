package com.bitstrips.character.skeleton
{
   import com.bitstrips.Utils;
   import com.bitstrips.character.CharLoader;
   import com.bitstrips.character.HeadBase;
   import com.bitstrips.character.IBody;
   import com.bitstrips.character.skeleton.data.LengthData;
   import com.bitstrips.character.skeleton.data.PointData;
   import com.bitstrips.core.ArtLoader;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class SkeletonBiped extends Skeleton implements IBody
   {
      
      public static const pose_defaults:Object = {
         "skin_stack":[["head_back","accback","bicepR","foreR","bicepL","foreL","legR","legL","torso","skirt","skirt_legR","skirt_legL","skirt_pelvis","shirt","breasts","shirtfront","breasts_top","accfront","control_zone","head"],["head_back","accback","bicepR","foreR","legR","torso","legL","skirt","skirt_legR","skirt_legL","skirt_pelvis","shirt","breasts","shirtfront","breasts_top","accfront","control_zone","bicepL","foreL","head"],["head_back","accback","bicepR","foreR","legR","torso","legL","skirt","skirt_legR","skirt_legL","skirt_pelvis","shirt","breasts","shirtfront","breasts_top","accfront","control_zone","bicepL","foreL","head"],["head","bicepL","foreL","legL","legR","accfront","breasts","breasts_top","torso","skirt","skirt_legL","skirt_legR","skirt_pelvis","shirt","shirtfront","control_zone","bicepR","foreR","accback","head_back"],["head","accfront","bicepR","foreR","bicepL","foreL","legL","legR","breasts","breasts_top","torso","skirt","skirt_legL","skirt_legR","skirt_pelvis","shirt","shirtfront","accback","control_zone","head_back"]],
         "_default_skin_stack":[["head_back","accback","bicepR","foreR","bicepL","foreL","legR","legL","torso","skirt","skirt_legR","skirt_legL","skirt_pelvis","shirt","breasts","shirtfront","breasts_top","accfront","control_zone","head"],["head_back","accback","bicepR","foreR","legR","torso","legL","skirt","skirt_legR","skirt_legL","skirt_pelvis","shirt","breasts","shirtfront","breasts_top","accfront","control_zone","bicepL","foreL","head"],["head_back","accback","bicepR","foreR","legR","torso","legL","skirt","skirt_legR","skirt_legL","skirt_pelvis","shirt","breasts","shirtfront","breasts_top","accfront","control_zone","bicepL","foreL","head"],["head","bicepL","foreL","legL","legR","accfront","breasts","breasts_top","torso","skirt","skirt_legL","skirt_legR","skirt_pelvis","shirt","shirtfront","control_zone","bicepR","foreR","accback","head_back"],["head","accfront","bicepR","foreR","bicepL","foreL","legL","legR","breasts","breasts_top","torso","skirt","skirt_legL","skirt_legR","skirt_pelvis","shirt","shirtfront","accback","control_zone","head_back"]],
         "_simple_stack_bottom":[{
            "bicepR":"accback",
            "foreR":"bicepR",
            "bicepL":"accback",
            "foreL":"bicepL",
            "legR":"accback",
            "legL":"accback"
         },{
            "bicepR":"accback",
            "foreR":"bicepR",
            "bicepL":"control_zone",
            "foreL":"bicepL",
            "legR":"accback",
            "legL":"torso"
         },{
            "bicepR":"accback",
            "foreR":"bicepR",
            "bicepL":"control_zone",
            "foreL":"bicepL",
            "legR":"control_zone",
            "legL":"torso"
         },{
            "bicepR":"head",
            "foreR":"bicepR",
            "bicepL":"head",
            "foreL":"bicepL",
            "legR":"bottom",
            "legL":"control_zone"
         },{
            "bicepR":"accfront",
            "foreR":"bicepR",
            "bicepL":"accfront",
            "foreL":"bicepL",
            "legR":"accfront",
            "legL":"accfront"
         }],
         "_simple_stack_top":[{
            "bicepR":"top",
            "foreR":"top",
            "bicepL":"top",
            "foreL":"top",
            "legR":"top",
            "legL":"top"
         },{
            "bicepR":"torso",
            "foreR":"top",
            "bicepL":"top",
            "foreL":"top",
            "legR":"torso",
            "legL":"top"
         },{
            "bicepR":"torso",
            "foreR":"top",
            "bicepL":"top",
            "foreL":"top",
            "legR":"torso",
            "legL":"top"
         },{
            "bicepR":"top",
            "foreR":"top",
            "bicepL":"top",
            "foreL":"top",
            "legR":"head",
            "legL":"head"
         },{
            "bicepR":"top",
            "foreR":"top",
            "bicepL":"top",
            "foreL":"top",
            "legR":"breasts",
            "legL":"breasts"
         }],
         "hand_rotate":[[1,1],[0,2],[0,2],[2,0],[3,3]],
         "hand_flip":[[false,false],[true,false],[true,false],[false,true],[true,true]],
         "hand_pose":[1,1]
      };
       
      
      private var arms:Array;
      
      private var legs:Array;
      
      private var _hands:Array;
      
      public const head_adjustment:Number = -30;
      
      private var skirt_mask:Sprite;
      
      private var skirt_mask_test:Sprite;
      
      public var clothing_selected:String;
      
      public var clothing_out:String;
      
      public var clothing_over:String;
      
      private var _mode:uint = 0;
      
      private var _gesture:uint = 0;
      
      private var _action:uint = 0;
      
      private var _stance:uint = 1;
      
      public function SkeletonBiped(param1:HeadBase, param2:ArtLoader, param3:Object = undefined, param4:Boolean = true)
      {
         this._hands = new Array(2);
         this.skirt_mask = new Sprite();
         this.skirt_mask_test = new Sprite();
         super(param1,param2,param3,param4);
         _point_data_source = PointData;
         _length_data_source = LengthData;
         _head = param1;
         this.addEventListener(SkeletonEvent.LEG_FLIP,this.flip_leg,false,0,true);
         species = "biped";
      }
      
      override public function init() : void
      {
         var _loc2_:Object = null;
         var _loc8_:String = null;
         super.init();
         _pose = new Pose(null,SkeletonBiped.pose_defaults);
         this.arms = new Array();
         this.legs = new Array();
         var _loc1_:Object = {
            "name":"spine",
            "starting_rot":-90,
            "pos_name":"spine_base",
            "bones":new Array()
         };
         add_bone(_loc1_,new Bone("spine_1","spine_1","spine"),null);
         add_bone(_loc1_,new Bone("spine_2","spine_2","spine"),get_bone("spine_1"));
         _loc2_ = {
            "name":"neck",
            "starting_rot":-90,
            "pos_name":"neck",
            "bones":new Array()
         };
         add_bone(_loc2_,new Bone("neck","neck","neck",[-28,28]),null);
         add_bone(_loc2_,new Bone("head","head","neck",[-60,60]),get_bone("neck"));
         var _loc3_:Object = {
            "name":"arm",
            "starting_rot":90,
            "pos_name":"shoulder_R",
            "bones":new Array()
         };
         add_bone(_loc3_,new Bone("bicepR","bicep","armR"),null);
         add_bone(_loc3_,new Bone("foreR","fore","armR"),get_bone("bicepR"));
         add_bone(_loc3_,new Bone("handR","hand","armR"),get_bone("foreR"));
         this.arms.push(_loc3_);
         var _loc4_:Object = {
            "name":"arm",
            "starting_rot":90,
            "pos_name":"shoulder_L",
            "bones":new Array()
         };
         add_bone(_loc4_,new Bone("bicepL","bicep","armL"),null);
         add_bone(_loc4_,new Bone("foreL","fore","armL"),get_bone("bicepL"));
         add_bone(_loc4_,new Bone("handL","hand","armL"),get_bone("foreL"));
         this.arms.push(_loc4_);
         var _loc5_:Object = {
            "name":"leg",
            "starting_rot":90,
            "pos_name":"hip_R",
            "bones":new Array()
         };
         add_bone(_loc5_,new Bone("thighR","thigh","legR"),null);
         add_bone(_loc5_,new Bone("shinR","shin","legR",[0,137]),get_bone("thighR"));
         add_bone(_loc5_,new Bone("footR","foot","legR",[-30,30]),get_bone("shinR"));
         add_bone(_loc5_,new Bone("toeR","foot","legR"),get_bone("footR"));
         this.legs.push(_loc5_);
         var _loc6_:Object = {
            "name":"leg",
            "starting_rot":90,
            "pos_name":"hip_L",
            "bones":new Array()
         };
         add_bone(_loc6_,new Bone("thighL","thigh","legL"),null);
         add_bone(_loc6_,new Bone("shinL","shin","legL",[-137,0]),get_bone("thighL"));
         add_bone(_loc6_,new Bone("footL","foot","legL",[-30,30]),get_bone("shinL"));
         add_bone(_loc6_,new Bone("toeL","foot","legL"),get_bone("footL"));
         this.legs.push(_loc6_);
         bone_structures = [_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_];
         structure_lookup = {
            "spine":_loc1_,
            "neck":_loc2_,
            "armR":_loc3_,
            "armL":_loc4_,
            "legR":_loc5_,
            "legL":_loc6_
         };
         get_bone("thighR").addEventListener(SkeletonEvent.BONE_POS_CHANGE,this.manage_skirt_handler,false,0,true);
         get_bone("thighL").addEventListener(SkeletonEvent.BONE_POS_CHANGE,this.manage_skirt_handler,false,0,true);
         get_bone("shinR").addEventListener(SkeletonEvent.BONE_POS_CHANGE,this.manage_skirt_handler,false,0,true);
         get_bone("shinL").addEventListener(SkeletonEvent.BONE_POS_CHANGE,this.manage_skirt_handler,false,0,true);
         get_bone("spine_1").addEventListener(SkeletonEvent.BONE_POS_CHANGE,this.manage_skirt_handler,false,0,true);
         _head.mouseChildren = false;
         this._hands[0] = art_loader.get_art("new_body","hand_bare");
         this._hands[1] = art_loader.get_art("new_body","hand_bare");
         var _loc7_:Object = {
            "shoulderA":[[340,32,62,100,340],[340,45,62,93,340],[340,46,83,100,340],[340,38,67,97,340],[340,30,62,100,340],[340,40,74,100,340],[347,45,84,106,347],[340,30,62,100,340],[350,49,77,95,350],[340,30,62,91,340],[346,46,76,94,346]],
            "shoulderB":[[100,158,193,218],[93,151,180,222],[100,158,195,222],[97,151,183,212],[100,158,195,222],[100,158,195,222],[106,141,204,240],[100,158,195,222],[95,151,182,212],[92,149,180,209],[93,153,183,212]],
            "hipA":[[330,48,105],[330,48,105],[330,48,105],[330,71,118],[330,64,105],[338,48,119],[347,48,123],[354,58,111],[345,56,105],[354,48,105],[350,48,105]],
            "hipB":[[300,20,257],[300,20,250],[300,20,234],[313,45,272],[309,32,264],[312,20,263],[316,20,257],[323,20,271],[315,27,269],[324,20,273],[321,20,271]]
         };
         _skin.add_skin_piece({
            "name":"control_zone",
            "type":"control_zone",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_1",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"control_zone"
         });
         _skin.add_skin_piece({
            "name":"pelvis",
            "type":"pelvis",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_1",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"torso"
         });
         _skin.add_skin_piece({
            "name":"pelvis_patch",
            "type":"pelvis_patch",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"thighR",
            "control_bone":"spine_1",
            "side":"center",
            "angles":[315,45,180],
            "stack_group":"torso"
         });
         _skin.add_skin_piece({
            "name":"tucked",
            "type":"tucked",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_2",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"shirt"
         });
         _skin.add_skin_piece({
            "name":"untucked",
            "type":"untucked",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_2",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"shirt"
         });
         _skin.add_skin_piece({
            "name":"torso_nude",
            "type":"torso_nude",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_2",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"torso"
         });
         _skin.add_skin_piece({
            "name":"torso_top",
            "type":"torso_top",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_2",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"shirt"
         });
         _skin.add_skin_piece({
            "name":"accfront",
            "type":"accfront",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_2",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"torso"
         });
         _skin.add_skin_piece({
            "name":"accback",
            "type":"accback",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_2",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"torso"
         });
         _skin.add_skin_piece({
            "name":"breasts",
            "type":"breasts",
            "clip":new Sprite(),
            "pos_bone":"spine_2",
            "rot_bone":"spine_2",
            "bend_bone":"spine_2",
            "control_bone":"spine_2",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"breasts"
         });
         _skin.add_skin_piece({
            "name":"breasts_top",
            "type":"breasts_top",
            "clip":new Sprite(),
            "pos_bone":"spine_2",
            "rot_bone":"spine_2",
            "bend_bone":"spine_2",
            "control_bone":"spine_2",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"breasts"
         });
         _skin.add_skin_piece({
            "name":"shirtfront",
            "type":"shirtfront",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_2",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"shirtfront"
         });
         _skin.add_skin_piece({
            "name":"neck",
            "type":"neck",
            "clip":new Sprite(),
            "pos_bone":"neck",
            "rot_bone":"neck",
            "bend_bone":"neck",
            "control_bone":"neck",
            "side":"center",
            "angles":[350,10,180],
            "stack_group":"shirtfront"
         });
         _skin.add_skin_piece({
            "name":"head",
            "type":"head",
            "clip":new Sprite(),
            "pos_bone":"head",
            "rot_bone":"head",
            "bend_bone":"head",
            "control_bone":"head",
            "side":"center",
            "angles":[300,60,180],
            "stack_group":"head"
         });
         _skin.add_skin_piece({
            "name":"head_back",
            "type":"head_back",
            "clip":new Sprite(),
            "pos_bone":"head",
            "rot_bone":"head",
            "bend_bone":"head",
            "control_bone":"head",
            "side":"center",
            "angles":[300,60,180],
            "stack_group":"head_back"
         });
         _skin.add_skin_piece({
            "name":"skirt_pelvis",
            "type":"skirt_pelvis",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_1",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"skirt_pelvis"
         });
         _skin.add_skin_piece({
            "name":"skirt_base",
            "type":"skirt_base",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_1",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"skirt"
         });
         _skin.add_skin_piece({
            "name":"bicepL",
            "type":"bicep",
            "clip":new Sprite(),
            "pos_bone":"bicepL",
            "rot_bone":"bicepL",
            "bend_bone":"foreL",
            "control_bone":"bicepL",
            "side":"left",
            "angles":[315,45,180],
            "stack_group":"bicepL"
         });
         _skin.add_skin_piece({
            "name":"shoulderAL",
            "type":"shoulderA",
            "clip":new Sprite(),
            "pos_bone":"bicepL",
            "rot_bone":"bicepL",
            "bend_bone":"bicepL",
            "control_bone":"bicepL",
            "side":"left",
            "angles":_loc7_.shoulderA,
            "stack_group":"bicepL"
         });
         _skin.add_skin_piece({
            "name":"shoulderBL",
            "type":"shoulderB",
            "clip":new Sprite(),
            "pos_bone":"bicepL",
            "rot_bone":"bicepL",
            "bend_bone":"bicepL",
            "control_bone":"bicepL",
            "side":"left",
            "angles":_loc7_.shoulderB,
            "stack_group":"bicepL"
         });
         _skin.add_skin_piece({
            "name":"foreL",
            "type":"fore",
            "clip":new Sprite(),
            "pos_bone":"foreL",
            "rot_bone":"foreL",
            "bend_bone":"foreL",
            "control_bone":"foreL",
            "side":"left",
            "angles":[315,45,180],
            "stack_group":"foreL"
         });
         _skin.add_skin_piece({
            "name":"cuffL",
            "type":"cuff",
            "clip":new Sprite(),
            "pos_bone":"foreL",
            "rot_bone":"foreL",
            "bend_bone":"foreL",
            "control_bone":"foreL",
            "side":"left",
            "angles":[300,60,180],
            "stack_group":"foreL"
         });
         _skin.add_skin_piece({
            "name":"cuff_topL",
            "type":"cuff_top",
            "clip":new Sprite(),
            "pos_bone":"foreL",
            "rot_bone":"foreL",
            "bend_bone":"foreL",
            "control_bone":"foreL",
            "side":"left",
            "angles":[300,60,180],
            "stack_group":"foreL"
         });
         _skin.add_skin_piece({
            "name":"handL",
            "type":"hand",
            "clip":new Sprite(),
            "pos_bone":"handL",
            "rot_bone":"handL",
            "bend_bone":"handL",
            "control_bone":"handL",
            "side":"left",
            "angles":[0,0,0],
            "stack_group":"foreL"
         });
         _skin.add_skin_piece({
            "name":"hand_topL",
            "type":"hand_top",
            "clip":new Sprite(),
            "pos_bone":"handL",
            "rot_bone":"handL",
            "bend_bone":"handL",
            "control_bone":"handL",
            "side":"left",
            "angles":[0,0,0],
            "stack_group":"foreL"
         });
         _skin.add_skin_piece({
            "name":"thighL",
            "type":"thigh",
            "clip":new Sprite(),
            "pos_bone":"thighL",
            "rot_bone":"thighL",
            "bend_bone":"shinL",
            "control_bone":"thighL",
            "side":"left",
            "angles":[315,45,180],
            "stack_group":"legL"
         });
         _skin.add_skin_piece({
            "name":"hipAL",
            "type":"hipA",
            "clip":new Sprite(),
            "pos_bone":"thighL",
            "rot_bone":"thighL",
            "bend_bone":"thighL",
            "control_bone":"thighL",
            "side":"left",
            "angles":_loc7_.hipA,
            "stack_group":"legL"
         });
         _skin.add_skin_piece({
            "name":"hipBL",
            "type":"hipB",
            "clip":new Sprite(),
            "pos_bone":"thighL",
            "rot_bone":"thighL",
            "bend_bone":"thighL",
            "control_bone":"thighL",
            "side":"left",
            "angles":_loc7_.hipB,
            "stack_group":"legL"
         });
         _skin.add_skin_piece({
            "name":"shinL",
            "type":"shin",
            "clip":new Sprite(),
            "pos_bone":"shinL",
            "rot_bone":"shinL",
            "bend_bone":"shinL",
            "control_bone":"shinL",
            "side":"left",
            "angles":[315,45,180],
            "stack_group":"legL"
         });
         _skin.add_skin_piece({
            "name":"shin_topL",
            "type":"shin_top",
            "clip":new Sprite(),
            "pos_bone":"shinL",
            "rot_bone":"shinL",
            "bend_bone":"shinL",
            "control_bone":"shinL",
            "side":"left",
            "angles":[300,60,180],
            "stack_group":"legL"
         });
         _skin.add_skin_piece({
            "name":"footL",
            "type":"foot",
            "clip":new Sprite(),
            "pos_bone":"footL",
            "rot_bone":"footL",
            "bend_bone":"toeL",
            "control_bone":"footL",
            "side":"left",
            "angles":[290,70,180],
            "stack_group":"legL"
         });
         _skin.add_skin_piece({
            "name":"foot_topL",
            "type":"foot_top",
            "clip":new Sprite(),
            "pos_bone":"footL",
            "rot_bone":"footL",
            "bend_bone":"toeL",
            "control_bone":"footL",
            "side":"left",
            "angles":[290,70,180],
            "stack_group":"legL"
         });
         _skin.add_skin_piece({
            "name":"skirt_thigh_OLL",
            "type":"skirt_thigh_OL",
            "clip":new Sprite(),
            "pos_bone":"thighL",
            "rot_bone":"thighL",
            "bend_bone":"shinL",
            "control_bone":"thighL",
            "side":"left",
            "angles":[315,45,180],
            "stack_group":"skirt_legL"
         });
         _skin.add_skin_piece({
            "name":"skirt_thigh_maskL",
            "type":"skirt_thigh_mask",
            "clip":new Sprite(),
            "pos_bone":"thighL",
            "rot_bone":"thighL",
            "bend_bone":"shinL",
            "control_bone":"thighL",
            "side":"left",
            "angles":[315,45,180],
            "stack_group":"skirt_legL"
         });
         _skin.add_skin_piece({
            "name":"skirt_shin_OLL",
            "type":"skirt_shin_OL",
            "clip":new Sprite(),
            "pos_bone":"shinL",
            "rot_bone":"shinL",
            "bend_bone":"shinL",
            "control_bone":"shinL",
            "side":"left",
            "angles":[315,45,180],
            "stack_group":"skirt_legL"
         });
         _skin.add_skin_piece({
            "name":"skirt_shin_maskL",
            "type":"skirt_shin_mask",
            "clip":new Sprite(),
            "pos_bone":"shinL",
            "rot_bone":"shinL",
            "bend_bone":"shinL",
            "control_bone":"shinL",
            "side":"left",
            "angles":[315,45,180],
            "stack_group":"skirt_legL"
         });
         _skin.add_skin_piece({
            "name":"skirt_mask_AL",
            "type":"skirt_mask",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_1",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"skirt_legL"
         });
         _skin.add_skin_piece({
            "name":"skirt_mask_BL",
            "type":"skirt_mask",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_1",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"skirt_legL"
         });
         _skin.add_skin_piece({
            "name":"bicepR",
            "type":"bicep",
            "clip":new Sprite(),
            "pos_bone":"bicepR",
            "rot_bone":"bicepR",
            "bend_bone":"foreR",
            "control_bone":"bicepR",
            "side":"right",
            "angles":[315,45,180],
            "stack_group":"bicepR"
         });
         _skin.add_skin_piece({
            "name":"shoulderAR",
            "type":"shoulderA",
            "clip":new Sprite(),
            "pos_bone":"bicepR",
            "rot_bone":"bicepR",
            "bend_bone":"bicepR",
            "control_bone":"bicepR",
            "side":"right",
            "angles":_loc7_.shoulderA,
            "stack_group":"bicepR"
         });
         _skin.add_skin_piece({
            "name":"shoulderBR",
            "type":"shoulderB",
            "clip":new Sprite(),
            "pos_bone":"bicepR",
            "rot_bone":"bicepR",
            "bend_bone":"bicepR",
            "control_bone":"bicepR",
            "side":"right",
            "angles":_loc7_.shoulderB,
            "stack_group":"bicepR"
         });
         _skin.add_skin_piece({
            "name":"foreR",
            "type":"fore",
            "clip":new Sprite(),
            "pos_bone":"foreR",
            "rot_bone":"foreR",
            "bend_bone":"foreR",
            "control_bone":"foreR",
            "side":"right",
            "angles":[315,45,180],
            "stack_group":"foreR"
         });
         _skin.add_skin_piece({
            "name":"cuffR",
            "type":"cuff",
            "clip":new Sprite(),
            "pos_bone":"foreR",
            "rot_bone":"foreR",
            "bend_bone":"foreR",
            "control_bone":"foreR",
            "side":"right",
            "angles":[300,60,180],
            "stack_group":"foreR"
         });
         _skin.add_skin_piece({
            "name":"cuff_topR",
            "type":"cuff_top",
            "clip":new Sprite(),
            "pos_bone":"foreR",
            "rot_bone":"foreR",
            "bend_bone":"foreR",
            "control_bone":"foreR",
            "side":"right",
            "angles":[300,60,180],
            "stack_group":"foreR"
         });
         _skin.add_skin_piece({
            "name":"handR",
            "type":"hand",
            "clip":new Sprite(),
            "pos_bone":"handR",
            "rot_bone":"handR",
            "bend_bone":"handR",
            "control_bone":"handR",
            "side":"right",
            "angles":[0,0,0],
            "stack_group":"foreR"
         });
         _skin.add_skin_piece({
            "name":"hand_topR",
            "type":"hand_top",
            "clip":new Sprite(),
            "pos_bone":"handR",
            "rot_bone":"handR",
            "bend_bone":"handR",
            "control_bone":"handR",
            "side":"right",
            "angles":[0,0,0],
            "stack_group":"foreR"
         });
         _skin.add_skin_piece({
            "name":"thighR",
            "type":"thigh",
            "clip":new Sprite(),
            "pos_bone":"thighR",
            "rot_bone":"thighR",
            "bend_bone":"shinR",
            "control_bone":"thighR",
            "side":"right",
            "angles":[315,45,180],
            "stack_group":"legR"
         });
         _skin.add_skin_piece({
            "name":"hipAR",
            "type":"hipA",
            "clip":new Sprite(),
            "pos_bone":"thighR",
            "rot_bone":"thighR",
            "bend_bone":"thighR",
            "control_bone":"thighR",
            "side":"right",
            "angles":_loc7_.hipA,
            "stack_group":"legR"
         });
         _skin.add_skin_piece({
            "name":"hipBR",
            "type":"hipB",
            "clip":new Sprite(),
            "pos_bone":"thighR",
            "rot_bone":"thighR",
            "bend_bone":"thighR",
            "control_bone":"thighR",
            "side":"right",
            "angles":_loc7_.hipB,
            "stack_group":"legR"
         });
         _skin.add_skin_piece({
            "name":"shinR",
            "type":"shin",
            "clip":new Sprite(),
            "pos_bone":"shinR",
            "rot_bone":"shinR",
            "bend_bone":"shinR",
            "control_bone":"shinR",
            "side":"right",
            "angles":[315,45,180],
            "stack_group":"legR"
         });
         _skin.add_skin_piece({
            "name":"shin_topR",
            "type":"shin_top",
            "clip":new Sprite(),
            "pos_bone":"shinR",
            "rot_bone":"shinR",
            "bend_bone":"shinR",
            "control_bone":"shinR",
            "side":"right",
            "angles":[300,60,180],
            "stack_group":"legR"
         });
         _skin.add_skin_piece({
            "name":"footR",
            "type":"foot",
            "clip":new Sprite(),
            "pos_bone":"footR",
            "rot_bone":"footR",
            "bend_bone":"toeR",
            "control_bone":"footR",
            "side":"right",
            "angles":[290,70,180],
            "stack_group":"legR"
         });
         _skin.add_skin_piece({
            "name":"foot_topR",
            "type":"foot_top",
            "clip":new Sprite(),
            "pos_bone":"footR",
            "rot_bone":"footR",
            "bend_bone":"toeR",
            "control_bone":"footR",
            "side":"right",
            "angles":[290,70,180],
            "stack_group":"legR"
         });
         _skin.add_skin_piece({
            "name":"skirt_thigh_OLR",
            "type":"skirt_thigh_OL",
            "clip":new Sprite(),
            "pos_bone":"thighR",
            "rot_bone":"thighR",
            "bend_bone":"shinR",
            "control_bone":"thighR",
            "side":"right",
            "angles":[315,45,180],
            "stack_group":"skirt_legR"
         });
         _skin.add_skin_piece({
            "name":"skirt_thigh_maskR",
            "type":"skirt_thigh_mask",
            "clip":new Sprite(),
            "pos_bone":"thighR",
            "rot_bone":"thighR",
            "bend_bone":"shinR",
            "control_bone":"thighR",
            "side":"right",
            "angles":[315,45,180],
            "stack_group":"skirt_legR"
         });
         _skin.add_skin_piece({
            "name":"skirt_shin_OLR",
            "type":"skirt_shin_OL",
            "clip":new Sprite(),
            "pos_bone":"shinR",
            "rot_bone":"shinR",
            "bend_bone":"shinR",
            "control_bone":"shinR",
            "side":"right",
            "angles":[315,45,180],
            "stack_group":"skirt_legR"
         });
         _skin.add_skin_piece({
            "name":"skirt_shin_maskR",
            "type":"skirt_shin_mask",
            "clip":new Sprite(),
            "pos_bone":"shinR",
            "rot_bone":"shinR",
            "bend_bone":"shinR",
            "control_bone":"shinR",
            "side":"right",
            "angles":[315,45,180],
            "stack_group":"skirt_legR"
         });
         _skin.add_skin_piece({
            "name":"skirt_mask_AR",
            "type":"skirt_mask",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_1",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"skirt_legR"
         });
         _skin.add_skin_piece({
            "name":"skirt_mask_BR",
            "type":"skirt_mask",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"spine_1",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"skirt_legR"
         });
         _skin.add_skin_piece({
            "name":"skirt_base_thighL",
            "type":"skirt_base",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"thighL",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"skirt"
         });
         _skin.add_skin_piece({
            "name":"skirt_base_shinL",
            "type":"skirt_base",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"shinL",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"skirt"
         });
         _skin.add_skin_piece({
            "name":"skirt_base_thighR",
            "type":"skirt_base",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"thighR",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"skirt"
         });
         _skin.add_skin_piece({
            "name":"skirt_base_shinR",
            "type":"skirt_base",
            "clip":new Sprite(),
            "pos_bone":"spine_1",
            "rot_bone":"spine_1",
            "bend_bone":"spine_2",
            "control_bone":"shinR",
            "side":"center",
            "angles":[336,24,180],
            "stack_group":"skirt"
         });
         stack_groups = {
            "bicepL":["bicepL","shoulderAL","shoulderBL"],
            "bicepR":["bicepR","shoulderAR","shoulderBR"],
            "foreL":["foreL","handL","cuffL","hand_topL","cuff_topL"],
            "foreR":["foreR","handR","cuffR","hand_topR","cuff_topR"],
            "legL":["thighL","hipAL","hipBL","shinL","footL","shin_topL","foot_topL"],
            "legR":["thighR","hipAR","hipBR","shinR","footR","shin_topR","foot_topR"],
            "torso":["torso_nude","pelvis","pelvis_patch"],
            "shirtfront":["shirtfront"],
            "shirt":["neck","tucked","torso_top","untucked"],
            "breasts":["breasts"],
            "head":["head"],
            "head_back":["head_back"],
            "accfront":["accfront"],
            "accback":["accback"],
            "breasts_top":["breasts_top"],
            "skirt":["skirt_base","skirt_base_thighL","skirt_base_shinL","skirt_base_thighR","skirt_base_shinR"],
            "skirt_pelvis":["skirt_pelvis"],
            "skirt_legL":["skirt_thigh_OLL","skirt_shin_OLL","skirt_mask_AL","skirt_mask_BL","skirt_thigh_maskL","skirt_shin_maskL"],
            "skirt_legR":["skirt_thigh_OLR","skirt_shin_OLR","skirt_mask_AR","skirt_mask_BR","skirt_thigh_maskR","skirt_shin_maskR"],
            "control_zone":["control_zone"]
         };
         if(_head.head_back)
         {
            _head.head_back.y = _head.head_back.y + _head.head_adjustment;
         }
         _head.used_back = true;
         _skin.add_skin_layer("head",_head);
         if(_head.head_back)
         {
            _skin.add_skin_layer("head_back",_head.head_back);
         }
         if(tmp_clothes.length == 1 && ArtLoader.exclusive_clothing.indexOf(tmp_clothes[0]) != -1)
         {
            trace("Exclusive!");
         }
         else
         {
            this.add_clothing("bare");
         }
         _skin.render();
         if(_interface)
         {
            _interface.render();
            addChild(_interface);
         }
         _controller.init();
         this.addEventListener(SkeletonEvent.CHAR_ROT_CHANGE,this.manage_hands_handler,false,0,true);
         this.addEventListener(SkeletonEvent.CHAR_HEIGHT_CHANGE,this.manage_hands_handler,false,0,true);
         this.addEventListener(SkeletonEvent.CHAR_TYPE_CHANGE,this.manage_hands_handler,false,0,true);
         this.addEventListener(SkeletonEvent.CHAR_SEX_CHANGE,this.manage_hands_handler,false,0,true);
         body_height = _body_height;
         if(tmp_clothes)
         {
            for each(_loc8_ in tmp_clothes)
            {
               this.add_clothing(_loc8_);
            }
         }
         update_offset_positions();
         addChild(this.skirt_mask);
         _skin.get_skin_piece("skirt_base").clip.mask = this.skirt_mask;
         _skin.get_skin_piece("skirt_mask_BL").clip.width = _skin.get_skin_piece("skirt_mask_BL").clip.width - 3;
         _skin.get_skin_piece("skirt_mask_BL").clip.height = _skin.get_skin_piece("skirt_mask_BL").clip.height - 3;
         _skin.get_skin_piece("skirt_mask_BR").clip.width = _skin.get_skin_piece("skirt_mask_BR").clip.width - 3;
         _skin.get_skin_piece("skirt_mask_BR").clip.height = _skin.get_skin_piece("skirt_mask_BR").clip.height - 3;
         _skin.get_skin_piece("skirt_thigh_OLL").clip.mask = _skin.get_skin_piece("skirt_mask_AL").clip;
         _skin.get_skin_piece("skirt_shin_OLL").clip.mask = _skin.get_skin_piece("skirt_mask_BL").clip;
         _skin.get_skin_piece("skirt_thigh_OLR").clip.mask = _skin.get_skin_piece("skirt_mask_AR").clip;
         _skin.get_skin_piece("skirt_shin_OLR").clip.mask = _skin.get_skin_piece("skirt_mask_BR").clip;
         _skin.get_skin_piece("skirt_base_thighL").clip.mask = _skin.get_skin_piece("skirt_thigh_maskL").clip;
         _skin.get_skin_piece("skirt_base_shinL").clip.mask = _skin.get_skin_piece("skirt_shin_maskL").clip;
         _skin.get_skin_piece("skirt_base_thighR").clip.mask = _skin.get_skin_piece("skirt_thigh_maskR").clip;
         _skin.get_skin_piece("skirt_base_shinR").clip.mask = _skin.get_skin_piece("skirt_shin_maskR").clip;
         (bone_lookup["head"] as Bone).addEventListener(SkeletonEvent.BONE_ROT_CHANGE,this.do_head_tilt,false,0,true);
         this.stance = 1;
      }
      
      override public function set pose(param1:Pose) : void
      {
         super.pose = param1;
      }
      
      override protected function assume_pose(param1:Pose) : void
      {
         super.assume_pose(param1);
         this.manage_hands();
      }
      
      override public function update_bone_positions() : void
      {
         this.setup_spine();
         this.setup_neck();
         this.align_neck();
         this.setup_arms();
         this.align_arms();
         this.setup_legs();
         this.align_legs();
         super.update_bone_positions();
         this.align_head();
      }
      
      public function setup_spine() : void
      {
         var _loc1_:Object = get_structure("spine");
         _loc1_.bones[0].set_position(new Point(_loc1_.position[0],_loc1_.position[1]),_loc1_.starting_rot);
      }
      
      public function setup_neck() : void
      {
         var _loc1_:Object = get_structure("neck");
         _loc1_.bones[0].set_position(new Point(_loc1_.position[0],_loc1_.position[1]),_loc1_.starting_rot);
      }
      
      public function setup_arms() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.arms.length)
         {
            this.arms[_loc1_].bones[0].set_position(new Point(0,0),this.arms[_loc1_].starting_rot);
            _loc1_++;
         }
      }
      
      public function setup_legs() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.legs.length)
         {
            this.legs[_loc1_].bones[0].set_position(new Point(0,0),this.legs[_loc1_].starting_rot);
            _loc1_++;
         }
      }
      
      public function align_neck() : void
      {
         var _loc1_:Object = get_structure("spine");
         var _loc2_:Object = get_structure("neck");
         var _loc3_:Point = _loc1_.bones[1].get_end_point();
         var _loc4_:Number = _loc1_.bones[1].rotation - _loc1_.starting_rot;
         var _loc5_:Point = new Point(_loc2_.position[0],_loc2_.position[1]);
         m.identity();
         m.rotate(_loc4_ * Math.PI / 180);
         m.translate(_loc3_.x,_loc3_.y);
         _loc5_ = m.transformPoint(_loc5_);
         _loc2_.bones[0].set_position(_loc5_,_loc4_ + _loc2_.starting_rot);
      }
      
      public function align_arms() : void
      {
         var _loc1_:Object = null;
         var _loc5_:Point = null;
         var _loc2_:Object = get_structure("spine");
         var _loc3_:Point = _loc2_.bones[1].get_end_point();
         var _loc4_:Number = _loc2_.bones[1].rotation - _loc2_.starting_rot;
         var _loc6_:uint = 0;
         while(_loc6_ < this.arms.length)
         {
            _loc1_ = this.arms[_loc6_];
            _loc5_ = new Point(_loc1_.position[0],_loc1_.position[1]);
            m.identity();
            m.rotate(_loc4_ * Math.PI / 180);
            m.translate(_loc3_.x,_loc3_.y);
            _loc5_ = m.transformPoint(_loc5_);
            _loc1_.bones[0].set_position(_loc5_,_loc4_ + this.arms[_loc6_].starting_rot);
            _loc6_++;
         }
      }
      
      public function align_legs() : void
      {
         var _loc1_:Object = null;
         var _loc5_:Point = null;
         var _loc2_:Object = get_structure("spine");
         var _loc3_:Point = _loc2_.bones[0].get_position();
         var _loc4_:Number = _loc2_.bones[0].rotation - _loc2_.starting_rot;
         var _loc6_:uint = 0;
         while(_loc6_ < this.legs.length)
         {
            _loc1_ = this.legs[_loc6_];
            _loc5_ = new Point(_loc1_.position[0],_loc1_.position[1]);
            m.identity();
            m.rotate(_loc4_ * Math.PI / 180);
            m.translate(_loc3_.x,_loc3_.y);
            _loc5_ = m.transformPoint(_loc5_);
            _loc1_.bones[0].set_position(_loc5_,_loc4_ + this.legs[_loc6_].starting_rot);
            _loc6_++;
         }
      }
      
      public function align_head() : void
      {
         if(_head)
         {
            _head.y = _head.head_adjustment;
         }
      }
      
      public function do_head_tilt(param1:Event) : void
      {
         dispatchEvent(new Event("head tilt"));
      }
      
      public function set head_angle(param1:Number) : void
      {
         if(_flipped)
         {
            param1 = param1 * -1;
         }
         var _loc2_:Bone = Bone(bone_lookup["head"]);
         _loc2_.internal_rotation = param1;
         _loc2_.update = true;
      }
      
      public function get head_angle() : Number
      {
         var _loc1_:Bone = Bone(bone_lookup["head"]);
         var _loc2_:Number = _loc1_.internal_rotation;
         if(_flipped)
         {
            _loc2_ = Utils.degrees(_loc2_ * -1);
         }
         return _loc2_;
      }
      
      override public function add_clothing(param1:String, param2:Boolean = false) : void
      {
         super.add_clothing(param1);
         this.manage_hands();
      }
      
      override public function remove_clothing(param1:String) : void
      {
         super.remove_clothing(param1);
         this.manage_hands();
      }
      
      public function manage_hands_handler(param1:Event) : void
      {
         this.manage_hands();
      }
      
      public function manage_hands() : void
      {
         var _loc5_:uint = 0;
         if(!skin.get_skin_piece("handL"))
         {
            return;
         }
         if(!skin.get_skin_piece("handL").clip)
         {
            return;
         }
         _skin.update_side_flip();
         var _loc1_:Object = skin.get_skin_piece("handL");
         var _loc2_:Object = skin.get_skin_piece("handR");
         var _loc3_:Object = skin.get_skin_piece("hand_topL");
         var _loc4_:Object = skin.get_skin_piece("hand_topR");
         if(_loc1_ == null || _loc2_ == null)
         {
            return;
         }
         if(_pose.hand_flip && _pose.hand_flip[body_rotation][0])
         {
            _loc1_.clip.scaleX = _loc1_.clip.scaleX * -1;
         }
         if(_pose.hand_flip && _pose.hand_flip[body_rotation][1])
         {
            _loc2_.clip.scaleX = _loc2_.clip.scaleX * -1;
         }
         _loc3_.clip.scaleX = _loc1_.clip.scaleX;
         _loc4_.clip.scaleX = _loc2_.clip.scaleX;
         var _loc6_:uint = 1;
         var _loc7_:uint = 1;
         if(_pose.hand_rotate)
         {
            _loc6_ = _pose.hand_rotate[body_rotation][0] * 10 + _pose.hand_pose[0];
            _loc7_ = _pose.hand_rotate[body_rotation][1] * 10 + _pose.hand_pose[1];
         }
         _loc5_ = 0;
         while(_loc5_ < _loc1_.clip.numChildren)
         {
            _loc1_.clip.getChildAt(_loc5_).gotoAndStop(_loc6_);
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc3_.clip.numChildren)
         {
            _loc3_.clip.getChildAt(_loc5_).gotoAndStop(_loc6_);
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc2_.clip.numChildren)
         {
            _loc2_.clip.getChildAt(_loc5_).gotoAndStop(_loc7_);
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < _loc4_.clip.numChildren)
         {
            _loc4_.clip.getChildAt(_loc5_).gotoAndStop(_loc7_);
            _loc5_++;
         }
         if(Skeleton.debug)
         {
            trace("left_hand_frame: " + _loc6_);
            trace("right_hand_frame: " + _loc7_);
         }
      }
      
      public function get_hand_info() : Array
      {
         return [{
            "rot":_pose.hand_rotate[body_rotation][0],
            "frame":_pose.hand_pose[0]
         },{
            "rot":_pose.hand_rotate[body_rotation][1],
            "frame":_pose.hand_pose[1]
         }];
      }
      
      public function set_hand(param1:uint, param2:uint, param3:uint) : uint
      {
         _pose.set_hand(param1,param2,param3,body_rotation);
         this.manage_hands();
         return param1;
      }
      
      public function get hands() : Array
      {
         return this._hands;
      }
      
      override public function reset_bones() : void
      {
         super.reset_bones();
         this.manage_hands();
      }
      
      override public function save_state() : Object
      {
         var _loc2_:Array = null;
         var _loc3_:Bone = null;
         var _loc4_:uint = 0;
         var _loc1_:Object = {
            "head":_head.save_state(),
            "mode":this._mode,
            "gesture":this._gesture,
            "stance":this._stance,
            "action":this._action,
            "master_rotation":_master_rotation,
            "head_angle":this.head_angle
         };
         if(this._mode == 3)
         {
            _loc1_["pose"] = _pose.save_state();
            _loc2_ = ["thighL","shinL","footL"];
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = bone_lookup[_loc2_[_loc4_]] as Bone;
               if(_loc3_.flipped)
               {
                  _loc1_["pose"]["angles"][_loc2_[_loc4_]] = Utils.degrees(360 - _loc3_.internal_rotation);
               }
               _loc4_++;
            }
         }
         _loc1_["hand_info"] = this.get_hand_info();
         return _loc1_;
      }
      
      override public function load_state(param1:Object) : void
      {
         _head.load_state(param1.head);
         if(param1.hasOwnProperty("mode"))
         {
            this._mode = param1.mode;
            if(param1.mode == 3)
            {
               this.pose = new Pose(param1.pose,this.pose_defaults);
            }
            else if(param1.mode == 2)
            {
               this.action = param1.action;
            }
            else
            {
               this.gesture = param1.gesture;
               this.stance = param1.stance;
            }
         }
         else if(param1.hasOwnProperty("sitting"))
         {
            if(param1.standing)
            {
               this._mode = 0;
            }
            else if(param1.sitting)
            {
               this._mode = 1;
            }
            else if(param1.action)
            {
               this._mode = 2;
            }
            if(this._mode == 2)
            {
               this.action = param1.pose;
            }
            else
            {
               if(this._mode == 1)
               {
                  this.stance = 1;
               }
               else
               {
                  if(param1.body_rotation >= 5)
                  {
                     if(param1.stance % 3 == 0)
                     {
                        param1.stance = param1.stance + 2;
                     }
                     else if(param1.stance % 3 == 2)
                     {
                        param1.stance = param1.stance - 2;
                     }
                  }
                  this.stance = param1.stance;
               }
               this.gesture = param1.gesture;
            }
            param1["hand_info"] = [{},{}];
            param1["hand_info"][0]["rot"] = Math.floor(param1["hands"][0] / 10);
            param1["hand_info"][1]["rot"] = Math.floor(param1["hands"][1] / 10);
            param1["hand_info"][0]["frame"] = param1["hands"][0] % 10;
            param1["hand_info"][1]["frame"] = param1["hands"][1] % 10;
         }
         if(param1.master_rotation)
         {
            set_rotation(param1.master_rotation);
         }
         else
         {
            set_rotation(param1.body_rotation);
         }
         if(param1.hasOwnProperty("hand_info"))
         {
            this.set_hand(0,param1["hand_info"][0]["rot"],param1["hand_info"][0]["frame"]);
            this.set_hand(1,param1["hand_info"][1]["rot"],param1["hand_info"][1]["frame"]);
         }
         this.head_angle = param1.head_angle;
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_["body_type"] = this._body_type;
         _loc1_["body_height"] = this._body_height;
         _loc1_["breast_type"] = this.breast_type;
         _loc1_["sex"] = this.sex;
         _loc1_["clothes"] = clothes;
         return _loc1_;
      }
      
      public function clear_listeners() : void
      {
      }
      
      public function dodat() : BitmapData
      {
         return new BitmapData(10,10);
      }
      
      public function get mode() : uint
      {
         return this._mode;
      }
      
      public function set mode(param1:uint) : void
      {
         if(this._mode == param1)
         {
            return;
         }
         var _loc2_:Boolean = false;
         if(this._mode == 2 || this._mode == 3)
         {
            _loc2_ = true;
         }
         this._mode = param1;
         if(this._mode == 0 || this._mode == 1)
         {
            if(_loc2_)
            {
               this.gesture = this._gesture;
            }
            this.stance = 1;
         }
         else if(this._mode == 2)
         {
            this.action = this._action;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get simple() : Boolean
      {
         return false;
      }
      
      public function set gesture(param1:uint) : void
      {
         this._gesture = param1;
         var _loc2_:Object = CharLoader.pose_data;
         trace("GESTURE NAME: " + "g" + param1);
         var _loc3_:Object = _loc2_["gesture"]["g" + this._gesture];
         if(!_loc3_)
         {
            _loc3_ = {
               "name":"g" + this._gesture,
               "type":PoseType.GESTURE
            };
         }
         this.pose = new Pose(_loc3_,this.pose_defaults);
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get gesture() : uint
      {
         return this._gesture;
      }
      
      public function set_breast(param1:uint) : uint
      {
         breast_type = param1;
         return breast_type;
      }
      
      public function set_height(param1:uint) : uint
      {
         body_height = param1;
         return body_height;
      }
      
      public function get action() : uint
      {
         return this._action;
      }
      
      public function set action(param1:uint) : void
      {
         var _loc4_:Pose = null;
         this._action = param1;
         if(this._mode != 2)
         {
            return;
         }
         var _loc2_:Object = CharLoader.pose_data;
         trace("POSE NAME: " + "p" + this._action);
         var _loc3_:Object = _loc2_["action"]["p" + this._action];
         if(!_loc3_)
         {
            _loc3_ = {
               "name":"p" + this._action,
               "type":PoseType.ACTION
            };
         }
         _loc4_ = new Pose(_loc3_,this.pose_defaults);
         this.pose = _loc4_;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function stance_up() : void
      {
         if(this._stance >= 3)
         {
            this.stance = this.stance - 3;
         }
      }
      
      public function stance_down() : void
      {
         if(this._stance <= 5)
         {
            this.stance = this.stance + 3;
         }
      }
      
      public function stance_left() : void
      {
         if(flipped)
         {
            if(this._stance % 3 != 2)
            {
               this.stance = this.stance + 1;
            }
         }
         else if(this._stance % 3 != 0)
         {
            this.stance = this.stance - 1;
         }
      }
      
      public function stance_right() : void
      {
         if(flipped)
         {
            if(this._stance % 3 != 0)
            {
               this.stance = this.stance - 1;
            }
         }
         else if(this._stance % 3 != 2)
         {
            this.stance = this.stance + 1;
         }
      }
      
      public function set stance(param1:uint) : void
      {
         var _loc5_:Pose = null;
         this._stance = Math.min(9,Math.max(0,param1));
         var _loc2_:Object = CharLoader.pose_data;
         var _loc3_:String = "m" + this._mode + "s" + this._stance;
         trace("STANCE NAME: " + _loc3_);
         var _loc4_:Object = _loc2_["stance"][_loc3_];
         if(!_loc4_)
         {
            _loc4_ = {
               "name":"s" + this._stance,
               "type":PoseType.STANCE
            };
         }
         _loc5_ = new Pose(_loc4_,this.pose_defaults);
         this.pose = _loc5_;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function get stance() : uint
      {
         return this._stance;
      }
      
      private function flip_leg(param1:Event) : void
      {
         trace("FLIP LEG");
         var _loc2_:Bone = this.get_bone("thighL");
         var _loc3_:Bone = this.get_bone("shinL");
         var _loc4_:Bone = this.get_bone("footL");
         if(_loc3_ && _loc2_ && _loc4_)
         {
            _loc2_.flip();
            _loc3_.flip();
            _loc4_.flip();
         }
      }
      
      private function manage_skirt_handler(param1:Event) : void
      {
         this.manage_skirt();
      }
      
      private function manage_skirt() : void
      {
         var _loc1_:Point = null;
         var _loc3_:Sprite = null;
         var _loc4_:uint = 0;
         var _loc19_:uint = 0;
         if(!is_wearing("skirt"))
         {
            return;
         }
         var _loc2_:Array = [this.skirt_mask];
         this.addChild(this.skirt_mask_test);
         this.skirt_mask_test.mouseChildren = false;
         this.skirt_mask_test.mouseEnabled = false;
         var _loc5_:Matrix = new Matrix();
         _loc1_ = get_bone("spine_1").get_position();
         _loc5_.translate(0 - _loc1_.x,0 - _loc1_.y);
         _loc5_.rotate((360 - get_bone("spine_1").internal_rotation) * Math.PI / 180);
         var _loc6_:Matrix = _loc5_.clone();
         _loc6_.invert();
         var _loc7_:Point = _loc5_.transformPoint(get_bone("thighL").get_position());
         var _loc8_:Point = _loc5_.transformPoint(get_bone("shinL").get_position());
         var _loc9_:Point = _loc5_.transformPoint(get_bone("footL").get_position());
         var _loc10_:Point = _loc5_.transformPoint(get_bone("thighR").get_position());
         var _loc11_:Point = _loc5_.transformPoint(get_bone("shinR").get_position());
         var _loc12_:Point = _loc5_.transformPoint(get_bone("footR").get_position());
         if(is_wearing("skirt02"))
         {
            _loc9_ = _loc5_.transformPoint(get_bone("shinL").get_position());
            _loc12_ = _loc5_.transformPoint(get_bone("shinR").get_position());
         }
         if(is_wearing("skirt03"))
         {
            _loc9_ = _loc5_.transformPoint(get_bone("footL").get_proto_point(40,0));
            _loc12_ = _loc5_.transformPoint(get_bone("footR").get_proto_point(40,0));
         }
         var _loc13_:Array = [_loc7_,_loc8_,_loc9_];
         var _loc14_:Array = [_loc12_,_loc11_,_loc10_];
         var _loc15_:Array = new Array().concat(_loc13_);
         var _loc16_:Number = Utils.get_degrees_from_points(new Point(),_loc9_);
         var _loc17_:Number = Utils.get_degrees_from_points(new Point(),_loc12_);
         if(_loc17_ > _loc16_)
         {
            _loc17_ = 0;
         }
         var _loc18_:Number = _loc16_;
         while(_loc18_ > _loc17_)
         {
            _loc18_ = _loc18_ - 5;
            _loc15_.push(Utils.project_point(new Point(),100,_loc18_));
         }
         _loc15_ = _loc15_.concat(_loc14_);
         _loc4_ = 0;
         while(_loc4_ < _loc15_.length)
         {
            _loc15_[_loc4_] = _loc6_.transformPoint(_loc15_[_loc4_]);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = Sprite(_loc2_[_loc4_]);
            _loc3_.graphics.clear();
            if(Skeleton.debug)
            {
               _loc3_.graphics.beginFill(16711935,0.5);
            }
            else
            {
               _loc3_.graphics.beginFill(16711935,0);
            }
            _loc3_.graphics.moveTo(_loc15_[0].x,_loc15_[0].y);
            _loc19_ = 1;
            while(_loc19_ < _loc15_.length)
            {
               _loc3_.graphics.lineTo(_loc15_[_loc19_].x,_loc15_[_loc19_].y);
               if(_loc4_ == 2)
               {
               }
               _loc19_++;
            }
            switch(_master_rotation)
            {
               case 5:
               case 6:
               case 7:
                  _loc3_.scaleX = -1;
                  break;
               default:
                  _loc3_.scaleX = 1;
            }
            _loc4_++;
         }
      }
      
      override protected function clothing_special_rules() : void
      {
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc1_:Boolean = true;
         if(is_wearing("pants") || is_wearing("skirt"))
         {
            _loc1_ = false;
         }
         show_shoulder_patches = true;
         if(is_wearing("jacket"))
         {
            show_shoulder_patches = false;
         }
         if(is_wearing("skirt"))
         {
            get_bone("thighR").limits = [-90,80];
            get_bone("thighL").limits = [-80,90];
            this.update_bone_positions();
         }
         else
         {
            get_bone("thighR").limits = null;
            get_bone("thighL").limits = null;
         }
         var _loc2_:Object = skin.get_skin_piece("shirtfront").clip;
         if(is_wearing("strap01"))
         {
            _loc2_ = skin.get_skin_piece("shirtfront").clip;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.numChildren)
            {
               _loc3_ = _loc2_.getChildAt(_loc4_);
               if(_loc3_.name == "shirtfront_strap01")
               {
                  if(is_wearing("sweater") || is_wearing("jacket"))
                  {
                     _loc3_.visible = true;
                  }
                  else
                  {
                     _loc3_.visible = false;
                  }
               }
               _loc4_++;
            }
         }
         skin.get_skin_piece("handL").clip.visible = !is_wearing("glove");
         skin.get_skin_piece("handR").clip.visible = !is_wearing("glove");
         _skin.get_skin_piece("tucked").clip.visible = _loc1_;
         _skin.get_skin_piece("shoulderAL").clip.visible = show_shoulder_patches;
         _skin.get_skin_piece("shoulderBL").clip.visible = show_shoulder_patches;
         _skin.get_skin_piece("shoulderAR").clip.visible = show_shoulder_patches;
         _skin.get_skin_piece("shoulderBR").clip.visible = show_shoulder_patches;
         var _loc6_:Array = _skin.get_skin_pieces();
         _loc4_ = 0;
         while(_loc4_ < _loc6_.length)
         {
            if(_loc2_ != _skin.get_skin_piece("head"))
            {
               _loc2_ = _loc6_[_loc4_].clip;
               _loc5_ = 0;
               while(_loc5_ < _loc2_.numChildren)
               {
                  _loc3_ = _loc2_.getChildAt(_loc5_);
                  if(_loc3_.name.indexOf("bare") != -1)
                  {
                     _loc3_.visible = !is_wearing("stickman");
                  }
                  _loc5_++;
               }
            }
            _loc4_++;
         }
      }
      
      private function combined_gesture_stance(param1:Pose, param2:Pose, param3:String) : Pose
      {
         var _loc4_:Object = new Object();
         _loc4_.name = param3;
         _loc4_.type = PoseType.COMBO;
         _loc4_.angles = this.combined_gesture_stance_angles(param1.angles,param2.angles);
         _loc4_.adjustments = this.combined_gesture_stance_adjustments(param1.adjustments,param2.adjustments);
         _loc4_.skin_stack = Utils.clone(param1.skin_stack);
         _loc4_.hand_pose = Utils.clone(param1.hand_pose);
         _loc4_.hand_rotate = Utils.clone(param1.hand_rotate);
         _loc4_.float = param2.float;
         return new Pose(_loc4_,this.pose_defaults);
      }
      
      private function combined_gesture_stance_angles(param1:Object, param2:Object) : Object
      {
         var a_gesture:Object = param1;
         var a_stance:Object = param2;
         var angles:Object = Utils.clone(a_stance);
         try
         {
            if(a_gesture.hasOwnProperty("bicepL"))
            {
               angles.bicepL = a_gesture.bicepL;
            }
            if(a_gesture.hasOwnProperty("foreL"))
            {
               angles.foreL = a_gesture.foreL;
            }
            if(a_gesture.hasOwnProperty("handL"))
            {
               angles.handL = a_gesture.handL;
            }
            if(a_gesture.hasOwnProperty("bicepR"))
            {
               angles.bicepR = a_gesture.bicepR;
            }
            if(a_gesture.hasOwnProperty("foreR"))
            {
               angles.foreR = a_gesture.foreR;
            }
            if(a_gesture.hasOwnProperty("handR"))
            {
               angles.handR = a_gesture.handR;
            }
         }
         catch(err:Error)
         {
            trace("ERROR: gesture does not have correct angles");
         }
         return angles;
      }
      
      private function combined_gesture_stance_adjustments(param1:Object, param2:Object) : Object
      {
         var _loc5_:* = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc3_:Object = this.filter_adjustment(Utils.clone(param2),PoseType.STANCE);
         var _loc4_:Object = this.filter_adjustment(Utils.clone(param1),PoseType.GESTURE);
         for(_loc5_ in _loc4_)
         {
            if(_loc5_.indexOf("rotation_") != -1)
            {
               if(_loc3_.hasOwnProperty(_loc5_))
               {
                  if(_loc3_[_loc5_].hasOwnProperty("adj") && _loc4_[_loc5_].hasOwnProperty("adj"))
                  {
                     _loc3_[_loc5_].adj = this.combined_gesture_stance_adjustment_objects(_loc4_[_loc5_].adj,_loc3_[_loc5_].adj);
                  }
                  for(_loc6_ in _loc4_[_loc5_])
                  {
                     if(_loc6_.indexOf("height_") != -1)
                     {
                        if(_loc3_[_loc5_].hasOwnProperty(_loc6_))
                        {
                           if(_loc3_[_loc5_][_loc6_].hasOwnProperty("adj") && _loc4_[_loc5_][_loc6_].hasOwnProperty("adj"))
                           {
                              _loc3_[_loc5_][_loc6_].adj = this.combined_gesture_stance_adjustment_objects(_loc4_[_loc5_][_loc6_].adj,_loc3_[_loc5_][_loc6_].adj);
                           }
                           for(_loc7_ in _loc4_[_loc5_][_loc6_])
                           {
                              if(_loc7_.indexOf("type_") != -1)
                              {
                                 if(_loc3_[_loc5_][_loc6_].hasOwnProperty(_loc7_))
                                 {
                                    if(_loc3_[_loc5_][_loc6_][_loc7_].hasOwnProperty("adj") && _loc4_[_loc5_][_loc6_][_loc7_].hasOwnProperty("adj"))
                                    {
                                       _loc3_[_loc5_][_loc6_][_loc7_].adj = this.combined_gesture_stance_adjustment_objects(_loc4_[_loc5_][_loc6_][_loc7_].adj,_loc3_[_loc5_][_loc6_][_loc7_].adj);
                                    }
                                 }
                                 else
                                 {
                                    _loc3_[_loc5_][_loc6_][_loc7_] = _loc4_[_loc5_][_loc6_][_loc7_];
                                    if(_loc4_[_loc5_][_loc6_][_loc7_].hasOwnProperty("adj"))
                                    {
                                       _loc3_[_loc5_][_loc6_][_loc7_].adj = this.combined_gesture_stance_adjustment_objects(_loc4_[_loc5_][_loc6_][_loc7_].adj,new Object());
                                    }
                                 }
                              }
                           }
                        }
                        else
                        {
                           _loc3_[_loc5_][_loc6_] = _loc4_[_loc5_][_loc6_];
                           if(_loc4_[_loc5_][_loc6_].hasOwnProperty("adj"))
                           {
                              _loc3_[_loc5_][_loc6_].adj = this.combined_gesture_stance_adjustment_objects(_loc4_[_loc5_][_loc6_].adj,new Object());
                           }
                        }
                     }
                  }
               }
               else
               {
                  _loc3_[_loc5_] = _loc4_[_loc5_];
                  if(_loc4_[_loc5_].hasOwnProperty("adj"))
                  {
                     _loc3_[_loc5_].adj = this.combined_gesture_stance_adjustment_objects(_loc4_[_loc5_].adj,new Object());
                  }
               }
            }
         }
         return _loc3_;
      }
      
      private function combined_gesture_stance_adjustment_objects(param1:Object, param2:Object) : Object
      {
         var a_gesture:Object = param1;
         var a_stance:Object = param2;
         var adj:Object = Utils.clone(a_stance);
         try
         {
            if(a_gesture.hasOwnProperty("bicepL"))
            {
               adj.bicepL = a_gesture.bicepL;
            }
            if(a_gesture.hasOwnProperty("foreL"))
            {
               adj.foreL = a_gesture.foreL;
            }
            if(a_gesture.hasOwnProperty("handL"))
            {
               adj.handL = a_gesture.handL;
            }
            if(a_gesture.hasOwnProperty("bicepR"))
            {
               adj.bicepR = a_gesture.bicepR;
            }
            if(a_gesture.hasOwnProperty("foreR"))
            {
               adj.foreR = a_gesture.foreR;
            }
            if(a_gesture.hasOwnProperty("handR"))
            {
               adj.handR = a_gesture.handR;
            }
         }
         catch(err:Error)
         {
            trace("ERROR: gesture does not have correct adjustment values");
         }
         return adj;
      }
      
      private function filter_adjustment(param1:Object, param2:String) : Object
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         if(param2 != PoseType.GESTURE && param2 != PoseType.STANCE)
         {
            return param1;
         }
         for(_loc3_ in param1)
         {
            if(_loc3_.indexOf("rotation") != -1)
            {
               param1[_loc3_] = this.filter_adjustment_property(param1[_loc3_],param2);
            }
            for(_loc4_ in param1[_loc3_])
            {
               if(_loc4_.indexOf("height") != -1)
               {
                  param1[_loc3_][_loc4_] = this.filter_adjustment_property(param1[_loc3_][_loc4_],param2);
               }
               for(_loc5_ in param1[_loc3_][_loc4_])
               {
                  if(_loc5_.indexOf("type") != -1)
                  {
                     param1[_loc3_][_loc4_][_loc5_] = this.filter_adjustment_property(param1[_loc3_][_loc4_][_loc5_],param2);
                  }
               }
            }
         }
         return param1;
      }
      
      private function filter_adjustment_property(param1:Object, param2:String) : Object
      {
         var _loc3_:* = null;
         var _loc4_:Array = ["bicepL","foreL","handL","bicepR","foreR","handR"];
         if(param1.hasOwnProperty("adj"))
         {
            for(_loc3_ in param1["adj"])
            {
               if(param2 == PoseType.GESTURE)
               {
                  if(_loc4_.indexOf(_loc3_) == -1)
                  {
                     delete param1["adj"][_loc3_];
                  }
               }
               else if(param2 == PoseType.STANCE)
               {
                  if(_loc4_.indexOf(_loc3_) != -1)
                  {
                     delete param1["adj"][_loc3_];
                  }
               }
            }
         }
         if(param1.hasOwnProperty("float"))
         {
            if(param2 == PoseType.GESTURE)
            {
               delete param1["float"];
            }
         }
         return param1;
      }
      
      override protected function configure_incoming_pose(param1:Pose) : Pose
      {
         switch(_pose.type)
         {
            case PoseType.NONE:
            case PoseType.ACTION:
               switch(param1.type)
               {
                  case PoseType.NONE:
                     param1 = new Pose(CharLoader.pose_data["action"]["default"],this.pose_defaults);
                     break;
                  case PoseType.GESTURE:
                     param1 = this.combined_gesture_stance(param1,new Pose(CharLoader.pose_data["action"]["default"],this.pose_defaults),param1.name);
                     break;
                  case PoseType.STANCE:
                     param1 = this.combined_gesture_stance(new Pose(CharLoader.pose_data["action"]["default"],this.pose_defaults),param1,param1.name);
                     break;
                  case PoseType.ACTION:
                     param1 = param1;
               }
               break;
            case PoseType.COMBO:
               switch(param1.type)
               {
                  case PoseType.NONE:
                     param1 = new Pose(CharLoader.pose_data["action"]["default"],this.pose_defaults);
                     break;
                  case PoseType.GESTURE:
                     param1 = this.combined_gesture_stance(param1,_pose,param1.name);
                     break;
                  case PoseType.STANCE:
                     param1 = this.combined_gesture_stance(_pose,param1,param1.name);
                     break;
                  case PoseType.ACTION:
                     param1 = param1;
               }
         }
         return param1;
      }
      
      public function simple_bone_up_report(param1:String) : Boolean
      {
         var _loc6_:int = 0;
         switch(param1)
         {
            case "bicepL":
            case "bicepR":
            case "foreL":
            case "foreR":
            case "legL":
            case "legR":
               var _loc2_:Array = _pose.default_skin_stack;
               var _loc3_:Array = Utils.clone(_loc2_[_body_rotation]) as Array;
               var _loc4_:int = _loc3_.indexOf(param1);
               var _loc5_:String = _pose.simple_stack_top[_body_rotation][param1];
               if(_loc5_ == "top")
               {
                  _loc6_ = _loc3_.length - 1;
               }
               else
               {
                  _loc6_ = _loc3_.indexOf(_loc5_) - 1;
               }
               if(_loc6_ > _loc4_)
               {
                  return true;
               }
               return false;
            default:
               return false;
         }
      }
      
      public function simple_bone_up(param1:String) : Boolean
      {
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         switch(param1)
         {
            case "bicepL":
            case "bicepR":
            case "foreL":
            case "foreR":
            case "legL":
            case "legR":
               var _loc2_:Array = _pose.default_skin_stack;
               var _loc3_:Array = Utils.clone(_loc2_[_body_rotation]) as Array;
               var _loc4_:int = _loc3_.indexOf(param1);
               var _loc5_:String = _pose.simple_stack_top[_body_rotation][param1];
               if(_loc5_ == "top")
               {
                  _loc6_ = _loc3_.length - 1;
               }
               else
               {
                  _loc6_ = _loc3_.indexOf(_loc5_) - 1;
               }
               if(_loc6_ > _loc4_)
               {
                  _loc7_ = _loc3_.splice(_loc4_,1);
                  if(Skeleton.debug)
                  {
                     trace("stack_list before: " + _loc3_);
                  }
                  _loc3_ = _loc3_.slice(0,_loc6_).concat(_loc7_).concat(_loc3_.slice(_loc6_));
                  if(Skeleton.debug)
                  {
                     trace("stack_list after: " + _loc3_);
                  }
                  _loc2_[body_rotation] = _loc3_;
                  _pose.skin_stack = _loc2_;
                  _skin.restack(_loc3_);
                  switch(param1)
                  {
                     case "bicepL":
                        this.simple_bone_up("foreL");
                        break;
                     case "bicepR":
                        this.simple_bone_up("foreR");
                  }
                  if(body_rotation == 3 && _skin.getChildIndex(_skin.get_skin_piece("bicepR").clip) < _skin.getChildIndex(_skin.get_skin_piece("control_zone").clip))
                  {
                     if(param1 == "foreR")
                     {
                        this.simple_bone_up("bicepR");
                     }
                  }
                  manage_head_rotation();
                  return true;
               }
               return false;
            default:
               return false;
         }
      }
      
      public function simple_bone_down_report(param1:String) : Boolean
      {
         var _loc6_:int = 0;
         switch(param1)
         {
            case "bicepL":
            case "bicepR":
            case "foreL":
            case "foreR":
            case "legL":
            case "legR":
               var _loc2_:Array = _pose.default_skin_stack;
               var _loc3_:Array = Utils.clone(_loc2_[_body_rotation]) as Array;
               var _loc4_:int = _loc3_.indexOf(param1);
               var _loc5_:String = _pose.simple_stack_bottom[_body_rotation][param1];
               if(_loc5_ == "bottom")
               {
                  _loc6_ = 0;
               }
               else
               {
                  _loc6_ = _loc3_.indexOf(_loc5_) + 1;
               }
               if(_loc6_ < _loc4_)
               {
                  return true;
               }
               return false;
            default:
               return false;
         }
      }
      
      public function simple_bone_down(param1:String) : Boolean
      {
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         switch(param1)
         {
            case "bicepL":
            case "bicepR":
            case "legL":
            case "legR":
               break;
            case "foreL":
               this.simple_bone_down("bicepL");
               break;
            case "foreR":
               this.simple_bone_down("bicepR");
               break;
            default:
               return false;
         }
         var _loc2_:Array = _pose.default_skin_stack;
         var _loc3_:Array = Utils.clone(_loc2_[_body_rotation]) as Array;
         var _loc4_:int = _loc3_.indexOf(param1);
         var _loc5_:String = _pose.simple_stack_bottom[_body_rotation][param1];
         if(_loc5_ == "bottom")
         {
            _loc6_ = 0;
         }
         else
         {
            _loc6_ = _loc3_.indexOf(_loc5_) + 1;
         }
         if(_loc6_ < _loc4_)
         {
            if(Skeleton.debug)
            {
               trace("stack_list before: " + _loc3_);
            }
            _loc7_ = _loc3_.splice(_loc4_,1);
            _loc3_ = _loc3_.slice(0,_loc6_).concat(_loc7_).concat(_loc3_.slice(_loc6_));
            if(Skeleton.debug)
            {
               trace("stack_list after: " + _loc3_);
            }
            _loc2_[body_rotation] = _loc3_;
            _pose.skin_stack = _loc2_;
            _skin.restack(_loc3_);
            manage_head_rotation();
            return true;
         }
         return false;
      }
      
      public function simple_stack_report() : Object
      {
         var _loc1_:String = null;
         if(_skin && _skin.selected_skin_piece)
         {
            _loc1_ = _skin.selected_skin_piece.stack_group;
            return {
               "up":this.simple_bone_up_report(_loc1_),
               "down":this.simple_bone_down_report(_loc1_)
            };
         }
         return {
            "up":false,
            "down":false
         };
      }
      
      override public function get pose_defaults() : Object
      {
         return SkeletonBiped.pose_defaults;
      }
      
      override public function set head(param1:HeadBase) : void
      {
         super.head = param1;
         _head.head_back.y = _head.head_back.y + _head.head_adjustment;
         _head.used_back = true;
         (_skin.get_skin_piece("head").clip as Sprite).removeChildAt(0);
         (_skin.get_skin_piece("head_back").clip as Sprite).removeChildAt(0);
         _skin.add_skin_layer("head",_head);
         _skin.add_skin_layer("head_back",_head.head_back);
         this.align_head();
      }
      
      public function get features() : Array
      {
         return new Array();
      }
   }
}
