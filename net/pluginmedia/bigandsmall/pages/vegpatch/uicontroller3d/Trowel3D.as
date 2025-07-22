package net.pluginmedia.bigandsmall.pages.vegpatch.uicontroller3d
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import net.pluginmedia.brain.core.animation.UIAnimation;
   import net.pluginmedia.brain.core.animation.events.AnimationEvent;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   
   public class Trowel3D extends PointSprite
   {
      
      public static var DONE_DIGGING:String = "Trowel3D.DONE_DIGGING";
      
      private var trowelUIAnim:UIAnimation;
      
      public var isDigging:Boolean = false;
      
      private var pSpriteMat:SpriteParticleMaterial = new SpriteParticleMaterial(trowelUIAnim);
      
      public function Trowel3D(param1:MovieClip, param2:Number = 0.7)
      {
         trowelUIAnim = new UIAnimation(param1);
         super(pSpriteMat,param2);
      }
      
      public function removeSelf() : void
      {
         this.visible = false;
         pSpriteMat.removeSprite();
      }
      
      public function doDig() : void
      {
         isDigging = true;
         trowelUIAnim.playLabel("digging",0);
         trowelUIAnim.addEventListener(AnimationEvent.COMPLETE,handleAnimComplete);
      }
      
      private function handleAnimComplete(param1:AnimationEvent) : void
      {
         dispatchEvent(new Event(DONE_DIGGING));
      }
      
      public function dragMode() : void
      {
         removeSelf();
      }
      
      public function readyDig() : void
      {
         this.visible = true;
      }
   }
}

