package net.pluginmedia.pv3d
{
   import flash.geom.Rectangle;
   import net.pluginmedia.pv3d.materials.special.SpriteParticleMaterial;
   import org.papervision3d.core.culling.IObjectCuller;
   import org.papervision3d.core.geom.renderables.Particle;
   import org.papervision3d.core.geom.renderables.Vertex3DInstance;
   import org.papervision3d.core.render.command.RenderParticle;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.materials.special.ParticleMaterial;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class PointSprite extends DisplayObject3D
   {
      
      public var particle:Particle;
      
      private var renderCommand:RenderParticle;
      
      protected var _particleMaterial:ParticleMaterial;
      
      public function PointSprite(param1:ParticleMaterial, param2:Number = 0.7)
      {
         super();
         particleMaterial = param1;
         particle = new Particle(param1,param2);
         particle.instance = this;
         autoCalcScreenCoords = true;
         renderCommand = new RenderParticle(particle);
      }
      
      public function get size() : Number
      {
         return particle.size;
      }
      
      public function set size(param1:Number) : void
      {
         particle.size = param1;
      }
      
      public function get particleMaterial() : ParticleMaterial
      {
         return _particleMaterial;
      }
      
      public function get renderScale() : Number
      {
         return particle.renderScale;
      }
      
      override public function project(param1:DisplayObject3D, param2:RenderSessionData) : Number
      {
         var _loc5_:Number = NaN;
         super.project(param1,param2);
         var _loc3_:Rectangle = param2.camera.viewport;
         var _loc4_:Vertex3DInstance = particle.vertex3D.vertex3DInstance;
         _loc4_.x = screen.x;
         _loc4_.y = screen.y;
         _loc4_.visible = screen.z > 0;
         renderCommand.screenZ = screen.z;
         if(param2.camera is IObjectCuller)
         {
            particle.renderScale = _loc3_.width / 2 / (x * view.n41 + y * view.n42 + z * view.n43 + view.n44);
         }
         else
         {
            _loc5_ = param2.camera.focus * param2.camera.zoom;
            particle.renderScale = _loc5_ / (param2.camera.focus + screen.z);
         }
         particle.updateRenderRect();
         if(param2.viewPort.particleCuller.testParticle(particle))
         {
            param2.renderer.addToRenderList(this.renderCommand);
         }
         else if(material is SpriteParticleMaterial)
         {
            SpriteParticleMaterial(material).removeSprite();
         }
         return this.screenZ = screen.z;
      }
      
      public function set particleMaterial(param1:ParticleMaterial) : void
      {
         var _loc2_:ParticleMaterial = _particleMaterial;
         _particleMaterial = param1;
         material = _particleMaterial;
         if(particle)
         {
            particle.material = _particleMaterial;
         }
         if(_loc2_ is SpriteParticleMaterial)
         {
            SpriteParticleMaterial(_loc2_).removeSprite();
         }
      }
   }
}

