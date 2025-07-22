package com.as3dmod.plugins.pv3d
{
   import com.as3dmod.core.MeshProxy;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.objects.DisplayObject3D;
   
   public class Pv3dMesh extends MeshProxy
   {
      
      private var do3d:DisplayObject3D;
      
      public function Pv3dMesh()
      {
         super();
      }
      
      override public function setMesh(param1:*) : void
      {
         var _loc5_:Pv3dVertex = null;
         do3d = param1 as DisplayObject3D;
         var _loc2_:Array = do3d.geometry.vertices;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new Pv3dVertex();
            _loc5_.setVertex(_loc2_[_loc4_] as Vertex3D);
            vertices.push(_loc5_);
            _loc4_++;
         }
      }
   }
}

