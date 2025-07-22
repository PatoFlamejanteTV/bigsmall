package net.pluginmedia.bigandsmall.pages.bathroom
{
   import flash.display.MovieClip;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.bigandsmall.definitions.CharacterDefinitions;
   import net.pluginmedia.bigandsmall.events.AnimationOldEvent;
   import net.pluginmedia.brain.managers.SoundManagerOld;
   import org.papervision3d.materials.MovieMaterial;
   import org.papervision3d.objects.primitives.Plane;
   
   public class ToothBrushHolder extends Plane
   {
      
      private var mat:MovieMaterial;
      
      private var shaking:Boolean = false;
      
      private var currentAnim:AnimationOld;
      
      private var bigClip:MovieClip;
      
      private var bigAnim:AnimationOld;
      
      private var smallClip:MovieClip;
      
      private var smallAnim:AnimationOld = new AnimationOld(smallClip);
      
      private var currentPOV:String;
      
      public function ToothBrushHolder(param1:MovieClip, param2:MovieClip, param3:Number = 0, param4:Number = 0, param5:Number = 1)
      {
         bigClip = param1;
         smallClip = param2;
         bigAnim = new AnimationOld(param1);
         var _loc6_:Number = param1.width * param5;
         var _loc7_:Number = param1.height * param5;
         currentAnim = bigAnim;
         mat = new MovieMaterial(currentAnim,true,false,true);
         super(mat,_loc6_,_loc7_,param3,param4);
      }
      
      public function reset() : void
      {
         currentAnim.gotoAndStop(1);
      }
      
      public function shake(param1:Boolean = false) : void
      {
         if(!shaking)
         {
            shaking = true;
            mat.animated = true;
            currentAnim.playOutLabel("shake");
            currentAnim.addEventListener(AnimationOldEvent.COMPLETE,handleAnimComplete);
            if(param1)
            {
               SoundManagerOld.playSound("bath_toothbrushrollover_2");
            }
         }
      }
      
      private function handleAnimComplete(param1:AnimationOldEvent) : void
      {
         currentAnim.removeEventListener(AnimationOldEvent.COMPLETE,handleAnimComplete);
         shaking = false;
         mat.animated = false;
      }
      
      public function setCharacter(param1:String) : void
      {
         currentPOV = param1;
         if(shaking)
         {
            mat.animated = false;
            shaking = false;
            currentAnim.removeEventListener(AnimationOldEvent.COMPLETE,handleAnimComplete);
            currentAnim.gotoAndStop(1);
         }
         if(param1 == CharacterDefinitions.BIG)
         {
            currentAnim = bigAnim;
         }
         else if(param1 == CharacterDefinitions.SMALL)
         {
            currentAnim = smallAnim;
         }
         mat.movie = currentAnim;
         mat.drawBitmap();
      }
      
      public function get isShaking() : Boolean
      {
         return shaking;
      }
   }
}

