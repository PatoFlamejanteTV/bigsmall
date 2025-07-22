package org.papervision3d.objects.special
{
   import org.papervision3d.core.geom.TriangleMesh3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   import org.papervision3d.core.render.data.RenderSessionData;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class Skin3D extends TriangleMesh3D
   {
      
      public function Skin3D(param1:MaterialObject3D, param2:Array, param3:Array, param4:String = null)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function project(param1:DisplayObject3D, param2:RenderSessionData) : Number
      {
         this.transform.copy(param1.world);
         this.transform.invert();
         return super.project(param1,param2);
      }
   }
}

