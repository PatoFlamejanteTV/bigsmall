package net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller3d
{
   import flash.display.MovieClip;
   import net.pluginmedia.brain.core.animation.UIAnimation;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   
   public class WateringCan3D extends PointSprite
   {
      
      private var canUIAnim:UIAnimation;
      
      private var pSpriteMat:SpriteParticleMaterial = new SpriteParticleMaterial(canUIAnim);
      
      public var isWatering:Boolean = false;
      
      public function WateringCan3D(param1:MovieClip, param2:Number = 0.7)
      {
         canUIAnim = new UIAnimation(param1);
         super(pSpriteMat,param2);
      }
      
      public function dropped() : void
      {
         endWatering();
         removeSelf();
      }
      
      public function pickedUp() : void
      {
         this.visible = true;
      }
      
      public function beginWatering() : void
      {
         isWatering = true;
      }
      
      public function removeSelf() : void
      {
         this.visible = false;
         pSpriteMat.removeSprite();
      }
      
      public function endWatering() : void
      {
         isWatering = false;
      }
   }
}

