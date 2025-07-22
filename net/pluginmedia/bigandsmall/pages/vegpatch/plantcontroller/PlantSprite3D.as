package net.pluginmedia.bigandsmall.pages.vegpatch.plantcontroller
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import net.pluginmedia.brain.core.animation.UIAnimation;
   import net.pluginmedia.brain.core.animation.events.AnimationEvent;
   import net.pluginmedia.pv3d.PointSprite;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.materials.special.MovieParticleMaterial;
   
   public class PlantSprite3D extends PointSprite
   {
      
      private var growthStarted:Boolean = false;
      
      private var currentGrowthPhase:int = 0;
      
      private var anim:UIAnimation;
      
      public var uprooted:Boolean = false;
      
      public var spritePartMat:SpriteParticleMaterial;
      
      private var _clip:MovieClip;
      
      private var _growing:Boolean = true;
      
      public var movPartMat:MovieParticleMaterial;
      
      public var type:String;
      
      public var growthPhases:uint = 3;
      
      public function PlantSprite3D(param1:MovieClip, param2:Number = 0.7, param3:String = null)
      {
         this.type = param3;
         _clip = param1;
         _clip.addEventListener("FruitAppear",handleFruitAppear);
         anim = new UIAnimation(_clip);
         anim.addEventListener(AnimationEvent.COMPLETE,handleAnimComplete);
         spritePartMat = new SpriteParticleMaterial(anim);
         movPartMat = new MovieParticleMaterial(anim,true,false);
         super(spritePartMat,param2);
      }
      
      public function get growing() : Boolean
      {
         if(_growing)
         {
            _growing = false;
            return true;
         }
         return uprooted;
      }
      
      private function handleFruitAppear(param1:Event) : void
      {
         dispatchEvent(new FruitAppearEvent(this));
      }
      
      public function get growthUnit() : Number
      {
         return _clip.currentFrame / _clip.totalFrames;
      }
      
      public function grow() : void
      {
         if(!_growing && _clip.currentFrame != _clip.totalFrames)
         {
            if(!growthStarted)
            {
               growthStarted = true;
            }
            _clip.nextFrame();
            _growing = true;
         }
      }
      
      private function handleAnimComplete(param1:AnimationEvent) : void
      {
         if(_growing)
         {
            _growing = false;
         }
      }
      
      public function get clip() : MovieClip
      {
         return _clip;
      }
      
      public function hitTestMovie(param1:DisplayObject) : Boolean
      {
         if(_clip.hitTestObject(param1))
         {
            return true;
         }
         return false;
      }
      
      public function activate() : void
      {
         this.particleMaterial = spritePartMat;
      }
      
      public function deactivate() : void
      {
         movPartMat.updateParticleBitmap();
         this.particleMaterial = movPartMat;
      }
      
      public function uproot() : void
      {
         _clip.removeEventListener("FruitAppear",handleFruitAppear);
         this.visible = false;
         spritePartMat.removeSprite();
      }
   }
}

