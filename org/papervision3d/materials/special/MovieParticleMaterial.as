package org.papervision3d.materials.special
{
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   import org.papervision3d.core.geom.renderables.Particle;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.material.IUpdateBeforeMaterial;
   
   public class MovieParticleMaterial extends BitmapParticleMaterial implements IUpdateBeforeMaterial
   {
      
      public static var bitmapLibrary:Dictionary = new Dictionary(true);
      
      public var movieTransparent:Boolean;
      
      public var animated:Boolean;
      
      public var actualSize:Boolean = false;
      
      public var movie:DisplayObject;
      
      public function MovieParticleMaterial(param1:DisplayObject, param2:Boolean = true, param3:Boolean = false)
      {
         if(param1)
         {
            movie = param1;
         }
         this.animated = param3;
         this.movieTransparent = param2;
         updateParticleBitmap();
         super(particleBitmap);
      }
      
      override public function updateRenderRect(param1:Particle) : void
      {
         if(actualSize)
         {
            updateParticleBitmap(param1.renderScale * param1.size,param1.vertex3D.vertex3DInstance.x,param1.vertex3D.vertex3DInstance.y);
         }
         else if(animated)
         {
            updateParticleBitmap(scale);
         }
         super.updateRenderRect(param1);
         if(actualSize)
         {
         }
      }
      
      public function updateBeforeRender(param1:RenderSessionData) : void
      {
      }
      
      public function updateParticleBitmap(param1:Number = 1, param2:Number = 0, param3:Number = 0) : void
      {
         if(particleBitmap)
         {
            particleBitmap.create(movie,param1);
         }
         else
         {
            particleBitmap = new ParticleBitmap(movie,param1);
         }
      }
   }
}

