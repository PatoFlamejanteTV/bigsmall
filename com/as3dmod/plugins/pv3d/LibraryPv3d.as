package com.as3dmod.plugins.pv3d
{
   import com.as3dmod.core.MeshProxy;
   import com.as3dmod.core.VertexProxy;
   import com.as3dmod.plugins.Library3d;
   
   public class LibraryPv3d extends Library3d
   {
      
      public function LibraryPv3d()
      {
         super();
         var _loc1_:MeshProxy = new Pv3dMesh();
         var _loc2_:VertexProxy = new Pv3dVertex();
      }
      
      override public function get id() : String
      {
         return "pv3d";
      }
      
      override public function get vertexClass() : String
      {
         return "com.as3dmod.plugins.pv3d.Pv3dVertex";
      }
      
      override public function get meshClass() : String
      {
         return "com.as3dmod.plugins.pv3d.Pv3dMesh";
      }
   }
}

