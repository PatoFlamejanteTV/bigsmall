package org.papervision3d.objects.primitives
{
   import org.papervision3d.core.geom.TriangleMesh3D;
   import org.papervision3d.core.geom.renderables.Triangle3D;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   import org.papervision3d.core.proto.MaterialObject3D;
   
   public class PaperPlane extends TriangleMesh3D
   {
      
      public static var DEFAULT_SCALE:Number = 1;
      
      public function PaperPlane(param1:MaterialObject3D = null, param2:Number = 0)
      {
         super(param1,new Array(),new Array(),null);
         param2 ||= DEFAULT_SCALE;
         buildPaperPlane(param2);
      }
      
      private function buildPaperPlane(param1:Number) : void
      {
         var _loc2_:Number = 100 * param1;
         var _loc3_:Number = _loc2_ / 2;
         var _loc4_:Number = _loc3_ / 3;
         var _loc5_:Array = [new Vertex3D(0,0,_loc2_),new Vertex3D(-_loc3_,_loc4_,-_loc2_),new Vertex3D(-_loc4_,_loc4_,-_loc2_),new Vertex3D(0,-_loc4_,-_loc2_),new Vertex3D(_loc4_,_loc4_,-_loc2_),new Vertex3D(_loc3_,_loc4_,-_loc2_)];
         this.geometry.vertices = _loc5_;
         this.geometry.faces = [new Triangle3D(this,[_loc5_[0],_loc5_[1],_loc5_[2]]),new Triangle3D(this,[_loc5_[0],_loc5_[2],_loc5_[3]]),new Triangle3D(this,[_loc5_[0],_loc5_[3],_loc5_[4]]),new Triangle3D(this,[_loc5_[0],_loc5_[4],_loc5_[5]])];
         this.projectTexture("x","z");
         this.geometry.ready = true;
      }
   }
}

