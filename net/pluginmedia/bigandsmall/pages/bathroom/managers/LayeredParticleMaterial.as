package net.pluginmedia.bigandsmall.pages.bathroom.managers
{
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import org.papervision3d.core.geom.renderables.Particle;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.materials.special.BitmapParticleMaterial;
   import org.papervision3d.materials.special.ParticleBitmap;
   
   public class LayeredParticleMaterial extends BitmapParticleMaterial
   {
      
      protected var layers:Array;
      
      protected var particleBitmaps:Array = new Array();
      
      public function LayeredParticleMaterial(param1:MovieClip, param2:Number = 1)
      {
         var _loc3_:int = 1;
         while(_loc3_ <= param1.totalFrames)
         {
            param1.gotoAndStop(_loc3_);
            particleBitmaps.push(new ParticleBitmap(param1,param2));
            _loc3_++;
         }
         super(particleBitmaps[0]);
      }
      
      override public function drawParticle(param1:Particle, param2:Graphics, param3:RenderSessionData) : void
      {
         var _loc5_:Graphics = null;
         var _loc4_:int = 0;
         while(_loc4_ < particleBitmaps.length)
         {
            particleBitmap = particleBitmaps[_loc4_];
            if(layers[_loc4_])
            {
               _loc5_ = layers[_loc4_].graphics;
               super.drawParticle(param1,_loc5_,param3);
            }
            _loc4_++;
         }
         particleBitmap = particleBitmaps[0];
      }
      
      public function setLayers(param1:Array) : void
      {
         layers = param1;
      }
   }
}

