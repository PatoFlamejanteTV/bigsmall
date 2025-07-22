package com.as3dmod.plugins.pv3d
{
   import com.as3dmod.core.VertexProxy;
   import org.papervision3d.core.geom.renderables.Vertex3D;
   
   public class Pv3dVertex extends VertexProxy
   {
      
      private var vx:Vertex3D;
      
      public function Pv3dVertex()
      {
         super();
      }
      
      override public function set x(param1:Number) : void
      {
         vx.x = param1;
      }
      
      override public function set y(param1:Number) : void
      {
         vx.y = param1;
      }
      
      override public function setVertex(param1:*) : void
      {
         vx = param1 as Vertex3D;
         ox = vx.x;
         oy = vx.y;
         oz = vx.z;
      }
      
      override public function get x() : Number
      {
         return vx.x;
      }
      
      override public function get y() : Number
      {
         return vx.y;
      }
      
      override public function get z() : Number
      {
         return vx.z;
      }
      
      override public function set z(param1:Number) : void
      {
         vx.z = param1;
      }
   }
}

