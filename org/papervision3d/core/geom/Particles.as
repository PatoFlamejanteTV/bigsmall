package org.papervision3d.core.geom
{
   import flash.geom.Rectangle;
   import org.papervision3d.core.culling.IObjectCuller;
   import org.papervision3d.core.geom.renderables.Particle;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class Particles extends Vertices3D
   {
      
      private static var _newID:int = 0;
      
      private var vertices:Array;
      
      public var particles:Array;
      
      public function Particles(param1:String = "Particles")
      {
         param1 += _newID++;
         this.vertices = new Array();
         this.particles = new Array();
         super(vertices,param1);
      }
      
      public function removeParticle(param1:Particle) : void
      {
         param1.instance = null;
         particles.splice(particles.indexOf(param1,0),1);
         vertices.splice(vertices.indexOf(param1.vertex3D,0),1);
      }
      
      public function addParticle(param1:Particle) : void
      {
         param1.instance = this;
         particles.push(param1);
         vertices.push(param1.vertex3D);
      }
      
      override public function project(param1:DisplayObject3D, param2:RenderSessionData) : Number
      {
         var _loc4_:Particle = null;
         var _loc5_:Vertex3D = null;
         var _loc6_:Number = NaN;
         super.project(param1,param2);
         var _loc3_:Rectangle = param2.camera.viewport;
         if(this.culled)
         {
            return 0;
         }
         for each(_loc4_ in particles)
         {
            if(param2.camera is IObjectCuller)
            {
               _loc5_ = _loc4_.vertex3D;
               _loc4_.renderScale = _loc3_.width / 2 / (_loc5_.x * view.n41 + _loc5_.y * view.n42 + _loc5_.z * view.n43 + view.n44);
            }
            else
            {
               _loc6_ = param2.camera.focus * param2.camera.zoom;
               _loc4_.renderScale = _loc6_ / (param2.camera.focus + _loc4_.vertex3D.vertex3DInstance.z);
            }
            _loc4_.updateRenderRect();
            if(param2.viewPort.particleCuller.testParticle(_loc4_))
            {
               _loc4_.renderCommand.screenZ = _loc4_.vertex3D.vertex3DInstance.z;
               param2.renderer.addToRenderList(_loc4_.renderCommand);
            }
            else
            {
               ++param2.renderStatistics.culledParticles;
            }
         }
         return 1;
      }
      
      public function removeAllParticles() : void
      {
         particles = new Array();
         vertices = new Array();
         geometry.vertices = vertices;
      }
   }
}

