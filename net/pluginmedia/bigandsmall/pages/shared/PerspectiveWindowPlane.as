package net.pluginmedia.bigandsmall.pages.shared
{
   import flash.display.DisplayObject;
   import net.pluginmedia.pv3d.materials.WindowMaterial;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.primitives.Plane;
   
   public class PerspectiveWindowPlane extends Plane
   {
      
      public var v1:Vertex3D;
      
      public var winMat:WindowMaterial;
      
      public function PerspectiveWindowPlane(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number3D)
      {
         v1 = new Vertex3D(param4,param5,param6);
         v1.x += param8.x * param7;
         v1.y += param8.y * param7;
         v1.z += param8.z * param7;
         winMat = new WindowMaterial(param1,1);
         winMat.doubleSided = true;
         super(winMat,param2,param3);
         geometry.vertices.push(v1);
         geometry.ready = true;
         geometry.dirty = true;
         winMat.setDistanceVertex(v1);
         this.x = param4;
         this.y = param5;
         this.z = param6;
         this.rotationY = Math.atan2(param8.z,param8.x) * Number3D.toDEGREES - 90;
      }
   }
}

