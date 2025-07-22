package net.pluginmedia.pv3d.materials.special
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.geom.Rectangle;
   import org.papervision3d.core.geom.renderables.Particle;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.math.util.FastRectangleTools;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.core.render.draw.IParticleDrawer;
   import org.papervision3d.core.render.material.IUpdateAfterMaterial;
   import org.papervision3d.core.render.material.IUpdateBeforeMaterial;
   import org.papervision3d.materials.special.ParticleMaterial;
   import org.papervision3d.view.layer.ViewportLayer;
   
   public class SpriteParticleMaterial extends ParticleMaterial implements IParticleDrawer, IUpdateBeforeMaterial, IUpdateAfterMaterial
   {
      
      public var maxSize:int = 1000;
      
      protected var spriteRect:Rectangle;
      
      public var _movie:DisplayObject;
      
      protected var renderRect:Rectangle;
      
      public function SpriteParticleMaterial(param1:DisplayObject)
      {
         super(0,0);
         if(param1)
         {
            _movie = param1;
         }
         renderRect = new Rectangle();
      }
      
      public function set movie(param1:DisplayObject) : void
      {
         var _loc2_:int = 0;
         if(_movie == param1)
         {
            return;
         }
         if(_movie.parent)
         {
            _loc2_ = _movie.parent.getChildIndex(_movie);
            param1.transform = _movie.transform;
            _movie.parent.addChild(param1);
            _movie.parent.removeChild(_movie);
         }
         _movie = param1;
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      override public function updateRenderRect(param1:Particle) : void
      {
         spriteRect = movie.getBounds(movie);
         var _loc2_:Number = param1.renderScale * param1.size;
         var _loc3_:Rectangle = param1.renderRect;
         if(_loc2_ < 0)
         {
            _loc2_ = -_loc2_;
         }
         if(movie.scaleX < 0)
         {
            movie.scaleX = -_loc2_;
         }
         else
         {
            movie.scaleX = _loc2_;
         }
         if(movie.scaleY < 0)
         {
            movie.scaleY = -_loc2_;
         }
         else
         {
            movie.scaleY = _loc2_;
         }
         _loc3_.width = movie.width;
         _loc3_.height = movie.height;
         var _loc4_:Vertex3DInstance = param1.vertex3D.vertex3DInstance;
         _loc3_.x = _loc4_.x + spriteRect.left * _loc2_;
         _loc3_.y = _loc4_.y + spriteRect.top * _loc2_;
      }
      
      public function removeSprite() : void
      {
         if(movie)
         {
            if(movie.parent)
            {
               movie.parent.removeChild(movie);
            }
         }
      }
      
      public function get movie() : DisplayObject
      {
         return _movie;
      }
      
      public function updateAfterRender(param1:RenderSessionData) : void
      {
      }
      
      override public function drawParticle(param1:Particle, param2:Graphics, param3:RenderSessionData) : void
      {
         var _loc4_:Rectangle = param3.viewPort.cullingRectangle;
         FastRectangleTools.intersection(_loc4_,param1.renderRect,renderRect);
         var _loc5_:ViewportLayer = param1.instance.container;
         if(!_loc5_)
         {
            _loc5_ = param3.viewPort.getChildLayer(param1.instance,true);
         }
         if(movie.parent != _loc5_)
         {
            if(movie.parent)
            {
               movie.parent.removeChild(movie);
            }
            _loc5_.addChild(movie);
         }
         var _loc6_:Vertex3DInstance = param1.vertex3D.vertex3DInstance;
         movie.x = _loc6_.x;
         movie.y = _loc6_.y;
         ++param3.renderStatistics.particles;
      }
      
      public function updateBeforeRender(param1:RenderSessionData) : void
      {
      }
   }
}

