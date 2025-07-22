package net.pluginmedia.bigandsmall.pages.garden.culling
{
   import flash.geom.Point;
   import org.papervision3d.core.geom.TriangleMesh3D;
   import org.papervision3d.core.math.Number3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class MeshGardenCullable extends AbstractGardenCullable
   {
      
      private var mesh:TriangleMesh3D;
      
      public function MeshGardenCullable(param1:DisplayObject3D)
      {
         super(param1);
         mesh = param1 as TriangleMesh3D;
         if(!mesh)
         {
            throw new Error(param1,"supplied is not a triangle mesh, cannot be used with MeshGardenCullable");
         }
      }
      
      override public function initCullPoints() : void
      {
         var _loc1_:Object = mesh.worldBoundingBox();
         var _loc2_:Number3D = _loc1_.min as Number3D;
         var _loc3_:Number3D = _loc1_.max as Number3D;
         cullPoints.push(new Point(_loc2_.x,_loc2_.z));
         cullPoints.push(new Point(_loc2_.x,_loc3_.z));
         cullPoints.push(new Point(_loc3_.x,_loc2_.z));
         cullPoints.push(new Point(_loc3_.x,_loc3_.z));
      }
   }
}

