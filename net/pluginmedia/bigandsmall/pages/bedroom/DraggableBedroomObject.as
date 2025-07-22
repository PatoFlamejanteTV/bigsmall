package net.pluginmedia.bigandsmall.pages.bedroom
{
   import flash.display.MovieClip;
   import net.pluginmedia.bigandsmall.core.animation.AnimationOld;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   
   public class DraggableBedroomObject extends PointSprite
   {
      
      private var _animation:AnimationOld;
      
      private var _material:SpriteParticleMaterial;
      
      private var _flyingLength:uint;
      
      private var _clip:MovieClip;
      
      public function DraggableBedroomObject(param1:MovieClip)
      {
         _animation = new AnimationOld(param1);
         _material = new SpriteParticleMaterial(param1);
         super(_material);
         _flyingLength = _animation.getLengthOfLabel("fly and hit");
      }
      
      public function drop() : void
      {
         _animation.gotoAndStop("start");
      }
      
      public function setVisible(param1:Boolean) : void
      {
         this.visible = param1;
         if(!param1)
         {
            _material.removeSprite();
         }
      }
      
      public function get spriteMaterial() : SpriteParticleMaterial
      {
         return _material;
      }
      
      public function pickUp() : void
      {
         _animation.gotoAndStop("pickup");
      }
   }
}

