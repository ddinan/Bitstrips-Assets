package com.bitstrips.character.custom
{
   import com.bitstrips.character.IHead;
   import com.bitstrips.character.PPData;
   import com.bitstrips.core.ColourData;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class HeadStick extends HeadCustom implements IHead
   {
       
      
      public function HeadStick(param1:PPData = undefined, param2:ColourData = undefined)
      {
         art_clip_name = "custom_head_stick";
         super(param1,param2);
      }
      
      override protected function refresh_head_bits(param1:Event) : void
      {
         super.refresh_head_bits(param1);
         if(clip["jaw"])
         {
            piece_dict["jaw"] = clip["jaw"];
            piece_dict["mouth"].mask = piece_dict["jaw"];
         }
         else
         {
            piece_dict["jaw"] = new MovieClip();
         }
      }
      
      override public function set_expression_mouth(param1:uint) : void
      {
         if(piece_dict["mouth"])
         {
            (piece_dict["mouth"] as MovieClip).gotoAndStop(param1);
         }
         lipsync = lipsync;
      }
   }
}
